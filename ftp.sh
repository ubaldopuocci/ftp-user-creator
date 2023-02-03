if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
if [[ "$1" == "" ]]; then
    echo "No username given, exiting"
    exit 1
fi
username="$1";
if [[ "$2" == "" ]]; then
    echo "No password given, exiting"
    exit 1
fi
password="$2";
echo "Adding new FTP account for $username...";
adduser $username;
echo "Added user, changing password..."
echo "$username:$password"|chpasswd;
echo "Password changed"
echo "Managing directory permissions..."
chown $username:$username /home/$username -R;
chown $username:$username /ftp/roots/$username;
chmod 770 /ftp/roots/$username;
"$username" >> /etc/vsftpd.userlist;
"local_root=/ftp/roots/$username" >> /ftp/user_config_dir/$username;
"write_enable=YES" >> /ftp/user_config_dir/$username;

echo "$username created with password $password."
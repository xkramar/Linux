#version=RockyLinux9

# Use CDROM installation media
cdrom
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
repo --name="AppStream" --baseurl=file:///run/install/repo/AppStream

# Root password
rootpw $2b$10$....
# System timezone
timezone Europe/Bratislava --utc --nontp
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --all --initlabel --drives=sda

# Disk partitioning information
part /boot --fstype="ext4" --ondisk=sda --size=1024 --label=boot
part swap --fstype="swap" --ondisk=sdb --size=4096
part pv.01 --fstype="ext4" --ondisk=sda --size=1024 --grow
part pv.02 --fstype="ext4" --ondisk=sdb --size=1024 --grow

volgroup rootvg --pesize=4096 pv.01
volgroup datavg --pesize=4096 pv.02

logvol / --fstype="ext4" --size=1024 --name=root --vgname=rootvg
logvol /tmp --fstype="ext4" --size=1024 --name=tmp --vgname=rootvg
logvol /home --fstype="ext4" --size=1024 --name=home --vgname=rootvg
logvol /usr --fstype="ext4" --size=1024 --name=usr --vgname=rootvg
logvol /opt --fstype="ext4" --size=1024 --name=opt --vgname=rootvg
logvol /var --fstype="ext4" --size=1024 --name=var --vgname=rootvg
logvol /var/log --fstype="ext4" --size=1024 --name=var_log --vgname=rootvg
logvol /var/log/audit --fstype="ext4" --size=1024 --name=var_log_audit --vgname=rootvg
logvol /data --fstype="ext4" --size=1024 --name=data --vgname=datavg

%post
echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/01-permitrootlogin.conf
%end

%packages
@core
kexec-tools
chrony
wget
net-tools
%end

%addon
com_redhat_kdump --enable --reserve_mb="auto"
%end

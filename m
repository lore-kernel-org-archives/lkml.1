Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYDGT7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYDGT7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYDGT7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:59:15 -0400
Received: from mail.fieldses.org ([66.93.2.214]:53365 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYDGT7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:59:13 -0400
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Jon Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH] Documentation: move nfsroot.txt to filesystems/
Date: Mon,  7 Apr 2008 15:59:03 -0400
Message-Id: <1207598345-14295-2-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207598345-14295-1-git-send-email-bfields@citi.umich.edu>
References: <1207598345-14295-1-git-send-email-bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/ is a little large, and filesystems/ seems an obvious
place for this file.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 Documentation/00-INDEX                |    2 -
 Documentation/filesystems/00-INDEX    |    2 +
 Documentation/filesystems/nfsroot.txt |  270 +++++++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt   |    6 +-
 Documentation/nfsroot.txt             |  270 ---------------------------------
 fs/Kconfig                            |    8 +-
 net/ipv4/Kconfig                      |    8 +-
 net/ipv4/ipconfig.c                   |    2 +-
 8 files changed, 284 insertions(+), 284 deletions(-)
 create mode 100644 Documentation/filesystems/nfsroot.txt
 delete mode 100644 Documentation/nfsroot.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index fc8e7c7..08a39cd 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -271,8 +271,6 @@ netlabel/
 	- directory with information on the NetLabel subsystem.
 networking/
 	- directory with info on various aspects of networking with Linux.
-nfsroot.txt
-	- short guide on setting up a diskless box with NFS root filesystem.
 nmi_watchdog.txt
 	- info on NMI watchdog for SMP systems.
 nommu-mmap.txt
diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index e68021c..b1b523b 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -66,6 +66,8 @@ mandatory-locking.txt
 	- info on the Linux implementation of Sys V mandatory file locking.
 ncpfs.txt
 	- info on Novell Netware(tm) filesystem using NCP protocol.
+nfsroot.txt
+	- short guide on setting up a diskless box with NFS root filesystem.
 ntfs.txt
 	- info and mount options for the NTFS filesystem (Windows NT).
 ocfs2.txt
diff --git a/Documentation/filesystems/nfsroot.txt b/Documentation/filesystems/nfsroot.txt
new file mode 100644
index 0000000..31b3291
--- /dev/null
+++ b/Documentation/filesystems/nfsroot.txt
@@ -0,0 +1,270 @@
+Mounting the root filesystem via NFS (nfsroot)
+===============================================
+
+Written 1996 by Gero Kuhlmann <gero@gkminix.han.de>
+Updated 1997 by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+Updated 2006 by Nico Schottelius <nico-kernel-nfsroot@schottelius.org>
+Updated 2006 by Horms <horms@verge.net.au>
+
+
+
+In order to use a diskless system, such as an X-terminal or printer server
+for example, it is necessary for the root filesystem to be present on a
+non-disk device. This may be an initramfs (see Documentation/filesystems/
+ramfs-rootfs-initramfs.txt), a ramdisk (see Documentation/initrd.txt) or a
+filesystem mounted via NFS. The following text describes on how to use NFS
+for the root filesystem. For the rest of this text 'client' means the
+diskless system, and 'server' means the NFS server.
+
+
+
+
+1.) Enabling nfsroot capabilities
+    -----------------------------
+
+In order to use nfsroot, NFS client support needs to be selected as
+built-in during configuration. Once this has been selected, the nfsroot
+option will become available, which should also be selected.
+
+In the networking options, kernel level autoconfiguration can be selected,
+along with the types of autoconfiguration to support. Selecting all of
+DHCP, BOOTP and RARP is safe.
+
+
+
+
+2.) Kernel command line
+    -------------------
+
+When the kernel has been loaded by a boot loader (see below) it needs to be
+told what root fs device to use. And in the case of nfsroot, where to find
+both the server and the name of the directory on the server to mount as root.
+This can be established using the following kernel command line parameters:
+
+
+root=/dev/nfs
+
+  This is necessary to enable the pseudo-NFS-device. Note that it's not a
+  real device but just a synonym to tell the kernel to use NFS instead of
+  a real device.
+
+
+nfsroot=[<server-ip>:]<root-dir>[,<nfs-options>]
+
+  If the `nfsroot' parameter is NOT given on the command line,
+  the default "/tftpboot/%s" will be used.
+
+  <server-ip>	Specifies the IP address of the NFS server.
+		The default address is determined by the `ip' parameter
+		(see below). This parameter allows the use of different
+		servers for IP autoconfiguration and NFS.
+
+  <root-dir>	Name of the directory on the server to mount as root.
+		If there is a "%s" token in the string, it will be
+		replaced by the ASCII-representation of the client's
+		IP address.
+
+  <nfs-options>	Standard NFS options. All options are separated by commas.
+		The following defaults are used:
+			port		= as given by server portmap daemon
+			rsize		= 4096
+			wsize		= 4096
+			timeo		= 7
+			retrans		= 3
+			acregmin	= 3
+			acregmax	= 60
+			acdirmin	= 30
+			acdirmax	= 60
+			flags		= hard, nointr, noposix, cto, ac
+
+
+ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
+
+  This parameter tells the kernel how to configure IP addresses of devices
+  and also how to set up the IP routing table. It was originally called
+  `nfsaddrs', but now the boot-time IP configuration works independently of
+  NFS, so it was renamed to `ip' and the old name remained as an alias for
+  compatibility reasons.
+
+  If this parameter is missing from the kernel command line, all fields are
+  assumed to be empty, and the defaults mentioned below apply. In general
+  this means that the kernel tries to configure everything using
+  autoconfiguration.
+
+  The <autoconf> parameter can appear alone as the value to the `ip'
+  parameter (without all the ':' characters before).  If the value is
+  "ip=off" or "ip=none", no autoconfiguration will take place, otherwise
+  autoconfiguration will take place.  The most common way to use this
+  is "ip=dhcp".
+
+  <client-ip>	IP address of the client.
+
+  		Default:  Determined using autoconfiguration.
+
+  <server-ip>	IP address of the NFS server. If RARP is used to determine
+		the client address and this parameter is NOT empty only
+		replies from the specified server are accepted.
+
+		Only required for for NFS root. That is autoconfiguration
+		will not be triggered if it is missing and NFS root is not
+		in operation.
+
+		Default: Determined using autoconfiguration.
+		         The address of the autoconfiguration server is used.
+
+  <gw-ip>	IP address of a gateway if the server is on a different subnet.
+
+		Default: Determined using autoconfiguration.
+
+  <netmask>	Netmask for local network interface. If unspecified
+		the netmask is derived from the client IP address assuming
+		classful addressing.
+
+		Default:  Determined using autoconfiguration.
+
+  <hostname>	Name of the client. May be supplied by autoconfiguration,
+  		but its absence will not trigger autoconfiguration.
+
+  		Default: Client IP address is used in ASCII notation.
+
+  <device>	Name of network device to use.
+
+		Default: If the host only has one device, it is used.
+			 Otherwise the device is determined using
+			 autoconfiguration. This is done by sending
+			 autoconfiguration requests out of all devices,
+			 and using the device that received the first reply.
+
+  <autoconf>	Method to use for autoconfiguration. In the case of options
+                which specify multiple autoconfiguration protocols,
+		requests are sent using all protocols, and the first one
+		to reply is used.
+
+		Only autoconfiguration protocols that have been compiled
+		into the kernel will be used, regardless of the value of
+		this option.
+
+                  off or none: don't use autoconfiguration
+				(do static IP assignment instead)
+		  on or any:   use any protocol available in the kernel
+			       (default)
+		  dhcp:        use DHCP
+		  bootp:       use BOOTP
+		  rarp:        use RARP
+		  both:        use both BOOTP and RARP but not DHCP
+		               (old option kept for backwards compatibility)
+
+                Default: any
+
+
+
+
+3.) Boot Loader
+    ----------
+
+To get the kernel into memory different approaches can be used.
+They depend on various facilities being available:
+
+
+3.1)  Booting from a floppy using syslinux
+
+	When building kernels, an easy way to create a boot floppy that uses
+	syslinux is to use the zdisk or bzdisk make targets which use
+      	and bzimage images respectively. Both targets accept the
+     	FDARGS parameter which can be used to set the kernel command line.
+
+	e.g.
+	   make bzdisk FDARGS="root=/dev/nfs"
+
+   	Note that the user running this command will need to have
+     	access to the floppy drive device, /dev/fd0
+
+     	For more information on syslinux, including how to create bootdisks
+     	for prebuilt kernels, see http://syslinux.zytor.com/
+
+	N.B: Previously it was possible to write a kernel directly to
+	     a floppy using dd, configure the boot device using rdev, and
+	     boot using the resulting floppy. Linux no longer supports this
+	     method of booting.
+
+3.2) Booting from a cdrom using isolinux
+
+     	When building kernels, an easy way to create a bootable cdrom that
+     	uses isolinux is to use the isoimage target which uses a bzimage
+     	image. Like zdisk and bzdisk, this target accepts the FDARGS
+     	parameter which can be used to set the kernel command line.
+
+	e.g.
+	  make isoimage FDARGS="root=/dev/nfs"
+
+     	The resulting iso image will be arch/<ARCH>/boot/image.iso
+     	This can be written to a cdrom using a variety of tools including
+     	cdrecord.
+
+	e.g.
+	  cdrecord dev=ATAPI:1,0,0 arch/i386/boot/image.iso
+
+     	For more information on isolinux, including how to create bootdisks
+     	for prebuilt kernels, see http://syslinux.zytor.com/
+
+3.2) Using LILO
+	When using LILO all the necessary command line parameters may be
+	specified using the 'append=' directive in the LILO configuration
+	file.
+
+	However, to use the 'root=' directive you also need to create
+	a dummy root device, which may be removed after LILO is run.
+
+	mknod /dev/boot255 c 0 255
+
+	For information on configuring LILO, please refer to its documentation.
+
+3.3) Using GRUB
+	When using GRUB, kernel parameter are simply appended after the kernel
+	specification: kernel <kernel> <parameters>
+
+3.4) Using loadlin
+	loadlin may be used to boot Linux from a DOS command prompt without
+	requiring a local hard disk to mount as root. This has not been
+	thoroughly tested by the authors of this document, but in general
+	it should be possible configure the kernel command line similarly
+	to the configuration of LILO.
+
+	Please refer to the loadlin documentation for further information.
+
+3.5) Using a boot ROM
+	This is probably the most elegant way of booting a diskless client.
+	With a boot ROM the kernel is loaded using the TFTP protocol. The
+	authors of this document are not aware of any no commercial boot
+	ROMs that support booting Linux over the network. However, there
+	are two free implementations of a boot ROM, netboot-nfs and
+	etherboot, both of which are available on sunsite.unc.edu, and both
+	of which contain everything you need to boot a diskless Linux client.
+
+3.6) Using pxelinux
+	Pxelinux may be used to boot linux using the PXE boot loader
+	which is present on many modern network cards.
+
+	When using pxelinux, the kernel image is specified using
+	"kernel <relative-path-below /tftpboot>". The nfsroot parameters
+	are passed to the kernel by adding them to the "append" line.
+	It is common to use serial console in conjunction with pxeliunx,
+	see Documentation/serial-console.txt for more information.
+
+	For more information on isolinux, including how to create bootdisks
+	for prebuilt kernels, see http://syslinux.zytor.com/
+
+
+
+
+4.) Credits
+    -------
+
+  The nfsroot code in the kernel and the RARP support have been written
+  by Gero Kuhlmann <gero@gkminix.han.de>.
+
+  The rest of the IP layer autoconfiguration code has been written
+  by Martin Mares <mj@atrey.karlin.mff.cuni.cz>.
+
+  In order to write the initial version of nfsroot I would like to thank
+  Jens-Uwe Mager <jum@anubis.han.de> for his help.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 508e2a2..57709e4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -845,7 +845,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			arch/alpha/kernel/core_marvel.c.
 
 	ip=		[IP_PNP]
-			See Documentation/nfsroot.txt.
+			See Documentation/filesystems/nfsroot.txt.
 
 	ip2=		[HW] Set IO/IRQ pairs for up to 4 IntelliPort boards
 			See comment before ip2_setup() in
@@ -1199,10 +1199,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			file if at all.
 
 	nfsaddrs=	[NFS]
-			See Documentation/nfsroot.txt.
+			See Documentation/filesystems/nfsroot.txt.
 
 	nfsroot=	[NFS] nfs root filesystem for disk-less boxes.
-			See Documentation/nfsroot.txt.
+			See Documentation/filesystems/nfsroot.txt.
 
 	nfs.callback_tcpport=
 			[NFS] set the TCP port on which the NFSv4 callback
diff --git a/Documentation/nfsroot.txt b/Documentation/nfsroot.txt
deleted file mode 100644
index 31b3291..0000000
--- a/Documentation/nfsroot.txt
+++ /dev/null
@@ -1,270 +0,0 @@
-Mounting the root filesystem via NFS (nfsroot)
-===============================================
-
-Written 1996 by Gero Kuhlmann <gero@gkminix.han.de>
-Updated 1997 by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
-Updated 2006 by Nico Schottelius <nico-kernel-nfsroot@schottelius.org>
-Updated 2006 by Horms <horms@verge.net.au>
-
-
-
-In order to use a diskless system, such as an X-terminal or printer server
-for example, it is necessary for the root filesystem to be present on a
-non-disk device. This may be an initramfs (see Documentation/filesystems/
-ramfs-rootfs-initramfs.txt), a ramdisk (see Documentation/initrd.txt) or a
-filesystem mounted via NFS. The following text describes on how to use NFS
-for the root filesystem. For the rest of this text 'client' means the
-diskless system, and 'server' means the NFS server.
-
-
-
-
-1.) Enabling nfsroot capabilities
-    -----------------------------
-
-In order to use nfsroot, NFS client support needs to be selected as
-built-in during configuration. Once this has been selected, the nfsroot
-option will become available, which should also be selected.
-
-In the networking options, kernel level autoconfiguration can be selected,
-along with the types of autoconfiguration to support. Selecting all of
-DHCP, BOOTP and RARP is safe.
-
-
-
-
-2.) Kernel command line
-    -------------------
-
-When the kernel has been loaded by a boot loader (see below) it needs to be
-told what root fs device to use. And in the case of nfsroot, where to find
-both the server and the name of the directory on the server to mount as root.
-This can be established using the following kernel command line parameters:
-
-
-root=/dev/nfs
-
-  This is necessary to enable the pseudo-NFS-device. Note that it's not a
-  real device but just a synonym to tell the kernel to use NFS instead of
-  a real device.
-
-
-nfsroot=[<server-ip>:]<root-dir>[,<nfs-options>]
-
-  If the `nfsroot' parameter is NOT given on the command line,
-  the default "/tftpboot/%s" will be used.
-
-  <server-ip>	Specifies the IP address of the NFS server.
-		The default address is determined by the `ip' parameter
-		(see below). This parameter allows the use of different
-		servers for IP autoconfiguration and NFS.
-
-  <root-dir>	Name of the directory on the server to mount as root.
-		If there is a "%s" token in the string, it will be
-		replaced by the ASCII-representation of the client's
-		IP address.
-
-  <nfs-options>	Standard NFS options. All options are separated by commas.
-		The following defaults are used:
-			port		= as given by server portmap daemon
-			rsize		= 4096
-			wsize		= 4096
-			timeo		= 7
-			retrans		= 3
-			acregmin	= 3
-			acregmax	= 60
-			acdirmin	= 30
-			acdirmax	= 60
-			flags		= hard, nointr, noposix, cto, ac
-
-
-ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
-
-  This parameter tells the kernel how to configure IP addresses of devices
-  and also how to set up the IP routing table. It was originally called
-  `nfsaddrs', but now the boot-time IP configuration works independently of
-  NFS, so it was renamed to `ip' and the old name remained as an alias for
-  compatibility reasons.
-
-  If this parameter is missing from the kernel command line, all fields are
-  assumed to be empty, and the defaults mentioned below apply. In general
-  this means that the kernel tries to configure everything using
-  autoconfiguration.
-
-  The <autoconf> parameter can appear alone as the value to the `ip'
-  parameter (without all the ':' characters before).  If the value is
-  "ip=off" or "ip=none", no autoconfiguration will take place, otherwise
-  autoconfiguration will take place.  The most common way to use this
-  is "ip=dhcp".
-
-  <client-ip>	IP address of the client.
-
-  		Default:  Determined using autoconfiguration.
-
-  <server-ip>	IP address of the NFS server. If RARP is used to determine
-		the client address and this parameter is NOT empty only
-		replies from the specified server are accepted.
-
-		Only required for for NFS root. That is autoconfiguration
-		will not be triggered if it is missing and NFS root is not
-		in operation.
-
-		Default: Determined using autoconfiguration.
-		         The address of the autoconfiguration server is used.
-
-  <gw-ip>	IP address of a gateway if the server is on a different subnet.
-
-		Default: Determined using autoconfiguration.
-
-  <netmask>	Netmask for local network interface. If unspecified
-		the netmask is derived from the client IP address assuming
-		classful addressing.
-
-		Default:  Determined using autoconfiguration.
-
-  <hostname>	Name of the client. May be supplied by autoconfiguration,
-  		but its absence will not trigger autoconfiguration.
-
-  		Default: Client IP address is used in ASCII notation.
-
-  <device>	Name of network device to use.
-
-		Default: If the host only has one device, it is used.
-			 Otherwise the device is determined using
-			 autoconfiguration. This is done by sending
-			 autoconfiguration requests out of all devices,
-			 and using the device that received the first reply.
-
-  <autoconf>	Method to use for autoconfiguration. In the case of options
-                which specify multiple autoconfiguration protocols,
-		requests are sent using all protocols, and the first one
-		to reply is used.
-
-		Only autoconfiguration protocols that have been compiled
-		into the kernel will be used, regardless of the value of
-		this option.
-
-                  off or none: don't use autoconfiguration
-				(do static IP assignment instead)
-		  on or any:   use any protocol available in the kernel
-			       (default)
-		  dhcp:        use DHCP
-		  bootp:       use BOOTP
-		  rarp:        use RARP
-		  both:        use both BOOTP and RARP but not DHCP
-		               (old option kept for backwards compatibility)
-
-                Default: any
-
-
-
-
-3.) Boot Loader
-    ----------
-
-To get the kernel into memory different approaches can be used.
-They depend on various facilities being available:
-
-
-3.1)  Booting from a floppy using syslinux
-
-	When building kernels, an easy way to create a boot floppy that uses
-	syslinux is to use the zdisk or bzdisk make targets which use
-      	and bzimage images respectively. Both targets accept the
-     	FDARGS parameter which can be used to set the kernel command line.
-
-	e.g.
-	   make bzdisk FDARGS="root=/dev/nfs"
-
-   	Note that the user running this command will need to have
-     	access to the floppy drive device, /dev/fd0
-
-     	For more information on syslinux, including how to create bootdisks
-     	for prebuilt kernels, see http://syslinux.zytor.com/
-
-	N.B: Previously it was possible to write a kernel directly to
-	     a floppy using dd, configure the boot device using rdev, and
-	     boot using the resulting floppy. Linux no longer supports this
-	     method of booting.
-
-3.2) Booting from a cdrom using isolinux
-
-     	When building kernels, an easy way to create a bootable cdrom that
-     	uses isolinux is to use the isoimage target which uses a bzimage
-     	image. Like zdisk and bzdisk, this target accepts the FDARGS
-     	parameter which can be used to set the kernel command line.
-
-	e.g.
-	  make isoimage FDARGS="root=/dev/nfs"
-
-     	The resulting iso image will be arch/<ARCH>/boot/image.iso
-     	This can be written to a cdrom using a variety of tools including
-     	cdrecord.
-
-	e.g.
-	  cdrecord dev=ATAPI:1,0,0 arch/i386/boot/image.iso
-
-     	For more information on isolinux, including how to create bootdisks
-     	for prebuilt kernels, see http://syslinux.zytor.com/
-
-3.2) Using LILO
-	When using LILO all the necessary command line parameters may be
-	specified using the 'append=' directive in the LILO configuration
-	file.
-
-	However, to use the 'root=' directive you also need to create
-	a dummy root device, which may be removed after LILO is run.
-
-	mknod /dev/boot255 c 0 255
-
-	For information on configuring LILO, please refer to its documentation.
-
-3.3) Using GRUB
-	When using GRUB, kernel parameter are simply appended after the kernel
-	specification: kernel <kernel> <parameters>
-
-3.4) Using loadlin
-	loadlin may be used to boot Linux from a DOS command prompt without
-	requiring a local hard disk to mount as root. This has not been
-	thoroughly tested by the authors of this document, but in general
-	it should be possible configure the kernel command line similarly
-	to the configuration of LILO.
-
-	Please refer to the loadlin documentation for further information.
-
-3.5) Using a boot ROM
-	This is probably the most elegant way of booting a diskless client.
-	With a boot ROM the kernel is loaded using the TFTP protocol. The
-	authors of this document are not aware of any no commercial boot
-	ROMs that support booting Linux over the network. However, there
-	are two free implementations of a boot ROM, netboot-nfs and
-	etherboot, both of which are available on sunsite.unc.edu, and both
-	of which contain everything you need to boot a diskless Linux client.
-
-3.6) Using pxelinux
-	Pxelinux may be used to boot linux using the PXE boot loader
-	which is present on many modern network cards.
-
-	When using pxelinux, the kernel image is specified using
-	"kernel <relative-path-below /tftpboot>". The nfsroot parameters
-	are passed to the kernel by adding them to the "append" line.
-	It is common to use serial console in conjunction with pxeliunx,
-	see Documentation/serial-console.txt for more information.
-
-	For more information on isolinux, including how to create bootdisks
-	for prebuilt kernels, see http://syslinux.zytor.com/
-
-
-
-
-4.) Credits
-    -------
-
-  The nfsroot code in the kernel and the RARP support have been written
-  by Gero Kuhlmann <gero@gkminix.han.de>.
-
-  The rest of the IP layer autoconfiguration code has been written
-  by Martin Mares <mj@atrey.karlin.mff.cuni.cz>.
-
-  In order to write the initial version of nfsroot I would like to thank
-  Jens-Uwe Mager <jum@anubis.han.de> for his help.
diff --git a/fs/Kconfig b/fs/Kconfig
index d731282..c509123 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1744,10 +1744,10 @@ config ROOT_NFS
 	  If you want your Linux box to mount its whole root file system (the
 	  one containing the directory /) from some other computer over the
 	  net via NFS (presumably because your box doesn't have a hard disk),
-	  say Y. Read <file:Documentation/nfsroot.txt> for details. It is
-	  likely that in this case, you also want to say Y to "Kernel level IP
-	  autoconfiguration" so that your box can discover its network address
-	  at boot time.
+	  say Y. Read <file:Documentation/filesystems/nfsroot.txt> for
+	  details. It is likely that in this case, you also want to say Y to
+	  "Kernel level IP autoconfiguration" so that your box can discover
+	  its network address at boot time.
 
 	  Most people say N here.
 
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 9c7e5ff..4670683 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -160,7 +160,7 @@ config IP_PNP_DHCP
 
 	  If unsure, say Y. Note that if you want to use DHCP, a DHCP server
 	  must be operating on your network.  Read
-	  <file:Documentation/nfsroot.txt> for details.
+	  <file:Documentation/filesystems/nfsroot.txt> for details.
 
 config IP_PNP_BOOTP
 	bool "IP: BOOTP support"
@@ -175,7 +175,7 @@ config IP_PNP_BOOTP
 	  does BOOTP itself, providing all necessary information on the kernel
 	  command line, you can say N here. If unsure, say Y. Note that if you
 	  want to use BOOTP, a BOOTP server must be operating on your network.
-	  Read <file:Documentation/nfsroot.txt> for details.
+	  Read <file:Documentation/filesystems/nfsroot.txt> for details.
 
 config IP_PNP_RARP
 	bool "IP: RARP support"
@@ -187,8 +187,8 @@ config IP_PNP_RARP
 	  discovered automatically at boot time using the RARP protocol (an
 	  older protocol which is being obsoleted by BOOTP and DHCP), say Y
 	  here. Note that if you want to use RARP, a RARP server must be
-	  operating on your network. Read <file:Documentation/nfsroot.txt> for
-	  details.
+	  operating on your network. Read
+	  <file:Documentation/filesystems/nfsroot.txt> for details.
 
 # not yet ready..
 #   bool '    IP: ARP support' CONFIG_IP_PNP_ARP		
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 7c992fb..4824fe8 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1411,7 +1411,7 @@ late_initcall(ip_auto_config);
 
 /*
  *  Decode any IP configuration options in the "ip=" or "nfsaddrs=" kernel
- *  command line parameter.  See Documentation/nfsroot.txt.
+ *  command line parameter.  See Documentation/filesystems/nfsroot.txt.
  */
 static int __init ic_proto_name(char *name)
 {
-- 
1.5.5.rc1


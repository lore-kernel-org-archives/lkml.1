Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbXEUB7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbXEUB7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbXEUB7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:59:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:11172 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXEUB7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-date:resent-message-id:resent-to:to:date:subject:from:message-id;
        b=j3ahViSwn7D56reZiYx/dewW0PZry5YMqs4u3QHzx/sFHG2cDnKQ3S/yByorgzU4pMDi/kXq+/WEEyUT5T6mizmvE+g28c+E3K/3RoeOuCurQHT/AVT7hrHeL+gW0/hM+k6gut6fgd04FI22lLtwxar5K6zY+gXGIQj9m2vIXmI=
To: linux-kernel@vger.kernel.org
Date: Mon, 21 May 2007 03:51:00 +0200
Subject: [PATCH] documentation: Documentation/initrd.txt
From: Domenico Andreoli <cavokz@gmail.com>
Message-ID: <4650fce6.54395a75.7ed7.ffff86db@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Final clearification of the pivot_root mechanism, which brings this
document really up-to-date.

Signed-off-by: Domenico Andreoli <cavok@dandreoli.com>

---
 Documentation/initrd.txt |   74 ++++++++++++++++++++++++++++-----------------
 1 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/Documentation/initrd.txt b/Documentation/initrd.txt
index 15f1b35..61e3111 100644
--- a/Documentation/initrd.txt
+++ b/Documentation/initrd.txt
@@ -27,16 +27,20 @@ When using initrd, the system typically boots as follows:
   1) the boot loader loads the kernel and the initial RAM disk
   2) the kernel converts initrd into a "normal" RAM disk and
      frees the memory used by initrd
-  3) initrd is mounted read-write as root
-  4) /linuxrc is executed (this can be any valid executable, including
+  3) if the root device is not /dev/ram0, the old (deprecated)
+     change_root procedure is followed. see the "Obsolete root change
+     mechanism" section below.
+  4) root device is mounted. if it is /dev/ram0, the initrd image is
+     then mounted as root
+  5) /sbin/init is executed (this can be any valid executable, including
      shell scripts; it is run with uid 0 and can do basically everything
-     init can do)
-  5) linuxrc mounts the "real" root file system
-  6) linuxrc places the root file system at the root directory using the
+     init can do). 
+  6) init mounts the "real" root file system
+  7) init places the root file system at the root directory using the
      pivot_root system call
-  7) the usual boot sequence (e.g. invocation of /sbin/init) is performed
-     on the root file system
-  8) the initrd file system is removed
+  8) init execs the /sbin/init on the new root filesystem, performing
+     the usual boot sequence
+  9) the initrd file system is removed
 
 Note that changing the root directory does not involve unmounting it.
 It is therefore possible to leave processes running on initrd during that
@@ -70,7 +74,7 @@ initrd adds the following new options:
   root=/dev/ram0
 
     initrd is mounted as root, and the normal boot procedure is followed,
-    with the RAM disk still mounted as root.
+    with the RAM disk mounted as root.
 
 Compressed cpio images
 ----------------------
@@ -137,11 +141,11 @@ We'll describe the loopback device method:
     # mkdir /mnt/dev
     # mknod /mnt/dev/console c 5 1
  5) copy all the files that are needed to properly use the initrd
-    environment. Don't forget the most important file, /linuxrc
-    Note that /linuxrc's permissions must include "x" (execute).
+    environment. Don't forget the most important file, /sbin/init
+    Note that /sbin/init's permissions must include "x" (execute).
  6) correct operation the initrd environment can frequently be tested
     even without rebooting with the command
-    # chroot /mnt /linuxrc
+    # chroot /mnt /sbin/init
     This is of course limited to initrds that do not interfere with the
     general system state (e.g. by reconfiguring network interfaces,
     overwriting mounted devices, trying to start already running demons,
@@ -154,7 +158,7 @@ We'll describe the loopback device method:
     # gzip -9 initrd
 
 For experimenting with initrd, you may want to take a rescue floppy and
-only add a symbolic link from /linuxrc to /bin/sh. Alternatively, you
+only add a symbolic link from /sbin/init to /bin/sh. Alternatively, you
 can try the experimental newlib environment [2] to create a small
 initrd.
 
@@ -163,15 +167,14 @@ boot loaders support initrd. Since the boot process is still compatible
 with an older mechanism, the following boot command line parameters
 have to be given:
 
-  root=/dev/ram0 init=/linuxrc rw
+  root=/dev/ram0 rw
 
 (rw is only necessary if writing to the initrd file system.)
 
 With LOADLIN, you simply execute
 
      LOADLIN <kernel> initrd=<disk_image>
-e.g. LOADLIN C:\LINUX\BZIMAGE initrd=C:\LINUX\INITRD.GZ root=/dev/ram0
-       init=/linuxrc rw
+e.g. LOADLIN C:\LINUX\BZIMAGE initrd=C:\LINUX\INITRD.GZ root=/dev/ram0 rw
 
 With LILO, you add the option INITRD=<path> to either the global section
 or to the section of the respective kernel in /etc/lilo.conf, and pass
@@ -179,7 +182,7 @@ the options using APPEND, e.g.
 
   image = /bzImage
     initrd = /boot/initrd.gz
-    append = "root=/dev/ram0 init=/linuxrc rw"
+    append = "root=/dev/ram0 rw"
 
 and run /sbin/lilo
 
@@ -191,7 +194,7 @@ Now you can boot and enjoy using initrd.
 Changing the root device
 ------------------------
 
-When finished with its duties, linuxrc typically changes the root device
+When finished with its duties, init typically changes the root device
 and proceeds with starting the Linux system on the "real" root device.
 
 The procedure involves the following steps:
@@ -217,7 +220,7 @@ must exist before calling pivot_root. Example:
 # mkdir initrd
 # pivot_root . initrd
 
-Now, the linuxrc process may still access the old root via its
+Now, the init process may still access the old root via its
 executable, shared libraries, standard input/output/error, and its
 current root directory. All these references are dropped by the
 following command:
@@ -249,10 +252,6 @@ disk can be freed:
 It is also possible to use initrd with an NFS-mounted root, see the
 pivot_root(8) man page for details.
 
-Note: if linuxrc or any program exec'ed from it terminates for some
-reason, the old change_root mechanism is invoked (see section "Obsolete
-root change mechanism").
-
 
 Usage scenarios
 ---------------
@@ -264,15 +263,15 @@ as follows:
   1) system boots from floppy or other media with a minimal kernel
      (e.g. support for RAM disks, initrd, a.out, and the Ext2 FS) and
      loads initrd
-  2) /linuxrc determines what is needed to (1) mount the "real" root FS
+  2) /sbin/init determines what is needed to (1) mount the "real" root FS
      (i.e. device type, device drivers, file system) and (2) the
      distribution media (e.g. CD-ROM, network, tape, ...). This can be
      done by asking the user, by auto-probing, or by using a hybrid
      approach.
-  3) /linuxrc loads the necessary kernel modules
-  4) /linuxrc creates and populates the root file system (this doesn't
+  3) /sbin/init loads the necessary kernel modules
+  4) /sbin/init creates and populates the root file system (this doesn't
      have to be a very usable system yet)
-  5) /linuxrc invokes pivot_root to change the root file system and
+  5) /sbin/init invokes pivot_root to change the root file system and
      execs - via chroot - a program that continues the installation
   6) the boot loader is installed
   7) the boot loader is configured to load an initrd with the set of
@@ -291,7 +290,7 @@ different hardware configurations in a single administrative domain. In
 such cases, it is desirable to generate only a small set of kernels
 (ideally only one) and to keep the system-specific part of configuration
 information as small as possible. In this case, a common initrd could be
-generated with all the necessary modules. Then, only /linuxrc or a file
+generated with all the necessary modules. Then, only /sbin/init or a file
 read by it would have to be different.
 
 A third scenario are more convenient recovery disks, because information
@@ -337,6 +336,25 @@ This old, deprecated mechanism is commonly called "change_root", while
 the new, supported mechanism is called "pivot_root".
 
 
+Mixed change_root and pivot_root mechanism
+------------------------------------------
+
+In case you did not want to use root=/dev/ram0 to trig the pivot_root mechanism,
+you may create both /linuxrc and /sbin/init in your initrd image.
+
+/linuxrc would contain only the following:
+
+#! /bin/sh
+mount -n -t proc proc /proc
+echo 0x0100 >/proc/sys/kernel/real-root-dev
+umount -n /proc
+
+Once linuxrc exited, the kernel would mount again your initrd as root,
+this time executing /sbin/init. Again, it would be duty of this init
+to build the right environment (maybe using the root= device passed on
+the cmdline) before the final execution of the real /sbin/init.
+
+
 Resources
 ---------
 
-- 
1.5.1.4

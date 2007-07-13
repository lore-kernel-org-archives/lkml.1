Return-Path: <linux-kernel-owner+w=401wt.eu-S937129AbXGMTCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937129AbXGMTCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbXGMTC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:02:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761375AbXGMTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:02:25 -0400
Date: Fri, 13 Jul 2007 21:02:11 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3][try 1] init: enable system-on-initramfs: make mount-on-boot
 optional
In-Reply-To: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
Message-ID: <Pine.LNX.4.58.0707132100320.3303@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/exbphKZ+jWlB7YvQ7GxaZMIGSlz+b2xUi3Pt
 RhBPtoXjgXUep6eJOJsvGdSxVoOhhiAi5bUM5tumeopkSUFh+6
 GlIDzNbvSoYrXzoJcpYyg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an option to disables the kernel's capability of mounting a
root device other than the ramfs. If you use initramfs, you don't need to
have this legacy feature anymore.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>


diff -X dontdiff -pruN linux-2.6.22.base/init/do_mounts.c linux-2.6.22.tmpfsroot/init/do_mounts.c
--- linux-2.6.22.base/init/do_mounts.c	2007-07-12 23:30:39.000000000 +0200
+++ linux-2.6.22.tmpfsroot/init/do_mounts.c	2007-07-12 23:07:50.000000000 +0200
@@ -18,11 +18,46 @@
 
 #include "do_mounts.h"
 
+int __initdata rd_doload;   /* 1 = load RAM disk, 0 = don't load */
+
+dev_t ROOT_DEV;
+int root_mountflags = MS_RDONLY | MS_SILENT;
+
+#if defined(CONFIG_BLK_DEV_RAM) || defined(CONFIG_BLK_DEV_FD)
+void __init change_floppy(char *fmt, ...)
+{
+	struct termios termios;
+	char buf[80];
+	char c;
+	int fd;
+	va_list args;
+	va_start(args, fmt);
+	vsprintf(buf, fmt, args);
+	va_end(args);
+	fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
+	if (fd >= 0) {
+		sys_ioctl(fd, FDEJECT, 0);
+		sys_close(fd);
+	}
+	printk(KERN_NOTICE "VFS: Insert %s and press ENTER\n", buf);
+	fd = sys_open("/dev/console", O_RDWR, 0);
+	if (fd >= 0) {
+		sys_ioctl(fd, TCGETS, (long)&termios);
+		termios.c_lflag &= ~ICANON;
+		sys_ioctl(fd, TCSETSF, (long)&termios);
+		sys_read(fd, &c, 1);
+		termios.c_lflag |= ICANON;
+		sys_ioctl(fd, TCSETSF, (long)&termios);
+		sys_close(fd);
+	}
+}
+#endif
+
+#ifndef CONFIG_DISABLE_MOUNT_ON_BOOT
+
 extern int get_filesystem_list(char * buf);
 
-int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 
-int root_mountflags = MS_RDONLY | MS_SILENT;
 char * __initdata root_device_name;
 #ifdef CONFIG_TMPFS_ROOT
 static char __initdata saved_root_name[64] = "rootfs";
@@ -30,8 +65,6 @@ static char __initdata saved_root_name[6
 static char __initdata saved_root_name[64];
 #endif
 
-dev_t ROOT_DEV;
-
 static int __init load_ramdisk(char *str)
 {
 	rd_doload = simple_strtol(str,NULL,0) & 3;
@@ -353,36 +386,6 @@ static int __init mount_nfs_root(void)
 }
 #endif
 
-#if defined(CONFIG_BLK_DEV_RAM) || defined(CONFIG_BLK_DEV_FD)
-void __init change_floppy(char *fmt, ...)
-{
-	struct termios termios;
-	char buf[80];
-	char c;
-	int fd;
-	va_list args;
-	va_start(args, fmt);
-	vsprintf(buf, fmt, args);
-	va_end(args);
-	fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
-	if (fd >= 0) {
-		sys_ioctl(fd, FDEJECT, 0);
-		sys_close(fd);
-	}
-	printk(KERN_NOTICE "VFS: Insert %s and press ENTER\n", buf);
-	fd = sys_open("/dev/console", O_RDWR, 0);
-	if (fd >= 0) {
-		sys_ioctl(fd, TCGETS, (long)&termios);
-		termios.c_lflag &= ~ICANON;
-		sys_ioctl(fd, TCSETSF, (long)&termios);
-		sys_read(fd, &c, 1);
-		termios.c_lflag |= ICANON;
-		sys_ioctl(fd, TCSETSF, (long)&termios);
-		sys_close(fd);
-	}
-}
-#endif
-
 void __init mount_root(void)
 {
 #ifdef CONFIG_ROOT_NFS
@@ -460,3 +463,19 @@ out_nomount:
 	security_sb_post_mountroot();
 }
 
+#else
+
+/*
+ * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
+ */
+void __init prepare_namespace(void)
+{
+	security_sb_post_mountroot();
+}
+
+void __init mount_block_root(char *name, int flags)
+{
+	panic("Booting without initramfs is disabled");
+}
+
+#endif
diff -X dontdiff -pruN linux-2.6.22.base/init/do_mounts_initrd.c linux-2.6.22.tmpfsroot/init/do_mounts_initrd.c
--- linux-2.6.22.base/init/do_mounts_initrd.c	2007-07-12 23:28:43.000000000 +0200
+++ linux-2.6.22.tmpfsroot/init/do_mounts_initrd.c	2007-07-12 23:33:22.000000000 +0200
@@ -13,6 +13,9 @@
 unsigned long initrd_start, initrd_end;
 int initrd_below_start_ok;
 unsigned int real_root_dev;	/* do_proc_dointvec cannot handle kdev_t */
+
+#ifndef CONFIG_DISABLE_MOUNT_ON_BOOT
+
 static int __initdata old_fd, root_fd;
 static int __initdata mount_initrd = 1;
 
@@ -122,3 +125,5 @@ int __init initrd_load(void)
 	sys_unlink("/initrd.image");
 	return 0;
 }
+
+#endif
diff -X dontdiff -pruN linux-2.6.22.base/init/initramfs.c linux-2.6.22.tmpfsroot/init/initramfs.c
--- linux-2.6.22.base/init/initramfs.c	2007-07-12 23:28:07.000000000 +0200
+++ linux-2.6.22.tmpfsroot/init/initramfs.c	2007-07-12 23:23:25.000000000 +0200
@@ -549,7 +549,7 @@ static int __init populate_rootfs(void)
 		panic(err);
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start) {
-#ifdef CONFIG_BLK_DEV_RAM
+#if defined CONFIG_BLK_DEV_RAM && !defined CONFIG_DISABLE_MOUNT_ON_BOOT
 		int fd;
 		printk(KERN_INFO "checking if image is initramfs...");
 		err = unpack_to_rootfs((char *)initrd_start,
diff -X dontdiff -pruN linux-2.6.22.base/usr/Kconfig linux-2.6.22.tmpfsroot/usr/Kconfig
--- linux-2.6.22.base/usr/Kconfig	2007-07-12 23:28:45.000000000 +0200
+++ linux-2.6.22.tmpfsroot/usr/Kconfig	2007-07-12 23:39:00.000000000 +0200
@@ -44,3 +44,11 @@ config INITRAMFS_ROOT_GID
 	  owned by group root in the initial ramdisk image.
 
 	  If you are not sure, leave it set to "0".
+
+config DISABLE_MOUNT_ON_BOOT
+	bool "Disable kernel root filesystem mount code"
+	depends on TMPFS_ROOT
+	help
+	  This disables the kernel's ability to mount a user-specified filesysten
+	  on boot. This REQUIRES an inital system on initramfs, either using
+	  /init for system setup, or directly using /sbin/init.

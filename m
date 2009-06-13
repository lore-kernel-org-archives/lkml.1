Return-Path: <linux-kernel-owner+w=401wt.eu-S1764964AbZFMN1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764964AbZFMN1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763928AbZFMN0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:26:06 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:37936 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763898AbZFMN0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=aC+STyHgU+e9Ps8a/rF0qgq8czeOrX2fLc6SWRZ032qqmRk7zzidJhMignEAkAiidf
         p3aq+FWceJVBl2ver+WCFSrL2QLFOpPFWZDAQ22lM6x0Thhrqzb7UbPbL8a2xm9PCZaX
         07zFQ4TneJuzrT5Z4hceuk+BibqrVIAhzhy34=
Message-ID: <4A33A802.8040507@gmail.com>
Date: Sat, 13 Jun 2009 15:22:10 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 08/14] Pramfs: Makefile and Kconfig
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Makefile and Kconfig.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -uprN linux-2.6.30-orig/fs/Kconfig linux-2.6.30/fs/Kconfig
--- linux-2.6.30-orig/fs/Kconfig	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30/fs/Kconfig	2009-06-13 10:01:41.000000000 +0200
@@ -13,7 +13,7 @@ source "fs/ext4/Kconfig"
 config FS_XIP
 # execute in place
 	bool
-	depends on EXT2_FS_XIP
+	depends on EXT2_FS_XIP || PRAMFS_XIP
 	default y
 
 source "fs/jbd/Kconfig"
@@ -176,6 +176,7 @@ source "fs/romfs/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
+source "fs/pramfs/Kconfig"
 
 config NILFS2_FS
 	tristate "NILFS2 file system support (EXPERIMENTAL)"
diff -uprN linux-2.6.30-orig/fs/Makefile linux-2.6.30/fs/Makefile
--- linux-2.6.30-orig/fs/Makefile	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30/fs/Makefile	2009-06-13 10:00:26.000000000 +0200
@@ -124,3 +124,5 @@ obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_EXOFS_FS)          += exofs/
+obj-$(CONFIG_PRAMFS)		+= pramfs/
+
diff -uprN linux-2.6.30-orig/fs/pramfs/Kconfig linux-2.6.30/fs/pramfs/Kconfig
--- linux-2.6.30-orig/fs/pramfs/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/Kconfig	2009-04-22 15:22:54.000000000 +0200
@@ -0,0 +1,51 @@
+config PRAMFS
+	tristate "Persistent and Protected RAM file system support"
+	select PRAMFS_NOWP if PRAMFS=m
+	help
+	   If your system has a block of fast (comparable in access speed to
+	   system memory) and non-volatile RAM and you wish to mount a
+	   light-weight, full-featured, and space-efficient filesystem over it,
+	   say Y here, and read <file:Documentation/filesystems/pramfs.txt>.
+
+	   To compile this as a module,  choose M here: the module will be
+	   called pramfs.
+
+config PRAMFS_XIP
+	bool "Enable Execute-in-place in PRAMFS"
+	depends on PRAMFS
+	select PRAMFS_NOWP
+	help
+	   Say Y here to enable xip feature of PRAMFS.
+
+config PRAMFS_NOWP
+	bool "Disable PRAMFS write protection"
+	depends on PRAMFS
+	default n
+	help
+	   Say Y here to disable the write protect feature of PRAMFS.
+
+config ROOT_PRAMFS
+	bool "Root file system on PRAMFS"
+	depends on PRAMFS && !ROOT_NFS
+	help
+	  Say Y if you have enabled PRAMFS, and you want to be
+	  able to use PRAMFS as the root filesystem.  To actually
+	  have the kernel mount PRAMFS as a root file system, you
+	  must also pass the command line parameter
+	  "root=/dev/null rootflags=physaddr=0x********" to the kernel
+	  (replace 0x******** with the physical address location of the
+	  previously initialized PRAMFS memory to boot with).
+
+config PRAMFS_TEST
+	boolean
+	depends on PRAMFS
+	default n
+
+config TEST_MODULE
+	tristate "PRAMFS Test"
+	depends on PRAMFS && m && !PRAMFS_NOWP
+	select PRAMFS_TEST
+	default n
+	help
+	  Say Y here to build a simple module to test the protection of
+	  PRAMFS. The module will be called pramfs_test.ko.
diff -uprN linux-2.6.30-orig/fs/pramfs/Makefile linux-2.6.30/fs/pramfs/Makefile
--- linux-2.6.30-orig/fs/pramfs/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/Makefile	2009-04-19 11:58:51.000000000 +0200
@@ -0,0 +1,13 @@
+#
+# Makefile for the linux pram-filesystem routines.
+#
+
+obj-$(CONFIG_PRAMFS) += pramfs.o
+obj-$(CONFIG_TEST_MODULE) += pramfs_test.o
+
+pramfs-objs := balloc.o dir.o file.o inode.o namei.o super.o symlink.o
+
+ifneq ($(CONFIG_PRAMFS_NOWP),y)
+pramfs-objs += wprotect.o
+endif
+pramfs-$(CONFIG_PRAMFS_XIP) += xip.o



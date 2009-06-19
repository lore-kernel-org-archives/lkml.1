Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbZFSOeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbZFSOeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZFSOeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:34:15 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:52288 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZFSOeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:34:14 -0400
Message-ID: <4A3BA1E5.8000109@msgid.tls.msk.ru>
Date: Fri, 19 Jun 2009 18:34:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: squashfs-devel@lists.sourceforge.net,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Backport of squashfs-2.6.29+ (squashfs-4.0) to kernel 2.6.27
Content-Type: multipart/mixed;
 boundary="------------020809010400020807060808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020809010400020807060808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Below are two diffs for squashfs-4 (as found in 2.6.29
and 2.6.30 kernels) to kernel 2.6.27.

In order to build, grab fs/squashfs directory from 2.6.29 or
2.6.30 (or maybe later version), copy it to fs/squashfs in
2.6.27 tree, and apply 2 provided patches.

First (squashfs-2.6.29-to-.27-backport.diff) changes squashfs
itself to be compatible with kernel 2.6.27 API (namely, adding
magic number definition and implementing d_obtain_alias() which
is missing in 2.6.27.

And second changes 2.6.27 build infrastructure to actually
include squashfs filesystem -- init/do_mounts_rd.c, fs/Kconfig
and fs/Makefile.

JFYI, in case it will be useful to someone.

What I use it for is -- since 2.6.29+ does not work with version
3 of the filesystem layout, and 2.6.28- only recognizes v.3, and
since I'm tired updating kernels on all supported machines, I want
to stop for some time, relying on 2.6.27.y stable series.  But we
also use squashfs and some machines requires more modern kernel
features.  So I thought about updating squashfs to v4 on all.
So here it goes.

Thanks.

/mjt

--------------020809010400020807060808
Content-Type: text/x-patch;
 name="squashfs-2.6.29-to-.27-backport.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="squashfs-2.6.29-to-.27-backport.diff"

--- linux-2.6.29/fs/squashfs/export.c	2009-06-10 07:05:27 +0400
+++ linux-2.6.27/fs/squashfs/export.c	2009-06-19 18:07:55 +0400
@@ -76,14 +76,30 @@ static struct dentry *squashfs_export_ig
 	unsigned int ino_num)
 {
 	long long ino;
-	struct dentry *dentry = ERR_PTR(-ENOENT);
+	struct dentry *dentry;
+	struct inode *i;
 
 	TRACE("Entered squashfs_export_iget\n");
 
 	ino = squashfs_inode_lookup(sb, ino_num);
-	if (ino >= 0)
-		dentry = d_obtain_alias(squashfs_iget(sb, ino, ino_num));
+	if (ino < 0) {
+		dentry = ERR_PTR(-ENOENT);
+		goto failure;
+	}
+
+	i = squashfs_iget(sb, ino, ino_num);
+	if (i == NULL) {
+		dentry = ERR_PTR(-EACCES);
+		goto failure;
+	}
+
+	dentry = d_alloc_anon(i);
+	if (dentry == NULL) {
+		iput(i);
+		dentry = ERR_PTR(-ENOMEM);
+	}
 
+failure:
 	return dentry;
 }
 
--- linux-2.6.29/fs/squashfs/squashfs_fs.h	2009-06-10 07:05:27 +0400
+++ linux-2.6.27/fs/squashfs/squashfs_fs.h	2009-06-19 18:07:55 +0400
@@ -23,6 +23,8 @@
  * squashfs_fs.h
  */
 
+#define SQUASHFS_MAGIC		0x73717368
+
 #define SQUASHFS_CACHED_FRAGMENTS	CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE
 #define SQUASHFS_MAJOR			4
 #define SQUASHFS_MINOR			0

--------------020809010400020807060808
Content-Type: text/x-patch;
 name="squashfs-integrate.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="squashfs-integrate.diff"

--- linux-2.6.27.orig/fs/Kconfig	2008-10-10 02:13:53 +0400
+++ linux-2.6.27.squash/fs/Kconfig	2009-06-19 17:57:16 +0400
@@ -1350,2 +1350,4 @@ config CRAMFS
 
+source "fs/squashfs/Kconfig"
+
 config VXFS_FS
--- linux-2.6.27.orig/fs/Makefile	2008-10-10 02:13:53 +0400
+++ linux-2.6.27.squash/fs/Makefile	2009-06-19 17:56:02 +0400
@@ -76,2 +76,3 @@ obj-$(CONFIG_EXT2_FS)		+= ext2/
 obj-$(CONFIG_CRAMFS)		+= cramfs/
+obj-$(CONFIG_SQUASHFS)		+= squashfs/
 obj-y				+= ramfs/
--- linux-2.6.27.orig/init/do_mounts_rd.c	2008-10-10 02:13:53 +0400
+++ linux-2.6.27.squash/init/do_mounts_rd.c	2009-06-19 17:53:22 +0400
@@ -11,2 +11,3 @@
 #include "do_mounts.h"
+#include "../fs/squashfs/squashfs_fs.h"
 
@@ -43,2 +44,3 @@ static int __init crd_load(int in_fd, in
  *	cramfs
+ *	squashfs
  * 	gzip
@@ -53,2 +55,3 @@ identify_ramdisk_image(int fd, int start
 	struct cramfs_super *cramfsb;
+	struct squashfs_super_block *squashfsb;
 	int nblocks = -1;
@@ -64,2 +67,3 @@ identify_ramdisk_image(int fd, int start
 	cramfsb = (struct cramfs_super *) buf;
+	squashfsb = (struct squashfs_super_block *) buf;
 	memset(buf, 0xe5, size);
@@ -101,2 +105,12 @@ identify_ramdisk_image(int fd, int start
 
+	/* squashfs is at block zero too */
+	if (le32_to_cpu(squashfsb->s_magic) == SQUASHFS_MAGIC) {
+		printk(KERN_NOTICE
+		       "RAMDISK: squashfs filesystem found at block %d\n",
+		       start_block);
+		nblocks = (le64_to_cpu(squashfsb->bytes_used) + BLOCK_SIZE - 1)
+			 >> BLOCK_SIZE_BITS;
+		goto done;
+	}
+
 	/*

--------------020809010400020807060808--

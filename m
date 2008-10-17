Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbYJQPws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbYJQPws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYJQPwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:52:09 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:3907 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237AbYJQPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:52:07 -0400
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Subject: [PATCH 15/16] Squashfs: initrd support
Message-Id: <E1KqrTX-0001yI-SL@dylan>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Fri, 17 Oct 2008 16:42:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 init/do_mounts_rd.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index fedef93..30086a7 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -5,6 +5,7 @@
 #include <linux/ext2_fs.h>
 #include <linux/romfs_fs.h>
 #include <linux/cramfs_fs.h>
+#include <linux/squashfs_fs.h>
 #include <linux/initrd.h>
 #include <linux/string.h>
 
@@ -41,6 +42,7 @@ static int __init crd_load(int in_fd, int out_fd);
  * 	ext2
  *	romfs
  *	cramfs
+ *	squashfs
  * 	gzip
  */
 static int __init 
@@ -51,6 +53,7 @@ identify_ramdisk_image(int fd, int start_block)
 	struct ext2_super_block *ext2sb;
 	struct romfs_super_block *romfsb;
 	struct cramfs_super *cramfsb;
+	struct squashfs_super_block *squashfsb;
 	int nblocks = -1;
 	unsigned char *buf;
 
@@ -62,6 +65,7 @@ identify_ramdisk_image(int fd, int start_block)
 	ext2sb = (struct ext2_super_block *) buf;
 	romfsb = (struct romfs_super_block *) buf;
 	cramfsb = (struct cramfs_super *) buf;
+	squashfsb = (struct squashfs_super_block *) buf;
 	memset(buf, 0xe5, size);
 
 	/*
@@ -99,6 +103,16 @@ identify_ramdisk_image(int fd, int start_block)
 		goto done;
 	}
 
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
 	 * Read block 1 to test for minix and ext2 superblock
 	 */
-- 
1.5.2.5


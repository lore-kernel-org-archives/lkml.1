Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYJ2Bvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYJ2Bvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 21:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYJ2BuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 21:50:03 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:1319 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbYJ2Bt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 21:49:58 -0400
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: [PATCH V2 15/16] Squashfs: initrd support
Message-Id: <E1Kv0C4-0006Hs-M3@dylan>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 29 Oct 2008 01:49:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 init/do_mounts_rd.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index a7c748f..0f0f0cf 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -9,6 +9,7 @@
 #include <linux/string.h>
 
 #include "do_mounts.h"
+#include "../fs/squashfs/squashfs_fs.h"
 
 int __initdata rd_prompt = 1;/* 1 = prompt for RAM disk, 0 = don't prompt */
 
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


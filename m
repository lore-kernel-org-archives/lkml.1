Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZKCP7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZKCP7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZKCP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:59:55 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:60281 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbZKCP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:59:54 -0500
To: jblunck@suse.de
Subject: [PATCH] BKL: Remove BKL from Squashfs
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, matthew@wil.cx, viro@zeniv.linux.org.uk
Message-Id: <E1N5LnX-00006U-Qq@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Tue, 03 Nov 2009 15:59:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super/put_super.  It is safe to remove it.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/super.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 23cea83..7c25056 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -30,7 +30,6 @@
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -78,14 +77,11 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	u64 lookup_table_start;
 	int err;
 
-	lock_kernel();
-
 	TRACE("Entered squashfs_fill_superblock\n");
 
 	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		ERROR("Failed to allocate squashfs_sb_info\n");
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	msblk = sb->s_fs_info;
@@ -289,7 +285,6 @@ allocate_root:
 
 	TRACE("Leaving squashfs_fill_super\n");
 	kfree(sblk);
-	unlock_kernel();
 	return 0;
 
 failed_mount:
@@ -303,14 +298,12 @@ failed_mount:
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 	kfree(sblk);
-	unlock_kernel();
 	return err;
 
 failure:
 	kfree(msblk->stream.workspace);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
-	unlock_kernel();
 	return -ENOMEM;
 }
 
@@ -345,8 +338,6 @@ static int squashfs_remount(struct super_block *sb, int *flags, char *data)
 
 static void squashfs_put_super(struct super_block *sb)
 {
-	lock_kernel();
-
 	if (sb->s_fs_info) {
 		struct squashfs_sb_info *sbi = sb->s_fs_info;
 		squashfs_cache_delete(sbi->block_cache);
@@ -359,8 +350,6 @@ static void squashfs_put_super(struct super_block *sb)
 		kfree(sb->s_fs_info);
 		sb->s_fs_info = NULL;
 	}
-
-	unlock_kernel();
 }
 
 
-- 
1.5.2.5


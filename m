Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZKCPrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZKCPrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZKCPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:47:06 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:62731 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbZKCPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:47:05 -0500
X-Greylist: delayed 1911 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 10:47:05 EST
To: jblunck@suse.de
Subject: BKL: Remove BKL from Squashfs
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, matthew@wil.cx, viro@zeniv.linux.org.uk
Message-Id: <E1N5L6K-0008LW-6y@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Tue, 03 Nov 2009 15:15:16 +0000
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


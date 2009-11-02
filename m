Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZKBKNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZKBKNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZKBKNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:13:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:47258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbZKBKG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:06:59 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-ext4@vger.kernel.org
Subject: [PATCH 08/27] BKL: Remove BKL from ext4 filesystem
Date: Mon,  2 Nov 2009 11:04:48 +0100
Message-Id: <1257156307-24175-9-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is still used in ext4_put_super(), ext4_fill_super() and
ext4_remount(). All three calles are protected against concurrent calls by
the s_umount rw semaphore of struct super_block.

Therefore the BKL is protecting nothing in this case.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext4/super.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9db81d2..328e9dc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/parser.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
 #include <linux/vfs.h>
@@ -599,7 +598,6 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
 	lock_super(sb);
-	lock_kernel();
 	if (sb->s_dirt)
 		ext4_commit_super(sb, 1);
 
@@ -665,7 +663,6 @@ static void ext4_put_super(struct super_block *sb)
 	 * Now that we are completely done shutting down the
 	 * superblock, we need to actually destroy the kobject.
 	 */
-	unlock_kernel();
 	unlock_super(sb);
 	kobject_put(&sbi->s_kobj);
 	wait_for_completion(&sbi->s_kobj_unregister);
@@ -2328,19 +2325,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_fs_info = sbi;
@@ -2352,8 +2344,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_sectors_written_start = part_stat_read(sb->s_bdev->bd_part,
 						      sectors[1]);
 
-	unlock_kernel();
-
 	/* Cleanup superblock name */
 	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
 		*cp = '!';
@@ -3456,8 +3446,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	int i;
 #endif
 
-	lock_kernel();
-
 	/* Store the original options */
 	lock_super(sb);
 	old_sb_flags = sb->s_flags;
@@ -3587,7 +3575,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			kfree(old_opts.s_qf_names[i]);
 #endif
 	unlock_super(sb);
-	unlock_kernel();
 	return 0;
 
 restore_opts:
@@ -3608,7 +3595,6 @@ restore_opts:
 	}
 #endif
 	unlock_super(sb);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2


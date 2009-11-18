Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZKRJ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZKRJ1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZKRJZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:25:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:42266 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbZKRJZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:11 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Subject: [PATCH 10/20] BKL: Remove BKL from ext4 filesystem
Date: Wed, 18 Nov 2009 10:24:43 +0100
Message-Id: <1258536293-7762-11-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is still used in ext4_put_super(), ext4_fill_super() and
ext4_remount(). All three calles are protected against concurrent calls by
the s_umount rw semaphore of struct super_block.

Therefore the BKL is protecting nothing in this case.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cdfe2a8..86bcab1 100644
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
@@ -2330,19 +2327,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -2354,8 +2346,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_sectors_written_start = part_stat_read(sb->s_bdev->bd_part,
 						      sectors[1]);
 
-	unlock_kernel();
-
 	/* Cleanup superblock name */
 	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
 		*cp = '!';
@@ -3464,8 +3454,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	int i;
 #endif
 
-	lock_kernel();
-
 	/* Store the original options */
 	lock_super(sb);
 	old_sb_flags = sb->s_flags;
@@ -3595,7 +3583,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			kfree(old_opts.s_qf_names[i]);
 #endif
 	unlock_super(sb);
-	unlock_kernel();
 	return 0;
 
 restore_opts:
@@ -3616,7 +3603,6 @@ restore_opts:
 	}
 #endif
 	unlock_super(sb);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZKBKNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZKBKNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZKBKNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:13:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbZKBKG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:06:58 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
       linux-ext4@vger.kernel.org
Subject: [PATCH 05/27] BKL: Remove BKL from ext2 filesystem
Date: Mon,  2 Nov 2009 11:04:45 +0100
Message-Id: <1257156307-24175-6-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is still used in ext2_put_super(), ext2_fill_super(), ext2_sync_fs()
ext2_remount() and ext2_write_inode(). From these calls ext2_put_super(),
ext2_fill_super() and ext2_remount() are protected against each other by
the struct super_block s_umount rw semaphore. The call in ext2_write_inode()
could only protect the modification of the ext2_sb_info through
ext2_update_dynamic_rev() against concurrent ext2_sync_fs() or ext2_remount().
ext2_fill_super() and ext2_put_super() can be left out because you need a
valid filesystem reference in all three cases, which you do not have when
you are one of these functions.

If the BKL is only protecting the modification of the ext2_sb_info it can
safely be removed since this is protected by the struct ext2_sb_info s_mutex.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/inode.c |    3 ---
 fs/ext2/super.c |   16 ----------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 057074e..8b51416 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -22,7 +22,6 @@
  *  Assorted race fixes, rewrite of ext2_get_block() by Al Viro, 2000
  */
 
-#include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
@@ -1400,13 +1399,11 @@ int ext2_write_inode(struct inode *inode, int do_sync)
 			       /* If this is the first large file
 				* created, add a flag to the superblock.
 				*/
-				lock_kernel();
 				mutex_lock(&EXT2_SB(sb)->s_mutex);
 				ext2_update_dynamic_rev(sb);
 				EXT2_SET_RO_COMPAT_FEATURE(sb,
 					EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
 				mutex_unlock(&EXT2_SB(sb)->s_mutex);
-				unlock_kernel();
 				ext2_write_super(sb);
 			}
 		}
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d610eb9..7e819ac 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -26,7 +26,6 @@
 #include <linux/random.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
-#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
@@ -118,8 +117,6 @@ static void ext2_put_super (struct super_block * sb)
 	int i;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
-	lock_kernel();
-
 	if (sb->s_dirt && !(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
 
@@ -143,8 +140,6 @@ static void ext2_put_super (struct super_block * sb)
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-
-	unlock_kernel();
 }
 
 static struct kmem_cache * ext2_inode_cachep;
@@ -750,8 +745,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	__le32 features;
 	int err;
 
-	lock_kernel();
-
 	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -1077,7 +1070,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		ext2_warning(sb, __func__,
 			"mounting ext3 filesystem as ext2");
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
-	unlock_kernel();
 	return 0;
 
 cantfind_ext2:
@@ -1102,7 +1094,6 @@ failed_sbi:
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 failed_unlock:
-	unlock_kernel();
 	return ret;
 }
 
@@ -1140,7 +1131,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 {
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 
-	lock_kernel();
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
 		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
@@ -1154,7 +1144,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 		ext2_commit_super(sb, es);
 	}
 	sb->s_dirt = 0;
-	unlock_kernel();
 
 	return 0;
 }
@@ -1181,7 +1170,6 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	unsigned long old_sb_flags;
 	int err;
 
-	lock_kernel();
 	mutex_lock(&sbi->s_mutex);
 
 	/* Store the old options */
@@ -1221,14 +1209,12 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		mutex_unlock(&sbi->s_mutex);
-		unlock_kernel();
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
 		    !(sbi->s_mount_state & EXT2_VALID_FS)) {
 			mutex_unlock(&sbi->s_mutex);
-			unlock_kernel();
 			return 0;
 		}
 		/*
@@ -1258,7 +1244,6 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	}
 	ext2_sync_super(sb, es);
 	mutex_unlock(&sbi->s_mutex);
-	unlock_kernel();
 	return 0;
 restore_opts:
 	sbi->s_mount_opt = old_opts.s_mount_opt;
@@ -1266,7 +1251,6 @@ restore_opts:
 	sbi->s_resgid = old_opts.s_resgid;
 	sb->s_flags = old_sb_flags;
 	mutex_unlock(&sbi->s_mutex);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2


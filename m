Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZKRJZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZKRJZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbZKRJZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:25:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbZKRJZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:21 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 20/20] BKL: Remove BKL from ext2 filesystem
Date: Wed, 18 Nov 2009 10:24:53 +0100
Message-Id: <1258536293-7762-21-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
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
safely be removed since this is protected by the struct ext2_sb_info s_lock.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c |    3 ---
 fs/ext2/super.c |   16 ----------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 65a0d4b..5afb161 100644
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
 				spin_lock(&EXT2_SB(sb)->s_lock);
 				ext2_update_dynamic_rev(sb);
 				EXT2_SET_RO_COMPAT_FEATURE(sb,
 					EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
 				spin_unlock(&EXT2_SB(sb)->s_lock);
-				unlock_kernel();
 				ext2_write_super(sb);
 			}
 		}
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 0ca42fe..a764002 100644
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
@@ -120,8 +119,6 @@ static void ext2_put_super (struct super_block * sb)
 	int i;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
-	lock_kernel();
-
 	if (sb->s_dirt && !(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
 
@@ -147,8 +144,6 @@ static void ext2_put_super (struct super_block * sb)
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-
-	unlock_kernel();
 }
 
 static struct kmem_cache * ext2_inode_cachep;
@@ -754,8 +749,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	__le32 features;
 	int err;
 
-	lock_kernel();
-
 	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -1081,7 +1074,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		ext2_warning(sb, __func__,
 			"mounting ext3 filesystem as ext2");
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
-	unlock_kernel();
 	return 0;
 
 cantfind_ext2:
@@ -1106,7 +1098,6 @@ failed_sbi:
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 failed_unlock:
-	unlock_kernel();
 	return ret;
 }
 
@@ -1149,7 +1140,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = sbi->s_es;
 
-	lock_kernel();
 	spin_lock(&sbi->s_lock);
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
@@ -1166,7 +1156,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 		spin_unlock(&sbi->s_lock);
 	}
 	sb->s_dirt = 0;
-	unlock_kernel();
 
 	return 0;
 }
@@ -1189,7 +1178,6 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	unsigned long old_sb_flags;
 	int err;
 
-	lock_kernel();
 	spin_lock(&sbi->s_lock);
 
 	/* Store the old options */
@@ -1229,14 +1217,12 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		spin_unlock(&sbi->s_lock);
-		unlock_kernel();
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
 		    !(sbi->s_mount_state & EXT2_VALID_FS)) {
 			spin_unlock(&sbi->s_lock);
-			unlock_kernel();
 			return 0;
 		}
 		/*
@@ -1266,7 +1252,6 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	}
 	spin_unlock(&EXT2_SB(sb)->s_lock);
 	ext2_sync_super(sb, es);
-	unlock_kernel();
 	return 0;
 restore_opts:
 	sbi->s_mount_opt = old_opts.s_mount_opt;
@@ -1274,7 +1259,6 @@ restore_opts:
 	sbi->s_resgid = old_opts.s_resgid;
 	sb->s_flags = old_sb_flags;
 	spin_unlock(&sbi->s_lock);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2


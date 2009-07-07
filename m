Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbZGGQQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbZGGQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbZGGQPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:15:52 -0400
Received: from smtp.nokia.com ([192.100.122.233]:60595 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732AbZGGQPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:15:41 -0400
From: Artem Bityutskiy <dedekind1@nokia.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, Artem Bityutskiy <dedekind1@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2009 21:05:48 +0300
Message-Id: <20090707180548.17048.74367.sendpatchset@localhost.localdomain>
In-Reply-To: <20090707180541.17048.49901.sendpatchset@localhost.localdomain>
References: <20090707180541.17048.49901.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/2] VFS: introduce helpers for manipulation s_dirty flag
X-OriginalArrivalTime: 07 Jul 2009 16:15:16.0850 (UTC) FILETIME=[1DA93520:01C9FF1E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] VFS: introduce helpers for manipulation s_dirty flag

This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
'mark_sb_clean()', and 'is_sb_dirty()'. The helpers simply
set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
every FS use these helpers instead of manipulating
'sb->s_dirt' directly.

This patch also makes all file-systems use the helpers.

This patch is just a preparation for further periodic write-back
timer optimizations. No functional changes yet.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/affs/bitmap.c      |    4 ++--
 fs/affs/super.c       |   14 +++++++++-----
 fs/bfs/inode.c        |    8 ++++----
 fs/exofs/inode.c      |    2 +-
 fs/exofs/super.c      |    6 +++---
 fs/ext2/balloc.c      |    4 ++--
 fs/ext2/ialloc.c      |    4 ++--
 fs/ext2/super.c       |   10 +++++-----
 fs/ext2/xattr.c       |    2 +-
 fs/ext4/balloc.c      |    2 +-
 fs/ext4/file.c        |    2 +-
 fs/ext4/ialloc.c      |    4 ++--
 fs/ext4/inode.c       |    2 +-
 fs/ext4/mballoc.c     |    4 ++--
 fs/ext4/resize.c      |    4 ++--
 fs/ext4/super.c       |    6 +++---
 fs/ext4/xattr.c       |    2 +-
 fs/fat/fatent.c       |    8 ++++----
 fs/fat/inode.c        |    6 +++---
 fs/hfs/extent.c       |    2 +-
 fs/hfs/hfs_fs.h       |    2 +-
 fs/hfs/inode.c        |    6 +++---
 fs/hfs/super.c        |    6 +++---
 fs/hfsplus/bitmap.c   |    4 ++--
 fs/hfsplus/dir.c      |    2 +-
 fs/hfsplus/inode.c    |    6 +++---
 fs/hfsplus/super.c    |   16 ++++++++--------
 fs/jffs2/os-linux.h   |    2 +-
 fs/jffs2/super.c      |    4 ++--
 fs/nilfs2/segment.c   |    2 +-
 fs/nilfs2/super.c     |   18 +++++++++---------
 fs/nilfs2/the_nilfs.c |    2 +-
 fs/reiserfs/journal.c |    6 +++---
 fs/reiserfs/resize.c  |    2 +-
 fs/reiserfs/super.c   |   10 +++++-----
 fs/super.c            |    4 ++--
 fs/sync.c             |    2 +-
 fs/sysv/inode.c       |    6 +++---
 fs/sysv/super.c       |    2 +-
 fs/sysv/sysv.h        |    2 +-
 fs/udf/super.c        |    6 +++---
 fs/udf/udfdecl.h      |    2 +-
 fs/ufs/balloc.c       |    8 ++++----
 fs/ufs/ialloc.c       |    4 ++--
 fs/ufs/super.c        |   12 ++++++------
 include/linux/fs.h    |   17 +++++++++++++++++
 46 files changed, 135 insertions(+), 114 deletions(-)

diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index dc5ef14..0be510c 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -102,7 +102,7 @@ affs_free_block(struct super_block *sb, u32 block)
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp - mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	bm->bm_free++;
 
 	mutex_unlock(&sbi->s_bmlock);
@@ -247,7 +247,7 @@ find_bit:
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp + mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	mutex_unlock(&sbi->s_bmlock);
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 104fdcb..3b3c770 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -68,9 +68,13 @@ affs_write_super(struct super_block *sb)
 		//		if (buffer_dirty(sbi->s_bitmap[i].bm_bh)) {
 		//			clean = 0;
 		affs_commit_super(sb, clean);
-		sb->s_dirt = !clean;	/* redo until bitmap synced */
+		/* redo until bitmap synced */
+		if (clean)
+			mark_sb_clean(sb);
+		else
+			mark_sb_dirty(sb);
 	} else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 	unlock_super(sb);
 
 	pr_debug("AFFS: write_super() at %lu, clean=%d\n", get_seconds(), clean);
@@ -81,7 +85,7 @@ affs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	affs_commit_super(sb, 2);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -540,8 +544,8 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
-		sb->s_dirt = 1;
-		while (sb->s_dirt)
+		mark_sb_dirty(sb);
+		while (is_sb_dirty(sb))
 			affs_write_super(sb);
 		affs_free_bitmap(sb);
 	} else
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 6f60336..8373016 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -222,7 +222,7 @@ static int bfs_sync_fs(struct super_block *sb, int wait)
 
 	mutex_lock(&info->bfs_lock);
 	mark_buffer_dirty(info->si_sbh);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	mutex_unlock(&info->bfs_lock);
 
 	return 0;
@@ -233,7 +233,7 @@ static void bfs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		bfs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static void bfs_put_super(struct super_block *s)
@@ -245,7 +245,7 @@ static void bfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (s->s_dirt)
+	if (is_sb_dirty(s))
 		bfs_write_super(s);
 
 	brelse(info->si_sbh);
@@ -480,7 +480,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	brelse(bh);
 	if (!(s->s_flags & MS_RDONLY)) {
 		mark_buffer_dirty(info->si_sbh);
-		s->s_dirt = 1;
+		mark_sb_dirty(s);
 	} 
 	dump_imap("read_super", s);
 	mutex_init(&info->bfs_lock);
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 77d0a29..cb20f1c 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1066,7 +1066,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 
 	sbi = sb->s_fs_info;
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	inode->i_uid = current->cred->fsuid;
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 8216c5b..14263ff 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -241,7 +241,7 @@ static int exofs_sync_fs(struct super_block *sb, int wait)
 		EXOFS_ERR("exofs_write_super: exofs_sync_op failed.\n");
 		goto out;
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 out:
 	if (or)
@@ -257,7 +257,7 @@ static void exofs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		exofs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 /*
@@ -271,7 +271,7 @@ static void exofs_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		exofs_write_super(sb);
 
 	/* make sure there are no pending commands */
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 7f8d2e5..a3de92b 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -164,7 +164,7 @@ static void release_blocks(struct super_block *sb, int count)
 		struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 		percpu_counter_add(&sbi->s_freeblocks_counter, count);
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 }
 
@@ -179,7 +179,7 @@ static void group_adjust_blocks(struct super_block *sb, int group_no,
 		free_blocks = le16_to_cpu(desc->bg_free_blocks_count);
 		desc->bg_free_blocks_count = cpu_to_le16(free_blocks + count);
 		spin_unlock(sb_bgl_lock(sbi, group_no));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		mark_buffer_dirty(bh);
 	}
 }
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 15387c9..bb8cf4e 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -81,7 +81,7 @@ static void ext2_release_inode(struct super_block *sb, int group, int dir)
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(bh);
 }
 
@@ -548,7 +548,7 @@ got:
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(bh2);
 	inode->i_uid = current_fsuid();
 	if (test_opt (sb, GRPID))
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1a9ffee..95fdfe9 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -117,7 +117,7 @@ static void ext2_put_super (struct super_block * sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		ext2_write_super(sb);
 
 	ext2_xattr_put_super(sb);
@@ -1094,7 +1094,7 @@ static void ext2_commit_super (struct super_block * sb,
 {
 	es->s_wtime = cpu_to_le32(get_seconds());
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 }
 
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
@@ -1104,7 +1104,7 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
 	es->s_wtime = cpu_to_le32(get_seconds());
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 }
 
 /*
@@ -1135,7 +1135,7 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	} else {
 		ext2_commit_super(sb, es);
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_kernel();
 
 	return 0;
@@ -1147,7 +1147,7 @@ void ext2_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static int ext2_remount (struct super_block * sb, int * flags, char * data)
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7913531..1673ee4 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -343,7 +343,7 @@ static void ext2_xattr_update_super_block(struct super_block *sb)
 		return;
 
 	EXT2_SET_COMPAT_FEATURE(sb, EXT2_FEATURE_COMPAT_EXT_ATTR);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 }
 
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e2126d7..c05558f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -490,7 +490,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 error_return:
 	brelse(bitmap_bh);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3f1873f..fb3a262 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -173,7 +173,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		if (!IS_ERR(cp)) {
 			memcpy(sbi->s_es->s_last_mounted, cp,
 			       sizeof(sbi->s_es->s_last_mounted));
-			sb->s_dirt = 1;
+			mark_sb_dirty(sb);
 		}
 	}
 	return generic_file_open(inode, filp);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2f64573..2042a5f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -294,7 +294,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (!fatal)
 		fatal = err;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, fatal);
@@ -978,7 +978,7 @@ got:
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 60a26f3..df6fdaa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4733,7 +4733,7 @@ static int ext4_do_update_inode(handle_t *handle,
 			ext4_update_dynamic_rev(sb);
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
-			sb->s_dirt = 1;
+			mark_sb_dirty(sb);
 			ext4_handle_sync(handle);
 			err = ext4_handle_dirty_metadata(handle, inode,
 					EXT4_SB(sb)->s_sbh);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 519a0a6..18fe55f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3027,7 +3027,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	brelse(bitmap_bh);
 	return err;
 }
@@ -4854,7 +4854,7 @@ do_more:
 		put_bh(bitmap_bh);
 		goto do_more;
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 68b0351..4fa6c8d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -945,7 +945,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	}
 
 	ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 exit_journal:
 	mutex_unlock(&sbi->s_resize_lock);
@@ -1076,7 +1076,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	}
 	ext4_blocks_count_set(es, o_blocks_count + add);
 	ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mutex_unlock(&EXT4_SB(sb)->s_resize_lock);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8f4f079..9c64d92 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -580,7 +580,7 @@ static void ext4_put_super(struct super_block *sb)
 
 	lock_super(sb);
 	lock_kernel();
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		ext4_commit_super(sb, 1);
 
 	ext4_release_system_zone(sb);
@@ -2533,7 +2533,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #else
 		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 
 	if (sbi->s_blocks_per_group > blocksize * 8) {
@@ -3217,7 +3217,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 					&EXT4_SB(sb)->s_freeblocks_counter));
 	es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(
 					&EXT4_SB(sb)->s_freeinodes_counter));
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 62b31c2..3589b7a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -456,7 +456,7 @@ static void ext4_xattr_update_super_block(handle_t *handle,
 
 	if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
 		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	}
 }
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index a810377..46db5e5 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -498,7 +498,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				sb->s_dirt = 1;
+				mark_sb_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -520,7 +520,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	err = -ENOSPC;
 
 out:
@@ -581,7 +581,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 		ops->ent_put(&fatent, FAT_ENT_FREE);
 		if (sbi->free_clusters != -1) {
 			sbi->free_clusters++;
-			sb->s_dirt = 1;
+			mark_sb_dirty(sb);
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -671,7 +671,7 @@ int fat_count_free_clusters(struct super_block *sb)
 	}
 	sbi->free_clusters = free;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	fatent_brelse(&fatent);
 out:
 	unlock_fat(sbi);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8970d8c..cdf552e 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -442,7 +442,7 @@ static void fat_clear_inode(struct inode *inode)
 static void fat_write_super(struct super_block *sb)
 {
 	lock_super(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	if (!(sb->s_flags & MS_RDONLY))
 		fat_clusters_flush(sb);
@@ -453,7 +453,7 @@ static int fat_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	fat_clusters_flush(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_super(sb);
 
 	return 0;
@@ -465,7 +465,7 @@ static void fat_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		fat_write_super(sb);
 
 	iput(sbi->fat_inode);
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index 2c16316..bff476a 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -432,7 +432,7 @@ out:
 		if (inode->i_ino < HFS_FIRSTUSER_CNID)
 			set_bit(HFS_FLG_ALT_MDB_DIRTY, &HFS_SB(sb)->flags);
 		set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 	return res;
 
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 052387e..3b6631f 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -251,7 +251,7 @@ static inline const char *hfs_mdb_name(struct super_block *sb)
 static inline void hfs_bitmap_dirty(struct super_block *sb)
 {
 	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 }
 
 static inline void hfs_buffer_sync(struct buffer_head *bh)
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index a1cbff2..b87dcf0 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -198,7 +198,7 @@ struct inode *hfs_new_inode(struct inode *dir, struct qstr *name, int mode)
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 	set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	return inode;
 }
@@ -213,7 +213,7 @@ void hfs_delete_inode(struct inode *inode)
 		if (HFS_I(inode)->cat_key.ParID == cpu_to_be32(HFS_ROOT_CNID))
 			HFS_SB(sb)->root_dirs--;
 		set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		return;
 	}
 	HFS_SB(sb)->file_count--;
@@ -226,7 +226,7 @@ void hfs_delete_inode(struct inode *inode)
 		}
 	}
 	set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 }
 
 void hfs_inode_read_fork(struct inode *inode, struct hfs_extent *ext,
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 6f833dc..2a3d293 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -50,7 +50,7 @@ MODULE_LICENSE("GPL");
 static void hfs_write_super(struct super_block *sb)
 {
 	lock_super(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	/* sync everything to the buffers */
 	if (!(sb->s_flags & MS_RDONLY))
@@ -62,7 +62,7 @@ static int hfs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	hfs_mdb_commit(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_super(sb);
 
 	return 0;
@@ -79,7 +79,7 @@ static void hfs_put_super(struct super_block *sb)
 {
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		hfs_write_super(sb);
 	hfs_mdb_close(sb);
 	/* release the MDB's resources */
diff --git a/fs/hfsplus/bitmap.c b/fs/hfsplus/bitmap.c
index ea30afc..345b0e3 100644
--- a/fs/hfsplus/bitmap.c
+++ b/fs/hfsplus/bitmap.c
@@ -151,7 +151,7 @@ done:
 	kunmap(page);
 	*max = offset + (curr - pptr) * 32 + i - start;
 	HFSPLUS_SB(sb).free_blocks -= *max;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	dprint(DBG_BITMAP, "-> %u,%u\n", start, *max);
 out:
 	mutex_unlock(&HFSPLUS_SB(sb).alloc_file->i_mutex);
@@ -225,7 +225,7 @@ out:
 	set_page_dirty(page);
 	kunmap(page);
 	HFSPLUS_SB(sb).free_blocks += len;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mutex_unlock(&HFSPLUS_SB(sb).alloc_file->i_mutex);
 
 	return 0;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 5f40236..71868b5 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -305,7 +305,7 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	return 0;
 }
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 1bcf597..76fe933 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -333,7 +333,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
 		HFSPLUS_SB(sb).file_count++;
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	return inode;
 }
@@ -344,7 +344,7 @@ void hfsplus_delete_inode(struct inode *inode)
 
 	if (S_ISDIR(inode->i_mode)) {
 		HFSPLUS_SB(sb).folder_count--;
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		return;
 	}
 	HFSPLUS_SB(sb).file_count--;
@@ -357,7 +357,7 @@ void hfsplus_delete_inode(struct inode *inode)
 		inode->i_size = 0;
 		hfsplus_file_truncate(inode);
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 }
 
 void hfsplus_inode_read_fork(struct inode *inode, struct hfsplus_fork_raw *fork)
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 9fc3af0..bedce7e 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -104,7 +104,7 @@ static int hfsplus_write_inode(struct inode *inode, int unused)
 	case HFSPLUS_EXT_CNID:
 		if (vhdr->ext_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			mark_sb_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->ext_file);
 		hfs_btree_write(HFSPLUS_SB(inode->i_sb).ext_tree);
@@ -112,7 +112,7 @@ static int hfsplus_write_inode(struct inode *inode, int unused)
 	case HFSPLUS_CAT_CNID:
 		if (vhdr->cat_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			mark_sb_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->cat_file);
 		hfs_btree_write(HFSPLUS_SB(inode->i_sb).cat_tree);
@@ -120,21 +120,21 @@ static int hfsplus_write_inode(struct inode *inode, int unused)
 	case HFSPLUS_ALLOC_CNID:
 		if (vhdr->alloc_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			mark_sb_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->alloc_file);
 		break;
 	case HFSPLUS_START_CNID:
 		if (vhdr->start_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			mark_sb_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->start_file);
 		break;
 	case HFSPLUS_ATTR_CNID:
 		if (vhdr->attr_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			mark_sb_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->attr_file);
 		hfs_btree_write(HFSPLUS_SB(inode->i_sb).attr_tree);
@@ -159,7 +159,7 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 	dprint(DBG_SUPER, "hfsplus_write_super\n");
 
 	lock_super(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	vhdr->free_blocks = cpu_to_be32(HFSPLUS_SB(sb).free_blocks);
 	vhdr->next_alloc = cpu_to_be32(HFSPLUS_SB(sb).next_alloc);
@@ -200,7 +200,7 @@ static void hfsplus_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		hfsplus_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static void hfsplus_put_super(struct super_block *sb)
@@ -211,7 +211,7 @@ static void hfsplus_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		hfsplus_write_super(sb);
 	if (!(sb->s_flags & MS_RDONLY) && HFSPLUS_SB(sb).s_vhdr) {
 		struct hfsplus_vh *vhdr = HFSPLUS_SB(sb).s_vhdr;
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index a7f03b7..91905e9 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -143,7 +143,7 @@ void jffs2_nor_wbuf_flash_cleanup(struct jffs2_sb_info *c);
 /* erase.c */
 static inline void jffs2_erase_pending_trigger(struct jffs2_sb_info *c)
 {
-	OFNI_BS_2SFFJ(c)->s_dirt = 1;
+	mark_sb_dirty(OFNI_BS_2SFFJ(c));
 }
 
 /* background.c */
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 07a22ca..1308174 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -58,7 +58,7 @@ static void jffs2_write_super(struct super_block *sb)
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
 	lock_super(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		D1(printk(KERN_DEBUG "jffs2_write_super()\n"));
@@ -195,7 +195,7 @@ static void jffs2_put_super (struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		jffs2_write_super(sb);
 
 	mutex_lock(&c->alloc_sem);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index aa97754..f857eaa 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2052,7 +2052,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	if (update_sr) {
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
-		sbi->s_super->s_dirt = 1;
+		mark_sb_dirty(sbi->s_super);
 
 		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8e2ec43..4eb2576 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -300,7 +300,7 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 		nilfs->ns_sbwtime[1] = t;
 	}
-	sbi->s_super->s_dirt = 0;
+	mark_sb_clean(sbi->s_super);
 	return nilfs_sync_super(sbi, dupsb);
 }
 
@@ -311,7 +311,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		nilfs_write_super(sb);
 
 	nilfs_detach_segment_constructor(sbi);
@@ -341,17 +341,17 @@ static void nilfs_put_super(struct super_block *sb)
  * @sb: super_block
  *
  * nilfs_write_super() gets a fs-dependent lock, writes super block(s), and
- * clears s_dirt.  This function is called in the section protected by
- * lock_super().
+ * clears the superblock.  This function is called in the section protected
+ * by lock_super().
  *
- * The s_dirt flag is managed by each filesystem and we protect it by ns_sem
- * of the struct the_nilfs.  Lock order must be as follows:
+ * The super block s_dirt flag is managed by each filesystem and we protect
+ * it by ns_sem of the struct the_nilfs.  Lock order must be as follows:
  *
  *   1. lock_super()
  *   2.    down_write(&nilfs->ns_sem)
  *
- * Inside NILFS, locking ns_sem is enough to protect s_dirt and the buffer
- * of the super block (nilfs->ns_sbp[]).
+ * Inside NILFS, locking ns_sem is enough to protect the super block s_dirt
+ * and the buffer of the super block (nilfs->ns_sbp[]).
  *
  * In most cases, VFS functions call lock_super() before calling these
  * methods.  So we must be careful not to bring on deadlocks when using
@@ -380,7 +380,7 @@ static void nilfs_write_super(struct super_block *sb)
 		dupsb = sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
 		nilfs_commit_super(sbi, dupsb);
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	up_write(&nilfs->ns_sem);
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 8b88898..a275939 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -330,7 +330,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			goto failed;
 		}
 		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED)
-			sbi->s_super->s_dirt = 1;
+			mark_sb_dirty(sbi->s_super);
 	}
 
 	set_nilfs_loaded(nilfs);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 77f5bb7..1197c30 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3259,7 +3259,7 @@ int journal_mark_dirty(struct reiserfs_transaction_handle *th,
 			       th->t_trans_id, journal->j_trans_id);
 	}
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	prepared = test_clear_buffer_journal_prepared(bh);
 	clear_buffer_journal_restore_dirty(bh);
@@ -3554,7 +3554,7 @@ int reiserfs_flush_old_commits(struct super_block *sb)
 			do_journal_end(&th, sb, 1, COMMIT_NOW | WAIT);
 		}
 	}
-	return sb->s_dirt;
+	return is_sb_dirty(sb);
 }
 
 /*
@@ -3984,7 +3984,7 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 	 ** it tells us if we should continue with the journal_end, or just return
 	 */
 	if (!check_journal_end(th, sb, nblocks, flags)) {
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		wake_queued_writers(sb);
 		reiserfs_async_progress_wait(sb);
 		goto out;
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index 18b315d..265bed0 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -201,7 +201,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 					  (bmap_nr_new - bmap_nr)));
 	PUT_SB_BLOCK_COUNT(s, block_count_new);
 	PUT_SB_BMAP_NR(s, bmap_would_wrap(bmap_nr_new) ? : bmap_nr_new);
-	s->s_dirt = 1;
+	mark_sb_dirty(s);
 
 	journal_mark_dirty(&th, s, SB_BUFFER_WITH_SB(s));
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index d3aeb06..a026cad 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -71,8 +71,8 @@ static int reiserfs_sync_fs(struct super_block *s, int wait)
 	if (!journal_begin(&th, s, 1))
 		if (!journal_end_sync(&th, s, 1))
 			reiserfs_flush_old_commits(s);
-	s->s_dirt = 0;	/* Even if it's not true.
-			 * We'll loop forever in sync_supers otherwise */
+	mark_sb_clean(s); /* Even if it's not true.
+			   * We'll loop forever in sync_supers otherwise */
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -98,7 +98,7 @@ static int reiserfs_freeze(struct super_block *s)
 			journal_end_sync(&th, s, 1);
 		}
 	}
-	s->s_dirt = 0;
+	mark_sb_clean(s);
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -468,7 +468,7 @@ static void reiserfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (s->s_dirt)
+	if (is_sb_dirty(s))
 		reiserfs_write_super(s);
 
 	/* change file system state to current state if it was mounted with read-write permissions */
@@ -1287,7 +1287,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	err = journal_end(&th, s, 10);
 	if (err)
 		goto out_err;
-	s->s_dirt = 0;
+	mark_sb_clean(s);
 
 	if (!(*mount_flags & MS_RDONLY)) {
 		finish_unfinished(s);
diff --git a/fs/super.c b/fs/super.c
index 0d22ce3..b536dda 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -412,12 +412,12 @@ void sync_supers(void)
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (sb->s_op->write_super && sb->s_dirt) {
+		if (sb->s_op->write_super && is_sb_dirty(sb)) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
 
 			down_read(&sb->s_umount);
-			if (sb->s_root && sb->s_dirt)
+			if (sb->s_root && is_sb_dirty(sb))
 				sb->s_op->write_super(sb);
 			up_read(&sb->s_umount);
 
diff --git a/fs/sync.c b/fs/sync.c
index dd20002..ba3fe8f 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -160,7 +160,7 @@ int file_fsync(struct file *filp, struct dentry *dentry, int datasync)
 
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
-	if (sb->s_dirt && sb->s_op->write_super)
+	if (is_sb_dirty(sb) && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 
 	/* .. finally sync the buffers to disk */
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 9824743..7cf8d82 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -60,7 +60,7 @@ static void sysv_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		sysv_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
@@ -70,7 +70,7 @@ static int sysv_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
 	if (!(*flags & MS_RDONLY))
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -79,7 +79,7 @@ static void sysv_put_super(struct super_block *sb)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		sysv_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 5a903da..f0d3679 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -347,7 +347,7 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		sb->s_flags |= MS_RDONLY;
 	if (sbi->s_truncate)
 		sb->s_root->d_op = &sysv_dentry_operations;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	return 1;
 }
 
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 53786eb..1467ff2 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -118,7 +118,7 @@ static inline void dirty_sb(struct super_block *sb)
 	mark_buffer_dirty(sbi->s_bh1);
 	if (sbi->s_bh1 != sbi->s_bh2)
 		mark_buffer_dirty(sbi->s_bh2);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 }
 
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 6832135..62b7774 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1912,7 +1912,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	sb->s_op = &udf_sb_ops;
 	sb->s_export_op = &udf_export_ops;
 	sb->dq_op = NULL;
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	sb->s_magic = UDF_SUPER_MAGIC;
 	sb->s_time_gran = 1000;
 
@@ -2039,7 +2039,7 @@ static void udf_error(struct super_block *sb, const char *function,
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		/* mark sb error */
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
@@ -2099,7 +2099,7 @@ static int udf_sync_fs(struct super_block *sb, int wait)
 		 * the buffer for IO
 		 */
 		mark_buffer_dirty(sbi->s_lvid_bh);
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 		sbi->s_lvid_dirty = 0;
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 8d46f42..4305bcb 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -119,7 +119,7 @@ static inline void udf_updated_lvid(struct super_block *sb)
 	WARN_ON_ONCE(((struct logicalVolIntegrityDesc *)
 		     bh->b_data)->integrityType !=
 		     cpu_to_le32(LVID_INTEGRITY_TYPE_OPEN));
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	UDF_SB(sb)->s_lvid_dirty = 1;
 }
 
diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 54c16ec..71a6971 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -122,7 +122,7 @@ void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	
 	unlock_super (sb);
 	UFSD("EXIT\n");
@@ -223,7 +223,7 @@ do_more:
 		goto do_more;
 	}
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 	return;
@@ -571,7 +571,7 @@ static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	UFSD("EXIT, fragment %llu\n", (unsigned long long)fragment);
 	
@@ -698,7 +698,7 @@ succed:
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	result += cgno * uspi->s_fpg;
 	UFSD("EXIT3, result %llu\n", (unsigned long long)result);
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index 3527c00..b33cfe6 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -124,7 +124,7 @@ void ufs_free_inode (struct inode * inode)
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
 	
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 }
@@ -300,7 +300,7 @@ cg_found:
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode->i_mode = mode;
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 5faed79..6bb1a62 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -237,7 +237,7 @@ void ufs_error (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
 	va_start (args, fmt);
@@ -270,7 +270,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -1149,7 +1149,7 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 		ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 	ufs_put_cstotal(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	UFSD("EXIT\n");
 	unlock_kernel();
@@ -1163,7 +1163,7 @@ static void ufs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static void ufs_put_super(struct super_block *sb)
@@ -1172,7 +1172,7 @@ static void ufs_put_super(struct super_block *sb)
 		
 	UFSD("ENTER\n");
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		ufs_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY))
@@ -1242,7 +1242,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 			ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 		ubh_mark_buffer_dirty (USPI_UBH(uspi));
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 		sb->s_flags |= MS_RDONLY;
 	} else {
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8f0478c..d98d8d1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1789,6 +1789,23 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 
+/*
+ * Note, VFS does not provide any protection for the super block clean/dirty
+ * state. File-systems should take care of this.
+ */
+static inline void mark_sb_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+static inline void mark_sb_clean(struct super_block *sb)
+{
+	sb->s_dirt = 0;
+}
+static inline int is_sb_dirty(struct super_block *sb)
+{
+	return sb->s_dirt;
+}
+
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbZE0LNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbZE0LNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759897AbZE0LMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:12 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49410 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759788AbZE0LMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:07 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:05:41 +0300
Message-Id: <20090527130541.4913.73978.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/19] EXT4: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:11:44.0510 (UTC) FILETIME=[EB52E9E0:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] EXT4: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/ext4/balloc.c  |    2 +-
 fs/ext4/ialloc.c  |    4 ++--
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    4 ++--
 fs/ext4/resize.c  |    4 ++--
 fs/ext4/super.c   |   16 ++++++++--------
 fs/ext4/xattr.c   |    2 +-
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 53c72ad..ccb83ff 100644
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
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f18e0a0..949e4a7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -297,7 +297,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (!fatal)
 		fatal = err;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, fatal);
@@ -968,7 +968,7 @@ got:
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e91f978..743ca39 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4598,7 +4598,7 @@ static int ext4_do_update_inode(handle_t *handle,
 			ext4_update_dynamic_rev(sb);
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
-			sb->s_dirt = 1;
+			mark_sb_dirty(sb);
 			ext4_handle_sync(handle);
 			err = ext4_handle_dirty_metadata(handle, inode,
 					EXT4_SB(sb)->s_sbh);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f871677..191cf37 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3054,7 +3054,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	brelse(bitmap_bh);
 	return err;
 }
@@ -4909,7 +4909,7 @@ do_more:
 		put_bh(bitmap_bh);
 		goto do_more;
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 546c7dd..323d741 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -945,7 +945,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	}
 
 	ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 exit_journal:
 	unlock_super(sb);
@@ -1076,7 +1076,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	}
 	ext4_blocks_count_set(es, o_blocks_count + add);
 	ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	unlock_super(sb);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d789833..017052a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -566,7 +566,7 @@ static void ext4_put_super(struct super_block *sb)
 
 	lock_super(sb);
 	lock_kernel();
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		ext4_write_super_locked(sb);
 
 	ext4_mb_release(sb);
@@ -2482,7 +2482,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #else
 		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 
 	if (sbi->s_blocks_per_group > blocksize * 8) {
@@ -3117,7 +3117,7 @@ static int ext4_load_journal(struct super_block *sb,
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
 		es->s_journal_dev = cpu_to_le32(journal_devnum);
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 
 		/* Make sure we flush the recovery flag to disk. */
 		ext4_commit_super(sb, es, 1);
@@ -3199,7 +3199,7 @@ static void ext4_mark_recovery_complete(struct super_block *sb,
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 		ext4_commit_super(sb, es, 1);
 	}
 	unlock_super(sb);
@@ -3261,7 +3261,7 @@ int ext4_force_commit(struct super_block *sb)
 
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 		ret = ext4_journal_force_commit(journal);
 	}
 
@@ -3279,7 +3279,7 @@ static void ext4_write_super_locked(struct super_block *sb)
 	if (EXT4_SB(sb)->s_journal) {
 		if (mutex_trylock(&sb->s_lock) != 0)
 			BUG();
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 	} else {
 		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
 	}
@@ -3298,7 +3298,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	tid_t target;
 
 	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	if (EXT4_SB(sb)->s_journal) {
 		if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal,
 					      &target)) {
@@ -3320,7 +3320,7 @@ static int ext4_freeze(struct super_block *sb)
 {
 	int error = 0;
 	journal_t *journal;
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		journal = EXT4_SB(sb)->s_journal;
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
-- 
1.6.0.6


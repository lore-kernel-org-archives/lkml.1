Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZGIG7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZGIG7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758949AbZGIG6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:58:49 -0400
Received: from smtp.nokia.com ([192.100.122.233]:29996 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802AbZGIG6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:58:45 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:49:04 +0300
Message-Id: <20090709084904.12122.54575.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 06/18] EXT4: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:58:33.0588 (UTC) FILETIME=[AC976B40:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ext4/balloc.c  |    2 +-
 fs/ext4/file.c    |    2 +-
 fs/ext4/ialloc.c  |    4 ++--
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    4 ++--
 fs/ext4/resize.c  |    4 ++--
 fs/ext4/super.c   |    6 +++---
 fs/ext4/xattr.c   |    2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

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
-- 
1.6.0.6


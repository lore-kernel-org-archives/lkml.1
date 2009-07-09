Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbZGIHAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbZGIHAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbZGIG6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:58:51 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41615 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbZGIG6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:58:48 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:48:57 +0300
Message-Id: <20090709084857.12122.38427.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 05/18] EXT2: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:58:28.0982 (UTC) FILETIME=[A9D89960:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ext2/balloc.c |    4 ++--
 fs/ext2/ialloc.c |    4 ++--
 fs/ext2/super.c  |   10 +++++-----
 fs/ext2/xattr.c  |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

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
 
-- 
1.6.0.6


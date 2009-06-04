Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbZFDIxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbZFDIxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbZFDItv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:51 -0400
Received: from smtp.nokia.com ([192.100.122.230]:56829 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbZFDIt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:27 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH v2 08/17] HFS: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:45 +0300
Message-Id: <1244112114-23144-9-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:40.0158 (UTC) FILETIME=[41F4BFE0:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/hfs/extent.c |    2 +-
 fs/hfs/hfs_fs.h |    2 +-
 fs/hfs/inode.c  |    6 +++---
 fs/hfs/super.c  |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

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
index 3aac417..6b84117 100644
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
@@ -69,7 +69,7 @@ static void hfs_put_super(struct super_block *sb)
 {
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		hfs_write_super(sb);
 	hfs_mdb_close(sb);
 	/* release the MDB's resources */
-- 
1.6.0.6


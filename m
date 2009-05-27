Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbZE0LPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbZE0LPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760359AbZE0LMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64994 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760114AbZE0LML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:11 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:05:54 +0300
Message-Id: <20090527130554.4913.94724.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/19] HFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:11:57.0073 (UTC) FILETIME=[F2CFE010:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] HFS: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
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


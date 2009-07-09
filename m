Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbZGIHBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbZGIHBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbZGIG7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:59:04 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41646 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305AbZGIG7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:59:02 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:49:24 +0300
Message-Id: <20090709084924.12122.27893.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 09/18] HFSPLUS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:58:56.0435 (UTC) FILETIME=[BA359830:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/hfsplus/bitmap.c |    4 ++--
 fs/hfsplus/dir.c    |    2 +-
 fs/hfsplus/inode.c  |    6 +++---
 fs/hfsplus/super.c  |   16 ++++++++--------
 4 files changed, 14 insertions(+), 14 deletions(-)

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
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYEKSfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYEKSfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYEKSfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:35:33 -0400
Received: from mx1.riseup.net ([204.13.164.18]:50840 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbYEKSfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:35:32 -0400
From: Matthias Kaehlcke <matthias@kaehlcke.net>
Date: Sun, 11 May 2008 19:56:13 +0200
Subject: [PATCH] HFS Plus: Convert the extents_lock in a mutex
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Message-Id: <S1755341AbYEKSfd/20080511183533Z+207@vger.kernel.org>

Apple Extended HFS file system: The semaphore extents lock is used as a mutex.
Convert it to the mutex API.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 fs/hfsplus/extents.c    |   14 +++++++-------
 fs/hfsplus/hfsplus_fs.h |    3 ++-
 fs/hfsplus/inode.c      |    4 ++--
 fs/hfsplus/super.c      |    2 +-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 12e899c..fec8f61 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -199,16 +199,16 @@ int hfsplus_get_block(struct inode *inode, sector_t iblock,
 		goto done;
 	}
 
-	down(&HFSPLUS_I(inode).extents_lock);
+	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	res = hfsplus_ext_read_extent(inode, ablock);
 	if (!res) {
 		dblock = hfsplus_ext_find_block(HFSPLUS_I(inode).cached_extents, ablock -
 					     HFSPLUS_I(inode).cached_start);
 	} else {
-		up(&HFSPLUS_I(inode).extents_lock);
+		mutex_unlock(&HFSPLUS_I(inode).extents_lock);
 		return -EIO;
 	}
-	up(&HFSPLUS_I(inode).extents_lock);
+	mutex_unlock(&HFSPLUS_I(inode).extents_lock);
 
 done:
 	dprint(DBG_EXTENT, "get_block(%lu): %llu - %u\n", inode->i_ino, (long long)iblock, dblock);
@@ -355,7 +355,7 @@ int hfsplus_file_extend(struct inode *inode)
 		return -ENOSPC;
 	}
 
-	down(&HFSPLUS_I(inode).extents_lock);
+	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	if (HFSPLUS_I(inode).alloc_blocks == HFSPLUS_I(inode).first_blocks)
 		goal = hfsplus_ext_lastblock(HFSPLUS_I(inode).first_extents);
 	else {
@@ -408,7 +408,7 @@ int hfsplus_file_extend(struct inode *inode)
 			goto insert_extent;
 	}
 out:
-	up(&HFSPLUS_I(inode).extents_lock);
+	mutex_unlock(&HFSPLUS_I(inode).extents_lock);
 	if (!res) {
 		HFSPLUS_I(inode).alloc_blocks += len;
 		mark_inode_dirty(inode);
@@ -465,7 +465,7 @@ void hfsplus_file_truncate(struct inode *inode)
 	if (blk_cnt == alloc_cnt)
 		goto out;
 
-	down(&HFSPLUS_I(inode).extents_lock);
+	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	hfs_find_init(HFSPLUS_SB(sb).ext_tree, &fd);
 	while (1) {
 		if (alloc_cnt == HFSPLUS_I(inode).first_blocks) {
@@ -492,7 +492,7 @@ void hfsplus_file_truncate(struct inode *inode)
 		hfs_brec_remove(&fd);
 	}
 	hfs_find_exit(&fd);
-	up(&HFSPLUS_I(inode).extents_lock);
+	mutex_unlock(&HFSPLUS_I(inode).extents_lock);
 
 	HFSPLUS_I(inode).alloc_blocks = blk_cnt;
 out:
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 9e59537..f027a90 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -11,6 +11,7 @@
 #define _LINUX_HFSPLUS_FS_H
 
 #include <linux/fs.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include "hfsplus_raw.h"
 
@@ -154,7 +155,7 @@ struct hfsplus_sb_info {
 
 
 struct hfsplus_inode_info {
-	struct semaphore extents_lock;
+	struct mutex extents_lock;
 	u32 clump_blocks, alloc_blocks;
 	sector_t fs_blocks;
 	/* Allocation extents from catalog record or volume header */
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index d53b2af..26ccfa3 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -161,7 +161,7 @@ static struct dentry *hfsplus_file_lookup(struct inode *dir, struct dentry *dent
 
 	inode->i_ino = dir->i_ino;
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
-	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
+	mutex_init(&HFSPLUS_I(inode).extents_lock);
 	HFSPLUS_I(inode).flags = HFSPLUS_FLG_RSRC;
 
 	hfs_find_init(HFSPLUS_SB(sb).cat_tree, &fd);
@@ -314,7 +314,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
 	inode->i_nlink = 1;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
-	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
+	mutex_init(&HFSPLUS_I(inode).extents_lock);
 	atomic_set(&HFSPLUS_I(inode).opencnt, 0);
 	HFSPLUS_I(inode).flags = 0;
 	memset(HFSPLUS_I(inode).first_extents, 0, sizeof(hfsplus_extent_rec));
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index ce97a54..3859118 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -34,7 +34,7 @@ struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 		return inode;
 
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
-	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
+	mutex_init(&HFSPLUS_I(inode).extents_lock);
 	HFSPLUS_I(inode).flags = 0;
 	HFSPLUS_I(inode).rsrc_inode = NULL;
 	atomic_set(&HFSPLUS_I(inode).opencnt, 0);
-- 
1.5.5

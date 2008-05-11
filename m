Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYEKSQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYEKSQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbYEKSQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:16:45 -0400
Received: from mx1.riseup.net ([204.13.164.18]:33608 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYEKSQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:16:44 -0400
Date: Sun, 11 May 2008 20:16:37 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2/2] HFS: Convert extents_lock in a mutex
Message-ID: <20080511181637.GC21359@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	zippel@linux-m68k.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080511174331.584439618@kaehlcke.net> <20080511174334.034854531@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511174334.034854531@kaehlcke.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple Macintosh file system: The semaphore extens_lock is used as a mutex.
Convert it to the mutex API
 
Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

Index: linux-2.6/fs/hfs/btree.c
===================================================================
--- linux-2.6.orig/fs/hfs/btree.c	2008-05-11 20:11:54.000000000 +0200
+++ linux-2.6/fs/hfs/btree.c	2008-05-11 20:11:59.000000000 +0200
@@ -40,7 +40,7 @@
 	{
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 	HFS_I(tree->inode)->flags = 0;
-	init_MUTEX(&HFS_I(tree->inode)->extents_lock);
+	mutex_init(&HFS_I(tree->inode)->extents_lock);
 	switch (id) {
 	case HFS_EXT_CNID:
 		hfs_inode_read_fork(tree->inode, mdb->drXTExtRec, mdb->drXTFlSize,
Index: linux-2.6/fs/hfs/extent.c
===================================================================
--- linux-2.6.orig/fs/hfs/extent.c	2008-05-11 20:11:54.000000000 +0200
+++ linux-2.6/fs/hfs/extent.c	2008-05-11 20:11:59.000000000 +0200
@@ -343,16 +343,16 @@
 		goto done;
 	}
 
-	down(&HFS_I(inode)->extents_lock);
+	mutex_lock(&HFS_I(inode)->extents_lock);
 	res = hfs_ext_read_extent(inode, ablock);
 	if (!res)
 		dblock = hfs_ext_find_block(HFS_I(inode)->cached_extents,
 					    ablock - HFS_I(inode)->cached_start);
 	else {
-		up(&HFS_I(inode)->extents_lock);
+		mutex_unlock(&HFS_I(inode)->extents_lock);
 		return -EIO;
 	}
-	up(&HFS_I(inode)->extents_lock);
+	mutex_unlock(&HFS_I(inode)->extents_lock);
 
 done:
 	map_bh(bh_result, sb, HFS_SB(sb)->fs_start +
@@ -375,7 +375,7 @@
 	u32 start, len, goal;
 	int res;
 
-	down(&HFS_I(inode)->extents_lock);
+	mutex_lock(&HFS_I(inode)->extents_lock);
 	if (HFS_I(inode)->alloc_blocks == HFS_I(inode)->first_blocks)
 		goal = hfs_ext_lastblock(HFS_I(inode)->first_extents);
 	else {
@@ -425,7 +425,7 @@
 			goto insert_extent;
 	}
 out:
-	up(&HFS_I(inode)->extents_lock);
+	mutex_unlock(&HFS_I(inode)->extents_lock);
 	if (!res) {
 		HFS_I(inode)->alloc_blocks += len;
 		mark_inode_dirty(inode);
@@ -487,7 +487,7 @@
 	if (blk_cnt == alloc_cnt)
 		goto out;
 
-	down(&HFS_I(inode)->extents_lock);
+	mutex_lock(&HFS_I(inode)->extents_lock);
 	hfs_find_init(HFS_SB(sb)->ext_tree, &fd);
 	while (1) {
 		if (alloc_cnt == HFS_I(inode)->first_blocks) {
@@ -514,7 +514,7 @@
 		hfs_brec_remove(&fd);
 	}
 	hfs_find_exit(&fd);
-	up(&HFS_I(inode)->extents_lock);
+	mutex_unlock(&HFS_I(inode)->extents_lock);
 
 	HFS_I(inode)->alloc_blocks = blk_cnt;
 out:
Index: linux-2.6/fs/hfs/hfs_fs.h
===================================================================
--- linux-2.6.orig/fs/hfs/hfs_fs.h	2008-05-11 20:11:54.000000000 +0200
+++ linux-2.6/fs/hfs/hfs_fs.h	2008-05-11 20:11:59.000000000 +0200
@@ -54,7 +54,7 @@
 	struct list_head open_dir_list;
 	struct inode *rsrc_inode;
 
-	struct semaphore extents_lock;
+	struct mutex extents_lock;
 
 	u16 alloc_blocks, clump_blocks;
 	sector_t fs_blocks;
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c	2008-05-11 20:11:54.000000000 +0200
+++ linux-2.6/fs/hfs/inode.c	2008-05-11 20:11:59.000000000 +0200
@@ -150,7 +150,7 @@
 	if (!inode)
 		return NULL;
 
-	init_MUTEX(&HFS_I(inode)->extents_lock);
+	mutex_init(&HFS_I(inode)->extents_lock);
 	INIT_LIST_HEAD(&HFS_I(inode)->open_dir_list);
 	hfs_cat_build_key(sb, (btree_key *)&HFS_I(inode)->cat_key, dir->i_ino, name);
 	inode->i_ino = HFS_SB(sb)->next_id++;
@@ -281,7 +281,7 @@
 
 	HFS_I(inode)->flags = 0;
 	HFS_I(inode)->rsrc_inode = NULL;
-	init_MUTEX(&HFS_I(inode)->extents_lock);
+	mutex_init(&HFS_I(inode)->extents_lock);
 	INIT_LIST_HEAD(&HFS_I(inode)->open_dir_list);
 
 	/* Initialize the inode */

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

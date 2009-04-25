Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbZDYBey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbZDYBey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZDYB3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:44593 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZDYB2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:55 -0400
Message-Id: <20090425012212.676943083@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:45 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 25/27] fs: icache lock lru/writeback lists
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, wb_inode_list_lock, to protect i_list and various lists
which the inode can be put onto.

XXX: haven't audited ocfs2
---
 fs/fs-writeback.c         |   41 ++++++++++++++++++++++++++++++++++------
 fs/hugetlbfs/inode.c      |   11 +++++++---
 fs/inode.c                |   47 ++++++++++++++++++++++++++++++++++++----------
 include/linux/writeback.h |    1 
 4 files changed, 81 insertions(+), 19 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -165,7 +165,9 @@ void __mark_inode_dirty(struct inode *in
 		 */
 		if (!was_dirty) {
 			inode->dirtied_when = jiffies;
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &sb->s_dirty);
+			spin_unlock(&wb_inode_list_lock);
 		}
 	}
 out:
@@ -195,12 +197,12 @@ static void redirty_tail(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	if (!list_empty(&sb->s_dirty)) {
 		struct inode *tail_inode;
 
 		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (time_before(inode->dirtied_when,
-				tail_inode->dirtied_when))
+		if (time_before(inode->dirtied_when, tail_inode->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
 	list_move(&inode->i_list, &sb->s_dirty);
@@ -211,6 +213,7 @@ static void redirty_tail(struct inode *i
  */
 static void requeue_io(struct inode *inode)
 {
+	assert_spin_locked(&wb_inode_list_lock);
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
 }
 
@@ -245,6 +248,7 @@ static void move_expired_inodes(struct l
 			       struct list_head *dispatch_queue,
 				unsigned long *older_than_this)
 {
+	assert_spin_locked(&wb_inode_list_lock);
 	while (!list_empty(delaying_queue)) {
 		struct inode *inode = list_entry(delaying_queue->prev,
 						struct inode, i_list);
@@ -299,6 +303,7 @@ __sync_single_inode(struct inode *inode,
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY;
 
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
@@ -319,6 +324,7 @@ __sync_single_inode(struct inode *inode,
 
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
@@ -424,12 +430,14 @@ __writeback_single_inode(struct inode *i
 
 		wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 		do {
+			spin_unlock(&wb_inode_list_lock);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			__wait_on_bit(wqh, &wq, inode_wait,
 							TASK_UNINTERRUPTIBLE);
 			spin_lock(&inode_lock);
 			spin_lock(&inode->i_lock);
+			spin_lock(&wb_inode_list_lock);
 		} while (inode->i_state & I_SYNC);
 	}
 	return __sync_single_inode(inode, wbc);
@@ -467,6 +475,8 @@ void generic_sync_sb_inodes(struct super
 	int sync = wbc->sync_mode == WB_SYNC_ALL;
 
 	spin_lock(&inode_lock);
+again:
+	spin_lock(&wb_inode_list_lock);
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		queue_io(sb, wbc->older_than_this);
 
@@ -477,6 +487,11 @@ void generic_sync_sb_inodes(struct super
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		long pages_skipped;
 
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&wb_inode_list_lock);
+			goto again;
+		}
+
 		if (!bdi_cap_writeback_dirty(bdi)) {
 			redirty_tail(inode);
 			if (sb_is_blkdev_sb(sb)) {
@@ -484,6 +499,7 @@ void generic_sync_sb_inodes(struct super
 				 * Dirty memory-backed blockdev: the ramdisk
 				 * driver does this.  Skip just this inode
 				 */
+				spin_unlock(&inode->i_lock);
 				continue;
 			}
 			/*
@@ -491,28 +507,34 @@ void generic_sync_sb_inodes(struct super
 			 * than the kernel-internal bdev filesystem.  Skip the
 			 * entire superblock.
 			 */
+			spin_unlock(&inode->i_lock);
 			break;
 		}
 
 		if (wbc->nonblocking && bdi_write_congested(bdi)) {
 			wbc->encountered_congestion = 1;
-			if (!sb_is_blkdev_sb(sb))
+			if (!sb_is_blkdev_sb(sb)) {
+				spin_unlock(&inode->i_lock);
 				break;		/* Skip a congested fs */
+			}
 			requeue_io(inode);
+			spin_unlock(&inode->i_lock);
 			continue;		/* Skip a congested blockdev */
 		}
 
 		if (wbc->bdi && bdi != wbc->bdi) {
-			if (!sb_is_blkdev_sb(sb))
+			if (!sb_is_blkdev_sb(sb)) {
+				spin_unlock(&inode->i_lock);
 				break;		/* fs has the wrong queue */
+			}
 			requeue_io(inode);
+			spin_unlock(&inode->i_lock);
 			continue;		/* blockdev has wrong queue */
 		}
 
-		spin_lock(&inode->i_lock);
 		if (inode->i_state & I_NEW) {
-			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 
@@ -544,11 +566,13 @@ void generic_sync_sb_inodes(struct super
 			 */
 			redirty_tail(inode);
 		}
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
+		spin_lock(&wb_inode_list_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
 			break;
@@ -556,6 +580,7 @@ void generic_sync_sb_inodes(struct super
 		if (!list_empty(&sb->s_more_io))
 			wbc->more_io = 1;
 	}
+	spin_unlock(&wb_inode_list_lock);
 
 	if (sync) {
 		struct inode *inode, *old_inode = NULL;
@@ -774,7 +799,9 @@ int write_inode_now(struct inode *inode,
 	might_sleep();
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	ret = __writeback_single_inode(inode, &wbc);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
@@ -800,7 +827,9 @@ int sync_inode(struct inode *inode, stru
 
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	ret = __writeback_single_inode(inode, wbc);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	return ret;
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -393,8 +393,11 @@ static void hugetlbfs_forget_inode(struc
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &inode_unused);
+			spin_unlock(&wb_inode_list_lock);
+		}
 		atomic_inc(&inodes_stat.nr_unused);
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
 			spin_unlock(&inode_lock);
@@ -412,13 +415,15 @@ static void hugetlbfs_forget_inode(struc
 		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_state &= ~I_WILL_FREE;
-		spin_unlock(&inode->i_lock);
-		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
+		spin_unlock(&inode->i_lock);
+		atomic_dec(&inodes_stat.nr_unused);
 	}
+	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
+	spin_unlock(&wb_inode_list_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -84,6 +84,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(wb_inode_list_lock);
 DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
@@ -277,8 +278,11 @@ void __iget(struct inode * inode)
 	if (inode->i_count > 1)
 		return;
 
-	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+		spin_lock(&wb_inode_list_lock);
 		list_move(&inode->i_list, &inode_in_use);
+		spin_unlock(&wb_inode_list_lock);
+	}
 	atomic_dec(&inodes_stat.nr_unused);
 }
 
@@ -381,7 +385,9 @@ static int invalidate_list(struct list_h
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, dispose);
+			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
@@ -460,6 +466,8 @@ static void prune_icache(int nr_to_scan)
 
 	mutex_lock(&iprune_mutex);
 	spin_lock(&inode_lock);
+again:
+	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
@@ -468,13 +476,17 @@ static void prune_icache(int nr_to_scan)
 
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
-		spin_lock(&inode->i_lock);
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&wb_inode_list_lock);
+			goto again;
+		}
 		if (inode->i_state || inode->i_count) {
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
+			spin_unlock(&wb_inode_list_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
@@ -483,11 +495,16 @@ static void prune_icache(int nr_to_scan)
 								0, -1);
 			iput(inode);
 			spin_lock(&inode_lock);
+again2:
+			spin_lock(&wb_inode_list_lock);
 
 			if (inode != list_entry(inode_unused.next,
 						struct inode, i_list))
 				continue;	/* wrong inode or list_empty */
-			spin_lock(&inode->i_lock);
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				goto again2;
+			}
 			if (!can_unuse(inode)) {
 				spin_unlock(&inode->i_lock);
 				continue;
@@ -505,6 +522,7 @@ static void prune_icache(int nr_to_scan)
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lock);
+	spin_unlock(&wb_inode_list_lock);
 
 	dispose_list(&freeable);
 	mutex_unlock(&iprune_mutex);
@@ -625,7 +643,9 @@ __inode_add_to_lists(struct super_block
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
+	spin_lock(&wb_inode_list_lock);
 	list_add(&inode->i_list, &inode_in_use);
+	spin_unlock(&wb_inode_list_lock);
 	if (head) {
 		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
@@ -1223,14 +1243,16 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
+	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
+	spin_unlock(&wb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	atomic_dec(&inodes_stat.nr_inodes);
 	spin_unlock(&inode_lock);
+	atomic_dec(&inodes_stat.nr_inodes);
 
 	security_inode_delete(inode);
 
@@ -1264,8 +1286,11 @@ static void generic_forget_inode(struct
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &inode_unused);
+			spin_unlock(&wb_inode_list_lock);
+		}
 		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
@@ -1289,14 +1314,16 @@ static void generic_forget_inode(struct
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
 	}
+	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
+	spin_unlock(&wb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
-	atomic_dec(&inodes_stat.nr_inodes);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
+	atomic_dec(&inodes_stat.nr_inodes);
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
 	clear_inode(inode);
@@ -1354,17 +1381,17 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
-retry:
+retry1:
 		spin_lock(&inode->i_lock);
 		if (inode->i_count == 1) {
 			if (!spin_trylock(&inode_lock)) {
+retry2:
 				spin_unlock(&inode->i_lock);
-				goto retry;
+				goto retry1;
 			}
 			if (!spin_trylock(&sb_inode_list_lock)) {
 				spin_unlock(&inode_lock);
-				spin_unlock(&inode->i_lock);
-				goto retry;
+				goto retry2;
 			}
 			inode->i_count--;
 			iput_final(inode);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -11,6 +11,7 @@ struct backing_dev_info;
 
 extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
+extern spinlock_t wb_inode_list_lock;
 extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;



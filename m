Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbZIDHBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbZIDHBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbZIDHBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:01:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:56560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547AbZIDG6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:41 -0400
Message-Id: <20090904065538.229463090@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:08 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 27/33] fs: icache remove inode_lock
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global inode_lock
---
 fs/buffer.c                 |    2 -
 fs/drop_caches.c            |    4 --
 fs/fs-writeback.c           |   23 +--------------
 fs/hugetlbfs/inode.c        |    6 ----
 fs/inode.c                  |   65 ++------------------------------------------
 fs/notify/inode_mark.c      |   14 +++++----
 fs/notify/inotify/inotify.c |   16 ++++++----
 fs/quota/dquot.c            |    6 ----
 include/linux/writeback.h   |    1 
 9 files changed, 26 insertions(+), 111 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -1145,7 +1145,7 @@ __getblk_slow(struct block_device *bdev,
  * inode list.
  *
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
- * mapping->tree_lock and the global inode_lock.
+ * and mapping->tree_lock.
  */
 void mark_buffer_dirty(struct buffer_head *bh)
 {
Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -16,7 +16,6 @@ static void drop_pagecache_sb(struct sup
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
@@ -28,15 +27,12 @@ static void drop_pagecache_sb(struct sup
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	iput(toput_inode);
 }
 
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -139,7 +139,6 @@ void __mark_inode_dirty(struct inode *in
 	if (unlikely(block_dump))
 		block_dump___mark_inode_dirty(inode);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
@@ -178,7 +177,6 @@ void __mark_inode_dirty(struct inode *in
 	}
 out:
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 
 EXPORT_SYMBOL(__mark_inode_dirty);
@@ -226,7 +224,7 @@ static void requeue_io(struct inode *ino
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
 	 */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
@@ -295,9 +293,7 @@ static void inode_wait_for_writeback(str
 	do {
 		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		spin_lock(&wb_inode_list_lock);
 	} while (inode->i_state & I_SYNC);
@@ -358,7 +354,6 @@ writeback_single_inode(struct inode *ino
 
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
 
@@ -375,7 +370,6 @@ writeback_single_inode(struct inode *ino
 			ret = err;
 	}
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	inode->i_state &= ~I_SYNC;
@@ -478,7 +472,6 @@ void generic_sync_sb_inodes(struct super
 	const unsigned long start = jiffies;	/* livelock avoidance */
 	int sync = wbc->sync_mode == WB_SYNC_ALL;
 
-	spin_lock(&inode_lock);
 again:
 	spin_lock(&wb_inode_list_lock);
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
@@ -572,10 +565,8 @@ again:
 		}
 		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
-		spin_lock(&inode_lock);
 		spin_lock(&wb_inode_list_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
@@ -610,7 +601,6 @@ again:
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
-			spin_unlock(&inode_lock);
 			/*
 			 * We hold a reference to 'inode' so it couldn't have
 			 * been removed from s_inodes list while we dropped the
@@ -626,14 +616,11 @@ again:
 
 			cond_resched();
 
-			spin_lock(&inode_lock);
 			spin_lock(&sb_inode_list_lock);
 		}
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 		iput(old_inode);
-	} else
-		spin_unlock(&inode_lock);
+	}
 
 	return;		/* Leave any unwritten inodes on s_io */
 }
@@ -752,13 +739,11 @@ int write_inode_now(struct inode *inode,
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, &wbc);
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	if (sync)
 		inode_sync_wait(inode);
 	return ret;
@@ -780,13 +765,11 @@ int sync_inode(struct inode *inode, stru
 {
 	int ret;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, wbc);
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
@@ -827,13 +810,11 @@ int generic_osync_inode(struct inode *in
 			err = err2;
 	}
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if ((inode->i_state & I_DIRTY) &&
 	    ((what & OSYNC_INODE) || (inode->i_state & I_DIRTY_DATASYNC)))
 		need_write_inode_now = 1;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	if (need_write_inode_now) {
 		err2 = write_inode_now(inode, 1);
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -379,7 +379,7 @@ static void hugetlbfs_delete_inode(struc
 	clear_inode(inode);
 }
 
-static void hugetlbfs_forget_inode(struct inode *inode) __releases(inode_lock)
+static void hugetlbfs_forget_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
@@ -393,20 +393,17 @@ static void hugetlbfs_forget_inode(struc
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
-			spin_unlock(&inode_lock);
 			return;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 		/*
 		 * write_inode_now is a noop as we set BDI_CAP_NO_WRITEBACK
 		 * in our backing_dev_info.
 		 */
 		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
@@ -424,7 +421,6 @@ static void hugetlbfs_forget_inode(struc
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	atomic_dec(&inodes_stat.nr_unused);
 	truncate_hugepages(inode, 0);
 	clear_inode(inode);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -84,7 +84,6 @@ static struct hlist_head *inode_hashtabl
  * NOTE! You also have to own the lock if you change
  * the i_state of an inode while it is in use..
  */
-DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
 DEFINE_SPINLOCK(inode_hash_lock);
@@ -362,16 +361,14 @@ static void dispose_list(struct list_hea
 			truncate_inode_pages(&inode->i_data, 0);
 		clear_inode(inode);
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
 		list_del_init(&inode->i_sb_list);
-		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&sb_inode_list_lock);
 
 		wake_up_inode(inode);
 		destroy_inode(inode);
@@ -399,7 +396,6 @@ static int invalidate_list(struct list_h
 		 * change during umount anymore, and because iprune_mutex keeps
 		 * shrink_icache_memory() away.
 		 */
-		cond_resched_lock(&inode_lock);
 		cond_resched_lock(&sb_inode_list_lock);
 
 		next = next->next;
@@ -444,13 +440,11 @@ int invalidate_inodes(struct super_block
 	LIST_HEAD(throw_away);
 
 	mutex_lock(&iprune_mutex);
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
 	mutex_unlock(&iprune_mutex);
@@ -493,7 +487,6 @@ static void prune_icache(int nr_to_scan)
 	unsigned long reap = 0;
 
 	mutex_lock(&iprune_mutex);
-	spin_lock(&inode_lock);
 again:
 	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
@@ -517,12 +510,10 @@ again:
 			spin_unlock(&wb_inode_list_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&inode_lock);
 again2:
 			spin_lock(&wb_inode_list_lock);
 
@@ -549,7 +540,6 @@ again2:
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&inode_lock);
 	spin_unlock(&wb_inode_list_lock);
 
 	dispose_list(&freeable);
@@ -700,12 +690,10 @@ void inode_add_to_lists(struct super_blo
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, head, inode);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
 
@@ -731,18 +719,14 @@ struct inode *new_inode(struct super_blo
 	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
-	spin_lock_prefetch(&inode_lock);
-
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_ino = atomic_inc_return(&last_ino);
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 	}
 	return inode;
 }
@@ -799,7 +783,6 @@ static struct inode *get_new_inode(struc
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
@@ -811,7 +794,6 @@ static struct inode *get_new_inode(struc
 			inode->i_state = I_LOCK|I_NEW;
 			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -826,7 +808,6 @@ static struct inode *get_new_inode(struc
 		 */
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -836,7 +817,6 @@ static struct inode *get_new_inode(struc
 set_failed:
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -854,7 +834,6 @@ static struct inode *get_new_inode_fast(
 	if (inode) {
 		struct inode *old;
 
-		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
@@ -864,7 +843,6 @@ static struct inode *get_new_inode_fast(
 			inode->i_state = I_LOCK|I_NEW;
 			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -879,7 +857,6 @@ static struct inode *get_new_inode_fast(
 		 */
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -929,7 +906,6 @@ ino_t iunique(struct super_block *sb, in
 	struct hlist_head *head;
 	ino_t res;
 
-	spin_lock(&inode_lock);
 	spin_lock(&unique_lock);
 	do {
 		if (counter <= max_reserved)
@@ -938,7 +914,6 @@ ino_t iunique(struct super_block *sb, in
 		head = inode_hashtable + hash(sb, res);
 	} while (!test_inode_iunique(sb, head, res));
 	spin_unlock(&unique_lock);
-	spin_unlock(&inode_lock);
 
 	return res;
 }
@@ -948,7 +923,6 @@ struct inode *igrab(struct inode *inode)
 {
 	struct inode *ret = inode;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)))
 		__iget(inode);
@@ -960,7 +934,6 @@ struct inode *igrab(struct inode *inode)
 		 */
 		ret = NULL;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	return ret;
 }
@@ -991,17 +964,14 @@ static struct inode *ifind(struct super_
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_lock);
 	return NULL;
 }
 
@@ -1025,16 +995,13 @@ static struct inode *ifind_fast(struct s
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
 	}
-	spin_unlock(&inode_lock);
 	return NULL;
 }
 
@@ -1198,7 +1165,6 @@ int insert_inode_locked(struct inode *in
 		struct hlist_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
 repeat:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
@@ -1218,13 +1184,11 @@ repeat:
 			/* XXX: initialize inode->i_lock to locked? */
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_hash_lock);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		spin_unlock(&inode_hash_lock);
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
 			iput(old);
@@ -1247,7 +1211,6 @@ int insert_inode_locked4(struct inode *i
 		struct hlist_node *node;
 		struct inode *old = NULL;
 
-		spin_lock(&inode_lock);
 repeat:
 		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
@@ -1267,13 +1230,11 @@ repeat:
 			/* XXX: initialize inode->i_lock to locked? */
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_hash_lock);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		spin_unlock(&inode_hash_lock);
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
 			iput(old);
@@ -1296,13 +1257,11 @@ void __insert_inode_hash(struct inode *i
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
 	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
 
@@ -1314,13 +1273,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
  */
 void remove_inode_hash(struct inode *inode)
 {
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
 
@@ -1348,7 +1305,6 @@ void generic_delete_inode(struct inode *
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	atomic_dec(&inodes_stat.nr_inodes);
 
 	security_inode_delete(inode);
@@ -1366,13 +1322,11 @@ void generic_delete_inode(struct inode *
 		truncate_inode_pages(&inode->i_data, 0);
 		clear_inode(inode);
 	}
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
 	destroy_inode(inode);
@@ -1393,16 +1347,13 @@ static void generic_forget_inode(struct
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
-			spin_unlock(&inode_lock);
 			return;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
@@ -1420,7 +1371,6 @@ static void generic_forget_inode(struct
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	atomic_dec(&inodes_stat.nr_inodes);
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
@@ -1478,17 +1428,12 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
-retry1:
+retry:
 		spin_lock(&inode->i_lock);
 		if (inode->i_count == 1) {
-			if (!spin_trylock(&inode_lock)) {
-retry2:
-				spin_unlock(&inode->i_lock);
-				goto retry1;
-			}
 			if (!spin_trylock(&sb_inode_list_lock)) {
-				spin_unlock(&inode_lock);
-				goto retry2;
+				spin_unlock(&inode->i_lock);
+				goto retry;
 			}
 			inode->i_count--;
 			iput_final(inode);
@@ -1683,10 +1628,8 @@ static void __wait_on_freeing_inode(stru
 	wq = bit_waitqueue(&inode->i_state, __I_LOCK);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_lock);
 }
 
 static __initdata unsigned long ihash_entries;
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -392,13 +392,16 @@ void inotify_unmount_inodes(struct list_
 		struct inode *need_iput_tmp;
 		struct list_head *watches;
 
+		spin_lock(&inode->i_lock);
 		/*
 		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
-		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW))
+		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
@@ -406,18 +409,21 @@ void inotify_unmount_inodes(struct list_
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!inode->i_count)
+		if (!inode->i_count) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
 		/* In case inotify_remove_watch_locked() drops a reference. */
 		if (inode != need_iput_tmp) {
-			spin_lock(&inode->i_lock);
 			__iget(inode);
-			spin_unlock(&inode->i_lock);
 		} else
 			need_iput_tmp = NULL;
+
+		spin_unlock(&inode->i_lock);
+
 		/* In case the dropping of a reference would nuke next_i. */
 		if (&next_i->i_sb_list != list) {
 			spin_lock(&next_i->i_lock);
@@ -437,7 +443,6 @@ void inotify_unmount_inodes(struct list_
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -457,7 +462,6 @@ void inotify_unmount_inodes(struct list_
 		mutex_unlock(&inode->inotify_mutex);
 		iput(inode);		
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 }
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -9,7 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
 extern spinlock_t inode_hash_lock;
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -821,7 +821,6 @@ static void add_dquot_ref(struct super_b
 {
 	struct inode *inode, *old_inode = NULL;
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
@@ -841,7 +840,6 @@ static void add_dquot_ref(struct super_b
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 
 		iput(old_inode);
 		sb->dq_op->initialize(inode, type);
@@ -851,11 +849,9 @@ static void add_dquot_ref(struct super_b
 		 * reference and we cannot iput it under inode_lock. So we
 		 * keep the reference and iput it later. */
 		old_inode = inode;
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
 
@@ -925,7 +921,6 @@ static void remove_dquot_ref(struct supe
 {
 	struct inode *inode;
 
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
@@ -938,7 +933,6 @@ static void remove_dquot_ref(struct supe
 			remove_inode_dquot_ref(inode, type, tofree_head);
 	}
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 }
 
 /* Gather all references from inodes and drop them */
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c
+++ linux-2.6/fs/notify/inode_mark.c
@@ -369,13 +369,16 @@ void fsnotify_unmount_inodes(struct list
 	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
 		struct inode *need_iput_tmp;
 
+		spin_lock(&inode->i_lock);
 		/*
 		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
-		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW))
+		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
@@ -383,19 +386,20 @@ void fsnotify_unmount_inodes(struct list
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!inode->i_count)
+		if (!inode->i_count) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp) {
-			spin_lock(&inode->i_lock);
 			__iget(inode);
-			spin_unlock(&inode->i_lock);
 		} else
 			need_iput_tmp = NULL;
+		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
 		if (&next_i->i_sb_list != list) {
@@ -416,7 +420,6 @@ void fsnotify_unmount_inodes(struct list
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -428,7 +431,6 @@ void fsnotify_unmount_inodes(struct list
 
 		iput(inode);
 
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 	}
 }



Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbZDYBgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbZDYBgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZDYB3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbZDYB2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:52 -0400
Message-Id: <20090425012212.968372092@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:47 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 27/27] fs: icache remove inode_lock
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global inode_lock
---
 fs/buffer.c                 |    2 -
 fs/drop_caches.c            |    4 --
 fs/fs-writeback.c           |   23 +-------------
 fs/hugetlbfs/inode.c        |    6 ---
 fs/inode.c                  |   71 ++++----------------------------------------
 fs/notify/inotify/inotify.c |    2 -
 fs/quota/dquot.c            |    6 ---
 include/linux/writeback.h   |    1 
 8 files changed, 11 insertions(+), 104 deletions(-)

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
 		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
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
@@ -133,7 +133,6 @@ void __mark_inode_dirty(struct inode *in
 			       name, inode->i_sb->s_id);
 	}
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
@@ -172,7 +171,6 @@ void __mark_inode_dirty(struct inode *in
 	}
 out:
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 }
 
 EXPORT_SYMBOL(__mark_inode_dirty);
@@ -220,7 +218,7 @@ static void requeue_io(struct inode *ino
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
 	 */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
@@ -305,7 +303,6 @@ __sync_single_inode(struct inode *inode,
 
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
 
@@ -322,7 +319,6 @@ __sync_single_inode(struct inode *inode,
 			ret = err;
 	}
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -432,10 +428,8 @@ __writeback_single_inode(struct inode *i
 		do {
 			spin_unlock(&wb_inode_list_lock);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 			__wait_on_bit(wqh, &wq, inode_wait,
 							TASK_UNINTERRUPTIBLE);
-			spin_lock(&inode_lock);
 			spin_lock(&inode->i_lock);
 			spin_lock(&wb_inode_list_lock);
 		} while (inode->i_state & I_SYNC);
@@ -474,7 +468,6 @@ void generic_sync_sb_inodes(struct super
 	const unsigned long start = jiffies;	/* livelock avoidance */
 	int sync = wbc->sync_mode == WB_SYNC_ALL;
 
-	spin_lock(&inode_lock);
 again:
 	spin_lock(&wb_inode_list_lock);
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
@@ -568,10 +561,8 @@ again:
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
@@ -606,7 +597,6 @@ again:
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
-			spin_unlock(&inode_lock);
 			/*
 			 * We hold a reference to 'inode' so it couldn't have
 			 * been removed from s_inodes list while we dropped the
@@ -622,14 +612,11 @@ again:
 
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
@@ -797,13 +784,11 @@ int write_inode_now(struct inode *inode,
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	ret = __writeback_single_inode(inode, &wbc);
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	if (sync)
 		inode_sync_wait(inode);
 	return ret;
@@ -825,13 +810,11 @@ int sync_inode(struct inode *inode, stru
 {
 	int ret;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	ret = __writeback_single_inode(inode, wbc);
 	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
@@ -872,13 +855,11 @@ int generic_osync_inode(struct inode *in
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
@@ -388,7 +388,7 @@ static void hugetlbfs_delete_inode(struc
 	clear_inode(inode);
 }
 
-static void hugetlbfs_forget_inode(struct inode *inode) __releases(inode_lock)
+static void hugetlbfs_forget_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
@@ -402,20 +402,17 @@ static void hugetlbfs_forget_inode(struc
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
@@ -433,7 +430,6 @@ static void hugetlbfs_forget_inode(struc
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
@@ -82,7 +82,6 @@ static struct hlist_head *inode_hashtabl
  * NOTE! You also have to own the lock if you change
  * the i_state of an inode while it is in use..
  */
-DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
 DEFINE_SPINLOCK(inode_hash_lock);
@@ -336,16 +335,14 @@ static void dispose_list(struct list_hea
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
@@ -373,7 +370,6 @@ static int invalidate_list(struct list_h
 		 * change during umount anymore, and because iprune_mutex keeps
 		 * shrink_icache_memory() away.
 		 */
-		cond_resched_lock(&inode_lock);
 		cond_resched_lock(&sb_inode_list_lock);
 
 		next = next->next;
@@ -418,12 +414,10 @@ int invalidate_inodes(struct super_block
 	LIST_HEAD(throw_away);
 
 	mutex_lock(&iprune_mutex);
-	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
 	spin_unlock(&sb_inode_list_lock);
-	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
 	mutex_unlock(&iprune_mutex);
@@ -467,7 +461,6 @@ static void prune_icache(int nr_to_scan)
 	unsigned long reap = 0;
 
 	mutex_lock(&iprune_mutex);
-	spin_lock(&inode_lock);
 again:
 	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
@@ -491,12 +484,10 @@ again:
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
 
@@ -523,7 +514,6 @@ again2:
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&inode_lock);
 	spin_unlock(&wb_inode_list_lock);
 
 	dispose_list(&freeable);
@@ -670,12 +660,10 @@ void inode_add_to_lists(struct super_blo
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
 
@@ -698,21 +686,17 @@ struct inode *new_inode(struct super_blo
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
-	static unsigned int last_ino;
+	static unsigned int last_ino; /* protected with sb_inode_list_lock for now */
 	struct inode * inode;
 
-	spin_lock_prefetch(&inode_lock);
-	
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
 	}
 	return inode;
 }
@@ -762,7 +746,6 @@ static struct inode * get_new_inode(stru
 	if (inode) {
 		struct inode * old;
 
-		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
@@ -774,7 +757,6 @@ static struct inode * get_new_inode(stru
 			inode->i_state = I_LOCK|I_NEW;
 			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -789,7 +771,6 @@ static struct inode * get_new_inode(stru
 		 */
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -798,7 +779,6 @@ static struct inode * get_new_inode(stru
 
 set_failed:
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -815,7 +795,6 @@ static struct inode * get_new_inode_fast
 	if (inode) {
 		struct inode * old;
 
-		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
@@ -825,7 +804,6 @@ static struct inode * get_new_inode_fast
 			inode->i_state = I_LOCK|I_NEW;
 			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
 			 * caller is responsible for filling in the contents
@@ -840,7 +818,6 @@ static struct inode * get_new_inode_fast
 		 */
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
 		wait_on_inode(inode);
@@ -874,16 +851,16 @@ ino_t iunique(struct super_block *sb, in
 	struct hlist_head *head;
 	ino_t res;
 
-	spin_lock(&inode_lock);
 	do {
+		spin_lock(&sb_inode_list_lock); /* xxx: hack to protect counter */
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
+		spin_unlock(&sb_inode_list_lock);
 		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);
 		spin_unlock(&inode->i_lock);
 	} while (inode != NULL);
-	spin_unlock(&inode_lock);
 
 	return res;
 }
@@ -893,7 +870,6 @@ struct inode *igrab(struct inode *inode)
 {
 	struct inode *ret = inode;
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)))
 		__iget(inode);
@@ -905,7 +881,6 @@ struct inode *igrab(struct inode *inode)
 		 */
 		ret = NULL;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 
 	return ret;
 }
@@ -937,17 +912,14 @@ static struct inode *ifind(struct super_
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
 
@@ -971,16 +943,13 @@ static struct inode *ifind_fast(struct s
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
 
@@ -1147,7 +1116,6 @@ int insert_inode_locked(struct inode *in
 
 	inode->i_state |= I_LOCK|I_NEW;
 	while (1) {
-		spin_lock(&inode_lock);
 		old = find_inode_fast(sb, head, ino);
 		if (likely(!old)) {
 			spin_lock(&inode->i_lock);
@@ -1155,12 +1123,10 @@ int insert_inode_locked(struct inode *in
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
 			iput(old);
@@ -1169,7 +1135,6 @@ int insert_inode_locked(struct inode *in
 		iput(old);
 	}
 }
-
 EXPORT_SYMBOL(insert_inode_locked);
 
 int insert_inode_locked4(struct inode *inode, unsigned long hashval,
@@ -1182,7 +1147,6 @@ int insert_inode_locked4(struct inode *i
 	inode->i_state |= I_LOCK|I_NEW;
 
 	while (1) {
-		spin_lock(&inode_lock);
 		old = find_inode(sb, head, test, data);
 		if (likely(!old)) {
 			spin_lock(&inode->i_lock);
@@ -1190,12 +1154,10 @@ int insert_inode_locked4(struct inode *i
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
 			return 0;
 		}
 		__iget(old);
 		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
 			iput(old);
@@ -1204,7 +1166,6 @@ int insert_inode_locked4(struct inode *i
 		iput(old);
 	}
 }
-
 EXPORT_SYMBOL(insert_inode_locked4);
 
 /**
@@ -1219,13 +1180,11 @@ void __insert_inode_hash(struct inode *i
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
@@ -1238,13 +1197,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
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
@@ -1273,7 +1230,6 @@ void generic_delete_inode(struct inode *
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	atomic_dec(&inodes_stat.nr_inodes);
 
 	security_inode_delete(inode);
@@ -1291,13 +1247,11 @@ void generic_delete_inode(struct inode *
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
@@ -1319,16 +1273,13 @@ static void generic_forget_inode(struct
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
@@ -1346,7 +1297,6 @@ static void generic_forget_inode(struct
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	atomic_dec(&inodes_stat.nr_inodes);
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
@@ -1405,17 +1355,12 @@ void iput(struct inode *inode)
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
@@ -1613,10 +1558,8 @@ static void __wait_on_freeing_inode(stru
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
@@ -436,7 +436,6 @@ void inotify_unmount_inodes(struct list_
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
 		spin_unlock(&sb_inode_list_lock);
-		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -456,7 +455,6 @@ void inotify_unmount_inodes(struct list_
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



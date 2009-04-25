Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbZDYBh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbZDYBh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbZDYBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:30:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbZDYB2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:52 -0400
Message-Id: <20090425012212.236165067@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:42 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 22/27] fs: icache lock i_state
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect i_state updates with i_lock
---
 fs/drop_caches.c     |    9 ++++--
 fs/fs-writeback.c    |   46 ++++++++++++++++++++++++---------
 fs/hugetlbfs/inode.c |    6 ++++
 fs/inode.c           |   71 +++++++++++++++++++++++++++++++++++++++++++--------
 fs/nilfs2/gcdat.c    |    1 
 fs/quota/dquot.c     |   14 +++++++---
 6 files changed, 118 insertions(+), 29 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -19,11 +19,14 @@ static void drop_pagecache_sb(struct sup
 	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
-			continue;
-		if (inode->i_mapping->nrpages == 0)
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)
+				|| inode->i_mapping->nrpages == 0) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -118,6 +118,7 @@ void __mark_inode_dirty(struct inode *in
 		struct dentry *dentry = NULL;
 		const char *name = "?";
 
+		/* XXX: someone forgot their locking here */
 		if (!list_empty(&inode->i_dentry)) {
 			dentry = list_entry(inode->i_dentry.next,
 					    struct dentry, d_alias);
@@ -133,6 +134,7 @@ void __mark_inode_dirty(struct inode *in
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
@@ -167,6 +169,7 @@ void __mark_inode_dirty(struct inode *in
 		}
 	}
 out:
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 
@@ -296,6 +299,7 @@ __sync_single_inode(struct inode *inode,
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY;
 
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -314,6 +318,7 @@ __sync_single_inode(struct inode *inode,
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
@@ -419,10 +424,12 @@ __writeback_single_inode(struct inode *i
 
 		wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 		do {
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			__wait_on_bit(wqh, &wq, inode_wait,
 							TASK_UNINTERRUPTIBLE);
 			spin_lock(&inode_lock);
+			spin_lock(&inode->i_lock);
 		} while (inode->i_state & I_SYNC);
 	}
 	return __sync_single_inode(inode, wbc);
@@ -487,11 +494,6 @@ void generic_sync_sb_inodes(struct super
 			break;
 		}
 
-		if (inode->i_state & I_NEW) {
-			requeue_io(inode);
-			continue;
-		}
-
 		if (wbc->nonblocking && bdi_write_congested(bdi)) {
 			wbc->encountered_congestion = 1;
 			if (!sb_is_blkdev_sb(sb))
@@ -507,16 +509,27 @@ void generic_sync_sb_inodes(struct super
 			continue;		/* blockdev has wrong queue */
 		}
 
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & I_NEW) {
+			spin_unlock(&inode->i_lock);
+			requeue_io(inode);
+			continue;
+		}
+
 		/*
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
 		 */
-		if (inode_dirtied_after(inode, start))
+		if (inode_dirtied_after(inode, start)) {
+			spin_unlock(&inode->i_lock);
 			break;
+		}
 
 		/* Is another pdflush already flushing this queue? */
-		if (current_is_pdflush() && !writeback_acquire(bdi))
+		if (current_is_pdflush() && !writeback_acquire(bdi)) {
+			spin_unlock(&inode->i_lock);
 			break;
+		}
 
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
@@ -531,6 +544,7 @@ void generic_sync_sb_inodes(struct super
 			 */
 			redirty_tail(inode);
 		}
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
@@ -555,15 +569,17 @@ void generic_sync_sb_inodes(struct super
 		 */
 		spin_lock(&sb_inode_list_lock);
 		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-			struct address_space *mapping;
+			struct address_space *mapping = inode->i_mapping;
 
+			spin_lock(&inode->i_lock);
 			if (inode->i_state &
-					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
-				continue;
-			mapping = inode->i_mapping;
-			if (mapping->nrpages == 0)
+					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)
+					|| mapping->nrpages == 0) {
+				spin_unlock(&inode->i_lock);
 				continue;
+			}
 			__iget(inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
 			spin_unlock(&inode_lock);
 			/*
@@ -756,7 +772,9 @@ int write_inode_now(struct inode *inode,
 
 	might_sleep();
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	ret = __writeback_single_inode(inode, &wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
 		inode_sync_wait(inode);
@@ -780,7 +798,9 @@ int sync_inode(struct inode *inode, stru
 	int ret;
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	ret = __writeback_single_inode(inode, wbc);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	return ret;
 }
@@ -823,9 +843,11 @@ int generic_osync_inode(struct inode *in
 	}
 
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if ((inode->i_state & I_DIRTY) &&
 	    ((what & OSYNC_INODE) || (inode->i_state & I_DIRTY_DATASYNC)))
 		need_write_inode_now = 1;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
 	if (need_write_inode_now) {
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -269,6 +269,7 @@ static void init_once(void *foo)
  */
 void __iget(struct inode * inode)
 {
+	assert_spin_locked(&inode->i_lock);
 	if (atomic_read(&inode->i_count)) {
 		atomic_inc(&inode->i_count);
 		return;
@@ -373,16 +374,21 @@ static int invalidate_list(struct list_h
 		if (tmp == head)
 			break;
 		inode = list_entry(tmp, struct inode, i_sb_list);
-		if (inode->i_state & I_NEW)
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & I_NEW) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		invalidate_inode_buffers(inode);
 		if (!atomic_read(&inode->i_count)) {
 			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
+			spin_unlock(&inode->i_lock);
 			count++;
 			continue;
 		}
+		spin_unlock(&inode->i_lock);
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
@@ -462,12 +468,15 @@ static void prune_icache(int nr_to_scan)
 
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
+		spin_lock(&inode->i_lock);
 		if (inode->i_state || atomic_read(&inode->i_count)) {
 			list_move(&inode->i_list, &inode_unused);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			__iget(inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
@@ -478,12 +487,16 @@ static void prune_icache(int nr_to_scan)
 			if (inode != list_entry(inode_unused.next,
 						struct inode, i_list))
 				continue;	/* wrong inode or list_empty */
-			if (!can_unuse(inode))
+			spin_lock(&inode->i_lock);
+			if (!can_unuse(inode)) {
+				spin_unlock(&inode->i_lock);
 				continue;
+			}
 		}
 		list_move(&inode->i_list, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
+		spin_unlock(&inode->i_lock);
 		nr_pruned++;
 	}
 	inodes_stat.nr_unused -= nr_pruned;
@@ -543,8 +556,14 @@ repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
-		if (!test(inode, data))
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&inode_hash_lock);
+			goto repeat;
+		}
+		if (!test(inode, data)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
 			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
@@ -572,6 +591,10 @@ repeat:
 			continue;
 		if (inode->i_sb != sb)
 			continue;
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&inode_hash_lock);
+			goto repeat;
+		}
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
 			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
@@ -598,10 +621,10 @@ __inode_add_to_lists(struct super_block
 			struct inode *inode)
 {
 	inodes_stat.nr_inodes++;
-	list_add(&inode->i_list, &inode_in_use);
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
+	list_add(&inode->i_list, &inode_in_use);
 	if (head) {
 		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
@@ -658,9 +681,9 @@ struct inode *new_inode(struct super_blo
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
-		__inode_add_to_lists(sb, NULL, inode);
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
+		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode_lock);
 	}
 	return inode;
@@ -718,8 +741,8 @@ static struct inode * get_new_inode(stru
 			if (set(inode, data))
 				goto set_failed;
 
-			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_LOCK|I_NEW;
+			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -734,6 +757,7 @@ static struct inode * get_new_inode(stru
 		 * allocated.
 		 */
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -742,6 +766,7 @@ static struct inode * get_new_inode(stru
 	return inode;
 
 set_failed:
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
@@ -764,8 +789,8 @@ static struct inode * get_new_inode_fast
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
 			inode->i_ino = ino;
-			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_LOCK|I_NEW;
+			__inode_add_to_lists(sb, head, inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -780,6 +805,7 @@ static struct inode * get_new_inode_fast
 		 * allocated.
 		 */
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -821,6 +847,7 @@ ino_t iunique(struct super_block *sb, in
 		res = counter++;
 		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);
+		spin_unlock(&inode->i_lock);
 	} while (inode != NULL);
 	spin_unlock(&inode_lock);
 
@@ -830,7 +857,10 @@ EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
 {
+	struct inode *ret = inode;
+
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)))
 		__iget(inode);
 	else
@@ -839,9 +869,11 @@ struct inode *igrab(struct inode *inode)
 		 * called yet, and somebody is calling igrab
 		 * while the inode is getting freed.
 		 */
-		inode = NULL;
+		ret = NULL;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
-	return inode;
+
+	return ret;
 }
 
 EXPORT_SYMBOL(igrab);
@@ -875,6 +907,7 @@ static struct inode *ifind(struct super_
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -908,6 +941,7 @@ static struct inode *ifind_fast(struct s
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1089,6 +1123,7 @@ int insert_inode_locked(struct inode *in
 			return 0;
 		}
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1121,6 +1156,7 @@ int insert_inode_locked4(struct inode *i
 			return 0;
 		}
 		__iget(old);
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1186,12 +1222,14 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
-	list_del_init(&inode->i_list);
 	spin_lock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
+	list_del_init(&inode->i_list);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+	spin_unlock(&inode->i_lock);
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
 
@@ -1226,19 +1264,27 @@ static void generic_forget_inode(struct
 {
 	struct super_block *sb = inode->i_sb;
 
+	spin_lock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
 	if (!hlist_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
+			spin_unlock(&inode->i_lock);
+			spin_unlock(&sb_inode_list_lock);
 			spin_unlock(&inode_lock);
 			return;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
+		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
@@ -1247,12 +1293,12 @@ static void generic_forget_inode(struct
 		spin_unlock(&inode_hash_lock);
 	}
 	list_del_init(&inode->i_list);
-	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
@@ -1493,6 +1539,8 @@ EXPORT_SYMBOL(inode_wait);
  * wake_up_inode() after removing from the hash list will DTRT.
  *
  * This is called with inode_lock held.
+ *
+ * Called with i_lock held and returns with it dropped.
  */
 static void __wait_on_freeing_inode(struct inode *inode)
 {
@@ -1500,6 +1548,7 @@ static void __wait_on_freeing_inode(stru
 	DEFINE_WAIT_BIT(wait, &inode->i_state, __I_LOCK);
 	wq = bit_waitqueue(&inode->i_state, __I_LOCK);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -400,7 +400,9 @@ static void hugetlbfs_forget_inode(struc
 			spin_unlock(&inode_lock);
 			return;
 		}
+		spin_lock(&inode->i_lock);
 		inode->i_state |= I_WILL_FREE;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * write_inode_now is a noop as we set BDI_CAP_NO_WRITEBACK
@@ -408,7 +410,9 @@ static void hugetlbfs_forget_inode(struc
 		 */
 		write_inode_now(inode, 1);
 		spin_lock(&inode_lock);
+		spin_lock(&inode->i_lock);
 		inode->i_state &= ~I_WILL_FREE;
+		spin_unlock(&inode->i_lock);
 		inodes_stat.nr_unused--;
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
@@ -418,7 +422,9 @@ static void hugetlbfs_forget_inode(struc
 	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
 	inode->i_state |= I_FREEING;
+	spin_unlock(&inode->i_lock);
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
 	truncate_hugepages(inode, 0);
Index: linux-2.6/fs/nilfs2/gcdat.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/gcdat.c
+++ linux-2.6/fs/nilfs2/gcdat.c
@@ -27,6 +27,7 @@
 #include "page.h"
 #include "mdt.h"
 
+/* XXX: what protects i_state? */
 int nilfs_init_gcdat_inode(struct the_nilfs *nilfs)
 {
 	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -824,14 +824,22 @@ static void add_dquot_ref(struct super_b
 	spin_lock(&inode_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		if (!atomic_read(&inode->i_writecount))
+		}
+		if (!atomic_read(&inode->i_writecount)) {
+			spin_unlock(&inode->i_lock);
 			continue;
-		if (!dqinit_needed(inode, type))
+		}
+		if (!dqinit_needed(inode, type)) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		__iget(inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 



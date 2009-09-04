Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbZIDHA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbZIDHA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbZIDHAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:00:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:56566 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784AbZIDG6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:43 -0400
Message-Id: <20090904065539.031330453@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:13 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 32/33] fs: rcu walk for i_sb_list
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-11.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables locking to be reduced and simplified.
---
 fs/drop_caches.c            |   10 ++++-----
 fs/fs-writeback.c           |   10 ++++-----
 fs/hugetlbfs/inode.c        |    4 ---
 fs/inode.c                  |   45 ++++++++++++++------------------------------
 fs/notify/inode_mark.c      |   10 ---------
 fs/notify/inotify/inotify.c |   10 ---------
 fs/quota/dquot.c            |   16 +++++++--------
 7 files changed, 34 insertions(+), 71 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -16,8 +16,8 @@ static void drop_pagecache_sb(struct sup
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)
 				|| inode->i_mapping->nrpages == 0) {
@@ -26,13 +26,13 @@ static void drop_pagecache_sb(struct sup
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
+		rcu_read_unlock();
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
-		spin_lock(&sb_inode_list_lock);
+		rcu_read_lock();
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 	iput(toput_inode);
 }
 
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -587,8 +587,8 @@ again:
 		 * In which case, the inode may not be on the dirty list, but
 		 * we still have to wait for that writeout.
 		 */
-		spin_lock(&sb_inode_list_lock);
-		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		rcu_read_lock();
+		list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 			struct address_space *mapping = inode->i_mapping;
 
 			spin_lock(&inode->i_lock);
@@ -600,7 +600,7 @@ again:
 			}
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&sb_inode_list_lock);
+			rcu_read_unlock();
 			/*
 			 * We hold a reference to 'inode' so it couldn't have
 			 * been removed from s_inodes list while we dropped the
@@ -616,9 +616,9 @@ again:
 
 			cond_resched();
 
-			spin_lock(&sb_inode_list_lock);
+			rcu_read_lock();
 		}
-		spin_unlock(&sb_inode_list_lock);
+		rcu_read_unlock();
 		iput(old_inode);
 	}
 
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -354,12 +354,12 @@ static void dispose_list(struct list_hea
 			truncate_inode_pages(&inode->i_data, 0);
 		clear_inode(inode);
 
-		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		__remove_inode_hash(inode);
+		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
-		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
+		spin_unlock(&inode->i_lock);
 
 		wake_up_inode(inode);
 		destroy_inode(inode);
@@ -381,14 +381,6 @@ static int invalidate_list(struct list_h
 		struct list_head *tmp = next;
 		struct inode *inode;
 
-		/*
-		 * We can reschedule here without worrying about the list's
-		 * consistency because the per-sb list of inodes must not
-		 * change during umount anymore, and because iprune_mutex keeps
-		 * shrink_icache_memory() away.
-		 */
-		cond_resched_lock(&sb_inode_list_lock);
-
 		next = next->next;
 		if (tmp == head)
 			break;
@@ -431,12 +423,17 @@ int invalidate_inodes(struct super_block
 	int busy;
 	LIST_HEAD(throw_away);
 
+	/*
+	 * Don't need to worry about the list's consistency because the per-sb
+	 * list of inodes must not change during umount anymore, and because
+	 * iprune_mutex keeps shrink_icache_memory() away.
+	 */
 	mutex_lock(&iprune_mutex);
-	spin_lock(&sb_inode_list_lock);
+//	spin_lock(&sb_inode_list_lock); XXX: is this safe?
 	inotify_unmount_inodes(&sb->s_inodes);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
-	spin_unlock(&sb_inode_list_lock);
+//	spin_unlock(&sb_inode_list_lock);
 
 	dispose_list(&throw_away);
 	mutex_unlock(&iprune_mutex);
@@ -662,6 +659,7 @@ __inode_add_to_lists(struct super_block
 			struct inode *inode)
 {
 	atomic_inc(&inodes_stat.nr_inodes);
+	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
 	if (b) {
@@ -687,7 +685,6 @@ void inode_add_to_lists(struct super_blo
 {
 	struct inode_hash_bucket *b = inode_hashtable + hash(sb, inode->i_ino);
 
-	spin_lock(&sb_inode_list_lock);
 	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, b, inode);
 	spin_unlock(&inode->i_lock);
@@ -718,7 +715,6 @@ struct inode *new_inode(struct super_blo
 
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_ino = atomic_inc_return(&last_ino);
 		inode->i_state = 0;
@@ -783,7 +779,6 @@ static struct inode *get_new_inode(struc
 		/* We released the lock, so.. */
 		old = find_inode(sb, b, test, data);
 		if (!old) {
-			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
 			if (set(inode, data))
 				goto set_failed;
@@ -813,7 +808,6 @@ static struct inode *get_new_inode(struc
 
 set_failed:
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&sb_inode_list_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -834,7 +828,6 @@ static struct inode *get_new_inode_fast(
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, b, ino);
 		if (!old) {
-			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
 			inode->i_state = I_LOCK|I_NEW;
@@ -1315,6 +1308,7 @@ void generic_delete_inode(struct inode *
 		list_del_init(&inode->i_list);
 		spin_unlock(&wb_inode_list_lock);
 	}
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1359,15 +1353,12 @@ static void generic_forget_inode(struct
 		}
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&sb_inode_list_lock);
 			return;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
 		write_inode_now(inode, 1);
-		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
@@ -1379,6 +1370,7 @@ static void generic_forget_inode(struct
 		spin_unlock(&wb_inode_list_lock);
 		atomic_dec(&inodes_stat.nr_unused);
 	}
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1441,19 +1433,12 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
-retry:
 		spin_lock(&inode->i_lock);
-		if (inode->i_count == 1) {
-			if (!spin_trylock(&sb_inode_list_lock)) {
-				spin_unlock(&inode->i_lock);
-				goto retry;
-			}
-			inode->i_count--;
+		inode->i_count--;
+		if (inode->i_count == 0)
 			iput_final(inode);
-		} else {
-			inode->i_count--;
+		else
 			spin_unlock(&inode->i_lock);
-		}
 	}
 }
 EXPORT_SYMBOL(iput);
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c
+++ linux-2.6/fs/notify/inode_mark.c
@@ -413,14 +413,6 @@ void fsnotify_unmount_inodes(struct list
 			spin_unlock(&next_i->i_lock);
 		}
 
-		/*
-		 * We can safely drop inode_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.  Finally,
-		 * iprune_mutex keeps shrink_icache_memory() away.
-		 */
-		spin_unlock(&sb_inode_list_lock);
-
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
 
@@ -430,7 +422,5 @@ void fsnotify_unmount_inodes(struct list
 		fsnotify_inode_delete(inode);
 
 		iput(inode);
-
-		spin_lock(&sb_inode_list_lock);
 	}
 }
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -436,14 +436,6 @@ void inotify_unmount_inodes(struct list_
 			spin_unlock(&next_i->i_lock);
 		}
 
-		/*
-		 * We can safely drop inode_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.  Finally,
-		 * iprune_mutex keeps shrink_icache_memory() away.
-		 */
-		spin_unlock(&sb_inode_list_lock);
-
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
 
@@ -461,8 +453,6 @@ void inotify_unmount_inodes(struct list_
 		}
 		mutex_unlock(&inode->inotify_mutex);
 		iput(inode);		
-
-		spin_lock(&sb_inode_list_lock);
 	}
 }
 EXPORT_SYMBOL_GPL(inotify_unmount_inodes);
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -821,8 +821,8 @@ static void add_dquot_ref(struct super_b
 {
 	struct inode *inode, *old_inode = NULL;
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
@@ -839,7 +839,7 @@ static void add_dquot_ref(struct super_b
 
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
+		rcu_read_unlock();
 
 		iput(old_inode);
 		sb->dq_op->initialize(inode, type);
@@ -849,9 +849,9 @@ static void add_dquot_ref(struct super_b
 		 * reference and we cannot iput it under inode_lock. So we
 		 * keep the reference and iput it later. */
 		old_inode = inode;
-		spin_lock(&sb_inode_list_lock);
+		rcu_read_lock();
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 	iput(old_inode);
 }
 
@@ -921,8 +921,8 @@ static void remove_dquot_ref(struct supe
 {
 	struct inode *inode;
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
 		 *  have quota pointer initialized. Luckily, we need to touch
@@ -932,7 +932,7 @@ static void remove_dquot_ref(struct supe
 		if (!IS_NOQUOTA(inode))
 			remove_inode_dquot_ref(inode, type, tofree_head);
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 }
 
 /* Gather all references from inodes and drop them */
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -392,19 +392,16 @@ static void hugetlbfs_forget_inode(struc
 		atomic_inc(&inodes_stat.nr_unused);
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&sb_inode_list_lock);
 			return;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
 		/*
 		 * write_inode_now is a noop as we set BDI_CAP_NO_WRITEBACK
 		 * in our backing_dev_info.
 		 */
 		write_inode_now(inode, 1);
-		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
@@ -414,6 +411,7 @@ static void hugetlbfs_forget_inode(struc
 	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
 	spin_unlock(&wb_inode_list_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);



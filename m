Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZDYBbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZDYBbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZDYB24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:28:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbZDYB2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:49 -0400
Message-Id: <20090425012211.943152128@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:40 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 20/27] fs: icache lock s_inodes list
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect sb->s_inodes with a new lock, sb_inode_list_lock.
---
 fs/drop_caches.c            |    4 ++++
 fs/fs-writeback.c           |    4 ++++
 fs/hugetlbfs/inode.c        |    2 ++
 fs/inode.c                  |   12 ++++++++++++
 fs/notify/inotify/inotify.c |    2 ++
 fs/quota/dquot.c            |    6 ++++++
 include/linux/writeback.h   |    1 +
 7 files changed, 31 insertions(+)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -17,18 +17,22 @@ static void drop_pagecache_sb(struct sup
 	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
 		iput(toput_inode);
 		toput_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(toput_inode);
 }
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -553,6 +553,7 @@ void generic_sync_sb_inodes(struct super
 		 * In which case, the inode may not be on the dirty list, but
 		 * we still have to wait for that writeout.
 		 */
+		spin_lock(&sb_inode_list_lock);
 		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 			struct address_space *mapping;
 
@@ -563,6 +564,7 @@ void generic_sync_sb_inodes(struct super
 			if (mapping->nrpages == 0)
 				continue;
 			__iget(inode);
+			spin_unlock(&sb_inode_list_lock);
 			spin_unlock(&inode_lock);
 			/*
 			 * We hold a reference to 'inode' so it couldn't have
@@ -580,7 +582,9 @@ void generic_sync_sb_inodes(struct super
 			cond_resched();
 
 			spin_lock(&inode_lock);
+			spin_lock(&sb_inode_list_lock);
 		}
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		iput(old_inode);
 	} else
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -83,6 +83,7 @@ static struct hlist_head *inode_hashtabl
  * the i_state of an inode while it is in use..
  */
 DEFINE_SPINLOCK(inode_lock);
+DEFINE_SPINLOCK(sb_inode_list_lock);
 
 /*
  * iprune_mutex provides exclusion between the kswapd or try_to_free_pages
@@ -329,7 +330,9 @@ static void dispose_list(struct list_hea
 
 		spin_lock(&inode_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -361,6 +364,7 @@ static int invalidate_list(struct list_h
 		 * shrink_icache_memory() away.
 		 */
 		cond_resched_lock(&inode_lock);
+		cond_resched_lock(&sb_inode_list_lock);
 
 		next = next->next;
 		if (tmp == head)
@@ -398,8 +402,10 @@ int invalidate_inodes(struct super_block
 
 	mutex_lock(&iprune_mutex);
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
@@ -584,7 +590,9 @@ __inode_add_to_lists(struct super_block
 {
 	inodes_stat.nr_inodes++;
 	list_add(&inode->i_list, &inode_in_use);
+	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb_inode_list_lock);
 	if (head)
 		hlist_add_head(&inode->i_hash, head);
 }
@@ -1159,7 +1167,9 @@ void generic_delete_inode(struct inode *
 	const struct super_operations *op = inode->i_sb->s_op;
 
 	list_del_init(&inode->i_list);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
@@ -1213,7 +1223,9 @@ static void generic_forget_inode(struct
 		hlist_del_init(&inode->i_hash);
 	}
 	list_del_init(&inode->i_list);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -430,6 +430,7 @@ void inotify_unmount_inodes(struct list_
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
@@ -452,6 +453,7 @@ void inotify_unmount_inodes(struct list_
 		iput(inode);		
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
 }
 EXPORT_SYMBOL_GPL(inotify_unmount_inodes);
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -822,6 +822,7 @@ static void add_dquot_ref(struct super_b
 	struct inode *inode, *old_inode = NULL;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
@@ -831,6 +832,7 @@ static void add_dquot_ref(struct super_b
 			continue;
 
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
@@ -842,7 +844,9 @@ static void add_dquot_ref(struct super_b
 		 * keep the reference and iput it later. */
 		old_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
@@ -914,6 +918,7 @@ static void remove_dquot_ref(struct supe
 	struct inode *inode;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -924,6 +929,7 @@ static void remove_dquot_ref(struct supe
 		if (!IS_NOQUOTA(inode))
 			remove_inode_dquot_ref(inode, type, tofree_head);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 }
 
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -10,6 +10,7 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
+extern spinlock_t sb_inode_list_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -413,7 +413,9 @@ static void hugetlbfs_forget_inode(struc
 		hlist_del_init(&inode->i_hash);
 	}
 	list_del_init(&inode->i_list);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb_inode_list_lock);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);



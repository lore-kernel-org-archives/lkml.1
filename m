Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbZIDHEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbZIDHEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbZIDHEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:04:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbZIDG6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:39 -0400
Message-Id: <20090904065537.110402299@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:01 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 20/33] fs: icache lock inode hash
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, inode_hash_lock, to protect the inode hash table lists.
---
 fs/hugetlbfs/inode.c      |    2 ++
 fs/inode.c                |   29 ++++++++++++++++++++++++++++-
 include/linux/writeback.h |    1 +
 3 files changed, 31 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -401,7 +401,9 @@ static void hugetlbfs_forget_inode(struc
 		spin_lock(&inode_lock);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 	}
 	list_del_init(&inode->i_list);
 	spin_lock(&sb_inode_list_lock);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -86,6 +86,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_mutex provides exclusion between the kswapd or try_to_free_pages
@@ -355,7 +356,9 @@ static void dispose_list(struct list_hea
 		clear_inode(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
@@ -565,17 +568,20 @@ static struct inode *find_inode(struct s
 	struct inode *inode = NULL;
 
 repeat:
+	spin_lock(&inode_hash_lock);
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
 			continue;
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
+			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
+	spin_unlock(&inode_hash_lock);
 	return node ? inode : NULL;
 }
 
@@ -590,17 +596,20 @@ static struct inode *find_inode_fast(str
 	struct inode *inode = NULL;
 
 repeat:
+	spin_lock(&inode_hash_lock);
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
+			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
+	spin_unlock(&inode_hash_lock);
 	return node ? inode : NULL;
 }
 
@@ -623,8 +632,11 @@ __inode_add_to_lists(struct super_block
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
-	if (head)
+	if (head) {
+		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
+		spin_unlock(&inode_hash_lock);
+	}
 }
 
 /**
@@ -1100,7 +1112,9 @@ int insert_inode_locked(struct inode *in
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
+
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
@@ -1112,9 +1126,11 @@ int insert_inode_locked(struct inode *in
 		}
 		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
+		spin_unlock(&inode_hash_lock);
 		__iget(old);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
@@ -1140,6 +1156,7 @@ int insert_inode_locked4(struct inode *i
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
@@ -1151,9 +1168,11 @@ int insert_inode_locked4(struct inode *i
 		}
 		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
+		spin_unlock(&inode_hash_lock);
 		__iget(old);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
@@ -1178,7 +1197,9 @@ void __insert_inode_hash(struct inode *i
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1192,7 +1213,9 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1238,7 +1261,9 @@ void generic_delete_inode(struct inode *
 		clear_inode(inode);
 	}
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
@@ -1266,7 +1291,9 @@ static void generic_forget_inode(struct
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 	}
 	list_del_init(&inode->i_list);
 	spin_lock(&sb_inode_list_lock);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -11,6 +11,7 @@ struct backing_dev_info;
 
 extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
+extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 



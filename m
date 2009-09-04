Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbZIDHBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbZIDHBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbZIDHBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:01:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:56558 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570AbZIDG6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:40 -0400
Message-Id: <20090904065537.906625456@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:06 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 25/33] fs: icache protect inode state
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-6b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect i_hash, i_sb_list etc members with i_lock.
---
 fs/hugetlbfs/inode.c |   14 +++++++++-----
 fs/inode.c           |   29 ++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -363,12 +363,14 @@ static void dispose_list(struct list_hea
 		clear_inode(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
+		spin_lock(&inode->i_lock);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
-		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -670,7 +672,6 @@ __inode_add_to_lists(struct super_block
 			struct inode *inode)
 {
 	atomic_inc(&inodes_stat.nr_inodes);
-	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
 	spin_lock(&wb_inode_list_lock);
@@ -700,7 +701,10 @@ void inode_add_to_lists(struct super_blo
 	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, head, inode);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
@@ -732,9 +736,12 @@ struct inode *new_inode(struct super_blo
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
+		spin_lock(&inode->i_lock);
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 	}
 	return inode;
@@ -796,11 +803,14 @@ static struct inode *get_new_inode(struc
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
+			spin_lock(&sb_inode_list_lock);
+			spin_lock(&inode->i_lock);
 			if (set(inode, data))
 				goto set_failed;
 
 			inode->i_state = I_LOCK|I_NEW;
 			__inode_add_to_lists(sb, head, inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -825,6 +835,7 @@ static struct inode *get_new_inode(struc
 
 set_failed:
 	spin_unlock(&inode->i_lock);
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
@@ -847,9 +858,12 @@ static struct inode *get_new_inode_fast(
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
+			spin_lock(&sb_inode_list_lock);
+			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
 			inode->i_state = I_LOCK|I_NEW;
 			__inode_add_to_lists(sb, head, inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -1185,6 +1199,7 @@ repeat:
 			break;
 		}
 		if (likely(!node)) {
+			/* XXX: initialize inode->i_lock to locked? */
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode_lock);
@@ -1233,6 +1248,7 @@ repeat:
 			break;
 		}
 		if (likely(!node)) {
+			/* XXX: initialize inode->i_lock to locked? */
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode_lock);
@@ -1263,10 +1279,13 @@ EXPORT_SYMBOL(insert_inode_locked4);
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
 	spin_unlock(&inode_hash_lock);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1280,9 +1299,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1330,9 +1351,11 @@ void generic_delete_inode(struct inode *
 		clear_inode(inode);
 	}
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
@@ -1368,10 +1391,10 @@ static void generic_forget_inode(struct
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
+		atomic_dec(&inodes_stat.nr_unused);
 	}
 	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -391,12 +391,15 @@ static void hugetlbfs_forget_inode(struc
 		}
 		atomic_inc(&inodes_stat.nr_unused);
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
+			spin_unlock(&inode->i_lock);
+			spin_unlock(&sb_inode_list_lock);
 			spin_unlock(&inode_lock);
 			return;
 		}
-		spin_lock(&inode->i_lock);
+		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * write_inode_now is a noop as we set BDI_CAP_NO_WRITEBACK
@@ -404,27 +407,28 @@ static void hugetlbfs_forget_inode(struc
 		 */
 		write_inode_now(inode, 1);
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
+		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
-		spin_unlock(&inode->i_lock);
 		atomic_dec(&inodes_stat.nr_unused);
 	}
 	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
 	spin_unlock(&wb_inode_list_lock);
-	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
-	spin_lock(&inode->i_lock);
+	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	atomic_dec(&inodes_stat.nr_unused);
 	spin_unlock(&inode_lock);
+	atomic_dec(&inodes_stat.nr_unused);
 	truncate_hugepages(inode, 0);
 	clear_inode(inode);
+	/* XXX: why no wake_up_inode? */
 	destroy_inode(inode);
 }
 



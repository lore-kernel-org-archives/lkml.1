Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZDYBfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZDYBfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbZDYB3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:44591 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbZDYB2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:52 -0400
Message-Id: <20090425012212.087880019@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:41 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 21/27] fs: icache lock inode hash
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, inode_hash_lock, to protect the inode hash table lists.
---
 fs/hugetlbfs/inode.c      |    2 ++
 fs/inode.c                |   26 +++++++++++++++++++++++++-
 include/linux/writeback.h |    1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -410,7 +410,9 @@ static void hugetlbfs_forget_inode(struc
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
@@ -84,6 +84,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_mutex provides exclusion between the kswapd or try_to_free_pages
@@ -329,7 +330,9 @@ static void dispose_list(struct list_hea
 		clear_inode(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
@@ -536,17 +539,20 @@ static struct inode * find_inode(struct
 	struct inode * inode = NULL;
 
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
 
@@ -560,17 +566,20 @@ static struct inode * find_inode_fast(st
 	struct inode * inode = NULL;
 
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
 
@@ -593,8 +602,11 @@ __inode_add_to_lists(struct super_block
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
@@ -1070,7 +1082,9 @@ int insert_inode_locked(struct inode *in
 		spin_lock(&inode_lock);
 		old = find_inode_fast(sb, head, ino);
 		if (likely(!old)) {
+			spin_lock(&inode_hash_lock);
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
@@ -1100,7 +1114,9 @@ int insert_inode_locked4(struct inode *i
 		spin_lock(&inode_lock);
 		old = find_inode(sb, head, test, data);
 		if (likely(!old)) {
+			spin_lock(&inode_hash_lock);
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
@@ -1129,7 +1145,9 @@ void __insert_inode_hash(struct inode *i
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 
@@ -1144,7 +1162,9 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 
@@ -1191,7 +1211,9 @@ void generic_delete_inode(struct inode *
 		clear_inode(inode);
 	}
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
@@ -1220,7 +1242,9 @@ static void generic_forget_inode(struct
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
 



Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbZIDHBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbZIDHBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbZIDHBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:01:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:56562 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbZIDG6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:41 -0400
Message-Id: <20090904065538.371812229@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:09 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 28/33] fs: inode factor hash lock into functions
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make inode_hash_lock private by adding a function __remove_inode_hash
that can be used by filesystems defining their own drop_inode functions.
---
 fs/hugetlbfs/inode.c      |    4 +---
 fs/inode.c                |   32 +++++++++++++++++++-------------
 include/linux/fs.h        |    1 +
 include/linux/writeback.h |    1 -
 4 files changed, 21 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -86,7 +86,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
-DEFINE_SPINLOCK(inode_hash_lock);
+static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_mutex provides exclusion between the kswapd or try_to_free_pages
@@ -363,9 +363,7 @@ static void dispose_list(struct list_hea
 
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
@@ -1266,6 +1264,20 @@ void __insert_inode_hash(struct inode *i
 EXPORT_SYMBOL(__insert_inode_hash);
 
 /**
+ *	__remove_inode_hash - remove an inode from the hash
+ *	@inode: inode to unhash
+ *
+ *	Remove an inode from the superblock. inode->i_lock must be
+ *	held.
+ */
+void __remove_inode_hash(struct inode *inode)
+{
+	spin_lock(&inode_hash_lock);
+	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
+}
+
+/**
  *	remove_inode_hash - remove an inode from the hash
  *	@inode: inode to unhash
  *
@@ -1274,9 +1286,7 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
+	__remove_inode_hash(inode);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1323,9 +1333,7 @@ void generic_delete_inode(struct inode *
 		clear_inode(inode);
 	}
 	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
+	__remove_inode_hash(inode);
 	spin_unlock(&inode->i_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
@@ -1358,9 +1366,7 @@ static void generic_forget_inode(struct
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		atomic_dec(&inodes_stat.nr_unused);
 	}
 	spin_lock(&wb_inode_list_lock);
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -408,9 +408,7 @@ static void hugetlbfs_forget_inode(struc
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		atomic_dec(&inodes_stat.nr_unused);
 	}
 	spin_lock(&wb_inode_list_lock);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -2176,6 +2176,7 @@ extern int should_remove_suid(struct den
 extern int file_remove_suid(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
+extern void __remove_inode_hash(struct inode *);
 extern void remove_inode_hash(struct inode *);
 static inline void insert_inode_hash(struct inode *inode) {
 	__insert_inode_hash(inode, inode->i_ino);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -11,7 +11,6 @@ struct backing_dev_info;
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 



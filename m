Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbZIDHBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbZIDHBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbZIDHBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:01:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:56563 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685AbZIDG6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:41 -0400
Message-Id: <20090904065538.693437484@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:11 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 30/33] fs: inode lazy lru
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impelemnt lazy inode lru similarly to dcache. This should reduce inode list
lock acquisition (todo: measure).
---
 fs/fs-writeback.c         |    2 -
 fs/inode.c                |   61 +++++++++++++++++++---------------------------
 include/linux/fs.h        |    7 ++++-
 include/linux/writeback.h |    1 
 4 files changed, 33 insertions(+), 38 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -74,7 +74,6 @@ static unsigned int i_hash_shift __read_
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_in_use);
 LIST_HEAD(inode_unused);
 
 struct inode_hash_bucket {
@@ -273,6 +272,7 @@ void inode_init_once(struct inode *inode
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
+	INIT_LIST_HEAD(&inode->i_list);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -298,24 +298,6 @@ static void init_once(void *foo)
 	inode_init_once(inode);
 }
 
-/*
- * inode_lock must be held
- */
-void __iget(struct inode *inode)
-{
-	assert_spin_locked(&inode->i_lock);
-	inode->i_count++;
-	if (inode->i_count > 1)
-		return;
-
-	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-		spin_lock(&wb_inode_list_lock);
-		list_move(&inode->i_list, &inode_in_use);
-		spin_unlock(&wb_inode_list_lock);
-	}
-	atomic_dec(&inodes_stat.nr_unused);
-}
-
 /**
  * clear_inode - clear an inode
  * @inode: inode to clear
@@ -359,7 +341,7 @@ static void dispose_list(struct list_hea
 		struct inode *inode;
 
 		inode = list_first_entry(head, struct inode, i_list);
-		list_del(&inode->i_list);
+		list_del_init(&inode->i_list);
 
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
@@ -412,11 +394,12 @@ static int invalidate_list(struct list_h
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
 			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_list, dispose);
+			list_del(&inode->i_list);
 			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
+			list_add(&inode->i_list, dispose);
 			count++;
 			continue;
 		}
@@ -503,7 +486,13 @@ again:
 			spin_unlock(&wb_inode_list_lock);
 			goto again;
 		}
-		if (inode->i_state || inode->i_count) {
+		if (inode->i_count) {
+			list_del_init(&inode->i_list);
+			spin_unlock(&inode->i_lock);
+			atomic_dec(&inodes_stat.nr_unused);
+			continue;
+		}
+		if (inode->i_state) {
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -519,6 +508,7 @@ again:
 again2:
 			spin_lock(&wb_inode_list_lock);
 
+			/* XXX: may no longer work well */
 			if (inode != list_entry(inode_unused.next,
 						struct inode, i_list))
 				continue;	/* wrong inode or list_empty */
@@ -667,9 +657,6 @@ __inode_add_to_lists(struct super_block
 	atomic_inc(&inodes_stat.nr_inodes);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
-	spin_lock(&wb_inode_list_lock);
-	list_add(&inode->i_list, &inode_in_use);
-	spin_unlock(&wb_inode_list_lock);
 	if (b) {
 		spin_lock(&b->lock);
 		hlist_add_head(&inode->i_hash, &b->head);
@@ -1316,9 +1303,11 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
-	spin_lock(&wb_inode_list_lock);
-	list_del_init(&inode->i_list);
-	spin_unlock(&wb_inode_list_lock);
+	if (!list_empty(&inode->i_list)) {
+		spin_lock(&wb_inode_list_lock);
+		list_del_init(&inode->i_list);
+		spin_unlock(&wb_inode_list_lock);
+	}
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1355,12 +1344,12 @@ static void generic_forget_inode(struct
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+		if (list_empty(&inode->i_list)) {
 			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_list, &inode_unused);
+			list_add(&inode->i_list, &inode_unused);
 			spin_unlock(&wb_inode_list_lock);
+			atomic_inc(&inodes_stat.nr_unused);
 		}
-		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
@@ -1376,11 +1365,13 @@ static void generic_forget_inode(struct
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
+	}
+	if (!list_empty(&inode->i_list)) {
+		spin_lock(&wb_inode_list_lock);
+		list_del_init(&inode->i_list);
+		spin_unlock(&wb_inode_list_lock);
 		atomic_dec(&inodes_stat.nr_unused);
 	}
-	spin_lock(&wb_inode_list_lock);
-	list_del_init(&inode->i_list);
-	spin_unlock(&wb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1705,7 +1696,7 @@ void __init inode_init(void)
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
+					sizeof(struct inode_hash_bucket),
 					ihash_entries,
 					14,
 					0,
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -2166,7 +2166,6 @@ extern int insert_inode_locked4(struct i
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
 
-extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
@@ -2384,6 +2383,12 @@ extern int generic_show_options(struct s
 extern void save_mount_options(struct super_block *sb, char *options);
 extern void replace_mount_options(struct super_block *sb, char *options);
 
+static inline void __iget(struct inode *inode)
+{
+	assert_spin_locked(&inode->i_lock);
+	inode->i_count++;
+}
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -429,7 +429,7 @@ writeback_single_inode(struct inode *ino
 			/*
 			 * The inode is clean, inuse
 			 */
-			list_move(&inode->i_list, &inode_in_use);
+			list_del_init(&inode->i_list);
 		} else {
 			/*
 			 * The inode is clean, unused
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -11,7 +11,6 @@ struct backing_dev_info;
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*



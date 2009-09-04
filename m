Return-Path: <linux-kernel-owner+w=401wt.eu-S933049AbZIDHDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbZIDHDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932979AbZIDHA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:00:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:56567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770AbZIDG6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:43 -0400
Message-Id: <20090904065538.866776742@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:12 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 31/33] fs: RCU free inodes
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_rcu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU free the struct inode. This will allow:

- sb_inode_list_lock to be moved inside i_lock because sb list walkers who want
  to take i_lock no longer need to take sb_inode_list_lock to walk the list in
  the first place. This will simplify and optimize locking.
- eventually, completely write-free RCU path walking. The inode must be
  consulted for permissions when walking, so a write-free reference (ie.
  RCU is helpful).
- can potentially simplify things a bit in VM land. May not need to take the
  page lock to get back to the page->mapping.
- can remove some nested trylock loops in dcache code

todo: convert all filesystems
---
 fs/block_dev.c       |    9 ++++++++-
 fs/ext2/super.c      |    9 ++++++++-
 fs/ext3/super.c      |    9 ++++++++-
 fs/hugetlbfs/inode.c |    9 ++++++++-
 fs/inode.c           |    9 ++++++++-
 fs/proc/inode.c      |    9 ++++++++-
 include/linux/fs.h   |    5 ++++-
 ipc/mqueue.c         |    9 ++++++++-
 net/socket.c         |    9 ++++++++-
 9 files changed, 68 insertions(+), 9 deletions(-)

Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c
+++ linux-2.6/fs/ext2/super.c
@@ -157,11 +157,18 @@ static struct inode *ext2_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void ext2_destroy_inode(struct inode *inode)
+static void ext2_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(ext2_inode_cachep, EXT2_I(inode));
 }
 
+static void ext2_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, ext2_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -252,13 +252,20 @@ void __destroy_inode(struct inode *inode
 }
 EXPORT_SYMBOL(__destroy_inode);
 
+static void i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(inode_cachep, inode);
+}
+
 void destroy_inode(struct inode *inode)
 {
 	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
-		kmem_cache_free(inode_cachep, (inode));
+		call_rcu(&inode->i_rcu, i_callback);
 }
 
 /*
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -718,7 +718,10 @@ struct inode {
 	struct hlist_node	i_hash;
 	struct list_head	i_list;
 	struct list_head	i_sb_list;
-	struct list_head	i_dentry;
+	union {
+		struct list_head	i_dentry;
+		struct rcu_head		i_rcu;
+	};
 	unsigned long		i_ino;
 	unsigned int		i_count;
 	unsigned int		i_nlink;
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c
+++ linux-2.6/fs/block_dev.c
@@ -416,14 +416,21 @@ static struct inode *bdev_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void bdev_destroy_inode(struct inode *inode)
+static void bdev_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct bdev_inode *bdi = BDEV_I(inode);
 
+	INIT_LIST_HEAD(&inode->i_dentry);
 	bdi->bdev.bd_inode_backing_dev_info = NULL;
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
+static void bdev_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, bdev_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c
+++ linux-2.6/fs/ext3/super.c
@@ -469,6 +469,13 @@ static struct inode *ext3_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
+static void ext3_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
+}
+
 static void ext3_destroy_inode(struct inode *inode)
 {
 	if (!list_empty(&(EXT3_I(inode)->i_orphan))) {
@@ -479,7 +486,7 @@ static void ext3_destroy_inode(struct in
 				false);
 		dump_stack();
 	}
-	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
+	call_rcu(&inode->i_rcu, ext3_i_callback);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -697,11 +697,18 @@ static struct inode *hugetlbfs_alloc_ino
 	return &p->vfs_inode;
 }
 
+static void hugetlbfs_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
+	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
+}
+
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
 	mpol_free_shared_policy(&HUGETLBFS_I(inode)->policy);
-	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
+	call_rcu(&inode->i_rcu, hugetlbfs_i_callback);
 }
 
 static const struct address_space_operations hugetlbfs_aops = {
Index: linux-2.6/fs/proc/inode.c
===================================================================
--- linux-2.6.orig/fs/proc/inode.c
+++ linux-2.6/fs/proc/inode.c
@@ -88,11 +88,18 @@ static struct inode *proc_alloc_inode(st
 	return inode;
 }
 
-static void proc_destroy_inode(struct inode *inode)
+static void proc_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(proc_inode_cachep, PROC_I(inode));
 }
 
+static void proc_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, proc_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c
+++ linux-2.6/ipc/mqueue.c
@@ -238,11 +238,18 @@ static struct inode *mqueue_alloc_inode(
 	return &ei->vfs_inode;
 }
 
-static void mqueue_destroy_inode(struct inode *inode)
+static void mqueue_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(mqueue_inode_cachep, MQUEUE_I(inode));
 }
 
+static void mqueue_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, mqueue_i_callback);
+}
+
 static void mqueue_delete_inode(struct inode *inode)
 {
 	struct mqueue_inode_info *info;
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c
+++ linux-2.6/net/socket.c
@@ -258,12 +258,19 @@ static struct inode *sock_alloc_inode(st
 	return &ei->vfs_inode;
 }
 
-static void sock_destroy_inode(struct inode *inode)
+static void sock_i_callback(struct rcu_head *head)
 {
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	INIT_LIST_HEAD(&inode->i_dentry);
 	kmem_cache_free(sock_inode_cachep,
 			container_of(inode, struct socket_alloc, vfs_inode));
 }
 
+static void sock_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, sock_i_callback);
+}
+
 static void init_once(void *foo)
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;



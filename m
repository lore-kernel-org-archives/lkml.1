Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbXEKSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbXEKSGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbXEKSGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:06:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58156 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757865AbXEKSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:06:42 -0400
Date: Fri, 11 May 2007 11:06:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Remove SLAB_CTOR_CONSTRUCTOR
Message-ID: <Pine.LNX.4.64.0705111105180.22949@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SLAB_CTOR_CONSTRUCTOR is always specified. No point in checking it.

[Sorry Andrew, another one of these "touch lots of kernel files" patch. Defer
if its not convenient.]

While we are at it: Fix bug in mtd/ubi/eba.c. Check was inverted.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-mm2/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/arch/powerpc/platforms/cell/spufs/inode.c	2007-05-11 10:29:43.000000000 -0700
+++ linux-2.6.21-mm2/arch/powerpc/platforms/cell/spufs/inode.c	2007-05-11 10:32:25.000000000 -0700
@@ -71,9 +71,7 @@ spufs_init_once(void *p, struct kmem_cac
 {
 	struct spufs_inode_info *ei = p;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&ei->vfs_inode);
-	}
+	inode_init_once(&ei->vfs_inode);
 }
 
 static struct inode *
Index: linux-2.6.21-mm2/drivers/mtd/ubi/eba.c
===================================================================
--- linux-2.6.21-mm2.orig/drivers/mtd/ubi/eba.c	2007-05-11 10:29:43.000000000 -0700
+++ linux-2.6.21-mm2/drivers/mtd/ubi/eba.c	2007-05-11 10:32:32.000000000 -0700
@@ -940,9 +940,6 @@ static void ltree_entry_ctor(void *obj, 
 {
 	struct ltree_entry *le = obj;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		return;
-
 	le->users = 0;
 	init_rwsem(&le->mutex);
 }
Index: linux-2.6.21-mm2/fs/adfs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/adfs/super.c	2007-05-11 10:29:43.000000000 -0700
+++ linux-2.6.21-mm2/fs/adfs/super.c	2007-05-11 10:32:42.000000000 -0700
@@ -232,8 +232,7 @@ static void init_once(void * foo, struct
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/affs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/affs/super.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/affs/super.c	2007-05-11 10:36:31.000000000 -0700
@@ -87,11 +87,9 @@ static void init_once(void * foo, struct
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		init_MUTEX(&ei->i_link_lock);
-		init_MUTEX(&ei->i_ext_lock);
-		inode_init_once(&ei->vfs_inode);
-	}
+	init_MUTEX(&ei->i_link_lock);
+	init_MUTEX(&ei->i_ext_lock);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/afs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/afs/super.c	2007-05-11 10:29:51.000000000 -0700
+++ linux-2.6.21-mm2/fs/afs/super.c	2007-05-11 10:35:07.000000000 -0700
@@ -454,17 +454,15 @@ static void afs_i_init_once(void *_vnode
 {
 	struct afs_vnode *vnode = _vnode;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		memset(vnode, 0, sizeof(*vnode));
-		inode_init_once(&vnode->vfs_inode);
-		init_waitqueue_head(&vnode->update_waitq);
-		mutex_init(&vnode->permits_lock);
-		mutex_init(&vnode->validate_lock);
-		spin_lock_init(&vnode->writeback_lock);
-		spin_lock_init(&vnode->lock);
-		INIT_LIST_HEAD(&vnode->writebacks);
-		INIT_WORK(&vnode->cb_broken_work, afs_broken_callback_work);
-	}
+	memset(vnode, 0, sizeof(*vnode));
+	inode_init_once(&vnode->vfs_inode);
+	init_waitqueue_head(&vnode->update_waitq);
+	mutex_init(&vnode->permits_lock);
+	mutex_init(&vnode->validate_lock);
+	spin_lock_init(&vnode->writeback_lock);
+	spin_lock_init(&vnode->lock);
+	INIT_LIST_HEAD(&vnode->writebacks);
+	INIT_WORK(&vnode->cb_broken_work, afs_broken_callback_work);
 }
 
 /*
Index: linux-2.6.21-mm2/fs/befs/linuxvfs.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/befs/linuxvfs.c	2007-05-11 10:29:50.000000000 -0700
+++ linux-2.6.21-mm2/fs/befs/linuxvfs.c	2007-05-11 10:34:22.000000000 -0700
@@ -292,10 +292,8 @@ befs_destroy_inode(struct inode *inode)
 static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
-	
-	        if (flags & SLAB_CTOR_CONSTRUCTOR) {
-			inode_init_once(&bi->vfs_inode);
-		}
+
+	inode_init_once(&bi->vfs_inode);
 }
 
 static void
Index: linux-2.6.21-mm2/fs/bfs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/bfs/inode.c	2007-05-11 10:29:54.000000000 -0700
+++ linux-2.6.21-mm2/fs/bfs/inode.c	2007-05-11 10:37:03.000000000 -0700
@@ -248,8 +248,7 @@ static void init_once(void * foo, struct
 {
 	struct bfs_inode_info *bi = foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&bi->vfs_inode);
+	inode_init_once(&bi->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/block_dev.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/block_dev.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/fs/block_dev.c	2007-05-11 10:23:24.000000000 -0700
@@ -460,17 +460,15 @@ static void init_once(void * foo, struct
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
 	struct block_device *bdev = &ei->bdev;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		memset(bdev, 0, sizeof(*bdev));
-		mutex_init(&bdev->bd_mutex);
-		sema_init(&bdev->bd_mount_sem, 1);
-		INIT_LIST_HEAD(&bdev->bd_inodes);
-		INIT_LIST_HEAD(&bdev->bd_list);
+	memset(bdev, 0, sizeof(*bdev));
+	mutex_init(&bdev->bd_mutex);
+	sema_init(&bdev->bd_mount_sem, 1);
+	INIT_LIST_HEAD(&bdev->bd_inodes);
+	INIT_LIST_HEAD(&bdev->bd_list);
 #ifdef CONFIG_SYSFS
-		INIT_LIST_HEAD(&bdev->bd_holder_list);
+	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
-		inode_init_once(&ei->vfs_inode);
-	}
+	inode_init_once(&ei->vfs_inode);
 }
 
 static inline void __bd_forget(struct inode *inode)
Index: linux-2.6.21-mm2/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/cifs/cifsfs.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/cifs/cifsfs.c	2007-05-11 10:36:23.000000000 -0700
@@ -701,10 +701,8 @@ cifs_init_once(void *inode, struct kmem_
 {
 	struct cifsInodeInfo *cifsi = inode;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&cifsi->vfs_inode);
-		INIT_LIST_HEAD(&cifsi->lockList);
-	}
+	inode_init_once(&cifsi->vfs_inode);
+	INIT_LIST_HEAD(&cifsi->lockList);
 }
 
 static int
Index: linux-2.6.21-mm2/fs/coda/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/coda/inode.c	2007-05-11 10:29:54.000000000 -0700
+++ linux-2.6.21-mm2/fs/coda/inode.c	2007-05-11 10:36:59.000000000 -0700
@@ -62,8 +62,7 @@ static void init_once(void * foo, struct
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 int coda_init_inodecache(void)
Index: linux-2.6.21-mm2/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ecryptfs/main.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/ecryptfs/main.c	2007-05-11 10:35:52.000000000 -0700
@@ -583,8 +583,7 @@ inode_info_init_once(void *vptr, struct 
 {
 	struct ecryptfs_inode_info *ei = (struct ecryptfs_inode_info *)vptr;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static struct ecryptfs_cache_info {
Index: linux-2.6.21-mm2/fs/efs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/efs/super.c	2007-05-11 10:29:53.000000000 -0700
+++ linux-2.6.21-mm2/fs/efs/super.c	2007-05-11 10:36:44.000000000 -0700
@@ -72,8 +72,7 @@ static void init_once(void * foo, struct
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/ext2/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ext2/super.c	2007-05-11 10:29:58.000000000 -0700
+++ linux-2.6.21-mm2/fs/ext2/super.c	2007-05-11 10:37:36.000000000 -0700
@@ -161,14 +161,12 @@ static void init_once(void * foo, struct
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		rwlock_init(&ei->i_meta_lock);
+	rwlock_init(&ei->i_meta_lock);
 #ifdef CONFIG_EXT2_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
+	init_rwsem(&ei->xattr_sem);
 #endif
-		mutex_init(&ei->truncate_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->truncate_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/ext3/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ext3/super.c	2007-05-11 10:29:47.000000000 -0700
+++ linux-2.6.21-mm2/fs/ext3/super.c	2007-05-11 10:34:02.000000000 -0700
@@ -466,14 +466,12 @@ static void init_once(void * foo, struct
 {
 	struct ext3_inode_info *ei = (struct ext3_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_orphan);
+	INIT_LIST_HEAD(&ei->i_orphan);
 #ifdef CONFIG_EXT3_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
+	init_rwsem(&ei->xattr_sem);
 #endif
-		mutex_init(&ei->truncate_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->truncate_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/ext4/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ext4/super.c	2007-05-11 10:29:44.000000000 -0700
+++ linux-2.6.21-mm2/fs/ext4/super.c	2007-05-11 10:33:08.000000000 -0700
@@ -526,14 +526,12 @@ static void init_once(void * foo, struct
 {
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_orphan);
+	INIT_LIST_HEAD(&ei->i_orphan);
 #ifdef CONFIG_EXT4DEV_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
+	init_rwsem(&ei->xattr_sem);
 #endif
-		mutex_init(&ei->truncate_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->truncate_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/fat/cache.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/fat/cache.c	2007-05-11 10:29:50.000000000 -0700
+++ linux-2.6.21-mm2/fs/fat/cache.c	2007-05-11 10:34:58.000000000 -0700
@@ -40,8 +40,7 @@ static void init_once(void *foo, struct 
 {
 	struct fat_cache *cache = (struct fat_cache *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		INIT_LIST_HEAD(&cache->cache_list);
+	INIT_LIST_HEAD(&cache->cache_list);
 }
 
 int __init fat_cache_init(void)
Index: linux-2.6.21-mm2/fs/fat/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/fat/inode.c	2007-05-11 10:29:50.000000000 -0700
+++ linux-2.6.21-mm2/fs/fat/inode.c	2007-05-11 10:34:53.000000000 -0700
@@ -500,14 +500,12 @@ static void init_once(void * foo, struct
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		spin_lock_init(&ei->cache_lru_lock);
-		ei->nr_caches = 0;
-		ei->cache_valid_id = FAT_CACHE_VALID + 1;
-		INIT_LIST_HEAD(&ei->cache_lru);
-		INIT_HLIST_NODE(&ei->i_fat_hash);
-		inode_init_once(&ei->vfs_inode);
-	}
+	spin_lock_init(&ei->cache_lru_lock);
+	ei->nr_caches = 0;
+	ei->cache_valid_id = FAT_CACHE_VALID + 1;
+	INIT_LIST_HEAD(&ei->cache_lru);
+	INIT_HLIST_NODE(&ei->i_fat_hash);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int __init fat_init_inodecache(void)
Index: linux-2.6.21-mm2/fs/fuse/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/fuse/inode.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/fuse/inode.c	2007-05-11 10:35:34.000000000 -0700
@@ -709,8 +709,7 @@ static void fuse_inode_init_once(void *f
 {
 	struct inode * inode = foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(inode);
+	inode_init_once(inode);
 }
 
 static int __init fuse_fs_init(void)
Index: linux-2.6.21-mm2/fs/gfs2/main.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/gfs2/main.c	2007-05-11 10:29:44.000000000 -0700
+++ linux-2.6.21-mm2/fs/gfs2/main.c	2007-05-11 10:32:52.000000000 -0700
@@ -27,12 +27,11 @@
 static void gfs2_init_inode_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_inode *ip = foo;
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&ip->i_inode);
-		spin_lock_init(&ip->i_spin);
-		init_rwsem(&ip->i_rw_mutex);
-		memset(ip->i_cache, 0, sizeof(ip->i_cache));
-	}
+
+	inode_init_once(&ip->i_inode);
+	spin_lock_init(&ip->i_spin);
+	init_rwsem(&ip->i_rw_mutex);
+	memset(ip->i_cache, 0, sizeof(ip->i_cache));
 }
 
 static void gfs2_init_glock_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
Index: linux-2.6.21-mm2/fs/hfs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/hfs/super.c	2007-05-11 10:29:45.000000000 -0700
+++ linux-2.6.21-mm2/fs/hfs/super.c	2007-05-11 10:33:48.000000000 -0700
@@ -434,8 +434,7 @@ static void hfs_init_once(void *p, struc
 {
 	struct hfs_inode_info *i = p;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&i->vfs_inode);
+	inode_init_once(&i->vfs_inode);
 }
 
 static int __init init_hfs_fs(void)
Index: linux-2.6.21-mm2/fs/hfsplus/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/hfsplus/super.c	2007-05-11 10:29:54.000000000 -0700
+++ linux-2.6.21-mm2/fs/hfsplus/super.c	2007-05-11 10:37:11.000000000 -0700
@@ -470,8 +470,7 @@ static void hfsplus_init_once(void *p, s
 {
 	struct hfsplus_inode_info *i = p;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&i->vfs_inode);
+	inode_init_once(&i->vfs_inode);
 }
 
 static int __init init_hfsplus_fs(void)
Index: linux-2.6.21-mm2/fs/hpfs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/hpfs/super.c	2007-05-11 10:29:58.000000000 -0700
+++ linux-2.6.21-mm2/fs/hpfs/super.c	2007-05-11 10:37:29.000000000 -0700
@@ -176,11 +176,9 @@ static void init_once(void * foo, struct
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		mutex_init(&ei->i_mutex);
-		mutex_init(&ei->i_parent_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->i_mutex);
+	mutex_init(&ei->i_parent_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/hugetlbfs/inode.c	2007-05-11 10:29:54.000000000 -0700
+++ linux-2.6.21-mm2/fs/hugetlbfs/inode.c	2007-05-11 10:37:07.000000000 -0700
@@ -556,8 +556,7 @@ static void init_once(void *foo, struct 
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
 
 const struct file_operations hugetlbfs_file_operations = {
Index: linux-2.6.21-mm2/fs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/inode.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/fs/inode.c	2007-05-11 10:23:33.000000000 -0700
@@ -223,8 +223,7 @@ static void init_once(void * foo, struct
 {
 	struct inode * inode = (struct inode *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(inode);
+	inode_init_once(inode);
 }
 
 /*
Index: linux-2.6.21-mm2/fs/isofs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/isofs/inode.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/isofs/inode.c	2007-05-11 10:35:43.000000000 -0700
@@ -77,8 +77,7 @@ static void init_once(void *foo, struct 
 {
 	struct iso_inode_info *ei = foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/jffs2/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/jffs2/super.c	2007-05-11 10:29:58.000000000 -0700
+++ linux-2.6.21-mm2/fs/jffs2/super.c	2007-05-11 10:37:42.000000000 -0700
@@ -47,10 +47,8 @@ static void jffs2_i_init_once(void * foo
 {
 	struct jffs2_inode_info *ei = (struct jffs2_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		init_MUTEX(&ei->sem);
-		inode_init_once(&ei->vfs_inode);
-	}
+	init_MUTEX(&ei->sem);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int jffs2_sync_fs(struct super_block *sb, int wait)
Index: linux-2.6.21-mm2/fs/jfs/jfs_metapage.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/jfs/jfs_metapage.c	2007-05-11 10:29:51.000000000 -0700
+++ linux-2.6.21-mm2/fs/jfs/jfs_metapage.c	2007-05-11 10:35:17.000000000 -0700
@@ -184,16 +184,14 @@ static void init_once(void *foo, struct 
 {
 	struct metapage *mp = (struct metapage *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		mp->lid = 0;
-		mp->lsn = 0;
-		mp->flag = 0;
-		mp->data = NULL;
-		mp->clsn = 0;
-		mp->log = NULL;
-		set_bit(META_free, &mp->flag);
-		init_waitqueue_head(&mp->wait);
-	}
+	mp->lid = 0;
+	mp->lsn = 0;
+	mp->flag = 0;
+	mp->data = NULL;
+	mp->clsn = 0;
+	mp->log = NULL;
+	set_bit(META_free, &mp->flag);
+	init_waitqueue_head(&mp->wait);
 }
 
 static inline struct metapage *alloc_metapage(gfp_t gfp_mask)
Index: linux-2.6.21-mm2/fs/jfs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/jfs/super.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/jfs/super.c	2007-05-11 10:35:30.000000000 -0700
@@ -752,20 +752,18 @@ static void init_once(void *foo, struct 
 {
 	struct jfs_inode_info *jfs_ip = (struct jfs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		memset(jfs_ip, 0, sizeof(struct jfs_inode_info));
-		INIT_LIST_HEAD(&jfs_ip->anon_inode_list);
-		init_rwsem(&jfs_ip->rdwrlock);
-		mutex_init(&jfs_ip->commit_mutex);
-		init_rwsem(&jfs_ip->xattr_sem);
-		spin_lock_init(&jfs_ip->ag_lock);
-		jfs_ip->active_ag = -1;
+	memset(jfs_ip, 0, sizeof(struct jfs_inode_info));
+	INIT_LIST_HEAD(&jfs_ip->anon_inode_list);
+	init_rwsem(&jfs_ip->rdwrlock);
+	mutex_init(&jfs_ip->commit_mutex);
+	init_rwsem(&jfs_ip->xattr_sem);
+	spin_lock_init(&jfs_ip->ag_lock);
+	jfs_ip->active_ag = -1;
 #ifdef CONFIG_JFS_POSIX_ACL
-		jfs_ip->i_acl = JFS_ACL_NOT_CACHED;
-		jfs_ip->i_default_acl = JFS_ACL_NOT_CACHED;
+	jfs_ip->i_acl = JFS_ACL_NOT_CACHED;
+	jfs_ip->i_default_acl = JFS_ACL_NOT_CACHED;
 #endif
-		inode_init_once(&jfs_ip->vfs_inode);
-	}
+	inode_init_once(&jfs_ip->vfs_inode);
 }
 
 static int __init init_jfs_fs(void)
Index: linux-2.6.21-mm2/fs/locks.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/locks.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/fs/locks.c	2007-05-11 10:23:42.000000000 -0700
@@ -203,9 +203,6 @@ static void init_once(void *foo, struct 
 {
 	struct file_lock *lock = (struct file_lock *) foo;
 
-	if (!(flags & SLAB_CTOR_CONSTRUCTOR))
-		return;
-
 	locks_init_lock(lock);
 }
 
Index: linux-2.6.21-mm2/fs/minix/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/minix/inode.c	2007-05-11 10:29:53.000000000 -0700
+++ linux-2.6.21-mm2/fs/minix/inode.c	2007-05-11 10:36:52.000000000 -0700
@@ -73,8 +73,7 @@ static void init_once(void * foo, struct
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/ncpfs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ncpfs/inode.c	2007-05-11 10:29:53.000000000 -0700
+++ linux-2.6.21-mm2/fs/ncpfs/inode.c	2007-05-11 10:36:40.000000000 -0700
@@ -60,10 +60,8 @@ static void init_once(void * foo, struct
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		mutex_init(&ei->open_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->open_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/nfs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/nfs/inode.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/nfs/inode.c	2007-05-11 10:36:18.000000000 -0700
@@ -1164,21 +1164,19 @@ static void init_once(void * foo, struct
 {
 	struct nfs_inode *nfsi = (struct nfs_inode *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&nfsi->vfs_inode);
-		spin_lock_init(&nfsi->req_lock);
-		INIT_LIST_HEAD(&nfsi->dirty);
-		INIT_LIST_HEAD(&nfsi->commit);
-		INIT_LIST_HEAD(&nfsi->open_files);
-		INIT_LIST_HEAD(&nfsi->access_cache_entry_lru);
-		INIT_LIST_HEAD(&nfsi->access_cache_inode_lru);
-		INIT_RADIX_TREE(&nfsi->nfs_page_tree, GFP_ATOMIC);
-		atomic_set(&nfsi->data_updates, 0);
-		nfsi->ndirty = 0;
-		nfsi->ncommit = 0;
-		nfsi->npages = 0;
-		nfs4_init_once(nfsi);
-	}
+	inode_init_once(&nfsi->vfs_inode);
+	spin_lock_init(&nfsi->req_lock);
+	INIT_LIST_HEAD(&nfsi->dirty);
+	INIT_LIST_HEAD(&nfsi->commit);
+	INIT_LIST_HEAD(&nfsi->open_files);
+	INIT_LIST_HEAD(&nfsi->access_cache_entry_lru);
+	INIT_LIST_HEAD(&nfsi->access_cache_inode_lru);
+	INIT_RADIX_TREE(&nfsi->nfs_page_tree, GFP_ATOMIC);
+	atomic_set(&nfsi->data_updates, 0);
+	nfsi->ndirty = 0;
+	nfsi->ncommit = 0;
+	nfsi->npages = 0;
+	nfs4_init_once(nfsi);
 }
  
 static int __init nfs_init_inodecache(void)
Index: linux-2.6.21-mm2/fs/ntfs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ntfs/super.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/ntfs/super.c	2007-05-11 10:36:07.000000000 -0700
@@ -3085,8 +3085,7 @@ static void ntfs_big_inode_init_once(voi
 {
 	ntfs_inode *ni = (ntfs_inode *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(VFS_I(ni));
+	inode_init_once(VFS_I(ni));
 }
 
 /*
Index: linux-2.6.21-mm2/fs/ocfs2/dlm/dlmfs.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ocfs2/dlm/dlmfs.c	2007-05-11 10:29:45.000000000 -0700
+++ linux-2.6.21-mm2/fs/ocfs2/dlm/dlmfs.c	2007-05-11 10:33:14.000000000 -0700
@@ -262,12 +262,10 @@ static void dlmfs_init_once(void *foo,
 	struct dlmfs_inode_private *ip =
 		(struct dlmfs_inode_private *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		ip->ip_dlm = NULL;
-		ip->ip_parent = NULL;
+	ip->ip_dlm = NULL;
+	ip->ip_parent = NULL;
 
-		inode_init_once(&ip->ip_vfs_inode);
-	}
+	inode_init_once(&ip->ip_vfs_inode);
 }
 
 static struct inode *dlmfs_alloc_inode(struct super_block *sb)
Index: linux-2.6.21-mm2/fs/ocfs2/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ocfs2/super.c	2007-05-11 10:29:45.000000000 -0700
+++ linux-2.6.21-mm2/fs/ocfs2/super.c	2007-05-11 10:33:32.000000000 -0700
@@ -937,31 +937,29 @@ static void ocfs2_inode_init_once(void *
 {
 	struct ocfs2_inode_info *oi = data;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		oi->ip_flags = 0;
-		oi->ip_open_count = 0;
-		spin_lock_init(&oi->ip_lock);
-		ocfs2_extent_map_init(&oi->vfs_inode);
-		INIT_LIST_HEAD(&oi->ip_io_markers);
-		oi->ip_created_trans = 0;
-		oi->ip_last_trans = 0;
-		oi->ip_dir_start_lookup = 0;
-
-		init_rwsem(&oi->ip_alloc_sem);
-		mutex_init(&oi->ip_io_mutex);
-
-		oi->ip_blkno = 0ULL;
-		oi->ip_clusters = 0;
-
-		ocfs2_lock_res_init_once(&oi->ip_rw_lockres);
-		ocfs2_lock_res_init_once(&oi->ip_meta_lockres);
-		ocfs2_lock_res_init_once(&oi->ip_data_lockres);
-		ocfs2_lock_res_init_once(&oi->ip_open_lockres);
+	oi->ip_flags = 0;
+	oi->ip_open_count = 0;
+	spin_lock_init(&oi->ip_lock);
+	ocfs2_extent_map_init(&oi->vfs_inode);
+	INIT_LIST_HEAD(&oi->ip_io_markers);
+	oi->ip_created_trans = 0;
+	oi->ip_last_trans = 0;
+	oi->ip_dir_start_lookup = 0;
+
+	init_rwsem(&oi->ip_alloc_sem);
+	mutex_init(&oi->ip_io_mutex);
+
+	oi->ip_blkno = 0ULL;
+	oi->ip_clusters = 0;
+
+	ocfs2_lock_res_init_once(&oi->ip_rw_lockres);
+	ocfs2_lock_res_init_once(&oi->ip_meta_lockres);
+	ocfs2_lock_res_init_once(&oi->ip_data_lockres);
+	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
-		ocfs2_metadata_cache_init(&oi->vfs_inode);
+	ocfs2_metadata_cache_init(&oi->vfs_inode);
 
-		inode_init_once(&oi->vfs_inode);
-	}
+	inode_init_once(&oi->vfs_inode);
 }
 
 static int ocfs2_initialize_mem_caches(void)
Index: linux-2.6.21-mm2/fs/openpromfs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/openpromfs/inode.c	2007-05-11 10:29:57.000000000 -0700
+++ linux-2.6.21-mm2/fs/openpromfs/inode.c	2007-05-11 10:37:23.000000000 -0700
@@ -419,8 +419,7 @@ static void op_inode_init_once(void *dat
 {
 	struct op_inode_info *oi = (struct op_inode_info *) data;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&oi->vfs_inode);
+	inode_init_once(&oi->vfs_inode);
 }
 
 static int __init init_openprom_fs(void)
Index: linux-2.6.21-mm2/fs/proc/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/proc/inode.c	2007-05-11 10:29:45.000000000 -0700
+++ linux-2.6.21-mm2/fs/proc/inode.c	2007-05-11 10:33:36.000000000 -0700
@@ -109,8 +109,7 @@ static void init_once(void * foo, struct
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 int __init proc_init_inodecache(void)
Index: linux-2.6.21-mm2/fs/qnx4/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/qnx4/inode.c	2007-05-11 10:29:43.000000000 -0700
+++ linux-2.6.21-mm2/fs/qnx4/inode.c	2007-05-11 10:32:37.000000000 -0700
@@ -536,8 +536,7 @@ static void init_once(void *foo, struct 
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/reiser4/super_ops.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/reiser4/super_ops.c	2007-05-11 10:29:50.000000000 -0700
+++ linux-2.6.21-mm2/fs/reiser4/super_ops.c	2007-05-11 10:34:45.000000000 -0700
@@ -33,25 +33,23 @@ static void init_once(void *obj, struct 
 
 	info = obj;
 
-	if ((flags & SLAB_CTOR_CONSTRUCTOR) == SLAB_CTOR_CONSTRUCTOR) {
-		/* initialize vfs inode */
-		inode_init_once(&info->vfs_inode);
-
-		/*
-		 * initialize reiser4 specific part fo inode.
-		 * NOTE-NIKITA add here initializations for locks, list heads,
-		 * etc. that will be added to our private inode part.
-		 */
-		INIT_LIST_HEAD(get_readdir_list(&info->vfs_inode));
-		init_rwsem(&info->p.conv_sem);
-		/* init semaphore which is used during inode loading */
-		loading_init_once(&info->p);
-		INIT_RADIX_TREE(jnode_tree_by_reiser4_inode(&info->p),
-				GFP_ATOMIC);
+	/* initialize vfs inode */
+	inode_init_once(&info->vfs_inode);
+
+	/*
+	 * initialize reiser4 specific part fo inode.
+	 * NOTE-NIKITA add here initializations for locks, list heads,
+	 * etc. that will be added to our private inode part.
+	 */
+	INIT_LIST_HEAD(get_readdir_list(&info->vfs_inode));
+	init_rwsem(&info->p.conv_sem);
+	/* init semaphore which is used during inode loading */
+	loading_init_once(&info->p);
+	INIT_RADIX_TREE(jnode_tree_by_reiser4_inode(&info->p),
+			GFP_ATOMIC);
 #if REISER4_DEBUG
-		info->p.nr_jnodes = 0;
+	info->p.nr_jnodes = 0;
 #endif
-	}
 }
 
 /**
Index: linux-2.6.21-mm2/fs/reiserfs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/reiserfs/super.c	2007-05-11 10:29:59.000000000 -0700
+++ linux-2.6.21-mm2/fs/reiserfs/super.c	2007-05-11 10:37:49.000000000 -0700
@@ -512,14 +512,12 @@ static void init_once(void *foo, struct 
 {
 	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_prealloc_list);
-		inode_init_once(&ei->vfs_inode);
+	INIT_LIST_HEAD(&ei->i_prealloc_list);
+	inode_init_once(&ei->vfs_inode);
 #ifdef CONFIG_REISERFS_FS_POSIX_ACL
-		ei->i_acl_access = NULL;
-		ei->i_acl_default = NULL;
+	ei->i_acl_access = NULL;
+	ei->i_acl_default = NULL;
 #endif
-	}
 }
 
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/revoke.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/revoke.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/fs/revoke.c	2007-05-11 10:23:50.000000000 -0700
@@ -739,10 +739,8 @@ static void revokefs_init_inode(void *ob
 {
 	struct revokefs_inode_info *info = obj;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		info->owner = NULL;
-		inode_init_once(&info->vfs_inode);
-	}
+	info->owner = NULL;
+	inode_init_once(&info->vfs_inode);
 }
 
 static int __init revokefs_init(void)
Index: linux-2.6.21-mm2/fs/romfs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/romfs/super.c	2007-05-11 10:29:48.000000000 -0700
+++ linux-2.6.21-mm2/fs/romfs/super.c	2007-05-11 10:34:13.000000000 -0700
@@ -594,8 +594,7 @@ static void romfs_i_init_once(void *_ino
 {
 	struct romfs_inode_info *inode = _inode;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&inode->vfs_inode);
+	inode_init_once(&inode->vfs_inode);
 }
 
 /*
Index: linux-2.6.21-mm2/fs/smbfs/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/smbfs/inode.c	2007-05-11 10:29:46.000000000 -0700
+++ linux-2.6.21-mm2/fs/smbfs/inode.c	2007-05-11 10:33:55.000000000 -0700
@@ -70,8 +70,7 @@ static void init_once(void * foo, struct
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/sysv/inode.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/sysv/inode.c	2007-05-11 10:29:53.000000000 -0700
+++ linux-2.6.21-mm2/fs/sysv/inode.c	2007-05-11 10:36:48.000000000 -0700
@@ -322,8 +322,7 @@ static void init_once(void *p, struct km
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&si->vfs_inode);
+	inode_init_once(&si->vfs_inode);
 }
 
 const struct super_operations sysv_sops = {
Index: linux-2.6.21-mm2/fs/udf/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/udf/super.c	2007-05-11 10:29:44.000000000 -0700
+++ linux-2.6.21-mm2/fs/udf/super.c	2007-05-11 10:32:58.000000000 -0700
@@ -134,10 +134,8 @@ static void init_once(void * foo, struct
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		ei->i_ext.i_data = NULL;
-		inode_init_once(&ei->vfs_inode);
-	}
+	ei->i_ext.i_data = NULL;
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/ufs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/ufs/super.c	2007-05-11 10:29:47.000000000 -0700
+++ linux-2.6.21-mm2/fs/ufs/super.c	2007-05-11 10:34:09.000000000 -0700
@@ -1237,8 +1237,7 @@ static void init_once(void * foo, struct
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/fs/unionfs/super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/unionfs/super.c	2007-05-11 10:29:52.000000000 -0700
+++ linux-2.6.21-mm2/fs/unionfs/super.c	2007-05-11 10:35:38.000000000 -0700
@@ -821,8 +821,7 @@ static void init_once(void *v, struct km
 {
 	struct unionfs_inode_info *i = v;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&i->vfs_inode);
+	inode_init_once(&i->vfs_inode);
 }
 
 int unionfs_init_inode_cache(void)
Index: linux-2.6.21-mm2/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.21-mm2.orig/fs/xfs/linux-2.6/xfs_super.c	2007-05-11 10:29:56.000000000 -0700
+++ linux-2.6.21-mm2/fs/xfs/linux-2.6/xfs_super.c	2007-05-11 10:37:19.000000000 -0700
@@ -360,8 +360,7 @@ xfs_fs_inode_init_once(
 	kmem_zone_t		*zonep,
 	unsigned long		flags)
 {
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
+	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
 
 STATIC int
Index: linux-2.6.21-mm2/include/linux/slab.h
===================================================================
--- linux-2.6.21-mm2.orig/include/linux/slab.h	2007-05-11 10:18:16.000000000 -0700
+++ linux-2.6.21-mm2/include/linux/slab.h	2007-05-11 10:38:24.000000000 -0700
@@ -32,9 +32,6 @@ typedef struct kmem_cache kmem_cache_t _
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
 
-/* Flags passed to a constructor functions */
-#define SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
-
 /*
  * struct kmem_cache related prototypes
  */
Index: linux-2.6.21-mm2/ipc/mqueue.c
===================================================================
--- linux-2.6.21-mm2.orig/ipc/mqueue.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/ipc/mqueue.c	2007-05-11 10:23:57.000000000 -0700
@@ -215,8 +215,7 @@ static void init_once(void *foo, struct 
 {
 	struct mqueue_inode_info *p = (struct mqueue_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&p->vfs_inode);
+	inode_init_once(&p->vfs_inode);
 }
 
 static struct inode *mqueue_alloc_inode(struct super_block *sb)
Index: linux-2.6.21-mm2/kernel/fork.c
===================================================================
--- linux-2.6.21-mm2.orig/kernel/fork.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/kernel/fork.c	2007-05-11 10:24:05.000000000 -0700
@@ -1437,10 +1437,8 @@ static void sighand_ctor(void *data, str
 {
 	struct sighand_struct *sighand = data;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		spin_lock_init(&sighand->siglock);
-		INIT_LIST_HEAD(&sighand->signalfd_list);
-	}
+	spin_lock_init(&sighand->siglock);
+	INIT_LIST_HEAD(&sighand->signalfd_list);
 }
 
 void __init proc_caches_init(void)
Index: linux-2.6.21-mm2/mm/rmap.c
===================================================================
--- linux-2.6.21-mm2.orig/mm/rmap.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/mm/rmap.c	2007-05-11 10:24:13.000000000 -0700
@@ -162,12 +162,10 @@ void anon_vma_unlink(struct vm_area_stru
 static void anon_vma_ctor(void *data, struct kmem_cache *cachep,
 			  unsigned long flags)
 {
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		struct anon_vma *anon_vma = data;
+	struct anon_vma *anon_vma = data;
 
-		spin_lock_init(&anon_vma->lock);
-		INIT_LIST_HEAD(&anon_vma->head);
-	}
+	spin_lock_init(&anon_vma->lock);
+	INIT_LIST_HEAD(&anon_vma->head);
 }
 
 void __init anon_vma_init(void)
Index: linux-2.6.21-mm2/mm/shmem.c
===================================================================
--- linux-2.6.21-mm2.orig/mm/shmem.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/mm/shmem.c	2007-05-11 10:24:20.000000000 -0700
@@ -2329,13 +2329,11 @@ static void init_once(void *foo, struct 
 {
 	struct shmem_inode_info *p = (struct shmem_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&p->vfs_inode);
+	inode_init_once(&p->vfs_inode);
 #ifdef CONFIG_TMPFS_POSIX_ACL
-		p->i_acl = NULL;
-		p->i_default_acl = NULL;
+	p->i_acl = NULL;
+	p->i_default_acl = NULL;
 #endif
-	}
 }
 
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/net/socket.c
===================================================================
--- linux-2.6.21-mm2.orig/net/socket.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/net/socket.c	2007-05-11 10:24:35.000000000 -0700
@@ -261,8 +261,7 @@ static void init_once(void *foo, struct 
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
Index: linux-2.6.21-mm2/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.21-mm2.orig/net/sunrpc/rpc_pipe.c	2007-05-11 10:30:00.000000000 -0700
+++ linux-2.6.21-mm2/net/sunrpc/rpc_pipe.c	2007-05-11 10:38:04.000000000 -0700
@@ -828,19 +828,17 @@ init_once(void * foo, struct kmem_cache 
 {
 	struct rpc_inode *rpci = (struct rpc_inode *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&rpci->vfs_inode);
-		rpci->private = NULL;
-		rpci->nreaders = 0;
-		rpci->nwriters = 0;
-		INIT_LIST_HEAD(&rpci->in_upcall);
-		INIT_LIST_HEAD(&rpci->pipe);
-		rpci->pipelen = 0;
-		init_waitqueue_head(&rpci->waitq);
-		INIT_DELAYED_WORK(&rpci->queue_timeout,
-				    rpc_timeout_upcall_queue);
-		rpci->ops = NULL;
-	}
+	inode_init_once(&rpci->vfs_inode);
+	rpci->private = NULL;
+	rpci->nreaders = 0;
+	rpci->nwriters = 0;
+	INIT_LIST_HEAD(&rpci->in_upcall);
+	INIT_LIST_HEAD(&rpci->pipe);
+	rpci->pipelen = 0;
+	init_waitqueue_head(&rpci->waitq);
+	INIT_DELAYED_WORK(&rpci->queue_timeout,
+			    rpc_timeout_upcall_queue);
+	rpci->ops = NULL;
 }
 
 int register_rpc_pipefs(void)
Index: linux-2.6.21-mm2/mm/slab.c
===================================================================
--- linux-2.6.21-mm2.orig/mm/slab.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/mm/slab.c	2007-05-11 10:39:26.000000000 -0700
@@ -2609,7 +2609,7 @@ static inline kmem_bufctl_t *slab_bufctl
 }
 
 static void cache_init_objs(struct kmem_cache *cachep,
-			    struct slab *slabp, unsigned long ctor_flags)
+			    struct slab *slabp)
 {
 	int i;
 
@@ -2633,7 +2633,7 @@ static void cache_init_objs(struct kmem_
 		 */
 		if (cachep->ctor && !(cachep->flags & SLAB_POISON))
 			cachep->ctor(objp + obj_offset(cachep), cachep,
-				     ctor_flags);
+				     0);
 
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone2(cachep, objp) != RED_INACTIVE)
@@ -2649,7 +2649,7 @@ static void cache_init_objs(struct kmem_
 					 cachep->buffer_size / PAGE_SIZE, 0);
 #else
 		if (cachep->ctor)
-			cachep->ctor(objp, cachep, ctor_flags);
+			cachep->ctor(objp, cachep, 0);
 #endif
 		slab_bufctl(slabp)[i] = i + 1;
 	}
@@ -2738,7 +2738,6 @@ static int cache_grow(struct kmem_cache 
 	struct slab *slabp;
 	size_t offset;
 	gfp_t local_flags;
-	unsigned long ctor_flags;
 	struct kmem_list3 *l3;
 
 	/*
@@ -2747,7 +2746,6 @@ static int cache_grow(struct kmem_cache 
 	 */
 	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
 
-	ctor_flags = SLAB_CTOR_CONSTRUCTOR;
 	local_flags = (flags & GFP_LEVEL_MASK);
 	/* Take the l3 list lock to change the colour_next on this node */
 	check_irq_off();
@@ -2792,7 +2790,7 @@ static int cache_grow(struct kmem_cache 
 	slabp->nodeid = nodeid;
 	slab_map_pages(cachep, slabp, objp);
 
-	cache_init_objs(cachep, slabp, ctor_flags);
+	cache_init_objs(cachep, slabp);
 
 	if (local_flags & __GFP_WAIT)
 		local_irq_disable();
Index: linux-2.6.21-mm2/mm/slob.c
===================================================================
--- linux-2.6.21-mm2.orig/mm/slob.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/mm/slob.c	2007-05-11 10:38:49.000000000 -0700
@@ -311,7 +311,7 @@ void *kmem_cache_alloc(struct kmem_cache
 		b = (void *)__get_free_pages(flags, get_order(c->size));
 
 	if (c->ctor)
-		c->ctor(b, c, SLAB_CTOR_CONSTRUCTOR);
+		c->ctor(b, c, 0);
 
 	return b;
 }
Index: linux-2.6.21-mm2/mm/slub.c
===================================================================
--- linux-2.6.21-mm2.orig/mm/slub.c	2007-05-11 10:22:44.000000000 -0700
+++ linux-2.6.21-mm2/mm/slub.c	2007-05-11 10:38:36.000000000 -0700
@@ -978,7 +978,7 @@ static void setup_object(struct kmem_cac
 	}
 
 	if (unlikely(s->ctor))
-		s->ctor(object, s, SLAB_CTOR_CONSTRUCTOR);
+		s->ctor(object, s, 0);
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbXDUBjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbXDUBjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 21:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXDUBjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 21:39:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58567 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754047AbXDUBjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 21:39:44 -0400
Date: Fri, 20 Apr 2007 18:39:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: slab allocators: Remove SLAB_DEBUG_INITIAL flag
Message-ID: <Pine.LNX.4.64.0704201832030.13607@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have never seen a use of SLAB_DEBUG_INITIAL. It is only supported by SLAB.

I think its purpose was to have a callback after an object has been freed
to verify that the state is the constructor state again? The callback is
performed before each freeing of an object.

I would think that it is much easier to check the object state manually
before the free. That also places the check near the code object
manipulation of the object.

Also the SLAB_DEBUG_INITIAL callback is only performed if the kernel was 
compiled with SLAB debugging on. If there would be code in a constructor 
handling SLAB_DEBUG_INITIAL then it would have to be conditional on 
SLAB_DEBUG otherwise it would just be dead code. But there is no such code 
in the kernel. I think SLUB_DEBUG_INITIAL is too problematic to make real 
use of, difficult to understand and there are easier ways to accomplish 
the same effect (i.e. add debug code before kfree).

There is a related flag SLAB_CTOR_VERIFY that is frequently checked
to be clear in fs inode caches. Remove the pointless checks 
(they would even be pointless without removeal of SLAB_DEBUG_INITIAL) 
from the fs constructors.

This is the last slab flag that SLUB did not support. Remove the check
for unimplemented flags from SLUB.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc6/include/linux/slab.h
===================================================================
--- linux-2.6.21-rc6.orig/include/linux/slab.h	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/include/linux/slab.h	2007-04-20 18:08:22.000000000 -0700
@@ -21,7 +21,6 @@ typedef struct kmem_cache kmem_cache_t _
  * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
  */
 #define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
-#define SLAB_DEBUG_INITIAL	0x00000200UL	/* DEBUG: Call constructor (as verifier) */
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
@@ -36,7 +35,6 @@ typedef struct kmem_cache kmem_cache_t _
 /* Flags passed to a constructor functions */
 #define SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
 #define SLAB_CTOR_ATOMIC	0x002UL		/* Tell constructor it can't sleep */
-#define SLAB_CTOR_VERIFY	0x004UL		/* Tell constructor it's a verify call */
 
 /*
  * struct kmem_cache related prototypes
Index: linux-2.6.21-rc6/mm/slab.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slab.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/mm/slab.c	2007-04-20 18:08:22.000000000 -0700
@@ -116,8 +116,7 @@
 #include	<asm/page.h>
 
 /*
- * DEBUG	- 1 for kmem_cache_create() to honour; SLAB_DEBUG_INITIAL,
- *		  SLAB_RED_ZONE & SLAB_POISON.
+ * DEBUG	- 1 for kmem_cache_create() to honour; SLAB_RED_ZONE & SLAB_POISON.
  *		  0 for faster, smaller code (especially in the critical paths).
  *
  * STATS	- 1 to collect stats for /proc/slabinfo.
@@ -172,7 +171,7 @@
 
 /* Legal flag mask for kmem_cache_create(). */
 #if DEBUG
-# define CREATE_MASK	(SLAB_DEBUG_INITIAL | SLAB_RED_ZONE | \
+# define CREATE_MASK	(SLAB_RED_ZONE | \
 			 SLAB_POISON | SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
 			 SLAB_STORE_USER | \
@@ -2182,12 +2181,6 @@ kmem_cache_create (const char *name, siz
 
 #if DEBUG
 	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
-	if ((flags & SLAB_DEBUG_INITIAL) && !ctor) {
-		/* No constructor, but inital state check requested */
-		printk(KERN_ERR "%s: No con, but init state check "
-		       "requested - %s\n", __FUNCTION__, name);
-		flags &= ~SLAB_DEBUG_INITIAL;
-	}
 #if FORCED_DEBUG
 	/*
 	 * Enable redzoning and last user accounting, except for caches with
@@ -2892,15 +2885,6 @@ static void *cache_free_debugcheck(struc
 	BUG_ON(objnr >= cachep->num);
 	BUG_ON(objp != index_to_obj(cachep, slabp, objnr));
 
-	if (cachep->flags & SLAB_DEBUG_INITIAL) {
-		/*
-		 * Need to call the slab's constructor so the caller can
-		 * perform a verify of its state (debugging).  Called without
-		 * the cache-lock held.
-		 */
-		cachep->ctor(objp + obj_offset(cachep),
-			     cachep, SLAB_CTOR_CONSTRUCTOR | SLAB_CTOR_VERIFY);
-	}
 	if (cachep->flags & SLAB_POISON && cachep->dtor) {
 		/* we want to cache poison the object,
 		 * call the destruction callback
Index: linux-2.6.21-rc6/drivers/mtd/ubi/eba.c
===================================================================
--- linux-2.6.21-rc6.orig/drivers/mtd/ubi/eba.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/drivers/mtd/ubi/eba.c	2007-04-20 18:08:22.000000000 -0700
@@ -940,8 +940,7 @@ static void ltree_entry_ctor(void *obj, 
 {
 	struct ltree_entry *le = obj;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) !=
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		return;
 
 	le->users = 0;
Index: linux-2.6.21-rc6/fs/block_dev.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/block_dev.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/block_dev.c	2007-04-20 18:08:22.000000000 -0700
@@ -455,9 +455,7 @@ static void init_once(void * foo, struct
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
 	struct block_device *bdev = &ei->bdev;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
-	{
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		memset(bdev, 0, sizeof(*bdev));
 		mutex_init(&bdev->bd_mutex);
 		sema_init(&bdev->bd_mount_sem, 1);
Index: linux-2.6.21-rc6/fs/buffer.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/buffer.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/buffer.c	2007-04-20 18:08:22.000000000 -0700
@@ -2961,8 +2961,7 @@ EXPORT_SYMBOL(free_buffer_head);
 static void
 init_buffer_head(void *data, struct kmem_cache *cachep, unsigned long flags)
 {
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-			    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		struct buffer_head * bh = (struct buffer_head *)data;
 
 		memset(bh, 0, sizeof(*bh));
Index: linux-2.6.21-rc6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/cifs/cifsfs.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/cifs/cifsfs.c	2007-04-20 18:08:22.000000000 -0700
@@ -693,8 +693,7 @@ cifs_init_once(void *inode, struct kmem_
 {
 	struct cifsInodeInfo *cifsi = inode;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&cifsi->vfs_inode);
 		INIT_LIST_HEAD(&cifsi->lockList);
 	}
Index: linux-2.6.21-rc6/fs/ext2/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ext2/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ext2/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -161,8 +161,7 @@ static void init_once(void * foo, struct
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		rwlock_init(&ei->i_meta_lock);
 #ifdef CONFIG_EXT2_FS_XATTR
 		init_rwsem(&ei->xattr_sem);
Index: linux-2.6.21-rc6/fs/ext3/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ext3/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ext3/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -466,8 +466,7 @@ static void init_once(void * foo, struct
 {
 	struct ext3_inode_info *ei = (struct ext3_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		INIT_LIST_HEAD(&ei->i_orphan);
 #ifdef CONFIG_EXT3_FS_XATTR
 		init_rwsem(&ei->xattr_sem);
Index: linux-2.6.21-rc6/fs/fuse/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/fuse/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/fuse/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -685,8 +685,7 @@ static void fuse_inode_init_once(void *f
 {
 	struct inode * inode = foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(inode);
 }
 
Index: linux-2.6.21-rc6/fs/gfs2/main.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/gfs2/main.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/gfs2/main.c	2007-04-20 18:08:22.000000000 -0700
@@ -27,8 +27,7 @@
 static void gfs2_init_inode_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_inode *ip = foo;
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&ip->i_inode);
 		spin_lock_init(&ip->i_spin);
 		init_rwsem(&ip->i_rw_mutex);
@@ -39,8 +38,7 @@ static void gfs2_init_inode_once(void *f
 static void gfs2_init_glock_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_glock *gl = foo;
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		INIT_HLIST_NODE(&gl->gl_list);
 		spin_lock_init(&gl->gl_spin);
 		INIT_LIST_HEAD(&gl->gl_holders);
Index: linux-2.6.21-rc6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/hugetlbfs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/hugetlbfs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -549,8 +549,7 @@ static void init_once(void *foo, struct 
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/fs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -213,8 +213,7 @@ static void init_once(void * foo, struct
 {
 	struct inode * inode = (struct inode *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(inode);
 }
 
Index: linux-2.6.21-rc6/fs/jffs2/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/jffs2/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/jffs2/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -49,8 +49,7 @@ static void jffs2_i_init_once(void * foo
 {
 	struct jffs2_inode_info *ei = (struct jffs2_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		init_MUTEX(&ei->sem);
 		inode_init_once(&ei->vfs_inode);
 	}
Index: linux-2.6.21-rc6/fs/nfs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/nfs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/nfs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -1162,8 +1162,7 @@ static void init_once(void * foo, struct
 {
 	struct nfs_inode *nfsi = (struct nfs_inode *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&nfsi->vfs_inode);
 		spin_lock_init(&nfsi->req_lock);
 		INIT_LIST_HEAD(&nfsi->dirty);
Index: linux-2.6.21-rc6/fs/ntfs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ntfs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ntfs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -3085,8 +3085,7 @@ static void ntfs_big_inode_init_once(voi
 {
 	ntfs_inode *ni = (ntfs_inode *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-			SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(VFS_I(ni));
 }
 
Index: linux-2.6.21-rc6/fs/ocfs2/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ocfs2/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ocfs2/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -937,8 +937,7 @@ static void ocfs2_inode_init_once(void *
 {
 	struct ocfs2_inode_info *oi = data;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		oi->ip_flags = 0;
 		oi->ip_open_count = 0;
 		spin_lock_init(&oi->ip_lock);
Index: linux-2.6.21-rc6/fs/reiserfs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/reiserfs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/reiserfs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -512,8 +512,7 @@ static void init_once(void *foo, struct 
 {
 	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		INIT_LIST_HEAD(&ei->i_prealloc_list);
 		inode_init_once(&ei->vfs_inode);
 #ifdef CONFIG_REISERFS_FS_POSIX_ACL
Index: linux-2.6.21-rc6/fs/romfs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/romfs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/romfs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -594,8 +594,7 @@ static void romfs_i_init_once(void *_ino
 {
 	struct romfs_inode_info *inode = _inode;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&inode->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/fs/unionfs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/unionfs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/unionfs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -209,8 +209,7 @@ static void init_once(void *v, struct km
 {
 	struct unionfs_inode_info *i = v;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&i->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/kernel/fork.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/fork.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/kernel/fork.c	2007-04-20 18:08:22.000000000 -0700
@@ -1426,8 +1426,7 @@ static void sighand_ctor(void *data, str
 {
 	struct sighand_struct *sighand = data;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-					SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		spin_lock_init(&sighand->siglock);
 }
 
Index: linux-2.6.21-rc6/mm/rmap.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/rmap.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/mm/rmap.c	2007-04-20 18:08:22.000000000 -0700
@@ -162,8 +162,7 @@ void anon_vma_unlink(struct vm_area_stru
 static void anon_vma_ctor(void *data, struct kmem_cache *cachep,
 			  unsigned long flags)
 {
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-						SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		struct anon_vma *anon_vma = data;
 
 		spin_lock_init(&anon_vma->lock);
Index: linux-2.6.21-rc6/mm/shmem.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/shmem.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/mm/shmem.c	2007-04-20 18:08:22.000000000 -0700
@@ -2329,8 +2329,7 @@ static void init_once(void *foo, struct 
 {
 	struct shmem_inode_info *p = (struct shmem_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&p->vfs_inode);
 #ifdef CONFIG_TMPFS_POSIX_ACL
 		p->i_acl = NULL;
Index: linux-2.6.21-rc6/net/socket.c
===================================================================
--- linux-2.6.21-rc6.orig/net/socket.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/net/socket.c	2007-04-20 18:08:22.000000000 -0700
@@ -261,8 +261,7 @@ static void init_once(void *foo, struct 
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR))
-	    == SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/arch/powerpc/platforms/cell/spufs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/arch/powerpc/platforms/cell/spufs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -69,8 +69,7 @@ spufs_init_once(void *p, struct kmem_cac
 {
 	struct spufs_inode_info *ei = p;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&ei->vfs_inode);
 	}
 }
Index: linux-2.6.21-rc6/fs/adfs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/adfs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/adfs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -232,8 +232,7 @@ static void init_once(void * foo, struct
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
Index: linux-2.6.21-rc6/fs/affs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/affs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/affs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -87,8 +87,7 @@ static void init_once(void * foo, struct
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		init_MUTEX(&ei->i_link_lock);
 		init_MUTEX(&ei->i_ext_lock);
 		inode_init_once(&ei->vfs_inode);
Index: linux-2.6.21-rc6/fs/afs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/afs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/afs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -387,8 +387,7 @@ static void afs_i_init_once(void *_vnode
 {
 	struct afs_vnode *vnode = (struct afs_vnode *) _vnode;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		memset(vnode, 0, sizeof(*vnode));
 		inode_init_once(&vnode->vfs_inode);
 		init_waitqueue_head(&vnode->update_waitq);
Index: linux-2.6.21-rc6/fs/befs/linuxvfs.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/befs/linuxvfs.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/befs/linuxvfs.c	2007-04-20 18:08:22.000000000 -0700
@@ -293,8 +293,7 @@ static void init_once(void * foo, struct
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
 	
-	        if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-		            SLAB_CTOR_CONSTRUCTOR) {
+	        if (flags & SLAB_CTOR_CONSTRUCTOR) {
 			inode_init_once(&bi->vfs_inode);
 		}
 }
Index: linux-2.6.21-rc6/fs/bfs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/bfs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/bfs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -248,8 +248,7 @@ static void init_once(void * foo, struct
 {
 	struct bfs_inode_info *bi = foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&bi->vfs_inode);
 }
  
Index: linux-2.6.21-rc6/fs/coda/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/coda/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/coda/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -62,8 +62,7 @@ static void init_once(void * foo, struct
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
Index: linux-2.6.21-rc6/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ecryptfs/main.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ecryptfs/main.c	2007-04-20 18:08:22.000000000 -0700
@@ -583,8 +583,7 @@ inode_info_init_once(void *vptr, struct 
 {
 	struct ecryptfs_inode_info *ei = (struct ecryptfs_inode_info *)vptr;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/fs/efs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/efs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/efs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -72,8 +72,7 @@ static void init_once(void * foo, struct
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
Index: linux-2.6.21-rc6/fs/ext4/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ext4/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ext4/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -517,8 +517,7 @@ static void init_once(void * foo, struct
 {
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		INIT_LIST_HEAD(&ei->i_orphan);
 #ifdef CONFIG_EXT4DEV_FS_XATTR
 		init_rwsem(&ei->xattr_sem);
Index: linux-2.6.21-rc6/fs/fat/cache.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/fat/cache.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/fat/cache.c	2007-04-20 18:08:22.000000000 -0700
@@ -40,8 +40,7 @@ static void init_once(void *foo, struct 
 {
 	struct fat_cache *cache = (struct fat_cache *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		INIT_LIST_HEAD(&cache->cache_list);
 }
 
Index: linux-2.6.21-rc6/fs/fat/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/fat/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/fat/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -499,8 +499,7 @@ static void init_once(void * foo, struct
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		spin_lock_init(&ei->cache_lru_lock);
 		ei->nr_caches = 0;
 		ei->cache_valid_id = FAT_CACHE_VALID + 1;
Index: linux-2.6.21-rc6/fs/hfs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/hfs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/hfs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -434,7 +434,7 @@ static void hfs_init_once(void *p, struc
 {
 	struct hfs_inode_info *i = p;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) == SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&i->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/fs/hfsplus/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/hfsplus/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/hfsplus/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -470,7 +470,7 @@ static void hfsplus_init_once(void *p, s
 {
 	struct hfsplus_inode_info *i = p;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) == SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&i->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/fs/hpfs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/hpfs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/hpfs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -176,8 +176,7 @@ static void init_once(void * foo, struct
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		mutex_init(&ei->i_mutex);
 		mutex_init(&ei->i_parent_mutex);
 		inode_init_once(&ei->vfs_inode);
Index: linux-2.6.21-rc6/fs/isofs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/isofs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/isofs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -77,8 +77,7 @@ static void init_once(void *foo, struct 
 {
 	struct iso_inode_info *ei = foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
Index: linux-2.6.21-rc6/fs/jfs/jfs_metapage.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/jfs/jfs_metapage.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/jfs/jfs_metapage.c	2007-04-20 18:08:22.000000000 -0700
@@ -184,8 +184,7 @@ static void init_once(void *foo, struct 
 {
 	struct metapage *mp = (struct metapage *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		mp->lid = 0;
 		mp->lsn = 0;
 		mp->flag = 0;
Index: linux-2.6.21-rc6/fs/jfs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/jfs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/jfs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -752,8 +752,7 @@ static void init_once(void *foo, struct 
 {
 	struct jfs_inode_info *jfs_ip = (struct jfs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		memset(jfs_ip, 0, sizeof(struct jfs_inode_info));
 		INIT_LIST_HEAD(&jfs_ip->anon_inode_list);
 		init_rwsem(&jfs_ip->rdwrlock);
Index: linux-2.6.21-rc6/fs/locks.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/locks.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/locks.c	2007-04-20 18:08:22.000000000 -0700
@@ -203,8 +203,7 @@ static void init_once(void *foo, struct 
 {
 	struct file_lock *lock = (struct file_lock *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) !=
-					SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		return;
 
 	locks_init_lock(lock);
Index: linux-2.6.21-rc6/fs/minix/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/minix/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/minix/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -73,8 +73,7 @@ static void init_once(void * foo, struct
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
Index: linux-2.6.21-rc6/fs/ncpfs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ncpfs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ncpfs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -60,8 +60,7 @@ static void init_once(void * foo, struct
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		mutex_init(&ei->open_mutex);
 		inode_init_once(&ei->vfs_inode);
 	}
Index: linux-2.6.21-rc6/fs/ocfs2/dlm/dlmfs.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ocfs2/dlm/dlmfs.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ocfs2/dlm/dlmfs.c	2007-04-20 18:08:22.000000000 -0700
@@ -263,8 +263,7 @@ static void dlmfs_init_once(void *foo,
 	struct dlmfs_inode_private *ip =
 		(struct dlmfs_inode_private *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		ip->ip_dlm = NULL;
 		ip->ip_parent = NULL;
 
Index: linux-2.6.21-rc6/fs/openpromfs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/openpromfs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/openpromfs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -419,8 +419,7 @@ static void op_inode_init_once(void *dat
 {
 	struct op_inode_info *oi = (struct op_inode_info *) data;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&oi->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/fs/qnx4/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/qnx4/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/qnx4/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -536,8 +536,7 @@ static void init_once(void *foo, struct 
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/fs/smbfs/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/smbfs/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/smbfs/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -69,9 +69,8 @@ static void smb_destroy_inode(struct ino
 static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
-	unsigned long flagmask = SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR;
 
-	if ((flags & flagmask) == SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
Index: linux-2.6.21-rc6/fs/sysv/inode.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/sysv/inode.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/sysv/inode.c	2007-04-20 18:08:22.000000000 -0700
@@ -322,8 +322,7 @@ static void init_once(void *p, struct km
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-			SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&si->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/fs/udf/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/udf/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/udf/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -134,9 +134,7 @@ static void init_once(void * foo, struct
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
-	{
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		ei->i_ext.i_data = NULL;
 		inode_init_once(&ei->vfs_inode);
 	}
Index: linux-2.6.21-rc6/fs/ufs/super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/ufs/super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/ufs/super.c	2007-04-20 18:08:22.000000000 -0700
@@ -1237,8 +1237,7 @@ static void init_once(void * foo, struct
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
Index: linux-2.6.21-rc6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/xfs/linux-2.6/xfs_super.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/fs/xfs/linux-2.6/xfs_super.c	2007-04-20 18:08:22.000000000 -0700
@@ -360,8 +360,7 @@ xfs_fs_inode_init_once(
 	kmem_zone_t		*zonep,
 	unsigned long		flags)
 {
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-		      SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
 
Index: linux-2.6.21-rc6/ipc/mqueue.c
===================================================================
--- linux-2.6.21-rc6.orig/ipc/mqueue.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/ipc/mqueue.c	2007-04-20 18:08:22.000000000 -0700
@@ -215,8 +215,7 @@ static void init_once(void *foo, struct 
 {
 	struct mqueue_inode_info *p = (struct mqueue_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-		SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&p->vfs_inode);
 }
 
Index: linux-2.6.21-rc6/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.21-rc6.orig/net/sunrpc/rpc_pipe.c	2007-04-20 18:07:16.000000000 -0700
+++ linux-2.6.21-rc6/net/sunrpc/rpc_pipe.c	2007-04-20 18:08:22.000000000 -0700
@@ -828,8 +828,7 @@ init_once(void * foo, struct kmem_cache 
 {
 	struct rpc_inode *rpci = (struct rpc_inode *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&rpci->vfs_inode);
 		rpci->private = NULL;
 		rpci->nreaders = 0;
Index: linux-2.6.21-rc6/mm/slub.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slub.c	2007-04-20 18:16:07.000000000 -0700
+++ linux-2.6.21-rc6/mm/slub.c	2007-04-20 18:16:48.000000000 -0700
@@ -103,20 +103,12 @@
  *
  * - Support PAGE_ALLOC_DEBUG. Should be easy to do.
  *
- * - SLAB_DEBUG_INITIAL is not supported but I have never seen a use of
- *   it.
- *
  * - Variable sizing of the per node arrays
  */
 
 /* Enable to test recovery from slab corruption on boot */
 #undef SLUB_RESILIENCY_TEST
 
-/*
- * Flags from the regular SLAB that SLUB does not support:
- */
-#define SLUB_UNIMPLEMENTED (SLAB_DEBUG_INITIAL)
-
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 /*
@@ -1757,8 +1749,6 @@ static int kmem_cache_open(struct kmem_c
 	s->flags = flags;
 	s->align = align;
 
-	BUG_ON(flags & SLUB_UNIMPLEMENTED);
-
 	/*
 	 * The page->offset field is only 16 bit wide. This is an offset
 	 * in units of words from the beginning of an object. If the slab

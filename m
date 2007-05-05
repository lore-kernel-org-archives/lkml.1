Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbXEEQId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbXEEQId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbXEEQId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:08:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56576 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbXEEQIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:08:32 -0400
Date: Sat, 5 May 2007 12:57:46 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, sct@redhat.com, adilger@clusterfs.com,
       clameter@sgi.com
Subject: [PATCH 1/4] ext2: remove inode constructor
Message-ID: <Pine.LNX.4.64.0705051256530.20886@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As alloc_inode() touches the same cache line as init_once(), we gain
nothing from using slab constructors.

Cc: Stephen C. Tweedie <sct@redhat.com>
Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/ext2/super.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

Index: 26-mm/fs/ext2/super.c
===================================================================
--- 26-mm.orig/fs/ext2/super.c	2007-05-05 12:26:15.000000000 +0300
+++ 26-mm/fs/ext2/super.c	2007-05-05 12:30:50.000000000 +0300
@@ -140,16 +140,24 @@ static struct kmem_cache * ext2_inode_ca
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
 	struct ext2_inode_info *ei;
-	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep,
-						GFP_KERNEL|__GFP_RECLAIMABLE);
+	struct inode *inode;
+
+	ei = kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL|__GFP_RECLAIMABLE);
 	if (!ei)
 		return NULL;
+	rwlock_init(&ei->i_meta_lock);
+#ifdef CONFIG_EXT2_FS_XATTR
+	init_rwsem(&ei->xattr_sem);
+#endif
+	mutex_init(&ei->truncate_mutex);
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 	ei->i_acl = EXT2_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 #endif
-	ei->vfs_inode.i_version = 1;
-	return &ei->vfs_inode;
+	inode = &ei->vfs_inode;
+	inode_init_once(inode);
+	inode->i_version = 1;
+	return inode;
 }
 
 static void ext2_destroy_inode(struct inode *inode)
@@ -157,27 +165,13 @@ static void ext2_destroy_inode(struct in
 	kmem_cache_free(ext2_inode_cachep, EXT2_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
-{
-	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
-
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		rwlock_init(&ei->i_meta_lock);
-#ifdef CONFIG_EXT2_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
-#endif
-		mutex_init(&ei->truncate_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
-}
- 
 static int init_inodecache(void)
 {
 	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
 					     sizeof(struct ext2_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
-					     init_once, NULL);
+					     NULL, NULL);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

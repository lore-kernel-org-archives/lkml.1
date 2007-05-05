Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXEEQJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXEEQJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXEEQJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:09:48 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56576 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278AbXEEQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:09:47 -0400
Date: Sat, 5 May 2007 12:59:13 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, sct@redhat.com, adilger@clusterfs.com,
       clameter@sgi.com
Subject: [PATCH 3/4] ext4: remove inode constructor
Message-ID: <Pine.LNX.4.64.0705051258310.20886@sbz-30.cs.Helsinki.FI>
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
 fs/ext4/super.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

Index: 26-mm/fs/ext4/super.c
===================================================================
--- 26-mm.orig/fs/ext4/super.c	2007-05-05 12:26:44.000000000 +0300
+++ 26-mm/fs/ext4/super.c	2007-05-05 12:28:56.000000000 +0300
@@ -496,16 +496,21 @@ static struct kmem_cache *ext4_inode_cac
 static struct inode *ext4_alloc_inode(struct super_block *sb)
 {
 	struct ext4_inode_info *ei;
+	struct inode *inode;
 
 	ei = kmem_cache_alloc(ext4_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
+	INIT_LIST_HEAD(&ei->i_orphan);
+#ifdef CONFIG_EXT4DEV_FS_XATTR
+	init_rwsem(&ei->xattr_sem);
+#endif
+	mutex_init(&ei->truncate_mutex);
 #ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	ei->i_acl = EXT4_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT4_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
-	ei->vfs_inode.i_version = 1;
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 
 	/* FIXME: these wb-related fields could be initialized once */
@@ -514,7 +519,10 @@ 	ei->i_md_reserved = 0;
 	atomic_set(&ei->i_wb_writers, 0);
 	spin_lock_init(&ei->i_wb_reserved_lock);
 
-	return &ei->vfs_inode;
+	inode = &ei->vfs_inode;
+	inode_init_once(inode);
+	inode->i_version = 1;
+	return inode;
 }
 
 static void ext4_destroy_inode(struct inode *inode)
@@ -522,27 +530,13 @@ static void ext4_destroy_inode(struct in
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
-{
-	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
-
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_orphan);
-#ifdef CONFIG_EXT4DEV_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
-#endif
-		mutex_init(&ei->truncate_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
-}
-
 static int init_inodecache(void)
 {
 	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
 					     sizeof(struct ext4_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
-					     init_once, NULL);
+					     NULL, NULL);
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

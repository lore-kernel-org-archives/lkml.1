Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbXEEQKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbXEEQKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbXEEQKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:10:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56576 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbXEEQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:10:22 -0400
Date: Sat, 5 May 2007 12:59:46 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com, clameter@sgi.com
Subject: [PATCH 4/4] reiserfs: remove inode constructor
Message-ID: <Pine.LNX.4.64.0705051259160.20886@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As alloc_inode() touches the same cache line as init_once(), we gain
nothing from using slab constructors.

Cc: <reiserfs-dev@namesys.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/reiserfs/super.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

Index: 26-mm/fs/reiserfs/super.c
===================================================================
--- 26-mm.orig/fs/reiserfs/super.c	2007-05-03 11:14:12.000000000 +0300
+++ 26-mm/fs/reiserfs/super.c	2007-05-05 12:34:56.000000000 +0300
@@ -495,12 +495,21 @@ static struct kmem_cache *reiserfs_inode
 static struct inode *reiserfs_alloc_inode(struct super_block *sb)
 {
 	struct reiserfs_inode_info *ei;
-	ei = (struct reiserfs_inode_info *)
-	    kmem_cache_alloc(reiserfs_inode_cachep,
-						GFP_KERNEL|__GFP_RECLAIMABLE);
+	struct inode *inode;
+
+	ei = kmem_cache_alloc(reiserfs_inode_cachep,
+			      GFP_KERNEL|__GFP_RECLAIMABLE);
 	if (!ei)
 		return NULL;
-	return &ei->vfs_inode;
+
+	INIT_LIST_HEAD(&ei->i_prealloc_list);
+#ifdef CONFIG_REISERFS_FS_POSIX_ACL
+	ei->i_acl_access = NULL;
+	ei->i_acl_default = NULL;
+#endif
+	inode = &ei->vfs_inode;
+	inode_init_once(inode);
+	return inode;
 }
 
 static void reiserfs_destroy_inode(struct inode *inode)
@@ -508,20 +517,6 @@ static void reiserfs_destroy_inode(struc
 	kmem_cache_free(reiserfs_inode_cachep, REISERFS_I(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
-{
-	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
-
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_prealloc_list);
-		inode_init_once(&ei->vfs_inode);
-#ifdef CONFIG_REISERFS_FS_POSIX_ACL
-		ei->i_acl_access = NULL;
-		ei->i_acl_default = NULL;
-#endif
-	}
-}
-
 static int init_inodecache(void)
 {
 	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
@@ -529,7 +524,7 @@ static int init_inodecache(void)
 							 reiserfs_inode_info),
 						  0, (SLAB_RECLAIM_ACCOUNT|
 							SLAB_MEM_SPREAD),
-						  init_once, NULL);
+						  NULL, NULL);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

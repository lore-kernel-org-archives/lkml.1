Return-Path: <linux-kernel-owner+w=401wt.eu-S1763130AbXFRKIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763130AbXFRKIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761491AbXFRJ7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58632 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760045AbXFRJ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:17 -0400
Message-Id: <20070618095917.242949306@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:58:54 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 16/26] Slab defragmentation: Support defragmentation for extX filesystem inodes
Content-Disposition: inline; filename=slub_defrag_fs_ext234
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ext2/super.c |   16 ++++++++++++++--
 fs/ext3/super.c |   14 +++++++++++++-
 fs/ext4/super.c |   14 +++++++++++++-
 3 files changed, 40 insertions(+), 4 deletions(-)

Index: slub/fs/ext2/super.c
===================================================================
--- slub.orig/fs/ext2/super.c	2007-06-07 14:09:36.000000000 -0700
+++ slub/fs/ext2/super.c	2007-06-07 14:28:47.000000000 -0700
@@ -168,14 +168,26 @@ static void init_once(void * foo, struct
 	mutex_init(&ei->truncate_mutex);
 	inode_init_once(&ei->vfs_inode);
 }
- 
+
+static void *ext2_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext2_inode_info, vfs_inode));
+}
+
+static struct kmem_cache_ops ext2_kmem_cache_ops = {
+	.get = ext2_get_inodes,
+	.kick = kick_inodes
+};
+
 static int init_inodecache(void)
 {
 	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
 					     sizeof(struct ext2_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
-					     init_once, NULL);
+					     init_once,
+					     &ext2_kmem_cache_ops);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
Index: slub/fs/ext3/super.c
===================================================================
--- slub.orig/fs/ext3/super.c	2007-06-07 14:09:36.000000000 -0700
+++ slub/fs/ext3/super.c	2007-06-07 14:28:47.000000000 -0700
@@ -483,13 +483,25 @@ static void init_once(void * foo, struct
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *ext3_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext3_inode_info, vfs_inode));
+}
+
+static struct kmem_cache_ops ext3_kmem_cache_ops = {
+	.get = ext3_get_inodes,
+	.kick = kick_inodes
+};
+
 static int init_inodecache(void)
 {
 	ext3_inode_cachep = kmem_cache_create("ext3_inode_cache",
 					     sizeof(struct ext3_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
-					     init_once, NULL);
+					     init_once,
+					     &ext3_kmem_cache_ops);
 	if (ext3_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
Index: slub/fs/ext4/super.c
===================================================================
--- slub.orig/fs/ext4/super.c	2007-06-07 14:09:36.000000000 -0700
+++ slub/fs/ext4/super.c	2007-06-07 14:29:49.000000000 -0700
@@ -543,13 +543,25 @@ static void init_once(void * foo, struct
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *ext4_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext4_inode_info, vfs_inode));
+}
+
+static struct kmem_cache_ops ext4_kmem_cache_ops = {
+	.get = ext4_get_inodes,
+	.kick = kick_inodes
+};
+
 static int init_inodecache(void)
 {
 	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
 					     sizeof(struct ext4_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
-					     init_once, NULL);
+					     init_once,
+					     &ext4_kmem_cache_ops);
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

-- 

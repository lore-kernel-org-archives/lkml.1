Return-Path: <linux-kernel-owner+w=401wt.eu-S1763689AbXERSOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763689AbXERSOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbXERSL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:11:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58629 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756589AbXERSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:11:21 -0400
Message-Id: <20070518181120.938438348@sgi.com>
References: <20070518181040.465335396@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 May 2007 11:10:50 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Cc: Hugh Dickins <hugh@veritas.com>
Subject: [patch 10/10] ext2 ext3 ext4: support inode slab defragmentation
Content-Disposition: inline; filename=fs_ext234
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ext2/super.c |   16 ++++++++++++++--
 fs/ext3/super.c |   14 +++++++++++++-
 fs/ext4/super.c |   15 ++++++++++++++-
 3 files changed, 41 insertions(+), 4 deletions(-)

Index: slub/fs/ext2/super.c
===================================================================
--- slub.orig/fs/ext2/super.c	2007-05-18 10:19:12.000000000 -0700
+++ slub/fs/ext2/super.c	2007-05-18 10:24:03.000000000 -0700
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
+	ext2_get_inodes,
+	kick_inodes
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
--- slub.orig/fs/ext3/super.c	2007-05-18 10:22:01.000000000 -0700
+++ slub/fs/ext3/super.c	2007-05-18 10:23:04.000000000 -0700
@@ -475,13 +475,25 @@ static void init_once(void * foo, struct
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *ext3_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext3_inode_info, vfs_inode));
+}
+
+static struct kmem_cache_ops ext3_kmem_cache_ops = {
+	ext3_get_inodes,
+	kick_inodes
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
--- slub.orig/fs/ext4/super.c	2007-05-18 10:23:15.000000000 -0700
+++ slub/fs/ext4/super.c	2007-05-18 10:23:48.000000000 -0700
@@ -535,13 +535,26 @@ static void init_once(void * foo, struct
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *ext4_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext4_inode_info, vfs_inode));
+}
+
+static struct kmem_cache_ops ext4_kmem_cache_ops = {
+	ext4_get_inodes,
+	kick_inodes
+};
+
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

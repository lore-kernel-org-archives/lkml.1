Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbXGHDM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbXGHDM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbXGHDJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:09:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46570 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755206AbXGHDIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:08:46 -0400
Message-Id: <20070708030845.503538007@sgi.com>
References: <20070708030538.729027694@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:05:47 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: dgc@sgi.com
Subject: [patch 09/12] Slab defragmentation: Support defragmentation for extX filesystem inodes
Content-Disposition: inline; filename=slub_defrag_fs_ext234
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic API for inodes established earlier to support all extX
filesystem.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ext2/super.c |   16 ++++++++++++++--
 fs/ext3/super.c |   14 +++++++++++++-
 fs/ext4/super.c |   14 +++++++++++++-
 3 files changed, 40 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc6-mm1/fs/ext2/super.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/fs/ext2/super.c	2007-07-03 17:19:26.000000000 -0700
+++ linux-2.6.22-rc6-mm1/fs/ext2/super.c	2007-07-03 17:28:49.000000000 -0700
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
Index: linux-2.6.22-rc6-mm1/fs/ext3/super.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/fs/ext3/super.c	2007-07-03 17:19:26.000000000 -0700
+++ linux-2.6.22-rc6-mm1/fs/ext3/super.c	2007-07-03 17:28:49.000000000 -0700
@@ -484,13 +484,25 @@ static void init_once(void * foo, struct
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
Index: linux-2.6.22-rc6-mm1/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/fs/ext4/super.c	2007-07-03 17:19:26.000000000 -0700
+++ linux-2.6.22-rc6-mm1/fs/ext4/super.c	2007-07-03 17:28:49.000000000 -0700
@@ -544,13 +544,25 @@ static void init_once(void * foo, struct
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762398AbXFRKHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398AbXFRKHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760332AbXFRJ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58649 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760097AbXFRJ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:18 -0400
Message-Id: <20070618095917.943779191@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:58:57 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 19/26] Slab defragmentation: Support reiserfs inode defragmentation
Content-Disposition: inline; filename=slub_defrag_fs_reiser
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add inode defrag support

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/reiserfs/super.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: slub/fs/reiserfs/super.c
===================================================================
--- slub.orig/fs/reiserfs/super.c	2007-06-07 14:09:36.000000000 -0700
+++ slub/fs/reiserfs/super.c	2007-06-07 14:30:49.000000000 -0700
@@ -520,6 +520,17 @@ static void init_once(void *foo, struct 
 #endif
 }
 
+static void *reiserfs_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+			offsetof(struct reiserfs_inode_info, vfs_inode));
+}
+
+struct kmem_cache_ops reiserfs_kmem_cache_ops = {
+	.get = reiserfs_get_inodes,
+	.kick = kick_inodes
+};
+
 static int init_inodecache(void)
 {
 	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
@@ -527,7 +538,8 @@ static int init_inodecache(void)
 							 reiserfs_inode_info),
 						  0, (SLAB_RECLAIM_ACCOUNT|
 							SLAB_MEM_SPREAD),
-						  init_once, NULL);
+						  init_once,
+						  &reiserfs_kmem_cache_ops);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;

-- 

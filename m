Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbXKGBTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbXKGBTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXKGBMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:12:48 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44723 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755389AbXKGBMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:12:32 -0500
Message-Id: <20071107011231.453090374@sgi.com>
References: <20071107011130.382244340@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 17:11:50 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundatin.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 20/23] dentries: Add constructor
Content-Disposition: inline; filename=0024-slab_defrag_dentry_state.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support defragmentation on the dentry cache we need to have
a determined object state at all times. Without a constructor the object
would have a random state after allocation.

Reviewed-by: Rik van Riel <riel@redhat.com>
So provide a constructor.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/dcache.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2007-11-06 12:56:56.000000000 -0800
+++ linux-2.6/fs/dcache.c	2007-11-06 12:57:01.000000000 -0800
@@ -870,6 +870,16 @@ static struct shrinker dcache_shrinker =
 	.seeks = DEFAULT_SEEKS,
 };
 
+void dcache_ctor(struct kmem_cache *s, void *p)
+{
+	struct dentry *dentry = p;
+
+	spin_lock_init(&dentry->d_lock);
+	dentry->d_inode = NULL;
+	INIT_LIST_HEAD(&dentry->d_lru);
+	INIT_LIST_HEAD(&dentry->d_alias);
+}
+
 /**
  * d_alloc	-	allocate a dcache entry
  * @parent: parent of entry to allocate
@@ -907,8 +917,6 @@ struct dentry *d_alloc(struct dentry * p
 
 	atomic_set(&dentry->d_count, 1);
 	dentry->d_flags = DCACHE_UNHASHED;
-	spin_lock_init(&dentry->d_lock);
-	dentry->d_inode = NULL;
 	dentry->d_parent = NULL;
 	dentry->d_sb = NULL;
 	dentry->d_op = NULL;
@@ -918,9 +926,7 @@ struct dentry *d_alloc(struct dentry * p
 	dentry->d_cookie = NULL;
 #endif
 	INIT_HLIST_NODE(&dentry->d_hash);
-	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
-	INIT_LIST_HEAD(&dentry->d_alias);
 
 	if (parent) {
 		dentry->d_parent = dget(parent);
@@ -2096,14 +2102,10 @@ static void __init dcache_init(void)
 {
 	int loop;
 
-	/* 
-	 * A constructor could be added for stable state like the lists,
-	 * but it is probably not worth it because of the cache nature
-	 * of the dcache. 
-	 */
-	dentry_cache = KMEM_CACHE(dentry,
-		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
-	
+	dentry_cache = kmem_cache_create("dentry_cache", sizeof(struct dentry),
+		0, SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD,
+		dcache_ctor);
+
 	register_shrinker(&dcache_shrinker);
 
 	/* Hash may have been set up in dcache_init_early */

-- 

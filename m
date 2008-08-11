Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYHKPOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYHKPOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYHKPOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:14:20 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:57976 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYHKPOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:14:18 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2008 11:14:17 EDT
Message-Id: <20080811150702.264510758@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:34 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 18/19] dentries: Add constructor
Content-Disposition: inline; filename=0031-dentries-Add-constructor.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support defragmentation on the dentry cache we need to have
a determined object state at all times. Without a constructor the object
would have a random state after allocation.

So provide a constructor.

Cc: Alexander Viro <viro@ftp.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/dcache.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: linux-next/fs/dcache.c
===================================================================
--- linux-next.orig/fs/dcache.c	2008-08-11 07:42:10.072351650 -0700
+++ linux-next/fs/dcache.c	2008-08-11 07:50:02.361383352 -0700
@@ -899,6 +899,16 @@ static struct shrinker dcache_shrinker =
 	.seeks = DEFAULT_SEEKS,
 };
 
+static void dcache_ctor(void *p)
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
@@ -936,8 +946,6 @@ struct dentry *d_alloc(struct dentry * p
 
 	atomic_set(&dentry->d_count, 1);
 	dentry->d_flags = DCACHE_UNHASHED;
-	spin_lock_init(&dentry->d_lock);
-	dentry->d_inode = NULL;
 	dentry->d_parent = NULL;
 	dentry->d_sb = NULL;
 	dentry->d_op = NULL;
@@ -947,9 +955,7 @@ struct dentry *d_alloc(struct dentry * p
 	dentry->d_cookie = NULL;
 #endif
 	INIT_HLIST_NODE(&dentry->d_hash);
-	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
-	INIT_LIST_HEAD(&dentry->d_alias);
 
 	if (parent) {
 		dentry->d_parent = dget(parent);
@@ -2275,14 +2281,10 @@ static void __init dcache_init(void)
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

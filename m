Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYHASjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYHASjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbYHASjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:39:10 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:14216 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYHASjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:39:09 -0400
Message-Id: <20080801182348.146243876@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:19 -0700
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

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-07-31 12:18:11.000000000 -0500
+++ linux-2.6/fs/dcache.c	2008-07-31 12:18:27.000000000 -0500
@@ -899,6 +899,16 @@
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
@@ -936,8 +946,6 @@
 
 	atomic_set(&dentry->d_count, 1);
 	dentry->d_flags = DCACHE_UNHASHED;
-	spin_lock_init(&dentry->d_lock);
-	dentry->d_inode = NULL;
 	dentry->d_parent = NULL;
 	dentry->d_sb = NULL;
 	dentry->d_op = NULL;
@@ -947,9 +955,7 @@
 	dentry->d_cookie = NULL;
 #endif
 	INIT_HLIST_NODE(&dentry->d_hash);
-	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
-	INIT_LIST_HEAD(&dentry->d_alias);
 
 	if (parent) {
 		dentry->d_parent = dget(parent);
@@ -2174,14 +2180,10 @@
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

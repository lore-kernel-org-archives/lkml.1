Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbYAWT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbYAWT0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYAWT03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:26:29 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46714 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYAWT03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:26:29 -0500
Date: Wed, 23 Jan 2008 21:26:26 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: olaf@aepfle.de
cc: mel@csn.ul.ie, clameter@sgi.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] slab: fix bootstrap on memoryless node
Message-ID: <Pine.LNX.4.64.0801232119140.11343@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

If the node we're booting on doesn't have memory, bootstrapping kmalloc()
caches resorts to fallback_alloc() which requires ->nodelists set for all
nodes.  Fix that by calling set_up_list3s() for CACHE_CACHE in
kmem_cache_init().

Tested-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Olaf, can you please test this against a clean git head with this revert 
applied before this patch:

http://www.csn.ul.ie/~mel/revert-memoryless-slab.diff

Mel tested this already and I assume it fixes your configuration also.

Andrew, if Olaf confirms this fix, you want to merge this to 2.6.24? 
It needs to be applied on top of the revert Mel has already sent (the 
revert by itself is not enough to fix Olaf's configuration).

			Pekka 

 mm/slab.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c
+++ linux-2.6/mm/slab.c
@@ -304,11 +304,11 @@ struct kmem_list3 {
 /*
  * Need this for bootstrapping a per node allocator.
  */
-#define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
+#define NUM_INIT_LISTS (3 * MAX_NUMNODES)
 struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
-#define	SIZE_AC 1
-#define	SIZE_L3 (1 + MAX_NUMNODES)
+#define	SIZE_AC MAX_NUMNODES
+#define	SIZE_L3 (2 * MAX_NUMNODES)
 
 static int drain_freelist(struct kmem_cache *cache,
 			struct kmem_list3 *l3, int tofree);
@@ -1410,6 +1410,22 @@ static void init_list(struct kmem_cache 
 }
 
 /*
+ * For setting up all the kmem_list3s for cache whose buffer_size is same as
+ * size of kmem_list3.
+ */
+static void __init set_up_list3s(struct kmem_cache *cachep, int index)
+{
+	int node;
+
+	for_each_online_node(node) {
+		cachep->nodelists[node] = &initkmem_list3[index + node];
+		cachep->nodelists[node]->next_reap = jiffies +
+		    REAPTIMEOUT_LIST3 +
+		    ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
+	}
+}
+
+/*
  * Initialisation.  Called after the page allocator have been initialised and
  * before smp_init().
  */
@@ -1432,6 +1448,7 @@ void __init kmem_cache_init(void)
 		if (i < MAX_NUMNODES)
 			cache_cache.nodelists[i] = NULL;
 	}
+	set_up_list3s(&cache_cache, CACHE_CACHE);
 
 	/*
 	 * Fragmentation resistance on low memory - only use bigger
@@ -1587,10 +1604,9 @@ void __init kmem_cache_init(void)
 	{
 		int nid;
 
-		/* Replace the static kmem_list3 structures for the boot cpu */
-		init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], node);
-
 		for_each_online_node(nid) {
+			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], nid);
+
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);
 
@@ -1960,22 +1976,6 @@ static void slab_destroy(struct kmem_cac
 	}
 }
 
-/*
- * For setting up all the kmem_list3s for cache whose buffer_size is same as
- * size of kmem_list3.
- */
-static void __init set_up_list3s(struct kmem_cache *cachep, int index)
-{
-	int node;
-
-	for_each_online_node(node) {
-		cachep->nodelists[node] = &initkmem_list3[index + node];
-		cachep->nodelists[node]->next_reap = jiffies +
-		    REAPTIMEOUT_LIST3 +
-		    ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
-	}
-}
-
 static void __kmem_cache_destroy(struct kmem_cache *cachep)
 {
 	int i;

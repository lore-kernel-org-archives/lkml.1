Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYDKHmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYDKHmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYDKHmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:42:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbYDKHmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:42:07 -0400
Date: Fri, 11 Apr 2008 09:41:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Message-ID: <20080411074145.GA4944@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


our x86.git randconfig auto-qa found a mm/slab.c early-bootup crash in 
mainline that got introduced since v2.6.24.

  http://redhat.com/~mingo/misc/log-Thu_Apr_10_10_41_16_CEST_2008.bad
  http://redhat.com/~mingo/misc/config-Thu_Apr_10_10_41_16_CEST_2008.bad

Note, the very same bzImage does not crash on other testboxes - only on 
this 8-way box with 4GB of RAM.

i tried a "use v2.6.24's slab.c" revert (with a few API fixes needed for 
it to build on .25) but that didnt solve the problem either.

i tried a bisection yesterday but it didnt work out too well - a 
combination of block layer (?) and networking regressions made it 
impossible.

Here's the list of "good" bisection points between v2.6.24 (from 
multiple bisection runs):

 0773769191d943358a8392fa86abd756d004c4b6
 21af0297c7e56024a5ccc4d8ad2a590f9ec371ba
 26b8256e2bb930a8e4d4d10aa74950d8921376b8
 2a10e7c41254941cac87be1eccdcb6379ce097f5
 3aa88cdf6bcc9e510c0707581131b821a7d3b7cb
 49914084e797530d9baaf51df9eda77babc98fa8
 53a6e2342d73d509318836e320f70cd286acd69c
 5be3bda8987b12a87863c89b74b136fdb1f072db
 6d5f718a497375f853d90247f5f6963368e89803
 7272dcd31d56580dee7693c21e369fd167e137fe
 77de2c590ec72828156d85fa13a96db87301cc68
 82cfbb008572b1a953091ef78f767aa3ca213092
 b75f53dba8a4a61fda1ff7e0fb0fe3b0d80e0c64
 c087567d3ffb2c7c61e091982e6ca45478394f1a
 d4b37ff73540ab90bee57b882a10b21e2f97939f
 fde1b3fa947c2512e3715962ebb1d3a6a9b9bb7d

the "bad" bisection points where i saw a slab.c crash were:

 7180c4c9e09888db0a188f729c96c6d7bd61fa83
 7fa2ac3728ce828070fa3d5846c08157fe5ef431

this still leaves a rather large set of commits:

  Bisecting: 1874 revisions left to test after this

and the mm/ bits alone look volumonious:

 $ git-bisect visualize -p -- mm | diffstat | tail -1
 106 files changed, 67759 insertions(+), 20852 deletions(-)

	Ingo

---------------->
Subject: slab: revert
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Apr 10 11:04:16 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slab.c |   72 +++++++++++++++++++++++++++++---------------------------------
 1 file changed, 34 insertions(+), 38 deletions(-)

Index: linux/mm/slab.c
===================================================================
--- linux.orig/mm/slab.c
+++ linux/mm/slab.c
@@ -304,11 +304,11 @@ struct kmem_list3 {
 /*
  * Need this for bootstrapping a per node allocator.
  */
-#define NUM_INIT_LISTS (3 * MAX_NUMNODES)
+#define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
 struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
-#define	SIZE_AC MAX_NUMNODES
-#define	SIZE_L3 (2 * MAX_NUMNODES)
+#define	SIZE_AC 1
+#define	SIZE_L3 (1 + MAX_NUMNODES)
 
 static int drain_freelist(struct kmem_cache *cache,
 			struct kmem_list3 *l3, int tofree);
@@ -333,7 +333,7 @@ static __always_inline int index_of(cons
 		return i; \
 	else \
 		i++;
-#include <linux/kmalloc_sizes.h>
+#include "linux/kmalloc_sizes.h"
 #undef CACHE
 		__bad_size();
 	} else
@@ -1407,22 +1407,6 @@ static void init_list(struct kmem_cache 
 }
 
 /*
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
-/*
  * Initialisation.  Called after the page allocator have been initialised and
  * before smp_init().
  */
@@ -1445,7 +1429,6 @@ void __init kmem_cache_init(void)
 		if (i < MAX_NUMNODES)
 			cache_cache.nodelists[i] = NULL;
 	}
-	set_up_list3s(&cache_cache, CACHE_CACHE);
 
 	/*
 	 * Fragmentation resistance on low memory - only use bigger
@@ -1481,7 +1464,7 @@ void __init kmem_cache_init(void)
 	list_add(&cache_cache.next, &cache_chain);
 	cache_cache.colour_off = cache_line_size();
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
-	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE + node];
+	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
 
 	/*
 	 * struct kmem_cache size depends on nr_node_ids, which
@@ -1601,9 +1584,10 @@ void __init kmem_cache_init(void)
 	{
 		int nid;
 
-		for_each_online_node(nid) {
-			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE + nid], nid);
+		/* Replace the static kmem_list3 structures for the boot cpu */
+		init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], node);
 
+		for_each_online_node(nid) {
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);
 
@@ -1973,6 +1957,22 @@ static void slab_destroy(struct kmem_cac
 	}
 }
 
+/*
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
 static void __kmem_cache_destroy(struct kmem_cache *cachep)
 {
 	int i;
@@ -2096,7 +2096,7 @@ static int __init_refok setup_cpu_cache(
 			g_cpucache_up = PARTIAL_L3;
 		} else {
 			int node;
-			for_each_online_node(node) {
+			for_each_node_state(node, N_NORMAL_MEMORY) {
 				cachep->nodelists[node] =
 				    kmalloc_node(sizeof(struct kmem_list3),
 						GFP_KERNEL, node);
@@ -2167,7 +2167,6 @@ kmem_cache_create (const char *name, siz
 	 * We use cache_chain_mutex to ensure a consistent view of
 	 * cpu_online_map as well.  Please see cpuup_callback
 	 */
-	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
 
 	list_for_each_entry(pc, &cache_chain, next) {
@@ -2394,7 +2393,6 @@ oops:
 		panic("kmem_cache_create(): failed to create slab `%s'\n",
 		      name);
 	mutex_unlock(&cache_chain_mutex);
-	put_online_cpus();
 	return cachep;
 }
 EXPORT_SYMBOL(kmem_cache_create);
@@ -2546,11 +2544,9 @@ int kmem_cache_shrink(struct kmem_cache 
 	int ret;
 	BUG_ON(!cachep || in_interrupt());
 
-	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
 	ret = __cache_shrink(cachep);
 	mutex_unlock(&cache_chain_mutex);
-	put_online_cpus();
 	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
@@ -2576,7 +2572,6 @@ void kmem_cache_destroy(struct kmem_cach
 	BUG_ON(!cachep || in_interrupt());
 
 	/* Find the cache in the chain of caches. */
-	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
 	/*
 	 * the chain is never empty, cache_cache is never destroyed
@@ -2586,7 +2581,6 @@ void kmem_cache_destroy(struct kmem_cach
 		slab_error(cachep, "Can't free all objects");
 		list_add(&cachep->next, &cache_chain);
 		mutex_unlock(&cache_chain_mutex);
-		put_online_cpus();
 		return;
 	}
 
@@ -2595,7 +2589,6 @@ void kmem_cache_destroy(struct kmem_cach
 
 	__kmem_cache_destroy(cachep);
 	mutex_unlock(&cache_chain_mutex);
-	put_online_cpus();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
@@ -2630,7 +2623,6 @@ static struct slab *alloc_slabmgmt(struc
 	slabp->colouroff = colour_off;
 	slabp->s_mem = objp + colour_off;
 	slabp->nodeid = nodeid;
-	slabp->free = 0;
 	return slabp;
 }
 
@@ -2684,6 +2676,7 @@ static void cache_init_objs(struct kmem_
 		slab_bufctl(slabp)[i] = i + 1;
 	}
 	slab_bufctl(slabp)[i - 1] = BUFCTL_END;
+	slabp->free = 0;
 }
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
@@ -2816,6 +2809,7 @@ static int cache_grow(struct kmem_cache 
 	if (!slabp)
 		goto opps1;
 
+	slabp->nodeid = nodeid;
 	slab_map_pages(cachep, slabp, objp);
 
 	cache_init_objs(cachep, slabp);
@@ -2964,10 +2958,11 @@ static void *cache_alloc_refill(struct k
 	struct array_cache *ac;
 	int node;
 
-retry:
-	check_irq_off();
 	node = numa_node_id();
+
+	check_irq_off();
 	ac = cpu_cache_get(cachep);
+retry:
 	batchcount = ac->batchcount;
 	if (!ac->touched && batchcount > BATCHREFILL_LIMIT) {
 		/*
@@ -3279,7 +3274,7 @@ retry:
 		if (local_flags & __GFP_WAIT)
 			local_irq_enable();
 		kmem_flagcheck(cache, flags);
-		obj = kmem_getpages(cache, local_flags, -1);
+		obj = kmem_getpages(cache, flags, -1);
 		if (local_flags & __GFP_WAIT)
 			local_irq_disable();
 		if (obj) {
@@ -3624,11 +3619,12 @@ void *kmem_cache_alloc(struct kmem_cache
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 /**
- * kmem_ptr_validate - check if an untrusted pointer might be a slab entry.
+ * kmem_ptr_validate - check if an untrusted pointer might
+ *	be a slab entry.
  * @cachep: the cache we're checking against
  * @ptr: pointer to validate
  *
- * This verifies that the untrusted pointer looks sane;
+ * This verifies that the untrusted pointer looks sane:
  * it is _not_ a guarantee that the pointer is actually
  * part of the slab cache in question, but it at least
  * validates that the pointer can be dereferenced and


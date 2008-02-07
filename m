Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbYBGUvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbYBGUvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbYBGUu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:50:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:44911 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759201AbYBGUu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:50:27 -0500
Date: Thu, 7 Feb 2008 12:46:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mel@csn.ul.ie,
       olaf@aepfle.de, clameter@sgi.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 02/45] slab: fix bootstrap on memoryless node
Message-ID: <20080207204621.GC16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="slab-fix-bootstrap-on-memoryless-node.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Pekka J Enberg <penberg@cs.helsinki.fi>

[ Upstream commit: 556a169dab38b5100df6f4a45b655dddd3db94c1 ]

If the node we're booting on doesn't have memory, bootstrapping kmalloc()
caches resorts to fallback_alloc() which requires ->nodelists set for all
nodes.  Fix that by calling set_up_list3s() for CACHE_CACHE in
kmem_cache_init().
    
As kmem_getpages() is called with GFP_THISNODE set, this used to work before
because of breakage in 2.6.22 and before with GFP_THISNODE returning pages from
the wrong node if a node had no memory. So it may have worked accidentally and
in an unsafe manner because the pages would have been associated with the wrong
node which could trigger bug ons and locking troubles.
    
Tested-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: Olaf Hering <olaf@aepfle.de>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
[ With additional one-liner by Olaf Hering  - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 mm/slab.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- linux-2.6.24.1.orig/mm/slab.c
+++ linux-2.6.24.1/mm/slab.c
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
@@ -2099,7 +2099,7 @@ static int __init_refok setup_cpu_cache(
 			g_cpucache_up = PARTIAL_L3;
 		} else {
 			int node;
-			for_each_node_state(node, N_NORMAL_MEMORY) {
+			for_each_online_node(node) {
 				cachep->nodelists[node] =
 				    kmalloc_node(sizeof(struct kmem_list3),
 						GFP_KERNEL, node);

-- 

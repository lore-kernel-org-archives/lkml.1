Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbZCTKMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbZCTKMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbZCTKC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:02:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55191 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045AbZCTKCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:02:53 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 25/25] Use a pre-calculated value instead of num_online_nodes() in fast paths
Date: Fri, 20 Mar 2009 10:03:12 +0000
Message-Id: <1237543392-11797-26-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>

num_online_nodes() is called in a number of places but most often by the
page allocator when deciding whether the zonelist needs to be filtered based
on cpusets or the zonelist cache. This is actually a heavy function and
touches a number of cache lines.

This patch stores the number of online nodes at boot time and updates the
value when nodes get onlined and offlined. The value is then used in a
number of important paths in place of num_online_nodes().

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/nodemask.h |   15 ++++++++++++++-
 mm/hugetlb.c             |    4 ++--
 mm/page_alloc.c          |   12 +++++++-----
 mm/slab.c                |    2 +-
 mm/slub.c                |    2 +-
 net/sunrpc/svc.c         |    2 +-
 6 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 848025c..474e73e 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -408,6 +408,19 @@ static inline int num_node_state(enum node_states state)
 #define next_online_node(nid)	next_node((nid), node_states[N_ONLINE])
 
 extern int nr_node_ids;
+extern int nr_online_nodes;
+
+static inline void node_set_online(int nid)
+{
+	node_set_state(nid, N_ONLINE);
+	nr_online_nodes = num_node_state(N_ONLINE);
+}
+
+static inline void node_set_offline(int nid)
+{
+	node_clear_state(nid, N_ONLINE);
+	nr_online_nodes = num_node_state(N_ONLINE);
+}
 #else
 
 static inline int node_state(int node, enum node_states state)
@@ -434,7 +447,7 @@ static inline int num_node_state(enum node_states state)
 #define first_online_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
-
+#define nr_online_nodes		1
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1e99997..210e28c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -875,7 +875,7 @@ static void return_unused_surplus_pages(struct hstate *h,
 	 * can no longer free unreserved surplus pages. This occurs when
 	 * the nodes with surplus pages have no free pages.
 	 */
-	unsigned long remaining_iterations = num_online_nodes();
+	unsigned long remaining_iterations = nr_online_nodes;
 
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
@@ -904,7 +904,7 @@ static void return_unused_surplus_pages(struct hstate *h,
 			h->surplus_huge_pages--;
 			h->surplus_huge_pages_node[nid]--;
 			nr_pages--;
-			remaining_iterations = num_online_nodes();
+			remaining_iterations = nr_online_nodes;
 		}
 	}
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 18f0b56..4131ff9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -164,7 +164,9 @@ static unsigned long __meminitdata dma_reserve;
 
 #if MAX_NUMNODES > 1
 int nr_node_ids __read_mostly = MAX_NUMNODES;
+int nr_online_nodes __read_mostly = 1;
 EXPORT_SYMBOL(nr_node_ids);
+EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
 int page_group_by_mobility_disabled __read_mostly;
@@ -1445,7 +1447,7 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 	/* Determine in advance if the zonelist needs filtering */
 	if ((alloc_flags & ALLOC_CPUSET) && unlikely(number_of_cpusets > 1))
 		zonelist_filter = 1;
-	if (num_online_nodes() > 1)
+	if (nr_online_nodes > 1)
 		zonelist_filter = 1;
 
 zonelist_scan:
@@ -1486,7 +1488,7 @@ this_zone_full:
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
 		if (NUMA_BUILD && zonelist_filter) {
-			if (!did_zlc_setup && num_online_nodes() > 1) {
+			if (!did_zlc_setup && nr_online_nodes > 1) {
 				/*
 				 * do zlc_setup after the first zone is tried
 				 * but only if there are multiple nodes to make
@@ -2285,7 +2287,7 @@ int numa_zonelist_order_handler(ctl_table *table, int write,
 }
 
 
-#define MAX_NODE_LOAD (num_online_nodes())
+#define MAX_NODE_LOAD (nr_online_nodes)
 static int node_load[MAX_NUMNODES];
 
 /**
@@ -2494,7 +2496,7 @@ static void build_zonelists(pg_data_t *pgdat)
 
 	/* NUMA-aware ordering of nodes */
 	local_node = pgdat->node_id;
-	load = num_online_nodes();
+	load = nr_online_nodes;
 	prev_node = local_node;
 	nodes_clear(used_mask);
 
@@ -2645,7 +2647,7 @@ void build_all_zonelists(void)
 
 	printk("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
-			num_online_nodes(),
+			nr_online_nodes,
 			zonelist_order_name[current_zonelist_order],
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
diff --git a/mm/slab.c b/mm/slab.c
index e7f1ded..e6157a0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3526,7 +3526,7 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	 * variable to skip the call, which is mostly likely to be present in
 	 * the cache.
 	 */
-	if (numa_platform && cache_free_alien(cachep, objp))
+	if (numa_platform > 1 && cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
diff --git a/mm/slub.c b/mm/slub.c
index 0280eee..8ce6be8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3648,7 +3648,7 @@ static int list_locations(struct kmem_cache *s, char *buf,
 						 to_cpumask(l->cpus));
 		}
 
-		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
+		if (nr_online_nodes > 1 && !nodes_empty(l->nodes) &&
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " nodes=");
 			len += nodelist_scnprintf(buf + len, PAGE_SIZE - len - 50,
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index c51fed4..ba9eb8f 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -124,7 +124,7 @@ svc_pool_map_choose_mode(void)
 {
 	unsigned int node;
 
-	if (num_online_nodes() > 1) {
+	if (nr_online_nodes > 1) {
 		/*
 		 * Actually have multiple NUMA nodes,
 		 * so split pools on NUMA node boundaries
-- 
1.5.6.5


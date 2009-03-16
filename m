Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbZCPR6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbZCPR6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbZCPRvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:51:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51192 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023AbZCPRvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:51:36 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 20/27] Use a pre-calculated value for num_online_nodes()
Date: Mon, 16 Mar 2009 17:53:34 +0000
Message-Id: <1237226020-14057-21-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

num_online_nodes() is called by the page allocator to decide whether the
zonelist needs to be filtered based on cpusets or the zonelist cache.
This is actually a heavy function and touches a number of cache lines.
This patch stores the number of online nodes at boot time and when
nodes get onlined and offlined.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/nodemask.h |   16 ++++++++++++++--
 mm/page_alloc.c          |    6 ++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 848025c..4749e30 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -449,13 +449,25 @@ static inline int num_node_state(enum node_states state)
 	node;					\
 })
 
+/* Recorded value for num_online_nodes() */
+extern int static_num_online_nodes;
+
 #define num_online_nodes()	num_node_state(N_ONLINE)
 #define num_possible_nodes()	num_node_state(N_POSSIBLE)
 #define node_online(node)	node_state((node), N_ONLINE)
 #define node_possible(node)	node_state((node), N_POSSIBLE)
 
-#define node_set_online(node)	   node_set_state((node), N_ONLINE)
-#define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
+static inline void node_set_online(int nid)
+{
+	node_set_state(nid, N_ONLINE);
+	static_num_online_nodes = num_node_state(N_ONLINE);
+}
+
+static inline void node_set_offline(int nid)
+{
+	node_clear_state(nid, N_ONLINE);
+	static_num_online_nodes = num_node_state(N_ONLINE);
+}
 
 #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 01cd489..799e2bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -70,6 +70,7 @@ EXPORT_SYMBOL(node_states);
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 unsigned long highest_memmap_pfn __read_mostly;
+int static_num_online_nodes __read_mostly;
 int percpu_pagelist_fraction;
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -1442,7 +1443,7 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 	/* Determine in advance if the zonelist needs filtering */
 	if ((alloc_flags & ALLOC_CPUSET) && unlikely(number_of_cpusets > 1))
 		zonelist_filter = 1;
-	if (num_online_nodes() > 1)
+	if (static_num_online_nodes > 1)
 		zonelist_filter = 1;
 
 zonelist_scan:
@@ -1488,7 +1489,7 @@ this_zone_full:
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
 		if (NUMA_BUILD && zonelist_filter) {
-			if (!did_zlc_setup && num_online_nodes() > 1) {
+			if (!did_zlc_setup && static_num_online_nodes > 1) {
 				/*
 				 * do zlc_setup after the first zone is tried
 				 * but only if there are multiple nodes to make
@@ -2645,6 +2646,7 @@ void build_all_zonelists(void)
 	else
 		page_group_by_mobility_disabled = 0;
 
+	static_num_online_nodes = num_node_state(N_ONLINE);
 	printk("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
 			num_online_nodes(),
-- 
1.5.6.5


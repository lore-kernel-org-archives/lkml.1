Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbZIVMyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbZIVMyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZIVMyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:54:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58754 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191AbZIVMyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:54:14 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/4] slqb: Do not use DEFINE_PER_CPU for per-node data
Date: Tue, 22 Sep 2009 13:54:12 +0100
Message-Id: <1253624054-10882-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLQB uses DEFINE_PER_CPU to define per-node areas. An implicit
assumption is made that all valid node IDs will have matching valid CPU
ids. In memoryless configurations, it is possible to have a node ID with
no CPU having the same ID. When this happens, per-cpu areas are not
initialised and the per-node data is effectively random.

An attempt was made to force the allocation of per-cpu areas corresponding
to active node IDs. However, for reasons unknown this led to silent
lockups. Instead, this patch fixes the SLQB problem by forcing the per-node
data to be statically declared.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/slqb.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index 4ca85e2..4d72be2 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -1944,16 +1944,16 @@ static void init_kmem_cache_node(struct kmem_cache *s,
 static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_cache_cpus);
 #endif
 #ifdef CONFIG_NUMA
-/* XXX: really need a DEFINE_PER_NODE for per-node data, but this is better than
- * a static array */
-static DEFINE_PER_CPU(struct kmem_cache_node, kmem_cache_nodes);
+/* XXX: really need a DEFINE_PER_NODE for per-node data because a static
+ *      array is wasteful */
+static struct kmem_cache_node kmem_cache_nodes[MAX_NUMNODES];
 #endif
 
 #ifdef CONFIG_SMP
 static struct kmem_cache kmem_cpu_cache;
 static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_cpu_cpus);
 #ifdef CONFIG_NUMA
-static DEFINE_PER_CPU(struct kmem_cache_node, kmem_cpu_nodes); /* XXX per-nid */
+static struct kmem_cache_node kmem_cpu_nodes[MAX_NUMNODES]; /* XXX per-nid */
 #endif
 #endif
 
@@ -1962,7 +1962,7 @@ static struct kmem_cache kmem_node_cache;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_node_cpus);
 #endif
-static DEFINE_PER_CPU(struct kmem_cache_node, kmem_node_nodes); /*XXX per-nid */
+static struct kmem_cache_node kmem_node_nodes[MAX_NUMNODES]; /*XXX per-nid */
 #endif
 
 #ifdef CONFIG_SMP
@@ -2918,15 +2918,15 @@ void __init kmem_cache_init(void)
 	for_each_node_state(i, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n;
 
-		n = &per_cpu(kmem_cache_nodes, i);
+		n = &kmem_cache_nodes[i];
 		init_kmem_cache_node(&kmem_cache_cache, n);
 		kmem_cache_cache.node_slab[i] = n;
 #ifdef CONFIG_SMP
-		n = &per_cpu(kmem_cpu_nodes, i);
+		n = &kmem_cpu_nodes[i];
 		init_kmem_cache_node(&kmem_cpu_cache, n);
 		kmem_cpu_cache.node_slab[i] = n;
 #endif
-		n = &per_cpu(kmem_node_nodes, i);
+		n = &kmem_node_nodes[i];
 		init_kmem_cache_node(&kmem_node_cache, n);
 		kmem_node_cache.node_slab[i] = n;
 	}
-- 
1.6.3.3


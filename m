Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYDEBOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYDEBOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYDEBLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56594 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751833AbYDEBLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:06 -0400
Message-Id: <20080405011102.500171000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:10 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg Banks <gnb@sgi.com>
Subject: [PATCH 10/12] nodemask: use new node_to_cpumask_ptr function
Content-Disposition: inline; filename=node_to_cpumask_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Use new node_to_cpumask_ptr.  This creates a pointer to the
    cpumask for a given node.  This definition is in mm patch:

	asm-generic-add-node_to_cpumask_ptr-macro.patch

  * Use new set_cpus_allowed_ptr function.

Depends on:
	[mm-patch]: asm-generic-add-node_to_cpumask_ptr-macro.patch
	[sched-devel]: sched: add new set_cpus_allowed_ptr function
	[x86/latest]: x86: add cpus_scnprintf function

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

# pci
Cc: Greg Kroah-Hartman <gregkh@suse.de>

# sunrpc
Cc: Greg Banks <gnb@melbourne.sgi.com>

# x86
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
One checkpatch error that I don't think can be fixed (was already in source):

ERROR: Macros with complex values should be enclosed in parenthesis
#230: FILE: include/linux/topology.h:49:

#define for_each_node_with_cpus(node)			\
        for_each_online_node(node)                      \
		if (nr_cpus_node(node))
---
 drivers/base/node.c |    7 ++++---
 kernel/sched.c      |   29 ++++++++++++++---------------
 mm/page_alloc.c     |    6 +++---
 mm/slab.c           |    5 ++---
 mm/vmscan.c         |   18 ++++++++----------
 net/sunrpc/svc.c    |   16 +++++++++++-----
 6 files changed, 42 insertions(+), 39 deletions(-)

--- linux-2.6.x86.orig/drivers/base/node.c
+++ linux-2.6.x86/drivers/base/node.c
@@ -22,14 +22,15 @@ static struct sysdev_class node_class = 
 static ssize_t node_read_cpumap(struct sys_device * dev, char * buf)
 {
 	struct node *node_dev = to_node(dev);
-	cpumask_t mask = node_to_cpumask(node_dev->sysdev.id);
+	node_to_cpumask_ptr(mask, node_dev->sysdev.id);
 	int len;
 
 	/* 2004/06/03: buf currently PAGE_SIZE, need > 1 char per 4 bits. */
 	BUILD_BUG_ON(MAX_NUMNODES/4 > PAGE_SIZE/2);
 
-	len = cpumask_scnprintf(buf, PAGE_SIZE-1, mask);
-	len += sprintf(buf + len, "\n");
+	len = cpumask_scnprintf(buf, PAGE_SIZE-2, *mask);
+ 	buf[len++] = '\n';
+ 	buf[len] = '\0';
 	return len;
 }
 
--- linux-2.6.x86.orig/kernel/sched.c
+++ linux-2.6.x86/kernel/sched.c
@@ -6484,7 +6484,7 @@ init_sched_build_groups(cpumask_t span, 
  *
  * Should use nodemask_t.
  */
-static int find_next_best_node(int node, unsigned long *used_nodes)
+static int find_next_best_node(int node, nodemask_t *used_nodes)
 {
 	int i, n, val, min_val, best_node = 0;
 
@@ -6498,7 +6498,7 @@ static int find_next_best_node(int node,
 			continue;
 
 		/* Skip already used nodes */
-		if (test_bit(n, used_nodes))
+		if (node_isset(n, *used_nodes))
 			continue;
 
 		/* Simple min distance search */
@@ -6510,14 +6510,13 @@ static int find_next_best_node(int node,
 		}
 	}
 
-	set_bit(best_node, used_nodes);
+	node_set(best_node, *used_nodes);
 	return best_node;
 }
 
 /**
  * sched_domain_node_span - get a cpumask for a node's sched_domain
  * @node: node whose cpumask we're constructing
- * @size: number of nodes to include in this span
  *
  * Given a node, construct a good cpumask for its sched_domain to span. It
  * should be one that prevents unnecessary balancing, but also spreads tasks
@@ -6525,22 +6524,22 @@ static int find_next_best_node(int node,
  */
 static cpumask_t sched_domain_node_span(int node)
 {
-	DECLARE_BITMAP(used_nodes, MAX_NUMNODES);
-	cpumask_t span, nodemask;
+	nodemask_t used_nodes;
+	cpumask_t span;
+	node_to_cpumask_ptr(nodemask, node);
 	int i;
 
 	cpus_clear(span);
-	bitmap_zero(used_nodes, MAX_NUMNODES);
+	nodes_clear(used_nodes);
 
-	nodemask = node_to_cpumask(node);
-	cpus_or(span, span, nodemask);
-	set_bit(node, used_nodes);
+	cpus_or(span, span, *nodemask);
+	node_set(node, used_nodes);
 
 	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
-		int next_node = find_next_best_node(node, used_nodes);
+		int next_node = find_next_best_node(node, &used_nodes);
 
-		nodemask = node_to_cpumask(next_node);
-		cpus_or(span, span, nodemask);
+		node_to_cpumask_ptr_next(nodemask, next_node);
+		cpus_or(span, span, *nodemask);
 	}
 
 	return span;
@@ -6937,6 +6936,7 @@ static int build_sched_domains(const cpu
 		for (j = 0; j < MAX_NUMNODES; j++) {
 			cpumask_t tmp, notcovered;
 			int n = (i + j) % MAX_NUMNODES;
+			node_to_cpumask_ptr(pnodemask, n);
 
 			cpus_complement(notcovered, covered);
 			cpus_and(tmp, notcovered, *cpu_map);
@@ -6944,8 +6944,7 @@ static int build_sched_domains(const cpu
 			if (cpus_empty(tmp))
 				break;
 
-			nodemask = node_to_cpumask(n);
-			cpus_and(tmp, tmp, nodemask);
+			cpus_and(tmp, tmp, *pnodemask);
 			if (cpus_empty(tmp))
 				continue;
 
--- linux-2.6.x86.orig/mm/page_alloc.c
+++ linux-2.6.x86/mm/page_alloc.c
@@ -2029,6 +2029,7 @@ static int find_next_best_node(int node,
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = -1;
+	node_to_cpumask_ptr(tmp, 0);
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
@@ -2037,7 +2038,6 @@ static int find_next_best_node(int node,
 	}
 
 	for_each_node_state(n, N_HIGH_MEMORY) {
-		cpumask_t tmp;
 
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
@@ -2050,8 +2050,8 @@ static int find_next_best_node(int node,
 		val += (n < node);
 
 		/* Give preference to headless and unused nodes */
-		tmp = node_to_cpumask(n);
-		if (!cpus_empty(tmp))
+		node_to_cpumask_ptr_next(tmp, n);
+		if (!cpus_empty(*tmp))
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
--- linux-2.6.x86.orig/mm/slab.c
+++ linux-2.6.x86/mm/slab.c
@@ -1160,14 +1160,13 @@ static void __cpuinit cpuup_canceled(lon
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
 	int node = cpu_to_node(cpu);
+	node_to_cpumask_ptr(mask, node);
 
 	list_for_each_entry(cachep, &cache_chain, next) {
 		struct array_cache *nc;
 		struct array_cache *shared;
 		struct array_cache **alien;
-		cpumask_t mask;
 
-		mask = node_to_cpumask(node);
 		/* cpu is dead; no one can alloc from it. */
 		nc = cachep->array[cpu];
 		cachep->array[cpu] = NULL;
@@ -1183,7 +1182,7 @@ static void __cpuinit cpuup_canceled(lon
 		if (nc)
 			free_block(cachep, nc->entry, nc->avail, node);
 
-		if (!cpus_empty(mask)) {
+		if (!cpus_empty(*mask)) {
 			spin_unlock_irq(&l3->list_lock);
 			goto free_array_cache;
 		}
--- linux-2.6.x86.orig/mm/vmscan.c
+++ linux-2.6.x86/mm/vmscan.c
@@ -1647,11 +1647,10 @@ static int kswapd(void *p)
 	struct reclaim_state reclaim_state = {
 		.reclaimed_slab = 0,
 	};
-	cpumask_t cpumask;
+	node_to_cpumask_ptr(cpumask, pgdat->node_id);
 
-	cpumask = node_to_cpumask(pgdat->node_id);
-	if (!cpus_empty(cpumask))
-		set_cpus_allowed(tsk, cpumask);
+	if (!cpus_empty(*cpumask))
+		set_cpus_allowed_ptr(tsk, cpumask);
 	current->reclaim_state = &reclaim_state;
 
 	/*
@@ -1880,17 +1879,16 @@ out:
 static int __devinit cpu_callback(struct notifier_block *nfb,
 				  unsigned long action, void *hcpu)
 {
-	pg_data_t *pgdat;
-	cpumask_t mask;
 	int nid;
 
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
 		for_each_node_state(nid, N_HIGH_MEMORY) {
-			pgdat = NODE_DATA(nid);
-			mask = node_to_cpumask(pgdat->node_id);
-			if (any_online_cpu(mask) != NR_CPUS)
+			pg_data_t *pgdat = NODE_DATA(nid);
+			node_to_cpumask_ptr(mask, pgdat->node_id);
+
+			if (any_online_cpu(*mask) < nr_cpu_ids)
 				/* One of our CPUs online: restore mask */
-				set_cpus_allowed(pgdat->kswapd, mask);
+				set_cpus_allowed_ptr(pgdat->kswapd, mask);
 		}
 	}
 	return NOTIFY_OK;
--- linux-2.6.x86.orig/net/sunrpc/svc.c
+++ linux-2.6.x86/net/sunrpc/svc.c
@@ -301,7 +301,6 @@ static inline int
 svc_pool_map_set_cpumask(unsigned int pidx, cpumask_t *oldmask)
 {
 	struct svc_pool_map *m = &svc_pool_map;
-	unsigned int node; /* or cpu */
 
 	/*
 	 * The caller checks for sv_nrpools > 1, which
@@ -314,16 +313,23 @@ svc_pool_map_set_cpumask(unsigned int pi
 	default:
 		return 0;
 	case SVC_POOL_PERCPU:
-		node = m->pool_to[pidx];
+	{
+		unsigned int cpu = m->pool_to[pidx];
+
 		*oldmask = current->cpus_allowed;
-		set_cpus_allowed(current, cpumask_of_cpu(node));
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 		return 1;
+	}
 	case SVC_POOL_PERNODE:
-		node = m->pool_to[pidx];
+	{
+		unsigned int node = m->pool_to[pidx];
+		node_to_cpumask_ptr(nodecpumask, node);
+
 		*oldmask = current->cpus_allowed;
-		set_cpus_allowed(current, node_to_cpumask(node));
+		set_cpus_allowed_ptr(current, nodecpumask);
 		return 1;
 	}
+	}
 }
 
 /*

-- 

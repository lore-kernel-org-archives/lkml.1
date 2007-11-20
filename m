Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXKTBUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXKTBUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbXKTBNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:55 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36874 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754337AbXKTBNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:37 -0500
Message-Id: <20071120011336.441846267@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:52 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 20/45] cpu alloc: neigbour statistics
Content-Disposition: inline; filename=0028-cpu-alloc-neigbour-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/net/neighbour.h |    6 +-----
 net/core/neighbour.c    |   11 ++++++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

Index: linux-2.6/include/net/neighbour.h
===================================================================
--- linux-2.6.orig/include/net/neighbour.h	2007-11-18 14:38:23.910033621 -0800
+++ linux-2.6/include/net/neighbour.h	2007-11-18 22:04:47.465297422 -0800
@@ -81,11 +81,7 @@ struct neigh_statistics
 };
 
 #define NEIGH_CACHE_STAT_INC(tbl, field)				\
-	do {								\
-		preempt_disable();					\
-		(per_cpu_ptr((tbl)->stats, smp_processor_id())->field)++; \
-		preempt_enable();					\
-	} while (0)
+	_CPU_INC(tbl->stats->field)
 
 struct neighbour
 {
Index: linux-2.6/net/core/neighbour.c
===================================================================
--- linux-2.6.orig/net/core/neighbour.c	2007-11-18 14:38:23.918033788 -0800
+++ linux-2.6/net/core/neighbour.c	2007-11-18 21:55:23.064297499 -0800
@@ -1348,7 +1348,8 @@ void neigh_table_init_no_netlink(struct 
 			kmem_cache_create(tbl->id, tbl->entry_size, 0,
 					  SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 					  NULL);
-	tbl->stats = alloc_percpu(struct neigh_statistics);
+	tbl->stats = CPU_ALLOC(struct neigh_statistics,
+					GFP_KERNEL | __GFP_ZERO);
 	if (!tbl->stats)
 		panic("cannot create neighbour cache statistics");
 
@@ -1437,7 +1438,7 @@ int neigh_table_clear(struct neigh_table
 
 	remove_proc_entry(tbl->id, init_net.proc_net_stat);
 
-	free_percpu(tbl->stats);
+	CPU_FREE(tbl->stats);
 	tbl->stats = NULL;
 
 	kmem_cache_destroy(tbl->kmem_cachep);
@@ -1694,7 +1695,7 @@ static int neightbl_fill_info(struct sk_
 		for_each_possible_cpu(cpu) {
 			struct neigh_statistics	*st;
 
-			st = per_cpu_ptr(tbl->stats, cpu);
+			st = CPU_PTR(tbl->stats, cpu);
 			ndst.ndts_allocs		+= st->allocs;
 			ndst.ndts_destroys		+= st->destroys;
 			ndst.ndts_hash_grows		+= st->hash_grows;
@@ -2343,7 +2344,7 @@ static void *neigh_stat_seq_start(struct
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
-		return per_cpu_ptr(tbl->stats, cpu);
+		return CPU_PTR(tbl->stats, cpu);
 	}
 	return NULL;
 }
@@ -2358,7 +2359,7 @@ static void *neigh_stat_seq_next(struct 
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
-		return per_cpu_ptr(tbl->stats, cpu);
+		return CPU_PTR(tbl->stats, cpu);
 	}
 	return NULL;
 }

-- 

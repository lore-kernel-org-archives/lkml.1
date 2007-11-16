Return-Path: <linux-kernel-owner+w=401wt.eu-S935807AbXKPXT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935807AbXKPXT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934857AbXKPXLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:41 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39561 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761731AbXKPXLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:07 -0500
Message-Id: <20071116231106.448808447@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:38 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 18/30] cpu alloc: neigbour statistics
Content-Disposition: inline; filename=0028-cpu-alloc-neigbour-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/net/neighbour.h |    2 +-
 net/core/neighbour.c    |   11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/include/net/neighbour.h
===================================================================
--- linux-2.6.orig/include/net/neighbour.h	2007-11-15 21:17:24.319654300 -0800
+++ linux-2.6/include/net/neighbour.h	2007-11-15 21:25:33.678404221 -0800
@@ -83,7 +83,7 @@ struct neigh_statistics
 #define NEIGH_CACHE_STAT_INC(tbl, field)				\
 	do {								\
 		preempt_disable();					\
-		(per_cpu_ptr((tbl)->stats, smp_processor_id())->field)++; \
+		(THIS_CPU((tbl)->stats)->field)++; \
 		preempt_enable();					\
 	} while (0)
 
Index: linux-2.6/net/core/neighbour.c
===================================================================
--- linux-2.6.orig/net/core/neighbour.c	2007-11-15 21:17:24.327654639 -0800
+++ linux-2.6/net/core/neighbour.c	2007-11-15 21:25:33.678404221 -0800
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

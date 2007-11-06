Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbXKFT4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbXKFT4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbXKFTwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:22 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45405 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756015AbXKFTwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:03 -0500
Message-Id: <20071106195201.541823912@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:01 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 17/28] cpu alloc: neigbour statistics
Content-Disposition: inline; filename=cpu_alloc_neighbour
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/net/neighbour.h |    2 +-
 net/core/neighbour.c    |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6/net/core/neighbour.c
===================================================================
--- linux-2.6.orig/net/core/neighbour.c	2007-11-04 20:14:21.000000000 -0800
+++ linux-2.6/net/core/neighbour.c	2007-11-04 20:16:08.000000000 -0800
@@ -35,6 +35,7 @@
 #include <linux/random.h>
 #include <linux/string.h>
 #include <linux/log2.h>
+#include <linux/cpu_alloc.h>
 
 #define NEIGH_DEBUG 1
 
@@ -1348,7 +1349,8 @@ void neigh_table_init_no_netlink(struct 
 			kmem_cache_create(tbl->id, tbl->entry_size, 0,
 					  SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 					  NULL);
-	tbl->stats = alloc_percpu(struct neigh_statistics);
+	tbl->stats = CPU_ALLOC(struct neigh_statistics,
+					GFP_KERNEL | __GFP_ZERO);
 	if (!tbl->stats)
 		panic("cannot create neighbour cache statistics");
 
@@ -1435,7 +1437,7 @@ int neigh_table_clear(struct neigh_table
 	kfree(tbl->phash_buckets);
 	tbl->phash_buckets = NULL;
 
-	free_percpu(tbl->stats);
+	CPU_FREE(tbl->stats);
 	tbl->stats = NULL;
 
 	kmem_cache_destroy(tbl->kmem_cachep);
@@ -1692,7 +1694,7 @@ static int neightbl_fill_info(struct sk_
 		for_each_possible_cpu(cpu) {
 			struct neigh_statistics	*st;
 
-			st = per_cpu_ptr(tbl->stats, cpu);
+			st = CPU_PTR(tbl->stats, cpu);
 			ndst.ndts_allocs		+= st->allocs;
 			ndst.ndts_destroys		+= st->destroys;
 			ndst.ndts_hash_grows		+= st->hash_grows;
@@ -2341,7 +2343,7 @@ static void *neigh_stat_seq_start(struct
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
-		return per_cpu_ptr(tbl->stats, cpu);
+		return CPU_PTR(tbl->stats, cpu);
 	}
 	return NULL;
 }
@@ -2356,7 +2358,7 @@ static void *neigh_stat_seq_next(struct 
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
-		return per_cpu_ptr(tbl->stats, cpu);
+		return CPU_PTR(tbl->stats, cpu);
 	}
 	return NULL;
 }
Index: linux-2.6/include/net/neighbour.h
===================================================================
--- linux-2.6.orig/include/net/neighbour.h	2007-11-04 20:15:41.000000000 -0800
+++ linux-2.6/include/net/neighbour.h	2007-11-04 20:16:24.000000000 -0800
@@ -83,7 +83,7 @@ struct neigh_statistics
 #define NEIGH_CACHE_STAT_INC(tbl, field)				\
 	do {								\
 		preempt_disable();					\
-		(per_cpu_ptr((tbl)->stats, smp_processor_id())->field)++; \
+		(THIS_CPU((tbl)->stats)->field)++; \
 		preempt_enable();					\
 	} while (0)
 

-- 

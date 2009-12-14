Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZLNWHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZLNWHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbZLNWGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:06:49 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:59517 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520AbZLNWE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:04:57 -0500
Message-Id: <20091214220340.838360930@quilx.com>
References: <20091214220320.665065925@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Dec 2009 16:03:24 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V7 4/8] SLUB: Get rid of dynamic DMA kmalloc cache allocation
Content-Disposition: inline; filename=percpu_slub_static_dma_kmalloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic DMA kmalloc cache allocation is troublesome since the
new percpu allocator does not support allocations in atomic contexts.
Reserve some statically allocated kmalloc_cpu structures instead.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/slub_def.h |   19 +++++++++++--------
 mm/slub.c                |   24 ++++++++++--------------
 2 files changed, 21 insertions(+), 22 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2009-12-14 15:22:57.000000000 -0600
+++ linux-2.6/include/linux/slub_def.h	2009-12-14 15:23:27.000000000 -0600
@@ -131,11 +131,21 @@ struct kmem_cache {
 
 #define SLUB_PAGE_SHIFT (PAGE_SHIFT + 2)
 
+#ifdef CONFIG_ZONE_DMA
+#define SLUB_DMA __GFP_DMA
+/* Reserve extra caches for potential DMA use */
+#define KMALLOC_CACHES (2 * SLUB_PAGE_SHIFT - 6)
+#else
+/* Disable DMA functionality */
+#define SLUB_DMA (__force gfp_t)0
+#define KMALLOC_CACHES SLUB_PAGE_SHIFT
+#endif
+
 /*
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
  */
-extern struct kmem_cache kmalloc_caches[SLUB_PAGE_SHIFT];
+extern struct kmem_cache kmalloc_caches[KMALLOC_CACHES];
 
 /*
  * Sorry that the following has to be that ugly but some versions of GCC
@@ -203,13 +213,6 @@ static __always_inline struct kmem_cache
 	return &kmalloc_caches[index];
 }
 
-#ifdef CONFIG_ZONE_DMA
-#define SLUB_DMA __GFP_DMA
-#else
-/* Disable DMA functionality */
-#define SLUB_DMA (__force gfp_t)0
-#endif
-
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2009-12-14 15:23:19.000000000 -0600
+++ linux-2.6/mm/slub.c	2009-12-14 15:23:27.000000000 -0600
@@ -2092,7 +2092,7 @@ static inline int alloc_kmem_cache_cpus(
 {
 	int cpu;
 
-	if (s < kmalloc_caches + SLUB_PAGE_SHIFT && s >= kmalloc_caches)
+	if (s < kmalloc_caches + KMALLOC_CACHES && s >= kmalloc_caches)
 		/*
 		 * Boot time creation of the kmalloc array. Use static per cpu data
 		 * since the per cpu allocator is not available yet.
@@ -2539,7 +2539,7 @@ EXPORT_SYMBOL(kmem_cache_destroy);
  *		Kmalloc subsystem
  *******************************************************************/
 
-struct kmem_cache kmalloc_caches[SLUB_PAGE_SHIFT] __cacheline_aligned;
+struct kmem_cache kmalloc_caches[KMALLOC_CACHES] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);
 
 static int __init setup_slub_min_order(char *str)
@@ -2629,6 +2629,7 @@ static noinline struct kmem_cache *dma_k
 	char *text;
 	size_t realsize;
 	unsigned long slabflags;
+	int i;
 
 	s = kmalloc_caches_dma[index];
 	if (s)
@@ -2649,18 +2650,13 @@ static noinline struct kmem_cache *dma_k
 	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d",
 			 (unsigned int)realsize);
 
-	if (flags & __GFP_WAIT)
-		s = kmalloc(kmem_size, flags & ~SLUB_DMA);
-	else {
-		int i;
+	s = NULL;
+	for (i = 0; i < KMALLOC_CACHES; i++)
+		if (!kmalloc_caches[i].size)
+			break;
 
-		s = NULL;
-		for (i = 0; i < SLUB_PAGE_SHIFT; i++)
-			if (kmalloc_caches[i].size) {
-				s = kmalloc_caches + i;
-				break;
-			}
-	}
+	BUG_ON(i >= KMALLOC_CACHES);
+	s = kmalloc_caches + i;
 
 	/*
 	 * Must defer sysfs creation to a workqueue because we don't know
@@ -2674,7 +2670,7 @@ static noinline struct kmem_cache *dma_k
 
 	if (!s || !text || !kmem_cache_open(s, flags, text,
 			realsize, ARCH_KMALLOC_MINALIGN, slabflags, NULL)) {
-		kfree(s);
+		s->size = 0;
 		kfree(text);
 		goto unlock_out;
 	}

-- 

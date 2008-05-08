Return-Path: <linux-kernel-owner+w=401wt.eu-S933209AbYEHVD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbYEHVD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760753AbYEHVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:03:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48560 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbYEHVDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:03:13 -0400
Date: Fri, 9 May 2008 00:03:11 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
cc: clameter@sgi.com, akpm@linux-foundation.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] slab: move struct kmem_cache to headers
Message-ID: <Pine.LNX.4.64.0805090002250.28488@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Move the SLAB struct kmem_cache definition to <linux/slab_def.h> like with SLUB
so kmemcheck can access ->ctor and ->flags.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab_def.h |   81 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/slab.c                |   81 -----------------------------------------------
 2 files changed, 81 insertions(+), 81 deletions(-)

Index: kmemcheck/include/linux/slab_def.h
===================================================================
--- kmemcheck.orig/include/linux/slab_def.h	2008-05-08 23:49:15.000000000 +0300
+++ kmemcheck/include/linux/slab_def.h	2008-05-08 23:50:45.000000000 +0300
@@ -15,6 +15,87 @@
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
 
+/*
+ * struct kmem_cache
+ *
+ * manages a cache.
+ */
+
+struct kmem_cache {
+/* 1) per-cpu data, touched during every alloc/free */
+	struct array_cache *array[NR_CPUS];
+/* 2) Cache tunables. Protected by cache_chain_mutex */
+	unsigned int batchcount;
+	unsigned int limit;
+	unsigned int shared;
+
+	unsigned int buffer_size;
+	u32 reciprocal_buffer_size;
+/* 3) touched by every alloc & free from the backend */
+
+	unsigned int flags;		/* constant flags */
+	unsigned int num;		/* # of objs per slab */
+
+/* 4) cache_grow/shrink */
+	/* order of pgs per slab (2^n) */
+	unsigned int gfporder;
+
+	/* force GFP flags, e.g. GFP_DMA */
+	gfp_t gfpflags;
+
+	size_t colour;			/* cache colouring range */
+	unsigned int colour_off;	/* colour offset */
+	struct kmem_cache *slabp_cache;
+	unsigned int slab_size;
+	unsigned int dflags;		/* dynamic flags */
+
+	/* constructor func */
+	void (*ctor)(struct kmem_cache *, void *);
+
+/* 5) cache creation/removal */
+	const char *name;
+	struct list_head next;
+
+/* 6) statistics */
+#ifdef CONFIG_DEBUG_SLAB
+	unsigned long num_active;
+	unsigned long num_allocations;
+	unsigned long high_mark;
+	unsigned long grown;
+	unsigned long reaped;
+	unsigned long errors;
+	unsigned long max_freeable;
+	unsigned long node_allocs;
+	unsigned long node_frees;
+	unsigned long node_overflow;
+	atomic_t allochit;
+	atomic_t allocmiss;
+	atomic_t freehit;
+	atomic_t freemiss;
+
+	/*
+	 * If debugging is enabled, then the allocator can add additional
+	 * fields and/or padding to every object. buffer_size contains the total
+	 * object size including these internal fields, the following two
+	 * variables contain the offset to the user object and its size.
+	 */
+	int obj_offset;
+	int obj_size;
+#endif /* CONFIG_DEBUG_SLAB */
+
+	/*
+	 * We put nodelists[] at the end of kmem_cache, because we want to size
+	 * this array to nr_node_ids slots instead of MAX_NUMNODES
+	 * (see kmem_cache_init())
+	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
+	 * is statically defined, so we reserve the max number of nodes.
+	 */
+	struct kmem_list3 *nodelists[MAX_NUMNODES];
+	/*
+	 * Do not add fields after nodelists[]
+	 */
+};
+
 /* Size description struct for general caches. */
 struct cache_sizes {
 	size_t		 	cs_size;
Index: kmemcheck/mm/slab.c
===================================================================
--- kmemcheck.orig/mm/slab.c	2008-05-08 23:49:15.000000000 +0300
+++ kmemcheck/mm/slab.c	2008-05-08 23:50:45.000000000 +0300
@@ -371,87 +371,6 @@
 	MAKE_LIST((cachep), (&(ptr)->slabs_free), slabs_free, nodeid);	\
 	} while (0)
 
-/*
- * struct kmem_cache
- *
- * manages a cache.
- */
-
-struct kmem_cache {
-/* 1) per-cpu data, touched during every alloc/free */
-	struct array_cache *array[NR_CPUS];
-/* 2) Cache tunables. Protected by cache_chain_mutex */
-	unsigned int batchcount;
-	unsigned int limit;
-	unsigned int shared;
-
-	unsigned int buffer_size;
-	u32 reciprocal_buffer_size;
-/* 3) touched by every alloc & free from the backend */
-
-	unsigned int flags;		/* constant flags */
-	unsigned int num;		/* # of objs per slab */
-
-/* 4) cache_grow/shrink */
-	/* order of pgs per slab (2^n) */
-	unsigned int gfporder;
-
-	/* force GFP flags, e.g. GFP_DMA */
-	gfp_t gfpflags;
-
-	size_t colour;			/* cache colouring range */
-	unsigned int colour_off;	/* colour offset */
-	struct kmem_cache *slabp_cache;
-	unsigned int slab_size;
-	unsigned int dflags;		/* dynamic flags */
-
-	/* constructor func */
-	void (*ctor)(struct kmem_cache *, void *);
-
-/* 5) cache creation/removal */
-	const char *name;
-	struct list_head next;
-
-/* 6) statistics */
-#if STATS
-	unsigned long num_active;
-	unsigned long num_allocations;
-	unsigned long high_mark;
-	unsigned long grown;
-	unsigned long reaped;
-	unsigned long errors;
-	unsigned long max_freeable;
-	unsigned long node_allocs;
-	unsigned long node_frees;
-	unsigned long node_overflow;
-	atomic_t allochit;
-	atomic_t allocmiss;
-	atomic_t freehit;
-	atomic_t freemiss;
-#endif
-#if DEBUG
-	/*
-	 * If debugging is enabled, then the allocator can add additional
-	 * fields and/or padding to every object. buffer_size contains the total
-	 * object size including these internal fields, the following two
-	 * variables contain the offset to the user object and its size.
-	 */
-	int obj_offset;
-	int obj_size;
-#endif
-	/*
-	 * We put nodelists[] at the end of kmem_cache, because we want to size
-	 * this array to nr_node_ids slots instead of MAX_NUMNODES
-	 * (see kmem_cache_init())
-	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
-	 * is statically defined, so we reserve the max number of nodes.
-	 */
-	struct kmem_list3 *nodelists[MAX_NUMNODES];
-	/*
-	 * Do not add fields after nodelists[]
-	 */
-};
-
 #define CFLGS_OFF_SLAB		(0x80000000UL)
 #define	OFF_SLAB(x)	((x)->flags & CFLGS_OFF_SLAB)
 

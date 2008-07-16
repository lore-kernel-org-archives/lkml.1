Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYGPAYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYGPAYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYGPAXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:23:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbYGPAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Ygf6LQTwZ1eZ+iLfdsXEHRIXWldBnUptUpXBP2xSq9aZpzHSRVImJVm1IBxEnzVu1a
         rxuP9s/teAO+HkyHs+Geo2qcyH0HKQ7oUQMmO4+hgXQ3R5K+XSntmMDxzcqVu9N6cBEa
         A6/uLHbQ1YhboPG3yaiAAm+TgznSRjiMpZmI0=
Date: Wed, 16 Jul 2008 02:22:58 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] slab: move struct kmem_cache to headers
Message-ID: <20080716002258.GE12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c418354ad71e10cfd6abc78328d643c1699c7998 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 9 May 2008 20:32:44 +0200
Subject: [PATCH 04/13] slab: move struct kmem_cache to headers

Move the SLAB struct kmem_cache definition to <linux/slab_def.h> like
with SLUB so kmemcheck can access ->ctor and ->flags.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/slab_def.h |   81 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/slab.c                |   81 ----------------------------------------------
 2 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 39c3a5e..37b4837 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
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
diff --git a/mm/slab.c b/mm/slab.c
index 046607f..8986265 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -371,87 +371,6 @@ static void kmem_list3_init(struct kmem_list3 *parent)
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
 
-- 
1.5.5.1


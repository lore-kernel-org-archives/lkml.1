Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXGHDvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXGHDvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXGHDuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:50:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49240 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755573AbXGHDuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:50:17 -0400
Message-Id: <20070708035016.166637038@sgi.com>
References: <20070708034952.022985379@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:49:53 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Cc: corey.d.gough@intel.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Subject: [patch 01/10] SLUB: Direct pass through of page size or higher kmalloc requests
Content-Disposition: inline; filename=slub_page_allocator_pass_through
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of all kmalloc caches larger than page size. A
kmalloc request larger than PAGE_SIZE > 2 is going to be passed
through to the page allocator. This works both inline where
we will call __get_free_pages instead of kmem_cache_alloc and
in __kmalloc.

kfree is modified to check if the object is in a slab page. If not
then the page is freed via the page allocator instead.

Drawbacks:
- No accounting for large kmalloc slab allocations anymore
- No debugging of large kmalloc slab allocations.
- Meshing of slab allocations and page allocator allocations
  become possible.
- Strange discontinuity in kmalloc operations. If larger than
  page size then full page allocator semantics apply.
  But SLOB is already doing that.
- kmalloc objects are aligned to ARCH_KMALLOC_MINALIGN
  if smaller than PAGE_SIZE otherwise they are
  page aligned.
- Additional check of the size in kmalloc and kfree.

Advantages:
- Significantly reduces memory overhead for kmalloc array
- Large kmalloc operations are faster since they do not
  need to pass through the slab allocator to get to the
  page allocator.
- Large kmallocs yields page aligned object which is what
  SLAB does. Bad things like using page sized kmalloc allocations can
  be transparently handled and are not distinguishable from page
  allocator uses.
- Checking for too large objects can be removed since
  it is done by the page allocator.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |   57 +++++++++++++++++-------------------------
 mm/slub.c                |   63 ++++++++++++++++++++++++++++-------------------
 2 files changed, 62 insertions(+), 58 deletions(-)

Index: linux-2.6.22-rc6-mm1/mm/slub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/slub.c	2007-07-06 16:08:36.000000000 -0700
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-06 16:08:36.000000000 -0700
@@ -2239,11 +2239,11 @@ EXPORT_SYMBOL(kmem_cache_destroy);
  *		Kmalloc subsystem
  *******************************************************************/
 
-struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1] __cacheline_aligned;
+struct kmem_cache kmalloc_caches[PAGE_SHIFT] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);
 
 #ifdef CONFIG_ZONE_DMA
-static struct kmem_cache *kmalloc_caches_dma[KMALLOC_SHIFT_HIGH + 1];
+static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT];
 #endif
 
 static int __init setup_slub_min_order(char *str)
@@ -2379,12 +2379,8 @@ static struct kmem_cache *get_slab(size_
 			return ZERO_SIZE_PTR;
 
 		index = size_index[(size - 1) / 8];
-	} else {
-		if (size > KMALLOC_MAX_SIZE)
-			return NULL;
-
+	} else
 		index = fls(size - 1);
-	}
 
 #ifdef CONFIG_ZONE_DMA
 	if (unlikely((flags & SLUB_DMA)))
@@ -2396,9 +2392,15 @@ static struct kmem_cache *get_slab(size_
 
 void *__kmalloc(size_t size, gfp_t flags)
 {
-	struct kmem_cache *s = get_slab(size, flags);
+	struct kmem_cache *s;
 
-	if (ZERO_OR_NULL_PTR(s))
+	if (unlikely(size > PAGE_SIZE / 2))
+		return (void *)__get_free_pages(flags | __GFP_COMP,
+							get_order(size));
+
+	s = get_slab(size, flags);
+
+	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
 	return slab_alloc(s, flags, -1, __builtin_return_address(0));
@@ -2408,9 +2410,15 @@ EXPORT_SYMBOL(__kmalloc);
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
-	struct kmem_cache *s = get_slab(size, flags);
+	struct kmem_cache *s;
 
-	if (ZERO_OR_NULL_PTR(s))
+	if (unlikely(size > PAGE_SIZE / 2))
+		return (void *)__get_free_pages(flags | __GFP_COMP,
+							get_order(size));
+
+	s = get_slab(size, flags);
+
+	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
 	return slab_alloc(s, flags, node, __builtin_return_address(0));
@@ -2455,22 +2463,17 @@ EXPORT_SYMBOL(ksize);
 
 void kfree(const void *x)
 {
-	struct kmem_cache *s;
 	struct page *page;
 
-	/*
-	 * This has to be an unsigned comparison. According to Linus
-	 * some gcc version treat a pointer as a signed entity. Then
-	 * this comparison would be true for all "negative" pointers
-	 * (which would cover the whole upper half of the address space).
-	 */
 	if (ZERO_OR_NULL_PTR(x))
 		return;
 
 	page = virt_to_head_page(x);
-	s = page->slab;
-
-	slab_free(s, page, (void *)x, __builtin_return_address(0));
+	if (unlikely(!PageSlab(page))) {
+		put_page(page);
+		return;
+	}
+	slab_free(page->slab, page, (void *)x, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kfree);
 
@@ -2927,7 +2930,7 @@ void __init kmem_cache_init(void)
 		caches++;
 	}
 
-	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
+	for (i = KMALLOC_SHIFT_LOW; i < PAGE_SHIFT; i++) {
 		create_kmalloc_cache(&kmalloc_caches[i],
 			"kmalloc", 1 << i, GFP_KERNEL);
 		caches++;
@@ -2954,7 +2957,7 @@ void __init kmem_cache_init(void)
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
-	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
+	for (i = KMALLOC_SHIFT_LOW; i < PAGE_SHIFT; i++)
 		kmalloc_caches[i]. name =
 			kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
 
@@ -3142,7 +3145,12 @@ static struct notifier_block __cpuinitda
 
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 {
-	struct kmem_cache *s = get_slab(size, gfpflags);
+	struct kmem_cache *s;
+
+	if (unlikely(size > PAGE_SIZE / 2))
+		return (void *)__get_free_pages(gfpflags | __GFP_COMP,
+							get_order(size));
+	s = get_slab(size, gfpflags);
 
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
@@ -3153,7 +3161,12 @@ void *__kmalloc_track_caller(size_t size
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 					int node, void *caller)
 {
-	struct kmem_cache *s = get_slab(size, gfpflags);
+	struct kmem_cache *s;
+
+	if (unlikely(size > PAGE_SIZE / 2))
+		return (void *)__get_free_pages(gfpflags | __GFP_COMP,
+							get_order(size));
+	s = get_slab(size, gfpflags);
 
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
Index: linux-2.6.22-rc6-mm1/include/linux/slub_def.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/slub_def.h	2007-07-06 16:07:53.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/linux/slub_def.h	2007-07-06 16:08:36.000000000 -0700
@@ -81,7 +81,7 @@ struct kmem_cache {
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
  */
-extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
+extern struct kmem_cache kmalloc_caches[PAGE_SHIFT];
 
 /*
  * Sorry that the following has to be that ugly but some versions of GCC
@@ -92,9 +92,6 @@ static inline int kmalloc_index(size_t s
 	if (!size)
 		return 0;
 
-	if (size > KMALLOC_MAX_SIZE)
-		return -1;
-
 	if (size <= KMALLOC_MIN_SIZE)
 		return KMALLOC_SHIFT_LOW;
 
@@ -111,6 +108,10 @@ static inline int kmalloc_index(size_t s
 	if (size <=        512) return 9;
 	if (size <=       1024) return 10;
 	if (size <=   2 * 1024) return 11;
+/*
+ * The following is only needed to support architectures with a larger page
+ * size than 4k.
+ */
 	if (size <=   4 * 1024) return 12;
 	if (size <=   8 * 1024) return 13;
 	if (size <=  16 * 1024) return 14;
@@ -118,13 +119,9 @@ static inline int kmalloc_index(size_t s
 	if (size <=  64 * 1024) return 16;
 	if (size <= 128 * 1024) return 17;
 	if (size <= 256 * 1024) return 18;
-	if (size <=  512 * 1024) return 19;
+	if (size <= 512 * 1024) return 19;
 	if (size <= 1024 * 1024) return 20;
 	if (size <=  2 * 1024 * 1024) return 21;
-	if (size <=  4 * 1024 * 1024) return 22;
-	if (size <=  8 * 1024 * 1024) return 23;
-	if (size <= 16 * 1024 * 1024) return 24;
-	if (size <= 32 * 1024 * 1024) return 25;
 	return -1;
 
 /*
@@ -149,19 +146,6 @@ static inline struct kmem_cache *kmalloc
 	if (index == 0)
 		return NULL;
 
-	/*
-	 * This function only gets expanded if __builtin_constant_p(size), so
-	 * testing it here shouldn't be needed.  But some versions of gcc need
-	 * help.
-	 */
-	if (__builtin_constant_p(size) && index < 0) {
-		/*
-		 * Generate a link failure. Would be great if we could
-		 * do something to stop the compile here.
-		 */
-		extern void __kmalloc_size_too_large(void);
-		__kmalloc_size_too_large();
-	}
 	return &kmalloc_caches[index];
 }
 
@@ -177,15 +161,21 @@ void *__kmalloc(size_t size, gfp_t flags
 
 static inline void *kmalloc(size_t size, gfp_t flags)
 {
-	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
-		struct kmem_cache *s = kmalloc_slab(size);
+	if (__builtin_constant_p(size)) {
+		if (size > PAGE_SIZE / 2)
+			return (void *)__get_free_pages(flags | __GFP_COMP,
+							get_order(size));
 
-		if (!s)
-			return ZERO_SIZE_PTR;
+		if (!(flags & SLUB_DMA)) {
+			struct kmem_cache *s = kmalloc_slab(size);
+
+			if (!s)
+				return ZERO_SIZE_PTR;
 
-		return kmem_cache_alloc(s, flags);
-	} else
-		return __kmalloc(size, flags);
+			return kmem_cache_alloc(s, flags);
+		}
+	}
+	return __kmalloc(size, flags);
 }
 
 #ifdef CONFIG_NUMA
@@ -194,15 +184,16 @@ void *kmem_cache_alloc_node(struct kmem_
 
 static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
-	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
-		struct kmem_cache *s = kmalloc_slab(size);
+	if (__builtin_constant_p(size) &&
+		size <= PAGE_SIZE / 2 && !(flags & SLUB_DMA)) {
+			struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
 			return ZERO_SIZE_PTR;
 
 		return kmem_cache_alloc_node(s, flags, node);
-	} else
-		return __kmalloc_node(size, flags, node);
+	}
+	return __kmalloc_node(size, flags, node);
 }
 #endif
 

-- 

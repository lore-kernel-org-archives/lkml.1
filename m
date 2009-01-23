Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZAWIna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZAWIna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 03:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZAWInW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 03:43:22 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34129 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZAWInV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:43:21 -0500
Date: Fri, 23 Jan 2009 10:43:20 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: cl@linux-foundation.org
cc: yanmin_zhang@linux.intel.com, Andi Kleen <andi@firstfloor.org>,
       Matthew Wilcox <matthew@wil.cx>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, akmp@linux-foundation.org
Subject: [PATCH] SLUB: revert direct page allocator pass through
Message-ID: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch reverts page allocator pass-through logic from the SLUB allocator.

Commit aadb4bc4a1f9108c1d0fbd121827c936c2ed4217 ("SLUB: direct pass through of
page size or higher kmalloc requests") added page allocator pass-through to the
SLUB allocator for large sized allocations. This, however, results in a
performance regression compared to SLAB in the netperf UDP-U-4k test.

The regression comes from the kfree(skb->head) call in skb_release_data() that
is subject to page allocator pass-through as the size passed to __alloc_skb()
is larger than 4 KB in this test. With this patch, the performance regression
is almost closed:

  <insert numbers here>

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Tested-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Yanmin, do you still have the relevant numbers I could cut and paste to 
the patch description?

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 2f5c16b..3bd3662 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -124,7 +124,7 @@ struct kmem_cache {
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
  */
-extern struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1];
+extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
 
 /*
  * Sorry that the following has to be that ugly but some versions of GCC
@@ -135,6 +135,9 @@ static __always_inline int kmalloc_index(size_t size)
 	if (!size)
 		return 0;
 
+	if (size > KMALLOC_MAX_SIZE)
+		return -1;
+
 	if (size <= KMALLOC_MIN_SIZE)
 		return KMALLOC_SHIFT_LOW;
 
@@ -154,10 +157,6 @@ static __always_inline int kmalloc_index(size_t size)
 	if (size <=       1024) return 10;
 	if (size <=   2 * 1024) return 11;
 	if (size <=   4 * 1024) return 12;
-/*
- * The following is only needed to support architectures with a larger page
- * size than 4k.
- */
 	if (size <=   8 * 1024) return 13;
 	if (size <=  16 * 1024) return 14;
 	if (size <=  32 * 1024) return 15;
@@ -167,6 +166,10 @@ static __always_inline int kmalloc_index(size_t size)
 	if (size <= 512 * 1024) return 19;
 	if (size <= 1024 * 1024) return 20;
 	if (size <=  2 * 1024 * 1024) return 21;
+	if (size <=  4 * 1024 * 1024) return 22;
+	if (size <=  8 * 1024 * 1024) return 23;
+	if (size <= 16 * 1024 * 1024) return 24;
+	if (size <= 32 * 1024 * 1024) return 25;
 	return -1;
 
 /*
@@ -191,6 +194,19 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 	if (index == 0)
 		return NULL;
 
+	/*
+	 * This function only gets expanded if __builtin_constant_p(size), so
+	 * testing it here shouldn't be needed.  But some versions of gcc need
+	 * help.
+	 */
+	if (__builtin_constant_p(size) && index < 0) {
+		/*
+		 * Generate a link failure. Would be great if we could
+		 * do something to stop the compile here.
+		 */
+		extern void __kmalloc_size_too_large(void);
+		__kmalloc_size_too_large();
+	}
 	return &kmalloc_caches[index];
 }
 
@@ -204,17 +220,9 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
-{
-	return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
-}
-
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
-		if (size > PAGE_SIZE)
-			return kmalloc_large(size, flags);
-
 		if (!(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
 
diff --git a/mm/slub.c b/mm/slub.c
index 6392ae5..8fad23f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2475,7 +2475,7 @@ EXPORT_SYMBOL(kmem_cache_destroy);
  *		Kmalloc subsystem
  *******************************************************************/
 
-struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1] __cacheline_aligned;
+struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);
 
 static int __init setup_slub_min_order(char *str)
@@ -2537,7 +2537,7 @@ panic:
 }
 
 #ifdef CONFIG_ZONE_DMA
-static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT + 1];
+static struct kmem_cache *kmalloc_caches_dma[KMALLOC_SHIFT_HIGH + 1];
 
 static void sysfs_add_func(struct work_struct *w)
 {
@@ -2643,8 +2643,12 @@ static struct kmem_cache *get_slab(size_t size, gfp_t flags)
 			return ZERO_SIZE_PTR;
 
 		index = size_index[(size - 1) / 8];
-	} else
+	} else {
+		if (size > KMALLOC_MAX_SIZE)
+			return NULL;
+
 		index = fls(size - 1);
+	}
 
 #ifdef CONFIG_ZONE_DMA
 	if (unlikely((flags & SLUB_DMA)))
@@ -2658,9 +2662,6 @@ void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large(size, flags);
-
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
@@ -2670,25 +2671,11 @@ void *__kmalloc(size_t size, gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc);
 
-static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
-{
-	struct page *page = alloc_pages_node(node, flags | __GFP_COMP,
-						get_order(size));
-
-	if (page)
-		return page_address(page);
-	else
-		return NULL;
-}
-
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large_node(size, flags, node);
-
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
@@ -2746,11 +2733,8 @@ void kfree(const void *x)
 		return;
 
 	page = virt_to_head_page(x);
-	if (unlikely(!PageSlab(page))) {
-		BUG_ON(!PageCompound(page));
-		put_page(page);
+	if (unlikely(WARN_ON(!PageSlab(page)))) /* XXX */
 		return;
-	}
 	slab_free(page->slab, page, object, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
@@ -2985,7 +2969,7 @@ void __init kmem_cache_init(void)
 		caches++;
 	}
 
-	for (i = KMALLOC_SHIFT_LOW; i <= PAGE_SHIFT; i++) {
+	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 		create_kmalloc_cache(&kmalloc_caches[i],
 			"kmalloc", 1 << i, GFP_KERNEL);
 		caches++;
@@ -3022,7 +3006,7 @@ void __init kmem_cache_init(void)
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
-	for (i = KMALLOC_SHIFT_LOW; i <= PAGE_SHIFT; i++)
+	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
 		kmalloc_caches[i]. name =
 			kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
 
@@ -3222,9 +3206,6 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large(size, gfpflags);
-
 	s = get_slab(size, gfpflags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
@@ -3238,9 +3219,6 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large_node(size, gfpflags, node);
-
 	s = get_slab(size, gfpflags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))

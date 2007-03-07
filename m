Return-Path: <linux-kernel-owner+w=401wt.eu-S1161238AbXCGCfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161238AbXCGCfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161235AbXCGCfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:35:43 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38119 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161227AbXCGCfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:35:16 -0500
From: Christoph Lameter <clameter@sgi.com>
To: akpm@osdl.org
Cc: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <clameter@sgi.com>,
       mpm@selenic.com, Manfred Spraul <manfred@colorfullife.com>
Message-Id: <20070307023513.19658.81228.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com>
References: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com>
Subject: [SLUB 2/3] Large kmalloc pass through. Removal of large general slabs
Date: Tue,  6 Mar 2007 18:35:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unlimited kmalloc size and removal of general caches >=4.

We can directly use the page allocator for all allocations 4K and larger. This
means that no general slabs are necessary and the size of the allocation passed
to kmalloc() can be arbitrarily large. Remove the useless general caches over 4k.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc2-mm1/mm/slub.c
===================================================================
--- linux-2.6.21-rc2-mm1.orig/mm/slub.c	2007-03-06 17:56:50.000000000 -0800
+++ linux-2.6.21-rc2-mm1/mm/slub.c	2007-03-06 17:57:11.000000000 -0800
@@ -1101,6 +1101,13 @@ void kmem_cache_free(struct kmem_cache *
 	if (unlikely(PageCompound(page)))
 		page = page->first_page;
 
+	if (unlikely(!PageSlab(page))) {
+		if (x == page_address(page)) {
+			put_page(page);
+			return;
+		}
+	}
+
 	if (!s)
 		s = page->slab;
 
@@ -1678,7 +1685,8 @@ static struct kmem_cache *get_slab(size_
 	/* SLAB allows allocations with zero size. So warn on those */
 	WARN_ON(size == 0);
 	/* Allocation too large? */
-	BUG_ON(index < 0);
+	if (index < 0)
+		return NULL;
 
 #ifdef CONFIG_ZONE_DMA
 	if ((flags & SLUB_DMA)) {
@@ -1722,15 +1730,32 @@ static struct kmem_cache *get_slab(size_
 
 void *__kmalloc(size_t size, gfp_t flags)
 {
-	return kmem_cache_alloc(get_slab(size, flags), flags);
+	struct kmem_cache *s = get_slab(size, flags);
+	struct page *page;
+
+	if (s)
+		return kmem_cache_alloc(s, flags);
+
+	page = alloc_pages(flags, get_order(size));
+	if (!page)
+		return NULL;
+	return page_address(page);
 }
 EXPORT_SYMBOL(__kmalloc);
 
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
-	return kmem_cache_alloc_node(get_slab(size, flags),
-							flags, node);
+	struct kmem_cache *s = get_slab(size, flags);
+	struct page *page;
+
+	if (s)
+		return kmem_cache_alloc_node(s, flags, node);
+
+	page = alloc_pages_node(node, flags, get_order(size));
+	if (!page)
+		return NULL;
+	return page_address(page);
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
Index: linux-2.6.21-rc2-mm1/include/linux/slub_def.h
===================================================================
--- linux-2.6.21-rc2-mm1.orig/include/linux/slub_def.h	2007-03-06 17:56:14.000000000 -0800
+++ linux-2.6.21-rc2-mm1/include/linux/slub_def.h	2007-03-06 17:57:11.000000000 -0800
@@ -55,7 +55,7 @@ struct kmem_cache {
  */
 #define KMALLOC_SHIFT_LOW 3
 
-#define KMALLOC_SHIFT_HIGH 18
+#define KMALLOC_SHIFT_HIGH 11
 
 #if L1_CACHE_BYTES <= 64
 #define KMALLOC_EXTRAS 2
@@ -93,13 +93,6 @@ static inline int kmalloc_index(int size
 	if (size <=  512) return 9;
 	if (size <= 1024) return 10;
 	if (size <= 2048) return 11;
-	if (size <= 4096) return 12;
-	if (size <=   8 * 1024) return 13;
-	if (size <=  16 * 1024) return 14;
-	if (size <=  32 * 1024) return 15;
-	if (size <=  64 * 1024) return 16;
-	if (size <= 128 * 1024) return 17;
-	if (size <= 256 * 1024) return 18;
 	return -1;
 }
 
@@ -113,14 +106,8 @@ static inline struct kmem_cache *kmalloc
 {
 	int index = kmalloc_index(size) - KMALLOC_SHIFT_LOW;
 
-	if (index < 0) {
-		/*
-		 * Generate a link failure. Would be great if we could
-		 * do something to stop the compile here.
-		 */
-		extern void __kmalloc_size_too_large(void);
-		__kmalloc_size_too_large();
-	}
+	if (index < 0)
+		return NULL;
 	return &kmalloc_caches[index];
 }
 
@@ -136,9 +123,10 @@ static inline void *kmalloc(size_t size,
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
 		struct kmem_cache *s = kmalloc_slab(size);
 
-		return kmem_cache_alloc(s, flags);
-	} else
-		return __kmalloc(size, flags);
+		if (s)
+			return kmem_cache_alloc(s, flags);
+	}
+	return __kmalloc(size, flags);
 }
 
 static inline void *kzalloc(size_t size, gfp_t flags)
@@ -146,9 +134,10 @@ static inline void *kzalloc(size_t size,
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
 		struct kmem_cache *s = kmalloc_slab(size);
 
-		return kmem_cache_zalloc(s, flags);
-	} else
-		return __kzalloc(size, flags);
+		if (s)
+			return kmem_cache_zalloc(s, flags);
+	}
+	return __kzalloc(size, flags);
 }
 
 #ifdef CONFIG_NUMA
@@ -159,9 +148,10 @@ static inline void *kmalloc_node(size_t 
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
 		struct kmem_cache *s = kmalloc_slab(size);
 
-		return kmem_cache_alloc_node(s, flags, node);
-	} else
-		return __kmalloc_node(size, flags, node);
+		if (s)
+			return kmem_cache_alloc_node(s, flags, node);
+	}
+	return __kmalloc_node(size, flags, node);
 }
 #endif
 

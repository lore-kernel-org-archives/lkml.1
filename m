Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZBUNhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZBUNhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZBUNgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:36:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:50544 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZBUNgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:36:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hKZg/YO/5JUk4af2Q2zYWcPgPvDUnD0s3kS+BqzWJ+sHFIvSgphPFbjAIOAJk2MZt/
         qKiU4xik1RHTL9AB1Zsdo/KdHFa9KaP7OcaPL7f1o1B5/MMEyDjxMOZ22To7zNczfJdS
         JUDDnWPq90ccnV8HfBwCUFsnF3Rv27LbcDNGI=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH] kmemcheck: add hooks for the page allocator
Date: Sat, 21 Feb 2009 14:36:04 +0100
Message-Id: <1235223364-2097-5-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
In-Reply-To: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com>
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for tracking the initializedness of memory that
was allocated with the page allocator. Highmem requests are not
tracked.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/include/asm/thread_info.h |    4 +-
 arch/x86/mm/kmemcheck/shadow.c     |    8 ++++++
 include/linux/gfp.h                |    5 ++++
 include/linux/kmemcheck.h          |   33 ++++++++++++++++++++++----
 mm/kmemcheck.c                     |   45 +++++++++++++++++++++++++----------
 mm/page_alloc.c                    |    8 ++++++
 mm/slab.c                          |   15 ++++++++----
 mm/slub.c                          |   23 ++++++++++++++----
 8 files changed, 111 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index df9d5f7..b5392e3 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -149,9 +149,9 @@ struct thread_info {
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
 #else
-#define THREAD_FLAGS GFP_KERNEL
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK)
 #endif
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
index 196dddc..aab8c18 100644
--- a/arch/x86/mm/kmemcheck/shadow.c
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -86,6 +86,14 @@ void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n)
 		kmemcheck_mark_uninitialized(page_address(&p[i]), PAGE_SIZE);
 }
 
+void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_initialized(page_address(&p[i]), PAGE_SIZE);
+}
+
 enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
 {
 	uint8_t *x;
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index e56f72f..e2ec7d5 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -50,7 +50,12 @@ struct vm_area_struct;
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
 #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
+
+#ifdef CONFIG_KMEMCHECK
 #define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */
+#else
+#define __GFP_NOTRACK	((__force gfp_t)0)
+#endif
 
 #define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index 7073121..2ee402e 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -42,13 +42,15 @@ extern int kmemcheck_enabled;
 void kmemcheck_init(void);
 
 /* The slab-related functions. */
-void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
-			    struct page *page, int order);
-void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order);
+void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node);
+void kmemcheck_free_shadow(struct page *page, int order);
 void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
 			  size_t size);
 void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size);
 
+void kmemcheck_pagealloc_alloc(struct page *p, unsigned int order,
+			       gfp_t gfpflags);
+
 void kmemcheck_show_pages(struct page *p, unsigned int n);
 void kmemcheck_hide_pages(struct page *p, unsigned int n);
 
@@ -61,6 +63,7 @@ void kmemcheck_mark_freed(void *address, unsigned int n);
 
 void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n);
 void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
+void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n);
 
 int kmemcheck_show_addr(unsigned long address);
 int kmemcheck_hide_addr(unsigned long address);
@@ -77,13 +80,13 @@ static inline void kmemcheck_init(void)
 }
 
 static inline void
-kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+kmemcheck_alloc_shadow(int ctor, gfp_t flags, int node,
 		       struct page *page, int order)
 {
 }
 
 static inline void
-kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+kmemcheck_free_shadow(struct page *page, int order)
 {
 }
 
@@ -98,6 +101,11 @@ static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object,
 {
 }
 
+static inline void kmemcheck_pagealloc_alloc(struct page *p,
+	unsigned int order, gfp_t gfpflags)
+{
+}
+
 static inline bool kmemcheck_page_is_tracked(struct page *p)
 {
 	return false;
@@ -119,6 +127,21 @@ static inline void kmemcheck_mark_freed(void *address, unsigned int n)
 {
 }
 
+static inline void kmemcheck_mark_unallocated_pages(struct page *p,
+						    unsigned int n)
+{
+}
+
+static inline void kmemcheck_mark_uninitialized_pages(struct page *p,
+						      unsigned int n)
+{
+}
+
+static inline void kmemcheck_mark_initialized_pages(struct page *p,
+						    unsigned int n)
+{
+}
+
 #define kmemcheck_annotate_bitfield(field) do { } while (0)
 #endif /* CONFIG_KMEMCHECK */
 
diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
index eaa41b8..fd814fd 100644
--- a/mm/kmemcheck.c
+++ b/mm/kmemcheck.c
@@ -1,10 +1,10 @@
+#include <linux/gfp.h>
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/kmemcheck.h>
 
-void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
-			   struct page *page, int order)
+void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
 {
 	struct page *shadow;
 	int pages;
@@ -16,7 +16,7 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 	 * With kmemcheck enabled, we need to allocate a memory area for the
 	 * shadow bits as well.
 	 */
-	shadow = alloc_pages_node(node, flags, order);
+	shadow = alloc_pages_node(node, flags | __GFP_NOTRACK, order);
 	if (!shadow) {
 		if (printk_ratelimit())
 			printk(KERN_ERR "kmemcheck: failed to allocate "
@@ -33,23 +33,17 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 	 * the memory accesses.
 	 */
 	kmemcheck_hide_pages(page, pages);
-
-	/*
-	 * Objects from caches that have a constructor don't get
-	 * cleared when they're allocated, so we need to do it here.
-	 */
-	if (s->ctor)
-		kmemcheck_mark_uninitialized_pages(page, pages);
-	else
-		kmemcheck_mark_unallocated_pages(page, pages);
 }
 
-void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+void kmemcheck_free_shadow(struct page *page, int order)
 {
 	struct page *shadow;
 	int pages;
 	int i;
 
+	if (!kmemcheck_page_is_tracked(page))
+		return;
+
 	pages = 1 << order;
 
 	kmemcheck_show_pages(page, pages);
@@ -101,3 +95,28 @@ void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size)
 	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
 		kmemcheck_mark_freed(object, size);
 }
+
+void kmemcheck_pagealloc_alloc(struct page *page, unsigned int order,
+			       gfp_t gfpflags)
+{
+	int pages;
+
+	if (gfpflags & (__GFP_HIGHMEM | __GFP_NOTRACK))
+		return;
+
+	pages = 1 << order;
+
+	/*
+	 * NOTE: We choose to track GFP_ZERO pages too; in fact, they
+	 * can become uninitialized by copying uninitialized memory
+	 * into them.
+	 */
+
+	/* XXX: Can use zone->node for node? */
+	kmemcheck_alloc_shadow(page, order, gfpflags, -1);
+
+	if (gfpflags & __GFP_ZERO)
+		kmemcheck_mark_initialized_pages(page, pages);
+	else
+		kmemcheck_mark_uninitialized_pages(page, pages);
+}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5675b30..cf247fd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -23,6 +23,7 @@
 #include <linux/bootmem.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
+#include <linux/kmemcheck.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
 #include <linux/pagevec.h>
@@ -549,6 +550,8 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	int i;
 	int bad = 0;
 
+	kmemcheck_free_shadow(page, order);
+
 	for (i = 0 ; i < (1 << order) ; ++i)
 		bad += free_pages_check(page + i);
 	if (bad)
@@ -1000,6 +1003,8 @@ static void free_hot_cold_page(struct page *page, int cold)
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
 
+	kmemcheck_free_shadow(page, 0);
+
 	if (PageAnon(page))
 		page->mapping = NULL;
 	if (free_pages_check(page))
@@ -1667,7 +1672,10 @@ nopage:
 		dump_stack();
 		show_mem();
 	}
+	return page;
 got_pg:
+	if (kmemcheck_enabled)
+		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_internal);
diff --git a/mm/slab.c b/mm/slab.c
index d6735bd..4fa7b7b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1600,7 +1600,7 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
-	page = alloc_pages_node(nodeid, flags, cachep->gfporder);
+	page = alloc_pages_node(nodeid, flags & ~__GFP_NOTRACK, cachep->gfporder);
 	if (!page)
 		return NULL;
 
@@ -1614,8 +1614,14 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	for (i = 0; i < nr_pages; i++)
 		__SetPageSlab(page + i);
 
-	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK))
-		kmemcheck_alloc_shadow(cachep, flags, nodeid, page, cachep->gfporder);
+	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
+		kmemcheck_alloc_shadow(page, cachep->gfporder, flags, nodeid);
+
+		if (cachep->ctor)
+			kmemcheck_mark_uninitialized_pages(page, nr_pages);
+		else
+			kmemcheck_mark_unallocated_pages(page, nr_pages);
+	}
 
 	return page_address(page);
 }
@@ -1629,8 +1635,7 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 	struct page *page = virt_to_page(addr);
 	const unsigned long nr_freed = i;
 
-	if (kmemcheck_page_is_tracked(page))
-		kmemcheck_free_shadow(cachep, page, cachep->gfporder);
+	kmemcheck_free_shadow(page, cachep->gfporder);
 
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		sub_zone_page_state(page_zone(page),
diff --git a/mm/slub.c b/mm/slub.c
index 628e3ec..b9c8169 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1069,6 +1069,8 @@ static inline struct page *alloc_slab_page(gfp_t flags, int node,
 {
 	int order = oo_order(oo);
 
+	flags |= __GFP_NOTRACK;
+
 	if (node == -1)
 		return alloc_pages(flags, order);
 	else
@@ -1100,7 +1102,18 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if (kmemcheck_enabled
 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS)))
 	{
-		kmemcheck_alloc_shadow(s, flags, node, page, compound_order(page));
+		int pages = 1 << oo_order(oo);
+
+		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
+
+		/*
+		 * Objects from caches that have a constructor don't get
+		 * cleared when they're allocated, so we need to do it here.
+		 */
+		if (s->ctor)
+			kmemcheck_mark_uninitialized_pages(page, pages);
+		else
+			kmemcheck_mark_unallocated_pages(page, pages);
 	}
 
 	page->objects = oo_objects(oo);
@@ -1176,8 +1189,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		__ClearPageSlubDebug(page);
 	}
 
-	if (kmemcheck_page_is_tracked(page))
-		kmemcheck_free_shadow(s, page, compound_order(page));
+	kmemcheck_free_shadow(page, compound_order(page));
 
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -2686,9 +2698,10 @@ EXPORT_SYMBOL(__kmalloc);
 
 static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct page *page = alloc_pages_node(node, flags | __GFP_COMP,
-						get_order(size));
+	struct page *page;
 
+	flags |= __GFP_COMP | __GFP_NOTRACK;
+	page = alloc_pages_node(node, flags, get_order(size));
 	if (page)
 		return page_address(page);
 	else
-- 
1.6.0.6


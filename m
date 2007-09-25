Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbXIYXtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbXIYXtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbXIYXnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752499AbXIYXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:51 -0400
Message-Id: <20070925234251.036277839@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:12 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [08/17] GFP_VFALLBACK: Allow fallback of compound pages to virtual mappings
Content-Disposition: inline; filename=vcompound_core
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new gfp flag

	__GFP_VFALLBACK

If specified during a higher order allocation then the system will fall
back to vmap and attempt to create a virtually contiguous area instead of
a physically contiguous area. In many cases the virtually contiguous area
can stand in for the physically contiguous area (with some loss of
performance).

The pages used for VFALLBACK are marked with a new flag
PageVcompound(page). The mark is necessary since we have to know upon
free if we have to destroy a virtual mapping. No additional flag is
consumed through the use of PG_swapcache together with PG_compound
(similar to PageHead() and PageTail()).

Also add a new function

	compound_nth_page(page, n)

to find the nth page of a compound page. For real compound pages
this simply reduces to page + n. For virtual compound pages we need to consult
the page tables to figure out the nth page.

Add new page to address and vice versa functions.

	struct page *addr_to_page(const void *address);
	void *page_to_addr(struct page *);

The new conversion functions allow the conversion of vmalloc areas to
the corresponding page structs that back it and vice versa. If the
addresses or the page struct is not part of a vmalloc function then
fall back to virt_to_page and page_address().

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/gfp.h        |    5 +
 include/linux/mm.h         |   33 +++++++++--
 include/linux/page-flags.h |   18 ++++++
 mm/page_alloc.c            |  131 ++++++++++++++++++++++++++++++++++++++++-----
 mm/vmalloc.c               |   10 +++
 5 files changed, 179 insertions(+), 18 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-25 10:22:16.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-25 10:22:36.000000000 -0700
@@ -60,6 +60,8 @@ long nr_swap_pages;
 int percpu_pagelist_fraction;
 
 static void __free_pages_ok(struct page *page, unsigned int order);
+static struct page *vcompound_alloc(gfp_t, int,
+					struct zonelist *, unsigned long);
 
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
@@ -251,7 +253,7 @@ static void prep_compound_page(struct pa
 	set_compound_order(page, order);
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
-		struct page *p = page + i;
+		struct page *p = compound_nth_page(page, i);
 
 		__SetPageTail(p);
 		p->first_page = page;
@@ -266,17 +268,23 @@ static void destroy_compound_page(struct
 	if (unlikely(compound_order(page) != order))
 		bad_page(page);
 
-	if (unlikely(!PageHead(page)))
-			bad_page(page);
-	__ClearPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
-		struct page *p = page + i;
+		struct page *p = compound_nth_page(page,  i);
 
 		if (unlikely(!PageTail(p) |
 				(p->first_page != page)))
 			bad_page(page);
 		__ClearPageTail(p);
 	}
+
+	/*
+	 * The PageHead is important since it determines how operations on
+	 * a compound page have to be performed. We can only tear the head
+	 * down after all the tail pages are done.
+	 */
+	if (unlikely(!PageHead(page)))
+			bad_page(page);
+	__ClearPageHead(page);
 }
 
 static inline void prep_zero_page(struct page *page, int order, gfp_t gfp_flags)
@@ -1230,6 +1238,82 @@ try_next_zone:
 }
 
 /*
+ * Virtual Compound Page support.
+ *
+ * Virtual Compound Pages are used to fall back to order 0 allocations if large
+ * linear mappings are not available and __GFP_VFALLBACK is set. They are
+ * formatted according to compound page conventions. I.e. following
+ * page->first_page if PageTail(page) is set can be used to determine the
+ * head page.
+ */
+static noinline struct page *vcompound_alloc(gfp_t gfp_mask, int order,
+		struct zonelist *zonelist, unsigned long alloc_flags)
+{
+	void *addr;
+	struct page *page;
+	int i;
+	int nr_pages = 1 << order;
+	struct page **pages = kmalloc(nr_pages * sizeof(struct page *),
+						gfp_mask & GFP_LEVEL_MASK);
+
+	if (!pages)
+		return NULL;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = get_page_from_freelist(gfp_mask & ~__GFP_VFALLBACK,
+					0, zonelist, alloc_flags);
+		if (!page)
+			goto abort;
+
+		/* Sets PageCompound which makes PageHead(page) true */
+		__SetPageVcompound(page);
+		pages[i] = page;
+	}
+	addr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!addr)
+		goto abort;
+
+	prep_compound_page(pages[0], order);
+	return pages[0];
+
+abort:
+	while (i-- > 0) {
+		page = pages[i];
+		if (!page)
+			continue;
+		__ClearPageVcompound(page);
+		__free_page(page);
+	}
+	kfree(pages);
+	return NULL;
+}
+
+static void vcompound_free(void *addr)
+{
+	struct page **pages;
+	int i;
+	struct page *page = vmalloc_to_page(addr);
+	int order = compound_order(page);
+	int nr_pages = 1 << order;
+
+	destroy_compound_page(page, order);
+	pages = vunmap(addr);
+	/*
+	 * First page will have zero refcount since it maintains state
+	 * for the compound and was decremented before we got here.
+	 */
+	__ClearPageVcompound(page);
+	free_hot_page(page);
+
+	for (i = 1; i < nr_pages; i++) {
+		page = pages[i];
+		__ClearPageVcompound(page);
+		__free_page(page);
+	}
+	kfree(pages);
+}
+
+/*
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page * fastcall
@@ -1324,12 +1408,12 @@ nofail_alloc:
 				goto nofail_alloc;
 			}
 		}
-		goto nopage;
+		goto try_vcompound;
 	}
 
 	/* Atomic allocations - we can't balance anything */
 	if (!wait)
-		goto nopage;
+		goto try_vcompound;
 
 	cond_resched();
 
@@ -1360,6 +1444,11 @@ nofail_alloc:
 		 */
 		page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
 				zonelist, ALLOC_WMARK_HIGH|ALLOC_CPUSET);
+
+		if (!page && order && (gfp_mask & __GFP_VFALLBACK))
+			page = vcompound_alloc(gfp_mask, order,
+					zonelist, alloc_flags);
+
 		if (page)
 			goto got_pg;
 
@@ -1391,6 +1480,14 @@ nofail_alloc:
 		goto rebalance;
 	}
 
+try_vcompound:
+	/* Last chance before failing the allocation */
+	if (order && (gfp_mask & __GFP_VFALLBACK)) {
+		page = vcompound_alloc(gfp_mask, order,
+					zonelist, alloc_flags);
+		if (page)
+			goto got_pg;
+	}
 nopage:
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
 		printk(KERN_WARNING "%s: page allocation failure."
@@ -1414,7 +1511,7 @@ fastcall unsigned long __get_free_pages(
 	page = alloc_pages(gfp_mask, order);
 	if (!page)
 		return 0;
-	return (unsigned long) page_address(page);
+	return (unsigned long) page_to_addr(page);
 }
 
 EXPORT_SYMBOL(__get_free_pages);
@@ -1431,7 +1528,7 @@ fastcall unsigned long get_zeroed_page(g
 
 	page = alloc_pages(gfp_mask | __GFP_ZERO, 0);
 	if (page)
-		return (unsigned long) page_address(page);
+		return (unsigned long) page_to_addr(page);
 	return 0;
 }
 
@@ -1450,8 +1547,12 @@ fastcall void __free_pages(struct page *
 	if (put_page_testzero(page)) {
 		if (order == 0)
 			free_hot_page(page);
-		else
-			__free_pages_ok(page, order);
+		else {
+			if (unlikely(PageVcompound(page)))
+				vcompound_free(vmalloc_address(page));
+			else
+				__free_pages_ok(page, order);
+		}
 	}
 }
 
@@ -1460,8 +1561,12 @@ EXPORT_SYMBOL(__free_pages);
 fastcall void free_pages(unsigned long addr, unsigned int order)
 {
 	if (addr != 0) {
-		VM_BUG_ON(!virt_addr_valid((void *)addr));
-		__free_pages(virt_to_page((void *)addr), order);
+		if (unlikely(is_vmalloc_addr((void *)addr)))
+			vcompound_free((void *)addr);
+		else {
+			VM_BUG_ON(!virt_addr_valid((void *)addr));
+			__free_pages(virt_to_page((void *)addr), order);
+		}
 	}
 }
 
Index: linux-2.6/include/linux/gfp.h
===================================================================
--- linux-2.6.orig/include/linux/gfp.h	2007-09-25 10:22:16.000000000 -0700
+++ linux-2.6/include/linux/gfp.h	2007-09-25 10:22:36.000000000 -0700
@@ -43,6 +43,7 @@ struct vm_area_struct;
 #define __GFP_REPEAT	((__force gfp_t)0x400u)	/* Retry the allocation.  Might fail */
 #define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* Retry for ever.  Cannot fail */
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* Do not retry.  Might fail */
+#define __GFP_VFALLBACK	((__force gfp_t)0x2000u)/* Permit fallback to vmalloc */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
@@ -86,6 +87,10 @@ struct vm_area_struct;
 #define GFP_THISNODE	((__force gfp_t)0)
 #endif
 
+/*
+ * Allocate large page but allow fallback to a virtually mapped page
+ */
+#define GFP_VFALLBACK	(GFP_KERNEL | __GFP_VFALLBACK)
 
 /* Flag - indicates that the buffer will be suitable for DMA.  Ignored on some
    platforms, used as appropriate on others */
Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2007-09-25 10:22:16.000000000 -0700
+++ linux-2.6/include/linux/page-flags.h	2007-09-25 10:22:36.000000000 -0700
@@ -248,6 +248,24 @@ static inline void __ClearPageTail(struc
 #define __SetPageHead(page)	__SetPageCompound(page)
 #define __ClearPageHead(page)	__ClearPageCompound(page)
 
+/*
+ * PG_swapcache is used in combination with PG_compound to indicate
+ * that a compound page was allocated via vmalloc.
+ */
+#define PG_vcompound_mask ((1L << PG_compound) | (1L << PG_swapcache))
+#define PageVcompound(page)	((page->flags & PG_vcompound_mask) \
+					== PG_vcompound_mask)
+
+static inline void __SetPageVcompound(struct page *page)
+{
+	page->flags |= PG_vcompound_mask;
+}
+
+static inline void __ClearPageVcompound(struct page *page)
+{
+	page->flags &= ~PG_vcompound_mask;
+}
+
 #ifdef CONFIG_SWAP
 #define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
 #define SetPageSwapCache(page)	set_bit(PG_swapcache, &(page)->flags)
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-09-25 10:22:35.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-09-25 10:22:36.000000000 -0700
@@ -297,6 +297,7 @@ static inline int get_page_unless_zero(s
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 void *vmalloc_address(struct page *);
+struct page *vmalloc_nth_page(struct page *page, int n);
 
 /* Determine if an address is within the vmalloc range */
 static inline int is_vmalloc_addr(const void *x)
@@ -306,6 +307,14 @@ static inline int is_vmalloc_addr(const 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 }
 
+static inline struct page *addr_to_page(const void *x)
+{
+
+	if (unlikely(is_vmalloc_addr(x)))
+		return vmalloc_to_page(x);
+	return virt_to_page(x);
+}
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -327,7 +336,7 @@ static inline void get_page(struct page 
 
 static inline struct page *virt_to_head_page(const void *x)
 {
-	struct page *page = virt_to_page(x);
+	struct page *page = addr_to_page(x);
 	return compound_head(page);
 }
 
@@ -352,27 +361,34 @@ void split_page(struct page *page, unsig
  */
 typedef void compound_page_dtor(struct page *);
 
+static inline struct page *compound_nth_page(struct page *page, int n)
+{
+	if (likely(!PageVcompound(page)))
+		return page + n;
+	return vmalloc_nth_page(page, n);
+}
+
 static inline void set_compound_page_dtor(struct page *page,
 						compound_page_dtor *dtor)
 {
-	page[1].lru.next = (void *)dtor;
+	compound_nth_page(page, 1)->lru.next = (void *)dtor;
 }
 
 static inline compound_page_dtor *get_compound_page_dtor(struct page *page)
 {
-	return (compound_page_dtor *)page[1].lru.next;
+	return (compound_page_dtor *)compound_nth_page(page, 1)->lru.next;
 }
 
 static inline int compound_order(struct page *page)
 {
 	if (!PageHead(page))
 		return 0;
-	return (unsigned long)page[1].lru.prev;
+	return (unsigned long)compound_nth_page(page, 1)->lru.prev;
 }
 
 static inline void set_compound_order(struct page *page, unsigned long order)
 {
-	page[1].lru.prev = (void *)order;
+	compound_nth_page(page, 1)->lru.prev = (void *)order;
 }
 
 /*
@@ -624,6 +640,13 @@ void page_address_init(void);
 #define page_address_init()  do { } while(0)
 #endif
 
+static inline void *page_to_addr(struct page *page)
+{
+	if (unlikely(PageVcompound(page)))
+		return vmalloc_address(page);
+	return page_address(page);
+}
+
 /*
  * On an anonymous page mapped into a user virtual memory area,
  * page->mapping points to its anon_vma, not to a struct address_space;
Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-25 10:22:35.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-25 10:22:38.000000000 -0700
@@ -657,6 +657,16 @@ void *vmalloc(unsigned long size)
 }
 EXPORT_SYMBOL(vmalloc);
 
+/*
+ * Given a pointer to the first page struct:
+ * Determine a pointer to the nth page.
+ */
+struct page *vmalloc_nth_page(struct page *page, int n)
+{
+	return vmalloc_to_page(vmalloc_address(page) + n * PAGE_SIZE);
+}
+EXPORT_SYMBOL(vmalloc_nth_page);
+
 /**
  * vmalloc_user - allocate zeroed virtually contiguous memory for userspace
  * @size: allocation size

-- 

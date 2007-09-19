Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXISDmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXISDmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXISDhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:37:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53648 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752273AbXISDgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:45 -0400
Message-Id: <20070919033641.933657553@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:12 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [07/17] GFP_VFALLBACK: Allow fallback of compound pages to virtual mappings
Content-Disposition: inline; filename=vcompound_core
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new gfp flag

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

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/gfp.h        |    5 +
 include/linux/page-flags.h |   18 +++++++
 mm/page_alloc.c            |  113 ++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 130 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-18 17:03:54.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-18 18:25:46.000000000 -0700
@@ -1230,6 +1230,86 @@ try_next_zone:
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
+struct page *vcompound_alloc(gfp_t gfp_mask, int order,
+		struct zonelist *zonelist, unsigned long alloc_flags)
+{
+	void *addr;
+	struct page *page;
+	int i;
+	int nr_pages = 1 << order;
+	struct page **pages = kzalloc((nr_pages + 1) * sizeof(struct page *),
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
+		if (i) {
+			page->first_page = pages[0];
+			__SetPageTail(page);
+		}
+		pages[i] = page;
+	}
+
+	addr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!addr)
+		goto abort;
+
+	return pages[0];
+
+abort:
+	for (i = 0; i < nr_pages; i++) {
+		page = pages[i];
+		if (!page)
+			continue;
+		__ClearPageTail(page);
+		__ClearPageHead(page);
+		__ClearPageVcompound(page);
+		__free_page(page);
+	}
+	kfree(pages);
+	return NULL;
+}
+
+static void vcompound_free(void *addr)
+{
+	struct page **pages = vunmap(addr);
+	int i;
+
+	/*
+	 * First page will have zero refcount since it maintains state
+	 * for the compound and was decremented before we got here.
+	 */
+	__ClearPageHead(pages[0]);
+	__ClearPageVcompound(pages[0]);
+	free_hot_page(pages[0]);
+
+	for (i = 1; pages[i]; i++) {
+		struct page *page = pages[i];
+
+		__ClearPageTail(page);
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
@@ -1324,12 +1404,12 @@ nofail_alloc:
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
 
@@ -1360,6 +1440,11 @@ nofail_alloc:
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
 
@@ -1391,6 +1476,14 @@ nofail_alloc:
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
@@ -1450,8 +1543,12 @@ fastcall void __free_pages(struct page *
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
 
@@ -1460,8 +1557,12 @@ EXPORT_SYMBOL(__free_pages);
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
--- linux-2.6.orig/include/linux/gfp.h	2007-09-18 17:03:54.000000000 -0700
+++ linux-2.6/include/linux/gfp.h	2007-09-18 17:03:58.000000000 -0700
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
--- linux-2.6.orig/include/linux/page-flags.h	2007-09-18 17:03:54.000000000 -0700
+++ linux-2.6/include/linux/page-flags.h	2007-09-18 17:03:58.000000000 -0700
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

-- 

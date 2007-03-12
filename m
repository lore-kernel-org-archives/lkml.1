Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXCLVTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXCLVTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXCLVTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:19:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbXCLVTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:19:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] swsusp: Use inline functions for changing page flags
Date: Mon, 12 Mar 2007 22:16:49 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703122214.02657.rjw@sisk.pl>
In-Reply-To: <200703122214.02657.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122216.50312.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Replace direct invocations of SetPageNosave(), SetPageNosaveFree() etc. with
calls to inline functions that can be changed in subsequent patches without
modifying the code calling them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 include/linux/suspend.h |   33 +++++++++++++++++++++++++++++++++
 kernel/power/snapshot.c |   48 +++++++++++++++++++++++++-----------------------
 mm/page_alloc.c         |    6 +++---
 3 files changed, 61 insertions(+), 26 deletions(-)

Index: linux-2.6.21-rc2/include/linux/suspend.h
===================================================================
--- linux-2.6.21-rc2.orig/include/linux/suspend.h	2007-03-02 09:05:53.000000000 +0100
+++ linux-2.6.21-rc2/include/linux/suspend.h	2007-03-02 09:24:02.000000000 +0100
@@ -8,6 +8,7 @@
 #include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/pm.h>
+#include <linux/mm.h>
 
 /* struct pbe is used for creating lists of pages that should be restored
  * atomically during the resume from disk, because the page frames they have
@@ -49,6 +50,38 @@ void __save_processor_state(struct saved
 void __restore_processor_state(struct saved_context *ctxt);
 unsigned long get_safe_page(gfp_t gfp_mask);
 
+/* Page management functions for the software suspend (swsusp) */
+
+static inline void swsusp_set_page_forbidden(struct page *page)
+{
+	SetPageNosave(page);
+}
+
+static inline int swsusp_page_is_forbidden(struct page *page)
+{
+	return PageNosave(page);
+}
+
+static inline void swsusp_unset_page_forbidden(struct page *page)
+{
+	ClearPageNosave(page);
+}
+
+static inline void swsusp_set_page_free(struct page *page)
+{
+	SetPageNosaveFree(page);
+}
+
+static inline int swsusp_page_is_free(struct page *page)
+{
+	return PageNosaveFree(page);
+}
+
+static inline void swsusp_unset_page_free(struct page *page)
+{
+	ClearPageNosaveFree(page);
+}
+
 /*
  * XXX: We try to keep some more pages free so that I/O operations succeed
  * without paging. Might this be more?
Index: linux-2.6.21-rc2/kernel/power/snapshot.c
===================================================================
--- linux-2.6.21-rc2.orig/kernel/power/snapshot.c	2007-03-02 09:05:53.000000000 +0100
+++ linux-2.6.21-rc2/kernel/power/snapshot.c	2007-03-02 09:27:06.000000000 +0100
@@ -67,15 +67,15 @@ static void *get_image_page(gfp_t gfp_ma
 
 	res = (void *)get_zeroed_page(gfp_mask);
 	if (safe_needed)
-		while (res && PageNosaveFree(virt_to_page(res))) {
+		while (res && swsusp_page_is_free(virt_to_page(res))) {
 			/* The page is unsafe, mark it for swsusp_free() */
-			SetPageNosave(virt_to_page(res));
+			swsusp_set_page_forbidden(virt_to_page(res));
 			allocated_unsafe_pages++;
 			res = (void *)get_zeroed_page(gfp_mask);
 		}
 	if (res) {
-		SetPageNosave(virt_to_page(res));
-		SetPageNosaveFree(virt_to_page(res));
+		swsusp_set_page_forbidden(virt_to_page(res));
+		swsusp_set_page_free(virt_to_page(res));
 	}
 	return res;
 }
@@ -91,8 +91,8 @@ static struct page *alloc_image_page(gfp
 
 	page = alloc_page(gfp_mask);
 	if (page) {
-		SetPageNosave(page);
-		SetPageNosaveFree(page);
+		swsusp_set_page_forbidden(page);
+		swsusp_set_page_free(page);
 	}
 	return page;
 }
@@ -110,9 +110,9 @@ static inline void free_image_page(void 
 
 	page = virt_to_page(addr);
 
-	ClearPageNosave(page);
+	swsusp_unset_page_forbidden(page);
 	if (clear_nosave_free)
-		ClearPageNosaveFree(page);
+		swsusp_unset_page_free(page);
 
 	__free_page(page);
 }
@@ -615,7 +615,8 @@ static struct page *saveable_highmem_pag
 
 	BUG_ON(!PageHighMem(page));
 
-	if (PageNosave(page) || PageReserved(page) || PageNosaveFree(page))
+	if (swsusp_page_is_forbidden(page) ||  swsusp_page_is_free(page) ||
+	    PageReserved(page))
 		return NULL;
 
 	return page;
@@ -681,7 +682,7 @@ static struct page *saveable_page(unsign
 
 	BUG_ON(PageHighMem(page));
 
-	if (PageNosave(page) || PageNosaveFree(page))
+	if (swsusp_page_is_forbidden(page) || swsusp_page_is_free(page))
 		return NULL;
 
 	if (PageReserved(page) && pfn_is_nosave(pfn))
@@ -821,9 +822,10 @@ void swsusp_free(void)
 			if (pfn_valid(pfn)) {
 				struct page *page = pfn_to_page(pfn);
 
-				if (PageNosave(page) && PageNosaveFree(page)) {
-					ClearPageNosave(page);
-					ClearPageNosaveFree(page);
+				if (swsusp_page_is_forbidden(page) &&
+				    swsusp_page_is_free(page)) {
+					swsusp_unset_page_forbidden(page);
+					swsusp_unset_page_free(page);
 					__free_page(page);
 				}
 			}
@@ -1146,7 +1148,7 @@ static int mark_unsafe_pages(struct memo
 		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 			if (pfn_valid(pfn))
-				ClearPageNosaveFree(pfn_to_page(pfn));
+				swsusp_unset_page_free(pfn_to_page(pfn));
 	}
 
 	/* Mark pages that correspond to the "original" pfns as "unsafe" */
@@ -1155,7 +1157,7 @@ static int mark_unsafe_pages(struct memo
 		pfn = memory_bm_next_pfn(bm);
 		if (likely(pfn != BM_END_OF_MAP)) {
 			if (likely(pfn_valid(pfn)))
-				SetPageNosaveFree(pfn_to_page(pfn));
+				swsusp_set_page_free(pfn_to_page(pfn));
 			else
 				return -EFAULT;
 		}
@@ -1321,14 +1323,14 @@ prepare_highmem_image(struct memory_bitm
 		struct page *page;
 
 		page = alloc_page(__GFP_HIGHMEM);
-		if (!PageNosaveFree(page)) {
+		if (!swsusp_page_is_free(page)) {
 			/* The page is "safe", set its bit the bitmap */
 			memory_bm_set_bit(bm, page_to_pfn(page));
 			safe_highmem_pages++;
 		}
 		/* Mark the page as allocated */
-		SetPageNosave(page);
-		SetPageNosaveFree(page);
+		swsusp_set_page_forbidden(page);
+		swsusp_set_page_free(page);
 	}
 	memory_bm_position_reset(bm);
 	safe_highmem_bm = bm;
@@ -1360,7 +1362,7 @@ get_highmem_page_buffer(struct page *pag
 	struct highmem_pbe *pbe;
 	void *kaddr;
 
-	if (PageNosave(page) && PageNosaveFree(page)) {
+	if (swsusp_page_is_forbidden(page) && swsusp_page_is_free(page)) {
 		/* We have allocated the "original" page frame and we can
 		 * use it directly to store the loaded page.
 		 */
@@ -1522,14 +1524,14 @@ prepare_image(struct memory_bitmap *new_
 			error = -ENOMEM;
 			goto Free;
 		}
-		if (!PageNosaveFree(virt_to_page(lp))) {
+		if (!swsusp_page_is_free(virt_to_page(lp))) {
 			/* The page is "safe", add it to the list */
 			lp->next = safe_pages_list;
 			safe_pages_list = lp;
 		}
 		/* Mark the page as allocated */
-		SetPageNosave(virt_to_page(lp));
-		SetPageNosaveFree(virt_to_page(lp));
+		swsusp_set_page_forbidden(virt_to_page(lp));
+		swsusp_set_page_free(virt_to_page(lp));
 		nr_pages--;
 	}
 	/* Free the reserved safe pages so that chain_alloc() can use them */
@@ -1558,7 +1560,7 @@ static void *get_buffer(struct memory_bi
 	if (PageHighMem(page))
 		return get_highmem_page_buffer(page, ca);
 
-	if (PageNosave(page) && PageNosaveFree(page))
+	if (swsusp_page_is_forbidden(page) && swsusp_page_is_free(page))
 		/* We have allocated the "original" page frame and we can
 		 * use it directly to store the loaded page.
 		 */
Index: linux-2.6.21-rc2/mm/page_alloc.c
===================================================================
--- linux-2.6.21-rc2.orig/mm/page_alloc.c	2007-03-02 09:03:43.000000000 +0100
+++ linux-2.6.21-rc2/mm/page_alloc.c	2007-03-02 09:11:54.000000000 +0100
@@ -770,8 +770,8 @@ void mark_free_pages(struct zone *zone)
 		if (pfn_valid(pfn)) {
 			struct page *page = pfn_to_page(pfn);
 
-			if (!PageNosave(page))
-				ClearPageNosaveFree(page);
+			if (!swsusp_page_is_forbidden(page))
+				swsusp_unset_page_free(page);
 		}
 
 	for (order = MAX_ORDER - 1; order >= 0; --order)
@@ -780,7 +780,7 @@ void mark_free_pages(struct zone *zone)
 
 			pfn = page_to_pfn(list_entry(curr, struct page, lru));
 			for (i = 0; i < (1UL << order); i++)
-				SetPageNosaveFree(pfn_to_page(pfn + i));
+				swsusp_set_page_free(pfn_to_page(pfn + i));
 		}
 
 	spin_unlock_irqrestore(&zone->lock, flags);


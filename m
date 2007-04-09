Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbXDIWFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbXDIWFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXDIWFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:05:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44851 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753541AbXDIWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:05:51 -0400
Date: Mon, 9 Apr 2007 15:05:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
In-Reply-To: <20070409114545.3858d8f1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704091505050.2836@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
 <20070406222336.4dcdd663.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
 <20070407155148.94da92e8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
 <20070407182506.4386dc13.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071825510.32544@schroedinger.engr.sgi.com>
 <20070407184801.b6f3f549.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704091105550.8331@schroedinger.engr.sgi.com>
 <20070409114545.3858d8f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another rev on that one. Inlined the two functions but that
required #including <mm_types.h>


Add PageTail / PageHead in order to avoid multiple branches when compound
pages are checked.

The patch adds PageTail(page) and PageHead(page) to check if a page is the
head or the tail of a compound page. This is done by masking the two
bits describing the state of a compound page and then comparing them. So
one comparision and a branch instead of two bit checks and two branches.

---
 include/linux/mm.h         |   11 ++---------
 include/linux/page-flags.h |   28 +++++++++++++++++-----------
 mm/page_alloc.c            |   10 ++++------
 3 files changed, 23 insertions(+), 26 deletions(-)

Index: linux-2.6.21-rc6-mm1/include/linux/mm.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/include/linux/mm.h	2007-04-09 12:08:33.000000000 -0700
+++ linux-2.6.21-rc6-mm1/include/linux/mm.h	2007-04-09 12:09:50.000000000 -0700
@@ -299,14 +299,7 @@ static inline int get_page_unless_zero(s
 
 static inline struct page *compound_head(struct page *page)
 {
-	/*
-	 * We could avoid the PageCompound(page) check if
-	 * we would not overload PageTail().
-	 *
-	 * This check has to be done in several performance critical
-	 * paths of the slab etc. IMHO PageTail deserves its own flag.
-	 */
-	if (unlikely(PageCompound(page) && PageTail(page)))
+	if (unlikely(PageTail(page)))
 		return page->first_page;
 	return page;
 }
@@ -363,7 +356,7 @@ static inline compound_page_dtor *get_co
 
 static inline int compound_order(struct page *page)
 {
-	if (!PageCompound(page) || PageTail(page))
+	if (!PageHead(page))
 		return 0;
 	return (unsigned long)page[1].lru.prev;
 }
Index: linux-2.6.21-rc6-mm1/include/linux/page-flags.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/include/linux/page-flags.h	2007-04-09 12:08:33.000000000 -0700
+++ linux-2.6.21-rc6-mm1/include/linux/page-flags.h	2007-04-09 12:13:36.000000000 -0700
@@ -6,6 +6,7 @@
 #define PAGE_FLAGS_H
 
 #include <linux/types.h>
+#include <linux/mm_types.h>
 
 /*
  * Various page->flags bits:
@@ -95,12 +96,6 @@
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
-/*
- * Marks tail portion of a compound page. We currently do not reclaim
- * compound pages so we can reuse a flag only used for reclaim here.
- */
-#define PG_tail			PG_reclaim
-
 #if (BITS_PER_LONG > 32)
 /*
  * 64-bit-only flags build down from bit 31
@@ -221,12 +216,32 @@ static inline void SetPageUptodate(struc
 #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
 
 /*
- * Note: PG_tail is an alias of another page flag. The result of PageTail()
- * is only valid if PageCompound(page) is true.
+ * PG_reclaim is used in combination with PG_compound to mark the
+ * head and tail of a compound page
+ *
+ * PG_compound & PG_reclaim	=> Tail page
+ * PG_compound & ~PG_reclaim	=> Head page
  */
-#define PageTail(page)	test_bit(PG_tail, &(page)->flags)
-#define __SetPageTail(page)	__set_bit(PG_tail, &(page)->flags)
-#define __ClearPageTail(page)	__clear_bit(PG_tail, &(page)->flags)
+
+#define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
+
+#define PageTail(page)	((page->flags & PG_head_tail_mask) \
+				== PG_head_tail_mask)
+
+static inline void __SetPageTail(struct page *page)
+{
+	page->flags |= PG_head_tail_mask;
+}
+
+static inline void __ClearPageTail(struct page *page)
+{
+	page->flags &= ~PG_head_tail_mask;
+}
+
+#define PageHead(page)	((page->flags & PG_head_tail_mask) \
+				== (1L << PG_compound))
+#define __SetPageHead(page)	__SetPageCompound(page)
+#define __ClearPageHead(page)	__ClearPageCompound(page)
 
 #ifdef CONFIG_SWAP
 #define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
Index: linux-2.6.21-rc6-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/mm/page_alloc.c	2007-04-09 12:08:33.000000000 -0700
+++ linux-2.6.21-rc6-mm1/mm/page_alloc.c	2007-04-09 12:09:50.000000000 -0700
@@ -300,12 +300,11 @@ static void prep_compound_page(struct pa
 
 	set_compound_page_dtor(page, free_compound_page);
 	set_compound_order(page, order);
-	__SetPageCompound(page);
+	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
 		__SetPageTail(p);
-		__SetPageCompound(p);
 		p->first_page = page;
 	}
 }
@@ -318,17 +317,16 @@ static void destroy_compound_page(struct
 	if (unlikely(compound_order(page) != order))
 		bad_page(page);
 
-	if (unlikely(!PageCompound(page)))
+	if (unlikely(!PageHead(page)))
 			bad_page(page);
-	__ClearPageCompound(page);
+	__ClearPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
-		if (unlikely(!PageCompound(p) | !PageTail(p) |
+		if (unlikely(!PageTail(p) |
 				(p->first_page != page)))
 			bad_page(page);
 		__ClearPageTail(p);
-		__ClearPageCompound(p);
 	}
 }
 


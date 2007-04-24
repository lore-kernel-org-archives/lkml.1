Return-Path: <linux-kernel-owner+w=401wt.eu-S1423171AbXDXWY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423171AbXDXWY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423167AbXDXWXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43903 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423171AbXDXWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:06 -0400
Message-Id: <20070424222305.352245592@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:09 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [04/17] Free up page->private for compound pages
Content-Disposition: inline; filename=var_pc_compound
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we add a new flag so that we can distinguish between the
first page and the tail pages then we can avoid to use page->private
in the first page. page->private == page for the first page, so there
is no real information in there.

Freeing up page->private makes the use of compound pages more transparent.
They become more usable like real pages. Right now we have to be careful f.e.
if we are going beyond PAGE_SIZE allocations in the slab on i386 because we
can then no longer use the private field. This is one of the issues that
cause us not to support debugging for page size slabs in SLAB.

Also if page->private is available then a compound page may be equipped
with buffer heads. This may free up the way for filesystems to support
larger blocks than page size.

Note that this patch is different from the one in mm. The one in mm
uses PG_reclaim as a PG_tail. We cannot use PG_tail here since pages can
be reclaimed now. So use a separate page flag. The patch in mm
has more cleanups. Both need to be reconciled at some point.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/ia64/mm/init.c        |    2 +-
 include/linux/mm.h         |   28 ++++++++++++++++++++++------
 include/linux/page-flags.h |    6 ++++++
 mm/internal.h              |    2 +-
 mm/page_alloc.c            |   35 +++++++++++++++++++++++++----------
 mm/slab.c                  |    6 ++----
 mm/swap.c                  |    2 +-
 7 files changed, 58 insertions(+), 23 deletions(-)

Index: linux-2.6.21-rc7/include/linux/mm.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/mm.h	2007-04-24 11:31:51.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/mm.h	2007-04-24 11:32:45.000000000 -0700
@@ -263,21 +263,24 @@ static inline int put_page_testzero(stru
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page));
 	return atomic_inc_not_zero(&page->_count);
 }
 
+static inline struct page *compound_head(struct page *page)
+{
+	if (unlikely(PageTail(page)))
+		return (struct page *)page->private;
+	return page;
+}
+
 static inline int page_count(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		page = (struct page *)page_private(page);
-	return atomic_read(&page->_count);
+	return atomic_read(&compound_head(page)->_count);
 }
 
 static inline void get_page(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		page = (struct page *)page_private(page);
+	page = compound_head(page);
 	VM_BUG_ON(atomic_read(&page->_count) == 0);
 	atomic_inc(&page->_count);
 }
@@ -314,6 +317,19 @@ static inline compound_page_dtor *get_co
 	return (compound_page_dtor *)page[1].lru.next;
 }
 
+static inline void set_compound_order(struct page *page, unsigned long order)
+{
+	page[1].lru.prev = (void *)order;
+}
+
+static inline int compound_order(struct page *page)
+{
+	if (!PageCompound(page) || PageTail(page))
+		return 0;
+
+	return (unsigned long)page[1].lru.prev;
+}
+
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
Index: linux-2.6.21-rc7/include/linux/page-flags.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/page-flags.h	2007-04-24 11:31:51.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/page-flags.h	2007-04-24 11:32:00.000000000 -0700
@@ -91,6 +91,8 @@
 #define PG_nosave_free		18	/* Used for system suspend/resume */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
+#define PG_tail			20	/* Page is tail of a compound page */
+
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
@@ -241,6 +243,10 @@ static inline void SetPageUptodate(struc
 #define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
 #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
 
+#define PageTail(page)	test_bit(PG_tail, &(page)->flags)
+#define __SetPageTail(page)	__set_bit(PG_tail, &(page)->flags)
+#define __ClearPageTail(page)	__clear_bit(PG_tail, &(page)->flags)
+
 #ifdef CONFIG_SWAP
 #define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
 #define SetPageSwapCache(page)	set_bit(PG_swapcache, &(page)->flags)
Index: linux-2.6.21-rc7/mm/internal.h
===================================================================
--- linux-2.6.21-rc7.orig/mm/internal.h	2007-04-24 11:31:51.000000000 -0700
+++ linux-2.6.21-rc7/mm/internal.h	2007-04-24 11:32:00.000000000 -0700
@@ -24,7 +24,7 @@ static inline void set_page_count(struct
  */
 static inline void set_page_refcounted(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page) && page_private(page) != (unsigned long)page);
+	VM_BUG_ON(PageTail(page));
 	VM_BUG_ON(atomic_read(&page->_count));
 	set_page_count(page, 1);
 }
Index: linux-2.6.21-rc7/mm/page_alloc.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/page_alloc.c	2007-04-24 11:31:51.000000000 -0700
+++ linux-2.6.21-rc7/mm/page_alloc.c	2007-04-24 11:32:00.000000000 -0700
@@ -227,7 +227,7 @@ static void bad_page(struct page *page)
 
 static void free_compound_page(struct page *page)
 {
-	__free_pages_ok(page, (unsigned long)page[1].lru.prev);
+	__free_pages_ok(page, compound_order(page));
 }
 
 static void prep_compound_page(struct page *page, unsigned long order)
@@ -236,12 +236,14 @@ static void prep_compound_page(struct pa
 	int nr_pages = 1 << order;
 
 	set_compound_page_dtor(page, free_compound_page);
-	page[1].lru.prev = (void *)order;
-	for (i = 0; i < nr_pages; i++) {
+	set_compound_order(page, order);
+	__SetPageCompound(page);
+	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
+		__SetPageTail(p);
 		__SetPageCompound(p);
-		set_page_private(p, (unsigned long)page);
+		p->private = (unsigned long)page;
 	}
 }
 
@@ -250,15 +252,19 @@ static void destroy_compound_page(struct
 	int i;
 	int nr_pages = 1 << order;
 
-	if (unlikely((unsigned long)page[1].lru.prev != order))
+	if (unlikely(compound_order(page) != order))
 		bad_page(page);
 
-	for (i = 0; i < nr_pages; i++) {
+	if (unlikely(!PageCompound(page)))
+			bad_page(page);
+	__ClearPageCompound(page);
+	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
-		if (unlikely(!PageCompound(p) |
-				(page_private(p) != (unsigned long)page)))
+		if (unlikely(!PageCompound(p) | !PageTail(p) |
+				((struct page *)p->private != page)))
 			bad_page(page);
+		__ClearPageTail(p);
 		__ClearPageCompound(p);
 	}
 }
@@ -1438,8 +1444,17 @@ void __pagevec_free(struct pagevec *pvec
 {
 	int i = pagevec_count(pvec);
 
-	while (--i >= 0)
-		free_hot_cold_page(pvec->pages[i], pvec->cold);
+	while (--i >= 0) {
+		struct page *page = pvec->pages[i];
+
+		if (PageCompound(page)) {
+			compound_page_dtor *dtor;
+
+			dtor = get_compound_page_dtor(page);
+			(*dtor)(page);
+		} else
+			free_hot_cold_page(page, pvec->cold);
+	}
 }
 
 fastcall void __free_pages(struct page *page, unsigned int order)
Index: linux-2.6.21-rc7/mm/slab.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/slab.c	2007-04-24 11:31:51.000000000 -0700
+++ linux-2.6.21-rc7/mm/slab.c	2007-04-24 11:32:00.000000000 -0700
@@ -592,8 +592,7 @@ static inline void page_set_cache(struct
 
 static inline struct kmem_cache *page_get_cache(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		page = (struct page *)page_private(page);
+	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return (struct kmem_cache *)page->lru.next;
 }
@@ -605,8 +604,7 @@ static inline void page_set_slab(struct 
 
 static inline struct slab *page_get_slab(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		page = (struct page *)page_private(page);
+	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return (struct slab *)page->lru.prev;
 }
Index: linux-2.6.21-rc7/mm/swap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/swap.c	2007-04-24 11:31:51.000000000 -0700
+++ linux-2.6.21-rc7/mm/swap.c	2007-04-24 11:32:00.000000000 -0700
@@ -55,7 +55,7 @@ static void fastcall __page_cache_releas
 
 static void put_compound_page(struct page *page)
 {
-	page = (struct page *)page_private(page);
+	page = compound_head(page);
 	if (put_page_testzero(page)) {
 		compound_page_dtor *dtor;
 
Index: linux-2.6.21-rc7/arch/ia64/mm/init.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ia64/mm/init.c	2007-04-24 11:31:51.000000000 -0700
+++ linux-2.6.21-rc7/arch/ia64/mm/init.c	2007-04-24 11:32:00.000000000 -0700
@@ -121,7 +121,7 @@ lazy_mmu_prot_update (pte_t pte)
 		return;				/* i-cache is already coherent with d-cache */
 
 	if (PageCompound(page)) {
-		order = (unsigned long) (page[1].lru.prev);
+		order = compound_order(page);
 		flush_icache_range(addr, addr + (1UL << order << PAGE_SHIFT));
 	}
 	else

--

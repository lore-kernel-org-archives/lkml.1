Return-Path: <linux-kernel-owner+w=401wt.eu-S1762587AbXFTSlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762587AbXFTSlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXFTSbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46751 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757748AbXFTSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:13 -0400
Message-Id: <20070620183011.339038856@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:30 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [23/37] compound pages: PageHead/PageTail instead of PageCompound
Content-Disposition: inline; filename=compound_headtail
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances the handling of compound pages in the VM. It may also
be important also for the antifrag patches that need to manage a set of
higher order free pages and also for other uses of compound pages.

For now it simplifies accounting for SLUB pages but the groundwork here is
important for the large block size patches and for allowing to page migration
of larger pages. With this framework we may be able to get to a point where
compound pages keep their flags while they are free and Mel may avoid having
special functions for determining the page order of higher order freed pages.
If we can avoid the setup and teardown of higher order pages then allocation
and release of compound pages will be faster.

Looking at the handling of compound pages we see that the fact that a page
is part of a higher order page is not that interesting. The differentiation
is mainly for head pages and tail pages of higher order pages. Head pages
usually need special handling to accomodate the larger size. It is usually
an error if tail pages are encountered. Or else they need to be treated
like PAGE_SIZE pages. So a compound flag in the page flags is not what we
need. Instead we introduce a flag for the head page and another for the tail
page. The PageCompound test is preserved for backward compatibility and
will test if either PageTail or PageHead has been set.

After this patchset the uses of CompoundPage() will be reduced significantly
in the core VM. The I/O layer will still use CompoundPage() for direct I/O.
However, if we at some point convert direct I/O to also support compound
pages as a single unit then CompoundPage() there may become unecessary as
well as the leftover check in mm/swap.c. We may end up mostly with checks
for PageTail and PageHead.

This patch:

Use two separate page flags for the head and tail of compound pages.
PageHead() and PageTail() become more efficient.

PageCompound then becomes a check for PageTail || PageHead. Over time
it is expected that PageCompound will mostly go away since the head page
processing will be different from tail page processing is most situations.

We can remove the compound page check from set_page_refcounted since
PG_reclaim is no longer overloaded.

Also the check in _free_one_page can only be for PageHead. We cannot
free a tail page.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/page-flags.h |   43 ++++++++++++-------------------------------
 mm/internal.h              |    2 +-
 mm/page_alloc.c            |    2 +-
 3 files changed, 14 insertions(+), 33 deletions(-)

Index: linux-2.6.22-rc4-mm2/include/linux/page-flags.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/page-flags.h	2007-06-15 17:35:33.000000000 -0700
+++ linux-2.6.22-rc4-mm2/include/linux/page-flags.h	2007-06-18 19:13:03.000000000 -0700
@@ -83,7 +83,6 @@
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
-#define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
 #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
@@ -91,6 +90,9 @@
 #define PG_buddy		19	/* Page is free, on buddy lists */
 #define PG_booked		20	/* Has blocks reserved on-disk */
 
+#define PG_head			21	/* Page is head of a compound page */
+#define PG_tail			22	/* Page is tail of a compound page */
+
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
 #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
 
@@ -221,37 +223,16 @@ static inline void SetPageUptodate(struc
 #define ClearPageReclaim(page)	clear_bit(PG_reclaim, &(page)->flags)
 #define TestClearPageReclaim(page) test_and_clear_bit(PG_reclaim, &(page)->flags)
 
-#define PageCompound(page)	test_bit(PG_compound, &(page)->flags)
-#define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
-#define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
-
-/*
- * PG_reclaim is used in combination with PG_compound to mark the
- * head and tail of a compound page
- *
- * PG_compound & PG_reclaim	=> Tail page
- * PG_compound & ~PG_reclaim	=> Head page
- */
-
-#define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
-
-#define PageTail(page)	((page->flags & PG_head_tail_mask) \
-				== PG_head_tail_mask)
-
-static inline void __SetPageTail(struct page *page)
-{
-	page->flags |= PG_head_tail_mask;
-}
-
-static inline void __ClearPageTail(struct page *page)
-{
-	page->flags &= ~PG_head_tail_mask;
-}
+#define PageHead(page)		test_bit(PG_head, &(page)->flags)
+#define __SetPageHead(page)	__set_bit(PG_head, &(page)->flags)
+#define __ClearPageHead(page)	__clear_bit(PG_head, &(page)->flags)
+
+#define PageTail(page)		test_bit(PG_tail, &(page->flags))
+#define __SetPageTail(page)	__set_bit(PG_tail, &(page)->flags)
+#define __ClearPageTail(page)	__clear_bit(PG_tail, &(page)->flags)
 
-#define PageHead(page)	((page->flags & PG_head_tail_mask) \
-				== (1L << PG_compound))
-#define __SetPageHead(page)	__SetPageCompound(page)
-#define __ClearPageHead(page)	__ClearPageCompound(page)
+#define PageCompound(page)	((page)->flags & \
+				((1L << PG_head) | (1L << PG_tail)))
 
 #ifdef CONFIG_SWAP
 #define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
Index: linux-2.6.22-rc4-mm2/mm/internal.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/internal.h	2007-06-15 17:35:33.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/internal.h	2007-06-18 19:13:03.000000000 -0700
@@ -24,7 +24,7 @@ static inline void set_page_count(struct
  */
 static inline void set_page_refcounted(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page) && PageTail(page));
+	VM_BUG_ON(PageTail(page));
 	VM_BUG_ON(atomic_read(&page->_count));
 	set_page_count(page, 1);
 }
Index: linux-2.6.22-rc4-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/page_alloc.c	2007-06-18 18:42:45.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/page_alloc.c	2007-06-18 19:13:03.000000000 -0700
@@ -428,7 +428,7 @@ static inline void __free_one_page(struc
 	int order_size = 1 << order;
 	int migratetype = get_pageblock_migratetype(page);
 
-	if (unlikely(PageCompound(page)))
+	if (unlikely(PageHead(page)))
 		destroy_compound_page(page, order);
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);

-- 

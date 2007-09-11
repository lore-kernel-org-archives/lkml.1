Return-Path: <linux-kernel-owner+w=401wt.eu-S1762532AbXIKGM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762532AbXIKGM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762440AbXIKGFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:05:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56499 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761238AbXIKGEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:32 -0400
Message-Id: <20070911060430.177939231@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:11 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [21/41] compound pages: Better PageHead/PageTail handling
Content-Disposition: inline; filename=0021-compound-pages-PageHead-PageTail-instead-of-PageCom.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the handling of compound pages we see that the fact that a page
is part of a higher order page is not that interesting. The differentiation
is mainly for head pages and tail pages of higher order pages. Head pages
keep the page state and it is usually sufficient to pass a pointer to
a head page. It is usually an error if tail pages are encountered. Or they
may need to be treated like PAGE_SIZE pages. So a compound flag in the page
flags is not what we need. Instead we introduce a flag for the head page and
another for the tail page. The PageCompound test is preserved for backward
compatibility and will test if either PageTail or PageHead has been set.

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

Also the check for a compound page  in __free_one_page() can be changed to
check only for PageHead. We can never free a tail page since it is a part
of a compound page that is handled through the PageHead.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/page-flags.h |   41 +++++++++++------------------------------
 mm/internal.h              |    2 +-
 mm/page_alloc.c            |    2 +-
 3 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 209d3a4..2786693 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -83,13 +83,15 @@
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
-#define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
 #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
 #define PG_reclaim		17	/* To be reclaimed asap */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
+#define PG_head			21	/* Page is head of a compound page */
+#define PG_tail			22	/* Page is tail of a compound page */
+
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
 #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
 
@@ -216,37 +218,16 @@ static inline void SetPageUptodate(struct page *page)
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
+#define PageHead(page)		test_bit(PG_head, &(page)->flags)
+#define __SetPageHead(page)	__set_bit(PG_head, &(page)->flags)
+#define __ClearPageHead(page)	__clear_bit(PG_head, &(page)->flags)
 
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
diff --git a/mm/internal.h b/mm/internal.h
index a3110c0..c79791c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,7 +24,7 @@ static inline void set_page_count(struct page *page, int v)
  */
 static inline void set_page_refcounted(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page) && PageTail(page));
+	VM_BUG_ON(PageTail(page));
 	VM_BUG_ON(atomic_read(&page->_count));
 	set_page_count(page, 1);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6427653..5c256ee 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -405,7 +405,7 @@ static inline void __free_one_page(struct page *page,
 	unsigned long page_idx;
 	int order_size = 1 << order;
 
-	if (unlikely(PageCompound(page)))
+	if (unlikely(PageHead(page)))
 		destroy_compound_page(page, order);
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
-- 
1.5.2.5

-- 

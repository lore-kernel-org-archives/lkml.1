Return-Path: <linux-kernel-owner+w=401wt.eu-S1763491AbXFTSod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763491AbXFTSod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759164AbXFTSbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54798 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757880AbXFTSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:13 -0400
Message-Id: <20070620183012.519569470@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:35 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [28/37] compound pages: Allow freeing of compound pages via pagevec
Content-Disposition: inline; filename=compound_free_via_pagevec
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the freeing of compound pages via pagevec.

In release_pages() we currently special case for compound pages in order to
be sure to always decrement the page count of the head page and not the
tail page. However that redirection to the head page is only necessary for
tail pages. So use PageTail instead of PageCompound. No change therefore
for the handling of tail pages.

The head page of a compound pages now represents single page large page.
We do the usual processing including checking if its on the LRU
and removing it (not useful right now but later when compound pages are
on the LRU this will work). Then we add the compound page to the pagevec.
Only head pages will end up on the pagevec not tail pages.

In __pagevec_free() we then check if we are freeing a head page and if
so call the destructor for the compound page.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |   13 +++++++++++--
 mm/swap.c       |    8 +++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/page_alloc.c	2007-06-18 19:13:03.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/page_alloc.c	2007-06-18 19:14:03.000000000 -0700
@@ -1746,8 +1746,17 @@ void __pagevec_free(struct pagevec *pvec
 {
 	int i = pagevec_count(pvec);
 
-	while (--i >= 0)
-		free_hot_cold_page(pvec->pages[i], pvec->cold);
+	while (--i >= 0) {
+		struct page *page = pvec->pages[i];
+
+		if (PageHead(page)) {
+			compound_page_dtor *dtor;
+
+			dtor = get_compound_page_dtor(page);
+			(*dtor)(page);
+		} else
+			free_hot_cold_page(page, pvec->cold);
+	}
 }
 
 fastcall void __free_pages(struct page *page, unsigned int order)
Index: linux-2.6.22-rc4-mm2/mm/swap.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/swap.c	2007-06-15 17:35:33.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/swap.c	2007-06-18 19:14:03.000000000 -0700
@@ -293,7 +293,13 @@ void release_pages(struct page **pages, 
 	for (i = 0; i < nr; i++) {
 		struct page *page = pages[i];
 
-		if (unlikely(PageCompound(page))) {
+		/*
+		 * If we have a tail page on the LRU then we need to
+		 * decrement the page count of the head page. There
+		 * is no further need to do anything since tail pages
+		 * cannot be on the LRU.
+		 */
+		if (unlikely(PageTail(page))) {
 			if (zone) {
 				spin_unlock_irq(&zone->lru_lock);
 				zone = NULL;

-- 

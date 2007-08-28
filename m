Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXH1TVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXH1TVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761419AbXH1TI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58369 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756207AbXH1THe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:34 -0400
Message-Id: <20070828190734.113982746@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:17 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [26/36] compound pages: Allow freeing of compound pages via pagevec
Content-Disposition: inline; filename=0026-compound-pages-Allow-freeing-of-compound-pages-via.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the freeing of compound pages via pagevec.

In release_pages() we currently special case for compound pages in order to
be sure to always decrement the page count of the head page and not the
tail page. However that redirection to the head page is only necessary for
tail pages. So we can actually use PageTail instead of PageCompound there
by avoiding the redirection to the first page. Tail page handling is
not changed.

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

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-08-27 20:59:38.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-08-27 21:05:34.000000000 -0700
@@ -1441,8 +1441,17 @@ void __pagevec_free(struct pagevec *pvec
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
Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/mm/swap.c	2007-08-27 21:05:34.000000000 -0700
@@ -263,7 +263,13 @@ void release_pages(struct page **pages, 
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

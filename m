Return-Path: <linux-kernel-owner+w=401wt.eu-S1423173AbXDXWXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423173AbXDXWXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423172AbXDXWXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423173AbXDXWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:06 -0400
Message-Id: <20070424222305.818002892@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:11 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [06/17] Fix up handling of Compound head pages
Content-Disposition: inline; filename=var_compound_release_pages
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compound pages can be on the LRU. This means that the page pointer
to the head page is on a pagevec. In that case we need full LRU processing
for the page in release_pages().

The check for compound pages in release_pages() was introduced by
Nick Piggin to make sure that the page count in tail pages is not
going negative. Well we can now explicitly check for the tail page.

The head page should be processes like a regular page in order to
support higher order page cache pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/swap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc7/mm/swap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/swap.c	2007-04-24 09:40:16.000000000 -0700
+++ linux-2.6.21-rc7/mm/swap.c	2007-04-24 09:42:27.000000000 -0700
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbXISDiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbXISDiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbXISDgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:36:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54939 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752017AbXISDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:43 -0400
Message-Id: <20070919033642.162537465@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:13 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [08/17] Pass vmalloc address in page->private
Content-Disposition: inline; filename=vcompound_pass_addr_in_private
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid expensive lookups of virtual addresses from page structs by
storing the vmalloc address in page->private. We can then avoid
the vmalloc_address() in the get_xxxx_pagexxxx() functions and
simply return page->private.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-18 18:35:55.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-18 18:36:01.000000000 -0700
@@ -1276,6 +1276,11 @@ struct page *vcompound_alloc(gfp_t gfp_m
 	if (!addr)
 		goto abort;
 
+	/*
+	 * Give the caller a chance to avoid an expensive vmalloc_addr()
+	 * call.
+	 */
+	pages[0]->private = (unsigned long)addr;
 	return pages[0];
 
 abort:
@@ -1534,6 +1539,8 @@ fastcall unsigned long __get_free_pages(
 	page = alloc_pages(gfp_mask, order);
 	if (!page)
 		return 0;
+	if (unlikely(PageVcompound(page)))
+		return page->private;
 	return (unsigned long) page_address(page);
 }
 
@@ -1550,9 +1557,11 @@ fastcall unsigned long get_zeroed_page(g
 	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
 
 	page = alloc_pages(gfp_mask | __GFP_ZERO, 0);
-	if (page)
-		return (unsigned long) page_address(page);
-	return 0;
+	if (!page)
+		return 0;
+	if (unlikely(PageVcompound(page)))
+		return page->private;
+	return (unsigned long) page_address(page);
 }
 
 EXPORT_SYMBOL(get_zeroed_page);

-- 

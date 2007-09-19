Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbXISDhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbXISDhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXISDgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:36:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53628 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbXISDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:42 -0400
Message-Id: <20070919033641.238778992@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:09 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [04/17] vmalloc: clean up page array indexing
Content-Disposition: inline; filename=vcompound_array_indexes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The page array is repeatedly indexed both in vunmap and vmalloc_area_node().
Add a temporary variable to make it easier to read (and easier to patch
later).

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmalloc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-18 13:22:16.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-18 13:22:17.000000000 -0700
@@ -383,8 +383,10 @@ static void __vunmap(const void *addr, i
 		int i;
 
 		for (i = 0; i < area->nr_pages; i++) {
-			BUG_ON(!area->pages[i]);
-			__free_page(area->pages[i]);
+			struct page *page = area->pages[i];
+
+			BUG_ON(!page);
+			__free_page(page);
 		}
 
 		if (area->flags & VM_VPAGES)
@@ -488,15 +490,19 @@ void *__vmalloc_area_node(struct vm_stru
 	}
 
 	for (i = 0; i < area->nr_pages; i++) {
+		struct page *page;
+
 		if (node < 0)
-			area->pages[i] = alloc_page(gfp_mask);
+			page = alloc_page(gfp_mask);
 		else
-			area->pages[i] = alloc_pages_node(node, gfp_mask, 0);
-		if (unlikely(!area->pages[i])) {
+			page = alloc_pages_node(node, gfp_mask, 0);
+
+		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
 			area->nr_pages = i;
 			goto fail;
 		}
+		area->pages[i] = page;
 	}
 
 	if (map_vm_area(area, prot, &pages))

-- 

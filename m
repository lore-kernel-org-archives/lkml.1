Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXISDl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXISDl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbXISDhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:37:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54943 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbXISDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:43 -0400
Message-Id: <20070919033642.612500609@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:15 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [10/17] Use GFP_VFALLBACK for sparsemem.
Content-Disposition: inline; filename=vcompound_sparse_gfp_vfallback
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sparsemem currently attempts first to do a physically contiguous mapping
and then falls back to vmalloc. The same thing can now be accomplished
using GFP_VFALLBACK.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/sparse.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c	2007-09-18 13:21:44.000000000 -0700
+++ linux-2.6/mm/sparse.c	2007-09-18 13:28:43.000000000 -0700
@@ -269,32 +269,15 @@ void __init sparse_init(void)
 #ifdef CONFIG_MEMORY_HOTPLUG
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
-	struct page *page, *ret;
 	unsigned long memmap_size = sizeof(struct page) * nr_pages;
 
-	page = alloc_pages(GFP_KERNEL|__GFP_NOWARN, get_order(memmap_size));
-	if (page)
-		goto got_map_page;
-
-	ret = vmalloc(memmap_size);
-	if (ret)
-		goto got_map_ptr;
-
-	return NULL;
-got_map_page:
-	ret = (struct page *)pfn_to_kaddr(page_to_pfn(page));
-got_map_ptr:
-	memset(ret, 0, memmap_size);
-
-	return ret;
+	return (struct page *)alloc_page(GFP_VFALLBACK|__GFP_ZERO,
+		get_order(memmap_size));
 }
 
 static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 {
-	if (is_vmalloc_addr(memmap))
-		vfree(memmap);
-	else
-		free_pages((unsigned long)memmap,
+	free_pages((unsigned long)memmap,
 			   get_order(sizeof(struct page) * nr_pages));
 }
 

-- 

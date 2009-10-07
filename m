Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbZJGMqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbZJGMqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759149AbZJGMp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:45:59 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52049 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151AbZJGMp7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Wed, 7 Oct 2009 08:45:59 -0400
Message-Id: <4ACCA98202000078000187DF@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 07 Oct 2009 13:45:22 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <hugh.dickins@tiscali.co.uk>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust gfp mask passed on nested vmalloc() invocation
	 (v2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- avoid wasting more precious resources (DMA or DMA32 pools), when
  being called through vmalloc_32{,_user}()
- explicitly allow using high memory here even if the outer allocation
  request doesn't allow it, unless is collides with __GFP_ZERO

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>

---
 mm/vmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.32-rc3/mm/vmalloc.c	2009-10-05 11:59:56.000000000 +0200
+++ 2.6.32-rc3-vmalloc-nested-gfp/mm/vmalloc.c	2009-10-07 14:39:38.000000000 +0200
@@ -1410,6 +1410,7 @@ static void *__vmalloc_area_node(struct 
 {
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
+	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 
 	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
@@ -1417,13 +1418,11 @@ static void *__vmalloc_area_node(struct 
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
+		pages = __vmalloc_node(array_size, nested_gfp | __GFP_HIGHMEM,
 				PAGE_KERNEL, node, caller);
 		area->flags |= VM_VPAGES;
 	} else {
-		pages = kmalloc_node(array_size,
-				(gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
-				node);
+		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
 	area->pages = pages;
 	area->caller = caller;




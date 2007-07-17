Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbXGQPn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbXGQPn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934578AbXGQPlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:41:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934575AbXGQPlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:41:04 -0400
Message-Id: <20070717173757.278179000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:31 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 03/12] mm: remove raw SetPageLocked() usage
Content-Disposition: inline; filename=lock_page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the last few SetPageLocked() instances and replace them with
lock_page().

If any of these spots would suffer performance wise (or cannot suffer
the might_sleep()) then we could introduce another primitive for this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 drivers/char/agp/generic.c   |    2 +-
 drivers/char/agp/intel-agp.c |    2 +-
 drivers/char/agp/sgi-agp.c   |    2 +-
 include/linux/pagemap.h      |    5 +++++
 mm/filemap.c                 |    2 +-
 mm/swap_state.c              |    2 +-
 6 files changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/char/agp/generic.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/generic.c
+++ linux-2.6/drivers/char/agp/generic.c
@@ -1170,7 +1170,7 @@ void *agp_generic_alloc_page(struct agp_
 	map_page_into_agp(page);
 
 	get_page(page);
-	SetPageLocked(page);
+	lock_page(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
 	return page_address(page);
 }
Index: linux-2.6/drivers/char/agp/intel-agp.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/intel-agp.c
+++ linux-2.6/drivers/char/agp/intel-agp.c
@@ -213,7 +213,7 @@ static void *i8xx_alloc_pages(void)
 	}
 	global_flush_tlb();
 	get_page(page);
-	SetPageLocked(page);
+	lock_page(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
 	return page_address(page);
 }
Index: linux-2.6/drivers/char/agp/sgi-agp.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/sgi-agp.c
+++ linux-2.6/drivers/char/agp/sgi-agp.c
@@ -51,7 +51,7 @@ static void *sgi_tioca_alloc_page(struct
 		return NULL;
 
 	get_page(page);
-	SetPageLocked(page);
+	lock_page(page);
 	atomic_inc(&agp_bridge->current_memory_agp);
 	return page_address(page);
 }
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -449,7 +449,7 @@ int add_to_page_cache(struct page *page,
 		radix_tree_unlock(&ctx);
 		if (!error) {
 			page_cache_get(page);
-			SetPageLocked(page);
+			lock_page(page);
 			page->mapping = mapping;
 			page->index = offset;
 			mapping_nrpages_inc(mapping);
Index: linux-2.6/mm/swap_state.c
===================================================================
--- linux-2.6.orig/mm/swap_state.c
+++ linux-2.6/mm/swap_state.c
@@ -343,7 +343,7 @@ struct page *read_swap_cache_async(swp_e
 			new_page = alloc_page_vma(GFP_HIGHUSER, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
-			SetPageLocked(new_page);/* could be non-atomic op */
+			lock_page(new_page);/* could be non-atomic op */
 		}
 
 		/*

--


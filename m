Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbXI1IBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbXI1IBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbXI1IBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802AbXI1IBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:34 -0400
Message-Id: <20070928080042.020756000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/12] mm: remove raw SetPageLocked() usage
Content-Disposition: inline; filename=lock_page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the last few SetPageLocked() instances.

use trylock_page() instead of SetPageLocked() because we hold tree_lock
so we cannot suffer the might_sleep(). Also at least add_to_page_cache() can
be handed a locked page.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/filemap.c    |    2 +-
 mm/swap_state.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -445,7 +445,7 @@ int add_to_page_cache(struct page *page,
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
 		if (!error) {
 			page_cache_get(page);
-			SetPageLocked(page);
+			trylock_page(page);
 			page->mapping = mapping;
 			page->index = offset;
 			mapping->nrpages++;
Index: linux-2.6/mm/swap_state.c
===================================================================
--- linux-2.6.orig/mm/swap_state.c
+++ linux-2.6/mm/swap_state.c
@@ -83,7 +83,7 @@ static int __add_to_swap_cache(struct pa
 						entry.val, page);
 		if (!error) {
 			page_cache_get(page);
-			SetPageLocked(page);
+			trylock_page(page);
 			SetPageSwapCache(page);
 			set_page_private(page, entry.val);
 			total_swapcache_pages++;

--


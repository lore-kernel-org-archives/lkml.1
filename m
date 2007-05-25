Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbXEYJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbXEYJWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXEYJWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:22:10 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56181 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXEYJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:22:09 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070525092207.17283.87048.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070525092126.17283.41581.sendpatchset@skynet.skynet.ie>
References: <20070525092126.17283.41581.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 2/5] Breakout page_order() to internal.h to avoid special knowledge of the buddy allocator
Date: Fri, 25 May 2007 10:22:07 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The statistics patch later needs to know what order a free page is on the
free lists. Rather than having special knowledge of page_private() when
PageBuddy() is set, this patch places out page_order() in internal.h and
adds a VM_BUG_ON to catch using it on non-PageBuddy pages.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
---

 internal.h   |   10 ++++++++++
 page_alloc.c |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.22-rc2-mm1-001_fix_movefreepages/mm/internal.h linux-2.6.22-rc2-mm1-002_breakout_pageorder/mm/internal.h
--- linux-2.6.22-rc2-mm1-001_fix_movefreepages/mm/internal.h	2007-05-19 05:06:17.000000000 +0100
+++ linux-2.6.22-rc2-mm1-002_breakout_pageorder/mm/internal.h	2007-05-24 16:41:31.000000000 +0100
@@ -37,4 +37,14 @@ static inline void __put_page(struct pag
 extern void fastcall __init __free_pages_bootmem(struct page *page,
 						unsigned int order);
 
+/*
+ * function for dealing with page's order in buddy system.
+ * zone->lock is already acquired when we use these.
+ * So, we don't need atomic page->flags operations here.
+ */
+static inline unsigned long page_order(struct page *page)
+{
+	VM_BUG_ON(!PageBuddy(page));
+	return page_private(page);
+}
 #endif
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.22-rc2-mm1-001_fix_movefreepages/mm/page_alloc.c linux-2.6.22-rc2-mm1-002_breakout_pageorder/mm/page_alloc.c
--- linux-2.6.22-rc2-mm1-001_fix_movefreepages/mm/page_alloc.c	2007-05-24 16:37:27.000000000 +0100
+++ linux-2.6.22-rc2-mm1-002_breakout_pageorder/mm/page_alloc.c	2007-05-24 16:41:31.000000000 +0100
@@ -336,16 +336,6 @@ static inline void prep_zero_page(struct
 		clear_highpage(page + i);
 }
 
-/*
- * function for dealing with page's order in buddy system.
- * zone->lock is already acquired when we use these.
- * So, we don't need atomic page->flags operations here.
- */
-static inline unsigned long page_order(struct page *page)
-{
-	return page_private(page);
-}
-
 static inline void set_page_order(struct page *page, int order)
 {
 	set_page_private(page, order);

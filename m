Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbZCTKLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbZCTKLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbZCTKCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:02:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55172 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbZCTKCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:02:50 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 23/25] Get the pageblock migratetype without disabling interrupts
Date: Fri, 20 Mar 2009 10:03:10 +0000
Message-Id: <1237543392-11797-24-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local interrupts are disabled when freeing pages to the PCP list. Part
of that free checks what the migratetype of the pageblock the page is in
but it checks this with interrupts disabled. This patch checks the
pagetype with interrupts enabled. The impact is that it is possible a
page is freed to the wrong list when a pageblock changes type but as
that block is now already considered mixed from an anti-fragmentation
perspective, it's not of vital importance.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6584465..18f0b56 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1037,6 +1037,7 @@ static void free_hot_cold_page(struct page *page, int cold)
 	kernel_map_pages(page, 1, 0);
 
 	pcp = &zone_pcp(zone, get_cpu())->pcp;
+	set_page_private(page, get_pageblock_migratetype(page));
 	local_irq_save(flags);
 	if (unlikely(clearMlocked))
 		free_page_mlock(page);
@@ -1046,7 +1047,6 @@ static void free_hot_cold_page(struct page *page, int cold)
 		list_add_tail(&page->lru, &pcp->list);
 	else
 		list_add(&page->lru, &pcp->list);
-	set_page_private(page, get_pageblock_migratetype(page));
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		free_pages_bulk(zone, pcp->batch, &pcp->list, 0);
-- 
1.5.6.5


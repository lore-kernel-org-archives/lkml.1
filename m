Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXIXNSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXIXNSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXIXNSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:18:11 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48201 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbXIXNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:18:10 -0400
Date: Mon, 24 Sep 2007 14:17:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH rc7-mm1] fix BUG at mm/swap.c:405!
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709241413460.2056@blonde.wat.veritas.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a.k.a. mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch

rotate_reclaimable_page() is not necessarily called with IRQ disabled:
it must do so when calling the helpfully commented pagevec_move_tail().

Hmm, if pagevec_move_tail() is assuming IRQ disabled, why should it
bother with irqsave/irqrestore variants of spin_lock?  Because we like
to see them on lru_lock?  But vmscan.c already has one bare spin_lock().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/swap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- 2.6.23-rc7-mm1/mm/swap.c	2007-09-24 11:05:55.000000000 +0100
+++ linux/mm/swap.c	2007-09-24 13:08:12.000000000 +0100
@@ -102,7 +102,6 @@ static void pagevec_move_tail(struct pag
 	int i;
 	int pgmoved = 0;
 	struct zone *zone = NULL;
-	unsigned long uninitialized_var(flags);
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
@@ -110,9 +109,9 @@ static void pagevec_move_tail(struct pag
 
 		if (pagezone != zone) {
 			if (zone)
-				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				spin_unlock(&zone->lru_lock);
 			zone = pagezone;
-			spin_lock_irqsave(&zone->lru_lock, flags);
+			spin_lock(&zone->lru_lock);
 		}
 		if (PageLRU(page) && !PageActive(page)) {
 			list_move_tail(&page->lru, &zone->inactive_list);
@@ -120,7 +119,7 @@ static void pagevec_move_tail(struct pag
 		}
 	}
 	if (zone)
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock(&zone->lru_lock);
 	__count_vm_events(PGROTATED, pgmoved);
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
@@ -150,6 +149,7 @@ void move_tail_pages()
 int rotate_reclaimable_page(struct page *page)
 {
 	struct pagevec *pvec;
+	unsigned long flags;
 
 	if (PageLocked(page))
 		return 1;
@@ -162,9 +162,11 @@ int rotate_reclaimable_page(struct page 
 
 	if (PageLRU(page) && !PageActive(page)) {
 		page_cache_get(page);
+		local_irq_save(flags);
 		pvec = &__get_cpu_var(rotate_pvecs);
 		if (!pagevec_add(pvec, page))
 			pagevec_move_tail(pvec);
+		local_irq_restore(flags);
 	}
 	if (!test_clear_page_writeback(page))
 		BUG();

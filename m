Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbXI0TtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbXI0TtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbXI0Tsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:48:55 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48295 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbXI0Tsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:48:54 -0400
Date: Thu, 27 Sep 2007 20:48:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH mm 1/3] fix BUG at include/linux/mm.h:220!
Message-ID: <Pine.LNX.4.64.0709272045180.19737@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a.k.a. mm-use-pagevec-to-rotate-reclaimable-page-fix-3.patch

put_page_testzero's VM_BUG_ON(atomic_read(&page->_count) == 0) fired
a couple of times while heavily swapping (on -rc7-mm1 and -rc8-mm1).

release_pages() has been using spin_lock_irq/spin_unlock_irq: but now
that it's being called by pagevec_move_tail() with interrupts disabled,
it must use spin_lock_irqsave/spin_unlock_irqrestore instead.

Aside from it being generally wrong to enable IRQs behind the caller's
back, here a pagevec might overflow, or (as I think must have happened
to cause those BUGs) release_pages() may be preempted to another cpu
while still acting on the pagevec of the cpu it started out with,
and that owning cpu also come in to drain it.  Hmm, no, one of the
BUGs was with preemption disabled: so I don't fully understand it.

Tested for 39 hours with rc8-mm1 on three 4cpu machines: no more BUGs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 mm/swap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- 2.6.23-rc8-mm2/mm/swap.c	2007-09-27 11:28:39.000000000 +0100
+++ linux/mm/swap.c	2007-09-27 17:51:11.000000000 +0100
@@ -299,6 +299,7 @@ void release_pages(struct page **pages, 
 	int i;
 	struct pagevec pages_to_free;
 	struct zone *zone = NULL;
+	unsigned long uninitialized_var(flags);
 
 	pagevec_init(&pages_to_free, cold);
 	for (i = 0; i < nr; i++) {
@@ -306,7 +307,7 @@ void release_pages(struct page **pages, 
 
 		if (unlikely(PageCompound(page))) {
 			if (zone) {
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				zone = NULL;
 			}
 			put_compound_page(page);
@@ -320,9 +321,10 @@ void release_pages(struct page **pages, 
 			struct zone *pagezone = page_zone(page);
 			if (pagezone != zone) {
 				if (zone)
-					spin_unlock_irq(&zone->lru_lock);
+					spin_unlock_irqrestore(&zone->lru_lock,
+									flags);
 				zone = pagezone;
-				spin_lock_irq(&zone->lru_lock);
+				spin_lock_irqsave(&zone->lru_lock, flags);
 			}
 			VM_BUG_ON(!PageLRU(page));
 			__ClearPageLRU(page);
@@ -331,7 +333,7 @@ void release_pages(struct page **pages, 
 
 		if (!pagevec_add(&pages_to_free, page)) {
 			if (zone) {
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				zone = NULL;
 			}
 			__pagevec_free(&pages_to_free);
@@ -339,7 +341,7 @@ void release_pages(struct page **pages, 
   		}
 	}
 	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
 	pagevec_free(&pages_to_free);
 }

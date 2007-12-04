Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbXLDUnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbXLDUnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXLDUmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:42:39 -0500
Received: from mga07.intel.com ([143.182.124.22]:10860 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695AbXLDUmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:42:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,250,1194249600"; 
   d="scan'208";a="332758444"
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/7] Avoid taking waitqueue lock in dmapool
Date: Tue,  4 Dec 2007 13:26:04 -0800
Message-Id: <11968035684180-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11968035681680-git-send-email-matthew@wil.cx>
References: <20071204170915.GE9405@parisc-linux.org> <11968035682899-git-send-email-matthew@wil.cx> <11968035681680-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With one trivial change (taking the lock slightly earlier on wakeup
from schedule), all uses of the waitq are under the pool lock, so we
can use the locked (or __) versions of the wait queue functions, and
avoid the extra spinlock.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 mm/dmapool.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 92e886d..b5ff9ce 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -275,8 +275,8 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 	size_t offset;
 	void *retval;
 
- restart:
 	spin_lock_irqsave(&pool->lock, flags);
+ restart:
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		int i;
 		/* only cachable accesses here ... */
@@ -299,12 +299,13 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 			DECLARE_WAITQUEUE(wait, current);
 
 			__set_current_state(TASK_INTERRUPTIBLE);
-			add_wait_queue(&pool->waitq, &wait);
+			__add_wait_queue(&pool->waitq, &wait);
 			spin_unlock_irqrestore(&pool->lock, flags);
 
 			schedule_timeout(POOL_TIMEOUT_JIFFIES);
 
-			remove_wait_queue(&pool->waitq, &wait);
+			spin_lock_irqsave(&pool->lock, flags);
+			__remove_wait_queue(&pool->waitq, &wait);
 			goto restart;
 		}
 		retval = NULL;
@@ -406,7 +407,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 	page->in_use--;
 	set_bit(block, &page->bitmap[map]);
 	if (waitqueue_active(&pool->waitq))
-		wake_up(&pool->waitq);
+		wake_up_locked(&pool->waitq);
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(bpp, page->bitmap)) pool_free_page(pool, page);
-- 
1.4.4.4

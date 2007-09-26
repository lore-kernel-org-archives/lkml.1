Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbXIZTBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbXIZTBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757811AbXIZTBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:01:22 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:48778 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbXIZTBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:01:21 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/4] Avoid taking waitqueue lock in dmapool
Date: Wed, 26 Sep 2007 15:01:16 -0400
Message-Id: <11908332791719-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.5.3.1
In-Reply-To: <20070926185757.GM3899@parisc-linux.org>
References: <20070926185757.GM3899@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With one trivial change (taking the lock slightly earlier on wakeup
from schedule), all uses of the waitq are under the pool lock, so we
can use the locked (or __) versions of the wait queue functions, and
avoid the extra spinlock.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 mm/dmapool.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 6201371..a359b5e 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -273,8 +273,8 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 	size_t offset;
 	void *retval;
 
- restart:
 	spin_lock_irqsave(&pool->lock, flags);
+ restart:
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		int i;
 		/* only cachable accesses here ... */
@@ -296,12 +296,13 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 			DECLARE_WAITQUEUE(wait, current);
 
 			current->state = TASK_INTERRUPTIBLE;
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
@@ -401,7 +402,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 	page->in_use--;
 	set_bit(block, &page->bitmap[map]);
 	if (waitqueue_active(&pool->waitq))
-		wake_up(&pool->waitq);
+		wake_up_locked(&pool->waitq);
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(bpp, page->bitmap)) pool_free_page(pool, page);
-- 
1.5.3.1


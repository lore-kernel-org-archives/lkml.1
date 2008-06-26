Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYFZLHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYFZLHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYFZLGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:06:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:59281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbYFZLGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:06:48 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-aio@kvack.org
Subject: [PATCH] aio: aio_complete() will never be called in interrupt context
Date: Thu, 26 Jun 2008 09:30:59 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
       Jeff Moyer <jmoyer@redhat.com>, Zach Brown <zach.brown@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806260930.59836.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


aio_complete() is never called from interrupt context. It is called from user 
context or worker threads. Remove disabling interrupts and for kmap_atomic use 
KM_USER slots instead of KM_IRQ slots.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/aio.c b/fs/aio.c
index 7817e8f..27b7181 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -893,7 +893,6 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
 	struct io_event	*event;
-	unsigned long	flags;
 	unsigned long	tail;
 	int		ret;
 
@@ -916,11 +915,9 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/* add a completion event to the ring buffer.
 	 * must be done holding ctx->ctx_lock to prevent
-	 * other code from messing with the tail
-	 * pointer since we might be called from irq
-	 * context.
+	 * other code from messing with the tail pointer.
 	 */
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
+	spin_lock(&ctx->ctx_lock);
 
 	if (iocb->ki_run_list.prev && !list_empty(&iocb->ki_run_list))
 		list_del_init(&iocb->ki_run_list);
@@ -932,10 +929,10 @@ int aio_complete(struct kiocb *iocb, long res, long 
res2)
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0], KM_IRQ1);
+	ring = kmap_atomic(info->ring_pages[0], KM_USER1);
 
 	tail = info->tail;
-	event = aio_ring_event(info, tail, KM_IRQ0);
+	event = aio_ring_event(info, tail, KM_USER0);
 	if (++tail >= info->nr)
 		tail = 0;
 
@@ -956,8 +953,8 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	info->tail = tail;
 	ring->tail = tail;
 
-	put_aio_ring_event(event, KM_IRQ0);
-	kunmap_atomic(ring, KM_IRQ1);
+	put_aio_ring_event(event, KM_USER0);
+	kunmap_atomic(ring, KM_USER1);
 
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
 
@@ -984,7 +981,7 @@ put_rq:
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	spin_unlock(&ctx->ctx_lock);
 	return ret;
 }
 

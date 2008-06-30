Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYF3Fq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYF3Fq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 01:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYF3Fqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 01:46:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:60698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbYF3Fqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 01:46:46 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] aio: aio_complete() will never be called in interrupt context
Date: Mon, 30 Jun 2008 11:21:09 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>
References: <200806260930.59836.knikanth@suse.de> <x49tzfft448.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49tzfft448.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806301121.10119.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2008 18:41:03 Jeff Moyer wrote:
> Nikanth Karthikesan <knikanth@suse.de> writes:
> > aio_complete() is never called from interrupt context. It is called from
> > user context or worker threads. Remove disabling interrupts and for
> > kmap_atomic use KM_USER slots instead of KM_IRQ slots.
>
> Actually, it can be called from softirq context.  See fs/directio.c.
>

Oh, sorry for my ignorance. Will using KM_SOFTIRQ slots be fine?

Thanks
Nikanth Karthikesan

aio_complete() is never called from hardware interrupt context. Remove 
disabling interrupts and for kmap_atomic use KM_SOFTIRQ slots instead of 
KM_IRQ slots.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/fs/aio.c
===================================================================
--- linux-2.6.orig/fs/aio.c
+++ linux-2.6/fs/aio.c
@@ -901,7 +901,6 @@ int aio_complete(struct kiocb *iocb, lon
 	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
 	struct io_event	*event;
-	unsigned long	flags;
 	unsigned long	tail;
 	int		ret;
 
@@ -924,11 +923,9 @@ int aio_complete(struct kiocb *iocb, lon
 
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
@@ -940,10 +937,10 @@ int aio_complete(struct kiocb *iocb, lon
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0], KM_IRQ1);
+	ring = kmap_atomic(info->ring_pages[0], KM_SOFTIRQ1);
 
 	tail = info->tail;
-	event = aio_ring_event(info, tail, KM_IRQ0);
+	event = aio_ring_event(info, tail, KM_SOFTIRQ0);
 	if (++tail >= info->nr)
 		tail = 0;
 
@@ -964,8 +961,8 @@ int aio_complete(struct kiocb *iocb, lon
 	info->tail = tail;
 	ring->tail = tail;
 
-	put_aio_ring_event(event, KM_IRQ0);
-	kunmap_atomic(ring, KM_IRQ1);
+	put_aio_ring_event(event, KM_SOFTIRQ0);
+	kunmap_atomic(ring, KM_SOFTIRQ1);
 
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
 
@@ -992,7 +989,7 @@ put_rq:
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	spin_unlock(&ctx->ctx_lock);
 	return ret;
 }
 





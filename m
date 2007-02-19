Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbXBSVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbXBSVib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932711AbXBSVib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:38:31 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:43913 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbXBSVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:38:31 -0500
From: Zach Brown <zach.brown@oracle.com>
To: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Cc: Benjamin LaHaise <bcrl@kvack.org>,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Leonid Ananiev <leonid.i.ananiev@intel.com>
Message-Id: <20070219213830.4032.71308.sendpatchset@tetsuo.zabbo.net>
Subject: [PATCH 1/2] aio: create aio_ring_insert_entry() function
Date: Mon, 19 Feb 2007 13:38:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

aio: create aio_ring_insert_entry() function

This patch just hoists the process of inserting an entry into the completion
ring into its own function.  No functionality is changed.  This is in
preparation for calling ring insertion from another path with slightly
different mechanics.

diff -r b551e6cbf434 fs/aio.c
Signed-off-by: Zach Brown <zach.brown@oracle.com>
---

 fs/aio.c |   77 +++++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 34 deletions(-)

--- a/fs/aio.c	Mon Feb 19 13:09:01 2007 -0800
+++ b/fs/aio.c	Mon Feb 19 13:12:04 2007 -0800
@@ -192,6 +192,47 @@ static int aio_setup_ring(struct kioctx 
 	(void)__event;				\
 	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK), km); \
 } while(0)
+
+static void aio_ring_insert_entry(struct kioctx *ctx, struct kiocb *iocb,
+				  long res, long res2)
+{
+	struct aio_ring_info	*info;
+	struct aio_ring		*ring;
+	struct io_event		*event;
+	unsigned long		tail;	
+
+	assert_spin_locked(&ctx->ctx_lock);
+
+	info = &ctx->ring_info;
+	ring = kmap_atomic(info->ring_pages[0], KM_IRQ1);
+
+	tail = info->tail;
+	event = aio_ring_event(info, tail, KM_IRQ0);
+	if (++tail >= info->nr)
+		tail = 0;
+
+	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
+	event->data = iocb->ki_user_data;
+	event->res = res;
+	event->res2 = res2;
+
+	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
+		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
+		res, res2);
+
+	/* after flagging the request as done, we
+	 * must never even look at it again
+	 */
+	smp_wmb();	/* make event visible before updating tail */
+
+	info->tail = tail;
+	ring->tail = tail;
+
+	put_aio_ring_event(event, KM_IRQ0);
+	kunmap_atomic(ring, KM_IRQ1);
+
+	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+}
 
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
@@ -924,11 +965,7 @@ int fastcall aio_complete(struct kiocb *
 int fastcall aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
-	struct aio_ring_info	*info;
-	struct aio_ring	*ring;
-	struct io_event	*event;
 	unsigned long	flags;
-	unsigned long	tail;
 	int		ret;
 
 	/*
@@ -946,8 +983,6 @@ int fastcall aio_complete(struct kiocb *
 		return 1;
 	}
 
-	info = &ctx->ring_info;
-
 	/* add a completion event to the ring buffer.
 	 * must be done holding ctx->ctx_lock to prevent
 	 * other code from messing with the tail
@@ -966,34 +1001,8 @@ int fastcall aio_complete(struct kiocb *
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0], KM_IRQ1);
-
-	tail = info->tail;
-	event = aio_ring_event(info, tail, KM_IRQ0);
-	if (++tail >= info->nr)
-		tail = 0;
-
-	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
-	event->data = iocb->ki_user_data;
-	event->res = res;
-	event->res2 = res2;
-
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
-		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
-		res, res2);
-
-	/* after flagging the request as done, we
-	 * must never even look at it again
-	 */
-	smp_wmb();	/* make event visible before updating tail */
-
-	info->tail = tail;
-	ring->tail = tail;
-
-	put_aio_ring_event(event, KM_IRQ0);
-	kunmap_atomic(ring, KM_IRQ1);
-
-	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+	aio_ring_insert_entry(ctx, iocb, res, res2);
+
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbYCHE3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbYCHE3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 23:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYCHE3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 23:29:22 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:54615 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYCHE3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 23:29:21 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 7 Mar 2008 20:29:20 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jeff Roberson <jroberson@chesapeake.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, riel@redhat.com,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] eventfd signal race in aio_complete()
In-Reply-To: <20080307161854.E920@desktop>
Message-ID: <Pine.LNX.4.64.0803071955490.13626@alien.or.mcafeemobile.com>
References: <20080307161854.E920@desktop>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc-ing zab]


On Fri, 7 Mar 2008, Jeff Roberson wrote:

> Hello,

Hi!


> I have an application that makes use of eventfd to merge socket and aio
> blocking with epoll in one thread.  Under heavy loads the application
> sometimes hangs when we receive notification from epoll that the eventfd has
> an event ready but reading the aio completions produces no results. Further
> investigation revealed that the aiocb was later ready with no new event and
> completing it based on a timer resolved the application hang.
>
> This pointed to the eventfd being signaled prematurely and I verified that
> this was indeed the problem.  aio_complete() calls eventfd_signal() before the
> event is actually placed on the completion ring.  On a multi-processor system
> it is possible to read the event from epoll and return to userspace before
> aio_complete() finishes.
> 
> The enclosed patch simply moves the signaling to the bottom of the function.
> I'm not 100% familiar with this code and it looks like it may be possible to
> have spurious wakeups now but there will be no missed wakeups.  An application
> may also race the other way now and receive aio completion before the signal,
> thus still leaving it with a signal with no completion.  signaling while the
> kioctx is locked would resolve this but I was hesitant to introduce further
> nesting of spinlocks that might have another order elsewhere.

Your patch access the iocb after the __aio_put_req() call, that can make 
the iocb (and the reference to the ki_eventfd) to become invalid. It also 
has the spurious wakeup issue (not a biggie, but if it can be avoided).
There're two solutions AFAICS. The first solution/patch get a reference to 
the file*, and signal (if the event has really been dropped inside the 
ring) and release.
The second solution/patch simply moves the eventfd_signal() call before 
the __aio_put_req() call, but after the event has beed "ringed".
We should be clear to go with the shorter/nicer second solution. Those 
patches builds, but I'm not even signing them off till I tested them.




- Davide



---
 fs/aio.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

Index: linux-2.6.mod/fs/aio.c
===================================================================
--- linux-2.6.mod.orig/fs/aio.c	2008-03-07 19:33:44.000000000 -0800
+++ linux-2.6.mod/fs/aio.c	2008-03-07 19:45:50.000000000 -0800
@@ -916,7 +916,8 @@
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
-	struct io_event	*event;
+	struct io_event	*event = NULL;
+	struct file *file = NULL;
 	unsigned long	flags;
 	unsigned long	tail;
 	int		ret;
@@ -937,12 +938,15 @@
 	}
 
 	/*
-	 * Check if the user asked us to deliver the result through an
-	 * eventfd. The eventfd_signal() function is safe to be called
-	 * from IRQ context.
+	 * Get a reference now, but do not deliver the event until
+	 * we're sure we actually dropped it inside the ring. We
+	 * need to get a reference before calling __aio_put_req(),
+	 * since the ->ki_eventfd may become invalid after such call.
 	 */
-	if (!IS_ERR(iocb->ki_eventfd))
-		eventfd_signal(iocb->ki_eventfd, 1);
+	if (!IS_ERR(iocb->ki_eventfd)) {
+		file = iocb->ki_eventfd;
+		get_file(file);
+	}
 
 	info = &ctx->ring_info;
 
@@ -1000,6 +1004,19 @@
 		wake_up(&ctx->wait);
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+
+	/*
+	 * If the user requested us to deliver a completion event to an
+	 * eventfd file descriptor *and* we actually delivered the event,
+	 * signal it with eventfd_signal(). The eventfd_signal() function
+	 * is safe to be called from IRQ context.
+	 */
+	if (file) {
+		if (event)
+			eventfd_signal(file, 1);
+		fput(file);
+	}
+
 	return ret;
 }
 





---
 fs/aio.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6.mod/fs/aio.c
===================================================================
--- linux-2.6.mod.orig/fs/aio.c	2008-03-07 20:14:55.000000000 -0800
+++ linux-2.6.mod/fs/aio.c	2008-03-07 20:15:24.000000000 -0800
@@ -936,14 +936,6 @@
 		return 1;
 	}
 
-	/*
-	 * Check if the user asked us to deliver the result through an
-	 * eventfd. The eventfd_signal() function is safe to be called
-	 * from IRQ context.
-	 */
-	if (!IS_ERR(iocb->ki_eventfd))
-		eventfd_signal(iocb->ki_eventfd, 1);
-
 	info = &ctx->ring_info;
 
 	/* add a completion event to the ring buffer.
@@ -992,6 +984,15 @@
 	kunmap_atomic(ring, KM_IRQ1);
 
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+
+	/*
+	 * Check if the user asked us to deliver the result through an
+	 * eventfd. The eventfd_signal() function is safe to be called
+	 * from IRQ context.
+	 */
+	if (!IS_ERR(iocb->ki_eventfd))
+		eventfd_signal(iocb->ki_eventfd, 1);
+
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbXKGMn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbXKGMn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 07:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbXKGMnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 07:43:19 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58782 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXKGMnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 07:43:18 -0500
Date: Wed, 7 Nov 2007 16:48:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick <gentuu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: fix IOPRIO_CLASS_IDLE delays
Message-ID: <20071107134855.GA5947@tv-sign.ru>
References: <20071106200510.GA11435@tv-sign.ru> <20071106192611.GS1767@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106192611.GS1767@kernel.dk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06, Jens Axboe wrote:
>
> On Tue, Nov 06 2007, Oleg Nesterov wrote:
> >
> > (I guess this patch is not complete, overflow is still possible)
>
> Hmm, where would it overflow?

What if the queue was idle long enough (no !CLASS_IDLE requests) so that
jiffies wraps into the past wrt ->last_end_request?

IOW, perhaps something like the patch below makes some sense. Of course,
this is only a theoretical problem, I'm not sure we really need a fix.

Oleg.


[PATCH] cfq_idle_class_timer: add paranoid checks for jiffies overflow

In theory, if the queue was idle long enough, cfq_idle_class_timer may have
a false (and very long) timeout because jiffies can wrap into the past wrt
->last_end_request.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- cfq/block/cfq-iosched.c~	2007-11-07 15:04:44.000000000 +0300
+++ cfq/block/cfq-iosched.c	2007-11-07 16:04:08.000000000 +0300
@@ -789,6 +789,20 @@ static inline void cfq_slice_expired(str
 		__cfq_slice_expired(cfqd, cfqq, timed_out);
 }
 
+static int start_idle_class_timer(struct cfq_data *cfqd)
+{
+	unsigned long end = cfqd->last_end_request + CFQ_IDLE_GRACE;
+	unsigned long now = jiffies;
+
+	if (time_before(now, end) &&
+	    time_after_eq(now, cfqd->last_end_request)) {
+		mod_timer(&cfqd->idle_class_timer, end);
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * Get next queue for service. Unless we have a queue preemption,
  * we'll simply select the first cfqq in the service tree.
@@ -805,19 +819,14 @@ static struct cfq_queue *cfq_get_next_qu
 	cfqq = rb_entry(n, struct cfq_queue, rb_node);
 
 	if (cfq_class_idle(cfqq)) {
-		unsigned long end;
-
 		/*
 		 * if we have idle queues and no rt or be queues had
 		 * pending requests, either allow immediate service if
 		 * the grace period has passed or arm the idle grace
 		 * timer
 		 */
-		end = cfqd->last_end_request + CFQ_IDLE_GRACE;
-		if (time_before(jiffies, end)) {
-			mod_timer(&cfqd->idle_class_timer, end);
+		if (start_idle_class_timer(cfqd))
 			cfqq = NULL;
-		}
 	}
 
 	return cfqq;
@@ -2033,17 +2042,14 @@ out_cont:
 static void cfq_idle_class_timer(unsigned long data)
 {
 	struct cfq_data *cfqd = (struct cfq_data *) data;
-	unsigned long flags, end;
+	unsigned long flags;
 
 	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
 
 	/*
 	 * race with a non-idle queue, reset timer
 	 */
-	end = cfqd->last_end_request + CFQ_IDLE_GRACE;
-	if (!time_after_eq(jiffies, end))
-		mod_timer(&cfqd->idle_class_timer, end);
-	else
+	if (!start_idle_class_timer(cfqd))
 		cfq_schedule_dispatch(cfqd);
 
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYEOMQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYEOMQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 08:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYEOMQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 08:16:03 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:56226 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbYEOMQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 08:16:01 -0400
Date: Thu, 15 May 2008 14:21:56 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew <jackdachef@gmail.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080515122156.GA11600@gandalf.sssup.it>
References: <e85b9d30805130558l502addbcq21996b92fdbfdc5b@mail.gmail.com> <20080513130508.GQ16217@kernel.dk> <e85b9d30805130842p3a34305l4ab1e7926e4b0dba@mail.gmail.com> <20080513180334.GS16217@kernel.dk> <20080513184057.GU16217@kernel.dk> <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com> <20080514082622.GA16217@kernel.dk> <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com> <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com> <20080515070127.GH16217@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515070127.GH16217@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, May 15, 2008 09:01:28AM +0200
>
> I don't think it's 2.6.25 vs 2.6.26-rc2, I can still reproduce some
> request size offsets with the patch. So still fumbling around with this,
> I'll be sending out another test patch when I'm confident it's solved
> the size issue.
> 

IMO an interesting thing is how/why anticipatory doesn't show the
issue.  The device is not put into ANTIC_WAIT_NEXT if there is no
dispatch returning no requests while the queue is not empty.  This
seems to be enough in the reported workloads.

I don't think this behavior is the correct one (it is still racy
WRT merges after breaking anticipation) anyway it should make things
a little bit better.  I fear that a complete solution would not
involve only the scheduler.

Introducing the very same behavior in cfq seems to be not so easy
(i.e., start idling only if there was a dispatch round while the
last request was being served) but an approximated version can be
introduced quite easily.  The patch below should do that, rescheduling
the dispatch only if necessary; it is not tested at all, just posted
for discussion.

---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b399c62..41f1e0e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -169,6 +169,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_queue_new,	/* queue never been serviced */
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
+	CFQ_CFQQ_FLAG_dispatched,	/* empty dispatch while idling */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -196,6 +197,7 @@ CFQ_CFQQ_FNS(prio_changed);
 CFQ_CFQQ_FNS(queue_new);
 CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
+CFQ_CFQQ_FNS(dispatched);
 #undef CFQ_CFQQ_FNS
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
@@ -749,6 +751,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfqq->slice_end = 0;
 		cfq_clear_cfqq_must_alloc_slice(cfqq);
 		cfq_clear_cfqq_fifo_expire(cfqq);
+		cfq_clear_cfqq_dispatched(cfqq);
 		cfq_mark_cfqq_slice_new(cfqq);
 		cfq_clear_cfqq_queue_new(cfqq);
 	}
@@ -978,6 +981,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 */
 	if (timer_pending(&cfqd->idle_slice_timer) ||
 	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
+		cfq_mark_cfqq_dispatched(cfqq);
 		cfqq = NULL;
 		goto keep_queue;
 	}
@@ -1784,7 +1788,10 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		if (cfq_cfqq_wait_request(cfqq)) {
 			cfq_mark_cfqq_must_dispatch(cfqq);
 			del_timer(&cfqd->idle_slice_timer);
-			blk_start_queueing(cfqd->queue);
+			if (cfq_cfqq_dispatched(cfqq)) {
+				cfq_clear_cfqq_dispatched(cfqq);
+				cfq_schedule_dispatch(cfqd);
+			}
 		}
 	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
 		/*

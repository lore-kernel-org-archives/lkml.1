Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZKCU2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZKCU2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZKCU2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:28:32 -0500
Received: from [95.166.99.235] ([95.166.99.235]:53483 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZKCU2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:28:32 -0500
Date: Tue, 3 Nov 2009 21:28:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH 0/5] cfq-iosched: improve latency for no-idle
	queues (v3)
Message-ID: <20091103202836.GM8742@kernel.dk>
References: <x49zl7c268s.fsf@segfault.boston.devel.redhat.com> <4e5e476b0910271124r2cf9f9c0l83fdc59b50619202@mail.gmail.com> <x493a4wsn5c.fsf@segfault.boston.devel.redhat.com> <x49fx8wbqd0.fsf@segfault.boston.devel.redhat.com> <4e5e476b0911030042q5963718aj5875c542e6f6cc40@mail.gmail.com> <x49ocnju35d.fsf@segfault.boston.devel.redhat.com> <4e5e476b0911030719m425c208cg311f44a91fad8342@mail.gmail.com> <4e5e476b0911031035l7caffcb7n36b6eddd399864e7@mail.gmail.com> <20091103201802.GL8742@kernel.dk> <x49ocnjqrs5.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ocnjqrs5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > Since for-linus contains conflicting changes, can you and Jeff please
> > double check that everything is still in order? The interesting bit here
> > is the merge with for-2.6.33 and the coop limit from Shaohua Li. I did
> > the straight forward merge, but we likely just need to drop that logic
> > since the coop concept is radically different given that we merge and
> > break queues in for-2.6.33.
> 
> Yeah, since I changed the meaning of the cfqq_coop flag, a lot of those
> tests are just plain wrong.  Let me play with it and I'll send you an
> incremental patch in a bit.

Thanks, here's what I have. It's basically a revert of the commit in
question.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b700f41..4ab240c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -253,7 +253,6 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
-	CFQ_CFQQ_FLAG_coop_preempt,	/* coop preempt */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -280,7 +279,6 @@ CFQ_CFQQ_FNS(prio_changed);
 CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
-CFQ_CFQQ_FNS(coop_preempt);
 #undef CFQ_CFQQ_FNS
 
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
@@ -1070,16 +1068,9 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
 					      struct cfq_queue *cfqq)
 {
-	if (!cfqq) {
+	if (!cfqq)
 		cfqq = cfq_get_next_queue(cfqd);
 
-		if (cfqq && !cfq_cfqq_coop_preempt(cfqq))
-			cfq_clear_cfqq_coop(cfqq);
-	}
-
-	if (cfqq)
-		cfq_clear_cfqq_coop_preempt(cfqq);
-
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
@@ -2433,16 +2424,8 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	 * if this request is as-good as one we would expect from the
 	 * current cfqq, let it preempt
 	 */
-	if (cfq_rq_close(cfqd, cfqq, rq) && (!cfq_cfqq_coop(new_cfqq) ||
-	    cfqd->busy_queues == 1)) {
-		/*
-		 * Mark new queue coop_preempt, so its coop flag will not be
-		 * cleared when new queue gets scheduled at the very first time
-		 */
-		cfq_mark_cfqq_coop_preempt(new_cfqq);
-		cfq_mark_cfqq_coop(new_cfqq);
+	if (cfq_rq_close(cfqd, cfqq, rq))
 		return true;
-	}
 
 	return false;
 }

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbXLCJ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbXLCJ5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXLCJ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:57:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbXLCJ5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:57:40 -0500
Date: Mon, 3 Dec 2007 10:57:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203095719.GA23106@elte.hu>
References: <1196155985.25646.31.camel@ymzhang> <200712031527.57129.nickpiggin@yahoo.com.au> <20071203084557.GA13156@elte.hu> <200712032017.19661.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712032017.19661.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > as far as desktop apps such as firefox goes, the exact opposite is 
> > true. We had two choices basically: either a "more agressive" yield 
> > than before or a "less agressive" yield. Desktop apps were reported 
> > to hurt from a "more agressive" yield (firefox for example gets some 
> > pretty bad delays), so we defaulted to the less agressive method. 
> > (and we defaulted to that in v2.6.23 already)
> 
> Yeah, I doubt the 2.6.23 scheduler will be usable for distros 
> though...

... which is a pretty gross exaggeration belied by distros already 
running v2.6.23. Sure, "enterprise" distros might not run .23 (or .22 or 
.21 or .24) because those are slow to adopt and pick _one_ upstream 
kernel every 10 releases without bothering much about anything 
inbetween. So the enterprise distros might in fact want to see 1-2 
iterations of the scheduler before they switch to it. (But by that 
argument 80% of the other upstream kernels were not used by enterprise 
distros either, so this is nothing new.)

> I was just talking about the default because I didn't know the reason 
> for the way it was set -- now that I do, we should talk about trying 
> to improve the actual code so we don't need 2 defaults.

I've got the patch below queued up: it uses the more agressive yield 
implementation for SCHED_BATCH tasks. SCHED_BATCH is a natural 
differentiator, it's a "I dont care about latency, it's all about 
throughput for me" signal from the application.

But first and foremost, do you realize that there will be no easy 
solutions to this topic, that it's not just about 'flipping a default'?

	Ingo

-------------->
Subject: sched: default to more agressive yield for SCHED_BATCH tasks
From: Ingo Molnar <mingo@elte.hu>

do more agressive yield for SCHED_BATCH tasks.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -824,8 +824,9 @@ static void dequeue_task_fair(struct rq 
  */
 static void yield_task_fair(struct rq *rq)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(rq->curr);
-	struct sched_entity *rightmost, *se = &rq->curr->se;
+	struct task_struct *curr = rq->curr;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	struct sched_entity *rightmost, *se = &curr->se;
 
 	/*
 	 * Are we the only task in the tree?
@@ -833,7 +834,7 @@ static void yield_task_fair(struct rq *r
 	if (unlikely(cfs_rq->nr_running == 1))
 		return;
 
-	if (likely(!sysctl_sched_compat_yield)) {
+	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
 		__update_rq_clock(rq);
 		/*
 		 * Update run-time statistics of the 'current'.

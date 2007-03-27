Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbXC0TPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbXC0TPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934196AbXC0TPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:15:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192AbXC0TPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:15:08 -0400
Date: Tue, 27 Mar 2007 21:14:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] scheduler: strange behavor with massive interactive processes
Message-ID: <20070327191420.GB29929@elte.hu>
References: <87r6rb1nbm.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6rb1nbm.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:

> Hi Ingo and all,
> 
> When I was executing massive interactive processes, I found that some 
> of them occupy CPU time and the others hardly run.

yeah.

> I also attach the test program which easily recreates this problem.

thanks, this is really helpful - does the patch below improve the 
situation?

	Ingo

---------------------->
Subject: [patch] sched: improve starvation prevention
From: Ingo Molnar <mingo@elte.hu>

improve starvation prevention by guaranteeing STARVATION_LIMIT. This 
also simplifies the code a bit.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -235,7 +235,7 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	unsigned long expired_timestamp;
+	unsigned long switch_timestamp;
 	/* Cached timestamp set by update_cpu_clock() */
 	unsigned long long most_recent_timestamp;
 	struct task_struct *curr, *idle;
@@ -3103,9 +3103,9 @@ static inline int expired_starving(struc
 {
 	if (rq->curr->static_prio > rq->best_expired_prio)
 		return 1;
-	if (!STARVATION_LIMIT || !rq->expired_timestamp)
+	if (!STARVATION_LIMIT)
 		return 0;
-	if (jiffies - rq->expired_timestamp > STARVATION_LIMIT * rq->nr_running)
+	if (jiffies - rq->switch_timestamp > STARVATION_LIMIT)
 		return 1;
 	return 0;
 }
@@ -3218,8 +3218,6 @@ static void task_running_tick(struct rq 
 		p->time_slice = task_timeslice(p);
 		p->first_time_slice = 0;
 
-		if (!rq->expired_timestamp)
-			rq->expired_timestamp = jiffies;
 		if (!TASK_INTERACTIVE(p) || expired_starving(rq)) {
 			enqueue_task(p, rq->expired);
 			if (p->static_prio < rq->best_expired_prio)
@@ -3406,7 +3404,7 @@ need_resched_nonpreemptible:
 		idle_balance(cpu, rq);
 		if (!rq->nr_running) {
 			next = rq->idle;
-			rq->expired_timestamp = 0;
+			rq->switch_timestamp = jiffies;
 			goto switch_tasks;
 		}
 	}
@@ -3420,7 +3418,7 @@ need_resched_nonpreemptible:
 		rq->active = rq->expired;
 		rq->expired = array;
 		array = rq->active;
-		rq->expired_timestamp = 0;
+		rq->switch_timestamp = jiffies;
 		rq->best_expired_prio = MAX_PRIO;
 	}
 

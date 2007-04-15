Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbXDOQZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbXDOQZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXDOQZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:25:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbXDOQZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:25:22 -0400
Date: Sun, 15 Apr 2007 18:25:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>,
       Christoph Pfister <christophpfister@gmail.com>,
       Jurgen Kofler <kaffeine@gmx.net>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070415162508.GA4526@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704141809.58737.caglar@pardus.org.tr> <20070414160939.GB3099@elte.hu> <200704141959.50076.caglar@pardus.org.tr> <20070415161348.GA30625@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415161348.GA30625@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > [1] http://cekirdek.pardus.org.tr/~caglar/strace.kaffeine
> 
> thanks. This does has the appearance of a userspace race condition of 
> some sorts. Can you trigger this hang with the patch below applied to 
> the vanilla tree as well? (with no CFS patch applied)

oops, please use the patch below instead.

	Ingo

---
 kernel/sched.c |   69 ++++-----------------------------------------------------
 1 file changed, 5 insertions(+), 64 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1653,77 +1653,18 @@ void fastcall sched_fork(struct task_str
  */
 void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
-	struct rq *rq, *this_rq;
 	unsigned long flags;
-	int this_cpu, cpu;
+	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
-	this_cpu = smp_processor_id();
-	cpu = task_cpu(p);
-
-	/*
-	 * We decrease the sleep average of forking parents
-	 * and children as well, to keep max-interactive tasks
-	 * from forking tasks that are max-interactive. The parent
-	 * (current) is done further down, under its lock.
-	 */
-	p->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(p) *
-		CHILD_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
 
 	p->prio = effective_prio(p);
+	__activate_task(p, rq);
+	if (TASK_PREEMPTS_CURR(p, rq))
+		resched_task(rq->curr);
 
-	if (likely(cpu == this_cpu)) {
-		if (!(clone_flags & CLONE_VM)) {
-			/*
-			 * The VM isn't cloned, so we're in a good position to
-			 * do child-runs-first in anticipation of an exec. This
-			 * usually avoids a lot of COW overhead.
-			 */
-			if (unlikely(!current->array))
-				__activate_task(p, rq);
-			else {
-				p->prio = current->prio;
-				p->normal_prio = current->normal_prio;
-				list_add_tail(&p->run_list, &current->run_list);
-				p->array = current->array;
-				p->array->nr_active++;
-				inc_nr_running(p, rq);
-			}
-			set_need_resched();
-		} else
-			/* Run child last */
-			__activate_task(p, rq);
-		/*
-		 * We skip the following code due to cpu == this_cpu
-	 	 *
-		 *   task_rq_unlock(rq, &flags);
-		 *   this_rq = task_rq_lock(current, &flags);
-		 */
-		this_rq = rq;
-	} else {
-		this_rq = cpu_rq(this_cpu);
-
-		/*
-		 * Not the local CPU - must adjust timestamp. This should
-		 * get optimised away in the !CONFIG_SMP case.
-		 */
-		p->timestamp = (p->timestamp - this_rq->most_recent_timestamp)
-					+ rq->most_recent_timestamp;
-		__activate_task(p, rq);
-		if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
-
-		/*
-		 * Parent and child are on different CPUs, now get the
-		 * parent runqueue to update the parent's ->sleep_avg:
-		 */
-		task_rq_unlock(rq, &flags);
-		this_rq = task_rq_lock(current, &flags);
-	}
-	current->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(current) *
-		PARENT_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
-	task_rq_unlock(this_rq, &flags);
+	task_rq_unlock(rq, &flags);
 }
 
 /*

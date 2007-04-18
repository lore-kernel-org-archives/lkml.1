Return-Path: <linux-kernel-owner+w=401wt.eu-S2992789AbXDRQPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992789AbXDRQPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992793AbXDRQPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:15:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992789AbXDRQPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:15:19 -0400
Date: Wed, 18 Apr 2007 18:14:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: "S.??a??lar Onur" <caglar@pardus.org.tr>,
       Christoph Pfister <christophpfister@gmail.com>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418161459.GA21351@elte.hu>
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com> <19a3b7a80704180621m1b343b4eif02a7930a5edf2fc@mail.gmail.com> <200704181625.51389.caglar@pardus.org.tr> <20070418154811.GA16842@elte.hu> <20070418160722.GB31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418160722.GB31925@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> At this point you might as well call the requeue operation something 
> having to do with yield. [...]

agreed - i've just done a requeue_task -> yield_task rename in my tree. 
(patch below)

> [...] I also suspect what goes on during the timer tick may eventually 
> become something different from requeueing the current task, and 
> furthermore class-dependent.

it already is, scheduler tick processing is done in class->task_tick().

	Ingo

---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |    7 +------
 kernel/sched_fair.c   |    4 ++--
 kernel/sched_rt.c     |    2 +-
 4 files changed, 5 insertions(+), 10 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -796,7 +796,7 @@ struct sched_class {
 
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p);
-	void (*requeue_task) (struct rq *rq, struct task_struct *p);
+	void (*yield_task) (struct rq *rq, struct task_struct *p);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -560,11 +560,6 @@ static void dequeue_task(struct rq *rq, 
 	p->on_rq = 0;
 }
 
-static void requeue_task(struct rq *rq, struct task_struct *p)
-{
-	p->sched_class->requeue_task(rq, p);
-}
-
 /*
  * __normal_prio - return the priority that is based on the static prio
  */
@@ -3773,7 +3768,7 @@ asmlinkage long sys_sched_yield(void)
 	schedstat_inc(rq, yld_cnt);
 	if (rq->nr_running == 1)
 		schedstat_inc(rq, yld_act_empty);
-	requeue_task(rq, current);
+	current->sched_class->yield_task(rq, current);
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -273,7 +273,7 @@ static void dequeue_task_fair(struct rq 
  * dequeue the task and move it to the rightmost position, which
  * causes the task to roundrobin to the end of the tree.
  */
-static void requeue_task_fair(struct rq *rq, struct task_struct *p)
+static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
 	dequeue_task_fair(rq, p);
 	p->on_rq = 0;
@@ -509,7 +509,7 @@ static void task_init_fair(struct rq *rq
 struct sched_class fair_sched_class __read_mostly = {
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
-	.requeue_task		= requeue_task_fair,
+	.yield_task		= yield_task_fair,
 
 	.check_preempt_curr	= check_preempt_curr_fair,
 
Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c
+++ linux/kernel/sched_rt.c
@@ -165,7 +165,7 @@ static void task_init_rt(struct rq *rq, 
 static struct sched_class rt_sched_class __read_mostly = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
-	.requeue_task		= requeue_task_rt,
+	.yield_task		= requeue_task_rt,
 
 	.check_preempt_curr	= check_preempt_curr_rt,
 

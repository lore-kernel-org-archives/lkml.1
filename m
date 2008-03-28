Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYC1Jnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYC1Jnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYC1Jnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:43:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbYC1Jno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:43:44 -0400
Date: Fri, 28 Mar 2008 10:43:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080328094326.GE30863@elte.hu>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <20080327203927.GA19968@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327203927.GA19968@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Let's compare one marker against one ftrace statement in sched.o on 
> the sched-dev tree on x86_32 and see where your "bloat" impression 
> about markers comes from. I think it's mostly due to the different 
> metrics we use.
> 
> sched.o w/o CONFIG_CONTEXT_SWITCH_TRACER
>    text    data     bss     dec     hex filename
>   46564    2924     200   49688    c218 kernel/sched.o
> 
> Let's get an idea of CONFIG_CONTEXT_SWITCH_TRACER impact on sched.o :
> 
> sched.o with CONFIG_CONTEXT_SWITCH_TRACER
> 
>   text    data     bss     dec     hex filename
>   46788    2924     200   49912    c2f8 kernel/sched.o
> 
> 224 bytes added for 6 ftrace_*(). This is partly due to the helper function
> ftrace_all_fair_tasks(). So let's be fair and not take it in account.

it's not 6 ftrace calls, you forgot about kernel/sched_fair.c, so it's 9 
tracepoints.

note that all but the 2 core trace hooks are temporary, i used them to 
debug a specific scheduler problem. Especially one trace point: 
ftrace_all_fair_tasks() is a totally ad-hoc trace-all-tasks-in-the-rq 
heavy function.

if you want to compare apples to apples, try the patch below, which 
removes the ad-hoc tracepoints.

	Ingo

------------------------>
Subject: no: ad hoc ftrace points
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Mar 28 10:30:37 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   47 -----------------------------------------------
 kernel/sched_fair.c |    3 ---
 2 files changed, 50 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -2005,53 +2005,6 @@ static int sched_balance_self(int cpu, i
 
 #endif /* CONFIG_SMP */
 
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
-
-void ftrace_task(struct task_struct *p, void *__tr, void *__data)
-{
-#if 0
-	/*  
-	 * trace timeline tree
-	 */
-	__trace_special(__tr, __data,
-			p->pid, p->se.vruntime, p->se.sum_exec_runtime);
-#else
-	/*
-	 * trace balance metrics
-	 */
-	__trace_special(__tr, __data,
-			p->pid, p->se.avg_overlap, 0);
-#endif
-}
-
-void ftrace_all_fair_tasks(void *__rq, void *__tr, void *__data)
-{
-	struct task_struct *p;
-	struct sched_entity *se;
-	struct rb_node *curr;
-	struct rq *rq = __rq;
-
-	if (rq->cfs.curr) {
-		p = task_of(rq->cfs.curr);
-		ftrace_task(p, __tr, __data);
-	}
-	if (rq->cfs.next) {
-		p = task_of(rq->cfs.next);
-		ftrace_task(p, __tr, __data);
-	}
-
-	for (curr = first_fair(&rq->cfs); curr; curr = rb_next(curr)) {
-		se = rb_entry(curr, struct sched_entity, run_node);
-		if (!entity_is_task(se))
-			continue;
-
-		p = task_of(se);
-		ftrace_task(p, __tr, __data);
-	}
-}
-
-#endif
-
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -991,8 +991,6 @@ wake_affine(struct rq *rq, struct sched_
 	if (!(this_sd->flags & SD_WAKE_AFFINE))
 		return 0;
 
-	ftrace_special(__LINE__, curr->se.avg_overlap, sync);
-	ftrace_special(__LINE__, p->se.avg_overlap, -1);
 	/*
 	 * If the currently running task will sleep within
 	 * a reasonable amount of time then attract this newly
@@ -1118,7 +1116,6 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(se == pse))
 		return;
 
-	ftrace_special(__LINE__, p->pid, se->last_wakeup);
 	cfs_rq_of(pse)->next = pse;
 
 	/*

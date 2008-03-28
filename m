Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYC1LiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYC1LiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYC1LiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:38:10 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:46363 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753235AbYC1LiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:38:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFAAN17EdMQWoK/2dsb2JhbACBWqlI
Date: Fri, 28 Mar 2008 07:38:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080328113805.GA1259@Krystal>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <20080327203927.GA19968@Krystal> <20080328094326.GE30863@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080328094326.GE30863@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:29:46 up 28 days,  7:40,  4 users,  load average: 0.30, 0.59,
	0.66
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Let's compare one marker against one ftrace statement in sched.o on 
> > the sched-dev tree on x86_32 and see where your "bloat" impression 
> > about markers comes from. I think it's mostly due to the different 
> > metrics we use.
> > 
> > sched.o w/o CONFIG_CONTEXT_SWITCH_TRACER
> >    text    data     bss     dec     hex filename
> >   46564    2924     200   49688    c218 kernel/sched.o
> > 
> > Let's get an idea of CONFIG_CONTEXT_SWITCH_TRACER impact on sched.o :
> > 
> > sched.o with CONFIG_CONTEXT_SWITCH_TRACER
> > 
> >   text    data     bss     dec     hex filename
> >   46788    2924     200   49912    c2f8 kernel/sched.o
> > 
> > 224 bytes added for 6 ftrace_*(). This is partly due to the helper function
> > ftrace_all_fair_tasks(). So let's be fair and not take it in account.
> 
> it's not 6 ftrace calls, you forgot about kernel/sched_fair.c, so it's 9 
> tracepoints.
> 
> note that all but the 2 core trace hooks are temporary, i used them to 
> debug a specific scheduler problem. Especially one trace point: 
> ftrace_all_fair_tasks() is a totally ad-hoc trace-all-tasks-in-the-rq 
> heavy function.
> 
> if you want to compare apples to apples, try the patch below, which 
> removes the ad-hoc tracepoints.
> 

Hrm, you are only quoting my introduction, where I introduce the reason
why I do in a more in-depth analysis on a _single_ ftrace statement.

Ingo, if you care to read the rest of my email, you will discover that I
concentrated my effort on a single ftrace statement in context_switch().
Whether or not I removed the trace points from kernel/sched_fair.c does
not change the validity of the results that follow. I commented out your
ad-hoc tracepoints from sched.c by hand in my test cases, and
sched_fair.c trace points were there in every scenario, so they were
invariant and _not_ considered, except in this introduction you quoted.

Mathieu

> 	Ingo
> 
> ------------------------>
> Subject: no: ad hoc ftrace points
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri Mar 28 10:30:37 CET 2008
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c      |   47 -----------------------------------------------
>  kernel/sched_fair.c |    3 ---
>  2 files changed, 50 deletions(-)
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -2005,53 +2005,6 @@ static int sched_balance_self(int cpu, i
>  
>  #endif /* CONFIG_SMP */
>  
> -#ifdef CONFIG_CONTEXT_SWITCH_TRACER
> -
> -void ftrace_task(struct task_struct *p, void *__tr, void *__data)
> -{
> -#if 0
> -	/*  
> -	 * trace timeline tree
> -	 */
> -	__trace_special(__tr, __data,
> -			p->pid, p->se.vruntime, p->se.sum_exec_runtime);
> -#else
> -	/*
> -	 * trace balance metrics
> -	 */
> -	__trace_special(__tr, __data,
> -			p->pid, p->se.avg_overlap, 0);
> -#endif
> -}
> -
> -void ftrace_all_fair_tasks(void *__rq, void *__tr, void *__data)
> -{
> -	struct task_struct *p;
> -	struct sched_entity *se;
> -	struct rb_node *curr;
> -	struct rq *rq = __rq;
> -
> -	if (rq->cfs.curr) {
> -		p = task_of(rq->cfs.curr);
> -		ftrace_task(p, __tr, __data);
> -	}
> -	if (rq->cfs.next) {
> -		p = task_of(rq->cfs.next);
> -		ftrace_task(p, __tr, __data);
> -	}
> -
> -	for (curr = first_fair(&rq->cfs); curr; curr = rb_next(curr)) {
> -		se = rb_entry(curr, struct sched_entity, run_node);
> -		if (!entity_is_task(se))
> -			continue;
> -
> -		p = task_of(se);
> -		ftrace_task(p, __tr, __data);
> -	}
> -}
> -
> -#endif
> -
>  /***
>   * try_to_wake_up - wake up a thread
>   * @p: the to-be-woken-up thread
> Index: linux/kernel/sched_fair.c
> ===================================================================
> --- linux.orig/kernel/sched_fair.c
> +++ linux/kernel/sched_fair.c
> @@ -991,8 +991,6 @@ wake_affine(struct rq *rq, struct sched_
>  	if (!(this_sd->flags & SD_WAKE_AFFINE))
>  		return 0;
>  
> -	ftrace_special(__LINE__, curr->se.avg_overlap, sync);
> -	ftrace_special(__LINE__, p->se.avg_overlap, -1);
>  	/*
>  	 * If the currently running task will sleep within
>  	 * a reasonable amount of time then attract this newly
> @@ -1118,7 +1116,6 @@ static void check_preempt_wakeup(struct 
>  	if (unlikely(se == pse))
>  		return;
>  
> -	ftrace_special(__LINE__, p->pid, se->last_wakeup);
>  	cfs_rq_of(pse)->next = pse;
>  
>  	/*

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

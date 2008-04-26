Return-Path: <linux-kernel-owner+w=401wt.eu-S1762522AbYDZULZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762522AbYDZULZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbYDZULR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:11:17 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:44751 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759196AbYDZULQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:11:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoFADIpE0hMROPA/2dsb2JhbACBU6hV
Date: Sat, 26 Apr 2008 16:11:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
	sched-devel.git
Message-ID: <20080426201114.GA24798@Krystal>
References: <20080424150324.802695381@polymtl.ca> <1209238735.6441.4.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1209238735.6441.4.camel@lappy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:01:55 up 57 days, 16:12,  5 users,  load average: 0.36, 0.38,
	0.46
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Thu, 2008-04-24 at 11:03 -0400, Mathieu Desnoyers wrote:
> > Hi Ingo,
> > 
> > Here is a rather large patchset applying kernel instrumentation to
> > sched-devel.git. It includes, mainly :
> 
> I saw this land in sched-devel, how about this:
> 

I think the main reason why those markers are ugly is they have
information meant for use by a general purpose tracer (it will only take
the parameters before the ## signs).

The other way around is to start specializing the general purpose tracer
to extract the information it needs from the task and rq pointers and
put that in the traces. Actually, that's the approach I use currently
use in LTTng, but Ingo seemed interested to have the union of parameters
needed by specialized and GP tracers, so this is what I did.

The only thing I dislike with the approach of putting everything in a
separatered header is that it adds a layer of indirection when one try
to to quickly grep for trace_mark() in the kernel tree to see where the
conceptual tracing points are. Therefore, it might be interesting to
simply remove the parameters meant for the general purpose tracer and
let this GP tracer create specialized probes for these instrumentation
sites. It would therefore remove the ugliness without creating a
supplementary indirection layer.

Mathieu

> ---
> Subject: sched: de-uglyfy marker impact
> 
> These trace_mark() things look like someone puked all over the code,
> lets hide the ugly bits.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c       |   24 ++++++++----------------
>  kernel/sched_trace.h |   41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 16 deletions(-)
> 
> Index: linux-2.6-2/kernel/sched.c
> ===================================================================
> --- linux-2.6-2.orig/kernel/sched.c
> +++ linux-2.6-2/kernel/sched.c
> @@ -71,7 +71,6 @@
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
> -#include <linux/marker.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -745,6 +744,8 @@ static void update_rq_clock(struct rq *r
>  #define task_rq(p)		cpu_rq(task_cpu(p))
>  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
>  
> +#include "sched_trace.h"
> +
>  /*
>   * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
>   */
> @@ -2258,8 +2259,7 @@ void wait_task_inactive(struct task_stru
>  		 * just go back and repeat.
>  		 */
>  		rq = task_rq_lock(p, &flags);
> -		trace_mark(kernel_sched_wait_task, "pid %d state %ld",
> -			p->pid, p->state);
> +		trace_kernel_sched_wait(p);
>  		running = task_running(rq, p);
>  		on_rq = p->se.on_rq;
>  		task_rq_unlock(rq, &flags);
> @@ -2603,9 +2603,7 @@ out_activate:
>  	success = 1;
>  
>  out_running:
> -	trace_mark(kernel_sched_wakeup,
> -		"pid %d state %ld ## rq %p task %p rq->curr %p",
> -		p->pid, p->state, rq, p, rq->curr);
> +	trace_kernel_sched_wakeup(rq, p);
>  	check_preempt_curr(rq, p);
>  
>  	p->state = TASK_RUNNING;
> @@ -2736,9 +2734,7 @@ void wake_up_new_task(struct task_struct
>  		p->sched_class->task_new(rq, p);
>  		inc_nr_running(rq);
>  	}
> -	trace_mark(kernel_sched_wakeup_new,
> -		"pid %d state %ld ## rq %p task %p rq->curr %p",
> -		p->pid, p->state, rq, p, rq->curr);
> +	trace_kernel_sched_wakeup_new(rq, p);
>  	check_preempt_curr(rq, p);
>  #ifdef CONFIG_SMP
>  	if (p->sched_class->task_wake_up)
> @@ -2911,11 +2907,8 @@ context_switch(struct rq *rq, struct tas
>  	struct mm_struct *mm, *oldmm;
>  
>  	prepare_task_switch(rq, prev, next);
> -	trace_mark(kernel_sched_schedule,
> -		"prev_pid %d next_pid %d prev_state %ld "
> -		"## rq %p prev %p next %p",
> -		prev->pid, next->pid, prev->state,
> -		rq, prev, next);
> +
> +	trace_kernel_sched_switch(rq, prev, next);
>  	mm = next->mm;
>  	oldmm = prev->active_mm;
>  	/*
> @@ -3148,8 +3141,7 @@ static void sched_migrate_task(struct ta
>  	    || unlikely(cpu_is_offline(dest_cpu)))
>  		goto out;
>  
> -	trace_mark(kernel_sched_migrate_task, "pid %d state %ld dest_cpu %d",
> -		p->pid, p->state, dest_cpu);
> +	trace_kernel_sched_migrate_task(p, cpu_of(rq), dest_cpu);
>  	/* force the process onto the specified CPU */
>  	if (migrate_task(p, dest_cpu, &req)) {
>  		/* Need to wait for migration thread (might exit: take ref). */
> Index: linux-2.6-2/kernel/sched_trace.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6-2/kernel/sched_trace.h
> @@ -0,0 +1,41 @@
> +#include <linux/marker.h>
> +
> +static inline void trace_kernel_sched_wait(struct task_struct *p)
> +{
> +	trace_mark(kernel_sched_wait_task, "pid %d state %ld",
> +			p->pid, p->state);
> +}
> +
> +static inline
> +void trace_kernel_sched_wakeup(struct rq *rq, struct task_struct *p)
> +{
> +	trace_mark(kernel_sched_wakeup,
> +			"pid %d state %ld ## rq %p task %p rq->curr %p",
> +			p->pid, p->state, rq, p, rq->curr);
> +}
> +
> +static inline
> +void trace_kernel_sched_wakeup_new(struct rq *rq, struct task_struct *p)
> +{
> +	trace_mark(kernel_sched_wakeup_new,
> +			"pid %d state %ld ## rq %p task %p rq->curr %p",
> +			p->pid, p->state, rq, p, rq->curr);
> +}
> +
> +static inline void trace_kernel_sched_switch(struct rq *rq,
> +		struct task_struct *prev, struct task_struct *next)
> +{
> +	trace_mark(kernel_sched_schedule,
> +			"prev_pid %d next_pid %d prev_state %ld "
> +			"## rq %p prev %p next %p",
> +			prev->pid, next->pid, prev->state,
> +			rq, prev, next);
> +}
> +
> +static inline void
> +trace_kernel_sched_migrate_task(struct task_struct *p, int src, int dst)
> +{
> +	trace_mark(kernel_sched_migrate_task,
> +			"pid %d state %ld dest_cpu %d",
> +			p->pid, p->state, dst);
> +}
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

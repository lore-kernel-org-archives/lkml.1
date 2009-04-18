Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZDRHLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZDRHLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZDRHL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:11:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZDRHLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:11:25 -0400
Date: Sat, 18 Apr 2009 09:11:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/5] tracing: add same level recursion detection
Message-ID: <20090418071111.GB7678@elte.hu>
References: <20090417211135.408179566@goodmis.org> <20090417211231.218150513@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417211231.218150513@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The tracing infrastructure allows for recursion. That is, an interrupt
> may interrupt the act of tracing an event, and that interrupt may very well
> perform its own trace. This is a recursive trace, and is fine to do.
> 
> The problem arises when there is a bug, and the utility doing the trace
> calls something that recurses back into the tracer. This recursion is not
> caused by an external event like an interrupt, but by code that is not
> expected to recurse. The result could be a lockup.
> 
> This patch adds a bitmask to the task structure that keeps track
> of the trace recursion. To find the interrupt depth, the following
> algorithm is used:
> 
>   level = hardirq_count() + softirq_count() + in_nmi;
> 
> Here, level will be the depth of interrutps and softirqs, and even handles
> the nmi. Then the corresponding bit is set in the recursion bitmask.
> If the bit was already set, we know we had a recursion at the same level
> and we warn about it and fail the writing to the buffer.
> 
> After the data has been committed to the buffer, we clear the bit.
> No atomics are needed. The only races are with interrupts and they reset
> the bitmask before returning anywy.
> 
> [ Impact: detect same irq level trace recursion ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace.h     |    7 +++++++
>  include/linux/init_task.h  |    1 +
>  include/linux/sched.h      |    4 +++-
>  kernel/trace/ring_buffer.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 53 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 97c83e1..39b95c5 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -488,8 +488,15 @@ static inline int test_tsk_trace_graph(struct task_struct *tsk)
>  
>  extern int ftrace_dump_on_oops;
>  
> +#ifdef CONFIG_PREEMPT
> +#define INIT_TRACE_RECURSION		.trace_recursion = 0,
> +#endif
> +
>  #endif /* CONFIG_TRACING */
>  
> +#ifndef INIT_TRACE_RECURSION
> +#define INIT_TRACE_RECURSION
> +#endif
>  
>  #ifdef CONFIG_HW_BRANCH_TRACER
>  
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index dcfb933..6fc2185 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -187,6 +187,7 @@ extern struct cred init_cred;
>  	INIT_TRACE_IRQFLAGS						\
>  	INIT_LOCKDEP							\
>  	INIT_FTRACE_GRAPH						\
> +	INIT_TRACE_RECURSION						\
>  }
>  
>  
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b4c38bc..7ede5e4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1428,7 +1428,9 @@ struct task_struct {
>  #ifdef CONFIG_TRACING
>  	/* state flags for use by tracers */
>  	unsigned long trace;
> -#endif
> +	/* bitmask of trace recursion */
> +	unsigned long trace_recursion;
> +#endif /* CONFIG_TRACING */
>  };
>  
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 84a6055..b421b0e 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1481,6 +1481,40 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
>  	return event;
>  }
>  
> +static int trace_irq_level(void)
> +{
> +	return hardirq_count() + softirq_count() + in_nmi();
> +}
> +
> +static int trace_recursive_lock(void)
> +{
> +	int level;
> +
> +	level = trace_irq_level();
> +
> +	if (unlikely(current->trace_recursion & (1 << level))) {
> +		/* Disable all tracing before we do anything else */
> +		tracing_off_permanent();
> +		WARN_ON_ONCE(1);
> +		return -1;
> +	}
> +
> +	current->trace_recursion |= 1 << level;
> +
> +	return 0;
> +}
> +
> +static void trace_recursive_unlock(void)
> +{
> +	int level;
> +
> +	level = trace_irq_level();
> +
> +	WARN_ON_ONCE(!current->trace_recursion & (1 << level));
> +
> +	current->trace_recursion &= ~(1 << level);
> +}
> +
>  static DEFINE_PER_CPU(int, rb_need_resched);
>  
>  /**
> @@ -1514,6 +1548,9 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
>  	/* If we are tracing schedule, we don't want to recurse */
>  	resched = ftrace_preempt_disable();
>  
> +	if (trace_recursive_lock())
> +		goto out_nocheck;

This is obviously a good idea, but i'm nervous about two things 
here: overhead and placement.

Firstly, the lock/unlock sequence adds to the critical path of all 
the tracing infrastructure and makes it slower. Secondly, we do this 
in ring_buffer_lock_reserve() only - instead of doing it at the 
outmost layer (where recursion protection is the most effective).

So while i've pulled it, it would be nice to rework the concepts 
here comprehensively. We have a number of atomics, layers, checks, 
and all that adds overhead and complexity.

The best would be to just face it and disable IRQs via 
raw_local_irq_save() plus set the trace recursion flag - and do this 
around all trace point facilities and as early as possible (they are 
not allowed to sleep anyway).

That would remove many of the "what if an IRQ recurses" uglinesses. 
CLI/POPF pairs are also very fast on most architectures (a lot of 
performance-sensitive code in Linux depends on that). This would 
also improve the end result: IRQs would not mix up the order of 
trace records occasionally.

	Ingo

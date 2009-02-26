Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZBZRxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZBZRxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZBZRxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:53:11 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:59857 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZBZRxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jU3btDnLulvjEvwtm2gGfnSlSFbEgMbGKPajaspSXzvxm6yuNnLVZJX+Bk2BuqgYms
         wIBjptmPKWpUu82H2MfcIo+7XM1oZ4ltCeuchsZ9ABpgunWz0KMV9XV044arp0QH1hM2
         zcpIGFj+dV8mDr/cmDfd7w3LL9mPvHr0ldVc0=
Date: Thu, 26 Feb 2009 18:53:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: hpa@zytor.com, mingo@redhat.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] tracing: implement trace_clock_*() APIs
Message-ID: <20090226175302.GD5889@nowhere>
References: <tip-14131f2f98ac350ee9e73faed916d2238a8b6a0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-14131f2f98ac350ee9e73faed916d2238a8b6a0d@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 05:45:48PM +0000, Ingo Molnar wrote:
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Thu, 26 Feb 2009 18:47:11 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 26 Feb 2009 18:44:06 +0100
> 
> tracing: implement trace_clock_*() APIs
> 
> Impact: implement new tracing timestamp APIs
> 
> Add three trace clock variants, with differing scalability/precision
> tradeoffs:
> 
>  -   local: CPU-local trace clock
>  -  medium: scalable global clock with some jitter
>  -  global: globally monotonic, serialized clock
> 
> Make the ring-buffer use the local trace clock internally.
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  include/linux/trace_clock.h |   19 ++++++++
>  kernel/trace/Makefile       |    1 +
>  kernel/trace/ring_buffer.c  |    5 +-
>  kernel/trace/trace_clock.c  |  101 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 123 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
> new file mode 100644
> index 0000000..7a81303
> --- /dev/null
> +++ b/include/linux/trace_clock.h
> @@ -0,0 +1,19 @@
> +#ifndef _LINUX_TRACE_CLOCK_H
> +#define _LINUX_TRACE_CLOCK_H
> +
> +/*
> + * 3 trace clock variants, with differing scalability/precision
> + * tradeoffs:
> + *
> + *  -   local: CPU-local trace clock
> + *  -  medium: scalable global clock with some jitter
> + *  -  global: globally monotonic, serialized clock
> + */
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +extern u64 notrace trace_clock_local(void);
> +extern u64 notrace trace_clock(void);
> +extern u64 notrace trace_clock_global(void);
> +
> +#endif /* _LINUX_TRACE_CLOCK_H */
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 664b6c0..c931fe0 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
>  obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
>  
>  obj-$(CONFIG_TRACING) += trace.o
> +obj-$(CONFIG_TRACING) += trace_clock.o
>  obj-$(CONFIG_TRACING) += trace_output.o
>  obj-$(CONFIG_TRACING) += trace_stat.o
>  obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 8f19f1a..a8c275c 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
>   */
>  #include <linux/ring_buffer.h>
> +#include <linux/trace_clock.h>
>  #include <linux/ftrace_irq.h>
>  #include <linux/spinlock.h>
>  #include <linux/debugfs.h>
> @@ -12,7 +13,6 @@
>  #include <linux/module.h>
>  #include <linux/percpu.h>
>  #include <linux/mutex.h>
> -#include <linux/sched.h>	/* used for sched_clock() (for now) */
>  #include <linux/init.h>
>  #include <linux/hash.h>
>  #include <linux/list.h>
> @@ -112,14 +112,13 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
>  /* Up this if you want to test the TIME_EXTENTS and normalization */
>  #define DEBUG_SHIFT 0
>  
> -/* FIXME!!! */
>  u64 ring_buffer_time_stamp(int cpu)
>  {
>  	u64 time;
>  
>  	preempt_disable_notrace();
>  	/* shift to debug/test normalization and TIME_EXTENTS */
> -	time = sched_clock() << DEBUG_SHIFT;
> +	time = trace_clock_local() << DEBUG_SHIFT;
>  	preempt_enable_no_resched_notrace();
>  
>  	return time;
> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> new file mode 100644
> index 0000000..2d4953f
> --- /dev/null
> +++ b/kernel/trace/trace_clock.c
> @@ -0,0 +1,101 @@
> +/*
> + * tracing clocks
> + *
> + *  Copyright (C) 2009 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> + *
> + * Implements 3 trace clock variants, with differing scalability/precision
> + * tradeoffs:
> + *
> + *  -   local: CPU-local trace clock
> + *  -  medium: scalable global clock with some jitter
> + *  -  global: globally monotonic, serialized clock
> + *
> + * Tracer plugins will chose a default from these clocks.
> + */
> +#include <linux/spinlock.h>
> +#include <linux/hardirq.h>
> +#include <linux/module.h>
> +#include <linux/percpu.h>
> +#include <linux/sched.h>
> +#include <linux/ktime.h>
> +
> +/*
> + * trace_clock_local(): the simplest and least coherent tracing clock.
> + *
> + * Useful for tracing that does not cross to other CPUs nor
> + * does it go through idle events.
> + */
> +u64 notrace trace_clock_local(void)
> +{
> +	/*
> +	 * sched_clock() is an architecture implemented, fast, scalable,
> +	 * lockless clock. It is not guaranteed to be coherent across
> +	 * CPUs, nor across CPU idle events.
> +	 */
> +	return sched_clock();
> +}
> +
> +/*
> + * trace_clock(): 'inbetween' trace clock. Not completely serialized,
> + * but not completely incorrect when crossing CPUs either.
> + *
> + * This is based on cpu_clock(), which will allow at most ~1 jiffy of
> + * jitter between CPUs. So it's a pretty scalable clock, but there
> + * can be offsets in the trace data.
> + */
> +u64 notrace trace_clock(void)
> +{
> +	return cpu_clock(raw_smp_processor_id());
> +}
> +
> +
> +/*
> + * trace_clock_global(): special globally coherent trace clock
> + *
> + * It has higher overhead than the other trace clocks but is still
> + * an order of magnitude faster than GTOD derived hardware clocks.
> + *
> + * Used by plugins that need globally coherent timestamps.
> + */
> +
> +static u64 prev_trace_clock_time;
> +
> +static raw_spinlock_t trace_clock_lock ____cacheline_aligned_in_smp =
> +	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
> +
> +u64 notrace trace_clock_global(void)
> +{
> +	unsigned long flags;
> +	int this_cpu;
> +	u64 now;
> +
> +	raw_local_irq_save(flags);
> +
> +	this_cpu = raw_smp_processor_id();
> +	now = cpu_clock(this_cpu);
> +	/*
> +	 * If in an NMI context then dont risk lockups and return the
> +	 * cpu_clock() time:
> +	 */
> +	if (unlikely(in_nmi()))
> +		goto out;
> +
> +	__raw_spin_lock(&trace_clock_lock);
> +
> +	/*
> +	 * TODO: if this happens often then maybe we should reset
> +	 * my_scd->clock to prev_trace_clock_time+1, to make sure
> +	 * we start ticking with the local clock from now on?
> +	 */
> +	if ((s64)(now - prev_trace_clock_time) < 0)
> +		now = prev_trace_clock_time + 1;
> +
> +	prev_trace_clock_time = now;
> +
> +	__raw_spin_unlock(&trace_clock_lock);
> +
> + out:
> +	raw_local_irq_restore(flags);
> +
> +	return now;
> +}


Hi,

I missed this one.

Wouldn't your previous idea of a cmpxchg global clock be better?
Perhaps it would scale better while tracing on many cpus.

Anyway, it's something less in my TODO list :-)


> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


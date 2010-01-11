Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502Ab0AKRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0AKRvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 12:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271Ab0AKRvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 12:51:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:49205 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab0AKRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 12:51:17 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v3a)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100111042903.GC32213@Krystal>
References: <20100110000318.GD9044@linux.vnet.ibm.com>
	 <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal>
	 <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com>
	 <1263124209.28171.3798.camel@gandalf.stny.rr.com>
	 <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal>
	 <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal>
	 <20100111042903.GC32213@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 18:50:40 +0100
Message-ID: <1263232240.4244.70.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 23:29 -0500, Mathieu Desnoyers wrote:
> Here is an implementation of a new system call, sys_membarrier(), which
> executes a memory barrier on all threads of the current process.

Please start a new thread for new versions, I really didn't find this
until I started reading in date order instead of thread order.


> Index: linux-2.6-lttng/arch/x86/include/asm/unistd_64.h
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/include/asm/unistd_64.h	2010-01-10 19:21:31.000000000 -0500
> +++ linux-2.6-lttng/arch/x86/include/asm/unistd_64.h	2010-01-10 19:21:37.000000000 -0500
> @@ -661,6 +661,8 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
>  __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
>  #define __NR_perf_event_open			298
>  __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
> +#define __NR_membarrier				299
> +__SYSCALL(__NR_membarrier, sys_membarrier)
>  
>  #ifndef __NO_STUBS
>  #define __ARCH_WANT_OLD_READDIR
> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-10 19:21:31.000000000 -0500
> +++ linux-2.6-lttng/kernel/sched.c	2010-01-10 22:22:40.000000000 -0500
> @@ -2861,12 +2861,26 @@ context_switch(struct rq *rq, struct tas
>  	 */
>  	arch_start_context_switch(prev);
>  
> +	/*
> +	 * sys_membarrier IPI-mb scheme requires a memory barrier between
> +	 * user-space thread execution and update to mm_cpumask.
> +	 */
> +	if (likely(oldmm) && likely(oldmm != mm))
> +		smp_mb__before_clear_bit();
> +
>  	if (unlikely(!mm)) {
>  		next->active_mm = oldmm;
>  		atomic_inc(&oldmm->mm_count);
>  		enter_lazy_tlb(oldmm, next);
> -	} else
> +	} else {
>  		switch_mm(oldmm, mm, next);
> +		/*
> +		 * sys_membarrier IPI-mb scheme requires a memory barrier
> +		 * between update to mm_cpumask and user-space thread execution.
> +		 */
> +		if (likely(oldmm != mm))
> +			smp_mb__after_clear_bit();
> +	}
>  
>  	if (unlikely(!prev->mm)) {
>  		prev->active_mm = NULL;
> @@ -10822,6 +10836,49 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
>  
> +/*
> + * Execute a memory barrier on all active threads from the current process
> + * on SMP systems. Do not rely on implicit barriers in
> + * smp_call_function_many(), just in case they are ever relaxed in the future.
> + */
> +static void membarrier_ipi(void *unused)
> +{
> +	smp_mb();
> +}
> +
> +/*
> + * sys_membarrier - issue memory barrier on current process running threads
> + *
> + * Execute a memory barrier on all running threads of the current process.
> + * Upon completion, the caller thread is ensured that all process threads
> + * have passed through a state where memory accesses match program order.
> + * (non-running threads are de facto in such a state)
> + */
> +SYSCALL_DEFINE0(membarrier)
> +{
> +#ifdef CONFIG_SMP
> +	if (unlikely(thread_group_empty(current)))
> +		return 0;
> +	/*
> +	 * Memory barrier on the caller thread _before_ sending first
> +	 * IPI. Matches memory barriers around mm_cpumask modification in
> +	 * context_switch().
> +	 */
> +	smp_mb();
> +	preempt_disable();
> +	smp_call_function_many(mm_cpumask(current->mm), membarrier_ipi,
> +			       NULL, 1);
> +	preempt_enable();
> +	/*
> +	 * Memory barrier on the caller thread _after_ we finished
> +	 * waiting for the last IPI. Matches memory barriers around mm_cpumask
> +	 * modification in context_switch().
> +	 */
> +	smp_mb();
> +#endif	/* #ifdef CONFIG_SMP */
> +	return 0;
> +}
> +
>  #ifndef CONFIG_SMP
>  
>  int rcu_expedited_torture_stats(char *page)

Right, so here you rely on the arch switch_mm() implementation to keep
mm_cpumask() current, but then stick a memory barrier in the generic
code... seems odd.

x86 switch_mm() does indeed keep it current, but writing cr3 is also a
rather serializing instruction.

Furthermore, do we really need that smp_mb() in the membarrier_ipi()
function? Shouldn't we investigate if either:
 - receiving an IPI implies an mb, or
 - enter/leave kernelspace implies an mb
?

So while I much like the simplified version, that previous one was
heavily over engineer, I 
 1) don't like that memory barrier in the generic code, 
 2) don't think that arch's necessarily keep that mask as tight.

[ even if for x86 smp_mb__{before,after}_clear_bit are a nop, tying that
  to switch_mm() semantics just reeks ]

See for example the sparc64 implementation of switch_mm() that only sets
cpus in mm_cpumask(), but only tlb flushes clear them. Also, I wouldn't
know if switch_mm() implies an mb on sparc64.



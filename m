Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320Ab0AKR1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0AKR1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 12:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984Ab0AKR1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 12:27:37 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46588 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab0AKR1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 12:27:36 -0500
Date: Mon, 11 Jan 2010 09:27:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v3a)
Message-ID: <20100111172730.GF6632@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal> <20100111042903.GC32213@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111042903.GC32213@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 11:29:03PM -0500, Mathieu Desnoyers wrote:
> Here is an implementation of a new system call, sys_membarrier(), which
> executes a memory barrier on all threads of the current process.
> 
> It aims at greatly simplifying and enhancing the current signal-based
> liburcu userspace RCU synchronize_rcu() implementation.
> (found at http://lttng.org/urcu)

Given that this has the memory barrier both before and after the
assignment to ->mm, looks good to me from a memory-ordering viewpoint.
I must defer to others on the effect on context-switch overhead.

						Thanx, Paul

> Changelog since v1:
> 
> - Only perform the IPI in CONFIG_SMP.
> - Only perform the IPI if the process has more than one thread.
> - Only send IPIs to CPUs involved with threads belonging to our process.
> - Adaptative IPI scheme (single vs many IPI with threshold).
> - Issue smp_mb() at the beginning and end of the system call.
> 
> Changelog since v2:
> - simply send-to-many to the mm_cpumask. It contains the list of processors we
>   have to IPI to (which use the mm), and this mask is updated atomically.
> 
> Both the signal-based and the sys_membarrier userspace RCU schemes
> permit us to remove the memory barrier from the userspace RCU
> rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
> accelerating them. These memory barriers are replaced by compiler
> barriers on the read-side, and all matching memory barriers on the 
> write-side are turned into an invokation of a memory barrier on all
> active threads in the process. By letting the kernel perform this
> synchronization rather than dumbly sending a signal to every process
> threads (as we currently do), we diminish the number of unnecessary wake
> ups and only issue the memory barriers on active threads. Non-running
> threads do not need to execute such barrier anyway, because these are
> implied by the scheduler context switches.
> 
> To explain the benefit of this scheme, let's introduce two example threads:
> 
> Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
> Thread B (frequent, e.g. executing liburcu rcu_read_lock()/rcu_read_unlock())
> 
> In a scheme where all smp_mb() in thread A synchronize_rcu() are
> ordering memory accesses with respect to smp_mb() present in 
> rcu_read_lock/unlock(), we can change all smp_mb() from
> synchronize_rcu() into calls to sys_membarrier() and all smp_mb() from
> rcu_read_lock/unlock() into compiler barriers "barrier()".
> 
> Before the change, we had, for each smp_mb() pairs:
> 
> Thread A                    Thread B
> prev mem accesses           prev mem accesses
> smp_mb()                    smp_mb()
> follow mem accesses         follow mem accesses
> 
> After the change, these pairs become:
> 
> Thread A                    Thread B
> prev mem accesses           prev mem accesses
> sys_membarrier()            barrier()
> follow mem accesses         follow mem accesses
> 
> As we can see, there are two possible scenarios: either Thread B memory
> accesses do not happen concurrently with Thread A accesses (1), or they
> do (2).
> 
> 1) Non-concurrent Thread A vs Thread B accesses:
> 
> Thread A                    Thread B
> prev mem accesses
> sys_membarrier()
> follow mem accesses
>                             prev mem accesses
>                             barrier()
>                             follow mem accesses
> 
> In this case, thread B accesses will be weakly ordered. This is OK,
> because at that point, thread A is not particularly interested in
> ordering them with respect to its own accesses.
> 
> 2) Concurrent Thread A vs Thread B accesses
> 
> Thread A                    Thread B
> prev mem accesses           prev mem accesses
> sys_membarrier()            barrier()
> follow mem accesses         follow mem accesses
> 
> In this case, thread B accesses, which are ensured to be in program
> order thanks to the compiler barrier, will be "upgraded" to full
> smp_mb() thanks to the IPIs executing memory barriers on each active
> system threads. Each non-running process threads are intrinsically
> serialized by the scheduler.
> 
> For my Intel Xeon E5405 (new set of results, disabled kernel debugging)
> 
> T=1: 0m18.921s
> T=2: 0m19.457s
> T=3: 0m21.619s
> T=4: 0m21.641s
> T=5: 0m23.426s
> T=6: 0m26.450s
> T=7: 0m27.731s
> 
> The expected top pattern, when using 1 CPU for a thread doing sys_membarrier()
> in a loop and other threads busy-waiting in user-space on a variable shows that
> the thread doing sys_membarrier is doing mostly system calls, and other threads
> are mostly running in user-space. Side-note, in this test, it's important to
> check that individual threads are not always fully at 100% user-space time (they
> range between ~95% and 100%), because when some thread in the test is always at
> 100% on the same CPU, this means it does not get the IPI at all. (I actually
> found out about a bug in my own code while developing it with this test.)
> 
> Cpu0  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu1  : 99.7%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
> Cpu2  : 99.3%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.7%hi,  0.0%si,  0.0%st
> Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu4  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu5  : 96.0%us,  1.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  2.6%si,  0.0%st
> Cpu6  :  1.3%us, 98.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu7  : 96.1%us,  3.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st
> 
> Results in liburcu:
> 
> Operations in 10s, 6 readers, 2 writers:
> 
> (what we previously had)
> memory barriers in reader: 973494744 reads, 892368 writes
> signal-based scheme:      6289946025 reads,   1251 writes
> 
> (what we have now, with dynamic sys_membarrier check)
> memory barriers in reader: 907693804 reads, 817793 writes
> sys_membarrier scheme:    4061976535 reads, 526807 writes
> 
> So the dynamic sys_membarrier availability check adds some overhead to the
> read-side, but besides that, we can see that we are close to the read-side
> performance of the signal-based scheme and also close (5/8) to the performance
> of the memory-barrier write-side. We have a write-side speedup of 421:1 over the
> signal-based scheme by using the sys_membarrier system call. This allows a 4.5:1
> read-side speedup over the memory barrier scheme.
> 
> The system call number is only assigned for x86_64 in this RFC patch.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: mingo@elte.hu
> CC: laijs@cn.fujitsu.com
> CC: dipankar@in.ibm.com
> CC: akpm@linux-foundation.org
> CC: josh@joshtriplett.org
> CC: dvhltc@us.ibm.com
> CC: niv@us.ibm.com
> CC: tglx@linutronix.de
> CC: peterz@infradead.org
> CC: rostedt@goodmis.org
> CC: Valdis.Kletnieks@vt.edu
> CC: dhowells@redhat.com
> ---
>  arch/x86/include/asm/unistd_64.h |    2 +
>  kernel/sched.c                   |   59 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 60 insertions(+), 1 deletion(-)
> 
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
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

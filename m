Return-Path: <linux-kernel-owner+w=401wt.eu-S1751067Ab0AGFCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab0AGFCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829Ab0AGFCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:02:53 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33004 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab0AGFCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:02:52 -0500
Date: Wed, 6 Jan 2010 21:02:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107050248.GA6803@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107044007.GA22863@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 11:40:07PM -0500, Mathieu Desnoyers wrote:
> Here is an implementation of a new system call, sys_membarrier(), which
> executes a memory barrier on all threads of the current process.
> 
> It aims at greatly simplifying and enhancing the current signal-based
> liburcu userspace RCU synchronize_rcu() implementation.
> (found at http://lttng.org/urcu)
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
> The current implementation simply executes a memory barrier in an IPI
> handler on each active cpu. Going through the hassle of taking run queue
> locks and checking if the thread running on each online CPU belongs to
> the current thread seems more heavyweight than the cost of the IPI
> itself (not measured though).
> 
> The system call number is only assigned for x86_64 in this RFC patch.

Beats the heck out of user-mode signal handlers!!!  And it is hard
to imagine groveling through runqueues ever being a win, even on very
large systems.  The only reasonable optimization I can imagine is to
turn this into a no-op for a single-threaded process, but there are
other ways to do that optimization.

Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

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
>  arch/x86/include/asm/unistd_64.h |    2 ++
>  kernel/sched.c                   |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> Index: linux-2.6-lttng/arch/x86/include/asm/unistd_64.h
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/include/asm/unistd_64.h	2010-01-06 22:11:32.000000000 -0500
> +++ linux-2.6-lttng/arch/x86/include/asm/unistd_64.h	2010-01-06 22:11:50.000000000 -0500
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
> --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-06 22:11:32.000000000 -0500
> +++ linux-2.6-lttng/kernel/sched.c	2010-01-06 23:20:42.000000000 -0500
> @@ -10822,6 +10822,36 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
> 
> +/*
> + * Execute a memory barrier on all CPUs on SMP systems.
> + * Do not rely on implicit barriers in smp_call_function(), just in case they
> + * are ever relaxed in the future.
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
> + *
> + * The current implementation simply executes a memory barrier in an IPI handler
> + * on each active cpu. Going through the hassle of taking run queue locks and
> + * checking if the thread running on each online CPU belongs to the current
> + * thread seems more heavyweight than the cost of the IPI itself.
> + */
> +SYSCALL_DEFINE0(membarrier)
> +{
> +	on_each_cpu(membarrier_ipi, NULL, 1);
> +
> +	return 0;
> +}
> +
>  #ifndef CONFIG_SMP
> 
>  int rcu_expedited_torture_stats(char *page)
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

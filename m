Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274Ab0ALSMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0ALSMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445Ab0ALSMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:12:17 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36771 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0ALSMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:12:15 -0500
Date: Tue, 12 Jan 2010 10:12:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v3b)
Message-ID: <20100112181212.GC6812@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal> <20100111043016.GD32213@Krystal> <20100111224355.GH6632@linux.vnet.ibm.com> <20100112153854.GA8122@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112153854.GA8122@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 10:38:54AM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sun, Jan 10, 2010 at 11:30:16PM -0500, Mathieu Desnoyers wrote:
> > > Here is an implementation of a new system call, sys_membarrier(), which
> > > executes a memory barrier on all threads of the current process.
> > > 
> > > It aims at greatly simplifying and enhancing the current signal-based
> > > liburcu userspace RCU synchronize_rcu() implementation.
> > > (found at http://lttng.org/urcu)
> > 
> > I didn't expect quite this comprehensive of an implementation from the
> > outset, but I guess I cannot complain.  ;-)
> > 
> > Overall, good stuff.
> > 
> > Interestingly enough, what you have implemented is analogous to
> > synchronize_rcu_expedited() and friends that have recently been added
> > to the in-kernel RCU API.  By this analogy, my earlier semi-suggestion
> > of synchronize_rcu(0 would be a candidate non-expedited implementation.
> > Long latency, but extremely low CPU consumption, full batching of
> > concurrent requests (even unrelated ones), and so on.
> 
> Yes, the main different I think is that the sys_membarrier
> infrastructure focuses on IPI-ing only the current process running
> threads.

Which does indeed make sense for the expedited interface.  On the other
hand, if you have a bunch of concurrent non-expedited requests from
different processes, covering all CPUs efficiently satisfies all of
the requests in one go.  And, if you use synchronize_sched() for the
non-expedited case, there will be no IPIs in the common case.

> > A few questions interspersed below.
> > 
> > > Changelog since v1:
> > > 
> > > - Only perform the IPI in CONFIG_SMP.
> > > - Only perform the IPI if the process has more than one thread.
> > > - Only send IPIs to CPUs involved with threads belonging to our process.
> > > - Adaptative IPI scheme (single vs many IPI with threshold).
> > > - Issue smp_mb() at the beginning and end of the system call.
> > > 
> > > Changelog since v2:
> > > 
> > > - Iteration on min(num_online_cpus(), nr threads in the process),
> > >   taking runqueue spinlocks, allocating a cpumask, ipi to many to the
> > >   cpumask. Does not allocate the cpumask if only a single IPI is needed.
> > > 
> > > 
> > > Both the signal-based and the sys_membarrier userspace RCU schemes
> > > permit us to remove the memory barrier from the userspace RCU
> > > rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
> > > accelerating them. These memory barriers are replaced by compiler
> > > barriers on the read-side, and all matching memory barriers on the 
> > > write-side are turned into an invokation of a memory barrier on all
> > > active threads in the process. By letting the kernel perform this
> > > synchronization rather than dumbly sending a signal to every process
> > > threads (as we currently do), we diminish the number of unnecessary wake
> > > ups and only issue the memory barriers on active threads. Non-running
> > > threads do not need to execute such barrier anyway, because these are
> > > implied by the scheduler context switches.
> > > 
> > > To explain the benefit of this scheme, let's introduce two example threads:
> > > 
> > > Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
> > > Thread B (frequent, e.g. executing liburcu rcu_read_lock()/rcu_read_unlock())
> > > 
> > > In a scheme where all smp_mb() in thread A synchronize_rcu() are
> > > ordering memory accesses with respect to smp_mb() present in 
> > > rcu_read_lock/unlock(), we can change all smp_mb() from
> > > synchronize_rcu() into calls to sys_membarrier() and all smp_mb() from
> > > rcu_read_lock/unlock() into compiler barriers "barrier()".
> > > 
> > > Before the change, we had, for each smp_mb() pairs:
> > > 
> > > Thread A                    Thread B
> > > prev mem accesses           prev mem accesses
> > > smp_mb()                    smp_mb()
> > > follow mem accesses         follow mem accesses
> > > 
> > > After the change, these pairs become:
> > > 
> > > Thread A                    Thread B
> > > prev mem accesses           prev mem accesses
> > > sys_membarrier()            barrier()
> > > follow mem accesses         follow mem accesses
> > > 
> > > As we can see, there are two possible scenarios: either Thread B memory
> > > accesses do not happen concurrently with Thread A accesses (1), or they
> > > do (2).
> > > 
> > > 1) Non-concurrent Thread A vs Thread B accesses:
> > > 
> > > Thread A                    Thread B
> > > prev mem accesses
> > > sys_membarrier()
> > > follow mem accesses
> > >                             prev mem accesses
> > >                             barrier()
> > >                             follow mem accesses
> > > 
> > > In this case, thread B accesses will be weakly ordered. This is OK,
> > > because at that point, thread A is not particularly interested in
> > > ordering them with respect to its own accesses.
> > > 
> > > 2) Concurrent Thread A vs Thread B accesses
> > > 
> > > Thread A                    Thread B
> > > prev mem accesses           prev mem accesses
> > > sys_membarrier()            barrier()
> > > follow mem accesses         follow mem accesses
> > > 
> > > In this case, thread B accesses, which are ensured to be in program
> > > order thanks to the compiler barrier, will be "upgraded" to full
> > > smp_mb() thanks to the IPIs executing memory barriers on each active
> > > system threads. Each non-running process threads are intrinsically
> > > serialized by the scheduler.
> > > 
> > > Just tried with a cache-hot kernel compilation using 6/8 CPUs.
> > > 
> > > Normally:                                              real 2m41.852s
> > > With the sys_membarrier+1 busy-looping thread running: real 5m41.830s
> > > 
> > > So... 2x slower. That hurts.
> > > 
> > > So let's try allocating a cpu mask for PeterZ scheme. I prefer to have a
> > > small allocation overhead and benefit from cpumask broadcast if
> > > possible so we scale better. But that all depends on how big the
> > > allocation overhead is.
> > > 
> > > Impact of allocating a cpumask (time for 10,000,000 sys_membarrier
> > > calls, one thread is doing the sys_membarrier, the others are busy
> > > looping)).  Given that it costs almost half as much to perform the
> > > cpumask allocation than to send a single IPI, as we iterate on the CPUs
> > > until we find more than N match or iterated on all cpus.  If we only have
> > > N match or less, we send single IPIs. If we need more than that, then we
> > > switch to the cpumask allocation and send a broadcast IPI to the cpumask
> > > we construct for the matching CPUs. Let's call it the "adaptative IPI
> > > scheme".
> > > 
> > > For my Intel Xeon E5405
> > > 
> > > *This is calibration only, not taking the runqueue locks*
> > > 
> > > Just doing local mb()+single IPI to T other threads:
> > > 
> > > T=1: 0m18.801s
> > > T=2: 0m29.086s
> > > T=3: 0m46.841s
> > > T=4: 0m53.758s
> > > T=5: 1m10.856s
> > > T=6: 1m21.142s
> > > T=7: 1m38.362s
> > > 
> > > Just doing cpumask alloc+IPI-many to T other threads:
> > > 
> > > T=1: 0m21.778s
> > > T=2: 0m22.741s
> > > T=3: 0m22.185s
> > > T=4: 0m24.660s
> > > T=5: 0m26.855s
> > > T=6: 0m30.841s
> > > T=7: 0m29.551s
> > > 
> > > So I think the right threshold should be 1 thread (assuming other
> > > architecture will behave like mine). So starting with 2 threads, we
> > > allocate the cpumask before sending IPIs.
> > > 
> > > *end of calibration*
> > > 
> > > Resulting adaptative scheme, with runqueue locks:
> > > 
> > > T=1: 0m20.990s
> > > T=2: 0m22.588s
> > > T=3: 0m27.028s
> > > T=4: 0m29.027s
> > > T=5: 0m32.592s
> > > T=6: 0m36.556s
> > > T=7: 0m33.093s
> > > 
> > > The expected top pattern, when using 1 CPU for a thread doing sys_membarrier()
> > > in a loop and other threads busy-waiting in user-space on a variable shows that
> > > the thread doing sys_membarrier is doing mostly system calls, and other threads
> > > are mostly running in user-space. Side-note, in this test, it's important to
> > > check that individual threads are not always fully at 100% user-space time (they
> > > range between ~95% and 100%), because when some thread in the test is always at
> > > 100% on the same CPU, this means it does not get the IPI at all. (I actually
> > > found out about a bug in my own code while developing it with this test.)
> > 
> > The below data is for how many threads in the process?
> 
> 8 threads: one doing sys_membarrier() in a loop, 7 others waiting on a
> variable.

OK, thanks for the info!

> > Also, is "top"
> > accurate given that the IPI handler will have interrupts disabled?
> 
> Probably not. AFAIK. "top" does not really consider interrupts into its
> accounting. So, better take this top output with a grain of salt or two.

Might need something like oprofile to get good info?

> > > Cpu0  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> > > Cpu1  : 99.7%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
> > > Cpu2  : 99.3%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.7%hi,  0.0%si,  0.0%st
> > > Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> > > Cpu4  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> > > Cpu5  : 96.0%us,  1.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  2.6%si,  0.0%st
> > > Cpu6  :  1.3%us, 98.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> > > Cpu7  : 96.1%us,  3.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st
> > > 
> > > The system call number is only assigned for x86_64 in this RFC patch.
> > > 
> > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > CC: mingo@elte.hu
> > > CC: laijs@cn.fujitsu.com
> > > CC: dipankar@in.ibm.com
> > > CC: akpm@linux-foundation.org
> > > CC: josh@joshtriplett.org
> > > CC: dvhltc@us.ibm.com
> > > CC: niv@us.ibm.com
> > > CC: tglx@linutronix.de
> > > CC: peterz@infradead.org
> > > CC: rostedt@goodmis.org
> > > CC: Valdis.Kletnieks@vt.edu
> > > CC: dhowells@redhat.com
> > > ---
> > >  arch/x86/include/asm/unistd_64.h |    2 
> > >  kernel/sched.c                   |  219 +++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 221 insertions(+)
> > > 
> > > Index: linux-2.6-lttng/arch/x86/include/asm/unistd_64.h
> > > ===================================================================
> > > --- linux-2.6-lttng.orig/arch/x86/include/asm/unistd_64.h	2010-01-10 22:23:59.000000000 -0500
> > > +++ linux-2.6-lttng/arch/x86/include/asm/unistd_64.h	2010-01-10 22:29:30.000000000 -0500
> > > @@ -661,6 +661,8 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
> > >  __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
> > >  #define __NR_perf_event_open			298
> > >  __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
> > > +#define __NR_membarrier				299
> > > +__SYSCALL(__NR_membarrier, sys_membarrier)
> > > 
> > >  #ifndef __NO_STUBS
> > >  #define __ARCH_WANT_OLD_READDIR
> > > Index: linux-2.6-lttng/kernel/sched.c
> > > ===================================================================
> > > --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-10 22:23:59.000000000 -0500
> > > +++ linux-2.6-lttng/kernel/sched.c	2010-01-10 23:12:35.000000000 -0500
> > > @@ -119,6 +119,11 @@
> > >   */
> > >  #define RUNTIME_INF	((u64)~0ULL)
> > > 
> > > +/*
> > > + * IPI vs cpumask broadcast threshold. Threshold of 1 IPI.
> > > + */
> > > +#define ADAPT_IPI_THRESHOLD	1
> > > +
> > >  static inline int rt_policy(int policy)
> > >  {
> > >  	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
> > > @@ -10822,6 +10827,220 @@ struct cgroup_subsys cpuacct_subsys = {
> > >  };
> > >  #endif	/* CONFIG_CGROUP_CPUACCT */
> > > 
> > > +/*
> > > + * Execute a memory barrier on all CPUs on SMP systems.
> > > + * Do not rely on implicit barriers in smp_call_function(), just in case they
> > > + * are ever relaxed in the future.
> > > + */
> > > +static void membarrier_ipi(void *unused)
> > > +{
> > > +	smp_mb();
> > > +}
> > > +
> > > +/*
> > > + * Handle out-of-mem by sending per-cpu IPIs instead.
> > > + */
> > 
> > Good handling for out-of-memory errors!
> > 
> > > +static void membarrier_cpus_retry(int this_cpu)
> > > +{
> > > +	struct mm_struct *mm;
> > > +	int cpu;
> > > +
> > > +	for_each_online_cpu(cpu) {
> > > +		if (unlikely(cpu == this_cpu))
> > > +			continue;
> > > +		spin_lock_irq(&cpu_rq(cpu)->lock);
> > > +		mm = cpu_curr(cpu)->mm;
> > > +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> > > +		if (current->mm == mm)
> > > +			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> > 
> > There is of course some possibility of interrupting a real-time task,
> > as the destination CPU could context-switch once we drop the ->lock.
> > Not a criticism, just something to keep in mind.  After all, the only ways
> > I can think of to avoid this possibility do so by keeping the CPU from
> > switching to the real-time task, which sort of defeats the purpose.  ;-)
> 
> Absolutely. And it's of no use to add a check within the IPI handler to
> verify if it was indeed needed, because all we would skip is a simple
> smp_mb(), which is relatively minor in terms of overhead compared to the
> IPI itself.

Agreed!

> > > +	}
> > > +}
> > > +
> > > +static void membarrier_threads_retry(int this_cpu)
> > > +{
> > > +	struct mm_struct *mm;
> > > +	struct task_struct *t;
> > > +	struct rq *rq;
> > > +	int cpu;
> > > +
> > > +	list_for_each_entry_rcu(t, &current->thread_group, thread_group) {
> > > +		local_irq_disable();
> > > +		rq = __task_rq_lock(t);
> > > +		mm = rq->curr->mm;
> > > +		cpu = rq->cpu;
> > > +		__task_rq_unlock(rq);
> > > +		local_irq_enable();
> > > +		if (cpu == this_cpu)
> > > +			continue;
> > > +		if (current->mm == mm)
> > > +			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> > 
> > Ditto.
> > 
> > > +	}
> > > +}
> > > +
> > > +static void membarrier_cpus(int this_cpu)
> > > +{
> > > +	int cpu, i, cpu_ipi[ADAPT_IPI_THRESHOLD], nr_cpus = 0;
> > > +	cpumask_var_t tmpmask;
> > > +	struct mm_struct *mm;
> > > +
> > > +	/* Get CPU IDs up to threshold */
> > > +	for_each_online_cpu(cpu) {
> > > +		if (unlikely(cpu == this_cpu))
> > > +			continue;
> > 
> > OK, the above "if" handles the single-threaded-process case.
> > 
> 
> No. See
> 
>  +   if (unlikely(thread_group_empty(current)))
>  +           return 0;
> 
> in the caller below. The if you present here simply ensures that we
> don't do a superfluous function call on the current thread. It's
> probably not really worth it for a slow path though.

OK, got it.

> > The UP-kernel case is handled by the #ifdef in sys_membarrier(), though
> > with a bit larger code footprint than the embedded guys would probably
> > prefer.  (Or is the compiler smart enough to omit these function given no
> > calls to them?  If not, recommend putting them under CONFIG_SMP #ifdef.)
> 
> Hrm, that's a bit odd. I agree that UP systems could simply return
> -ENOSYS for sys_membarrier, but then I wonder how userland could
> distinguish between:
> 
> - an old kernel not supporting sys_membarrier()
>   -> in this case we need to use the smp_mb() fallback on the read-side
>      and in synchronize_rcu().
> - a recent kernel supporting sys_membarrier(), CONFIG_SMP
>   -> can use the barrier() on read-side, call sys_membarrier upon
>      update.
> - a recent kernel supporting sys_membarrier, !CONFIG_SMP
>   -> calls to sys_membarrier() are not required, nor is barrier().
> 
> Or maybe we just postpone the userland smp_mb() question to another
> thread. This will eventually need to be addressed anyway. Maybe with a
> vgetmaxcpu() vsyscall.

[covered in Steve's email]

> > > +		spin_lock_irq(&cpu_rq(cpu)->lock);
> > > +		mm = cpu_curr(cpu)->mm;
> > > +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> > > +		if (current->mm == mm) {
> > > +			if (nr_cpus == ADAPT_IPI_THRESHOLD) {
> > > +				nr_cpus++;
> > > +				break;
> > > +			}
> > > +			cpu_ipi[nr_cpus++] = cpu;
> > > +		}
> > > +	}
> > > +	if (likely(nr_cpus <= ADAPT_IPI_THRESHOLD)) {
> > > +		for (i = 0; i < nr_cpus; i++) {
> > > +			smp_call_function_single(cpu_ipi[i],
> > > +						 membarrier_ipi,
> > > +						 NULL, 1);
> > > +		}
> > > +	} else {
> > > +		if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> > > +			membarrier_cpus_retry(this_cpu);
> > > +			return;
> > > +		}
> > > +		for (i = 0; i < ADAPT_IPI_THRESHOLD; i++)
> > > +			cpumask_set_cpu(cpu_ipi[i], tmpmask);
> > > +		/* Continue previous online cpu iteration */
> > > +		cpumask_set_cpu(cpu, tmpmask);
> > > +		for (;;) {
> > > +			cpu = cpumask_next(cpu, cpu_online_mask);
> > > +			if (unlikely(cpu == this_cpu))
> > > +				continue;
> > > +			if (unlikely(cpu >= nr_cpu_ids))
> > > +				break;
> > > +			spin_lock_irq(&cpu_rq(cpu)->lock);
> > > +			mm = cpu_curr(cpu)->mm;
> > > +			spin_unlock_irq(&cpu_rq(cpu)->lock);
> > > +			if (current->mm == mm)
> > > +				cpumask_set_cpu(cpu, tmpmask);
> > > +		}
> > > +		smp_call_function_many(tmpmask, membarrier_ipi, NULL, 1);
> > > +		free_cpumask_var(tmpmask);
> > > +	}
> > > +}
> > > +
> > > +static void membarrier_threads(int this_cpu)
> > > +{
> > > +	int cpu, i, cpu_ipi[ADAPT_IPI_THRESHOLD], nr_cpus = 0;
> > > +	cpumask_var_t tmpmask;
> > > +	struct mm_struct *mm;
> > > +	struct task_struct *t;
> > > +	struct rq *rq;
> > > +
> > > +	/* Get CPU IDs up to threshold */
> > > +	list_for_each_entry_rcu(t, &current->thread_group,
> > > +				thread_group) {
> > > +		local_irq_disable();
> > > +		rq = __task_rq_lock(t);
> > > +		mm = rq->curr->mm;
> > > +		cpu = rq->cpu;
> > > +		__task_rq_unlock(rq);
> > > +		local_irq_enable();
> > > +		if (cpu == this_cpu)
> > > +			continue;
> > > +		if (current->mm == mm) {
> > 
> > I do not believe that the above test is gaining you anything.  It would
> > fail only if the task switched since the __task_rq_unlock(), but then
> > again, it could switch immediately after the above test just as well.
> 
> OK. Anyway I think I'll go the the shorter implementation using the
> mm_cpumask, and add an additionnal ->mm check with spinlocks.

Checking the ones not in mm_cpumask?  I guess I will find out when I
see the new patch.

							Thanx, Paul

> > > +			if (nr_cpus == ADAPT_IPI_THRESHOLD) {
> > > +				nr_cpus++;
> > > +				break;
> > > +			}
> > > +			cpu_ipi[nr_cpus++] = cpu;
> > > +		}
> > > +	}
> > > +	if (likely(nr_cpus <= ADAPT_IPI_THRESHOLD)) {
> > > +		for (i = 0; i < nr_cpus; i++) {
> > > +			smp_call_function_single(cpu_ipi[i],
> > > +						 membarrier_ipi,
> > > +						 NULL, 1);
> > > +		}
> > > +	} else {
> > > +		if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> > > +			membarrier_threads_retry(this_cpu);
> > > +			return;
> > > +		}
> > > +		for (i = 0; i < ADAPT_IPI_THRESHOLD; i++)
> > > +			cpumask_set_cpu(cpu_ipi[i], tmpmask);
> > > +		/* Continue previous thread iteration */
> > > +		cpumask_set_cpu(cpu, tmpmask);
> > > +		list_for_each_entry_continue_rcu(t,
> > > +						 &current->thread_group,
> > > +						 thread_group) {
> > > +			local_irq_disable();
> > > +			rq = __task_rq_lock(t);
> > > +			mm = rq->curr->mm;
> > > +			cpu = rq->cpu;
> > > +			__task_rq_unlock(rq);
> > > +			local_irq_enable();
> > > +			if (cpu == this_cpu)
> > > +				continue;
> > > +			if (current->mm == mm)
> > 
> > Ditto.
> > 
> > > +				cpumask_set_cpu(cpu, tmpmask);
> > A> +		}
> > > +		smp_call_function_many(tmpmask, membarrier_ipi, NULL, 1);
> > > +		free_cpumask_var(tmpmask);
> > > +	}
> > > +}
> > > +
> > > +/*
> > > + * sys_membarrier - issue memory barrier on current process running threads
> > > + *
> > > + * Execute a memory barrier on all running threads of the current process.
> > > + * Upon completion, the caller thread is ensured that all process threads
> > > + * have passed through a state where memory accesses match program order.
> > > + * (non-running threads are de facto in such a state)
> > > + *
> > > + * We do not use mm_cpumask because there is no guarantee that each architecture
> > > + * switch_mm issues a smp_mb() before and after mm_cpumask modification upon
> > > + * scheduling change. Furthermore, leave_mm is also modifying the mm_cpumask (at
> > > + * least on x86) from the TLB flush IPI handler. So rather than playing tricky
> > > + * games with lazy TLB flush, let's simply iterate on online cpus/thread group,
> > > + * whichever is the smallest.
> > > + */
> > > +SYSCALL_DEFINE0(membarrier)
> > > +{
> > > +#ifdef CONFIG_SMP
> > > +	int this_cpu;
> > > +
> > > +	if (unlikely(thread_group_empty(current)))
> > > +		return 0;
> > > +
> > > +	rcu_read_lock();	/* protect cpu_curr(cpu)-> and rcu list */
> > > +	preempt_disable();
> > 
> > Hmmm...  You are going to hate me for pointing this out, Mathieu, but
> > holding preempt_disable() across the whole sys_membarrier() processing
> > might be hurting real-time latency more than would unconditionally
> > IPIing all the CPUs.  :-/
> 
> Hehe, I pointed this out myself a few emails ago :) This is why I
> started by using raw_smp_processor_id(). Well, let's make it simple
> first, and then we can improve if needed.
> 
> > 
> > That said, we have no shortage of situations where we scan the CPUs with
> > preemption disabled, and with interrupts disabled, for that matter.
> 
> Yep.
> 
> Thanks,
> 
> Mathieu
> 
> > 
> > > +	/*
> > > +	 * Memory barrier on the caller thread _before_ sending first IPI.
> > > +	 */
> > > +	smp_mb();
> > > +	/*
> > > +	 * We don't need to include ourself in IPI, as we already
> > > +	 * surround our execution with memory barriers.
> > > +	 */
> > > +	this_cpu = smp_processor_id();
> > > +	/* Approximate which is fastest: CPU or thread group iteration ? */
> > > +	if (num_online_cpus() <= atomic_read(&current->mm->mm_users))
> > > +		membarrier_cpus(this_cpu);
> > > +	else
> > > +		membarrier_threads(this_cpu);
> > > +	/*
> > > +	 * Memory barrier on the caller thread _after_ we finished
> > > +	 * waiting for the last IPI.
> > > +	 */
> > > +	smp_mb();
> > > +	preempt_enable();
> > > +	rcu_read_unlock();
> > > +#endif	/* #ifdef CONFIG_SMP */
> > > +	return 0;
> > > +}
> > > +
> > >  #ifndef CONFIG_SMP
> > > 
> > >  int rcu_expedited_torture_stats(char *page)
> > > -- 
> > > Mathieu Desnoyers
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

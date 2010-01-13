Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759Ab0AMD6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0AMD6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 22:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209Ab0AMD6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 22:58:12 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:32880 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753891Ab0AMD6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 22:58:12 -0500
Date: Tue, 12 Jan 2010 22:58:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113035809.GA7260@Krystal>
References: <20100113013757.GA29314@Krystal> <20100113110455.B3D3.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100113110455.B3D3.A69D9226@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 22:37:13 up 27 days, 11:55,  5 users,  load average: 0.09, 0.10,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
> 
> Interesting patch :)
> 
> I have few comments.
> 
> > Index: linux-2.6-lttng/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-12 10:25:47.000000000 -0500
> > +++ linux-2.6-lttng/kernel/sched.c	2010-01-12 14:33:20.000000000 -0500
> > @@ -10822,6 +10822,117 @@ struct cgroup_subsys cpuacct_subsys = {
> >  };
> >  #endif	/* CONFIG_CGROUP_CPUACCT */
> >  
> > +#ifdef CONFIG_SMP
> > +
> > +/*
> > + * Execute a memory barrier on all active threads from the current process
> > + * on SMP systems. Do not rely on implicit barriers in IPI handler execution,
> > + * because batched IPI lists are synchronized with spinlocks rather than full
> > + * memory barriers. This is not the bulk of the overhead anyway, so let's stay
> > + * on the safe side.
> > + */
> > +static void membarrier_ipi(void *unused)
> > +{
> > +	smp_mb();
> > +}
> > +
> > +/*
> > + * Handle out-of-mem by sending per-cpu IPIs instead.
> > + */
> > +static void membarrier_retry(void)
> > +{
> > +	struct mm_struct *mm;
> > +	int cpu;
> > +
> > +	for_each_cpu(cpu, mm_cpumask(current->mm)) {
> > +		spin_lock_irq(&cpu_rq(cpu)->lock);
> > +		mm = cpu_curr(cpu)->mm;
> > +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> > +		if (current->mm == mm)
> > +			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> > +	}
> > +}
> > +
> > +#endif /* #ifdef CONFIG_SMP */
> > +
> > +/*
> > + * sys_membarrier - issue memory barrier on current process running threads
> > + * @expedited: (0) Lowest overhead. Few milliseconds latency.
> > + *             (1) Few microseconds latency.
> 
> Why do we need both expedited and non-expedited mode? at least, this documentation
> is bad. it suggest "you have to use non-expedited mode always!".

Right. Maybe I should rather write:

 + * @expedited: (0) Low overhead, but slow execution (few milliseconds)
 + *             (1) Slightly higher overhead, fast execution (few microseconds)

And I could probably go as far as adding a few paragraphs:

Using the non-expedited mode is recommended for applications which can
afford leaving the caller thread waiting for a few milliseconds. A good
example would be a thread dedicated to execute RCU callbacks, which
waits for callbacks to enqueue most of the time anyway.

The expedited mode is recommended whenever the application needs to have
control returning to the caller thread as quickly as possible. An
example of such application would be one which uses the same thread to
perform data structure updates and issue the RCU synchronization.

It is perfectly safe to call both expedited and non-expedited
sys_membarriers in a process.


Does that help ?

> 
> 
> > + *
> > + * Execute a memory barrier on all running threads of the current process.
> > + * Upon completion, the caller thread is ensured that all process threads
> > + * have passed through a state where memory accesses match program order.
> > + * (non-running threads are de facto in such a state)
> > + *
> > + * mm_cpumask is used as an approximation. It is a superset of the cpumask to
> > + * which we must send IPIs, mainly due to lazy TLB shootdown. Therefore,
> > + * we check each runqueue to make sure our ->mm is indeed running on them. This
> > + * reduces the risk of disturbing a RT task by sending unnecessary IPIs. There
> > + * is still a slight chance to disturb an unrelated task, because we do not lock
> > + * the runqueues while sending IPIs, but the real-time effect of this heavy
> > + * locking would be worse than the comparatively small disruption of an IPI.
> > + *
> > + * RED PEN: before assinging a system call number for sys_membarrier() to an
> > + * architecture, we must ensure that switch_mm issues full memory barriers (or a
> > + * synchronizing instruction having the same effect) between:
> > + * - user-space code execution and clear mm_cpumask.
> > + * - set mm_cpumask and user-space code execution.
> > + * In some case adding a comment to this effect will suffice, in others we will
> > + * need to add smp_mb__before_clear_bit()/smp_mb__after_clear_bit() or simply
> > + * smp_mb(). These barriers are required to ensure we do not _miss_ a CPU that
> > + * need to receive an IPI, which would be a bug.
> > + *
> > + * On uniprocessor systems, this system call simply returns 0 without doing
> > + * anything, so user-space knows it is implemented.
> > + */
> > +SYSCALL_DEFINE1(membarrier, int, expedited)
> > +{
> > +#ifdef CONFIG_SMP
> > +	cpumask_var_t tmpmask;
> > +	struct mm_struct *mm;
> > +	int cpu;
> > +
> > +	if (unlikely(thread_group_empty(current) || (num_online_cpus() == 1)))
> > +		return 0;
> > +	if (!unlikely(expedited)) {
> 
> unlikely(!expedited)?

Woops, thanks !

> 
> 
> > +		synchronize_sched();
> > +		return 0;
> > +	}
> > +	/*
> > +	 * Memory barrier on the caller thread _before_ sending first
> > +	 * IPI. Matches memory barriers around mm_cpumask modification in
> > +	 * switch_mm().
> > +	 */
> > +	smp_mb();
> > +	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> > +		membarrier_retry();
> > +		goto unlock;
> > +	}
> 
> if CONFIG_CPUMASK_OFFSTACK=1, alloc_cpumask_var call kmalloc. FWIW,
> kmalloc calling seems destory the worth of this patch.

Why ? I'm not sure I understand your point. Even if we call kmalloc to
allocate the cpumask, this is a constant overhead. The benefit of
smp_call_function_many() over smp_call_function_single() is that it
scales better by allowing to broadcast IPIs when the architecture
supports it. Or maybe I'm missing something ?

> 
> #ifdef CONFIG_CPUMASK_OFFSTACK
> 	membarrier_retry();
> 	goto unlock;
> #endif
> 
> is better? I'm not sure.

Thanks for the comments !

Mathieu


> 
> 
> > +	cpumask_copy(tmpmask, mm_cpumask(current->mm));
> > +	preempt_disable();
> > +	cpumask_clear_cpu(smp_processor_id(), tmpmask);
> > +	for_each_cpu(cpu, tmpmask) {
> > +		spin_lock_irq(&cpu_rq(cpu)->lock);
> > +		mm = cpu_curr(cpu)->mm;
> > +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> > +		if (current->mm != mm)
> > +			cpumask_clear_cpu(cpu, tmpmask);
> > +	}
> > +	smp_call_function_many(tmpmask, membarrier_ipi, NULL, 1);
> > +	preempt_enable();
> > +	free_cpumask_var(tmpmask);
> > +unlock:
> > +	/*
> > +	 * Memory barrier on the caller thread _after_ we finished
> > +	 * waiting for the last IPI. Matches memory barriers around mm_cpumask
> > +	 * modification in switch_mm().
> > +	 */
> > +	smp_mb();
> > +#endif /* #ifdef CONFIG_SMP */
> > +	return 0;
> > +}
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

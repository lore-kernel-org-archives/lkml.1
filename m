Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714Ab0AIQVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0AIQVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 11:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679Ab0AIQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 11:21:22 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:45103 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451Ab0AIQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 11:21:21 -0500
Date: Sat, 9 Jan 2010 11:16:18 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       paulmck@linux.vnet.ibm.com, Josh Triplett <josh@joshtriplett.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v2)
Message-ID: <20100109161617.GA13505@Krystal>
References: <20100108235649.GA18477@Krystal> <1263034063.557.6495.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263034063.557.6495.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:50:25 up 24 days, 8 min,  4 users,  load average: 0.32, 0.25,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-01-08 at 18:56 -0500, Mathieu Desnoyers wrote:
> 
> > Index: linux-2.6-lttng/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-06 23:23:34.000000000 -0500
> > +++ linux-2.6-lttng/kernel/sched.c	2010-01-08 18:17:44.000000000 -0500
> > @@ -119,6 +119,11 @@
> >   */
> >  #define RUNTIME_INF	((u64)~0ULL)
> >  
> > +/*
> > + * IPI vs cpumask broadcast threshold. Threshold of 1 IPI.
> > + */
> > +#define ADAPT_IPI_THRESHOLD	1
> > +
> >  static inline int rt_policy(int policy)
> >  {
> >  	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
> > @@ -10822,6 +10827,124 @@ struct cgroup_subsys cpuacct_subsys = {
> >  };
> >  #endif	/* CONFIG_CGROUP_CPUACCT */
> >  
> > +/*
> > + * Execute a memory barrier on all CPUs on SMP systems.
> > + * Do not rely on implicit barriers in smp_call_function(), just in case they
> > + * are ever relaxed in the future.
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
> > +	int cpu;
> > +
> > +	for_each_cpu(cpu, mm_cpumask(current->mm)) {
> > +		if (cpu_curr(cpu)->mm == current->mm)
> > +			smp_call_function_single(cpu, membarrier_ipi,
> > +						 NULL, 1);
> > +	}
> > +}
> 
> 
> > +SYSCALL_DEFINE0(membarrier)
> > +{
> > +#ifdef CONFIG_SMP
> > +	int cpu, i, cpu_ipi[ADAPT_IPI_THRESHOLD], nr_cpus = 0;
> > +	cpumask_var_t tmpmask;
> > +	int this_cpu;
> > +
> > +	if (likely(!thread_group_empty(current))) {
> > +		rcu_read_lock();	/* protect cpu_curr(cpu)-> access */
> > +		/*
> > +		 * We don't need to include ourself in IPI, as we already
> > +		 * surround our execution with memory barriers. We also
> > +		 * don't have to disable preemption here, because if we
> > +		 * migrate out of "this_cpu", then there is an implied memory
> > +		 * barrier for the thread now running on "this_cpu".
> > +		 */
> > +		this_cpu = raw_smp_processor_id();
> 
> How is this not a bug?

This should be moved it right below the following smp_mb(). See below,

> 
> > +		/*
> > +		 * Memory barrier on the caller thread _before_ the first
> > +		 * cpu_curr(cpu)->mm read and also before sending first IPI.
> > +		 */
> > +		smp_mb();

So let's move it here. Now, why this should be ok:

The requirement of this algorithm is that, between the two smp_mb()
issued at the beginning and end of sys_membarrier() execution, we can be
sure that smp_mb() are issued on all processors running threads which
belong to our process.

So if we are preempted after reading the processor ID and migrated (and
another thread belonging to our process is run on our CPU), the
scheduler activity happening between the two smp_mb() surrounding
sys_membarrier() guarantees that memory barriers are issued for the
newly coming process. Therefore, we can skip the CPU on which we took
the processor ID, even if we happen to be moved to a different CPU.

It is based on the same assumption as the "racy" cpu_curr(cpu)->mm read:
we need to be sure that the scheduler issues a smp_mb() between the
execution of user-level instructions and scheduler activity (but in this
case, the scenario also involves a migration).


> > +		/* Get CPU IDs up to threshold */
> > +		for_each_cpu(cpu, mm_cpumask(current->mm)) {
> > +			if (unlikely(cpu == this_cpu))
> > +				continue;
> > +			if (cpu_curr(cpu)->mm == current->mm) {
> > +				if (nr_cpus == ADAPT_IPI_THRESHOLD) {
> > +					nr_cpus++;
> > +					break;
> > +				}
> > +				cpu_ipi[nr_cpus++] = cpu;
> > +			}
> > +		}
> > +		if (likely(nr_cpus <= ADAPT_IPI_THRESHOLD)) {
> > +			for (i = 0; i < nr_cpus; i++) {
> > +				smp_call_function_single(cpu_ipi[i],
> > +							 membarrier_ipi,
> > +							 NULL, 1);
> > +			}
> > +		} else {
> > +			if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> > +				membarrier_retry();
> > +				goto unlock;
> > +			}
> > +			for (i = 0; i < ADAPT_IPI_THRESHOLD; i++)
> > +				cpumask_set_cpu(cpu_ipi[i], tmpmask);
> > +			/* Continue previous for_each_cpu() */
> > +			do {
> > +				if (cpu_curr(cpu)->mm == current->mm)
> > +					cpumask_set_cpu(cpu, tmpmask);
> > +				cpu = cpumask_next(cpu,
> > +						   mm_cpumask(current->mm));
> > +				if (unlikely(cpu == this_cpu))
> > +					continue;
> > +			} while (cpu < nr_cpu_ids);
> > +			preempt_disable();	/* explicitly required */
> 
> This seems to indicate the same.

I solely added these preempt disable/enable because they are explicitly
required by smp_call_function_many() (see the comment at the beginning
of the implementation). I have not checked whether or not this would
indeed be required in this very specific case, or somehow permitted due
following my explanation above. Given that smp_processor_id() is used in
smp_call_function_many, it would complain if preemption is not disabled,
so it's better to stick with preemption disabling anyway.

So it all depends: I'm a bit reluctant to disable preemption when
iterating on all CPUs, as it's pushing the duration of the preempt-off
section as we add more cores on the system. So if possible I'd like to
keep preemption on. However, given that we already disable preemption
while waiting for other processor to acknowledge the IPI, we might as
well bite the bullet and disable it around the whole system call
althogether.

Anyway I don't see the impact of keeping preemption on as being as
important as taking all runqueue locks, so I could do with keeping
preemption off if it keeps the complexity level down.

Thoughts ?

Thanks,

Mathieu

> 
> > +			smp_call_function_many(tmpmask, membarrier_ipi, NULL,
> > +					       1);
> > +			preempt_enable();
> > +			free_cpumask_var(tmpmask);
> > +		}
> > +unlock:
> > +		/*
> > +		 * Memory barrier on the caller thread _after_ we finished
> > +		 * waiting for the last IPI and also after reading the last
> > +		 * cpu_curr(cpu)->mm.
> > +		 */
> > +		smp_mb();
> > +		rcu_read_unlock();
> > +	}
> > +#endif	/* #ifdef CONFIG_SMP */
> > +	return 0;
> > +}
> > +
> >  #ifndef CONFIG_SMP
> >  
> >  int rcu_expedited_torture_stats(char *page)
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

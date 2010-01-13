Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499Ab0AMFdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab0AMFdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779Ab0AMFdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:33:18 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55746 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab0AMFdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:33:17 -0500
Date: Tue, 12 Jan 2010 21:33:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113053313.GD6781@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100113110455.B3D3.A69D9226@jp.fujitsu.com> <20100113035809.GA7260@Krystal> <20100113130716.B3DC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113130716.B3DC.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 01:47:50PM +0900, KOSAKI Motohiro wrote:
> > * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > > Hi
> > > 
> > > Interesting patch :)
> > > 
> > > I have few comments.
> > > 
> > > > Index: linux-2.6-lttng/kernel/sched.c
> > > > ===================================================================
> > > > --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-12 10:25:47.000000000 -0500
> > > > +++ linux-2.6-lttng/kernel/sched.c	2010-01-12 14:33:20.000000000 -0500
> > > > @@ -10822,6 +10822,117 @@ struct cgroup_subsys cpuacct_subsys = {
> > > >  };
> > > >  #endif	/* CONFIG_CGROUP_CPUACCT */
> > > >  
> > > > +#ifdef CONFIG_SMP
> > > > +
> > > > +/*
> > > > + * Execute a memory barrier on all active threads from the current process
> > > > + * on SMP systems. Do not rely on implicit barriers in IPI handler execution,
> > > > + * because batched IPI lists are synchronized with spinlocks rather than full
> > > > + * memory barriers. This is not the bulk of the overhead anyway, so let's stay
> > > > + * on the safe side.
> > > > + */
> > > > +static void membarrier_ipi(void *unused)
> > > > +{
> > > > +	smp_mb();
> > > > +}
> > > > +
> > > > +/*
> > > > + * Handle out-of-mem by sending per-cpu IPIs instead.
> > > > + */
> > > > +static void membarrier_retry(void)
> > > > +{
> > > > +	struct mm_struct *mm;
> > > > +	int cpu;
> > > > +
> > > > +	for_each_cpu(cpu, mm_cpumask(current->mm)) {
> > > > +		spin_lock_irq(&cpu_rq(cpu)->lock);
> > > > +		mm = cpu_curr(cpu)->mm;
> > > > +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> > > > +		if (current->mm == mm)
> > > > +			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> > > > +	}
> > > > +}
> > > > +
> > > > +#endif /* #ifdef CONFIG_SMP */
> > > > +
> > > > +/*
> > > > + * sys_membarrier - issue memory barrier on current process running threads
> > > > + * @expedited: (0) Lowest overhead. Few milliseconds latency.
> > > > + *             (1) Few microseconds latency.
> > > 
> > > Why do we need both expedited and non-expedited mode? at least, this documentation
> > > is bad. it suggest "you have to use non-expedited mode always!".
> > 
> > Right. Maybe I should rather write:
> > 
> >  + * @expedited: (0) Low overhead, but slow execution (few milliseconds)
> >  + *             (1) Slightly higher overhead, fast execution (few microseconds)
> > 
> > And I could probably go as far as adding a few paragraphs:
> > 
> > Using the non-expedited mode is recommended for applications which can
> > afford leaving the caller thread waiting for a few milliseconds. A good
> > example would be a thread dedicated to execute RCU callbacks, which
> > waits for callbacks to enqueue most of the time anyway.
> > 
> > The expedited mode is recommended whenever the application needs to have
> > control returning to the caller thread as quickly as possible. An
> > example of such application would be one which uses the same thread to
> > perform data structure updates and issue the RCU synchronization.
> > 
> > It is perfectly safe to call both expedited and non-expedited
> > sys_membarriers in a process.
> > 
> > 
> > Does that help ?
> 
> Do librcu need both? I bet average programmer don't understand this
> explanation. please recall, syscall interface are used by non kernel
> developers too. If librcu only use either (0) or (1), I hope remove
> another one.

I believe that user-mode RCU will need both, and for much the same
reasons that kernel-mode RCU now has both expedited and non-expedited
grace periods.

						Thanx, Paul

> But if librcu really need both, the above explanation is enough good.
> I think.
> 
> 
> > > > +	 * Memory barrier on the caller thread _before_ sending first
> > > > +	 * IPI. Matches memory barriers around mm_cpumask modification in
> > > > +	 * switch_mm().
> > > > +	 */
> > > > +	smp_mb();
> > > > +	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> > > > +		membarrier_retry();
> > > > +		goto unlock;
> > > > +	}
> > > 
> > > if CONFIG_CPUMASK_OFFSTACK=1, alloc_cpumask_var call kmalloc. FWIW,
> > > kmalloc calling seems destory the worth of this patch.
> > 
> > Why ? I'm not sure I understand your point. Even if we call kmalloc to
> > allocate the cpumask, this is a constant overhead. The benefit of
> > smp_call_function_many() over smp_call_function_single() is that it
> > scales better by allowing to broadcast IPIs when the architecture
> > supports it. Or maybe I'm missing something ?
> 
> It depend on what mean "constant overhead". kmalloc might cause
> page reclaim and undeterministic delay. I'm not sure (1) How much
> membarrier_retry() slower than smp_call_function_many and (2) Which do
> you think important average or worst performance. Only I note I don't
> think GFP_KERNEL is constant overhead.
> 
> hmm...
> Do you intend to GFP_ATOMIC?
> 
> 
> 
> > > 
> > > #ifdef CONFIG_CPUMASK_OFFSTACK
> > > 	membarrier_retry();
> > > 	goto unlock;
> > > #endif
> > > 
> > > is better? I'm not sure.
> > 
> > Thanks for the comments !
> > 
> > Mathieu
> > 
> 
> 

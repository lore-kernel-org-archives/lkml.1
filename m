Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYBIJf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYBIJf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYBIJfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:35:19 -0500
Received: from www.tglx.de ([62.245.132.106]:41970 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbYBIJfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:35:16 -0500
Date: Sat, 9 Feb 2008 10:33:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "Brown, Len" <len.brown@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Simplify cpu_idle_wait
In-Reply-To: <20080208172430.GA8302@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.00.0802091029400.3145@apollo.tec.linutronix.de>
References: <1199759244.26343.35.camel@localhost.localdomain> <B5B0CFF685D7DF46A05CF1678CFB42ED20E00653@orsmsx423.amr.corp.intel.com> <20080208010550.GA8090@linux-os.sc.intel.com> <200802081128.48621.ak@suse.de>
 <20080208172430.GA8302@linux-os.sc.intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Venki Pallipadi wrote:

> On Fri, Feb 08, 2008 at 11:28:48AM +0100, Andi Kleen wrote:
> > 
> > > -	set_cpus_allowed(current, tmp);
> > > +	smp_mb();
> > > +	/* kick all the CPUs so that they exit out of pm_idle */
> > > +	smp_call_function(do_nothing, NULL, 0, 0);
> > 
> > I think the last argument (wait) needs to be 1 to make sure it is 
> > synchronous (for 32/64) Otherwise the patch looks great.
> 
> Yes. Below is the updated patch

Applied. Thanks,

	 tglx

> Earlier commit 40d6a146629b98d8e322b6f9332b182c7cbff3df
> added smp_call_function in cpu_idle_wait() to kick cpus that are in tickless
> idle. Looking at cpu_idle_wait code at that time, code seemed to be
> over-engineered for a case which is rarely used (while changing idle handler).
> 
> Below is a simplified version of cpu_idle_wait, which just makes
> a dummy smp_call_function to all cpus, to make them come out of old idle handler
> and start using the new idle handler. It eliminates code in the idle loop
> to handle cpu_idle_wait.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Index: linux-2.6.25-rc/arch/x86/kernel/process_32.c
> ===================================================================
> --- linux-2.6.25-rc.orig/arch/x86/kernel/process_32.c
> +++ linux-2.6.25-rc/arch/x86/kernel/process_32.c
> @@ -82,7 +82,6 @@ unsigned long thread_saved_pc(struct tas
>   */
>  void (*pm_idle)(void);
>  EXPORT_SYMBOL(pm_idle);
> -static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
>  
>  void disable_hlt(void)
>  {
> @@ -181,9 +180,6 @@ void cpu_idle(void)
>  		while (!need_resched()) {
>  			void (*idle)(void);
>  
> -			if (__get_cpu_var(cpu_idle_state))
> -				__get_cpu_var(cpu_idle_state) = 0;
> -
>  			check_pgt_cache();
>  			rmb();
>  			idle = pm_idle;
> @@ -208,40 +204,19 @@ static void do_nothing(void *unused)
>  {
>  }
>  
> +/*
> + * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
> + * pm_idle and update to new pm_idle value. Required while changing pm_idle
> + * handler on SMP systems.
> + *
> + * Caller must have changed pm_idle to the new value before the call. Old
> + * pm_idle value will not be used by any CPU after the return of this function.
> + */
>  void cpu_idle_wait(void)
>  {
> -	unsigned int cpu, this_cpu = get_cpu();
> -	cpumask_t map, tmp = current->cpus_allowed;
> -
> -	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
> -	put_cpu();
> -
> -	cpus_clear(map);
> -	for_each_online_cpu(cpu) {
> -		per_cpu(cpu_idle_state, cpu) = 1;
> -		cpu_set(cpu, map);
> -	}
> -
> -	__get_cpu_var(cpu_idle_state) = 0;
> -
> -	wmb();
> -	do {
> -		ssleep(1);
> -		for_each_online_cpu(cpu) {
> -			if (cpu_isset(cpu, map) && !per_cpu(cpu_idle_state, cpu))
> -				cpu_clear(cpu, map);
> -		}
> -		cpus_and(map, map, cpu_online_map);
> -		/*
> -		 * We waited 1 sec, if a CPU still did not call idle
> -		 * it may be because it is in idle and not waking up
> -		 * because it has nothing to do.
> -		 * Give all the remaining CPUS a kick.
> -		 */
> -		smp_call_function_mask(map, do_nothing, 0, 0);
> -	} while (!cpus_empty(map));
> -
> -	set_cpus_allowed(current, tmp);
> +	smp_mb();
> +	/* kick all the CPUs so that they exit out of pm_idle */
> +	smp_call_function(do_nothing, NULL, 0, 1);
>  }
>  EXPORT_SYMBOL_GPL(cpu_idle_wait);
>  
> Index: linux-2.6.25-rc/arch/x86/kernel/process_64.c
> ===================================================================
> --- linux-2.6.25-rc.orig/arch/x86/kernel/process_64.c
> +++ linux-2.6.25-rc/arch/x86/kernel/process_64.c
> @@ -64,7 +64,6 @@ EXPORT_SYMBOL(boot_option_idle_override)
>   */
>  void (*pm_idle)(void);
>  EXPORT_SYMBOL(pm_idle);
> -static DEFINE_PER_CPU(unsigned int, cpu_idle_state);
>  
>  static ATOMIC_NOTIFIER_HEAD(idle_notifier);
>  
> @@ -139,41 +138,19 @@ static void do_nothing(void *unused)
>  {
>  }
>  
> +/*
> + * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
> + * pm_idle and update to new pm_idle value. Required while changing pm_idle
> + * handler on SMP systems.
> + *
> + * Caller must have changed pm_idle to the new value before the call. Old
> + * pm_idle value will not be used by any CPU after the return of this function.
> + */
>  void cpu_idle_wait(void)
>  {
> -	unsigned int cpu, this_cpu = get_cpu();
> -	cpumask_t map, tmp = current->cpus_allowed;
> -
> -	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
> -	put_cpu();
> -
> -	cpus_clear(map);
> -	for_each_online_cpu(cpu) {
> -		per_cpu(cpu_idle_state, cpu) = 1;
> -		cpu_set(cpu, map);
> -	}
> -
> -	__get_cpu_var(cpu_idle_state) = 0;
> -
> -	wmb();
> -	do {
> -		ssleep(1);
> -		for_each_online_cpu(cpu) {
> -			if (cpu_isset(cpu, map) &&
> -					!per_cpu(cpu_idle_state, cpu))
> -				cpu_clear(cpu, map);
> -		}
> -		cpus_and(map, map, cpu_online_map);
> -		/*
> -		 * We waited 1 sec, if a CPU still did not call idle
> -		 * it may be because it is in idle and not waking up
> -		 * because it has nothing to do.
> -		 * Give all the remaining CPUS a kick.
> -		 */
> -		smp_call_function_mask(map, do_nothing, 0, 0);
> -	} while (!cpus_empty(map));
> -
> -	set_cpus_allowed(current, tmp);
> +	smp_mb();
> +	/* kick all the CPUs so that they exit out of pm_idle */
> +	smp_call_function(do_nothing, NULL, 0, 1);
>  }
>  EXPORT_SYMBOL_GPL(cpu_idle_wait);
>  
> @@ -215,9 +192,6 @@ void cpu_idle (void)
>  		while (!need_resched()) {
>  			void (*idle)(void);
>  
> -			if (__get_cpu_var(cpu_idle_state))
> -				__get_cpu_var(cpu_idle_state) = 0;
> -
>  			tick_nohz_stop_sched_tick();
>  
>  			rmb();
> 

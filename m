Return-Path: <linux-kernel-owner+w=401wt.eu-S1423085AbXBUUXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423085AbXBUUXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423086AbXBUUXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:23:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42366 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423085AbXBUUXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:23:54 -0500
Date: Wed, 21 Feb 2007 12:23:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, npiggin@suse.de,
       rostedt@goodmis.org
Subject: Re: [patch 2/2] sched: dynticks idle load balancing - v2
Message-Id: <20070221122344.564fb44f.akpm@linux-foundation.org>
In-Reply-To: <20070216180842.B8744@unix-os.sc.intel.com>
References: <20061213224317.GA2986@elte.hu>
	<20061213231316.GA13849@elte.hu>
	<20061213150314.B12795@unix-os.sc.intel.com>
	<20061213233157.GA20470@elte.hu>
	<20061213151926.C12795@unix-os.sc.intel.com>
	<20061219201247.GA12648@elte.hu>
	<20061219131223.E23105@unix-os.sc.intel.com>
	<20070116113505.GA6294@elte.hu>
	<20070130135709.B32010@unix-os.sc.intel.com>
	<20070216180335.A8744@unix-os.sc.intel.com>
	<20070216180842.B8744@unix-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 18:08:42 -0800
"Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:

> Changes since v1:
> 
>   - Move the idle load balancer selection from schedule()
>     to the first busy scheduler_tick() after restarting the tick.
>     This will avoid the unnecessay ownership changes when 
>     softirq's(which are run in softirqd context in certain -rt
>     configurations) like timer, sched are invoked for every idle tick
>     that happens.
> 
>   - Misc cleanups.
> 
> ---
> Fix the process idle load balancing in the presence of dynticks.
> cpus for which ticks are stopped will sleep till the next event wakes it up.
> Potentially these sleeps can be for large durations and during which today,
> there is no periodic idle load balancing being done.
> 
> This patch nominates an owner among the idle cpus, which does the idle load
> balancing on behalf of the other idle cpus. And once all the cpus are
> completely idle, then we can stop this idle load balancing too. Checks added
> in fast path are minimized.  Whenever there are busy cpus in the system, there
> will be an owner(idle cpu) doing the system wide idle load balancing.
> 
> Open items:
> 1. Intelligent owner selection (like an idle core in a busy package).
> 2. Merge with rcu's nohz_cpu_mask?
> 

I spose I'll hold my nose and merge this, but it creates too much of a mess
to be mergeable into the CPU scheduler, IMO.

Can we please do something to reduce the ifdef density?  And if possible,
all the newly-added returns-from-the-middle-of-a-function?


> +#ifdef CONFIG_NO_HZ
> +static struct {
> +	int load_balancer;
> +	cpumask_t  cpu_mask;
> +} nohz ____cacheline_aligned = {
> +	.load_balancer = -1,
> +	.cpu_mask = CPU_MASK_NONE,
> +};
> +
> +/*
> + * This routine will try to nominate the ilb (idle load balancing)
> + * owner among the cpus whose ticks are stopped. ilb owner will do the idle
> + * load balancing on behalf of all those cpus. If all the cpus in the system
> + * go into this tickless mode, then there will be no ilb owner (as there is
> + * no need for one) and all the cpus will sleep till the next wakeup event
> + * arrives...
> + *
> + * For the ilb owner, tick is not stopped. And this tick will be used
> + * for idle load balancing. ilb owner will still be part of
> + * nohz.cpu_mask..
> + *
> + * While stopping the tick, this cpu will become the ilb owner if there
> + * is no other owner. And will be the owner till that cpu becomes busy
> + * or if all cpus in the system stop their ticks at which point
> + * there is no need for ilb owner.
> + *
> + * When the ilb owner becomes busy, it nominates another owner, during the
> + * next busy scheduler_tick()
> + */
> +int select_nohz_load_balancer(int stop_tick)
> +{
> +	int cpu = smp_processor_id();
> +
> +	if (stop_tick) {
> +		cpu_set(cpu, nohz.cpu_mask);
> +		cpu_rq(cpu)->in_nohz_recently = 1;
> +
> +		/*
> +		 * If we are going offline and still the leader, give up!
> +		 */
> +		if (cpu_is_offline(cpu) && nohz.load_balancer == cpu) {
> +			if (cmpxchg(&nohz.load_balancer,  cpu, -1) != cpu)

So we require that architectures which implement CONFIG_NO_HZ also
implement cmpxchg.

> +				BUG();
> +			return 0;
> +		}
> +
> +		/* time for ilb owner also to sleep */
> +		if (cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
> +			if (nohz.load_balancer == cpu)
> +				nohz.load_balancer = -1;
> +			return 0;
> +		}
> +
> +		if (nohz.load_balancer == -1) {
> +			/* make me the ilb owner */
> +			if (cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
> +				return 1;
> +		} else if (nohz.load_balancer == cpu)
> +			return 1;
> +	} else {
> +		if (!cpu_isset(cpu, nohz.cpu_mask))
> +			return 0;
> +
> +		cpu_clear(cpu, nohz.cpu_mask);
> +
> +		if (nohz.load_balancer == cpu)
> +			if (cmpxchg(&nohz.load_balancer,  cpu, -1) != cpu)
> +				BUG();
> +	}
> +	return 0;
> +}
> +#endif
> +
>  /*
>   * run_rebalance_domains is triggered when needed from the scheduler tick.
>   *
> @@ -3347,15 +3437,46 @@ static DEFINE_SPINLOCK(balancing);
>  
>  static void run_rebalance_domains(struct softirq_action *h)
>  {
> -	int this_cpu = smp_processor_id(), balance = 1;
> -	struct rq *this_rq = cpu_rq(this_cpu);
> -	unsigned long interval;
> +	int balance_cpu = smp_processor_id(), balance;
> +	struct rq *balance_rq = cpu_rq(balance_cpu);
> +	unsigned long interval, next_balance;

One definition per line is preferred.

>  	struct sched_domain *sd;
> -	enum idle_type idle = this_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
> +	enum idle_type idle;
> +
> +#ifdef CONFIG_NO_HZ
> +	cpumask_t cpus = nohz.cpu_mask;
> +	int local_cpu = balance_cpu;
> +	struct rq *local_rq = balance_rq;
> +
> +restart:
> +
> +	if (local_rq->idle_at_tick && nohz.load_balancer == local_cpu) {
> +		if (need_resched())
> +			return;
> +
> +		balance_cpu = first_cpu(cpus);
> +		if (unlikely(balance_cpu >= NR_CPUS))
> +			return;
> +		balance_rq = cpu_rq(balance_cpu);
> +		cpu_clear(balance_cpu, cpus);
> +	}
> +
> +	/*
> +	 * We must be doing idle load balancing for some other idle cpu
> +	 */
> +	if (local_cpu != balance_cpu)
> +		idle = SCHED_IDLE;
> +	else
> +#endif
> +		idle = balance_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
> +

It's not just that this is an eyesore (it is) - it introduces some ongoing
maintenance problems.  I expect this can be pulled out into a separate
function with no loss in quality of generated code.

And that function would be a nice site for a nice comment explaining the
design.  Why do we return if need_resched()?  What is the significance of
(balance_cpu >= NR_CPUS)?


> +
>  	/* Earliest time when we have to call run_rebalance_domains again */
> -	unsigned long next_balance = jiffies + 60*HZ;
> +	next_balance = jiffies + 60*HZ;
> +
> +	for_each_domain(balance_cpu, sd) {
>  
> -	for_each_domain(this_cpu, sd) {
>  		if (!(sd->flags & SD_LOAD_BALANCE))
>  			continue;
>  
> @@ -3374,7 +3495,7 @@ static void run_rebalance_domains(struct
>  		}
>  
>  		if (time_after_eq(jiffies, sd->last_balance + interval)) {
> -			if (load_balance(this_cpu, this_rq, sd, idle, &balance)) {
> +			if (load_balance(balance_cpu, balance_rq, sd, idle, &balance)) {
>  				/*
>  				 * We've pulled tasks over so either we're no
>  				 * longer idle, or one of our SMT siblings is
> @@ -3398,7 +3519,16 @@ out:
>  		if (!balance)
>  			break;
>  	}
> -	this_rq->next_balance = next_balance;
> +	balance_rq->next_balance = next_balance;
> +
> +#ifdef CONFIG_NO_HZ
> +	if (local_rq->idle_at_tick && nohz.load_balancer == local_cpu) {
> +		if (time_after(next_balance, local_rq->next_balance))
> +			local_rq->next_balance = next_balance;
> +	    	if (!cpus_empty(cpus))
> +			goto restart;
> +	}
> +#endif
>  }

A goto in an ifdef :(

Perhaps it can be removed by teaching the caller to call this function again?



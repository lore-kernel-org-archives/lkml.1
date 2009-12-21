Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZLUMOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZLUMOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZLUMOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:14:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42197 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZLUMOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:14:19 -0500
Subject: Re: [patch 1/2] sched: Change the nohz ilb logic from pull to push
 model
From: Peter Zijlstra <peterz@infradead.org>
To: venkatesh.pallipadi@intel.com
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20091211013056.305998000@intel.com>
References: <20091211012748.267627000@intel.com>
	 <20091211013056.305998000@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 13:13:15 +0100
Message-ID: <1261397595.4314.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 17:27 -0800, venkatesh.pallipadi@intel.com wrote:

> @@ -4507,12 +4507,45 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
>  }
>  
>  #ifdef CONFIG_NO_HZ
> +
> +/*
> + * idle load balancing details
> + * - One of the idle CPUs nominates itself as idle load_balancer, while
> + *   entering idle.
> + * - With previous logic, this idle load balancer CPU will not go into
> + *   tickless mode when it is idle and does the idle load balancing for
> + *   all the idle CPUs.
> + * - With new logic, this idle load balancer CPU will also go into
> + *   tickless mode when it is idle, just like all other idle CPUs
> + * - When one of the busy CPUs notice that there may be an idle rebalancing
> + *   needed, they will kick the idle load balancer, which then does idle
> + *   load balancing for all the idle CPUs.
> + * - As idle load balancing looks at the load of all the CPUs, not all busy
> + *   CPUs need to do this idle load balancer kick.
> + * - first_pick_cpu is the one of the busy CPUs which will kick
> + *   idle load balancer when it has more than one process active. This
> + *   eliminates the need for idle load balancing altogether when we have
> + *   only one running process in the system (common case).
> + * - If there are more than one busy CPU, idle load balancer may have
> + *   to run for active_load_balance to happen (i.e., two busy CPUs are
> + *   SMT or core siblings and can run better if they move to different
> + *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
> + *   which will kick idle load balancer as soon as it has any load.
> + * - With previous logic, idle load balancer used to run at every tick.
> + *   With new logic, idle load balancer tracks the rq->next_balance for all
> + *   the idle CPUs and does idle load balancing only when needed.
> + */

Right so like said before, this comments needs a rewrite.

>  static struct {
>  	atomic_t load_balancer;
> -	cpumask_var_t cpu_mask;
> -	cpumask_var_t ilb_grp_nohz_mask;
> +	atomic_t first_pick_cpu;
> +	atomic_t second_pick_cpu;
> +	cpumask_var_t idle_cpus_mask;
> +	cpumask_var_t tmp_nohz_mask;

I don't mind the rename, but tmp_nohz_mask is a really bad name.

> +	unsigned long next_balance;	/* in jiffy units */
>  } nohz ____cacheline_aligned = {
>  	.load_balancer = ATOMIC_INIT(-1),
> +	.first_pick_cpu = ATOMIC_INIT(-1),
> +	.second_pick_cpu = ATOMIC_INIT(-1),
>  };
>  
>  int get_nohz_load_balancer(void)

>  /*
> + * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
> + * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
> + * CPU (if there is one).
> +*/
> +static void nohz_balancer_kick(int cpu)
> +{
> +	int ilb_cpu;
> +
> +	nohz.next_balance++;
> +
> +	ilb_cpu = get_nohz_load_balancer();
> +	if (ilb_cpu < 0) {
> +		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
> +		if (ilb_cpu >= nr_cpu_ids)
> +			return;
> +	}
> +
> +	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
> +		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
> +		resched_cpu(ilb_cpu);
> +	}
> +	return;
> +}

So here you simply send an resched-ipi, which requires the below hack in
schedule()?


> @@ -4673,28 +4722,20 @@ int select_nohz_load_balancer(int stop_tick)
>  			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
>  				BUG();
>  
> +			return;
>  		}
>  
> +		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
> +		atomic_cmpxchg(&nohz.first_pick_cpu, cpu, -1);
> +		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, -1);

If you were to use nr_cpu_ids here instead of -1, you get more
consistent code in nohz_balancer_kick().


> +	ret = atomic_cmpxchg(&nohz.first_pick_cpu, -1, cpu);
> +	if (ret == -1 || ret == cpu) {
> +		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, -1);
> +		if (rq->nr_running > 1)
> +			return 1;
> +	} else {
> +		ret = atomic_cmpxchg(&nohz.second_pick_cpu, -1, cpu);
> +		if (ret == -1 || ret == cpu) {
> +			if (rq->nr_running)
> +				return 1;
>  		}
>  	}

Looked very funny, and took a while to understand why you're doing that,
but yeah, I can't see a better way of doing it either.

The comments confused me more than helped me understand it.

> @@ -5446,8 +5490,19 @@ need_resched_nonpreemptible:
>  
>  	pre_schedule(rq, prev);
>  
> -	if (unlikely(!rq->nr_running))
> +	if (unlikely(!rq->nr_running)) {
> +#ifdef CONFIG_NO_HZ
> +		if (rq->nohz_balance_kick) {
> +			spin_unlock_irq(&rq->lock);
> +			nohz_idle_balance(cpu, rq);
> +			spin_lock_irq(&rq->lock);
> +		} else {
> +			idle_balance(cpu, rq);
> +		}
> +#else
>  		idle_balance(cpu, rq);
> +#endif
> +	}

And I think this is the wrong kind of trade-off, complicating the
schedule()/newidle path for nohz idle balancing.

nohz_balancer_kick() seems like the perfect place to use something like
send_remote_softirq().


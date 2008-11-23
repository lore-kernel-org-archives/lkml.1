Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYKWCEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYKWCEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 21:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYKWCEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 21:04:15 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:30258 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYKWCEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 21:04:15 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC PATCH v4 3/7] sched: nominate preferred wakeup cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
In-Reply-To: <20081121083114.27075.2113.stgit@drishya.in.ibm.com>
References: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
	 <20081121083114.27075.2113.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 03:03:58 +0100
Message-Id: <1227405838.7685.20000.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 14:01 +0530, Vaidyanathan Srinivasan wrote:
> When the system utilisation is low and more cpus are idle,
> then the process waking up from sleep should prefer to
> wakeup an idle cpu from semi-idle cpu package (multi core
> package) rather than a completely idle cpu package which
> would waste power.
> 
> Use the sched_mc balance logic in find_busiest_group() to
> nominate a preferred wakeup cpu.
> 
> This info can be sored in appropriate sched_domain, but
> updating this info in all copies of sched_domain is not
> practical.  Hence this information is stored in root_domain
> struct which is one copy per partitioned sched domain.
> The root_domain can be accessed from each cpu's runqueue
> and there is one copy per partitioned sched domain.
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 79b71f3..d28cd98 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -493,6 +493,17 @@ struct root_domain {
>  #ifdef CONFIG_SMP
>  	struct cpupri cpupri;
>  #endif
> +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +
> +	/*
> +	 * Preferred wake up cpu nominated by sched_mc balance that will be
> +	 * used when most cpus are idle in the system indicating overall very
> +	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
> +	 */
> +	unsigned int sched_mc_preferred_wakeup_cpu;
> +
> +#endif
> +
>  };
>  
>  /*

Do we really need that extra whitespace?

> @@ -3090,6 +3101,7 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
>  	return 0;
>  }
>  
> +
>  /*
>   * find_busiest_group finds and returns the busiest CPU group within the
>   * domain. It calculates and returns the amount of weighted load which

Ditto?

> @@ -3406,6 +3418,9 @@ out_balanced:
>  
>  	if (this == group_leader && group_leader != group_min) {
>  		*imbalance = min_load_per_task;
> +		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP)
> +			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
> +					first_cpu(group_leader->cpumask);

While not strictly needed, I prefer braces around multi-line statments.
It's easier on the eyes.

>  		return group_min;
>  	}
>  #endif
> 


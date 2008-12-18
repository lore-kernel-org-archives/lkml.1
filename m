Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752506AbYLRSMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbYLRSMa (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYLRSMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:12:20 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:34414 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbYLRSMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:12:18 -0500
Date: Thu, 18 Dec 2008 23:42:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-ID: <20081218181210.GG26572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>,
	Pavel Machek <pavel@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218175622.29812.69201.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081218175622.29812.69201.stgit@drishya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-18 23:26:22]:

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
>  kernel/sched.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0b9bbbd..3415fa3 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -493,6 +493,14 @@ struct root_domain {
>  #ifdef CONFIG_SMP
>  	struct cpupri cpupri;
>  #endif
> +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +	/*
> +	 * Preferred wake up cpu nominated by sched_mc balance that will be
> +	 * used when most cpus are idle in the system indicating overall very
> +	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
> +	 */
> +	unsigned int sched_mc_preferred_wakeup_cpu;
> +#endif
>  };
> 
>  /*
> @@ -3407,6 +3415,10 @@ out_balanced:
> 
>  	if (this == group_leader && group_leader != group_min) {
>  		*imbalance = min_load_per_task;
> +		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
> +			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
> +					first_cpu(group_leader->cpumask);
> +		}
>  		return group_min;
>  	}
>  #endif

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir

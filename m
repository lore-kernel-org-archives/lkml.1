Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575Ab0A2I76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0A2I76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295Ab0A2I75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:59:57 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50283 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab0A2I74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:59:56 -0500
Date: Fri, 29 Jan 2010 14:29:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v5 PATCH 1/8] sched: Rename struct rt_bandwidth to
 sched_bandwidth
Message-ID: <20100129085949.GD25191@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com>
 <20100105075824.GF27899@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100105075824.GF27899@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bharata B Rao <bharata@linux.vnet.ibm.com> [2010-01-05 13:28:24]:

> sched: Rename struct rt_bandwidth to sched_bandwidth
> 
> From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Rename struct rt_bandwidth to sched_bandwidth and rename some of the
> routines to generic names (s/rt_/sched_) so that they can be used
> by CFS hard limits code in the subsequent patches.
> 
> No functionality change by this patch.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

Looks good, some nit picks below

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

> ---
>  kernel/sched.c    |  127 ++++++++++++++++++++++++++---------------------------
>  kernel/sched_rt.c |   46 ++++++++++---------
>  2 files changed, 86 insertions(+), 87 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c535cc4..21cf0d5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -139,50 +139,50 @@ struct rt_prio_array {
>  	struct list_head queue[MAX_RT_PRIO];
>  };
> 
> -struct rt_bandwidth {
> +struct sched_bandwidth {
>  	/* nests inside the rq lock: */
> -	raw_spinlock_t		rt_runtime_lock;
> -	ktime_t			rt_period;
> -	u64			rt_runtime;
> -	struct hrtimer		rt_period_timer;
> +	raw_spinlock_t		runtime_lock;
> +	ktime_t			period;
> +	u64			runtime;
> +	struct hrtimer		period_timer;
>  };
> 
> -static struct rt_bandwidth def_rt_bandwidth;
> +static struct sched_bandwidth def_rt_bandwidth;
> 
> -static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
> +static int do_sched_rt_period_timer(struct sched_bandwidth *sched_b, int overrun);
> 
>  static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
>  {
> -	struct rt_bandwidth *rt_b =
> -		container_of(timer, struct rt_bandwidth, rt_period_timer);
> +	struct sched_bandwidth *sched_b =
> +		container_of(timer, struct sched_bandwidth, period_timer);
>  	ktime_t now;
>  	int overrun;
>  	int idle = 0;
> 
>  	for (;;) {
>  		now = hrtimer_cb_get_time(timer);
> -		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
> +		overrun = hrtimer_forward(timer, now, sched_b->period);
> 
>  		if (!overrun)
>  			break;
> 
> -		idle = do_sched_rt_period_timer(rt_b, overrun);
> +		idle = do_sched_rt_period_timer(sched_b, overrun);
>  	}
> 
>  	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
>  }
> 
> -static
> -void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
> +static void init_sched_bandwidth(struct sched_bandwidth *sched_b, u64 period,
> +	u64 runtime, enum hrtimer_restart (*period_timer)(struct hrtimer *))
>  {
> -	rt_b->rt_period = ns_to_ktime(period);
> -	rt_b->rt_runtime = runtime;
> +	sched_b->period = ns_to_ktime(period);
> +	sched_b->runtime = runtime;
> 
> -	raw_spin_lock_init(&rt_b->rt_runtime_lock);
> +	raw_spin_lock_init(&sched_b->runtime_lock);
> 
> -	hrtimer_init(&rt_b->rt_period_timer,
> +	hrtimer_init(&sched_b->period_timer,
>  			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -	rt_b->rt_period_timer.function = sched_rt_period_timer;
> +	sched_b->period_timer.function = *period_timer;

Hmm.. may be I forgetting the "C" language, but why do you dereference
the pointer before assignment? You should be able to directly assign a
function address to the function pointer. Did you see a warning?

>  }
> 
>  static inline int rt_bandwidth_enabled(void)
> @@ -190,42 +190,40 @@ static inline int rt_bandwidth_enabled(void)
>  	return sysctl_sched_rt_runtime >= 0;
>  }
> 
> -static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
> +static void start_sched_bandwidth(struct sched_bandwidth *sched_b)
>  {
>  	ktime_t now;
> 
> -	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
> +	if (!rt_bandwidth_enabled() || sched_b->runtime == RUNTIME_INF)
>  		return;
> 
> -	if (hrtimer_active(&rt_b->rt_period_timer))
> +	if (hrtimer_active(&sched_b->period_timer))
>  		return;
> 
> -	raw_spin_lock(&rt_b->rt_runtime_lock);
> +	raw_spin_lock(&sched_b->runtime_lock);

I don't quite understand why this is a raw_spin_lock

[snip]

-- 
	Balbir

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYGPLO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYGPLO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYGPLOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:14:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbYGPLOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:14:43 -0400
Subject: Re: [PATCH 3/3] sched_clock: stop maximum check on NO HZ
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080707182104.327343504@goodmis.org>
References: <20080707181649.942597764@goodmis.org>
	 <20080707182104.327343504@goodmis.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 13:14:55 +0200
Message-Id: <1216206895.5232.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 14:16 -0400, Steven Rostedt wrote:
> plain text document attachment (sched-clock-no-max-from-idle.patch)
> Working with ftrace I would get large jumps of 11 millisecs or more with
> the clock tracer. This killed the latencing timings of ftrace and also
> caused the irqoff self tests to fail.
> 
> What was happening is with NO_HZ the idle would stop the jiffy counter and
> before the jiffy counter was updated the sched_clock would have a bad
> delta jiffies to compare with the gtod with the maximum.
> 
> The jiffies would stop and the last sched_tick would record the last gtod.
> On wakeup, the sched clock update would compare the gtod + delta jiffies
> (which would be zero) and compare it to the TSC. The TSC would have
> correctly (with a stable TSC) moved forward several jiffies. But because the
> jiffies has not been updated yet the clock would be prevented from moving
> forward because it would appear that the TSC jumped too far ahead.
> 
> The clock would then virtually stop, until the jiffies are updated. Then
> the next sched clock update would see that the clock was very much behind
> since the delta jiffies is now correct. This would then jump the clock
> forward by several jiffies.
> 
> This caused ftrace to report several milliseconds of interrupts off
> latency at every resume from NO_HZ idle.
> 
> This patch adds hooks into the nohz code to disable the checking of the
> maximum clock update when nohz is in effect. It resumes the max check
> when nohz has updated the jiffies again.

IIRC we have code to move jiffies forward over no_hz periods too. So
could this be an ordering issue, in that we should update the jiffies
before we do this bit?

Wouldn't be the first time ftrace causes ordering issues..

/me goes look for where that jiffie stuff was done again.

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/sched.h    |   17 ++++++++++++++++-
>  kernel/sched_clock.c     |   39 ++++++++++++++++++++++++++++++++++++++-
>  kernel/time/tick-sched.c |    2 ++
>  3 files changed, 56 insertions(+), 2 deletions(-)
> 
> Index: linux-tip.git/kernel/sched_clock.c
> ===================================================================
> --- linux-tip.git.orig/kernel/sched_clock.c	2008-07-06 23:29:43.000000000 -0400
> +++ linux-tip.git/kernel/sched_clock.c	2008-07-07 13:14:42.000000000 -0400
> @@ -45,6 +45,9 @@ struct sched_clock_data {
>  	u64			tick_raw;
>  	u64			tick_gtod;
>  	u64			clock;
> +#ifdef CONFIG_NO_HZ
> +	int			check_max;
> +#endif
>  };
>  
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
> @@ -76,11 +79,45 @@ void sched_clock_init(void)
>  		scd->tick_raw = 0;
>  		scd->tick_gtod = ktime_now;
>  		scd->clock = ktime_now;
> +#ifdef CONFIG_NO_HZ
> +		scd->check_max = 1;
> +#endif
>  	}
>  
>  	sched_clock_running = 1;
>  }
>  
> +#ifdef CONFIG_NO_HZ
> +/*
> + * The dynamic ticks makes the delta jiffies inaccurate. This
> + * prevents us from checking the maximum time update.
> + * Disable the maximum check during stopped ticks.
> + */
> +void sched_clock_tick_stop(int cpu)
> +{
> +	struct sched_clock_data *scd = cpu_sdc(cpu);
> +
> +	scd->check_max = 0;
> +}
> +
> +void sched_clock_tick_start(int cpu)
> +{
> +	struct sched_clock_data *scd = cpu_sdc(cpu);
> +
> +	scd->check_max = 1;
> +}
> +
> +static int check_max(struct sched_clock_data *scd)
> +{
> +	return scd->check_max;
> +}
> +#else
> +static int check_max(struct sched_clock_data *scd)
> +{
> +	return 1;
> +}
> +#endif /* CONFIG_NO_HZ */
> +
>  /*
>   * update the percpu scd from the raw @now value
>   *
> @@ -112,7 +149,7 @@ static void __update_sched_clock(struct 
>  	 */
>  	max_clock = scd->tick_gtod + (2 + delta_jiffies) * TICK_NSEC;
>  
> -	if (unlikely(clock + delta > max_clock)) {
> +	if (unlikely(clock + delta > max_clock) && check_max(scd)) {
>  		if (clock < max_clock)
>  			clock = max_clock;
>  		else
> Index: linux-tip.git/include/linux/sched.h
> ===================================================================
> --- linux-tip.git.orig/include/linux/sched.h	2008-07-06 23:02:53.000000000 -0400
> +++ linux-tip.git/include/linux/sched.h	2008-07-06 23:38:33.000000000 -0400
> @@ -1575,13 +1575,28 @@ static inline void sched_clock_idle_slee
>  static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
>  {
>  }
> -#else
> +
> +#ifdef CONFIG_NO_HZ
> +static inline void sched_clock_tick_stop(int cpu)
> +{
> +}
> +
> +static inline void sched_clock_tick_start(int cpu)
> +{
> +}
> +#endif
> +
> +#else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
>  extern void sched_clock_init(void);
>  extern u64 sched_clock_cpu(int cpu);
>  extern void sched_clock_tick(void);
>  extern void sched_clock_idle_sleep_event(void);
>  extern void sched_clock_idle_wakeup_event(u64 delta_ns);
> +#ifdef CONFIG_NO_HZ
> +extern void sched_clock_tick_stop(int cpu);
> +extern void sched_clock_tick_start(int cpu);
>  #endif
> +#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
>  
>  /*
>   * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
> Index: linux-tip.git/kernel/time/tick-sched.c
> ===================================================================
> --- linux-tip.git.orig/kernel/time/tick-sched.c	2008-07-06 23:02:53.000000000 -0400
> +++ linux-tip.git/kernel/time/tick-sched.c	2008-07-07 10:51:21.000000000 -0400
> @@ -276,6 +276,7 @@ void tick_nohz_stop_sched_tick(void)
>  			ts->tick_stopped = 1;
>  			ts->idle_jiffies = last_jiffies;
>  			rcu_enter_nohz();
> +			sched_clock_tick_stop(cpu);
>  		}
>  
>  		/*
> @@ -375,6 +376,7 @@ void tick_nohz_restart_sched_tick(void)
>  	select_nohz_load_balancer(0);
>  	now = ktime_get();
>  	tick_do_update_jiffies64(now);
> +	sched_clock_tick_start(cpu);
>  	cpu_clear(cpu, nohz_cpu_mask);
>  
>  	/*
> 


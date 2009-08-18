Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbZHRTZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbZHRTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZHRTZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:25:58 -0400
Received: from www.tglx.de ([62.245.132.106]:53127 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbZHRTZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:25:57 -0400
Date: Tue, 18 Aug 2009 21:25:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jon Hunter <jon-hunter@ti.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
In-Reply-To: <1250617512-23567-2-git-send-email-jon-hunter@ti.com>
Message-ID: <alpine.LFD.2.00.0908182115270.3361@localhost.localdomain>
References: <1250617512-23567-1-git-send-email-jon-hunter@ti.com> <1250617512-23567-2-git-send-email-jon-hunter@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Jon Hunter wrote:

> From: Jon Hunter <jon-hunter@ti.com>
> 
> The dynamic tick allows the kernel to sleep for periods longer
> than a single tick. This patch prevents that the kernel from
> sleeping for a period longer than the maximum time that the
> current clocksource can count. This ensures that the kernel will
> not lose track of time. This patch adds a function called
> "clocksource_max_deferment()" that calculates the maximum time the
> kernel can sleep for a given clocksource and function called
> "timekeeping_max_deferment()" that returns maximum time the kernel
> can sleep for the current clocksource.
> 
> Signed-off-by: Jon Hunter <jon-hunter@ti.com>
> ---
>  include/linux/clocksource.h |    2 +
>  include/linux/time.h        |    1 +
>  kernel/time/clocksource.c   |   47 +++++++++++++++++++++++++++++++++++
>  kernel/time/tick-sched.c    |   57 ++++++++++++++++++++++++++++++++----------
>  kernel/time/timekeeping.c   |   11 ++++++++
>  5 files changed, 104 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index 9ea40ff..09ed7f1 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -151,6 +151,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
>   *			subtraction of non 64 bit counters
>   * @mult:		cycle to nanosecond multiplier
>   * @shift:		cycle to nanosecond divisor (power of two)
> + * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
>   * @flags:		flags describing special properties
>   * @vread:		vsyscall based read
>   * @resume:		resume function for the clocksource, if necessary
> @@ -168,6 +169,7 @@ struct clocksource {
>  	cycle_t mask;
>  	u32 mult;
>  	u32 shift;
> +	s64 max_idle_ns;

I don't think we should move this to the clocksource. That should go
into the new struct timekeeper and initialized when a clocksource is
selected for timekeeping.

> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index e0f59a2..7a98e90 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -217,6 +217,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	ktime_t last_update, expires, now;
>  	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
>  	int cpu;
> +	s64 time_delta, max_time_delta;
>  
>  	local_irq_save(flags);
>  
> @@ -270,6 +271,18 @@ void tick_nohz_stop_sched_tick(int inidle)
>  		seq = read_seqbegin(&xtime_lock);
>  		last_update = last_jiffies_update;
>  		last_jiffies = jiffies;
> +
> +		/*
> +		 * On SMP we really should only care for the CPU which
> +		 * has the do_timer duty assigned. All other CPUs can
> +		 * sleep as long as they want.
> +		 */
> +		if (cpu == tick_do_timer_cpu ||
> +				tick_do_timer_cpu == TICK_DO_TIMER_NONE)
> +			max_time_delta = timekeeping_max_deferment();
> +		else
> +			max_time_delta = KTIME_MAX;
> +

Is it worth the extra check instead of always using
timekeeping_max_deferment() ?

>  	} while (read_seqretry(&xtime_lock, seq));
>  
>  	/* Get the next timer wheel timer */
> @@ -289,11 +302,30 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	if ((long)delta_jiffies >= 1) {
>  
>  		/*
> -		* calculate the expiry time for the next timer wheel
> -		* timer
> -		*/
> -		expires = ktime_add_ns(last_update, tick_period.tv64 *
> -				   delta_jiffies);
> +		 * calculate the expiry time for the next timer wheel
> +		 * timer. delta_jiffies >= NEXT_TIMER_MAX_DELTA signals
> +		 * that there is no timer pending or at least extremely
> +		 * far into the future (12 days for HZ=1000). In this
> +		 * case we set the expiry to the end of time.
> +		 */
> +		if (likely(delta_jiffies < NEXT_TIMER_MAX_DELTA)) {
> +
> +			/*
> +			 * Calculate the time delta for the next timer event.
> +			 * If the time delta exceeds the maximum time delta
> +			 * permitted by the current clocksource then adjust
> +			 * the time delta accordingly to ensure the
> +			 * clocksource does not wrap.
> +			 */
> +			time_delta = tick_period.tv64 * delta_jiffies;
> +
> +			if (time_delta > max_time_delta)
> +				time_delta = max_time_delta;
> +
> +			expires = ktime_add_ns(last_update, time_delta);
> +		} else {
> +			expires.tv64 = KTIME_MAX;
> +		}

This looks incorrect. You set expires to KTIME_MAX when no timer is
pending, but that defeats the purpose of this patch. When we hit this
code path and the next interrupt comes in after the timekeeping
clocksource wrapped we are bust.
  
Thanks,

	tglx

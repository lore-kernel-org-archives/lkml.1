Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbXLGSud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbXLGSud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbXLGSuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:50:13 -0500
Received: from smtp1.Stanford.EDU ([171.67.22.28]:41041 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbXLGSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:50:11 -0500
Subject: Re: [git pull] x86/hrtimer/acpi fixes
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20071207183633.GC26778@elte.hu>
References: <20071207183633.GC26778@elte.hu>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 10:49:46 -0800
Message-Id: <1197053386.32023.13.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-07 at 19:36 +0100, Ingo Molnar wrote:
> Linus, please pull the latest x86 git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> This contains 3 x86/hrtimer/hpet/ACPI fixes from Thomas: the ACPI fix 
> has been ACK-ed by Venki. Build and boot tested on various boxes.

Ingo, I was about to post about timer problems in 2.6.23.9+rt12 when I
saw this. Would this be related / should I test / will this solve
everything? :-)

What I'm seeing is jack "delays" that go away if I boot with
"idle=poll", just like it was happening a long time ago. Smells like
'time of day' glitches when the process switches cpus (this is on a dual
core intel laptop). 

Does not happen in 2.6.22.10 + rt9 - well, I do see very occassional
delay warnings there as well. 

I also see occassional complete hangs but I don't have a way of knowing
what triggers that. 

-- Fernando


> ------------------>
> Thomas Gleixner (3):
>       hrtimers: avoid overflow for large relative timeouts
>       clockevents: warn once when program_event() is called with negative expiry
>       ACPI: move timer broadcast before busmaster disable
> 
>  drivers/acpi/processor_idle.c |   19 ++++++++++++++-----
>  kernel/hrtimer.c              |    8 ++++++++
>  kernel/time/clockevents.c     |    5 +++++
>  3 files changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index b1fbee3..2fe34cc 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -531,6 +531,11 @@ static void acpi_processor_idle(void)
>  
>  	case ACPI_STATE_C3:
>  		/*
> +		 * Must be done before busmaster disable as we might
> +		 * need to access HPET !
> +		 */
> +		acpi_state_timer_broadcast(pr, cx, 1);
> +		/*
>  		 * disable bus master
>  		 * bm_check implies we need ARB_DIS
>  		 * !bm_check implies we need cache flush
> @@ -557,7 +562,6 @@ static void acpi_processor_idle(void)
>  		/* Get start time (ticks) */
>  		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>  		/* Invoke C3 */
> -		acpi_state_timer_broadcast(pr, cx, 1);
>  		/* Tell the scheduler that we are going deep-idle: */
>  		sched_clock_idle_sleep_event();
>  		acpi_cstate_enter(cx);
> @@ -1401,9 +1405,6 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
>  	if (acpi_idle_suspend)
>  		return(acpi_idle_enter_c1(dev, state));
>  
> -	if (pr->flags.bm_check)
> -		acpi_idle_update_bm_rld(pr, cx);
> -
>  	local_irq_disable();
>  	current_thread_info()->status &= ~TS_POLLING;
>  	/*
> @@ -1418,13 +1419,21 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
>  		return 0;
>  	}
>  
> +	/*
> +	 * Must be done before busmaster disable as we might need to
> +	 * access HPET !
> +	 */
> +	acpi_state_timer_broadcast(pr, cx, 1);
> +
> +	if (pr->flags.bm_check)
> +		acpi_idle_update_bm_rld(pr, cx);
> +
>  	if (cx->type == ACPI_STATE_C3)
>  		ACPI_FLUSH_CPU_CACHE();
>  
>  	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>  	/* Tell the scheduler that we are going deep-idle: */
>  	sched_clock_idle_sleep_event();
> -	acpi_state_timer_broadcast(pr, cx, 1);
>  	acpi_idle_do_entry(cx);
>  	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>  
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 22a2514..e65dd0b 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -850,6 +850,14 @@ hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
>  #ifdef CONFIG_TIME_LOW_RES
>  		tim = ktime_add(tim, base->resolution);
>  #endif
> +		/*
> +		 * Careful here: User space might have asked for a
> +		 * very long sleep, so the add above might result in a
> +		 * negative number, which enqueues the timer in front
> +		 * of the queue.
> +		 */
> +		if (tim.tv64 < 0)
> +			tim.tv64 = KTIME_MAX;
>  	}
>  	timer->expires = tim;
>  
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 822beeb..5fb139f 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -78,6 +78,11 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
>  	unsigned long long clc;
>  	int64_t delta;
>  
> +	if (unlikely(expires.tv64 < 0)) {
> +		WARN_ON_ONCE(1);
> +		return -ETIME;
> +	}
> +
>  	delta = ktime_to_ns(ktime_sub(expires, now));
>  
>  	if (delta <= 0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


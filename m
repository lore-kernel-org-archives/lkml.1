Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYLOL7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYLOL7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYLOL71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:59:27 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53280 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYLOL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:59:26 -0500
Date: Mon, 15 Dec 2008 12:31:28 +0100
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: Re: [RFC][PATCH] Fix cpu hotplug hang
Message-ID: <20081215123128.172b21be@bull.net>
In-Reply-To: <20081201140907.56743abd@bull.net>
References: <20081201140907.56743abd@bull.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 14:09:07 +0100 Sebastien Dugue <sebastien.dugue@bull.net> wrote:

> 
>   Hi Thomas, Ingo,
> 
>   here is a patch that fixes a CPU hotplug hang I get on a Power6 box. It may
> not be the only possible fix but it appears to be the cleanest I can think of
> at the moment.
> 
>   Comments welcomed.

  Ingo, Thomas, anybody care to comment on the hang and this possible fix?

> 
>   Thanks,
> 
>   Sebastien.
> 
> 
> From b3bf273f7a91a686db25112278fc554b47aa30c6 Mon Sep 17 00:00:00 2001
> From: Sebastien Dugue <sebastien.dugue@bull.net>
> Date: Mon, 1 Dec 2008 12:22:06 +0100
> Subject: [PATCH] Fix cpu hotplug hang
> 
>   On architectures that support offlining all cpus (at least powerpc/pseries),
> hot-unpluging the tick_do_timer_cpu can result in a system hang.
> 
>   This comes from the fact that if the cpu going down happens to be the
> cpu doing the tick, then as the tick_do_timer_cpu handover happens after the
> cpu is dead (via the CPU_DEAD notification), we're left without ticks,
> jiffies are frozen and any task relying on timers (msleep, ...) is stuck.
> That's particularly the case for the cpu looping in __cpu_die() waiting
> for the dying cpu to be dead.
> 
>   This patch addresses this by having the tick_do_timer_cpu handover happen
> earlier during the CPU_DYING notification. For this, a new clockevent
> notification type is introduced (CLOCK_EVT_NOTIFY_CPU_DYING) which is triggered
> in hrtimer_cpu_notify().
> 
> Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/clockchips.h |    1 +
>  kernel/hrtimer.c           |    4 ++++
>  kernel/time/tick-common.c  |   26 +++++++++++++++++++-------
>  3 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index ed3a5d4..c6de413 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -36,6 +36,7 @@ enum clock_event_nofitiers {
>  	CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
>  	CLOCK_EVT_NOTIFY_SUSPEND,
>  	CLOCK_EVT_NOTIFY_RESUME,
> +	CLOCK_EVT_NOTIFY_CPU_DYING,
>  	CLOCK_EVT_NOTIFY_CPU_DEAD,
>  };
>  
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 47e6334..b870bd0 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1794,6 +1794,10 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
>  		break;
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> +	case CPU_DYING:
> +	case CPU_DYING_FROZEN:
> +		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, &cpu);
> +		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
>  		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index df12434..152871c 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -274,6 +274,21 @@ out_bc:
>  }
>  
>  /*
> + * Transfer the do_timer job away from a dying cpu.
> + *
> + * Called with interrupts disabled.
> + */
> +static void tick_handover_do_timer(unsigned int *cpup)
> +{
> +	if (*cpup == tick_do_timer_cpu) {
> +		int cpu = first_cpu(cpu_online_map);
> +
> +		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu :
> +			TICK_DO_TIMER_NONE;
> +	}
> +}
> +
> +/*
>   * Shutdown an event device on a given cpu:
>   *
>   * This is called on a life CPU, when a CPU is dead. So we cannot
> @@ -297,13 +312,6 @@ static void tick_shutdown(unsigned int *cpup)
>  		clockevents_exchange_device(dev, NULL);
>  		td->evtdev = NULL;
>  	}
> -	/* Transfer the do_timer job away from this cpu */
> -	if (*cpup == tick_do_timer_cpu) {
> -		int cpu = first_cpu(cpu_online_map);
> -
> -		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu :
> -			TICK_DO_TIMER_NONE;
> -	}
>  	spin_unlock_irqrestore(&tick_device_lock, flags);
>  }
>  
> @@ -357,6 +365,10 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
>  		tick_broadcast_oneshot_control(reason);
>  		break;
>  
> +	case CLOCK_EVT_NOTIFY_CPU_DYING:
> +		tick_handover_do_timer(dev);
> +		break;
> +
>  	case CLOCK_EVT_NOTIFY_CPU_DEAD:
>  		tick_shutdown_broadcast_oneshot(dev);
>  		tick_shutdown_broadcast(dev);
> -- 
> 1.6.0.1.308.gede4c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

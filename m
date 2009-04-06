Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZDFK6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZDFK6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 06:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZDFK6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 06:58:37 -0400
Received: from www.tglx.de ([62.245.132.106]:45699 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbZDFK6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 06:58:36 -0400
Date: Mon, 6 Apr 2009 12:56:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v4 RFC PATCH 4/4] timers: logic to move non pinned timers
In-Reply-To: <20090406104228.GB17412@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0904061248120.747@localhost.localdomain>
References: <20090401113128.GA22478@linux.vnet.ibm.com> <20090401113738.GE22478@linux.vnet.ibm.com> <alpine.LFD.2.00.0904032142460.12916@localhost.localdomain> <20090406051656.GA17412@linux.vnet.ibm.com> <20090406104228.GB17412@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun,

On Mon, 6 Apr 2009, Arun R Bharadwaj wrote:
>  
> +ktime_t clockevents_get_next_event(int cpu)
> +{
> +	struct tick_device *td;
> +	struct clock_event_device *dev;
> +
> +	td = &per_cpu(tick_cpu_device, cpu);
> +	dev = td->evtdev;
> +
> +	return dev->next_event;
> +}
> +

Preferrably this function should be in the clock events code and a
stub inline function which returns KTIME_MAX for non clock events
archs is probably necessary as well.

>  /*
>   * Switch the timer base to the current CPU when possible.
>   */
> @@ -198,8 +211,17 @@ switch_hrtimer_base(struct hrtimer *time
>  {
>  	struct hrtimer_clock_base *new_base;
>  	struct hrtimer_cpu_base *new_cpu_base;
> +	int cpu, preferred_cpu = -1;
> +
> +	cpu = smp_processor_id();
> +	if (get_sysctl_timer_migration() && !pinned && idle_cpu(cpu)) {
> +		preferred_cpu = get_nohz_load_balancer();
> +		if (preferred_cpu >= 0)
> +			cpu = preferred_cpu;
> +	}
>  
> -	new_cpu_base = &__get_cpu_var(hrtimer_bases);
> +again:
> +	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
>  	new_base = &new_cpu_base->clock_base[base->index];
>  
>  	if (base != new_base) {
> @@ -220,6 +242,32 @@ switch_hrtimer_base(struct hrtimer *time
>  		spin_unlock(&base->cpu_base->lock);
>  		spin_lock(&new_base->cpu_base->lock);
>  		timer->base = new_base;
> +
> +		if (cpu == preferred_cpu) {
> +			/* Calculate clock monotonic expiry time */
> +			ktime_t expires = ktime_sub(hrtimer_get_expires(timer),
> +							new_base->offset);
> +
> +			/*
> +			 * Get the next event on target cpu from the
> +			 * clock events layer.
> +			 * This covers the highres=off nohz=on case as well.
> +			 */
> +			ktime_t next = clockevents_get_next_event(cpu);
> +
> +			ktime_t delta = ktime_sub(expires, next);
> +
> +			/*
> +			 * We do not migrate the timer when it is expiring
> +			 * before the next event on the target cpu because
> +			 * we cannot reprogram the target cpu hardware and
> +			 * we would cause it to fire late.
> +			 */
> +			if (delta.tv64 < 0) {
> +				cpu = smp_processor_id();

  You are missing a small but fatal detail here: You hold
  new_base->cpu_base->lock. So you need to do:

  			    spin_unlock(&new_base->cpu_base->lock);
			    spin_lock(&base->cpu_base->lock);
  
> +				goto again;
> +			}

  Also you need to move

>  		timer->base = new_base;

  here to avoid a stale timer->base setting.

> +		}
>  	}
>  	return new_base;
>  }

Thanks,

	tglx

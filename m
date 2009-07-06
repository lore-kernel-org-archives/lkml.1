Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZGFOHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZGFOHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZGFOHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:07:41 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:49261 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbZGFOHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:07:40 -0400
Message-ID: <4A52051A.60407@gmail.com>
Date: Mon, 06 Jul 2009 16:07:22 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] optimized ktime_get[_ts] for GENERIC_TIME=y
References: <20090706154933.5a1f8990@skybase>
In-Reply-To: <20090706154933.5a1f8990@skybase>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 06 Jul 2009 16:07:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky a écrit :
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> The generic ktime_get function defined in kernel/hrtimer.c is suboptimial
> for GENERIC_TIME=y:
> 
>  0)               |  ktime_get() {
>  0)               |    ktime_get_ts() {
>  0)               |      getnstimeofday() {
>  0)               |        read_tod_clock() {
>  0)   0.601 us    |        }
>  0)   1.938 us    |      }
>  0)               |      set_normalized_timespec() {
>  0)   0.602 us    |      }
>  0)   4.375 us    |    }
>  0)   5.523 us    |  }
> 
> Overall there are two read_seqbegin/read_seqretry loops and a lot of
> unnecessary struct timespec calculations. ktime_get returns a nano second
> value which is the sum of xtime, wall_to_monotonic and the nano second
> delta from the clock source.
> 
> ktime_get can be optimized for GENERIC_TIME=y. The new version only calls
> clocksource_read:
> 
>  0)               |  ktime_get() {
>  0)               |    read_tod_clock() {
>  0)   0.610 us    |    }
>  0)   1.977 us    |  }
> 
> It uses a single read_seqbegin/readseqretry loop and just adds everthing
> to a nano second value.
> 
> ktime_get_ts is optimized in a similar fashion.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  kernel/hrtimer.c          |    4 ++
>  kernel/time/timekeeping.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
> 
> 
> diff -urpN linux-2.5/kernel/hrtimer.c linux-2.5-patched/kernel/hrtimer.c
> --- linux-2.5/kernel/hrtimer.c	2009-07-03 10:46:07.000000000 +0200
> +++ linux-2.5-patched/kernel/hrtimer.c	2009-07-03 10:46:23.000000000 +0200
> @@ -46,6 +46,7 @@
>  
>  #include <asm/uaccess.h>
>  
> +#ifndef CONFIG_GENERIC_TIME
>  /**
>   * ktime_get - get the monotonic time in ktime_t format
>   *
> @@ -60,6 +61,7 @@ ktime_t ktime_get(void)
>  	return timespec_to_ktime(now);
>  }
>  EXPORT_SYMBOL_GPL(ktime_get);
> +#endif
>  
>  /**
>   * ktime_get_real - get the real (wall-) time in ktime_t format
> @@ -104,6 +106,7 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, 
>  	}
>  };
>  
> +#ifndef CONFIG_GENERIC_TIME
>  /**
>   * ktime_get_ts - get the monotonic clock in timespec format
>   * @ts:		pointer to timespec variable
> @@ -128,6 +131,7 @@ void ktime_get_ts(struct timespec *ts)
>  				ts->tv_nsec + tomono.tv_nsec);
>  }
>  EXPORT_SYMBOL_GPL(ktime_get_ts);
> +#endif
>  
>  /*
>   * Get the coarse grained time at the softirq based on xtime and
> diff -urpN linux-2.5/kernel/time/timekeeping.c linux-2.5-patched/kernel/time/timekeeping.c
> --- linux-2.5/kernel/time/timekeeping.c	2009-07-03 10:46:07.000000000 +0200
> +++ linux-2.5-patched/kernel/time/timekeeping.c	2009-07-03 10:46:23.000000000 +0200
> @@ -118,6 +118,69 @@ void getnstimeofday(struct timespec *ts)
>  
>  EXPORT_SYMBOL(getnstimeofday);
>  
> +ktime_t ktime_get(void)
> +{
> +	cycle_t cycle_now, cycle_delta;
> +	struct timespec time;
> +	unsigned long seq;
> +	s64 nsecs;
> +
> +	do {
> +		seq = read_seqbegin(&xtime_lock);

minor nit : read_seqbegin() returns an "unsigned int", not an "unsigned long"

But apparently, most callers store the value into an unsigned long... oh well...

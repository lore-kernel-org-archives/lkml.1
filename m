Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbZEBT2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbZEBT2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZEBT2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:28:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962AbZEBT2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:28:13 -0400
Date: Sat, 2 May 2009 12:24:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dimitri Sivanich <sivanich@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 2/3] timer: move calc_load to softirq
Message-Id: <20090502122459.ccc870fc.akpm@linux-foundation.org>
In-Reply-To: <20090502190545.489264416@linutronix.de>
References: <20090502190500.513452861@linutronix.de>
	<20090502190545.489264416@linutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 May 2009 19:06:35 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:

> xtime_lock is held write locked across calc_load() which iterates over
> all online CPUs. That can cause long latencies for xtime_lock readers
> on large SMP systems. The load average calculation is an rough
> estimate anyway so there is no real need to protect the readers
> vs. the update. It's not a problem when the avenrun array is updated
> while a reader copies the values.
> 
> Move the calculation to the softirq and reduce the xtime_lock write
> locked section. This also reduces the interrupts off section.
> 
> ...
>
> +static atomic_t avenrun_ticks;
> +static DEFINE_SPINLOCK(avenrun_lock);
> +static DEFINE_PER_CPU(int, avenrun_calculate);
> +
>  static unsigned long
>  calc_load(unsigned long load, unsigned long exp, unsigned long active)
>  {
> @@ -1143,23 +1145,47 @@ calc_load(unsigned long load, unsigned l
>  
>  /*
>   * calc_load - given tick count, update the avenrun load estimates.
> - * This is called while holding a write_lock on xtime_lock.
>   */
> -static void calc_global_load(unsigned long ticks)
> +static void calc_global_load(void)
>  {
> -	unsigned long active_tasks; /* fixed-point */
> -	static int count = LOAD_FREQ;
> +	unsigned long active_tasks = nr_active() * FIXED_1;
>  
> -	count -= ticks;
> -	if (unlikely(count < 0)) {
> -		active_tasks = nr_active() * FIXED_1;
> -		do {
> -			avenrun[0] = calc_load(avenrun[0], EXP_1, active_tasks);
> -			avenrun[1] = calc_load(avenrun[1], EXP_5, active_tasks);
> -			avenrun[2] = calc_load(avenrun[2], EXP_15, active_tasks);
> -			count += LOAD_FREQ;
> -		} while (count < 0);
> +	avenrun[0] = calc_load(avenrun[0], EXP_1, active_tasks);
> +	avenrun[1] = calc_load(avenrun[1], EXP_5, active_tasks);
> +	avenrun[2] = calc_load(avenrun[2], EXP_15, active_tasks);
> +}
> +
> +/*
> + * Check whether do_timer has set avenrun_calculate. The variable is
> + * cpu local so we avoid cache line bouncing of avenrun_lock and
> + * avenrun_ticks. avenrun_lock protects the avenrun calculation.
> + */
> +static void check_calc_load(void)
> +{
> +	int ticks, *calc = &__get_cpu_var(avenrun_calculate);
> +
> +	if (!*calc)
> +		return;
> +
> +	spin_lock(&avenrun_lock);
> +	ticks = atomic_read(&avenrun_ticks);
> +	if (ticks >= LOAD_FREQ) {
> +		atomic_sub(LOAD_FREQ, &avenrun_ticks);
> +		calc_global_load();
>  	}
> +	spin_unlock(&avenrun_lock);
> +	*calc = 0;
> +}

I wonder if we really really need avenrun_lock.  Various bits of code
(eg net/sched/em_meta.c) cheerily read avenrun[] without locking.

avenrun_lock could be made static within check_calc_load().



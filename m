Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbYEIMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbYEIMOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbYEIMN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:13:58 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:60851 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbYEIMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:13:57 -0400
Message-ID: <48243FF9.6040300@googlemail.com>
Date: Fri, 09 May 2008 14:13:45 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hinko.kocevar@cetrtapot.si
Subject: Re: CONFIG_PRINTK_TIME broken on git HEAD ?
References: <48222C7C.2050807@googlemail.com>	 <20080507154155.2b472bb1.akpm@linux-foundation.org>	 <482233CD.70502@googlemail.com>  <4822DD4E.3010000@googlemail.com>	 <1210245238.13978.199.camel@twins>  <4822E23F.8040101@googlemail.com> <1210325973.13978.216.camel@twins>
In-Reply-To: <1210325973.13978.216.camel@twins>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-05-08 at 13:21 +0200, Gabriel C wrote:
> 
>>> Ok, so the issue is that the clock doesn't start at 0, but at:
>>> 4294014.506571 ?
>> At least on my box , yes.
>>
> 
> Does this work for you?

No it does not , I still get :

....

[    0.000000] PERCPU: Allocating 42756 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
[4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010723                                                               

...

> 
> ---
> 
> Subject: sched: fixup sched-clock offset
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> It could happen that ktime doesn't start at 0.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched_clock.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6-2/kernel/sched_clock.c
> ===================================================================
> --- linux-2.6-2.orig/kernel/sched_clock.c
> +++ linux-2.6-2/kernel/sched_clock.c
> @@ -59,21 +59,23 @@ static inline struct sched_clock_data *c
>  	return &per_cpu(sched_clock_data, cpu);
>  }
>  
> +static __read_mostly u64 ktime_offset;
> +
>  void sched_clock_init(void)
>  {
> -	u64 ktime_now = ktime_to_ns(ktime_get());
> -	u64 now = 0;
>  	int cpu;
>  
> +	ktime_offset = ktime_to_ns(ktime_get());
> +
>  	for_each_possible_cpu(cpu) {
>  		struct sched_clock_data *scd = cpu_sdc(cpu);
>  
>  		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>  		scd->prev_jiffies = jiffies;
> -		scd->prev_raw = now;
> -		scd->tick_raw = now;
> -		scd->tick_gtod = ktime_now;
> -		scd->clock = ktime_now;
> +		scd->prev_raw = 0;
> +		scd->tick_raw = 0;
> +		scd->tick_gtod = 0;
> +		scd->clock = 0;
>  	}
>  }
>  
> @@ -177,7 +179,7 @@ void sched_clock_tick(void)
>  	WARN_ON_ONCE(!irqs_disabled());
>  
>  	now = sched_clock();
> -	now_gtod = ktime_to_ns(ktime_get());
> +	now_gtod = ktime_to_ns(ktime_get()) - ktime_offset;
>  
>  	__raw_spin_lock(&scd->lock);
>  	__update_sched_clock(scd, now);
> 
> 
> 

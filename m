Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYLVPRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYLVPRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 10:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYLVPR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 10:17:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41611 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbYLVPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 10:17:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f3StYemQa5QFsleFbkDH4Jv+qftPkQqw4vOLzgPHv/rONFZTyOy0x8pUSeFHFVU/oE
         xkUrEGINhQ7j+XJJgpOCJNDK/mte/SU5xNWG4TrYuvW+URSTOjNr9XxDZNmSGAhz3HPS
         +KlHxE77WehpM5PW3+OXELulw5ZHLnQBNJzgY=
Date: Mon, 22 Dec 2008 18:17:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while
	interrupt hanging
Message-ID: <20081222151723.GA7927@localhost>
References: <494EEC60.4080708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494EEC60.4080708@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Frederic Weisbecker - Mon, Dec 22, 2008 at 02:24:48AM +0100]
| Impact: avoid hanging on slow systems
| 
| While using the function graph tracer on a virtualized system, the hrtimer_interrupt
| can hang the system on an infinite loop.
| This can be caused on several situation where something intrusive is slowing the
| system (ie: tracing) and the next clock events to program are always before the current
| time.
| This patch implements a reasonable compromise. If such a situation is detected, we share
| the CPUs time in 1/4 to process the hrtimer interrupts. This is enough to let the system
| running without serious starvation.
| 
| It has been successfully tested under VirtualBox with 1000 HZ and 100 HZ with function graph
| tracer launched. On both cases, the clock events were increased until about 25 ms periodic ticks,
| which means 40 HZ.
| 
| Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
| Cc: Thomas Gleixner <tglx@linutronix.de>
| ---
|  kernel/hrtimer.c |   30 +++++++++++++++++++++++++++++-
|  1 files changed, 29 insertions(+), 1 deletions(-)
| 
| diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
| index bda9cb9..02f2477 100644
| --- a/kernel/hrtimer.c
| +++ b/kernel/hrtimer.c
| @@ -1171,6 +1171,29 @@ static void __run_hrtimer(struct hrtimer *timer)
|  
|  #ifdef CONFIG_HIGH_RES_TIMERS
|  
| +static int force_clock_reprogram;
| +
| +/*
| + * After 5 iteration's attempts, we consider that hrtimer_interrupt()
| + * is hanging, which could happen with something that slows the interrupt
| + * such as the tracing. Then we force the clock reprogramming for each future
| + * hrtimer interrupts to avoid infinite loops and use the min_delta_ns
| + * threshold that we will overwrite.
| + * The next tick event will be scheduled to 3 times we currently spend on
| + * hrtimer_interrupt(). This gives a good compromise, the cpus will spend
| + * 1/4 of their time to process the hrtimer interrupts. This is enough to
| + * let it running without serious starvation.
| + */
| +
| +static inline void
| +hrtimer_interrupt_hanging(struct clock_event_device *dev,
| +			ktime_t try_time)
| +{
| +	force_clock_reprogram = 1;
| +	dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
| +	printk(KERN_WARNING "hrtimer: interrupt too slow, "
| +		"forcing clock min delta to %lu ns\n", dev->min_delta_ns);
| +}
|  /*
|   * High resolution timer interrupt
|   * Called with interrupts disabled
| @@ -1180,6 +1203,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
|  	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
|  	struct hrtimer_clock_base *base;
|  	ktime_t expires_next, now;
| +	int nr_retries = 0;
|  	int i;
|  
|  	BUG_ON(!cpu_base->hres_active);
| @@ -1187,6 +1211,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
|  	dev->next_event.tv64 = KTIME_MAX;
|  
|   retry:
| +	/* 5 retries is enough to notice a hang */
| +	if (!(++nr_retries % 5))
| +		hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now));
| +
|  	now = ktime_get();

Hi Frederic,

is it really needed to use mod operation here? Why
cant we test for plain 5 and flush it to zero then?
I mean something like

	if (++nr_retries > 5) {
		nr_retries = 0;
		...
	}

Did I miss anything?

		- Cyrill -

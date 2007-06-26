Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXFZALz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXFZALz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXFZALs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:11:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbXFZALr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:11:47 -0400
Date: Mon, 25 Jun 2007 17:11:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch -mm 09/28] Tick management: spread timer interrupt
Message-Id: <20070625171115.73a42e93.akpm@linux-foundation.org>
In-Reply-To: <20070623124030.531042944@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
	<20070623124030.531042944@inhelltoy.tec.linutronix.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 13:32:34 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> From: john stultz <johnstul@us.ibm.com>
> 
> After discussing w/ Thomas over IRC, it seems the issue is the sched
> tick fires on every cpu at the same time, causing extra lock contention.
> 
> This smaller change, adds an extra offset per cpu so the ticks don't
> line up. This patch also drops the idle latency from 40us down to under
> 20us.
> 
> Signed-off-by: john stultz <johnstul@us.ibm.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  kernel/time/tick-sched.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.22-rc4-mm/kernel/time/tick-sched.c
> ===================================================================
> --- linux-2.6.22-rc4-mm.orig/kernel/time/tick-sched.c	2007-06-23 14:38:56.000000000 +0200
> +++ linux-2.6.22-rc4-mm/kernel/time/tick-sched.c	2007-06-23 14:38:58.000000000 +0200
> @@ -573,6 +573,7 @@ void tick_setup_sched_timer(void)
>  {
>  	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
>  	ktime_t now = ktime_get();
> +	u64 offset;
>  
>  	/*
>  	 * Emulate tick processing via per-CPU hrtimers:
> @@ -581,8 +582,12 @@ void tick_setup_sched_timer(void)
>  	ts->sched_timer.function = tick_sched_timer;
>  	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
>  
> -	/* Get the next period */
> +	/* Get the next period (per cpu) */
>  	ts->sched_timer.expires = tick_init_jiffy_update();
> +	offset = ktime_to_ns(tick_period) >> 1;
> +	do_div(offset, NR_CPUS);

With CONFIG_NR_CPUS=128 on a 2-way this'll be a pretty lumpy spreading? 
Perhaps it woud be better to use num_possible_cpus() here?


> +	offset *= smp_processor_id();
> +	ts->sched_timer.expires = ktime_add_ns(ts->sched_timer.expires, offset);
>  
>  	for (;;) {
>  		hrtimer_forward(&ts->sched_timer, now, tick_period);
> 
> -- 

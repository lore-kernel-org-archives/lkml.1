Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYBQQjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYBQQjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYBQQjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:39:13 -0500
Received: from www.tglx.de ([62.245.132.106]:48667 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbYBQQjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:39:12 -0500
Date: Sun, 17 Feb 2008 17:38:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Timer cleanups
In-Reply-To: <20080204234813.GA1927@elf.ucw.cz>
Message-ID: <alpine.LFD.1.00.0802171735540.7583@apollo.tec.linutronix.de>
References: <20080204234813.GA1927@elf.ucw.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Pavel Machek wrote:
> 
> Add anotations, so that timertop produces nicer results. Relative
> expiry time can get negative, so it should be signed.
> 
> Signed-off-by: Pavel Machek <Pavel@suse.cz>

Please do not mix patches for arch / generic code 

> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 429d084..235fd6c 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -368,8 +368,8 @@ static int hpet_clocksource_register(voi
>  	return 0;
>  }
>  
> -/*
> - * Try to setup the HPET timer
> +/**
> + * hpet_enable - Try to setup the HPET timer. Returns 1 on success.
>   */
>  int __init hpet_enable(void)
>  {

Applied to x86.

> diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
> index d3d94c1..0fab3ca 100644
> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c
> @@ -65,9 +65,9 @@ #ifdef CONFIG_TIMER_STATS
>  	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
>  #endif
>  	SEQ_printf(m, "\n");
> -	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
> +	SEQ_printf(m, " # expires at %Lu nsecs [in %Ld nsecs]\n",
>  		(unsigned long long)ktime_to_ns(timer->expires),
> -		(unsigned long long)(ktime_to_ns(timer->expires) - now));
> +		(long long)(ktime_to_ns(timer->expires) - now));
>  }

Applied to -hrt.

>  static void
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 52db48e..6cbec10 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -219,6 +219,7 @@ int queue_delayed_work_on(int cpu, struc
>  	struct timer_list *timer = &dwork->timer;
>  	struct work_struct *work = &dwork->work;
>  
> +	timer_stats_timer_set_start_info(&dwork->timer);
>  	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
>  		BUG_ON(timer_pending(timer));
>  		BUG_ON(!list_empty(&work->entry));
> @@ -580,6 +581,7 @@ EXPORT_SYMBOL(schedule_delayed_work);
>  int schedule_delayed_work_on(int cpu,
>  			struct delayed_work *dwork, unsigned long delay)
>  {
> +	timer_stats_timer_set_start_info(&dwork->timer);
>  	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
>  }
>  EXPORT_SYMBOL(schedule_delayed_work_on);

Makes sense to see the call site of schedule_delayed_work in the
stats. Applied to hrt.

Thanks,

	tglx

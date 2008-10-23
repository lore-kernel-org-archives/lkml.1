Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYJWV7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYJWV7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYJWV7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:59:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:47854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYJWV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:59:00 -0400
Subject: Re: [PATCH] timers: Handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly
	from softirq context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: ego@in.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Paul E McKenney <paulmck@us.ibm.com>
In-Reply-To: <20081023215003.GC1480@in.ibm.com>
References: <20081023215003.GC1480@in.ibm.com>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 23:58:39 +0200
Message-Id: <1224799119.32762.2.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 03:20 +0530, Gautham R Shenoy wrote:
> timers: Handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly from softirq context
> 
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> While migrating the the CB_IRQSAFE_UNLOCKED timers during a cpu-offline,
> we queue them on the cb_pending list, so that they won't go
> stale.
> 
> Thus, when the callbacks of the timers run from the softirq context,
> they could run into potential deadlocks, since these callbacks
> assume that they're running with irq's disabled, thereby annoying
> lockdep (see below)!
> 
> Fix this by emulating hardirq context while running these callbacks from
> the hrtimer softirq.

Yeah, and we can't run them from the migration context because we're
holding all kinds of funny locks there.

So I suppose this is the best solution available.

Thanks ego!

> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> 
>  kernel/hrtimer.c |   21 ++++++++++++++++++---
>  1 files changed, 18 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index cdec83e..60aaad6 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1188,6 +1188,7 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
>  		enum hrtimer_restart (*fn)(struct hrtimer *);
>  		struct hrtimer *timer;
>  		int restart;
> +		int emulate_hardirq_ctx = 0;
>  
>  		timer = list_entry(cpu_base->cb_pending.next,
>  				   struct hrtimer, cb_entry);
> @@ -1196,12 +1197,26 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
>  		timer_stats_account_hrtimer(timer);
>  
>  		fn = timer->function;
> +		/*
> +		 * A timer might have been added to the cb_pending list
> +		 * when it was migrated during a cpu-offline operation.
> +		 * Emulate hardirq context for such timers.
> +		 */
> +		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
> +		    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED)
> +			emulate_hardirq_ctx = 1;
> +
>  		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
> -		spin_unlock_irq(&cpu_base->lock);
> +		spin_unlock(&cpu_base->lock);
>  
> -		restart = fn(timer);
> +		if (likely(!emulate_hardirq_ctx)) {
> +			local_irq_enable();
> +			restart = fn(timer);
> +			local_irq_disable();
> +		} else
> +			restart = fn(timer);
>  
> -		spin_lock_irq(&cpu_base->lock);
> +		spin_lock(&cpu_base->lock);
>  
>  		timer->state &= ~HRTIMER_STATE_CALLBACK;
>  		if (restart == HRTIMER_RESTART) {


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZFBHZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZFBHZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZFBHZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:25:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:45230 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZFBHZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:25:19 -0400
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090602071718.GA17710@linux-sh.org>
References: <20090602071718.GA17710@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 09:25:02 +0200
Message-Id: <1243927502.23657.5619.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 16:17 +0900, Paul Mundt wrote:

> @@ -362,6 +364,9 @@ static struct clocksource *select_clocksource(void)
>  	if (next == curr_clocksource)
>  		return NULL;
>  
> +	if (next->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK)
> +		sched_clocksource = next;
> +
>  	return next;
>  }
>  
> @@ -440,7 +445,21 @@ void clocksource_unregister(struct clocksource *cs)
>  	list_del(&cs->list);
>  	if (clocksource_override == cs)
>  		clocksource_override = NULL;
> +
>  	next_clocksource = select_clocksource();
> +
> +	/*
> +	 * If select_clocksource() fails to find another suitable
> +	 * clocksource for sched_clocksource and we are unregistering
> +	 * it, switch back to jiffies.
> +	 */
> +	if (sched_clocksource == cs) {
> +		rcu_assign_pointer(sched_clocksource, &clocksource_jiffies);
> +		spin_unlock_irqrestore(&clocksource_lock, flags);
> +		synchronize_rcu();
> +		return;
> +	}
> +
>  	spin_unlock_irqrestore(&clocksource_lock, flags);
>  }


What if there's multiple CLOCK_SOURCE_USER_FOR_SCHED_CLOCK [ damn, thats
a long name to type :-) ] ?

That is, should we have logic in select_clocksource that does:

  if ((next->flags & ..) && next->prio > sched_clocksource->prio)

or whatever, so that it picks the best one?

Same for unregister, should we re-evaluate all clocksources before
falling back to basic?

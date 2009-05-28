Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbZE1NAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbZE1NAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbZE1NAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:00:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:54946 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883AbZE1NAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:00:39 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <20090528124207.GA28830@linux-sh.org>
References: <1243348681.23657.14.camel@twins>
	 <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>
	 <20090526230855.GA27218@linux-sh.org>
	 <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain>
	 <20090527001543.GA8493@linux-sh.org> <1243441525.28705.19.camel@desktop>
	 <20090528091936.GA27545@linux-sh.org> <1243503281.23657.80.camel@twins>
	 <20090528110902.GA27884@linux-sh.org>
	 <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain>
	 <20090528124207.GA28830@linux-sh.org>
Content-Type: text/plain
Date: Thu, 28 May 2009 14:59:30 +0200
Message-Id: <1243515570.6600.96.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 21:42 +0900, Paul Mundt wrote:

>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> -	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> -					* (NSEC_PER_SEC / HZ);
> +	struct clocksource *clock = ACCESS_ONCE(sched_clocksource);
> +
> +	return cyc2ns(clock, clocksource_read(clock));
>  }
>  

> @@ -440,7 +444,17 @@ void clocksource_unregister(struct clocksource *cs)
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
> +	if (sched_clocksource == cs)
> +		sched_clocksource = &clocksource_jiffies;
> +
>  	spin_unlock_irqrestore(&clocksource_lock, flags);
>  }


CPU0                           CPU1

clock = ACCESS_ONCE(sched_clocksource);

                               unload module
                                 clocksource_unregister()
                                   sched_clocksource = jiffies
                                 unmap data/text

cyc2ns(clock, clocksource_read(clock)) <--- fireworks




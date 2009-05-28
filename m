Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbZE1WQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbZE1WQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZE1WQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:16:52 -0400
Received: from www.tglx.de ([62.245.132.106]:39182 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZE1WQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:16:51 -0400
Date: Fri, 29 May 2009 00:16:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jon Hunter <jon-hunter@ti.com>
cc: john stultz <johnstul@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
In-Reply-To: <4A1EFDBD.8040007@ti.com>
Message-ID: <alpine.LFD.2.00.0905282330510.3397@localhost.localdomain>
References: <4A1D52E3.3040204@ti.com>  <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain> <1243455615.7440.17.camel@localhost.localdomain> <alpine.LFD.2.00.0905272229190.3397@localhost.localdomain> <4A1EF244.5040108@ti.com>
 <alpine.LFD.2.00.0905282231500.3397@localhost.localdomain> <4A1EFDBD.8040007@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Jon Hunter wrote:
 
> Thomas Gleixner wrote:
> >   Please make this a real function. There is no reason to stick this
> >   into a header file. The only user is clocksource.c anyway, so please
> >   put it there as a static function and let the compiler decide what
> >   to do with it.
> 
> No problem. Please see below. Let me know if this is ok and there is anything
> else.

  Looks good now.
 
>  /**
> + * timekeeping_max_deferment - Returns max time the clocksource can be
> deferred
> + *
> + * IMPORTANT: Caller must observe xtime_lock via read_seqbegin/read_seqretry
> + * to ensure that the clocksource does not change!
> + */

  Just nitpicking here. For the intended use case this is irrelevant.
  
  On UP this is called from an irq disabled section, so nothing is
  going to change the clock source.

  On SMP it does not matter if CPU A goes to sleep with the old clock
  source and CPU B changes the clock source while A is idle. When B
  goes idle it will take the change into account.

  But that leads me to an interesting observation:

  On SMP we really should only care for the CPU which has the do_timer
  duty assigned. All other CPUs can sleep as long as they want. When
  that CPU goes idle and drops the do_timer duty it needs to look at
  max_deferement, but the others can sleep as long as they want.

  So the rule would be:

  if (cpu == tick_do_timer_cpu || tick_do_timer_cpu == TICK_DO_TIMER_NONE)
     check_max_deferment();
  else
     sleep_as_long_as_you_want;

  Could you add that perhaps ?

> +s64 timekeeping_max_deferment(void)
> +{
> +	return clock->max_idle_ns;
> +}
> +

Thanks for your patience,

	tglx

Return-Path: <linux-kernel-owner+w=401wt.eu-S1750974AbXBYI3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbXBYI3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 03:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXBYI3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 03:29:19 -0500
Received: from www.osadl.org ([213.239.205.134]:36261 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750974AbXBYI3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 03:29:19 -0500
Subject: Re: generic one-shot bug (was Re: sparc generic time / clockevents)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: David Miller <davem@davemloft.net>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, peter.keilty@hp.com
In-Reply-To: <20070224.211353.74752521.davem@davemloft.net>
References: <20070223.015520.125893182.davem@davemloft.net>
	 <1172260279.6261.20.camel@localhost>
	 <20070223.163428.104033815.davem@davemloft.net>
	 <20070224.211353.74752521.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 09:34:40 +0100
Message-Id: <1172392480.25076.348.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-24 at 21:13 -0800, David Miller wrote:
> As I suspected, the one-shot code wasn't very well tested and I'd be
> the one to debug this thing on sparc64 :-)
> 
> When a timer exceeds the timer period, the one-shot handling code does
> the following loop:
> 
> 	for (;;) {
> 		ktime_t next = ktime_add(dev->next_event, tick_period);
> 
> 		if (!clockevents_program_event(dev, next, ktime_get()))
> 			return;
> 		tick_periodic(cpu);
> 	}
> 
> So it just keeps running tick_periodic() until we "catch up".
>
> Problem is, if clockevents_program_event() gets a "next" time in the
> past, the very case where we'll loop, it DOES NOT update
> dev->next_event.  It returns the error before doing so.

Yep, that's caused by a late change for the *!&#ed broadcast stuff for
x86.

> As a result of this, we'll loop forever here, the softlockup watchdog
> will trigger, and the system will wedge completely.
> 
> I was getting a softlockup and immediate system hang, so to debug this
> I kept a history of the last 8 TSC values when tick_periodic() was
> invoked.  At softlockup trigger, I'd dump the log.  And what I saw
> were TSC deltas that we so tiny as to be just enough to indicate
> tick_periodic() was running in a tight loop :-)
> 
> I propose the following fix, which I'm about to test.

Yep

> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 4500e34..0986a2b 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -77,6 +77,7 @@ static void tick_periodic(int cpu)
>  void tick_handle_periodic(struct clock_event_device *dev)
>  {
>  	int cpu = smp_processor_id();
> +	ktime_t next;
>  
>  	tick_periodic(cpu);
>  
> @@ -86,12 +87,12 @@ void tick_handle_periodic(struct clock_event_device *dev)
>  	 * Setup the next period for devices, which do not have
>  	 * periodic mode:
>  	 */
> +	next = ktime_add(dev->next_event, tick_period);
>  	for (;;) {
> -		ktime_t next = ktime_add(dev->next_event, tick_period);
> -
>  		if (!clockevents_program_event(dev, next, ktime_get()))
>  			return;
>  		tick_periodic(cpu);
> +		next = ktime_add(next, tick_period);
>  	}
>  }
>  


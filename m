Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYDYKwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYDYKwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYDYKwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:52:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53703 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbYDYKwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:52:15 -0400
Date: Fri, 25 Apr 2008 12:51:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] scheduler/misc fixes
Message-ID: <20080425105149.GA11227@elte.hu>
References: <20080424225530.GA8717@elte.hu> <20080424.204620.88617191.davem@davemloft.net> <1209109710.7115.400.camel@twins> <1209118778.7115.417.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209118778.7115.417.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> OK, so David came up with the idea that it might be the reschedule IPI 
> (smp_receive_signal_client) that did the wakeup resulting in the 
> following scenario:
> 
>  <idle > 60s >
>  <resched-IPI> -> nohz_restart() -> restart timer
>                                  -> schedule()
> 
>  <run stuff>
>  <timer> -> softlockup_tick() -> BUG!
>  
> doing irq_enter/exit() for smp_receive_signal_client() did indeed fix
> the whole issue. (x86 also has this bug - its just darn hard to generate
> 60s+ nohz periods due to the shitty clocks/timers)
> 
> So per b) any nohz wake needs to be done with an interrupt _and_ all
> such interrupts must pass through irq_enter().
> 
> As far as I can tell this is not nessecarily true (or desired from a 
> performance POV) for all platforms, imagine the core2 monitor/mwait 
> idle that wakes up because of a memory write. This doesn't require an 
> interrupt at all to wake up.
> 
> So, are we going to require all waking interrupts (IPIs and regular) 
> to do the irq_enter/exit() dance and add the perhaps unneeded overhead 
> to these paths and require the non-interrupt driven wake-ups like 
> monitor/mwait to do the touch_softlockup_watchdog() themselves?
> 
> Or,
> 
> Is Ingo's initial patch to make nohz_restart() also touch the 
> softlockup watchdog the best fix (now that we understand what 
> happens)?

thanks Peter for the detailed analysis.

I think we should not require all IRQ contexts to do irq_enter/exit - 
not because of the overhead (these are mainly really small costs), but 
mostly because as this example has shown, nothing besides this rather 
elusive softlockup false-positive enforces their correctness. So we'll 
always lag behind significantly and wont ever achieve a truly correct 
solution.

a much stronger approach would be to: require all exit-idle paths to 
touch the softlockup watchdog (we are evidently not locked up there), 
and require the timer IRQ to touch it as well if it hits an idle 
context. We restart the scheduler tick in the exit-idle path anyway, 
otherwise the scheduler breaks visibly - so that's the right place to 
put the touch_softlockup_watchdog() call.

I.e. i'd pretty much concur with you that the best solution is the very 
first patch - which is also in the pull to Linus - we just now 
understand exactly why ;-) David, do you agree?

	Ingo

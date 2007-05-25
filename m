Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbXEYEFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbXEYEFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXEYEFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:05:44 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:43771 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXEYEFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:05:42 -0400
Date: Fri, 25 May 2007 13:04:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <Bryan.Wu@analog.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
Message-ID: <20070525040445.GA8395@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Bryan Wu <Bryan.Wu@analog.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com> <200705240929.51696.rgetz@blackfin.uclinux.org> <20070524152318.GA4491@linux-sh.org> <200705241332.30335.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705241332.30335.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 01:32:30PM -0400, Robin Getz wrote:
> On Thu 24 May 2007 11:23, Paul Mundt pondered:
> > 
> > Calling it a periodic timer when its in periodic timer mode makes sense.
> 
> No disagreements - but I don't think that a watchdog that doesn't cause a 
> reset is a periodic timer.
> 
I'm not sure what else you think it is? On most platforms, when it's not
in reset mode, it works as a free-running timer with an IRQ generated on
overflow. I've certainly used the watchdog as a system timer before on
boards where all of the timer channels are tied up for other uses.

> > Why you would want to interface that with a userspace watchdog daemon is
> > beyond me, they're conceptually unrelated.
> 
> Agreed again - periodic timers have nothing to do with watchdogs. This is 
> where I am confused about why you are saying that the only event a watchdog 
> can have is a hard reset.
> 
No, what I said was that the only event that _matters_ to CONFIG_WATCHDOG
is a hard reset. So far no one has suggested anything outside of hard
reset, periodic timer, or softlockup detection that would be useful to
extend CONFIG_WATCHDOG for.

If you're talking about specific events, clockevents are still a much
better way to go than trying to hammer something in to CONFIG_WATCHDOG
that it was never designed for. If you have some 'special' events for
your watchdog that would be of use to others, tying these in as
additional flags for clockevents would be far more beneficial anyways.

> > I'm not advocating hiding a clocksource somewhere in the depths of
> > CONFIG_WATCHDOG, they're completely unrelated.
> 
> I (and many others) consider a "watchdog" a clock sink - something that needs 
> to be poked within certain limits (too fast can indicate a failures just as 
> too slow is a failure).
> 
Currently there's nothing in the kernel that cares about clearing 'too fast'.
I can't imagine why this _should_ be treated as a failure, but feel free
to code up a solution if you feel it will be useful.

> The event or how something is notified of the failure of the watchdog to be 
> serviced shouldn't determine what the name is.
> 
If all you want is a timer that you occasionally have to poke and then
take some notification when it expires, you can just use a regular
one-shot timer anyways and bank off of the system timer, the 'watchdog'
is certainly not doing anything useful at this point.

So far the only example anyone has provided outside of periodic timers or
hardware reset has been dumping the stack when something gets stuck.
Softlockup does this already today, using a timer.

If your system is completely dead, you won't have any way to trigger or
see the stack dump anyways, so the watchdog doesn't buy you anything
there, either.

What many watchdogs do today is simply to have split timer for userspace
and the actual hardware (where userspace has to poke the timer every now
and then, or the kernel will allow the overflow). This is pretty common
for watchdogs with very fast overflow periods.

There's certainly nothing wrong with having a timer that runs out and
kicks a notifier chain if there's something special you want to do, but
tying up the watchdog hardware for that is silly. There are many other
things one has to use the watchdog hardware for anyways (reset, periodic
timing, frequency scaling -- waiting for PLL stabilization, etc.). Tying
down a hardware block where a struct timer_list will do the same work
makes no sense.

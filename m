Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbZE0AW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbZE0AW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbZE0AWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:22:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37278 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254AbZE0AWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:22:12 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: john stultz <johnstul@us.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090526234425.GB6295@linux-sh.org>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <1243348681.23657.14.camel@twins>
	 <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>
	 <20090526230855.GA27218@linux-sh.org> <1243380303.3275.40.camel@localhost>
	 <20090526234425.GB6295@linux-sh.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 17:22:10 -0700
Message-Id: <1243383730.3275.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 08:44 +0900, Paul Mundt wrote:
> On Tue, May 26, 2009 at 04:25:03PM -0700, john stultz wrote:
> > On Wed, 2009-05-27 at 08:08 +0900, Paul Mundt wrote:
> > > On Tue, May 26, 2009 at 10:17:02PM +0200, Thomas Gleixner wrote:
> > > > On Tue, 26 May 2009, Peter Zijlstra wrote:
> > > > > On Tue, 2009-05-26 at 16:31 +0200, Linus Walleij wrote:
> > > > > > The definition of "rating" from the kerneldoc does not
> > > > > > seem to imply that, it's a subjective measure AFAICT.
> > > > 
> > > >   Right, there is no rating threshold defined, which allows to deduce
> > > >   that. The TSC on x86 which might be unreliable, but usable as
> > > >   sched_clock has an initial rating of 300 which can be changed later
> > > >   on to 0 when the TSC is unusable as a time of day source. In that
> > > >   case clock is replaced by HPET which has a rating > 100 but is
> > > >   definitely not a good choice for sched_clock
> > > > 
> > > > > > Else you might want an additional criteria, like
> > > > > > cyc2ns(1) (much less than) jiffies_to_usecs(1)*1000
> > > > > > (however you do that the best way)
> > > > > > so you don't pick something
> > > > > > that isn't substantially faster than the jiffy counter atleast?
> > > > 
> > > >   What we can do is add another flag to the clocksource e.g.
> > > >   CLOCK_SOURCE_USE_FOR_SCHED_CLOCK and check this instead of the
> > > >   rating.
> > > > 
> > > Ok, so based on this and John's locking concerns, how about something
> > > like this? It doesn't handle the wrapping cases, but I wonder if we
> > > really want to add that amount of logic to sched_clock() in the first
> > > place. Clocksources that wrap frequently could either leave the flag
> > > unset, or do something similar to the TSC code where the cyc2ns shift is
> > > used. If this is something we want to handle generically, then I'll have
> > > a go at generalizing the TSC cyc2ns scaling bits for the next spin.
> > 
> > 
> > Yea. So this is a little better. There's still a few other issues to
> > consider:
> > 
> > 1) What if a clocksource is registered that has the _SCHED_CLOCK bit
> > set, but is not selected for timekeeping due it being unstable like the
> > TSC?
> > 
> See, this is what I thought the rating information was useful for, as the
> rating is subsequently dropped if it is not usable. But perhaps it makes
> more sense to just clear the bit at the same time that the rating is
> lowered once it turns out to be unstable.

Yes, if we're dropping a clocksource we should also drop the bit. That
shouldn't be a problem.

The point I was making, is that multiple clocksources may be registered
at one time (TSC, ACPI_PM, etc). But only one is being managed by the
timekeeping code (clock). So there may be the case where the
sched_clock() is different then the timekeeping clock (which is common
on x86). 

So I suspect we need a special hook that grabs the best _SCHED_CLOCK
clocksource (as computed at clocksource registration time) and provides
it to the generic sched_clock() interface.


> > 2) Conditionally returning jiffies if the lock is held seems troubling.
> > Might get some crazy values that way.
> > 
> What would you recommend instead? We do not want to spin here, and if we
> are in the middle of changing clocksources and returning jiffies anyways,
> then this same issue pops up in the current sched_clock() implementation
> regardless of whether we are testing for lock contention or not.
> Likewise, even if we were to spin, the same situation exists if the new
> clocksource does not have the _SCHED_CLOCK bit set and we have to fall
> back on jiffies anyways, doesn't it?
> 
> Put another way, and unless I'm missing something obvious, if we ignore
> my changes to sched_clock(), how is your concern not applicable to case
> where we are changing clocksources and using generic sched_clock() as it
> is today?

Well, Thomas' point that locking isn't necessary, as sched_clock()
doesn't have to be correct, is probably right. 

So, I think a get_sched_clocksource() interface would be ideal (if we
want to get academic at a later date, the pointer could be atomically
updated, and we'd keep it valid for some time via an rcu like method).

Additionally, you can set the jiffies clocksource as a _SCHED_CLOCK
clocksource and drop the jiffies fallback code completely.

thanks
-john



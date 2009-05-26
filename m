Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbZEZXvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbZEZXvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbZEZXvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:51:15 -0400
Received: from www.tglx.de ([62.245.132.106]:49486 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840AbZEZXvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:51:14 -0400
Date: Wed, 27 May 2009 01:49:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
In-Reply-To: <20090526230855.GA27218@linux-sh.org>
Message-ID: <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain>
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Paul Mundt wrote:

> On Tue, May 26, 2009 at 10:17:02PM +0200, Thomas Gleixner wrote:
> > On Tue, 26 May 2009, Peter Zijlstra wrote:
> > > On Tue, 2009-05-26 at 16:31 +0200, Linus Walleij wrote:
> > > > The definition of "rating" from the kerneldoc does not
> > > > seem to imply that, it's a subjective measure AFAICT.
> > 
> >   Right, there is no rating threshold defined, which allows to deduce
> >   that. The TSC on x86 which might be unreliable, but usable as
> >   sched_clock has an initial rating of 300 which can be changed later
> >   on to 0 when the TSC is unusable as a time of day source. In that
> >   case clock is replaced by HPET which has a rating > 100 but is
> >   definitely not a good choice for sched_clock
> > 
> > > > Else you might want an additional criteria, like
> > > > cyc2ns(1) (much less than) jiffies_to_usecs(1)*1000
> > > > (however you do that the best way)
> > > > so you don't pick something
> > > > that isn't substantially faster than the jiffy counter atleast?
> > 
> >   What we can do is add another flag to the clocksource e.g.
> >   CLOCK_SOURCE_USE_FOR_SCHED_CLOCK and check this instead of the
> >   rating.
> > 
> Ok, so based on this and John's locking concerns, how about something
> like this? It doesn't handle the wrapping cases, but I wonder if we
> really want to add that amount of logic to sched_clock() in the first
> place. Clocksources that wrap frequently could either leave the flag
> unset, or do something similar to the TSC code where the cyc2ns shift is
> used. If this is something we want to handle generically, then I'll have
> a go at generalizing the TSC cyc2ns scaling bits for the next spin.

Gah. There is no locking issue. As Peter explained before the
scheduler code can cope with some inaccurate value.

The wrap issue is completly academic. If the current clock source has
a wrap issue then it needs to be addressed anyway by frequent enough
wakeups to assure correctness of timekeeping and that makes it
suitable for the sched clock domain as well. Also the scheduler can
not hit a value which has not gone through the irq_enter() based
update after a long idle sleep.

So changing your previous patch from

   if (clock && clock->rating > 100)

to

   if (clock && (clock->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK))

is sufficient.

Thanks,

	tglx

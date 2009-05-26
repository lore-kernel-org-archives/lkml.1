Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZEZUSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZEZUSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZEZUSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:18:00 -0400
Received: from www.tglx.de ([62.245.132.106]:39382 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZEZUR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:17:59 -0400
Date: Tue, 26 May 2009 22:17:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
In-Reply-To: <1243348681.23657.14.camel@twins>
Message-ID: <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>
References: <20090526061532.GD9188@linux-sh.org>  <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Peter Zijlstra wrote:
> Added the generic clock and timer folks to CC.
> 
> On Tue, 2009-05-26 at 16:31 +0200, Linus Walleij wrote:
> > 2009/5/26 Paul Mundt <lethal@linux-sh.org>:
> > 
> > >  */
> > >  unsigned long long __attribute__((weak)) sched_clock(void)
> > >  {
> > > +       /*
> > > +        * Use the current clocksource when it becomes available later in
> > > +        * the boot process, and ensure that it has a high enough rating
> > > +        * to make it suitable for general use.
> > > +        */
> > > +       if (clock && clock->rating >= 100)
> > > +               return cyc2ns(clock, clocksource_read(clock));
> > > +
> > > +       /* Otherwise just fall back on jiffies */
> > >        return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> > >                                        * (NSEC_PER_SEC / HZ);
> > >  }
> > 
> > This seems like it would make the patch I sent the other day
> > unnecessary (subject u300 sched_clock() implementation).
> > 
> > It would also trim off this solution found in all OMAP platforms in
> > arch/arm/plat-omap/common.c
> > 
> > BUT Peter Zijlstra replied to my question about why this wasn't
> > generic with:
> > 
> > [peterz]:
> > > But that is the reason this isn't generic, non of the 'stable'
> > > clocksources on x86 are fast enough to use as sched_clock.
> > 
> > Does that mean clock->rating for these clocksources is
> > for certain < 100?
> > 
> > The definition of "rating" from the kerneldoc does not
> > seem to imply that, it's a subjective measure AFAICT.

  Right, there is no rating threshold defined, which allows to deduce
  that. The TSC on x86 which might be unreliable, but usable as
  sched_clock has an initial rating of 300 which can be changed later
  on to 0 when the TSC is unusable as a time of day source. In that
  case clock is replaced by HPET which has a rating > 100 but is
  definitely not a good choice for sched_clock

> > Else you might want an additional criteria, like
> > cyc2ns(1) (much less than) jiffies_to_usecs(1)*1000
> > (however you do that the best way)
> > so you don't pick something
> > that isn't substantially faster than the jiffy counter atleast?

  What we can do is add another flag to the clocksource e.g.
  CLOCK_SOURCE_USE_FOR_SCHED_CLOCK and check this instead of the
  rating.

Thanks,

	tglx

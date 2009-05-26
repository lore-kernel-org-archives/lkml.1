Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZEZOoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZEZOoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZEZOoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:44:13 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44852 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZEZOoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:44:12 -0400
Date: Tue, 26 May 2009 23:43:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, peterz@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090526144357.GA20577@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	peterz@infradead.org, linux-arm-kernel@lists.arm.linux.org.uk
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:31:58PM +0200, Linus Walleij wrote:
> 2009/5/26 Paul Mundt <lethal@linux-sh.org>:
> 
> >  */
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> >  {
> > +       /*
> > +        * Use the current clocksource when it becomes available later in
> > +        * the boot process, and ensure that it has a high enough rating
> > +        * to make it suitable for general use.
> > +        */
> > +       if (clock && clock->rating >= 100)
> > +               return cyc2ns(clock, clocksource_read(clock));
> > +
> > +       /* Otherwise just fall back on jiffies */
> >        return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> >                                        * (NSEC_PER_SEC / HZ);
> >  }
> 
> This seems like it would make the patch I sent the other day
> unnecessary (subject u300 sched_clock() implementation).
> 
> It would also trim off this solution found in all OMAP platforms in
> arch/arm/plat-omap/common.c
> 
> BUT Peter Zijlstra replied to my question about why this wasn't
> generic with:
> 
Hum, you trimmed out my changelog which explains all the rationale for
precisely why this needs to be generic. Hopefully people that care will
go back and read that.

> [peterz]:
> > But that is the reason this isn't generic, non of the 'stable'
> > clocksources on x86 are fast enough to use as sched_clock.
> 
> Does that mean clock->rating for these clocksources is
> for certain < 100?
> 
The '100' thing is a bit arbitrary, this is what defines base level
usability. If we want to set a mandate that sched_clock() sources need to
start at 300 or 400 or whatever, that is fine with me, too. In the case
of x86 there are several < 100 ratings, but I don't know if those cover
all of the cases Peter is concerned about.

Regardless, the above cyc2ns() logic does make most of the
architecture-specific sched_clock() implementations redundant, so they
can of course be killed off incrementally. This might not be the case for
x86, but in those cases I expect a different sched_clock() to be
implemented anyways.

> Else you might want an additional criteria, like
> cyc2ns(1) (much less than) jiffies_to_usecs(1)*1000
> (however you do that the best way)
> so you don't pick something
> that isn't substantially faster than the jiffy counter atleast?
> 
This rather defeats the purpose of sched_clock() being fast. If we want
to add a flag that means this in to the clocksource instead of consulting
the rating, that is fine with me too. I know which clocksources I prefer
to use for a sched_clock() and they are all better than jiffies. The
semantics of how we tell sched_clock() that are not so important. Rating
seemed like a good choice from the documentation in struct clocksource at
least.

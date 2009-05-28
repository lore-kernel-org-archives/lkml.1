Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZE1IpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZE1IpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZE1IpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:45:05 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50541 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZE1IpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:45:01 -0400
Date: Thu, 28 May 2009 17:44:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090528084444.GA26955@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	John Stultz <johnstul@linux.vnet.ibm.com>
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org> <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain> <20090527001543.GA8493@linux-sh.org> <1243441525.28705.19.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243441525.28705.19.camel@desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:25:25AM -0700, Daniel Walker wrote:
> On Wed, 2009-05-27 at 09:15 +0900, Paul Mundt wrote:
> 
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> >  {
> > +	/*
> > +	 * Use the current clocksource when it becomes available later in
> > +	 * the boot process, and ensure that it is usable for sched_clock().
> > +	 */
> > +	if (clock && (clock->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK))
> > +		return cyc2ns(clock, clocksource_read(clock));
> > +
> > +	/* Otherwise just fall back on jiffies */
> >  	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> 
> Do we really need all this complexity in a fast path? the jiffies
> clocksource is static and always ready. Could we instead remove the
> usage of "clock" and create a new pointer called "sched_clocksource" and
> initialize it to the jiffies clock, and allow the clocksource management
> code to update that new pointer based on the
> CLOCK_SOURCE_USE_FOR_SCHED_CLOCK flag when new clocksources are
> registered/removed/marked unstable etc..
> 
> that would eliminate all the code in sched_clock except one line,
> 
> unsigned long long __attribute__((weak)) sched_clock(void)
> {
> 	return cyc2ns(sched_clocksource, clocksource_read(sched_clocksource));
> }
> 
It would, but then what would that do to the sched_clock() value? It will
reset once a CLOCK_SOURCE_USE_FOR_SCHED_CLOCK clocksource comes along,
which basically means that sched_clock() then rolls back, which is worse
than simply being delayed a bit. So even if we were to use a special
sched_clocksource, it still could not be used until it was set up at
registration time.

Now we could of course add a sched_clocksource assignment in
select_clocksource(), but that's really no different than just testing
'clock' as we do today. All it does is move the flag test in to a
different path.

So, I think the current v3 is still the best solution.

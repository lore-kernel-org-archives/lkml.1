Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYCRCDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYCRCDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 22:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYCRCDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 22:03:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59807 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYCRCDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 22:03:45 -0400
Subject: Re: [PATCH 2/5] introduce CLOCK_MONOTONIC_RAW
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803150536290.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain>
	 <1205553938.6122.79.camel@localhost.localdomain>
	 <1205554018.6122.81.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150536290.1791@scrub.home>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 19:03:38 -0700
Message-Id: <1205805818.28128.91.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-15 at 05:50 +0100, Roman Zippel wrote:
> Hi,
> 
> On Fri, 14 Mar 2008, john stultz wrote:
> 
> > My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
> > nanosecond based time value, that increments starting at bootup and has
> > no frequency adjustments made to it what so ever.
> 
> A general comment: the raw clock doesn't need any adjustments, so updates 
> don't have to be done that frequently and you can move most of that logic 
> into second_overflow().

You're suggesting adding MONTONIC_RAW code to ntp.c ?  That doesn't make
much sense to me (the whole point is its not ntp adjusted). Even if you
mean just inside the "if (clock->xtime_nsec >= (u64)NSEC_PER_SEC ..."
conditional, then that means we don't get to leverage the
cycles_interval, and cycle_last, values, so all of that would have to be
duplicated and managed. Which I'm not sure it would save us much more
then the extra add and compare here.


> > @@ -439,6 +475,7 @@ static void clocksource_adjust(s64 offset)
> >  void update_wall_time(void)
> >  {
> >  	cycle_t offset;
> > +	static u64 raw_snsec; /* shifted raw nanosecnds */
> >  
> >  	/* Make sure we're fully resumed: */
> >  	if (unlikely(timekeeping_suspended))
> 
> IMO that's really a clock property, so this belongs in the clock 
> structure.
> (Some day we may want to have multiple active clocks for various purposes 
> and thus export multiple raw clocks.)

I disagree. I think that crufts up the clocksource structure (which is
ideally just a simple hw counter abstraction), with timekeeping state.

I'm still not sold on the multiple clocks with multiple notions of time
idea you keep on bringing up. But if/when we cross that bridge, maybe it
would be better to add a timekeeping_clock mid-layer abstraction that
keeps the clocksource specific timekeeping state. That way we don't add
lots of complexity for the clocksource driver writers to deal with and
we allow the clocksources to be better re-purposed (for maybe more sane
things like performance counters) without getting too bloated.

> > @@ -466,6 +504,11 @@ void update_wall_time(void)
> >  			second_overflow();
> >  		}
> >  
> > +		if (raw_snsec >= (u64)NSEC_PER_SEC << clock->shift) {
> > +			raw_snsec -= (u64)NSEC_PER_SEC << clock->shift;
> > +			monotonic_raw.tv_sec++;
> > +		}
> > +	
> 
> You don't really have to use clock->shift as a scale, thus simplifying the 
> shifting here (e.g. by using NTP_SCALE_SHIFT).
> I'm thinking about doing this for e.g. xtime_nsec as well.

Could you explain this more? 

Given the clocksources have different shift values, why should we not
keep the extra resolution? 

How does adding the extra shifting to convert from the clocksource scale
to the NTP_SCALE_SHIFT value simplify the shifting?

thanks
-john



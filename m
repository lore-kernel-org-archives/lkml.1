Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZEPBS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZEPBS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 21:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZEPBSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 21:18:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58617 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZEPBSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 21:18:46 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep
 formorethan2.15 seconds
From: John Stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A0D99E0.3050306@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>
	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>
	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>
	 <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com>
	 <1242232872.9110.98.camel@jstultz-laptop>  <4A0B0939.5030008@ti.com>
	 <1242242497.9777.2.camel@jstultz-laptop>  <4A0D99E0.3050306@ti.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 18:18:46 -0700
Message-Id: <1242436726.29511.198.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 11:35 -0500, Jon Hunter wrote:
> John Stultz wrote:
> >>>> One final question, I noticed in clocksource.h that the definition of 
> >>>> function cyc2ns returns a type of s64, however, in the function itself a 
> >>>> variable of type u64 is used and returned. Should this function be 
> >>>> modified as follows?
> >>>>
> >>>>   static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
> >>>>   {
> >>>> -       u64 ret = (u64)cycles;
> >>>> +       s64 ret = (s64)cycles;
> >>>>          ret = (ret * cs->mult) >> cs->shift;
> >>>>          return ret;
> >>>>   }
> >>> Damn. So this brings up an issue I had missed prior.
> >> Any comments on whether this should be u64 versus s64?
> > 
> > I'd leave it alone for now. I'm concerns that in large multiplies, if
> > its a s64 the sign might get extended down by the shift. I need to look
> > at it in more detail though.
> 
> I have been thinking about this some more and I do agree that there is a 
> chance that the multiply could overflow if the "cycles" and "mult" are 
> large. From the perspective of the timekeeping_max_deferment() function 
> this would be very likely for 64-bit clocksources when the mask will be 
> equal to (2^64)-1. Therefore, how about modifying the function as 
> follows in order to catch any occurrences of overflow?
> 
> Let me know if this is aligned with your thinking or if I am barking up 
> the wrong tree here.

So cyc2ns is a very very hot path, so I don't think we want to muck with
that much.

Instead of catching the overflows, and then trying to handle them, we
really want to prevent overflows from happening. That is the main point
of the timekeeping_max_deferrment() interface after all ;)

So thinking about it a bit more, what we really want from
timekeeping_max_deferrment() is roughly:

	/* find the max cycle value that would overflow the mult */
	max_cycles = -1UUL/clocksource->mult;

	/* pick the smaller of max_cycles or the mask value */
	max_cycles = min(max_cycles, clocksource->mask);

	/* convert max_cycles into ns */
	max_time = cyc2ns(clocksource, max_cycles);

	/* take off 5% of the max to make sure we don't show up late */
	max_time = max_time - max_time/20;


We should be able to make this reasonably fast via:
	max_cycles = 1<<(64 - ilog2(clocksource->mult) - 1);
	max_cycles = min(max_cycles, clocksource->mask);
	max_time = cyc2ns(clocksource, max_cycles);
	max_time = max_time - max_time >> 4;

Does that seem reasonable?

thanks
-john




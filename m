Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbZEMQnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbZEMQnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZEMQng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:43:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33736 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZEMQnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:43:35 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep   
 formorethan2.15 seconds
From: John Stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A0AE3E3.5090304@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>
	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>
	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>
	 <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com>
Content-Type: text/plain
Date: Wed, 13 May 2009 09:41:12 -0700
Message-Id: <1242232872.9110.98.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 10:14 -0500, Jon Hunter wrote:
> john stultz wrote:
> > Well, the mult adjustments should be quite small, especially compared to
> > the NSEC_PER_SEC/HZ adjustment.
> > 
> > Hmm... Although, I guess we could get bitten if the max_deferment was
> > like an hour, and the adjustment was enough that it scaled out to and we
> > ended up being a second late or so. So you have a point.
> > 
> > But since the clockevent driver is not scaled, we probably can get away
> > with using the orig_mult value instead of mult, and be ok.
> > 
> > Alternatively instead of NSEC_PER_SEC/HZ, we could always drop the
> > larger of NSEC_PER_SEC/HZ or max_deferment/10? That way we should scale
> > up without a problem. 
> 
> Yes, may be this would be a safer option. Thinking about this I was 
> wondering if we should always use max_deferement/10, because I did not 
> think that there would ever be a case where NSEC_PER_SEC/HZ would be 
> greater. If NSEC_PER_SEC/HZ was greater than max_deferement/10 this 
> would imply that the clocksource would wrap after only 10 jiffies, if I 
> have the math right...

Right, but even with such limitiations, if an arch can skip every 5
ticks, they probably will try, right? :)


> > I suspect it would be tough to hit this issue though.
> 
> Agree.
> 
> > Two patches should be fine.
> 
> Ok, I will re-post as two once we have the final version.
> 
> > Looks good overall. We may want to add the -10% (or -5%) to be totally
> > safe, but that's likely just me being paranoid.
> 
> I am paranoid too! Do you care if we use 6.25% or 12.5% margin instead 
> of 10% or 5%? This way we can avoid a 64-bit division by using a simple 
> shift. See below. I have implemented a 6.25% margin for now. Let me know 
> your thoughts.

That sounds reasonable to me.

> One final question, I noticed in clocksource.h that the definition of 
> function cyc2ns returns a type of s64, however, in the function itself a 
> variable of type u64 is used and returned. Should this function be 
> modified as follows?
> 
>   static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
>   {
> -       u64 ret = (u64)cycles;
> +       s64 ret = (s64)cycles;
>          ret = (ret * cs->mult) >> cs->shift;
>          return ret;
>   }

Damn. So this brings up an issue I had missed prior.

Given that a clocksoure's shift value is calculated so that the
cycles*mult multiplication won't overflow 64 bits, there may be inherent
assumptions in the clocksource code that limit the results of
timekeeping_max_deferrment() other then just the clocksource mask value.

So even if the clocksource doesn't wrap over the interval, it could be
large enough to cause the cyc2ns function to break given a large enough
cycle interval.

Right now that assumption is spread out in the individual clocksource
drivers. I've got a calculate_shift() helper patch sitting around that
will help unify that, but even so there still is a trade-off in that:

1) The larger the shift value, the finer grained (smoother) we can be in
making NTP adjustments. 

2) The smaller the shift value, the smaller the mult value, so the
longer the cycle interval length can be before we overflow.

So I'm not sure how we can better extend this in all cases.

I'll have to think about how that would change
timekeeping_max_deferment() and how we'd have to calculate a reasonable
max efficiently.

Other then this issue (which is my fault for not noticing it earlier),
you're patch looks great. I just feel badly for making you rev this
thing over and over. 

One option if you're itching to push it in and be done with it: Make
timekeeping_max_deferment() return just 1 second for now. Your patch
provides the right infrastructure for the timekeeping code to provide
its limits to the clockevents code. So you can use a safe short constant
value for now, and we can extend that out correctly in a future patch.

Sorry again for not catching this until now. :(

thanks
-john




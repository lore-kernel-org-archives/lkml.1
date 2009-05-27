Return-Path: <linux-kernel-owner+w=401wt.eu-S1761169AbZE0UUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761169AbZE0UUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbZE0UUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:20:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37308 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbZE0UUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:20:22 -0400
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jon Hunter <jon-hunter@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain>
References: <4A1D52E3.3040204@ti.com>
	 <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 27 May 2009 13:20:15 -0700
Message-Id: <1243455615.7440.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 18:01 +0200, Thomas Gleixner wrote:
> On Wed, 27 May 2009, Jon Hunter wrote:
> > + */
> > +s64 timekeeping_max_deferment(void)
> > +{
> > +	s64 max_nsecs;
> > +	u64 max_cycles;
> > +
> > +	/*
> > +	 * Calculate the maximum number of cycles that we can pass to the
> > +	 * cyc2ns function without overflowing a 64-bit signed result. The
> > +	 * maximum number of cycles is equal to ULLONG_MAX/clock->mult which
> > +	 * is equivalent to the below.
> > +	 * max_cycles < (2^63)/clock->mult
> > +	 * max_cycles < 2^(log2((2^63)/clock->mult))
> > +	 * max_cycles < 2^(log2(2^63) - log2(clock->mult))
> > +	 * max_cycles < 2^(63 - log2(clock->mult))
> > +	 * max_cycles < 1 << (63 - log2(clock->mult))
> > +	 * Please note that we add 1 to the result of the log2 to account for
> > +	 * any rounding errors, ensure the above inequality is satisfied and
> > +	 * no overflow will occur.
> > +	 */
> > +	max_cycles = 1ULL << (63 - (ilog2(clock->mult) + 1));
> > +
> > +	/*
> > +	 * The actual maximum number of cycles we can defer the clocksource is
> > +	 * determined by the minimum of max_cycles and clock->mask.
> > +	 */
> > +	max_cycles = min(max_cycles, clock->mask);
> > +	max_nsecs = cyc2ns(clock, max_cycles);
> 
>   Why do you want to recalculate the whole stuff over and over ?
> 
>   That computation can be done when the clock source is initialized or
>   any fundamental change of the clock parameters happens.
> 
>   Stick that value into the clocksource struct and just read it out.

Sigh. 

I was hoping to avoid hanging another bit of junk off of the clocksource
struct. 

But I guess we could compute that value on registration and keep it
around. Changes to mult could effect things, but should be well within
the 6% safety net we give ourselves.


> > +	/*
> > +	 * To ensure that the clocksource does not wrap whilst we are idle,
> > +	 * limit the time the clocksource can be deferred by 6.25%. Please
> > +	 * note a margin of 6.25% is used because this can be computed with
> > +	 * a shift, versus say 5% which would require division.
> > +	 */
> > +	max_nsecs = max_nsecs - (max_nsecs >> 4);
> > +
> > +	if (max_nsecs < 0)
> > +		max_nsecs = 0;
> 
>   How does "max_nsecs = max_nsecs - (max_nsecs >> 4)" ever become
>   negative ?

Fair point. Now we've limited the overflow case, we shouldn't trip
negative values. 

thanks
-john



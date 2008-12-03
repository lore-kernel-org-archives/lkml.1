Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYLCCgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYLCCgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYLCCf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:35:58 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2295 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLCCf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:35:58 -0500
Date: Wed, 3 Dec 2008 03:35:00 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, yanmin_zhang@linux.intel.com,
       alex.shi@intel.com, Thomas Gleixner <tglx@tglx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Catch xtime_nsec underflows and fix them
In-Reply-To: <1228185281.7176.37.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0812022118330.24668@localhost.localdomain>
References: <1228185281.7176.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 1 Dec 2008, john stultz wrote:

> Alex Shi, along with Yanmin Zhang have been noticing occasional time
> inconsistencies recently. Through their great diagnosis, they found that
> the xtime_nsec value used in update_wall_time was occasionally going
> negative. After looking through the code for awhile, I realized we have
> the possibility for an underflow when three conditions are met in
> update_wall_time():
> 
> 1) We have accumulated a second's worth of nanoseconds, so we
> incremented xtime.tv_sec and appropriately decrement xtime_nsec. (This
> doesn't cause xtime_nsec to go negative, but it can cause it to be
> small).
> 
> 2) The remaining offset value is large, but just slightly less then
> cycle_interval.
> 
> 3) clocksource_adjust() is speeding up the clock, causing a corrective
> amount (compensating for the increase in the multiplier being multiplied
> against the unaccumulated offset value) to be subtracted from
> xtime_nsec.
> 
> This can cause xtime_nsec to underflow.

This doesn't explain the problem entirely, I considered a negative 
xtime_nsec before, but xtime_nsec+offset should still be positive and 
produce the correct result, at least I can't find anything in 
getnstimeofday(). It should also be a very rare event, so it's really 
puzzling that it's so easy to reproduce.
So there must be more to it than just a negative xtime_nsec, it triggers 
the problem, but it's not the actual problem. One possible explanation is 
this line:

	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;

The rounding further increases the problem as the error is adjusted into 
the wrong direction and under the right conditions it seems to be possible 
to go out of sync as the error increasingly gets worse. I'd like to see 
some numbers to confirm this theory, in any case above line is incorrect 
for negative numbers.

> +	/* Since in the loop above, we accumulate any amount of time
> +	 * in xtime_nsec over a second into xtime.tv_sec, its possible for
> +	 * xtime_nsec to be fairly small after the loop. Further, if we're
> +	 * slightly speeding the clocksource up in clocksource_adjust(),
> +	 * its possible the required corrective factor to xtime_nsec could
> +	 * cause it to underflow.
> +	 * Now, we cannot simply roll the accumulated second back, since
> +	 * the NTP subsystem has been notified via second_overflow. So
> +	 * instead we push xtime_nsec forward by the amount we underflowed,
> +	 * and add that amount into the error.
> +	 * We'll correct this error next time through this function, when
> +	 * xtime_nsec is not as small.
> +	 */
> +	if (unlikely((s64)clock->xtime_nsec < 0)) {
> +		s64 neg = -(s64)clock->xtime_nsec;
> +		clock->xtime_nsec = 0;
> +		clock->error += neg << (NTP_SCALE_SHIFT - clock->shift);
> +	}

I don't mind this solution, but to be precise it avoids the problem.
My favourite solution would involve improving the xtime handling, as it's 
not really necessary to copy the nsec value back and forth between xtime 
and xtime_nsec, but it requires going through all xtime users, especially 
all settimeofday implementations, which also have to set xtime_nsec so 
update_wall_time() doesn't has to read it in. Then it's possible to make 
xtime_nsec signed and allow it to be negative.
So avoiding the negative nsec value is the better shorttime solution, but 
I'd prefer you'd drop the second paragraph, instead of suggesting a broken 
solution I'd rather see a bit info about how to fix this properly, i.e. 
fixing the xtime handling, so it's safe to allow negative values.

bye, Roman

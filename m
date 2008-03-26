Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYCZEkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYCZEkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYCZEkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:40:04 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4659 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYCZEkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:40:02 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/5] introduce CLOCK_MONOTONIC_RAW
Date: Wed, 26 Mar 2008 04:41:11 +0100
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <1205553852.6122.76.camel@localhost.localdomain> <Pine.LNX.4.64.0803150536290.1791@scrub.home> <1205805818.28128.91.camel@localhost>
In-Reply-To: <1205805818.28128.91.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803260441.12155.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 18. March 2008, john stultz wrote:

> > A general comment: the raw clock doesn't need any adjustments, so updates
> > don't have to be done that frequently and you can move most of that logic
> > into second_overflow().
>
> You're suggesting adding MONTONIC_RAW code to ntp.c ?  That doesn't make
> much sense to me (the whole point is its not ntp adjusted).

I didn't looked at the code, what I meant was moving it close to it, so it's 
done at the same time.

> Even if you 
> mean just inside the "if (clock->xtime_nsec >= (u64)NSEC_PER_SEC ..."
> conditional, then that means we don't get to leverage the
> cycles_interval, and cycle_last, values, so all of that would have to be
> duplicated and managed. Which I'm not sure it would save us much more
> then the extra add and compare here.

You could use a shift (e.g. SHIFT_HZ for non NO_HZ), to scale these value up a 
little.

> > IMO that's really a clock property, so this belongs in the clock
> > structure.
> > (Some day we may want to have multiple active clocks for various purposes
> > and thus export multiple raw clocks.)
>
> I disagree. I think that crufts up the clocksource structure (which is
> ideally just a simple hw counter abstraction), with timekeeping state.

It's not cruft, littering the code with unnecessary static variables is IMO 
worse. In OO terms this would be an abstract base class, the actual 
implementation only needs to provide a few functions and otherwise doesn't 
really have to worry about all the details.
Splitting the structure is certainly an option, but hiding related variables 
as static is IMO not a good choice.

> I'm still not sold on the multiple clocks with multiple notions of time
> idea you keep on bringing up.

Well, here are some ideas where I think it might be useful, it would make it 
possible to chain clocks with different frequencies:
- SMP systems with slighty different clock frequencies.
- instead of deactivating an unstable tsc clock, delay activation until we 
know it's stable.
- deactivate a tsc (which stops during sleep) before sleep and resync when 
needed.
- use different clocks for timer purposes (e.g. jiffies and a slow clock).

(The last point would make IMO more acceptable to use hrtimer for more trivial 
purposes, if it were at least possible to select the used clock.)

> > > +		if (raw_snsec >= (u64)NSEC_PER_SEC << clock->shift) {
> > > +			raw_snsec -= (u64)NSEC_PER_SEC << clock->shift;
> > > +			monotonic_raw.tv_sec++;
> > > +		}
> > > +
> >
> > You don't really have to use clock->shift as a scale, thus simplifying
> > the shifting here (e.g. by using NTP_SCALE_SHIFT).
> > I'm thinking about doing this for e.g. xtime_nsec as well.
>
> Could you explain this more?
>
> Given the clocksources have different shift values, why should we not
> keep the extra resolution?

The extra resolution is still there, as it doesn't make any sense to use a 
shift larger than 32.

> How does adding the extra shifting to convert from the clocksource scale
> to the NTP_SCALE_SHIFT value simplify the shifting?

NTP_SCALE_SHIFT is a constant and a very simple shift, which produces better 
code.
There are two ways to use the nsec value here:
1. nsec_now = (((cycle_new - cycle_last) * mult) + nsec) >> shift
2. nsec_now = ((cycle_new - cycle_last) * mult) >> shift +
		nsec >> NTP_SCALE_SHIFT
Both do the same under the condition that the gettime operation is not 
significantly shorter than 1nsec, but the second version can generate 
slightly better code. I intended to use the first for xtime_nsec, but instead 
the value is still splitted at every timer interrupt.
For the raw time please at least get rid of the splitting of raw_nsec in 
update_wall_time(). From the monotonic_raw value you only need the tv_sec 
part and the tv_nsec part can be calculated as above.

bye, Roman

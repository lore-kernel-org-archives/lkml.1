Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbYBSBCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbYBSBCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 20:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYBSBCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 20:02:25 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58282 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYBSBCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 20:02:24 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0802150436300.1822@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801251349120.17507@scrub.home>
	 <1201573686.6766.13.camel@localhost>
	 <Pine.LNX.4.64.0801290439480.17507@scrub.home>
	 <1201659263.6766.40.camel@localhost>
	 <Pine.LNX.4.64.0801310251090.17507@scrub.home>
	 <1201745776.6195.14.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801310404480.17507@scrub.home>
	 <1201914175.6216.46.camel@jstultz-laptop>
	 <Pine.LNX.4.64.0802081718040.3378@scrub.home>
	 <1202523452.6174.45.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802101917030.3378@scrub.home>
	 <1202774999.5984.106.camel@localhost>
	 <Pine.LNX.4.64.0802120335170.3378@scrub.home>
	 <1202963796.6195.141.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802150436300.1822@scrub.home>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 17:02:20 -0800
Message-Id: <1203382940.5984.242.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-16 at 05:24 +0100, Roman Zippel wrote:
> Hi,
> 
> On Wed, 13 Feb 2008, john stultz wrote:
> 
> > Oh! So your issue is that since time_freq is stored in ppm, or in effect
> > a usecs per sec offset, when we add it to something other then 1 second
> > we mis-apply what NTP tells us to. Is that right?
> 
> Pretty much everything is centered around that 1sec, so the closer the 
> update frequency is to it the better.
> 
> > Right, so if NTP has us apply a 10ppm adjustment, instead of doing:
> > 	NSEC_PER_SEC + 10,000
> > 
> > We're doing:
> > 	NSEC_PER_SEC + CLOCK_TICK_ADJUST + 10,000
> > 
> > Which, if I'm doing my math right, results in a 10.002ppm adjustment
> > (using the 999847467ns number above), instead of just a 10ppm
> > adjustment.
> > 
> > Now, true, this is an error, but it is a pretty small one. Even at the
> > maximum 500ppm value, it only results in an error of 76 parts per
> > billion. As you'll see below, that tends to be less error then what we
> > get from the clock granularity. Is there something else I'm missing here
> > or is this really the core issue you're concerned with?
> 
> The error accumulates and there is no good reason to do this for the 
> common case.

I agree, but we can also easily resolve this by scaling the ppm
adjustment to the interval length, rather then just applying it as
usec/sec. No?

So instead of:
	adjusted_length = NSEC_PER_SEC + time_adj

We could do:
	adjusted_length = ntp_interval_length + 
				(ntp_interval_length * time_adj)/MILLION


So this fixes the time_adj scaling error, while letting us be more
flexible w/ our interval length, so we can better map the requested
length to the clocksource granularity, lessening the granularity error.


> > HZ=1000 CLOCK_TICK_ADJUST=-152533
> > jiffies     	467 ppb error
> > jiffies NOHZ	467 ppb error
> > pit     	0 ppb error
> > pit NOHZ	0 ppb error
> > acpi_pm     	-280 ppb error
> > acpi_pm NOHZ	279 ppb error
> > 
> > HZ=1000 CLOCK_TICK_ADJUST=0
> > jiffies     	153000 ppb error
> > jiffies NOHZ	153000 ppb error
> > pit     	152533 ppb error
> > pit NOHZ	0 ppb error
> > acpi_pm     	-127112 ppb error
> > acpi_pm NOHZ	279 ppb error
> > 
> > So you are right, w/ pit & NO_HZ, the granularity error is always very
> > small both with or without CLOCK_TICK_ADJUST. 
> 
> If you change the frequency of acpi_pm to 3579000 you'll get this:
> 
> HZ=1000 CLOCK_TICK_ADJUST=0
> jiffies         153000 ppb error
> jiffies NOHZ    153000 ppb error
> pit             152533 ppb error
> pit NOHZ        0 ppb error
> acpi_pm         0 ppb error
> acpi_pm NOHZ    0 ppb error
> 
> HZ=1000 CLOCK_TICK_ADJUST=-152533
> jiffies         0 ppb error
> jiffies NOHZ    466 ppb error
> pit             -467 ppb error
> pit NOHZ        -1 ppb error
> acpi_pm         126407 ppb error
> acpi_pm NOHZ    22 ppb error

Right, but the acpi_pm's frequency isn't 3579000. It's supposed to be
3579545. That is injecting error, and I believe it to be different then
what I'm claiming is achieved by CLOCK_TICK_ADJUST.

Further, the specific example above was agreeing with you that  that
CLOCK_TICK_ADJUST=0 looks ok for NOHZ, with the exception in the case of
the jiffies clocksource.

That one still has the 153ppm drift. What do we do about that?


> CLOCK_TICK_ADJUST has only any meaning for PIT (and indirectly for 
> jiffies). For every other clock you just add some random value, where 
> it doesn't do _any_ good.

While not the main point, the aside I included about the acpi_pm being
interesting, is that because the ACPI PM's frequency is a multiple of
the PIT's (and thus jiffies), the same granularity issues arise
(although to a lesser degree). That is why CLOCK_TICK_ADJUST helps it in
the !NOHZ case.

> The worst case error there will always be (ntp_hz/freq/2*10^9nsec), all 
> you do with CLOCK_TICK_ADJUST is to do shift it around, but it doesn't 
> actually fix the error - it's still there.
> 
> > However, without CLOCK_TICK_ADJUST, the jiffies error increases for all
> > values of HZ except 100 (which at first seems odd, but seems to be due
> > to loss from rounding in the ACTHZ calculation).
> 
> jiffies depends on the timer resolution, so it will practically produce 
> the same results as PIT (assuming it's used to generate the timer tick).
> 
> > One interesting surprise in the data: With CLOCK_TICK_ADJUST=0, the
> > acpi_pm's error frequency shot up in the !NO_HZ cases. This ends up
> > being due to the acpi_pm being a very close to a multiple (3x) of the
> > pit frequency, so CLOCK_TICK_ADJUST helps it as well.
> 
> What exactly does it help with?
> All you are doing is number cosmetics, it has _no_ practically value and 
> only decreases the quality of timekeeping.

Unless you want to clarify what aspect of "quality" you're talking
about, I'd very much disagree with your claim. This is not cosmetics,
this is about addressing granularity error.

By using a base interval that does not match the clocksource's natural
granularity, we effectively inject a per-interval error. Since the error
is tracked and compensated by the clocksource_adjust() function, we end
up with a incorrect clocksource frequency. This then has to be
discovered and compensated for by NTP, in addition to the actual
hardware error.

By using a base interval that does match the clocksource's natural
granularity, we avoid the per-interval error. Without this per-interval
error, we utilize the specified frequency of the hardware, and NTP only
has to correct for the actual hardware error.

If we are building a train station, and each train car is 60ft, it
doesn't make much sense to build 1000ft stations, right? Instead you'll
do better if you build a 1020ft station.

That's what CLOCK_TICK_ADJ is trying to address.

Now, I'm open to doing something other then just adding CLOCK_TICK_ADJ.

For instance, if we find a way to push the initial xtime_interval
(without clocksource_adjust()'s adjustments - see the mult-adj-split
patch from my patchset friday) back to the ntp code so it uses that as
its interval base, and then use the time_adj scaling pointed out above.
That I think would work.


> > Further it seems to point that if we are going to be chasing down small
> > sub-100ppb errors (which I think would be great to do, but lets not make
> > users to endure 200+ppm errors while we debate the fine-tuning :) we
> > might want to consider a method where we let ntp_update_freq take into
> > account the current clocksource's interval length, so it becomes the
> > base value against which we apply adjustments (scaled appropriately).
> 
> The error at least is real, the use value of CLOCK_TICK_ADJUST for the 
> common case is not existent.

Again, I disagree.

> > There are 3 sources of error that we've discussed here:
> > 1) The large (280ppm) error seen with no-NTP adjustment, caused by the
> > inconsistent (A!=B) interval comparisons which started this discussion,
> > which my patch does address.
> 
> Part of the error is caused by CLOCK_TICK_ADJUST, but the other part of 
> the error is real, all you do is hiding it.

Explain hiding it. I'm just making sure we do equal comparisons. If
ntp_update_frequency() is using CLOCK_TICK_ADJUST, so should the
clocksource_calculate_interval() functions. 

And yes, if we remove CLOCK_TICK_ADJUST, that would also resolve the 
(A!=B) issue, but it doesn't address the error from #2 below.


> > 2) The medium (153-0ppm)clocksource granularity error shown in the data
> > above, caused by the actual interval length not matching the requested
> > interval length (what CLOCK_TICK_ADJUST tries to compensate for when
> > using jiffies/PIT).
> 
> To be precise: CLOCK_TICK_ADJUST doesn't compensate anything, it only 
> hides the error for jiffies/PIT. In any other case it's just some random 
> value added to it.

Wrong. We're using a base interval that maps to the granularity of the
PIT/jiffies clocksource. It doesn't matter too much for other
clocksources, as they're fine grained enough to not really matter, esp
if NTP_INTERVAL_FREQ is 2.


> > 3) The smaller (0.076ppm max) NTP adjustment error caused by the
> > parts-per-billion == nsec-per-sec shortcut used in combination w/ a base
> > interval that is not actually a second (due to CLOCK_TICK_ADJUST being
> > added in) in ntp_update_frequency() 
> 
> The maximum is not that trivial, e.g. alpha has a CLOCK_TICK_RATE value of 
> 32768 and has two possible HZ values 1024/1200. Everything is fine with 
> 1024, but with 1200 you create an error of ~11230ppm.

Uh. Check that again. I'm seeing the 11230ppm error only when looking at
the _granularity error_ when CLOCK_TICK_ADJUST is *not* used (where
CLOCK_TICK_ADJUST is used, we get 1.2ppm granularity error).

To see the maximum NTP adjustment error caused by the nsec-per-sec==ppb
shortcut, its:

(NSEC_PER_SEC + 500,000)/NSEC_PER_SEC - (NSEC_PER_SEC + CLOCK_TICK_ADJ +
500,000)/(NSEC_PER_SEC + CLOCK_TICK_ADJ) = -5689ppb error

So even here, in the case where a *very* poor HZ value is selected given
the CLOCK_TICK_RATE (its that train station analogy again), the error
from point #3 is fairly small.

> In the alpha case you have the interesting problem, that the timer tick is 
> generated by the RTC (if I see it correctly). If the alpha used clock 
> sources, what value should CLOCK_TICK_RATE have? Which of the three 
> possible clocks do you want to adjust - the jiffies, the PIT or the cpu 
> cycle clock?

On this I agree. If we're using fine grained clocksources,
CLOCK_TICK_RATE makes less and less sense. But it also should hurt less,
due to the granularity error being smaller on those clocksources. And
yes, one could imagine a system with multiple course clocks that have
different granularity errors and in that case CLOCK_TICK_RATE doesn't
address everything.

However right now CLOCK_TICK_RATE is important for very course
clocksources such as jiffies and the PIT. And many systems use those
clocksources (it should be noted, EVERY non GENERIC_TIME arch uses the
jiffies clocksource as its clocksource), so it effects many users. Until
systems do not use those as clocksources (when everyone has very fine
grained clocks) we need a solution here. I'm not seeing how your
suggestions solve this.

> That's the other big problem with CLOCK_TICK_RATE, for many archs it's 
> just some random value and in some unlucky configuration it now may do 
> more harm than it does any good. It had some value when process timer were 
> jiffies based, but since hrtimer that reason is gone and in the NTP code 
> it does more harm than good.

Oh yes. Setting it correctly is a responsibility of the arch maintainer.
If the arch has a incorrect CLOCK_TICK_RATE, it will very much do damage
to the accuracy of the jiffies clocksource and will hurt timekeeping. 

However, if we just remove CLOCK_TICK_RATE, we will hurt the jiffies
clocksource as well.


Overall, I think I agree with your basic dislike for CLOCK_TICK_RATE,
but I do not see how we just get rid of it as you suggest and still have
good timekeeping for all systems.


So again I claim these are the issues, in severity order:

1) A!=B interval comparison needs to get solved. This is just a brain
dead source of large error, and is easily fixed one way or the other.

2) We need a solution that handles granularity error well, as this is a
moderate source of error for course clocksources such as jiffies.
CLOCK_TICK_ADJUST does cover this fairly well in most cases. I suspect
we could do even better, but that will take some deeper changes.

3) We should make sure the even smaller error done by not scaling the
ntp frequency adjustment to the interval length is corrected.


My approach solves only #1. #2 is addressed as CLOCK_TICK_ADJUST handles
it relatively well in most cases. I've proposed that we scale the
frequency adjustment properly to handle #3.

My understanding of your approach (removing CLOCK_TICK_ADJUST),
addresses issues #1 and #3, but hurts issue #2.

So have we talked this out enough? :) 

If I'm still mis-characterizing your solution, feel free to send a patch
and I'll try to refine my critique.

thanks
-john


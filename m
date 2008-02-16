Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYBPEYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYBPEYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 23:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYBPEYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 23:24:10 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:38390 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYBPEYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 23:24:08 -0500
Date: Sat, 16 Feb 2008 05:24:05 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1202963796.6195.141.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0802150436300.1822@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home>  <1202523452.6174.45.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802101917030.3378@scrub.home>  <1202774999.5984.106.camel@localhost>
  <Pine.LNX.4.64.0802120335170.3378@scrub.home> <1202963796.6195.141.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 13 Feb 2008, john stultz wrote:

> Oh! So your issue is that since time_freq is stored in ppm, or in effect
> a usecs per sec offset, when we add it to something other then 1 second
> we mis-apply what NTP tells us to. Is that right?

Pretty much everything is centered around that 1sec, so the closer the 
update frequency is to it the better.

> Right, so if NTP has us apply a 10ppm adjustment, instead of doing:
> 	NSEC_PER_SEC + 10,000
> 
> We're doing:
> 	NSEC_PER_SEC + CLOCK_TICK_ADJUST + 10,000
> 
> Which, if I'm doing my math right, results in a 10.002ppm adjustment
> (using the 999847467ns number above), instead of just a 10ppm
> adjustment.
> 
> Now, true, this is an error, but it is a pretty small one. Even at the
> maximum 500ppm value, it only results in an error of 76 parts per
> billion. As you'll see below, that tends to be less error then what we
> get from the clock granularity. Is there something else I'm missing here
> or is this really the core issue you're concerned with?

The error accumulates and there is no good reason to do this for the 
common case.

> > In consequence this means, if we want to improve timekeeping, we first set 
> > the (update_cycles * NTP_INTERVAL_FREQ) interval as close as possible to 
> > the real frequency. It doesn't has to be perfect as we usually don't know 
> > the real frequency with 100% certainty anyway. 
> 
> This might need some more explanation, as I'm not certain I know what
> update_cycles refers to. Do you mean cycle_interval? I guess I'm not
> completely sure how you're suggesting we change things here.

clock->cycle_interval

> > Second, we drop the tick 
> > adjustment if possible and leave the adjustments to the NTP daemon and as 
> > long as the drift is within the 500ppm limit it has no problem to manage 
> > this.
> 
> Dropping the tick adjustment? By that do you mean the tick_usec value
> set by adjtimex()? I don't quite see why we want that. Could you expand
> here?

CLOCK_TICK_ADJUST

> HZ=1000 CLOCK_TICK_ADJUST=-152533
> jiffies     	467 ppb error
> jiffies NOHZ	467 ppb error
> pit     	0 ppb error
> pit NOHZ	0 ppb error
> acpi_pm     	-280 ppb error
> acpi_pm NOHZ	279 ppb error
> 
> HZ=1000 CLOCK_TICK_ADJUST=0
> jiffies     	153000 ppb error
> jiffies NOHZ	153000 ppb error
> pit     	152533 ppb error
> pit NOHZ	0 ppb error
> acpi_pm     	-127112 ppb error
> acpi_pm NOHZ	279 ppb error
> 
> So you are right, w/ pit & NO_HZ, the granularity error is always very
> small both with or without CLOCK_TICK_ADJUST. 

If you change the frequency of acpi_pm to 3579000 you'll get this:

HZ=1000 CLOCK_TICK_ADJUST=0
jiffies         153000 ppb error
jiffies NOHZ    153000 ppb error
pit             152533 ppb error
pit NOHZ        0 ppb error
acpi_pm         0 ppb error
acpi_pm NOHZ    0 ppb error

HZ=1000 CLOCK_TICK_ADJUST=-152533
jiffies         0 ppb error
jiffies NOHZ    466 ppb error
pit             -467 ppb error
pit NOHZ        -1 ppb error
acpi_pm         126407 ppb error
acpi_pm NOHZ    22 ppb error

CLOCK_TICK_ADJUST has only any meaning for PIT (and indirectly for 
jiffies). For every other clock you just add some random value, where 
it doesn't do _any_ good.
The worst case error there will always be (ntp_hz/freq/2*10^9nsec), all 
you do with CLOCK_TICK_ADJUST is to do shift it around, but it doesn't 
actually fix the error - it's still there.

> However, without CLOCK_TICK_ADJUST, the jiffies error increases for all
> values of HZ except 100 (which at first seems odd, but seems to be due
> to loss from rounding in the ACTHZ calculation).

jiffies depends on the timer resolution, so it will practically produce 
the same results as PIT (assuming it's used to generate the timer tick).

> One interesting surprise in the data: With CLOCK_TICK_ADJUST=0, the
> acpi_pm's error frequency shot up in the !NO_HZ cases. This ends up
> being due to the acpi_pm being a very close to a multiple (3x) of the
> pit frequency, so CLOCK_TICK_ADJUST helps it as well.

What exactly does it help with?
All you are doing is number cosmetics, it has _no_ practically value and 
only decreases the quality of timekeeping.

> Further it seems to point that if we are going to be chasing down small
> sub-100ppb errors (which I think would be great to do, but lets not make
> users to endure 200+ppm errors while we debate the fine-tuning :) we
> might want to consider a method where we let ntp_update_freq take into
> account the current clocksource's interval length, so it becomes the
> base value against which we apply adjustments (scaled appropriately).

The error at least is real, the use value of CLOCK_TICK_ADJUST for the 
common case is not existent.

> There are 3 sources of error that we've discussed here:
> 1) The large (280ppm) error seen with no-NTP adjustment, caused by the
> inconsistent (A!=B) interval comparisons which started this discussion,
> which my patch does address.

Part of the error is caused by CLOCK_TICK_ADJUST, but the other part of 
the error is real, all you do is hiding it.

> 2) The medium (153-0ppm)clocksource granularity error shown in the data
> above, caused by the actual interval length not matching the requested
> interval length (what CLOCK_TICK_ADJUST tries to compensate for when
> using jiffies/PIT).

To be precise: CLOCK_TICK_ADJUST doesn't compensate anything, it only 
hides the error for jiffies/PIT. In any other case it's just some random 
value added to it.

> 3) The smaller (0.076ppm max) NTP adjustment error caused by the
> parts-per-billion == nsec-per-sec shortcut used in combination w/ a base
> interval that is not actually a second (due to CLOCK_TICK_ADJUST being
> added in) in ntp_update_frequency() 

The maximum is not that trivial, e.g. alpha has a CLOCK_TICK_RATE value of 
32768 and has two possible HZ values 1024/1200. Everything is fine with 
1024, but with 1200 you create an error of ~11230ppm.

In the alpha case you have the interesting problem, that the timer tick is 
generated by the RTC (if I see it correctly). If the alpha used clock 
sources, what value should CLOCK_TICK_RATE have? Which of the three 
possible clocks do you want to adjust - the jiffies, the PIT or the cpu 
cycle clock?

That's the other big problem with CLOCK_TICK_RATE, for many archs it's 
just some random value and in some unlucky configuration it now may do 
more harm than it does any good. It had some value when process timer were 
jiffies based, but since hrtimer that reason is gone and in the NTP code 
it does more harm than good.

bye, Roman

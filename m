Return-Path: <linux-kernel-owner+w=401wt.eu-S1762930AbYBLOpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762930AbYBLOpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760645AbYBLOpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:45:09 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:3003 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759928AbYBLOpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:45:08 -0500
Date: Tue, 12 Feb 2008 15:36:17 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1202774999.5984.106.camel@localhost>
Message-ID: <Pine.LNX.4.64.0802120335170.3378@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home>  <1202523452.6174.45.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802101917030.3378@scrub.home> <1202774999.5984.106.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 11 Feb 2008, john stultz wrote:

> > I don't want to just send a patch, I want you to understand why your 
> > approach is wrong.
> 
> With all due respect, it also keeps the critique in one direction and
> makes your review less collaborative and more confrontational then I
> suspect (or maybe just hope) you intend.

I don't think that's necessarily a contradiction, if we keep it to 
confronting the problem. A simple patch wouldn't have provided any further 
understanding of the problem compared to what I already said. You would 
have seen what the patch does (which I described already differently), but 
not really why it does that.

In this sense I prefer to force the confrontation of the problem. I'm 
afraid a working patch would encourage to simply ignore the problem, as 
your problem at hand would be solved without completely understanding it.
The point is that I'd really like you to understand the problem, so I'm 
not the only one who understands this code :) and in the end it might 
allow better collaboration to further improve this code.

To make it very clear this is just about understanding the problem, I 
don't want to force a specific solution (which a patch would practically 
do). If we both understand the problem, we can also discuss the solution 
and maybe we find something better, but maybe I'm also totally wrong, 
which would be a little embarrassing :), but that would be fine too. There 
may be better ways to go about this problem, but IMO it would still be 
better than just ignoring the problem and force it with a patch.

> This fine grained error accounting is where the bug I'm trying to
> address is cropping up from. In order to have the comparison we need to
> have two values:
>  A: The clocksource's notion of how long the fixed interval is.
>  B: NTP's notion of how long the fixed interval is.
> 
> When no NTP adjustment is being made, these two values should be equal,
> but currently they are not. This is what causes the 280ppm error seen on
> my test system.
> 
> Part A is calculated in the following fashion:
> 	#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
> 
> 	Which is then functionally shifted up by TICK_LENGTH_SHIFT, but for the
> course of this discussion, lets ignore that.
> 
> Part B is calculated in ntp_update_frequency() as:
> 
> 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
> 				<< TICK_LENGTH_SHIFT;
> 	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
> 	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
> 
> 	tick_length_base = second_length;
> 	do_div(tick_length_base, NTP_INTERVAL_FREQ);
> 
> 
> If we're assuming there is no NTP adjustment, and avoiding the
> TICK_LENGTH_SHIFT, this can be shorted to:
> 	B = ((TICK_USEC * NSEC_PER_USEC * USER_HZ)
> 		+ CLOCK_TICK_ADJUST)/NTP_ITNERVAL_FREQ
> 
> 
> The A vs B comparison can be shortened further to:
> 	NSEC_PER_SEC != (TICK_USEC * NSEC_PER_USEC * USER_HZ)
> 				+ CLOCK_TICK_ADJUST
> 
> So now on to what seems to be the point of contention:
> 	If A != B, which side do we fix?
> 
> 
> My patches fix the A side so that it matches B, which on its face isn't
> terribly complicated, but you seem to be suggesting we fix the B side
> instead (Now I'm assuming here, because there's no patch. So I can only
> speak to your emails, which were not clear to me).

If we go from your base assumption above "there is no NTP adjustment", I 
would actually agree with you and it wouldn't matter much on which side 
to correct the equation.

The question is now what happens, if there are NTP adjustments, i.e. when 
the time_freq value isn't zero. Based on this initialization we tell the 
NTP daemon the base frequency, although not directly but it knows the 
length freq1 == 1 sec. If the clock now needs adjustment, the NTP daemon 
tells the kernel via time_freq how to change the speed so that freq1 == 
1 sec + time_freq.

The problem is now that by using CLOCK_TICK_ADJUST we are cheating and we 
don't tell the NTP daemon the real frequency. We define 1 sec as freq2 + 
tick_adjust and with the NTP adjustment we have freq2 + tick_adj == 1 sec 
+ time_freq. Above initialization now calcalutes the base time length for 
an update interval of freq2 / NTP_INTERVAL_FREQ, this means the requested 
time_freq adjustment isn't applied to (freq2 + tick_adj) cycles but to 
freq2 cycles, so this finally means any adjustment made by the NTP daemon 
is slightly off.

To demonstrate this let's look at some real values and let's use the PIT 
for it (as this is where this originated and on which CLOCK_TICK_ADJUST is 
based on). With freq1=1193182 and HZ=1000 we program the timer with 1193 
cycles and the actual update frequency is freq2=1193000. To adjust for 
this difference we change the length of a timer tick:

	(NSEC_PER_SEC + CLOCK_TICK_ADJUST) / NTP_INTERVAL_FREQ

or

	(10^9 nsec - 152533 nsec) / 1000

This way every 1000 interrupts or 1193000 cycles the clock is advanced by 
999847467 nsec, so that we advance time according to freq1, but any 
further adjustments aren't applied to an interval of what the NTP daemon 
thinks is 1 sec but 999847467 nsec instead.

In consequence this means, if we want to improve timekeeping, we first set 
the (update_cycles * NTP_INTERVAL_FREQ) interval as close as possible to 
the real frequency. It doesn't has to be perfect as we usually don't know 
the real frequency with 100% certainty anyway. Second, we drop the tick 
adjustment if possible and leave the adjustments to the NTP daemon and as 
long as the drift is within the 500ppm limit it has no problem to manage 
this.

> However, what happens if a system uses the PIT or jiffies clocksource,
> which do suffer from the HZ / ACTHZ error resolved by the patch linked
> to above? Since those clocksources are so course, we still need to take
> that error into account. So in that regard the assumptions are still
> valid, no?
> 
> You've seemingly suggested we set CLOCK_TICK_ADJUST to zero in the
> CONFIG_NO_HZ situation, however note that a CONFIG_NO_HZ kernel should
> be able to  boot and run on a box that only supports the jiffies or pit
> clocksource (just not be able to switching into NO_HZ mode). Further,
> how does that resolve the issue w/ the tsc/hpet/acpi_pm clocksources
> that still exist when CONFIG_NO_HZ=n?
> 
> I just don't see how this will work.

Look at your Part A, with NO_HZ the update interval is much larger, so any 
rounding error becomes practically irrelevant. In the above PIT example 
the update interval wouldn't be 1193 cycles but 596591 cycles instead.

I hope this helps to understand what I suggested. For NO_HZ we can just 
drop this correction without problems. In the other case it's a little 
more complicated, but we basically have to check the update interval and 
if (interval * NTP_INTERVAL_FREQ) is within the 500ppm limit there isn't 
much we really have to do.
This correction was only introduced to accommodate clocks which exceed 
this 500ppm limit for whatever reason, so the NTP daemon isn't confused. 
The best solution would be really to limit this correction to these 
clocks.

bye, Roman

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYBLAKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYBLAKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYBLAKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:10:06 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36498 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbYBLAKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:10:04 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0802101917030.3378@scrub.home>
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
Content-Type: text/plain
Date: Mon, 11 Feb 2008 16:09:59 -0800
Message-Id: <1202774999.5984.106.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-10 at 19:45 +0100, Roman Zippel wrote:
> Hi,
> 
> On Fri, 8 Feb 2008, john stultz wrote:
> 
> > -ENOPATCH
> > 
> > We're taking weeks to critique fairly small bug fix. I'm sure we both
> > have better things to do then continue to misunderstand each other. I'll
> > do the testing and will happily ack it if it resolves the issue.
> 
> I don't want to just send a patch, I want you to understand why your 
> approach is wrong.

With all due respect, it also keeps the critique in one direction and
makes your review less collaborative and more confrontational then I
suspect (or maybe just hope) you intend.


> > Now, If you're disputing that I'm correcting the wrong side of the
> > equation, then we're getting somewhere. But its still not clear to me
> > how you're suggesting the other side (which is calculated in
> > ntp_update_frequency) be changed.
> > [..]
> > You keep on bringing up NO_HZ, and again, the bug I'm trying to fix
> > occurs with or without NO_HZ. The fix I proposed resolves the issue with
> > or without NO_HZ.
> 
> The correction is incorrect for NO_HZ.
> Let's try it the other way around, as my explanation seem to lack 
> something.
> Please try to explain what this correction actually means and why it 
> should be correct for NO_HZ as well.


For the course of this discussion, lets assume we're talking about
2.6.24.

One of the goals of the timekeeping design is to let it be flexible
enough that accumulation interval can be irregular and it will still
behave correctly. This stems from the one of original issues with the
old tick based timekeeping: lost or irregular timer interrupts.

Now, we do used fixed interval accumulation in update_wall_time, but
that was for two reasons:
1) In the common case, its faster to do the compare and add/subtract
then the mult orignally used (*a)
2) It allows for the extra fine-grained NTP error accounting.


This fine grained error accounting is where the bug I'm trying to
address is cropping up from. In order to have the comparison we need to
have two values:
 A: The clocksource's notion of how long the fixed interval is.
 B: NTP's notion of how long the fixed interval is.

When no NTP adjustment is being made, these two values should be equal,
but currently they are not. This is what causes the 280ppm error seen on
my test system.

Part A is calculated in the following fashion:
	#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)

	Which is then functionally shifted up by TICK_LENGTH_SHIFT, but for the
course of this discussion, lets ignore that.

Part B is calculated in ntp_update_frequency() as:

	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
				<< TICK_LENGTH_SHIFT;
	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);

	tick_length_base = second_length;
	do_div(tick_length_base, NTP_INTERVAL_FREQ);


If we're assuming there is no NTP adjustment, and avoiding the
TICK_LENGTH_SHIFT, this can be shorted to:
	B = ((TICK_USEC * NSEC_PER_USEC * USER_HZ)
		+ CLOCK_TICK_ADJUST)/NTP_ITNERVAL_FREQ


The A vs B comparison can be shortened further to:
	NSEC_PER_SEC != (TICK_USEC * NSEC_PER_USEC * USER_HZ)
				+ CLOCK_TICK_ADJUST

So now on to what seems to be the point of contention:
	If A != B, which side do we fix?


My patches fix the A side so that it matches B, which on its face isn't
terribly complicated, but you seem to be suggesting we fix the B side
instead (Now I'm assuming here, because there's no patch. So I can only
speak to your emails, which were not clear to me).

Really it doesn't matter to me, as long as it works in all the cases
needed. You're argument of simplifying B so its closer to A does sound
initially compelling. Simpler is better, so lets follow the discussion
below to see if it will work, or if I'm just missing something.


*a: Note: this does backfire on us if the fixed interval is too small,
causing the loop to run too many times, which was seen when NO_HZ was
being merged. This was why we changed the NTP_INTERVAL_FREQ to be about
half a second w/ NO_HZ, which reduced the time spent in the accumulation
loop.


> This is the original patch which introduced the correction:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=69c1cd9218e4cf3016b0f435d6ef3dffb5a53860
> 
> Keep in mind that at that time PIT was used as the base clock (even if the 
> tsc was used, it was relative to PIT). So how much of those assumptions 
> are still valid today (especially with NO_HZ enabled)?

Indeed! When we use the TSC, acpi_pm, HPET or other fine grained
clocksource (regardless of NO_HZ), it does seem silly to take these odd
PIT based values into account.

However, what happens if a system uses the PIT or jiffies clocksource,
which do suffer from the HZ / ACTHZ error resolved by the patch linked
to above? Since those clocksources are so course, we still need to take
that error into account. So in that regard the assumptions are still
valid, no?

You've seemingly suggested we set CLOCK_TICK_ADJUST to zero in the
CONFIG_NO_HZ situation, however note that a CONFIG_NO_HZ kernel should
be able to  boot and run on a box that only supports the jiffies or pit
clocksource (just not be able to switching into NO_HZ mode). Further,
how does that resolve the issue w/ the tsc/hpet/acpi_pm clocksources
that still exist when CONFIG_NO_HZ=n?

I just don't see how this will work.

Now, don't get me wrong, I'd love it if we didn't have to include
CLOCK_TICK_ADJUST, simpler is better, but I don't see how it will work
correctly.

So instead of trying to fix part B by removing the CLOCK_TICK_ADJUST
component, lets look at my solution, which adds the pit based
corrections to part A.

***This is the key part***: Since the hpet/acpi_pm/tsc are high res
clocksources, they can easily adapt to the request for a slightly odd
interval length, and it will not affect them. They are flexible like
that.

AGAIN: For high res clocksources, the interval length requested can be
almost(see note *a above, as well as hardware wrapping which puts some
limitations on us) arbitrary and the code should function correctly. 

So CLOCK_TICK_ADJUST doesn't really mean anything in relation to
hpet/acpi_pm/tsc, but it also doesn't hurt us to include it.

But if, when using the same kernel, we switch to the jiffies
clocksource, we need to request a interval length that matches the
actual jiffy/pit tick length. This is why CLOCK_TICK_ADJUST is still
needed.

So by modifying part A, we achieve the consistency needed (that is
A==B), and we still function well with low-res clocksources. Further we
don't need any config time decisions to be made to function correctly.
It just all works out.

Now, I'm sure its quite likely I've somehow not understood your
suggestions. Maybe you are not suggesting adding lots of compile time
logic to try to even the B side out. Again, a patch would likely clarify
all of this.

thanks
-john


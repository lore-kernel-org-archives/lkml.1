Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYBTRIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYBTRIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764744AbYBTRIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:08:25 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:45252 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757692AbYBTRIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:08:21 -0500
Date: Wed, 20 Feb 2008 18:08:43 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1203472250.6123.98.camel@localhost>
Message-ID: <Pine.LNX.4.64.0802200348230.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home>  <1202523452.6174.45.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802101917030.3378@scrub.home>  <1202774999.5984.106.camel@localhost>
  <Pine.LNX.4.64.0802120335170.3378@scrub.home>  <1202963796.6195.141.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802150436300.1822@scrub.home>  <1203382940.5984.242.camel@localhost>
  <Pine.LNX.4.64.0802190219360.2723@scrub.home> <1203472250.6123.98.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 19 Feb 2008, john stultz wrote:

> To better keep with your analogy, you'd have to imagine a scale that
> only reads in X pound increments. As long as X is fairly small, it
> should measure everyone's weight fairly well. However, if X is large,
> like say 50kg, then it won't weigh a 70kg person very accurately (even
> if he is a liar and he really weighs 77kgs).
> 
> 
> This is the granularity error I'm talking about. 

There is a big difference between accuracy and granularity. Even a coarse 
grained scale can be accurate (just within its resolution) and a fine 
grained scale can be very inaccurate if you shift around the scale.
Please keep this separate, otherwise this can go on forever...

> Now, when NTP starts up, if we had perfect hardware and there was no
> hardware drift, NTP would have to inject a -153ppm correction to offset
> the systematic error we've introduced.
> 
> If we do not have perfect hardware, then NTP would have to correct for
> both the 153ppm error and the hardware error. Sp if the hardware error
> was in the same direction, we can now only compensate for up to a 347ppm
> hardware drift, before we hit the 500ppm bound in NTP.

Out of curiosity, what kind of hardware error do you expect?
If you have that crappy hardware you're better off initializing the clock 
with the correct frequency.

> > To keep in mind what time adjusting is supposed to do:
> > 
> > 	freq = 1sec + time_freq
> 
> But it is this fixation on 1sec that is the cause of the granularity
> error.

You need some kind of fix point and everyone is using 1sec for as base 
length, for some mysterious reason you're now trying to redefine it.
The PIT (and any clock based on it) has a certain resolution, so with an 
update frequency of HZ=1000 it produces a certain error, but why on earth 
are you trying to introduce this error as universal constant? This is a 
property of the PIT clock, applying this error to every other clock makes 
no sense.

> I believe the following is also correct (assuming time_freq is in ppm units):
> 
> adjusted_freq = interval_length + (interval_length * time_freq)/MILLION
> 
> This properly scales the adjustment to any interval length.

Actually it's not that simple, ntp_update_frequency() only calculates the 
base length, time_offset had to be scaled as well (and back when requested 
from user space). You would add a lot of complexity for a silly little 
error, which the current mechanisms can handle just fine.

> > What we do instead is:
> > 
> > 	freq + tick_adj = 1sec + time_freq
> > 
> > Where exactly is now the problem to integrate tick_adj into time_freq? The 
> > result is _exactly_ the same. The only visible difference is a slightly 
> > higher time_freq value and as long as it is within the 500 ppm limit there 
> > is simply no problem.
> 
> Well, it is a problem if its large. The 500ppm limit is supposed to be
> for hardware frequency error correction, not hardware frequency +
> software error correction. Now, if it were 1-10ppm, it wouldn't be that
> big of an issue, but with the jiffies example above, 153ppm does cut
> into the correctable space a good bit.

Again, what kind of crappy hardware do you expect? Aren't clocks supposed 
to get better and not worse?
Where do you get this idea that the 500ppm are exclusively for hardware 
errors? If you have such bad hardware, there is another simple solution: 
change HZ to 100 and the error is reduced to 15ppm.

I would see the point if this problem had actually any practically 
relevance, but this error is not a problem for pretty much all existing 
standard hardware. Why are you insisting on redesigning timekeeping for 
broken hardware?

> > > My understanding of your approach (removing CLOCK_TICK_ADJUST),
> > > addresses issues #1 and #3, but hurts issue #2.
> > 
> > What exactly is hurt?
> 
> By injecting 153ppm of error, the ability for NTP to correct hardware
> error within 500ppm is hurt.

There's nothing 'injected', that resolution error is very real and the 
500ppm limit is more than enough to deal with this. _Nobody_ is hurt by 
this.

> Sigh. So at this point, if we're not closing the gap in our
> understanding, I'm not sure how much its worth to continue on the
> discussion in this manner. I'd welcome anyone to help clarify what I'm
> missing, or maybe assistance in better communicating my point.

The point is you are redefining a mechanism which has _never_ been 
intendend for purpose you're trying to abuse it for now.
Reread the original patch, it was intended for kernel with HZ of 2000, 
where the error would be 687ppm. Now we have other ways to increase the 
resolution, timekeeping isn't solely based on the PIT anymore. The whole 
reason for the original patch is pretty much gone by now.

If you really need some kind of adjustment for your extremely broken 
hardware, below is the absolute maximum you need, which doesn't inflict 
more insanity on all the sane hardware.

bye, Roman


Revert bbe4d18ac2e058c56adb0cd71f49d9ed3216a405 and 
e13a2e61dd5152f5499d2003470acf9c838eab84 and remove CLOCK_TICK_ADJUST 
completely. Add a optional kernel parameter ntp_tick_adj instead to allow 
adjusting of a large base drift and thus keeping ntpd happy.
The CLOCK_TICK_ADJUST mechanism was introduced at a time PIT was the 
primary clock, but we have a varity of clock sources now, so a global PIT 
specific adjustment makes little sense anymore.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>


---
 include/linux/timex.h     |    9 +--------
 kernel/time/ntp.c         |   11 ++++++++++-
 kernel/time/timekeeping.c |    6 ++----
 3 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/timex.h
===================================================================
--- linux-2.6.orig/include/linux/timex.h
+++ linux-2.6/include/linux/timex.h
@@ -232,14 +232,7 @@ static inline int ntp_synced(void)
 #else
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
-
-#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-					(s64)CLOCK_TICK_RATE)
-
-/* Because using NSEC_PER_SEC would be too easy */
-#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC * NSEC_PER_USEC * USER_HZ) + \
-			      CLOCK_TICK_ADJUST) / NTP_INTERVAL_FREQ)
+#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -42,12 +42,13 @@ long time_esterror = NTP_PHASE_LIMIT;	/*
 long time_freq;				/* frequency offset (scaled ppm)*/
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
+long ntp_tick_adj;
 
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
 				<< TICK_LENGTH_SHIFT;
-	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
+	second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
 	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
 
 	tick_length_base = second_length;
@@ -400,3 +401,11 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	notify_cmos_timer();
 	return(result);
 }
+
+static int __init ntp_tick_adj_setup(char *str)
+{
+	ntp_tick_adj = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ntp_tick_adj=", ntp_tick_adj_setup);
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -187,8 +187,7 @@ static void change_clocksource(void)
 
 	clock->error = 0;
 	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
 	tick_clock_notify();
 
@@ -245,8 +244,7 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;

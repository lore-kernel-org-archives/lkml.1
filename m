Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYBVCji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYBVCji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYBVCjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:39:25 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54366 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYBVCjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:39:22 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0802200348230.2723@scrub.home>
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
	 <1203382940.5984.242.camel@localhost>
	 <Pine.LNX.4.64.0802190219360.2723@scrub.home>
	 <1203472250.6123.98.camel@localhost>
	 <Pine.LNX.4.64.0802200348230.2723@scrub.home>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 18:39:11 -0800
Message-Id: <1203647951.6150.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 18:08 +0100, Roman Zippel wrote:
> > Well, it is a problem if its large. The 500ppm limit is supposed to be
> > for hardware frequency error correction, not hardware frequency +
> > software error correction. Now, if it were 1-10ppm, it wouldn't be that
> > big of an issue, but with the jiffies example above, 153ppm does cut
> > into the correctable space a good bit.
> 
> Again, what kind of crappy hardware do you expect? Aren't clocks supposed 
> to get better and not worse?

Well, while I've seen much worse, I consider crappy hardware to be 100
+ppm error. So if the hardware is perfect and the system results in
153ppm error, I'd consider that pretty crappy, especially if its not the
hardware's fault.

> Where do you get this idea that the 500ppm are exclusively for hardware 
> errors? If you have such bad hardware, there is another simple solution: 
> change HZ to 100 and the error is reduced to 15ppm.

True its not exclusively for hardware errors, and if we were talking
about only 15ppm I wouldn't really worry about it. But when we're saying
the system is adding 30% of the maximum error, that's just not good.

> I would see the point if this problem had actually any practically 
> relevance, but this error is not a problem for pretty much all existing 
> standard hardware. Why are you insisting on redesigning timekeeping for 
> broken hardware?

Remember my earlier data? Where I was talking about the acpi_pm being a
multiple of the PIT frequency? By removing CLOCK_TICK_ADJUST we got a
127ppm error when HZ=1000. NO_HZ drops that down to where we don't care,
but this _does_ effect current hardware, so I'd call it relevant.


> > > > My understanding of your approach (removing CLOCK_TICK_ADJUST),
> > > > addresses issues #1 and #3, but hurts issue #2.
> > > 
> > > What exactly is hurt?
> > 
> > By injecting 153ppm of error, the ability for NTP to correct hardware
> > error within 500ppm is hurt.
> 
> There's nothing 'injected', that resolution error is very real and the 
> 500ppm limit is more than enough to deal with this. _Nobody_ is hurt by 
> this.

Sure, 500ppm is enough for most people with good hardware. But remember
the alpha example you brought up earlier? The HZ=1200 case, with the
CLOCK_TICK_RATE=32768? If we don't take CLOCK_TICK_ADJUST into account,
we end up with a **11230ppm** error from the granularity issue. NTP just
won't work on those systems.

Now granted, the three types of alpha systems that actually use that HZ
value is probably as close to "nobody" as you're going to get, but I
don't think we can just throw the granularity issue aside.


> Revert bbe4d18ac2e058c56adb0cd71f49d9ed3216a405 and 
> e13a2e61dd5152f5499d2003470acf9c838eab84 and remove CLOCK_TICK_ADJUST 
> completely. Add a optional kernel parameter ntp_tick_adj instead to allow 
> adjusting of a large base drift and thus keeping ntpd happy.
> The CLOCK_TICK_ADJUST mechanism was introduced at a time PIT was the 
> primary clock, but we have a varity of clock sources now, so a global PIT 
> specific adjustment makes little sense anymore.
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

So thanks so much for sending the patch. It makes clear your solution.

My initial comments: Its simple and that really does have its merits. It
resolves the inconsistent comparison issue, and does not have the
smallish scaling error we talked about as well. As I've said before, I
do like the idea, I'm just worried about the corner cases (mainly
jiffies based systems).

The granularity issue is still present. Depending on the HZ settings and
the clocksource hardware, systems may see large errors added on to the
actual hardware error, and its possible the kernel error may dominate
the actual hardware error.

The ntp_tick_adjust option does give a way out if you have, for example,
one of those alpha systems where it would be necessary, but I do wish
there was a better way then forcing users to calculate for themselves
what the granularity adjustment should be (esp given that it is more a
function of the kernel compile options, so different kernels would need
different values for the same system).

So then yes, your patch is simple and corrects the issue that started
the discussion. I think we're closing the gaps. :)

I still think my claims hold that your patch as it stands may worsen the
drift error depending on HZ settings, especially on jiffies based
systems (which means every non-GENERIC_TIME arch). However, if folks
don't really care, then that may be acceptable.

As promised, here is my own patch, which takes the scaling error you
pointed out into account, as well as resolving the granularity issue in
a way similar to your ntp_tick_adjust option does, only the kernel will
calculate such a granularity correction on a per-clocksource base, so
users don't have to do the math.

Sadly I've not had the chance to really test and debug this (there's a
lot of shifting logic, so I may have flubed something there), but I
wanted to send it out for comments, as I think it communicates the gist
of the idea. I'll test and refine it tomorrow and send it out again if
needed.

Let me know what you think.

Again, thanks for sending the patch and your continued feedback!
-john

----------------------------------------->

My first version of the ntp_interval/tick_length inconsistent usage
patch was recently merged as bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

While the fix did greatly improve the situation, Roman correctly pointed
out that it does have a small bug: If the users change clocksources
after the system has been running and NTP has made corrections, the
correctoins made against the old clocksource will be applied against the
new clocksource, causing error.

My second attempt, which corrects the issue in the NTP_INTERVAL_LENGTH
definition has also made it up-stream as commit
e13a2e61dd5152f5499d2003470acf9c838eab84

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e13a2e61dd5152f5499d2003470acf9c838eab84

Roman also had objections to this patch, and I agree with some, but not
all of them.

This patch reverts both of those changes, and introduces a new solution:

Roman has correctly pointed out that CLOCK_TICK_ADJUST is calculated
based on the PIT's frequency, and isn't really relevant to non-PIT
driven clocksources (that is, clocksources other then jiffies and pit).

However, by removing CLOCK_TICK_ADJUST, we no longer take into account
the granularity error that the PIT driven clocksources have. This can
result in large errors in time accumulation for systems that use jiffies
or the pit.

This patch tries to rectify the issue by introducing the
ntp_set_granularity_error() function, which is called when we begin
using a clocksource. This function allows the actual clocksource
granularity error to be taken into consideration by ntp when it
calculates the current_tick_length() function.

Using this method, we should be able to have the system clock drift
match very closely to the actual hardware drift, regardless of the
clocksource granularity or the tick frequency.


UNTESTED! DO NOT MERGE!
Signed-off-by: John Stultz <johnstul@us.ibm.com>
UNTESTED! DO NOT MERGE!

diff --git a/include/linux/timex.h b/include/linux/timex.h
index c3f3747..24fa43b 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -233,17 +233,11 @@ static inline int ntp_synced(void)
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
 
-#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-					(s64)CLOCK_TICK_RATE)
-
-/* Because using NSEC_PER_SEC would be too easy */
-#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC * NSEC_PER_USEC * USER_HZ) + \
-			      CLOCK_TICK_ADJUST) / NTP_INTERVAL_FREQ)
+#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC / NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
-
+extern void ntp_set_granularity_error(s64 len);
 extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index c88b591..fe25c94 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -43,19 +43,32 @@ long time_freq;				/* frequency offset (scaled ppm)*/
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
 
+static s64 granularity_error_adjust;
+
+void ntp_set_granularity_error(s64 len)
+{
+	granularity_error_adjust = len * NTP_INTERVAL_FREQ;
+}
+
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
 				<< TICK_LENGTH_SHIFT;
-	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
-	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
+	s64 adj;
+	
+	/* Compensate for clocksource granularity error */
+	second_length += granularity_error_adjust;
+	
+	/* Scale the base second length by the frequency adjustment */
+	adj = second_length * time_freq;
+	do_div(adj, 1000000);
+	second_length += adj>>SHIFT_NSEC;
 
 	tick_length_base = second_length;
+	do_div(tick_length_base, NTP_INTERVAL_FREQ);
 
 	do_div(second_length, HZ);
 	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
-
-	do_div(tick_length_base, NTP_INTERVAL_FREQ);
 }
 
 /**
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1af9fb0..c91f3ec 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -172,6 +172,7 @@ static void change_clocksource(void)
 	struct clocksource *new;
 	cycle_t now;
 	u64 nsec;
+	s64 adj;
 
 	new = clocksource_get_next();
 
@@ -187,8 +188,15 @@ static void change_clocksource(void)
 
 	clock->error = 0;
 	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+
+	/* Calculate the granularity error */
+	adj = clock->cycle_interval * clock->mult;
+	adj <<= TICK_LENGTH_SHIFT - clock->shift;
+	adj = (NTP_INTERVAL_LENGTH << TICK_LENGTH_SHIFT) - adj;
+	ntp_set_granularity_error(adj);
+
+	ntp_clear();
 
 	tick_clock_notify();
 
@@ -245,8 +253,7 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;



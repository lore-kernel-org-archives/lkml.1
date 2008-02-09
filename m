Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYBICRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYBICRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 21:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYBICRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 21:17:45 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58586 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbYBICRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 21:17:42 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0802081718040.3378@scrub.home>
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
Content-Type: text/plain
Date: Fri, 08 Feb 2008 18:17:32 -0800
Message-Id: <1202523452.6174.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 18:33 +0100, Roman Zippel wrote:
> Hi,
> 
> On Fri, 1 Feb 2008, John Stultz wrote:
> 
> > > CLOCK_TICK_ADJUST is based on LATCH and HZ, if the update frequency isn't 
> > > based on HZ, there is no point in using it!
> > 
> > Hey Roman,
> > 
> > Again, I'm sorry I don't seem to be following your objections. If you
> > want to suggest a different patch to fix the issue, it might help.
> 
> I already gave you the necessary details for how to set 
> NTP_INTERVAL_LENGTH and in the previous mail I explained the basis for it. 

-ENOPATCH

We're taking weeks to critique fairly small bug fix. I'm sure we both
have better things to do then continue to misunderstand each other. I'll
do the testing and will happily ack it if it resolves the issue.

> I really don't understand what's your problem with it. Why do you try to 
> make it more complex than necessary?

Again, I profusely apologize for not understanding your suggestions. I
do appreciate your feedback and I really respect your insistence on
getting this right, but I do not see exactly how your comments connect
to resolving the bug I'm trying to fix.

> > The big issue for me, is that we have to initialize the clocksource
> > cycle interval so it matches the base tick_length that NTP uses.
> > 
> > To be clear, the issue I'm trying to address is only this:
> > Assuming there is no NTP adjustment yet to be made, if we initialize the
> > clocksource interval to X, then compare it with Y when we accumulate, we
> > introduce error if X and Y are not the same.
> > 
> > It really doesn't matter how long the length is, if we're including
> > CLOCK_TICK_ADJUST, or if it really matches the actual HZ tick length or
> > not. The issue is that we have to be consistent. If we're not, then we
> > introduce error that ntpd has to additionally correct for.
> 
> You don't create consistency by adding corrections all over the place 
> until it adds up to the right sum.

Uh, I'd argue that you create consistency by using the same method on
both sides of the equation. That's what I'm trying to do.

Now, If you're disputing that I'm correcting the wrong side of the
equation, then we're getting somewhere. But its still not clear to me
how you're suggesting the other side (which is calculated in
ntp_update_frequency) be changed.

> The current correction is already somewhat of a hack and I'd rather get 
> rid of it than to let it spread all over the place (it's really only 
> needed so that people with weird HZ settings don't hit the 500ppm limit 
> and we're basically cheating to the ntpd by not telling it the real 
> frequency). Please keep the knowledge about this crutch at a single place 
> and don't spread it.
> Anyway, for NO_HZ this correction is completely irrelevant, so again 
> there's no point in adding random values all over the place until you get 
> the correct result.

You keep on bringing up NO_HZ, and again, the bug I'm trying to fix
occurs with or without NO_HZ. The fix I proposed resolves the issue with
or without NO_HZ.

> The only other alternative would be to calculate this correction 
> dynamically. For this you leave NTP_INTERVAL_LENGTH as is and when 
> changing clocks you check whether "abs(((cs->xtime_interval * 
> NTP_INTERVAL_FREQ) >> cs->shift) - NSEC_PER_SEC)" exceeds a certain limit 
> (e.g. 200usec) and in this case you print a warning message, that the 
> clock has large base drift value and is a bad ntp source and apply a 
> correction value. This way the correction only hits the very few system 
> which might need it and it would be the prefered solution, but it also 
> requires a few more changes.

Uh, that seems to be just checking if the xtime_interval is off base, or
if the ntp correction has gone too far. I just don't see how this
connects to the issue at hand.

Just so we're current, I've refined the patch further and included it
below. It now addresses error caused by the intervals of adjusted
clocksource being recalculated on clocksource changes (and thus
including the adjustment in the base interval).

thanks
-john


Fix time skew caused by inconsistent use of NTP_INTERVAL_LENGTH and
current_tick_length(). Patch has three components:
1) Reverts the first version of this patch that made it upstream (while
not perfect, its still avoids the issue for most users).
2) Changes NTP_INTERVAL_LENGTH to be consistent with the calculations
made in ntp_update_frequency().
3) Splits the clocksource mult value into two parts: the original mult
component and the ntp adjusted mult_adj component. This allows us to
correctly recalculate the base xtime_intervals if users switch back and
forth between adjusted clocksources.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 3ab0427..07cacc9 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -357,7 +357,7 @@ void update_vsyscall(struct timespec *wall, struct clocksource *c)
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
-        fsyscall_gtod_data.clk_mult = c->mult;
+        fsyscall_gtod_data.clk_mult = c->mult + c->mult_adj;
         fsyscall_gtod_data.clk_shift = c->shift;
         fsyscall_gtod_data.clk_fsys_mmio = c->fsys_mmio;
         fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3b26fbd..36aa8da 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -814,7 +814,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
-	t2x = (u64) clock->mult * 4611686018ULL;
+	t2x = (u64) (clock->mult + clock->mult_adj) * 4611686018ULL;
 	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
 	do_div(stamp_xsec, 1000000000);
 	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3f82427..14afd48 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -83,7 +83,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
 	vsyscall_gtod_data.clock.mask = clock->mask;
-	vsyscall_gtod_data.clock.mult = clock->mult;
+	vsyscall_gtod_data.clock.mult = clock->mult + clock->mult_adj;
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 85778a4..6719e50 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -63,6 +63,7 @@ struct clocksource {
 	cycle_t (*read)(void);
 	cycle_t mask;
 	u32 mult;
+	s32 mult_adj;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
@@ -179,7 +180,7 @@ static inline cycle_t clocksource_read(struct clocksource *cs)
 static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
 {
 	u64 ret = (u64)cycles;
-	ret = (ret * cs->mult) >> cs->shift;
+	ret = (ret * (cs->mult + cs->mult_adj)) >> cs->shift;
 	return ret;
 }
 
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 8ea3e71..66ae8dd 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -232,7 +232,13 @@ static inline int ntp_synced(void)
 #else
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
-#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
+
+#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
+#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
+					(s64)CLOCK_TICK_RATE)
+
+/* Becaues using NSEC_PER_SEC would be too easy */
+#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC*NSEC_PER_USEC*USER_HZ)+CLOCK_TICK_ADJUST)/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index e64efaf..c88b591 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -43,10 +43,6 @@ long time_freq;				/* frequency offset (scaled ppm)*/
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
 
-#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-					(s64)CLOCK_TICK_RATE)
-
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cd5dbc4..e319ecc 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
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
@@ -426,7 +424,7 @@ static void clocksource_adjust(s64 offset)
 	} else
 		return;
 
-	clock->mult += adj;
+	clock->mult_adj += adj;
 	clock->xtime_interval += interval;
 	clock->xtime_nsec -= offset;
 	clock->error -= (interval - offset) <<








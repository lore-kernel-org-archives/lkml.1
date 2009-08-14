Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZHNNsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZHNNsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbZHNNsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:48:17 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:64196 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373AbZHNNsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:48:10 -0400
Message-Id: <20090814134809.871899606@de.ibm.com>
References: <20090814134717.859098725@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 15:47:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/15] add xtime_shift and ntp_error_shift to struct timekeeper
Content-Disposition: inline; filename=timekeeper-shift.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The xtime_nsec value in the timekeeper structure is shifted by a few
bits to improve precision. This happens to be the same value as the
clock->shift. To improve readability add xtime_shift to the timekeeper
and use it instead of the clock->shift. Likewise add ntp_error_shift
and replace all (NTP_SCALE_SHIFT - clock->shift) expressions.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/time/timekeeping.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -23,6 +23,8 @@
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
 	struct clocksource *clock;
+	/* The shift value of the current clocksource. */
+	int	shift;
 
 	/* Number of clock cycles in one NTP interval. */
 	cycle_t cycle_interval;
@@ -36,6 +38,9 @@ struct timekeeper {
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
 	s64	ntp_error;
+	/* Shift conversion between clock shifted nano seconds and
+	 * ntp shifted nano seconds. */
+	int	ntp_error_shift;
 };
 
 struct timekeeper timekeeper;
@@ -75,8 +80,10 @@ static void timekeeper_setup_internals(s
 		((u64) interval * clock->mult_orig) >> clock->shift;
 
 	timekeeper.xtime_nsec = 0;
+	timekeeper.shift = clock->shift;
 
 	timekeeper.ntp_error = 0;
+	timekeeper.ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
 }
 
 /*
@@ -641,8 +648,7 @@ static __always_inline int timekeeping_b
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >>
-			(NTP_SCALE_SHIFT - timekeeper.clock->shift + 1);
+	tick_error = tick_length >> (timekeeper.ntp_error_shift + 1);
 	tick_error -= timekeeper.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -673,8 +679,7 @@ static void timekeeping_adjust(s64 offse
 	s64 error, interval = timekeeper.cycle_interval;
 	int adj;
 
-	error = timekeeper.ntp_error >>
-		(NTP_SCALE_SHIFT - timekeeper.clock->shift - 1);
+	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
@@ -696,7 +701,7 @@ static void timekeeping_adjust(s64 offse
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
 	timekeeper.ntp_error -= (interval - offset) <<
-			(NTP_SCALE_SHIFT - timekeeper.clock->shift);
+ 				timekeeper.ntp_error_shift;
 }
 
 /**
@@ -708,7 +713,7 @@ void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
-	s64 nsecs;
+	u64 nsecs;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -720,7 +725,7 @@ void update_wall_time(void)
 #else
 	offset = timekeeper.cycle_interval;
 #endif
-	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
+	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
@@ -731,8 +736,9 @@ void update_wall_time(void)
 		clock->cycle_last += timekeeper.cycle_interval;
 
 		timekeeper.xtime_nsec += timekeeper.xtime_interval;
-		if (timekeeper.xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
-			timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
+		nsecs = (u64) NSEC_PER_SEC << timekeeper.shift;
+		if (timekeeper.xtime_nsec >= nsecs) {
+			timekeeper.xtime_nsec -= nsecs;
 			xtime.tv_sec++;
 			second_overflow();
 		}
@@ -746,7 +752,7 @@ void update_wall_time(void)
 		/* accumulate error between NTP and clock interval */
 		timekeeper.ntp_error += tick_length;
 		timekeeper.ntp_error -= timekeeper.xtime_interval <<
-					(NTP_SCALE_SHIFT - clock->shift);
+					timekeeper.ntp_error_shift;
 	}
 
 	/* correct the clock when NTP error is too big */
@@ -771,16 +777,16 @@ void update_wall_time(void)
 	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
 		s64 neg = -(s64)timekeeper.xtime_nsec;
 		timekeeper.xtime_nsec = 0;
-		timekeeper.ntp_error += neg << (NTP_SCALE_SHIFT - clock->shift);
+		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
 	}
 
 	/* store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
-	xtime.tv_nsec = ((s64)timekeeper.xtime_nsec >> clock->shift) + 1;
-	timekeeper.xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
-	timekeeper.ntp_error += timekeeper.xtime_nsec <<
-				(NTP_SCALE_SHIFT - clock->shift);
+	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
+	timekeeper.xtime_nsec -= (s64) xtime.tv_nsec << timekeeper.shift;
+	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
+				timekeeper.ntp_error_shift;
 
 	nsecs = clocksource_cyc2ns(offset, clock->mult, clock->shift);
 	update_xtime_cache(nsecs);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


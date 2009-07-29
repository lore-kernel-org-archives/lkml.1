Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZG2NpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZG2NpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbZG2NpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:45:03 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50106 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbZG2Nmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:42:32 -0400
Message-Id: <20090729134231.269077552@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 09/12] add xtime_shift and ntp_error_shift to struct timekeeper
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
 kernel/time/timekeeping.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -27,6 +27,8 @@ struct timekeeper {
 	u32	raw_interval;
 	u64	xtime_nsec;
 	s64	ntp_error;
+	int	xtime_shift;
+	int	ntp_error_shift;
 };
 
 struct timekeeper timekeeper;
@@ -66,8 +68,10 @@ static void timekeeper_setup_internals(s
 		((u64) interval * clock->mult_orig) >> clock->shift;
 
 	timekeeper.xtime_nsec = 0;
+	timekeeper.xtime_shift = clock->shift;
 
 	timekeeper.ntp_error = 0;
+	timekeeper.ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
 }
 
 /*
@@ -621,8 +625,7 @@ static __always_inline int timekeeping_b
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >>
-			(NTP_SCALE_SHIFT - timekeeper.clock->shift + 1);
+	tick_error = tick_length >> (timekeeper.ntp_error_shift + 1);
 	tick_error -= timekeeper.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -653,8 +656,7 @@ static void timekeeping_adjust(s64 offse
 	s64 error, interval = timekeeper.cycle_interval;
 	int adj;
 
-	error = timekeeper.ntp_error >>
-		(NTP_SCALE_SHIFT - timekeeper.clock->shift - 1);
+	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
@@ -676,7 +678,7 @@ static void timekeeping_adjust(s64 offse
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
 	timekeeper.ntp_error -= (interval - offset) <<
-			(NTP_SCALE_SHIFT - timekeeper.clock->shift);
+ 				timekeeper.ntp_error_shift;
 }
 
 /**
@@ -688,7 +690,7 @@ void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
-	s64 nsecs;
+	u64 nsecs;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -700,7 +702,7 @@ void update_wall_time(void)
 #else
 	offset = timekeeper.cycle_interval;
 #endif
-	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
+	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.xtime_shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
@@ -711,8 +713,9 @@ void update_wall_time(void)
 		clock->cycle_last += timekeeper.cycle_interval;
 
 		timekeeper.xtime_nsec += timekeeper.xtime_interval;
-		if (timekeeper.xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
-			timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
+		nsecs = (u64) NSEC_PER_SEC << timekeeper.xtime_shift;
+		if (timekeeper.xtime_nsec >= nsecs) {
+			timekeeper.xtime_nsec -= nsecs;
 			xtime.tv_sec++;
 			second_overflow();
 		}
@@ -726,7 +729,7 @@ void update_wall_time(void)
 		/* accumulate error between NTP and clock interval */
 		timekeeper.ntp_error += tick_length;
 		timekeeper.ntp_error -= timekeeper.xtime_interval <<
-					(NTP_SCALE_SHIFT - clock->shift);
+					timekeeper.ntp_error_shift;
 	}
 
 	/* correct the clock when NTP error is too big */
@@ -751,16 +754,16 @@ void update_wall_time(void)
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
+	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.xtime_shift) + 1;
+	timekeeper.xtime_nsec -= (s64) xtime.tv_nsec << timekeeper.xtime_shift;
+	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
+				timekeeper.ntp_error_shift;
 
 	nsecs = clocksource_cyc2ns(offset, clock->mult, clock->shift);
 	update_xtime_cache(nsecs);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


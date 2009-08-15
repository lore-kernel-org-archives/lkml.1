Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbZHOJEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbZHOJEK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZHOJEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:04:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:55336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbZHOJEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:04:04 -0400
Date: Sat, 15 Aug 2009 09:03:27 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, dwalker@fifo99.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090814134809.871899606@de.ibm.com>
References: <20090814134809.871899606@de.ibm.com>
Subject: [tip:timers/core] timekeeping: Add xtime_shift and ntp_error_shift to struct timekeeper
Message-ID: <tip-23ce72117c714baab794e66c8daf343bf6a912bf@git.kernel.org>
Git-Commit-ID: 23ce72117c714baab794e66c8daf343bf6a912bf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:03:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23ce72117c714baab794e66c8daf343bf6a912bf
Gitweb:     http://git.kernel.org/tip/23ce72117c714baab794e66c8daf343bf6a912bf
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:27 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:46 +0200

timekeeping: Add xtime_shift and ntp_error_shift to struct timekeeper

The xtime_nsec value in the timekeeper structure is shifted by a few
bits to improve precision. This happens to be the same value as the
clock->shift. To improve readability add xtime_shift to the timekeeper
and use it instead of the clock->shift. Likewise add ntp_error_shift
and replace all (NTP_SCALE_SHIFT - clock->shift) expressions.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134809.871899606@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/time/timekeeping.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7af45cb..dfdab1c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
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
@@ -75,8 +80,10 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 		((u64) interval * clock->mult_orig) >> clock->shift;
 
 	timekeeper.xtime_nsec = 0;
+	timekeeper.shift = clock->shift;
 
 	timekeeper.ntp_error = 0;
+	timekeeper.ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
 }
 
 /*
@@ -641,8 +648,7 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >>
-			(NTP_SCALE_SHIFT - timekeeper.clock->shift + 1);
+	tick_error = tick_length >> (timekeeper.ntp_error_shift + 1);
 	tick_error -= timekeeper.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -673,8 +679,7 @@ static void timekeeping_adjust(s64 offset)
 	s64 error, interval = timekeeper.cycle_interval;
 	int adj;
 
-	error = timekeeper.ntp_error >>
-		(NTP_SCALE_SHIFT - timekeeper.clock->shift - 1);
+	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
@@ -696,7 +701,7 @@ static void timekeeping_adjust(s64 offset)
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
 	timekeeper.ntp_error -= (interval - offset) <<
-			(NTP_SCALE_SHIFT - timekeeper.clock->shift);
+				timekeeper.ntp_error_shift;
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
@@ -720,13 +725,13 @@ void update_wall_time(void)
 #else
 	offset = timekeeper.cycle_interval;
 #endif
-	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
+	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
 	 */
 	while (offset >= timekeeper.cycle_interval) {
-		u64 nsecps = (u64)NSEC_PER_SEC << clock->shift;
+		u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
 
 		/* accumulate one interval */
 		offset -= timekeeper.cycle_interval;
@@ -748,7 +753,7 @@ void update_wall_time(void)
 		/* accumulate error between NTP and clock interval */
 		timekeeper.ntp_error += tick_length;
 		timekeeper.ntp_error -= timekeeper.xtime_interval <<
-					(NTP_SCALE_SHIFT - clock->shift);
+					timekeeper.ntp_error_shift;
 	}
 
 	/* correct the clock when NTP error is too big */
@@ -773,16 +778,16 @@ void update_wall_time(void)
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

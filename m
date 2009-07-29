Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbZG2NnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbZG2NnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZG2NnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:43:24 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:52113 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbZG2NnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:43:21 -0400
Message-Id: <20090729134231.515027738@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:35 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 10/12] move NTP adjusted clock multiplier to struct timekeeper
Content-Disposition: inline; filename=timekeeper-mult.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The clocksource structure has two multipliers, the unmodified multiplier
clock->mult_orig and the NTP corrected multiplier clock->mult. The NTP
multiplier is misplaced in the struct clocksource, this is private
information of the timekeeping code. Add the mult field to the struct
timekeeper to contain the NTP corrected value, keep the unmodifed
multiplier in clock->mult and remove clock->mult_orig. For consistency
add the shift value associated with the NTP corrected mult value to
struct timekeeper as well.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/arm/plat-omap/common.c |    2 +-
 include/linux/clocksource.h |    4 +---
 kernel/time/timekeeping.c   |   43 +++++++++++++++++++++++++------------------
 3 files changed, 27 insertions(+), 22 deletions(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -149,8 +149,7 @@ extern u64 timecounter_cyc2time(struct t
  * @disable:		optional function to disable the clocksource
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters
- * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
- * @mult_orig:		cycle to nanosecond multiplier (unadjusted by NTP)
+ * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
@@ -168,7 +167,6 @@ struct clocksource {
 	void (*disable)(struct clocksource *cs);
 	cycle_t mask;
 	u32 mult;
-	u32 mult_orig;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -29,6 +29,8 @@ struct timekeeper {
 	s64	ntp_error;
 	int	xtime_shift;
 	int	ntp_error_shift;
+	u32	mult;			/* NTP adjusted clock multiplier */
+	u32	shift;			/* NTP adjusted clock shift */
 };
 
 struct timekeeper timekeeper;
@@ -54,8 +56,8 @@ static void timekeeper_setup_internals(s
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
 	tmp <<= clock->shift;
-	tmp += clock->mult_orig/2;
-	do_div(tmp, clock->mult_orig);
+	tmp += clock->mult/2;
+	do_div(tmp, clock->mult);
 	if (tmp == 0)
 		tmp = 1;
 
@@ -65,13 +67,21 @@ static void timekeeper_setup_internals(s
 	/* Go back from cycles -> shifted ns */
 	timekeeper.xtime_interval = (u64) interval * clock->mult;
 	timekeeper.raw_interval =
-		((u64) interval * clock->mult_orig) >> clock->shift;
+		((u64) interval * clock->mult) >> clock->shift;
 
 	timekeeper.xtime_nsec = 0;
 	timekeeper.xtime_shift = clock->shift;
 
 	timekeeper.ntp_error = 0;
 	timekeeper.ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
+
+	/*
+	 * The timekeeper keeps its own mult & shift values for the
+	 * currently active clocksource. These value will be adjusted
+	 * via NTP to counteract clock drifting.
+	 */
+	timekeeper.mult = clock->mult;
+	timekeeper.shift = clock->shift;
 }
 
 /*
@@ -142,14 +152,15 @@ static void timekeeping_forward_now(void
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
-	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+	nsec = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+				  timekeeper.shift);
 
 	/* If arch requires, add in gettimeoffset() */
 	nsec += arch_gettimeoffset();
 
 	timespec_add_ns(&xtime, nsec);
 
-	nsec = clocksource_cyc2ns(cycle_delta, clock->mult_orig, clock->shift);
+	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 	timespec_add_ns(&raw_time, nsec);
 }
 
@@ -181,8 +192,8 @@ void getnstimeofday(struct timespec *ts)
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
-					   clock->shift);
+		nsecs = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+					   timekeeper.shift);
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -216,8 +227,8 @@ ktime_t ktime_get(void)
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs += clocksource_cyc2ns(cycle_delta, clock->mult,
-					    clock->shift);
+		nsecs += clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+					    timekeeper.shift);
 
 	} while (read_seqretry(&xtime_lock, seq));
 	/*
@@ -259,8 +270,8 @@ void ktime_get_ts(struct timespec *ts)
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
-					   clock->shift);
+		nsecs = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+					   timekeeper.shift);
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -344,8 +355,6 @@ static void change_clocksource(void)
 
 	if (new->enable && ! new->enable(new))
 		return;
-	/* save mult_orig on enable */
-	new->mult_orig = new->mult;
 
 	old = timekeeper.clock;
 	timekeeper_setup_internals(new);
@@ -438,7 +447,7 @@ void getrawmonotonic(struct timespec *ts
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult_orig,
+		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
 					   clock->shift);
 
 		*ts = raw_time;
@@ -498,8 +507,6 @@ void __init timekeeping_init(void)
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
-	/* save mult_orig on enable */
-	clock->mult_orig = clock->mult;
 
 	timekeeper_setup_internals(clock);
 
@@ -674,7 +681,7 @@ static void timekeeping_adjust(s64 offse
 	} else
 		return;
 
-	timekeeper.clock->mult += adj;
+	timekeeper.mult += adj;
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
 	timekeeper.ntp_error -= (interval - offset) <<
@@ -765,7 +772,7 @@ void update_wall_time(void)
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
-	nsecs = clocksource_cyc2ns(offset, clock->mult, clock->shift);
+	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
 	update_xtime_cache(nsecs);
 
 	/* check to see if there is a new clocksource to use */
Index: linux-2.6/arch/arm/plat-omap/common.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/common.c
+++ linux-2.6/arch/arm/plat-omap/common.c
@@ -256,7 +256,7 @@ unsigned long long sched_clock(void)
 	unsigned long long ret;
 
 	ret = (unsigned long long)clocksource_32k.read(&clocksource_32k);
-	ret = (ret * clocksource_32k.mult_orig) >> clocksource_32k.shift;
+	ret = (ret * clocksource_32k.mult) >> clocksource_32k.shift;
 	return ret;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


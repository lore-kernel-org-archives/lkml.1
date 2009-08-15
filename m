Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZHOJEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZHOJEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZHOJE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:04:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:55356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZHOJEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:04:23 -0400
Date: Sat, 15 Aug 2009 09:03:40 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, dwalker@fifo99.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090814134810.149047645@de.ibm.com>
References: <20090814134810.149047645@de.ibm.com>
Subject: [tip:timers/core] timekeeping: Move NTP adjusted clock multiplier to struct timekeeper
Message-ID: <tip-0a54419836254a27baecd9037103171bcbabaf67@git.kernel.org>
Git-Commit-ID: 0a54419836254a27baecd9037103171bcbabaf67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:03:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a54419836254a27baecd9037103171bcbabaf67
Gitweb:     http://git.kernel.org/tip/0a54419836254a27baecd9037103171bcbabaf67
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:28 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:46 +0200

timekeeping: Move NTP adjusted clock multiplier to struct timekeeper

The clocksource structure has two multipliers, the unmodified multiplier
clock->mult_orig and the NTP corrected multiplier clock->mult. The NTP
multiplier is misplaced in the struct clocksource, this is private
information of the timekeeping code. Add the mult field to the struct
timekeeper to contain the NTP corrected value, keep the unmodifed
multiplier in clock->mult and remove clock->mult_orig.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134810.149047645@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/arm/plat-omap/common.c |    7 +----
 include/linux/clocksource.h |    4 +--
 kernel/time/timekeeping.c   |   53 +++++++++++++++++++-----------------------
 3 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index ebcf006..95587b6 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -253,11 +253,8 @@ static struct clocksource clocksource_32k = {
  */
 unsigned long long sched_clock(void)
 {
-	unsigned long long ret;
-
-	ret = (unsigned long long)clocksource_32k.read(&clocksource_32k);
-	ret = (ret * clocksource_32k.mult_orig) >> clocksource_32k.shift;
-	return ret;
+	return clocksource_cyc2ns(clocksource_32k.read(&clocksource_32k),
+				  clocksource_32k.mult, clocksource_32k.shift);
 }
 
 static int __init omap_init_clocksource_32k(void)
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index e12e309..e34015e 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -149,8 +149,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
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
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index dfdab1c..f4056f6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -41,6 +41,8 @@ struct timekeeper {
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
 	int	ntp_error_shift;
+	/* NTP adjusted clock multiplier */
+	u32	mult;
 };
 
 struct timekeeper timekeeper;
@@ -66,8 +68,8 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
 	tmp <<= clock->shift;
-	tmp += clock->mult_orig/2;
-	do_div(tmp, clock->mult_orig);
+	tmp += clock->mult/2;
+	do_div(tmp, clock->mult);
 	if (tmp == 0)
 		tmp = 1;
 
@@ -77,13 +79,20 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 	/* Go back from cycles -> shifted ns */
 	timekeeper.xtime_interval = (u64) interval * clock->mult;
 	timekeeper.raw_interval =
-		((u64) interval * clock->mult_orig) >> clock->shift;
+		((u64) interval * clock->mult) >> clock->shift;
 
 	timekeeper.xtime_nsec = 0;
 	timekeeper.shift = clock->shift;
 
 	timekeeper.ntp_error = 0;
 	timekeeper.ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
+
+	/*
+	 * The timekeeper keeps its own mult values for the currently
+	 * active clocksource. These value will be adjusted via NTP
+	 * to counteract clock drifting.
+	 */
+	timekeeper.mult = clock->mult;
 }
 
 /*
@@ -154,14 +163,15 @@ static void timekeeping_forward_now(void)
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
 
@@ -193,8 +203,8 @@ void getnstimeofday(struct timespec *ts)
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
-					   clock->shift);
+		nsecs = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+					   timekeeper.shift);
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -228,8 +238,8 @@ ktime_t ktime_get(void)
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs += clocksource_cyc2ns(cycle_delta, clock->mult,
-					    clock->shift);
+		nsecs += clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+					    timekeeper.shift);
 
 	} while (read_seqretry(&xtime_lock, seq));
 	/*
@@ -271,8 +281,8 @@ void ktime_get_ts(struct timespec *ts)
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
-					   clock->shift);
+		nsecs = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+					   timekeeper.shift);
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -356,22 +366,10 @@ static void change_clocksource(void)
 
 	if (new->enable && !new->enable(new))
 		return;
-	/*
-	 * The frequency may have changed while the clocksource
-	 * was disabled. If so the code in ->enable() must update
-	 * the mult value to reflect the new frequency. Make sure
-	 * mult_orig follows this change.
-	 */
-	new->mult_orig = new->mult;
 
 	old = timekeeper.clock;
 	timekeeper_setup_internals(new);
 
-	/*
-	 * Save mult_orig in mult so that the value can be restored
-	 * regardless if ->enable() updates the value of mult or not.
-	 */
-	old->mult = old->mult_orig;
 	if (old->disable)
 		old->disable(old);
 
@@ -461,7 +459,7 @@ void getrawmonotonic(struct timespec *ts)
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult_orig,
+		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
 					   clock->shift);
 
 		*ts = raw_time;
@@ -521,9 +519,6 @@ void __init timekeeping_init(void)
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
-	/* set mult_orig on enable */
-	clock->mult_orig = clock->mult;
-
 	timekeeper_setup_internals(clock);
 
 	xtime.tv_sec = sec;
@@ -697,7 +692,7 @@ static void timekeeping_adjust(s64 offset)
 	} else
 		return;
 
-	timekeeper.clock->mult += adj;
+	timekeeper.mult += adj;
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
 	timekeeper.ntp_error -= (interval - offset) <<
@@ -789,7 +784,7 @@ void update_wall_time(void)
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
-	nsecs = clocksource_cyc2ns(offset, clock->mult, clock->shift);
+	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
 	update_xtime_cache(nsecs);
 
 	/* check to see if there is a new clocksource to use */

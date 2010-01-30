Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653Ab0A3AQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0A3AQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 19:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764Ab0A3AQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 19:16:51 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58671 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0A3AQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 19:16:50 -0500
Subject: [RFC][PATCH] time: remove xtime_cache (take 2)
From: john stultz <johnstul@us.ibm.com>
To: Petr =?UTF-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 16:16:40 -0800
Message-ID: <1264810600.3469.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Petr,
	So I wanted to take another swing at the xtime_cache removal, and
wanted to see if you could give it a test to make sure the invalid atime
issue was resolved.

No urgent rush, but if you have a chance, it would be great if you'd try
this patch on  2.6.33-rc5+ kernel. Let me know if you still see the
issue from before.

thanks
-john



With the earlier logarithmic time accumulation patch, xtime will now
always be within one "tick" of the current time, instead of possibly
half a second off.

This removes the need for the xtime_cache value, which always stored the
time at the last interrupt, so this patch cleans that up removing the
xtime_cache related code.

This patch also addresses an issue with an earlier version of this change,
where xtime_cache was normalizing xtime, which could in some cases be
not valid (ie: tv_nsec == NSEC_PER_SEC). This is fixed by handling
the edge case in update_wall_time().

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 include/linux/time.h      |    1 -
 kernel/time.c             |    1 -
 kernel/time/timekeeping.c |   35 ++++++++++++++++-------------------
 3 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 6e026e4..ea3559f 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -150,7 +150,6 @@ extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern void update_wall_time(void);
-extern void update_xtime_cache(u64 nsec);
 extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
diff --git a/kernel/time.c b/kernel/time.c
index 8047980..c6324d9 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -136,7 +136,6 @@ static inline void warp_clock(void)
 	write_seqlock_irq(&xtime_lock);
 	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
 	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
-	update_xtime_cache(0);
 	write_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7faaa32..ff188ca 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -165,13 +165,6 @@ struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
-static struct timespec xtime_cache __attribute__ ((aligned (16)));
-void update_xtime_cache(u64 nsec)
-{
-	xtime_cache = xtime;
-	timespec_add_ns(&xtime_cache, nsec);
-}
-
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
@@ -332,8 +325,6 @@ int do_settimeofday(struct timespec *tv)
 
 	xtime = *tv;
 
-	update_xtime_cache(0);
-
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
@@ -559,7 +550,6 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
-	update_xtime_cache(0);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -593,7 +583,6 @@ static int timekeeping_resume(struct sys_device *dev)
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
 		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
 	}
-	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
@@ -787,7 +776,6 @@ void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
-	u64 nsecs;
 	int shift = 0, maxshift;
 
 	/* Make sure we're fully resumed: */
@@ -845,7 +833,9 @@ void update_wall_time(void)
 		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
 	}
 
-	/* store full nanoseconds into xtime after rounding it up and
+
+	/*
+	 * Store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
 	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
@@ -853,8 +843,15 @@ void update_wall_time(void)
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
-	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
-	update_xtime_cache(nsecs);
+	/*
+	 * Finally, make sure that after the rounding 
+	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
+	 */
+	if (unlikely(xtime.tv_nsec >= NSEC_PER_SEC)) {
+		xtime.tv_nsec -= NSEC_PER_SEC;
+		xtime.tv_sec++;
+		second_overflow();
+	}
 
 	/* check to see if there is a new clocksource to use */
 	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
@@ -892,13 +889,13 @@ void monotonic_to_bootbased(struct timespec *ts)
 
 unsigned long get_seconds(void)
 {
-	return xtime_cache.tv_sec;
+	return xtime.tv_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return xtime_cache;
+	return xtime;
 }
 
 struct timespec current_kernel_time(void)
@@ -909,7 +906,7 @@ struct timespec current_kernel_time(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		now = xtime_cache;
+		now = xtime;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	return now;
@@ -924,7 +921,7 @@ struct timespec get_monotonic_coarse(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		now = xtime_cache;
+		now = xtime;
 		mono = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
-- 
1.6.0.4




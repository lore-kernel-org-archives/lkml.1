Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbZHOJCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbZHOJCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZHOJCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:02:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:55176 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZHOJCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:02:17 -0400
Date: Sat, 15 Aug 2009 09:01:40 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dwalker@fifo99.com, hpa@zytor.com,
       mingo@redhat.com, johnstul@us.ibm.com, schwidefsky@de.ibm.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dwalker@fifo99.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20090814134807.903108946@de.ibm.com>
References: <20090814134807.903108946@de.ibm.com>
Subject: [tip:timers/core] timekeeping: Remove clocksource inline functions
Message-ID: <tip-a0f7d48bfb95a4c5172a2756dbc4b82afc8e9ae4@git.kernel.org>
Git-Commit-ID: a0f7d48bfb95a4c5172a2756dbc4b82afc8e9ae4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:01:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0f7d48bfb95a4c5172a2756dbc4b82afc8e9ae4
Gitweb:     http://git.kernel.org/tip/a0f7d48bfb95a4c5172a2756dbc4b82afc8e9ae4
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:19 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:45 +0200

timekeeping: Remove clocksource inline functions

The three inline functions clocksource_read, clocksource_enable and
clocksource_disable are simple wrappers of an indirect call plus the
copy from and to the mult_orig value. The functions are exclusively
used by the timekeeping code which has intimate knowledge of the
clocksource anyway. Therefore remove the inline functions. No
functional change.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134807.903108946@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/linux/clocksource.h |   58 -------------------------------------------
 kernel/time/timekeeping.c   |   41 ++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 71 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 1219be4..a1ef46f 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -268,64 +268,6 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
 }
 
 /**
- * clocksource_read: - Access the clocksource's current cycle value
- * @cs:		pointer to clocksource being read
- *
- * Uses the clocksource to return the current cycle_t value
- */
-static inline cycle_t clocksource_read(struct clocksource *cs)
-{
-	return cs->read(cs);
-}
-
-/**
- * clocksource_enable: - enable clocksource
- * @cs:		pointer to clocksource
- *
- * Enables the specified clocksource. The clocksource callback
- * function should start up the hardware and setup mult and field
- * members of struct clocksource to reflect hardware capabilities.
- */
-static inline int clocksource_enable(struct clocksource *cs)
-{
-	int ret = 0;
-
-	if (cs->enable)
-		ret = cs->enable(cs);
-
-	/*
-	 * The frequency may have changed while the clocksource
-	 * was disabled. If so the code in ->enable() must update
-	 * the mult value to reflect the new frequency. Make sure
-	 * mult_orig follows this change.
-	 */
-	cs->mult_orig = cs->mult;
-
-	return ret;
-}
-
-/**
- * clocksource_disable: - disable clocksource
- * @cs:		pointer to clocksource
- *
- * Disables the specified clocksource. The clocksource callback
- * function should power down the now unused hardware block to
- * save power.
- */
-static inline void clocksource_disable(struct clocksource *cs)
-{
-	/*
-	 * Save mult_orig in mult so clocksource_enable() can
-	 * restore the value regardless if ->enable() updates
-	 * the value of mult or not.
-	 */
-	cs->mult = cs->mult_orig;
-
-	if (cs->disable)
-		cs->disable(cs);
-}
-
-/**
  * cyc2ns - converts clocksource cycles to nanoseconds
  * @cs:		Pointer to clocksource
  * @cycles:	Cycles
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b8b70fb..016a259 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -79,7 +79,7 @@ static void clocksource_forward_now(void)
 	cycle_t cycle_now, cycle_delta;
 	s64 nsec;
 
-	cycle_now = clocksource_read(clock);
+	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
@@ -114,7 +114,7 @@ void getnstimeofday(struct timespec *ts)
 		*ts = xtime;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -146,7 +146,7 @@ ktime_t ktime_get(void)
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -186,7 +186,7 @@ void ktime_get_ts(struct timespec *ts)
 		tomono = wall_to_monotonic;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -274,16 +274,29 @@ static void change_clocksource(void)
 
 	clocksource_forward_now();
 
-	if (clocksource_enable(new))
+	if (new->enable && !new->enable(new))
 		return;
+	/*
+	 * The frequency may have changed while the clocksource
+	 * was disabled. If so the code in ->enable() must update
+	 * the mult value to reflect the new frequency. Make sure
+	 * mult_orig follows this change.
+	 */
+	new->mult_orig = new->mult;
 
 	new->raw_time = clock->raw_time;
 	old = clock;
 	clock = new;
-	clocksource_disable(old);
+	/*
+	 * Save mult_orig in mult so that the value can be restored
+	 * regardless if ->enable() updates the value of mult or not.
+	 */
+	old->mult = old->mult_orig;
+	if (old->disable)
+		old->disable(old);
 
 	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
@@ -373,7 +386,7 @@ void getrawmonotonic(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -435,9 +448,12 @@ void __init timekeeping_init(void)
 	ntp_init();
 
 	clock = clocksource_get_next();
-	clocksource_enable(clock);
+	if (clock->enable)
+		clock->enable(clock);
+	/* set mult_orig on enable */
+	clock->mult_orig = clock->mult;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
@@ -477,8 +493,7 @@ static int timekeeping_resume(struct sys_device *dev)
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -630,7 +645,7 @@ void update_wall_time(void)
 		return;
 
 #ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #else
 	offset = clock->cycle_interval;
 #endif

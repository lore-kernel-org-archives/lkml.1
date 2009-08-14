Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbZHNNtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbZHNNtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZHNNts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:49:48 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:49464 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830AbZHNNtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:49:46 -0400
Message-Id: <20090814134810.435105711@de.ibm.com>
References: <20090814134717.859098725@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 15:47:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/15] timekeeper read clock helper functions
Content-Disposition: inline; filename=timekeeper-helper.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add timekeeper_read_clock_ntp and timekeeper_read_clock_raw and use
them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/time/timekeeping.c |   91 +++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 53 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -95,6 +95,40 @@ static void timekeeper_setup_internals(s
 	timekeeper.mult = clock->mult;
 }
 
+/* Timekeeper helper functions. */
+static inline s64 timekeeping_get_ns(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
+
+	/* read clocksource: */
+	clock = timekeeper.clock;
+	cycle_now = clock->read(clock);
+
+	/* calculate the delta since the last update_wall_time: */
+	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+	/* return delta convert to nanoseconds using ntp adjusted mult. */
+	return clocksource_cyc2ns(cycle_delta, timekeeper.mult,
+				  timekeeper.shift);
+}
+
+static inline s64 timekeeping_get_ns_raw(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
+
+	/* read clocksource: */
+	clock = timekeeper.clock;
+	cycle_now = clock->read(clock);
+
+	/* calculate the delta since the last update_wall_time: */
+	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+	/* return delta convert to nanoseconds using ntp adjusted mult. */
+	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+}
+
 /*
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime.
@@ -183,8 +217,6 @@ static void timekeeping_forward_now(void
  */
 void getnstimeofday(struct timespec *ts)
 {
-	cycle_t cycle_now, cycle_delta;
-	struct clocksource *clock;
 	unsigned long seq;
 	s64 nsecs;
 
@@ -194,17 +226,7 @@ void getnstimeofday(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 
 		*ts = xtime;
-
-		/* read clocksource: */
-		clock = timekeeper.clock;
-		cycle_now = clock->read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
-					   timekeeper.shift);
+		nsecs = timekeeping_get_ns();
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -218,8 +240,6 @@ EXPORT_SYMBOL(getnstimeofday);
 
 ktime_t ktime_get(void)
 {
-	cycle_t cycle_now, cycle_delta;
-	struct clocksource *clock;
 	unsigned int seq;
 	s64 secs, nsecs;
 
@@ -229,17 +249,7 @@ ktime_t ktime_get(void)
 		seq = read_seqbegin(&xtime_lock);
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
-
-		/* read clocksource: */
-		clock = timekeeper.clock;
-		cycle_now = clock->read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs += clocksource_cyc2ns(cycle_delta, timekeeper.mult,
-					    timekeeper.shift);
+		nsecs += timekeeping_get_ns();
 
 	} while (read_seqretry(&xtime_lock, seq));
 	/*
@@ -260,8 +270,6 @@ EXPORT_SYMBOL_GPL(ktime_get);
  */
 void ktime_get_ts(struct timespec *ts)
 {
-	cycle_t cycle_now, cycle_delta;
-	struct clocksource *clock;
 	struct timespec tomono;
 	unsigned int seq;
 	s64 nsecs;
@@ -272,17 +280,7 @@ void ktime_get_ts(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 		*ts = xtime;
 		tomono = wall_to_monotonic;
-
-		/* read clocksource: */
-		clock = timekeeper.clock;
-		cycle_now = clock->read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
-					   timekeeper.shift);
+		nsecs = timekeeping_get_ns();
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -445,23 +443,10 @@ void getrawmonotonic(struct timespec *ts
 {
 	unsigned long seq;
 	s64 nsecs;
-	cycle_t cycle_now, cycle_delta;
-	struct clocksource *clock;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-
-		/* read clocksource: */
-		clock = timekeeper.clock;
-		cycle_now = clock->read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = clocksource_cyc2ns(cycle_delta, clock->mult,
-					   clock->shift);
-
+		nsecs = timekeeping_get_ns_raw();
 		*ts = raw_time;
 
 	} while (read_seqretry(&xtime_lock, seq));

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


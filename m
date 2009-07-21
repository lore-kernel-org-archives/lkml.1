Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZGUTVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZGUTVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZGUTVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:21:49 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:59404 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbZGUTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:21:12 -0400
Message-Id: <20090721192100.489213669@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 21 Jul 2009 21:17:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 4/5] clocksource_read/clocksource_read_raw inline functions
Content-Disposition: inline; filename=clocksource-read-ns.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add clocksource_read / clocksource_read_raw inline functions and use
them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clocksource.h |   45 +++++++++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c   |   46 +++-----------------------------------------
 2 files changed, 49 insertions(+), 42 deletions(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -284,6 +284,51 @@ static inline s64 cyc2ns(struct clocksou
 	return ret;
 }
 
+/**
+ * clocksource_read: - Read nanosecond delta from clocksource.
+ * @cs:		pointer to clocksource being read
+ *
+ * Read from the clock source and return the clock value converted
+ * to nanoseconds.
+ */
+static inline s64 clocksource_read(struct clocksource *cs)
+{
+	cycle_t cycle_now, cycle_delta;
+
+	/* read clocksource: */
+	cycle_now = cs->read(cs);
+
+	/* calculate the delta since the last update_wall_time: */
+	cycle_delta = (cycle_now - cs->cycle_last) & cs->mask;
+
+	/* convert to nanoseconds: */
+	return cyc2ns(cs, cycle_delta);
+}
+
+/**
+ * clocksource_read_raw: - Read raw nanosecond delta from clocksource.
+ * @cs:		pointer to clocksource being read
+ *
+ * Read from the clock source and return the clock value converted
+ * to nanoseconds.
+ */
+static inline s64 clocksource_read_raw(struct clocksource *cs,
+				       struct timespec *ts)
+{
+	cycle_t cycle_now, cycle_delta;
+
+	*ts = clock->raw_time;
+
+	/* read clocksource: */
+	cycle_now = cs->read(cs);
+
+	/* calculate the delta since the last update_wall_time: */
+	cycle_delta = (cycle_now - cs->cycle_last) & cs->mask;
+
+	/* convert to nanoseconds: */
+	return ((s64) cycle_delta * clock->mult_orig) >> clock->shift;
+}
+
 /* used to install a new clocksource */
 extern void __init clocksource_init(void);
 extern int clocksource_register(struct clocksource*);
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -66,7 +66,6 @@ void update_xtime_cache(u64 nsec)
  */
 void getnstimeofday(struct timespec *ts)
 {
-	cycle_t cycle_now, cycle_delta;
 	unsigned long seq;
 	s64 nsecs;
 
@@ -76,15 +75,7 @@ void getnstimeofday(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 
 		*ts = xtime;
-
-		/* read clocksource: */
-		cycle_now = clock->read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = cyc2ns(clock, cycle_delta);
+		nsecs = clocksource_read(clock);
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -98,7 +89,6 @@ EXPORT_SYMBOL(getnstimeofday);
 
 ktime_t ktime_get(void)
 {
-	cycle_t cycle_now, cycle_delta;
 	unsigned int seq;
 	s64 secs, nsecs;
 
@@ -108,15 +98,7 @@ ktime_t ktime_get(void)
 		seq = read_seqbegin(&xtime_lock);
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
-
-		/* read clocksource: */
-		cycle_now = clock->read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs += cyc2ns(clock, cycle_delta);
+		nsecs += clocksource_read(clock);
 
 	} while (read_seqretry(&xtime_lock, seq));
 	/*
@@ -137,7 +119,6 @@ EXPORT_SYMBOL_GPL(ktime_get);
  */
 void ktime_get_ts(struct timespec *ts)
 {
-	cycle_t cycle_now, cycle_delta;
 	struct timespec tomono;
 	unsigned int seq;
 	s64 nsecs;
@@ -148,15 +129,7 @@ void ktime_get_ts(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 		*ts = xtime;
 		tomono = wall_to_monotonic;
-
-		/* read clocksource: */
-		cycle_now = clock->read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = cyc2ns(clock, cycle_delta);
+		nsecs = clocksource_read(clock);
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -290,21 +263,10 @@ void getrawmonotonic(struct timespec *ts
 {
 	unsigned long seq;
 	s64 nsecs;
-	cycle_t cycle_now, cycle_delta;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-
-		/* read clocksource: */
-		cycle_now = clock->read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
-
-		*ts = clock->raw_time;
+		nsecs = clocksource_read_raw(clock, ts);
 
 	} while (read_seqretry(&xtime_lock, seq));
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbZHOJEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbZHOJEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZHOJEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:04:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:55349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbZHOJER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:04:17 -0400
Date: Sat, 15 Aug 2009 09:03:52 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, dwalker@fifo99.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090814134810.435105711@de.ibm.com>
References: <20090814134810.435105711@de.ibm.com>
Subject: [tip:timers/core] timekeeping: Add timekeeper read_clock helper functions
Message-ID: <tip-2ba2a3054fdffc8e6452f4ee120760322a6fbd43@git.kernel.org>
Git-Commit-ID: 2ba2a3054fdffc8e6452f4ee120760322a6fbd43
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:03:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ba2a3054fdffc8e6452f4ee120760322a6fbd43
Gitweb:     http://git.kernel.org/tip/2ba2a3054fdffc8e6452f4ee120760322a6fbd43
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:29 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:46 +0200

timekeeping: Add timekeeper read_clock helper functions

Add timekeeper_read_clock_ntp and timekeeper_read_clock_raw and use
them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134810.435105711@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/time/timekeeping.c |   91 +++++++++++++++++++--------------------------
 1 files changed, 38 insertions(+), 53 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f4056f6..27ae01b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -95,6 +95,40 @@ static void timekeeper_setup_internals(struct clocksource *clock)
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
@@ -183,8 +217,6 @@ static void timekeeping_forward_now(void)
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
 
@@ -445,23 +443,10 @@ void getrawmonotonic(struct timespec *ts)
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

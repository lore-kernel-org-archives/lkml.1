Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbZG2Nnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbZG2Nnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbZG2Nnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:43:50 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:60299 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbZG2Nnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:43:46 -0400
Message-Id: <20090729134229.529582732@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 02/12] remove clocksource inline functions
Content-Disposition: inline; filename=clocksource-inline.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Remove clocksource_read, clocksource_enable and clocksource_disable
inline functions. No functional change.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clocksource.h |   46 --------------------------------------------
 kernel/time/timekeeping.c   |   32 +++++++++++++++++-------------
 2 files changed, 18 insertions(+), 60 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -79,7 +79,7 @@ static void clocksource_forward_now(void
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
@@ -274,16 +274,18 @@ static void change_clocksource(void)
 
 	clocksource_forward_now();
 
-	if (clocksource_enable(new))
+	if (new->enable && ! new->enable(new))
 		return;
+	/* save mult_orig on enable */
+	new->mult_orig = new->mult;
 
 	new->raw_time = clock->raw_time;
 	old = clock;
 	clock = new;
-	clocksource_disable(old);
+	if (old->disable)
+		old->disable(old);
 
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
@@ -373,7 +375,7 @@ void getrawmonotonic(struct timespec *ts
 		seq = read_seqbegin(&xtime_lock);
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -435,9 +437,12 @@ void __init timekeeping_init(void)
 	ntp_init();
 
 	clock = clocksource_get_next();
-	clocksource_enable(clock);
+	if (clock->enable)
+		clock->enable(clock);
+	/* save mult_orig on enable */
+	clock->mult_orig = clock->mult;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
@@ -477,8 +482,7 @@ static int timekeeping_resume(struct sys
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -630,7 +634,7 @@ void update_wall_time(void)
 		return;
 
 #ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #else
 	offset = clock->cycle_interval;
 #endif
Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -268,52 +268,6 @@ static inline u32 clocksource_hz2mult(u3
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
-	/* save mult_orig on enable */
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
-	if (cs->disable)
-		cs->disable(cs);
-}
-
-/**
  * cyc2ns - converts clocksource cycles to nanoseconds
  * @cs:		Pointer to clocksource
  * @cycles:	Cycles

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


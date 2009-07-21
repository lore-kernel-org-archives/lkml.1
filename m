Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZGUTVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZGUTVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZGUTVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:21:51 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:60481 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZGUTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:21:12 -0400
Message-Id: <20090721192059.454927873@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 21 Jul 2009 21:17:48 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 3/5] remove clocksource inline functions
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
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/time/clocksource.c |   18 ++++++++++++------
 kernel/time/timekeeping.c |   13 ++++++-------
 2 files changed, 18 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -517,7 +517,7 @@ void clocksource_forward_now(void)
 	cycle_t cycle_now, cycle_delta;
 	s64 nsec;
 
-	cycle_now = clocksource_read(clock);
+	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
@@ -567,16 +567,19 @@ void change_clocksource(void)
 
 	clocksource_forward_now();
 
-	if (clocksource_enable(new))
+	if (new->enable && !new->enable(new))
 		return;
 
+	/* save mult_orig after successful enable */
+	new->mult_orig = new->mult;
+
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
@@ -655,7 +658,10 @@ void clocksource_unregister(struct clock
 void __init clocksource_init(void)
 {
 	clock = clocksource_get_next();
-	clocksource_enable(clock);
+	if (clock->enable)
+		clock->enable(clock);
+	/* save mult_orig on enable */
+	clock->mult_orig = clock->mult;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clock->read(clock);
 }
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -78,7 +78,7 @@ void getnstimeofday(struct timespec *ts)
 		*ts = xtime;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -110,7 +110,7 @@ ktime_t ktime_get(void)
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -150,7 +150,7 @@ void ktime_get_ts(struct timespec *ts)
 		tomono = wall_to_monotonic;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -296,7 +296,7 @@ void getrawmonotonic(struct timespec *ts
 		seq = read_seqbegin(&xtime_lock);
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -396,8 +396,7 @@ static int timekeeping_resume(struct sys
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -464,7 +463,7 @@ void update_wall_time(void)
 		return;
 
 #ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #else
 	offset = clock->cycle_interval;
 #endif

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


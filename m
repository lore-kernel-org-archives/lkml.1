Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZEBTIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZEBTIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbZEBTIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:08:10 -0400
Received: from www.tglx.de ([62.245.132.106]:33807 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbZEBTIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:08:07 -0400
Message-Id: <20090502190545.410632127@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 19:06:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 1/3] timers: use function instead of macro for calc_load
References: <20090502190500.513452861@linutronix.de>
Content-Disposition: inline;
	filename=calc-load-use-function-instead-of-macro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the CALC_LOAD macro by a static function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    5 -----
 kernel/timer.c        |   29 ++++++++++++++---------------
 2 files changed, 14 insertions(+), 20 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -124,11 +124,6 @@ extern unsigned long avenrun[];		/* Load
 #define EXP_5		2014		/* 1/exp(5sec/5min) */
 #define EXP_15		2037		/* 1/exp(5sec/15min) */
 
-#define CALC_LOAD(load,exp,n) \
-	load *= exp; \
-	load += n*(FIXED_1-exp); \
-	load >>= FSHIFT;
-
 extern unsigned long total_forks;
 extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1123,14 +1123,6 @@ void update_process_times(int user_tick)
 }
 
 /*
- * Nr of active tasks - counted in fixed-point numbers
- */
-static unsigned long count_active_tasks(void)
-{
-	return nr_active() * FIXED_1;
-}
-
-/*
  * Hmm.. Changed this, as the GNU make sources (load.c) seems to
  * imply that avenrun[] is the standard name for this kind of thing.
  * Nothing else seems to be standardized: the fractional size etc
@@ -1139,25 +1131,32 @@ static unsigned long count_active_tasks(
  * Requires xtime_lock to access.
  */
 unsigned long avenrun[3];
-
 EXPORT_SYMBOL(avenrun);
 
+static unsigned long
+calc_load(unsigned long load, unsigned long exp, unsigned long active)
+{
+	load *= exp;
+	load += active * (FIXED_1 - exp);
+	return load >> FSHIFT;
+}
+
 /*
  * calc_load - given tick count, update the avenrun load estimates.
  * This is called while holding a write_lock on xtime_lock.
  */
-static inline void calc_load(unsigned long ticks)
+static void calc_global_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
 	static int count = LOAD_FREQ;
 
 	count -= ticks;
 	if (unlikely(count < 0)) {
-		active_tasks = count_active_tasks();
+		active_tasks = nr_active() * FIXED_1;
 		do {
-			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
-			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
-			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
+			avenrun[0] = calc_load(avenrun[0], EXP_1, active_tasks);
+			avenrun[1] = calc_load(avenrun[1], EXP_5, active_tasks);
+			avenrun[2] = calc_load(avenrun[2], EXP_15, active_tasks);
 			count += LOAD_FREQ;
 		} while (count < 0);
 	}
@@ -1193,7 +1192,7 @@ void run_local_timers(void)
 static inline void update_times(unsigned long ticks)
 {
 	update_wall_time();
-	calc_load(ticks);
+	calc_global_load(ticks);
 }
 
 /*



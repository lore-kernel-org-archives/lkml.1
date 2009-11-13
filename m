Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbZKMTuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbZKMTuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbZKMTuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:50:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:36051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbZKMTuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:50:16 -0500
Date: Fri, 13 Nov 2009 19:50:03 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, jon-hunter@ti.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, jon-hunter@ti.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] nohz: Track last do_timer() cpu
Message-ID: <tip-27185016b806d5a1181ff501cae120582b2b27dd@git.kernel.org>
Git-Commit-ID: 27185016b806d5a1181ff501cae120582b2b27dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27185016b806d5a1181ff501cae120582b2b27dd
Gitweb:     http://git.kernel.org/tip/27185016b806d5a1181ff501cae120582b2b27dd
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 12 Nov 2009 22:12:06 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 13 Nov 2009 20:46:24 +0100

nohz: Track last do_timer() cpu

The previous patch which limits the sleep time to the maximum
deferment time of the time keeping clocksource has some limitations on
SMP machines: if all CPUs are idle then for all CPUs the maximum sleep
time is limited.

Solve this by keeping track of which cpu had the do_timer() duty
assigned last and limit the sleep time only for this cpu.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: Jon Hunter <jon-hunter@ti.com>
Cc: John Stultz <johnstul@us.ibm.com>
---
 include/linux/tick.h     |    2 +
 kernel/time/tick-sched.c |   52 ++++++++++++++++++++++++---------------------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 8dc0821..d2ae79e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -43,6 +43,7 @@ enum tick_nohz_mode {
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
  * @sleep_length:	Duration of the current idle sleep
+ * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
 struct tick_sched {
 	struct hrtimer			sched_timer;
@@ -64,6 +65,7 @@ struct tick_sched {
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
+	int				do_timer_last;
 };
 
 extern void __init tick_init(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a80b464..df133bc 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -263,17 +263,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		seq = read_seqbegin(&xtime_lock);
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
-
-		/*
-		 * On SMP we really should only care for the CPU which
-		 * has the do_timer duty assigned. All other CPUs can
-		 * sleep as long as they want.
-		 */
-		if (cpu == tick_do_timer_cpu ||
-		    tick_do_timer_cpu == TICK_DO_TIMER_NONE)
-			time_delta = timekeeping_max_deferment();
-		else
-			time_delta = KTIME_MAX;
+		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
@@ -296,6 +286,29 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if ((long)delta_jiffies >= 1) {
 
 		/*
+		 * If this cpu is the one which updates jiffies, then
+		 * give up the assignment and let it be taken by the
+		 * cpu which runs the tick timer next, which might be
+		 * this cpu as well. If we don't drop this here the
+		 * jiffies might be stale and do_timer() never
+		 * invoked. Keep track of the fact that it was the one
+		 * which had the do_timer() duty last. If this cpu is
+		 * the one which had the do_timer() duty last, we
+		 * limit the sleep time to the timekeeping
+		 * max_deferement value which we retrieved
+		 * above. Otherwise we can sleep as long as we want.
+		 */
+		if (cpu == tick_do_timer_cpu) {
+			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+			ts->do_timer_last = 1;
+		} else if (tick_do_timer_cpu != TICK_DO_TIMER_NONE) {
+			time_delta = KTIME_MAX;
+			ts->do_timer_last = 0;
+		} else if (!ts->do_timer_last) {
+			time_delta = KTIME_MAX;
+		}
+
+		/*
 		 * calculate the expiry time for the next timer wheel
 		 * timer. delta_jiffies >= NEXT_TIMER_MAX_DELTA signals
 		 * that there is no timer pending or at least extremely
@@ -312,21 +325,12 @@ void tick_nohz_stop_sched_tick(int inidle)
 			 */
 			time_delta = min_t(u64, time_delta,
 					   tick_period.tv64 * delta_jiffies);
-			expires = ktime_add_ns(last_update, time_delta);
-		} else {
-			expires.tv64 = KTIME_MAX;
 		}
 
-		/*
-		 * If this cpu is the one which updates jiffies, then
-		 * give up the assignment and let it be taken by the
-		 * cpu which runs the tick timer next, which might be
-		 * this cpu as well. If we don't drop this here the
-		 * jiffies might be stale and do_timer() never
-		 * invoked.
-		 */
-		if (cpu == tick_do_timer_cpu)
-			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+		if (time_delta < KTIME_MAX)
+			expires = ktime_add_ns(last_update, time_delta);
+		else
+			expires.tv64 = KTIME_MAX;
 
 		if (delta_jiffies > 1)
 			cpumask_set_cpu(cpu, nohz_cpu_mask);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZIXLjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZIXLjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZIXLja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:39:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZIXLj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:39:29 -0400
Date: Thu, 24 Sep 2009 13:39:38 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, mingo@elte.hu,
       peterz@infradead.org, tglx@tglx.de
Subject: [RFC PATCH] timer: provide microaccounting for iowait in addition
 to idle time
Message-ID: <20090924133938.6d71db13@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f511560312467628f37578d3dd70d63849eb8c8a Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 24 Sep 2009 13:35:48 +0200
Subject: [PATCH] timer: provide microaccounting for iowait in addition to idle time

Today, the kernel has microaccounting for the CPU idle time, as used by
cpufreq governors and other places.

For a cpufreq governor I'm working on I would also like to get access
to microaccounting of iowait time.

This patch adds the iowait micro-accounting to the existing microaccounting
code. In addition, I've improved the accuracy of the data by updating
the totals at the time of asking for the total, rather than just reporting
the total at the last schedule point.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/tick.h     |    4 +++
 kernel/time/tick-sched.c |   55 ++++++++++++++++++++++++++++++++++++++++++---
 kernel/time/timer_list.c |    1 +
 3 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0482229..322b3fd 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -42,6 +42,7 @@ enum tick_nohz_mode {
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
+ * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
  */
 struct tick_sched {
@@ -59,6 +60,7 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
+	ktime_t				iowait_sleeptime;
 	ktime_t				idle_lastupdate;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
@@ -119,6 +121,7 @@ extern void tick_nohz_stop_sched_tick(int inidle);
 extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
+extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -129,6 +132,7 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 	return len;
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
+static inline u64 get_cpu_iowait(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
 #endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e0f59a2..0699af0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -165,6 +165,9 @@ static void tick_nohz_stop_idle(int cpu)
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_lastupdate = now;
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		if (nr_iowait_cpu()>0)
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+
 		ts->idle_active = 0;
 
 		sched_clock_idle_wakeup_event(0);
@@ -180,6 +183,8 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_lastupdate = now;
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		if (nr_iowait_cpu()>0)
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 	}
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
@@ -190,19 +195,61 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, delta;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	if (ts->idle_active)
-		*last_update_time = ktime_to_us(ts->idle_lastupdate);
-	else
-		*last_update_time = ktime_to_us(ktime_get());
+	now = ktime_get();
+	if (ts->idle_active) {
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_lastupdate = now;
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		if (nr_iowait_cpu()>0)
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+		ts->idle_entrytime = now;
+	}
+
+	if (last_update_time) {
+		if (ts->idle_active)
+			*last_update_time = ktime_to_us(ts->idle_lastupdate);
+		else
+			*last_update_time = ktime_to_us(ktime_get());
+	}
 
 	return ktime_to_us(ts->idle_sleeptime);
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
+u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, delta;
+
+	if (!tick_nohz_enabled)
+		return -1;
+
+	now = ktime_get();
+	if (ts->idle_active) {
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_lastupdate = now;
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		if (nr_iowait_cpu()>0)
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+		ts->idle_entrytime = now;
+	}
+
+	if (last_update_time) {
+		if (ts->idle_active)
+			*last_update_time = ktime_to_us(ts->idle_lastupdate);
+		else
+			*last_update_time = ktime_to_us(ktime_get());
+	}
+
+	return ktime_to_us(ts->iowait_sleeptime);
+}
+EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
+
 /**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index fddd69d..3965f20 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -173,6 +173,7 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P_ns(idle_waketime);
 		P_ns(idle_exittime);
 		P_ns(idle_sleeptime);
+		P_ns(iowait_sleeptime);
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

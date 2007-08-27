Return-Path: <linux-kernel-owner+w=401wt.eu-S1765299AbXH0V6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765299AbXH0V6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765622AbXH0V4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:56:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:16082 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765103AbXH0V4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:56:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,313,1183359600"; 
   d="scan'208";a="268666393"
Date: Mon, 27 Aug 2007 14:56:11 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Message-ID: <20070827215611.GA30396@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Current idle time in kstat is based on jiffies and is coarse grained.
tick_sched.idle_sleeptime is making some attempt to keep track of
idle time in a fine grained manner. But, it is not handling
the time spent in interrupts fully.

Make tick_sched.idle_sleeptime accurate with respect to time spent on
handling interrupts and also add tick_sched.idle_lastupdate, which
keeps track of last time when idle_sleeptime was updated.

This statistics will be crucial for cpufreq-ondemand governor, which can shed
some conservative gaurd band that is uses today while setting the frequency.
The ondemand changes that uses the exact idle time is coming soon. 

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.22.orig/kernel/time/tick-sched.c
+++ linux-2.6.22/kernel/time/tick-sched.c
@@ -141,6 +141,43 @@ void tick_nohz_update_jiffies(void)
 	local_irq_restore(flags);
 }
 
+void tick_nohz_stop_idle(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (ts->idle_active) {
+		ktime_t now, delta;
+		now = ktime_get();
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_lastupdate = now;
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		ts->idle_active = 0;
+	}
+}
+
+static void tick_nohz_start_idle(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, delta;
+
+	now = ktime_get();
+	if (ts->idle_active) {
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_lastupdate = now;
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	}
+	ts->idle_entrytime = now;
+	ts->idle_active = 1;
+}
+
+u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	*last_update_time = ktime_to_us(ts->idle_lastupdate);
+	return ktime_to_us(ts->idle_sleeptime);
+}
+
 /**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
@@ -152,13 +189,15 @@ void tick_nohz_stop_sched_tick(void)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
 	struct tick_sched *ts;
-	ktime_t last_update, expires, now, delta;
+	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	int cpu;
 
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
+	tick_nohz_start_idle(cpu);
+
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
@@ -178,19 +217,7 @@ void tick_nohz_stop_sched_tick(void)
 		}
 	}
 
-	now = ktime_get();
-	/*
-	 * When called from irq_exit we need to account the idle sleep time
-	 * correctly.
-	 */
-	if (ts->tick_stopped) {
-		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-	}
-
-	ts->idle_entrytime = now;
 	ts->idle_calls++;
-
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
 		seq = read_seqbegin(&xtime_lock);
@@ -320,23 +347,22 @@ void tick_nohz_restart_sched_tick(void)
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long ticks;
-	ktime_t now, delta;
+	ktime_t now;
+
+	local_irq_disable();
+	tick_nohz_stop_idle(cpu);
 
-	if (!ts->tick_stopped)
+	if (!ts->tick_stopped) {
+		local_irq_enable();
 		return;
+	}
 
 	/* Update jiffies first */
-	now = ktime_get();
-
-	local_irq_disable();
 	select_nohz_load_balancer(0);
+	now = ktime_get();
 	tick_do_update_jiffies64(now);
 	cpu_clear(cpu, nohz_cpu_mask);
 
-	/* Account the idle time */
-	delta = ktime_sub(now, ts->idle_entrytime);
-	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
 	 * time we slept as update_process_times does only a 1 tick
Index: linux-2.6.22/include/linux/tick.h
===================================================================
--- linux-2.6.22.orig/include/linux/tick.h
+++ linux-2.6.22/include/linux/tick.h
@@ -51,8 +51,10 @@ struct tick_sched {
 	unsigned long			idle_jiffies;
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
+	int				idle_active;
 	ktime_t				idle_entrytime;
 	ktime_t				idle_sleeptime;
+	ktime_t				idle_lastupdate;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
@@ -103,6 +105,8 @@ extern void tick_nohz_stop_sched_tick(vo
 extern void tick_nohz_restart_sched_tick(void);
 extern void tick_nohz_update_jiffies(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
+extern void tick_nohz_stop_idle(int cpu);
+extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_stop_sched_tick(void) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -113,6 +117,8 @@ static inline ktime_t tick_nohz_get_slee
 
 	return len;
 }
+static inline void tick_nohz_stop_idle(int cpu) { }
+static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return 0; }
 # endif /* !NO_HZ */
 
 #endif
Index: linux-2.6.22/kernel/softirq.c
===================================================================
--- linux-2.6.22.orig/kernel/softirq.c
+++ linux-2.6.22/kernel/softirq.c
@@ -280,9 +280,14 @@ EXPORT_SYMBOL(do_softirq);
  */
 void irq_enter(void)
 {
+#ifdef CONFIG_NO_HZ
+	int cpu = smp_processor_id();
+	if (idle_cpu(cpu) && !in_interrupt())
+		tick_nohz_stop_idle(cpu);
+#endif
 	__irq_enter();
 #ifdef CONFIG_NO_HZ
-	if (idle_cpu(smp_processor_id()))
+	if (idle_cpu(cpu))
 		tick_nohz_update_jiffies();
 #endif
 }

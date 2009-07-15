Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZGOP2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZGOP2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZGOP2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:28:54 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:52470 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbZGOP2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:28:54 -0400
Date: Wed, 15 Jul 2009 17:28:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: [RFC][PATCH] reuse ktime in sub-functions of tick_check_idle.
Message-ID: <20090715172851.21d618f3@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

On a system with NOHZ=y tick_check_idle calls tick_nohz_stop_idle and
tick_nohz_update_jiffies. Given the right conditions (ts->idle_active
and/or ts->tick_stopped) both function get a time stamp with ktime_get.
The same time stamp can be reused if both function require one.

On s390 this change has the additional benefit that gcc inlines the
tick_nohz_stop_idle function into tick_check_idle. The number of
instructions to execute tick_check_idle drops from 225 to 144
(without the ktime_get optimization it is 367 vs 215 instructions).

before:

 0)               |  tick_check_idle() {
 0)               |    tick_nohz_stop_idle() {
 0)               |      ktime_get() {
 0)               |        read_tod_clock() {
 0)   0.601 us    |        }
 0)   1.765 us    |      }
 0)   3.047 us    |    }
 0)               |    ktime_get() {
 0)               |      read_tod_clock() {
 0)   0.570 us    |      }
 0)   1.727 us    |    }
 0)               |    tick_do_update_jiffies64() {
 0)   0.609 us    |    }
 0)   8.055 us    |  }

after:

 0)               |  tick_check_idle() {
 0)               |    ktime_get() {
 0)               |      read_tod_clock() {
 0)   0.617 us    |      }
 0)   1.773 us    |    }
 0)               |    tick_do_update_jiffies64() {
 0)   0.593 us    |    }
 0)   4.477 us    |  }

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 kernel/time/tick-sched.c |   56 ++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

Index: git-linux-2.6/kernel/time/tick-sched.c
===================================================================
--- git-linux-2.6.orig/kernel/time/tick-sched.c
+++ git-linux-2.6/kernel/time/tick-sched.c
@@ -134,18 +134,13 @@ __setup("nohz=", setup_tick_nohz);
  * value. We do this unconditionally on any cpu, as we don't know whether the
  * cpu, which has the update task assigned is in a long sleep.
  */
-static void tick_nohz_update_jiffies(void)
+static void tick_nohz_update_jiffies(ktime_t now)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long flags;
-	ktime_t now;
-
-	if (!ts->tick_stopped)
-		return;
 
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
-	now = ktime_get();
 	ts->idle_waketime = now;
 
 	local_irq_save(flags);
@@ -155,20 +150,17 @@ static void tick_nohz_update_jiffies(voi
 	touch_softlockup_watchdog();
 }
 
-static void tick_nohz_stop_idle(int cpu)
+static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t delta;
 
-	if (ts->idle_active) {
-		ktime_t now, delta;
-		now = ktime_get();
-		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_lastupdate = now;
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		ts->idle_active = 0;
+	delta = ktime_sub(now, ts->idle_entrytime);
+	ts->idle_lastupdate = now;
+	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	ts->idle_active = 0;
 
-		sched_clock_idle_wakeup_event(0);
-	}
+	sched_clock_idle_wakeup_event(0);
 }
 
 static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
@@ -431,7 +423,11 @@ void tick_nohz_restart_sched_tick(void)
 	ktime_t now;
 
 	local_irq_disable();
-	tick_nohz_stop_idle(cpu);
+	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
+		now = ktime_get();
+
+	if (ts->idle_active)
+		tick_nohz_stop_idle(cpu, now);
 
 	if (!ts->inidle || !ts->tick_stopped) {
 		ts->inidle = 0;
@@ -445,7 +441,6 @@ void tick_nohz_restart_sched_tick(void)
 
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
-	now = ktime_get();
 	tick_do_update_jiffies64(now);
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
@@ -579,22 +574,18 @@ static void tick_nohz_switch_to_nohz(voi
  * timer and do not touch the other magic bits which need to be done
  * when idle is left.
  */
-static void tick_nohz_kick_tick(int cpu)
+static void tick_nohz_kick_tick(int cpu, ktime_t now)
 {
 #if 0
 	/* Switch back to 2.6.27 behaviour */
 
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t delta, now;
-
-	if (!ts->tick_stopped)
-		return;
+	ktime_t delta;
 
 	/*
 	 * Do not touch the tick device, when the next expiry is either
 	 * already reached or less/equal than the tick period.
 	 */
-	now = ktime_get();
 	delta =	ktime_sub(hrtimer_get_expires(&ts->sched_timer), now);
 	if (delta.tv64 <= tick_period.tv64)
 		return;
@@ -614,11 +605,22 @@ static inline void tick_nohz_switch_to_n
  */
 void tick_check_idle(int cpu)
 {
+#ifdef CONFIG_NO_HZ
+	struct tick_sched *ts;
+#endif
+
 	tick_check_oneshot_broadcast(cpu);
 #ifdef CONFIG_NO_HZ
-	tick_nohz_stop_idle(cpu);
-	tick_nohz_update_jiffies();
-	tick_nohz_kick_tick(cpu);
+	ts = &per_cpu(tick_cpu_sched, cpu);
+	if (ts->idle_active || ts->tick_stopped) {
+		ktime_t now = ktime_get();
+		if (ts->idle_active)
+			tick_nohz_stop_idle(cpu, now);
+		if (ts->tick_stopped) {
+			tick_nohz_update_jiffies(now);
+			tick_nohz_kick_tick(cpu, now);
+		}
+	}
 #endif
 }
 

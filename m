Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbZKEG6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbZKEG6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbZKEG6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:58:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:60804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144AbZKEG6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:58:04 -0500
Date: Thu, 5 Nov 2009 06:57:41 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20090929122533.206589318@de.ibm.com>
References: <20090929122533.206589318@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] nohz: Reuse ktime in sub-functions of tick_check_idle.
Message-ID: <tip-eed3b9cf3fe3fcc7a50238dfcab63a63914e8f42@git.kernel.org>
Git-Commit-ID: eed3b9cf3fe3fcc7a50238dfcab63a63914e8f42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eed3b9cf3fe3fcc7a50238dfcab63a63914e8f42
Gitweb:     http://git.kernel.org/tip/eed3b9cf3fe3fcc7a50238dfcab63a63914e8f42
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Tue, 29 Sep 2009 14:25:15 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 5 Nov 2009 07:53:53 +0100

nohz: Reuse ktime in sub-functions of tick_check_idle.

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

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: john stultz <johnstul@us.ibm.com>
LKML-Reference: <20090929122533.206589318@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |   62 ++++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e0f59a2..7378e2c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
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
@@ -155,20 +150,17 @@ static void tick_nohz_update_jiffies(void)
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
 
@@ -579,22 +574,18 @@ static void tick_nohz_switch_to_nohz(void)
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
@@ -603,9 +594,26 @@ static void tick_nohz_kick_tick(int cpu)
 #endif
 }
 
+static inline void tick_check_nohz(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now;
+
+	if (!ts->idle_active && !ts->tick_stopped)
+		return;
+	now = ktime_get();
+	if (ts->idle_active)
+		tick_nohz_stop_idle(cpu, now);
+	if (ts->tick_stopped) {
+		tick_nohz_update_jiffies(now);
+		tick_nohz_kick_tick(cpu, now);
+	}
+}
+
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
+static inline void tick_check_nohz(int cpu) { }
 
 #endif /* NO_HZ */
 
@@ -615,11 +623,7 @@ static inline void tick_nohz_switch_to_nohz(void) { }
 void tick_check_idle(int cpu)
 {
 	tick_check_oneshot_broadcast(cpu);
-#ifdef CONFIG_NO_HZ
-	tick_nohz_stop_idle(cpu);
-	tick_nohz_update_jiffies();
-	tick_nohz_kick_tick(cpu);
-#endif
+	tick_check_nohz(cpu);
 }
 
 /*

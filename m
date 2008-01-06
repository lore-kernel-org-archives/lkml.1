Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYAFQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYAFQZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbYAFQXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:23:22 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:5387 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbYAFQXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:23:15 -0500
X-SourceIP: 80.56.237.116
Message-Id: <20080106162123.084811000@chello.nl>
References: <20080106161128.152634000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 06 Jan 2008 17:11:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/11] hrtimer: clean up cpu->base locking tricks
Content-Disposition: inline; filename=hrtimer-unlocked-callback.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to more easily allow for the scheduler to use timers, clean up
the locking a bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c         |  109 +++++++++++++++++++++++++++++++++++++++++++----
 kernel/time/tick-sched.c |    8 ---
 2 files changed, 102 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1063,7 +1063,9 @@ void hrtimer_interrupt(struct clock_even
 		basenow = ktime_add(now, base->offset);
 
 		while ((node = base->first)) {
+			enum hrtimer_restart (*fn)(struct hrtimer *);
 			struct hrtimer *timer;
+			int restart;
 
 			timer = rb_entry(node, struct hrtimer, node);
 
@@ -1091,13 +1093,29 @@ void hrtimer_interrupt(struct clock_even
 					 HRTIMER_STATE_CALLBACK, 0);
 			timer_stats_account_hrtimer(timer);
 
+			fn = timer->function;
+			if (timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ) {
+				/*
+				 * Used for scheduler timers, avoid lock
+				 * inversion with rq->lock and tasklist_lock.
+				 *
+				 * These timers are required to deal with
+				 * enqueue expiry themselves and are not
+				 * allowed to migrate.
+				 */
+				spin_unlock(&cpu_base->lock);
+				restart = fn(timer);
+				spin_lock(&cpu_base->lock);
+			} else
+				restart = fn(timer);
+
 			/*
 			 * Note: We clear the CALLBACK bit after
 			 * enqueue_hrtimer to avoid reprogramming of
 			 * the event hardware. This happens at the end
 			 * of this function anyway.
 			 */
-			if (timer->function(timer) != HRTIMER_NORESTART) {
+			if (restart != HRTIMER_NORESTART) {
 				BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 				enqueue_hrtimer(timer, base, 0);
 			}
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -514,7 +514,6 @@ static enum hrtimer_restart tick_sched_t
 {
 	struct tick_sched *ts =
 		container_of(timer, struct tick_sched, sched_timer);
-	struct hrtimer_cpu_base *base = timer->base->cpu_base;
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 	int cpu = smp_processor_id();
@@ -552,15 +551,8 @@ static enum hrtimer_restart tick_sched_t
 			touch_softlockup_watchdog();
 			ts->idle_jiffies++;
 		}
-		/*
-		 * update_process_times() might take tasklist_lock, hence
-		 * drop the base lock. sched-tick hrtimers are per-CPU and
-		 * never accessible by userspace APIs, so this is safe to do.
-		 */
-		spin_unlock(&base->lock);
 		update_process_times(user_mode(regs));
 		profile_tick(CPU_PROFILING);
-		spin_lock(&base->lock);
 	}
 
 	/* Do not restart, when we are in the idle loop */

--


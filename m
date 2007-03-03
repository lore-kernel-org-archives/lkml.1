Return-Path: <linux-kernel-owner+w=401wt.eu-S2992920AbXCCCwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992920AbXCCCwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 21:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992922AbXCCCwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 21:52:40 -0500
Received: from mail.queued.net ([207.210.101.209]:1844 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992920AbXCCCwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 21:52:39 -0500
Message-ID: <45E8E2F8.1030102@debian.org>
Date: Fri, 02 Mar 2007 21:52:40 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Marcelo Tosatti <marcelo@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] dynticks: don't unlock spinlock twice
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------000600050007040205020408"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000600050007040205020408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

During boot with dynticks enabled, we would sometimes get:

[   35.271900] Switched to high resolution mode on CPU 0
[   35.304468] BUG: spinlock already unlocked on CPU#0, swapper/1
[   35.338099]  lock: c06428a0, .magic: dead4ead, .owner: <none>/-1,
.owner_cpu:
 -1
[   35.373597]  [<c04d7cf0>] _raw_spin_unlock+0x28/0x67
[   35.406647]  [<c05ba279>] _spin_unlock+0x5/0x23
[   35.439369]  [<c04255f7>] tick_sched_timer+0x4e/0xa7
[   35.472388]  [<c04255a9>] tick_sched_timer+0x0/0xa7
[   35.504833]  [<c0422528>] hrtimer_run_queues+0x199/0x1ec
[   35.537617]  [<c0416b72>] run_timer_softirq+0x12/0x166
[   35.570019]  [<c04144d9>] __do_softirq+0x40/0x85

[   35.601542]  [<c0405494>] do_softirq+0x53/0xa9
...

This appears to be caused by run_hrtimer_queue() (called by
hrtimer_run_queues) calling spin_unlock_irq(&cpu_base->lock) before
calling timer->function(timer).  The callback function
(tick_sched_timer) expects cpu_base->lock to be held when it is called,
and attempts to unlock it.  Since it doesn't seem like anything within
tick_sched_timer really needs to hold the lock (afaict), the attached
patch simply removes the lock handling from tick_sched_timer.  Things
called by tick_sched_timer may grab the base->lock, but that's fine (and
their responsibility).  Let me know if there's some reason why the lock
should be held, and I can rework this.

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------000600050007040205020408
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 51556b9..b43bccb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -422,13 +422,12 @@ static inline void tick_nohz_switch_to_nohz(void) { }
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
  * We rearm the timer until we get disabled by the idle code
- * Called with interrupts disabled and timer->base->cpu_base->lock held.
+ * Called with interrupts disabled and timer->base->cpu_base->lock *not* held.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 {
 	struct tick_sched *ts =
 		container_of(timer, struct tick_sched, sched_timer);
-	struct hrtimer_cpu_base *base = timer->base->cpu_base;
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 
@@ -454,13 +453,12 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		}
 		/*
 		 * update_process_times() might take tasklist_lock, hence
-		 * drop the base lock. sched-tick hrtimers are per-CPU and
-		 * never accessible by userspace APIs, so this is safe to do.
+		 * we don't attempt to grab the base lock here.
+		 * sched-tick hrtimers are per-CPU and never accessible by
+		 * userspace APIs, so this is safe to do.
 		 */
-		spin_unlock(&base->lock);
 		update_process_times(user_mode(regs));
 		profile_tick(CPU_PROFILING);
-		spin_lock(&base->lock);
 	}
 
 	/* Do not restart, when we are in the idle loop */

--------------000600050007040205020408--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZA3XHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZA3XHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZA3XHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:07:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33242 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbZA3XHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:07:33 -0500
Date: Sat, 31 Jan 2009 00:07:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] timer fixes
Message-ID: <20090130230724.GA31001@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Special mention for this commit:

      hrtimers: increase clock min delta threshold while interrupt hanging

We found it useful in the case where a very slow (or very emulated) system 
is overwhelmed with HZ irqs - we get a kernel message and some throttling, 
instead of a hard lockup in essence. If that kind of approach is not 
acceptable we can remove this patch and resend the other fixes.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      hrtimers: increase clock min delta threshold while interrupt hanging

Sebastien Dugue (1):
      hrtimers: allow the hot-unplugging of all cpus

Thomas Gleixner (1):
      hrtimer: prevent negative expiry value after clock_was_set()


 include/linux/clockchips.h |    1 +
 kernel/hrtimer.c           |   41 ++++++++++++++++++++++++++++++++++++++++-
 kernel/time/tick-common.c  |   26 +++++++++++++++++++-------
 3 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index cea1536..3a1dbba 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -36,6 +36,7 @@ enum clock_event_nofitiers {
 	CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
 	CLOCK_EVT_NOTIFY_SUSPEND,
 	CLOCK_EVT_NOTIFY_RESUME,
+	CLOCK_EVT_NOTIFY_CPU_DYING,
 	CLOCK_EVT_NOTIFY_CPU_DEAD,
 };
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f33afb0..f394d2a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -501,6 +501,13 @@ static void hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base)
 			continue;
 		timer = rb_entry(base->first, struct hrtimer, node);
 		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		/*
+		 * clock_was_set() has changed base->offset so the
+		 * result might be negative. Fix it up to prevent a
+		 * false positive in clockevents_program_event()
+		 */
+		if (expires.tv64 < 0)
+			expires.tv64 = 0;
 		if (expires.tv64 < cpu_base->expires_next.tv64)
 			cpu_base->expires_next = expires;
 	}
@@ -1158,6 +1165,29 @@ static void __run_hrtimer(struct hrtimer *timer)
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 
+static int force_clock_reprogram;
+
+/*
+ * After 5 iteration's attempts, we consider that hrtimer_interrupt()
+ * is hanging, which could happen with something that slows the interrupt
+ * such as the tracing. Then we force the clock reprogramming for each future
+ * hrtimer interrupts to avoid infinite loops and use the min_delta_ns
+ * threshold that we will overwrite.
+ * The next tick event will be scheduled to 3 times we currently spend on
+ * hrtimer_interrupt(). This gives a good compromise, the cpus will spend
+ * 1/4 of their time to process the hrtimer interrupts. This is enough to
+ * let it running without serious starvation.
+ */
+
+static inline void
+hrtimer_interrupt_hanging(struct clock_event_device *dev,
+			ktime_t try_time)
+{
+	force_clock_reprogram = 1;
+	dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
+	printk(KERN_WARNING "hrtimer: interrupt too slow, "
+		"forcing clock min delta to %lu ns\n", dev->min_delta_ns);
+}
 /*
  * High resolution timer interrupt
  * Called with interrupts disabled
@@ -1167,6 +1197,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	ktime_t expires_next, now;
+	int nr_retries = 0;
 	int i;
 
 	BUG_ON(!cpu_base->hres_active);
@@ -1174,6 +1205,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	dev->next_event.tv64 = KTIME_MAX;
 
  retry:
+	/* 5 retries is enough to notice a hang */
+	if (!(++nr_retries % 5))
+		hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now));
+
 	now = ktime_get();
 
 	expires_next.tv64 = KTIME_MAX;
@@ -1226,7 +1261,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 
 	/* Reprogramming necessary ? */
 	if (expires_next.tv64 != KTIME_MAX) {
-		if (tick_program_event(expires_next, 0))
+		if (tick_program_event(expires_next, force_clock_reprogram))
 			goto retry;
 	}
 }
@@ -1580,6 +1615,10 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, &scpu);
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 	{
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 63e05d4..21a5ca8 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -274,6 +274,21 @@ out_bc:
 }
 
 /*
+ * Transfer the do_timer job away from a dying cpu.
+ *
+ * Called with interrupts disabled.
+ */
+static void tick_handover_do_timer(int *cpup)
+{
+	if (*cpup == tick_do_timer_cpu) {
+		int cpu = cpumask_first(cpu_online_mask);
+
+		tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu :
+			TICK_DO_TIMER_NONE;
+	}
+}
+
+/*
  * Shutdown an event device on a given cpu:
  *
  * This is called on a life CPU, when a CPU is dead. So we cannot
@@ -297,13 +312,6 @@ static void tick_shutdown(unsigned int *cpup)
 		clockevents_exchange_device(dev, NULL);
 		td->evtdev = NULL;
 	}
-	/* Transfer the do_timer job away from this cpu */
-	if (*cpup == tick_do_timer_cpu) {
-		int cpu = cpumask_first(cpu_online_mask);
-
-		tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu :
-			TICK_DO_TIMER_NONE;
-	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
@@ -357,6 +365,10 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
 		tick_broadcast_oneshot_control(reason);
 		break;
 
+	case CLOCK_EVT_NOTIFY_CPU_DYING:
+		tick_handover_do_timer(dev);
+		break;
+
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
 		tick_shutdown_broadcast_oneshot(dev);
 		tick_shutdown_broadcast(dev);

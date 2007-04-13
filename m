Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXDMTE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXDMTE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbXDMTE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:04:59 -0400
Received: from www.osadl.org ([213.239.205.134]:42238 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754145AbXDMTE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:04:58 -0400
Subject: [PATCH] highres/dyntick: prevent xtime lock contention
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>
Content-Type: text/plain
Date: Fri, 13 Apr 2007 21:05:57 +0200
Message-Id: <1176491157.3387.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While the !highres/!dyntick code assigns the duty of the do_timer() call
to one specific CPU, this was dropped in the highres/dyntick part during
development.

Steven Rostedt discovered the xtime lock contention on highres/dyntick
due to several CPUs trying to update jiffies.

Add the single CPU assignement back. In the dyntick case this needs to
be handled carefully, as the CPU which has the do_timer() duty must drop
the assignement and let it be grabbed by another CPU, which is active.
Otherwise the do_timer() calls would not happen during the long sleep.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index bfda3f7..a96ec9a 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -31,7 +31,7 @@ DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
-static int tick_do_timer_cpu = -1;
+int tick_do_timer_cpu __read_mostly = -1;
 DEFINE_SPINLOCK(tick_device_lock);
 
 /*
@@ -295,6 +295,12 @@ static void tick_shutdown(unsigned int *cpup)
 		clockevents_exchange_device(dev, NULL);
 		td->evtdev = NULL;
 	}
+	/* Transfer the do_timer job away from this cpu */
+	if (*cpup == tick_do_timer_cpu) {
+		int cpu = first_cpu(cpu_online_map);
+
+		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu : -1;
+	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index c9d203b..5645e6a 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -5,6 +5,7 @@ DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern spinlock_t tick_device_lock;
 extern ktime_t tick_next_period;
 extern ktime_t tick_period;
+extern int tick_do_timer_cpu __read_mostly;
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 51556b9..3a8e524 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -221,6 +221,18 @@ void tick_nohz_stop_sched_tick(void)
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
 		}
+
+		/*
+		 * If this cpu is the one which updates jiffies, then
+		 * give up the assignment and let it be taken by the
+		 * cpu which runs the tick timer next, which might be
+		 * this cpu as well. If we don't drop this here the
+		 * jiffies might be stale and do_timer() never
+		 * invoked.
+		 */
+		if (cpu == tick_do_timer_cpu)
+			tick_do_timer_cpu = -1;
+
 		/*
 		 * calculate the expiry time for the next timer wheel
 		 * timer
@@ -338,12 +350,24 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
+	int cpu = smp_processor_id();
 	ktime_t now = ktime_get();
 
 	dev->next_event.tv64 = KTIME_MAX;
 
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == -1))
+		tick_do_timer_cpu = cpu;
+
 	/* Check, if the jiffies need an update */
-	tick_do_update_jiffies64(now);
+	if (tick_do_timer_cpu == cpu)
+		tick_do_update_jiffies64(now);
 
 	/*
 	 * When we are idle and the tick is stopped, we have to touch
@@ -431,9 +455,23 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	struct hrtimer_cpu_base *base = timer->base->cpu_base;
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
+	int cpu = smp_processor_id();
+
+#ifdef CONFIG_NO_HZ
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == -1))
+		tick_do_timer_cpu = cpu;
+#endif
 
 	/* Check, if the jiffies need an update */
-	tick_do_update_jiffies64(now);
+	if (tick_do_timer_cpu == cpu)
+		tick_do_update_jiffies64(now);
 
 	/*
 	 * Do not call, when we are not in irq context and have



Return-Path: <linux-kernel-owner+w=401wt.eu-S934806AbXEUTjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806AbXEUTjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765578AbXEUTWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:22:43 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35560 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765572AbXEUTWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:22:41 -0400
Message-Id: <20070521191723.247392000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       rostedt@goodmis.org, mlord@pobox.com, tglx@linutronix.de, mingo@elte.hu
Subject: [patch 28/69] highres/dyntick: prevent xtime lock contention
Content-Disposition: inline; filename=highres-dyntick-prevent-xtime-lock-contention.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

While the !highres/!dyntick code assigns the duty of the do_timer() call to
one specific CPU, this was dropped in the highres/dyntick part during
development.

Steven Rostedt discovered the xtime lock contention on highres/dyntick due
to several CPUs trying to update jiffies.

Add the single CPU assignement back.  In the dyntick case this needs to be
handled carefully, as the CPU which has the do_timer() duty must drop the
assignement and let it be grabbed by another CPU, which is active. 
Otherwise the do_timer() calls would not happen during the long sleep.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 kernel/time/tick-common.c   |    8 +++++++-
 kernel/time/tick-internal.h |    1 +
 kernel/time/tick-sched.c    |   42 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 48 insertions(+), 3 deletions(-)

--- linux-2.6.21.1.orig/kernel/time/tick-common.c
+++ linux-2.6.21.1/kernel/time/tick-common.c
@@ -31,7 +31,7 @@ DEFINE_PER_CPU(struct tick_device, tick_
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
-static int tick_do_timer_cpu = -1;
+int tick_do_timer_cpu __read_mostly = -1;
 DEFINE_SPINLOCK(tick_device_lock);
 
 /*
@@ -295,6 +295,12 @@ static void tick_shutdown(unsigned int *
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
 
--- linux-2.6.21.1.orig/kernel/time/tick-internal.h
+++ linux-2.6.21.1/kernel/time/tick-internal.h
@@ -5,6 +5,7 @@ DECLARE_PER_CPU(struct tick_device, tick
 extern spinlock_t tick_device_lock;
 extern ktime_t tick_next_period;
 extern ktime_t tick_period;
+extern int tick_do_timer_cpu __read_mostly;
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
--- linux-2.6.21.1.orig/kernel/time/tick-sched.c
+++ linux-2.6.21.1/kernel/time/tick-sched.c
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
@@ -338,12 +350,24 @@ static void tick_nohz_handler(struct clo
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
@@ -431,9 +455,23 @@ static enum hrtimer_restart tick_sched_t
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

-- 

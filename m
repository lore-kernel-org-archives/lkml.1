Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYADN4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYADN4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYADN4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:56:10 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:24604 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752045AbYADN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:56:08 -0500
Message-Id: <20080104135652.657943000@chello.nl>
References: <20080104135457.336761000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 Jan 2008 14:55:01 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/7] hrtimer: fixup the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ fallback
Content-Disposition: inline; filename=hrtimer-fallback.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all highres=off timers are run from softirq context, but
HRTIMER_CB_IRQSAFE_NO_SOFTIRQ timers expect to run from irq context.

Fix this up by splitting it similar to the highres=on case.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/hrtimer.h |    1 
 kernel/hrtimer.c        |  223 ++++++++++++++++++++++++------------------------
 kernel/timer.c          |    3 
 3 files changed, 117 insertions(+), 110 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1030,6 +1030,85 @@ int hrtimer_get_res(const clockid_t whic
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
+static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
+{
+	spin_lock_irq(&cpu_base->lock);
+
+	while (!list_empty(&cpu_base->cb_pending)) {
+		enum hrtimer_restart (*fn)(struct hrtimer *);
+		struct hrtimer *timer;
+		int restart;
+
+		timer = list_entry(cpu_base->cb_pending.next,
+				   struct hrtimer, cb_entry);
+
+		timer_stats_account_hrtimer(timer);
+
+		fn = timer->function;
+		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
+		spin_unlock_irq(&cpu_base->lock);
+
+		restart = fn(timer);
+
+		spin_lock_irq(&cpu_base->lock);
+
+		timer->state &= ~HRTIMER_STATE_CALLBACK;
+		if (restart == HRTIMER_RESTART) {
+			BUG_ON(hrtimer_active(timer));
+			/*
+			 * Enqueue the timer, allow reprogramming of the event
+			 * device
+			 */
+			enqueue_hrtimer(timer, timer->base, 1);
+		} else if (hrtimer_active(timer)) {
+			/*
+			 * If the timer was rearmed on another CPU, reprogram
+			 * the event device.
+			 */
+			if (timer->base->first == &timer->node)
+				hrtimer_reprogram(timer, timer->base);
+		}
+	}
+	spin_unlock_irq(&cpu_base->lock);
+}
+
+static void __run_hrtimer(struct hrtimer *timer)
+{
+	struct hrtimer_clock_base *base = timer->base;
+	struct hrtimer_cpu_base *cpu_base = base->cpu_base;
+	enum hrtimer_restart (*fn)(struct hrtimer *);
+	int restart;
+
+	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
+	timer_stats_account_hrtimer(timer);
+
+	fn = timer->function;
+	if (timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ) {
+		/*
+		 * Used for scheduler timers, avoid lock inversion with
+		 * rq->lock and tasklist_lock.
+		 *
+		 * These timers are required to deal with enqueue expiry
+		 * themselves and are not allowed to migrate.
+		 */
+		spin_unlock(&cpu_base->lock);
+		restart = fn(timer);
+		spin_lock(&cpu_base->lock);
+	} else
+		restart = fn(timer);
+
+	/*
+	 * Note: We clear the CALLBACK bit after enqueue_hrtimer to avoid
+	 * reprogramming of the event hardware. This happens at the end of this
+	 * function anyway.
+	 */
+	if (restart != HRTIMER_NORESTART) {
+		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
+		enqueue_hrtimer(timer, base, 0);
+	}
+	timer->state &= ~HRTIMER_STATE_CALLBACK;
+}
+
 #ifdef CONFIG_HIGH_RES_TIMERS
 
 /*
@@ -1063,9 +1142,7 @@ void hrtimer_interrupt(struct clock_even
 		basenow = ktime_add(now, base->offset);
 
 		while ((node = base->first)) {
-			enum hrtimer_restart (*fn)(struct hrtimer *);
 			struct hrtimer *timer;
-			int restart;
 
 			timer = rb_entry(node, struct hrtimer, node);
 
@@ -1089,37 +1166,7 @@ void hrtimer_interrupt(struct clock_even
 				continue;
 			}
 
-			__remove_hrtimer(timer, base,
-					 HRTIMER_STATE_CALLBACK, 0);
-			timer_stats_account_hrtimer(timer);
-
-			fn = timer->function;
-			if (timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ) {
-				/*
-				 * Used for scheduler timers, avoid lock
-				 * inversion with rq->lock and tasklist_lock.
-				 *
-				 * These timers are required to deal with
-				 * enqueue expiry themselves and are not
-				 * allowed to migrate.
-				 */
-				spin_unlock(&cpu_base->lock);
-				restart = fn(timer);
-				spin_lock(&cpu_base->lock);
-			} else
-				restart = fn(timer);
-
-			/*
-			 * Note: We clear the CALLBACK bit after
-			 * enqueue_hrtimer to avoid reprogramming of
-			 * the event hardware. This happens at the end
-			 * of this function anyway.
-			 */
-			if (restart != HRTIMER_NORESTART) {
-				BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
-				enqueue_hrtimer(timer, base, 0);
-			}
-			timer->state &= ~HRTIMER_STATE_CALLBACK;
+			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
 		base++;
@@ -1140,52 +1187,41 @@ void hrtimer_interrupt(struct clock_even
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	spin_lock_irq(&cpu_base->lock);
-
-	while (!list_empty(&cpu_base->cb_pending)) {
-		enum hrtimer_restart (*fn)(struct hrtimer *);
-		struct hrtimer *timer;
-		int restart;
-
-		timer = list_entry(cpu_base->cb_pending.next,
-				   struct hrtimer, cb_entry);
+	run_hrtimer_pending(&__get_cpu_var(hrtimer_bases));
+}
 
-		timer_stats_account_hrtimer(timer);
+#endif	/* CONFIG_HIGH_RES_TIMERS */
 
-		fn = timer->function;
-		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
-		spin_unlock_irq(&cpu_base->lock);
+/*
+ * Called from timer softirq every jiffy, expire hrtimers:
+ *
+ * For HRT its the fall back code to run the softirq in the timer
+ * softirq context in case the hrtimer initialization failed or has
+ * not been done yet.
+ */
+void hrtimer_run_pending(void)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 
-		restart = fn(timer);
+	if (hrtimer_hres_active())
+		return;
 
-		spin_lock_irq(&cpu_base->lock);
+	/*
+	 * This _is_ ugly: We have to check in the softirq context,
+	 * whether we can switch to highres and / or nohz mode. The
+	 * clocksource switch happens in the timer interrupt with
+	 * xtime_lock held. Notification from there only sets the
+	 * check bit in the tick_oneshot code, otherwise we might
+	 * deadlock vs. xtime_lock.
+	 */
+	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
+		hrtimer_switch_to_hres();
 
-		timer->state &= ~HRTIMER_STATE_CALLBACK;
-		if (restart == HRTIMER_RESTART) {
-			BUG_ON(hrtimer_active(timer));
-			/*
-			 * Enqueue the timer, allow reprogramming of the event
-			 * device
-			 */
-			enqueue_hrtimer(timer, timer->base, 1);
-		} else if (hrtimer_active(timer)) {
-			/*
-			 * If the timer was rearmed on another CPU, reprogram
-			 * the event device.
-			 */
-			if (timer->base->first == &timer->node)
-				hrtimer_reprogram(timer, timer->base);
-		}
-	}
-	spin_unlock_irq(&cpu_base->lock);
+	run_hrtimer_pending(cpu_base);
 }
 
-#endif	/* CONFIG_HIGH_RES_TIMERS */
-
 /*
- * Expire the per base hrtimer-queue:
+ * Called from hardirq context every jiffy
  */
 static inline void run_hrtimer_queue(struct hrtimer_cpu_base *cpu_base,
 				     int index)
@@ -1203,42 +1239,23 @@ static inline void run_hrtimer_queue(str
 
 	while ((node = base->first)) {
 		struct hrtimer *timer;
-		enum hrtimer_restart (*fn)(struct hrtimer *);
-		int restart;
 
 		timer = rb_entry(node, struct hrtimer, node);
 		if (base->softirq_time.tv64 <= timer->expires.tv64)
 			break;
 
-#ifdef CONFIG_HIGH_RES_TIMERS
-		WARN_ON_ONCE(timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ);
-#endif
-		timer_stats_account_hrtimer(timer);
-
-		fn = timer->function;
-		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
-		spin_unlock_irq(&cpu_base->lock);
-
-		restart = fn(timer);
-
-		spin_lock_irq(&cpu_base->lock);
-
-		timer->state &= ~HRTIMER_STATE_CALLBACK;
-		if (restart != HRTIMER_NORESTART) {
-			BUG_ON(hrtimer_active(timer));
-			enqueue_hrtimer(timer, base, 0);
+		if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
+			__remove_hrtimer(timer, base, HRTIMER_STATE_PENDING, 0);
+			list_add_tail(&timer->cb_entry,
+					&base->cpu_base->cb_pending);
+			continue;
 		}
+
+		__run_hrtimer(timer);
 	}
 	spin_unlock_irq(&cpu_base->lock);
 }
 
-/*
- * Called from timer softirq every jiffy, expire hrtimers:
- *
- * For HRT its the fall back code to run the softirq in the timer
- * softirq context in case the hrtimer initialization failed or has
- * not been done yet.
- */
 void hrtimer_run_queues(void)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
@@ -1247,18 +1264,6 @@ void hrtimer_run_queues(void)
 	if (hrtimer_hres_active())
 		return;
 
-	/*
-	 * This _is_ ugly: We have to check in the softirq context,
-	 * whether we can switch to highres and / or nohz mode. The
-	 * clocksource switch happens in the timer interrupt with
-	 * xtime_lock held. Notification from there only sets the
-	 * check bit in the tick_oneshot code, otherwise we might
-	 * deadlock vs. xtime_lock.
-	 */
-	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
-		if (hrtimer_switch_to_hres())
-			return;
-
 	hrtimer_get_softirq_time(cpu_base);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -896,7 +896,7 @@ static void run_timer_softirq(struct sof
 {
 	tvec_base_t *base = __get_cpu_var(tvec_bases);
 
-	hrtimer_run_queues();
+	hrtimer_run_pending();
 
 	if (time_after_eq(jiffies, base->timer_jiffies))
 		__run_timers(base);
@@ -907,6 +907,7 @@ static void run_timer_softirq(struct sof
  */
 void run_local_timers(void)
 {
+	hrtimer_run_queues();
 	raise_softirq(TIMER_SOFTIRQ);
 	softlockup_tick();
 }
Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -319,6 +319,7 @@ extern void hrtimer_init_sleeper(struct 
 
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
+extern void hrtimer_run_pending(void);
 
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);

--


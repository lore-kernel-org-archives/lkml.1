Return-Path: <linux-kernel-owner+w=401wt.eu-S965526AbXAWWDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526AbXAWWDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965523AbXAWWBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:01:25 -0500
Received: from www.osadl.org ([213.239.205.134]:35887 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933162AbXAWWBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:08 -0500
Message-Id: <20070123211206.891194000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 26/46] hrtimers; add state tracking
Content-Disposition: inline; filename=hrtimers-add-state-tracking.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Reintroduce ktimers feature "optimized away" by the ktimers review
process: multiple hrtimer states to enable the running of hrtimers
without holding the cpu-base-lock.

(The "optimized" rbtree hack carried only 2 states worth of information
and we need 4 for high resolution timers and dynamic ticks.)

No functional changes.

Build-fixes-from: Andrew Morton <akpm@osdl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |   36 +++++++++++++++++++++++++++++++++++-
 kernel/hrtimer.c        |   40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 67 insertions(+), 9 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/include/linux/hrtimer.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/hrtimer.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/hrtimer.h
@@ -40,6 +40,34 @@ enum hrtimer_restart {
 	HRTIMER_RESTART,	/* Timer must be restarted */
 };
 
+/*
+ * Bit values to track state of the timer
+ *
+ * Possible states:
+ *
+ * 0x00		inactive
+ * 0x01		enqueued into rbtree
+ * 0x02		callback function running
+ * 0x03		callback function running and enqueued
+ *		(was requeued on another CPU)
+ *
+ * The "callback function running and enqueued" status is only possible on
+ * SMP. It happens for example when a posix timer expired and the callback
+ * queued a signal. Between dropping the lock which protects the posix timer
+ * and reacquiring the base lock of the hrtimer, another CPU can deliver the
+ * signal and rearm the timer. We have to preserve the callback running state,
+ * as otherwise the timer could be removed before the softirq code finishes the
+ * the handling of the timer.
+ *
+ * The HRTIMER_STATE_ENQUEUE bit is always or'ed to the current state to
+ * preserve the HRTIMER_STATE_CALLBACK bit in the above scenario.
+ *
+ * All state transitions are protected by cpu_base->lock.
+ */
+#define HRTIMER_STATE_INACTIVE	0x00
+#define HRTIMER_STATE_ENQUEUED	0x01
+#define HRTIMER_STATE_CALLBACK	0x02
+
 /**
  * struct hrtimer - the basic hrtimer structure
  * @node:	red black tree node for time ordered insertion
@@ -48,6 +76,7 @@ enum hrtimer_restart {
  *		which the timer is based.
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
+ * @state:	state information (See bit values above)
  *
  * The hrtimer structure must be initialized by init_hrtimer_#CLOCKTYPE()
  */
@@ -56,6 +85,7 @@ struct hrtimer {
 	ktime_t				expires;
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
+	unsigned long			state;
 };
 
 /**
@@ -141,9 +171,13 @@ extern int hrtimer_get_res(const clockid
 extern ktime_t hrtimer_get_next_event(void);
 #endif
 
+/*
+ * A timer is active, when it is enqueued into the rbtree or the callback
+ * function is running.
+ */
 static inline int hrtimer_active(const struct hrtimer *timer)
 {
-	return rb_parent(&timer->node) != &timer->node;
+	return timer->state != HRTIMER_STATE_INACTIVE;
 }
 
 /* Forward a hrtimer so it expires after now: */
Index: linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/hrtimer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
@@ -150,6 +150,23 @@ static void hrtimer_get_softirq_time(str
 }
 
 /*
+ * Helper function to check, whether the timer is on one of the queues
+ */
+static inline int hrtimer_is_queued(struct hrtimer *timer)
+{
+	return timer->state & HRTIMER_STATE_ENQUEUED;
+}
+
+/*
+ * Helper function to check, whether the timer is running the callback
+ * function
+ */
+static inline int hrtimer_callback_running(struct hrtimer *timer)
+{
+	return timer->state & HRTIMER_STATE_CALLBACK;
+}
+
+/*
  * Functions and macros which are different for UP/SMP systems are kept in a
  * single place
  */
@@ -390,6 +407,11 @@ static void enqueue_hrtimer(struct hrtim
 	 */
 	rb_link_node(&timer->node, parent, link);
 	rb_insert_color(&timer->node, &base->active);
+	/*
+	 * HRTIMER_STATE_ENQUEUED is or'ed to the current state to preserve the
+	 * state of a possibly running callback.
+	 */
+	timer->state |= HRTIMER_STATE_ENQUEUED;
 
 	if (!base->first || timer->expires.tv64 <
 	    rb_entry(base->first, struct hrtimer, node)->expires.tv64)
@@ -402,7 +424,8 @@ static void enqueue_hrtimer(struct hrtim
  * Caller must hold the base lock.
  */
 static void __remove_hrtimer(struct hrtimer *timer,
-			     struct hrtimer_clock_base *base)
+			     struct hrtimer_clock_base *base,
+			     unsigned long newstate)
 {
 	/*
 	 * Remove the timer from the rbtree and replace the
@@ -411,7 +434,7 @@ static void __remove_hrtimer(struct hrti
 	if (base->first == &timer->node)
 		base->first = rb_next(&timer->node);
 	rb_erase(&timer->node, &base->active);
-	rb_set_parent(&timer->node, &timer->node);
+	timer->state = newstate;
 }
 
 /*
@@ -420,8 +443,8 @@ static void __remove_hrtimer(struct hrti
 static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
-	if (hrtimer_active(timer)) {
-		__remove_hrtimer(timer, base);
+	if (hrtimer_is_queued(timer)) {
+		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE);
 		return 1;
 	}
 	return 0;
@@ -493,7 +516,7 @@ int hrtimer_try_to_cancel(struct hrtimer
 
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (base->cpu_base->curr_timer != timer)
+	if (!hrtimer_callback_running(timer))
 		ret = remove_hrtimer(timer, base);
 
 	unlock_hrtimer_base(timer, &flags);
@@ -598,7 +621,6 @@ void hrtimer_init(struct hrtimer *timer,
 		clock_id = CLOCK_MONOTONIC;
 
 	timer->base = &cpu_base->clock_base[clock_id];
-	rb_set_parent(&timer->node, &timer->node);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
@@ -649,13 +671,14 @@ static inline void run_hrtimer_queue(str
 
 		fn = timer->function;
 		set_curr_timer(cpu_base, timer);
-		__remove_hrtimer(timer, base);
+		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK);
 		spin_unlock_irq(&cpu_base->lock);
 
 		restart = fn(timer);
 
 		spin_lock_irq(&cpu_base->lock);
 
+		timer->state &= ~HRTIMER_STATE_CALLBACK;
 		if (restart != HRTIMER_NORESTART) {
 			BUG_ON(hrtimer_active(timer));
 			enqueue_hrtimer(timer, base);
@@ -826,7 +849,8 @@ static void migrate_hrtimer_list(struct 
 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
-		__remove_hrtimer(timer, old_base);
+		BUG_ON(timer->state & HRTIMER_STATE_CALLBACK);
+		__remove_hrtimer(timer, old_base, HRTIMER_STATE_INACTIVE);
 		timer->base = new_base;
 		enqueue_hrtimer(timer, new_base);
 	}

--


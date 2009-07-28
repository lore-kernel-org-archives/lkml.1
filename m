Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZG1Mq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZG1Mq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZG1MqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:46:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53332 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZG1MqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:46:24 -0400
Message-ID: <4A6EF315.1050701@cn.fujitsu.com>
Date: Tue, 28 Jul 2009 20:46:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/3] ftrace: add tracepoint for hrtimer
References: <4A6EF27C.7010605@cn.fujitsu.com>
In-Reply-To: <4A6EF27C.7010605@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those tracepoints are wanted and useful:
1: We can detect a hrtimer's delay
2: We can monitor the lifecycle and behaviors of a hrtimer

Thus they help in analysing and debuging.

Great thanks to Thomas for giving me so many valuable advices.

Example ftrace output:
  insmod-1824  [001]   606.749538: hrtimer_init: timer=d0ae04c0 clockid=CLOCK_REALTIME mode=HRTIMER_MODE_ABS
  insmod-1824  [001]   606.749614: hrtimer_start: timer=d0ae04c0 func=hrtimer_fun expires=1246707447252299435ns softexpires=1246707447252299435ns
  <idle>-0     [001]   606.754372: hrtimer_cancel: timer=d0ae04c0
  <idle>-0     [001]   606.754374: hrtimer_expire: timer=d0ae04c0 now=1246707447257141331ns
  <idle>-0     [001]   606.754430: hrtimer_callback_done: timer=d0ae04c0
 
We expect the hrtimer expires at 1246707447252299435ns, actually the
hrtimer expires at 1246707447257141331ns, so it is delayed by
1246707447257141331-1246707447252299435=4841896ns.
We also realize the hrtimer's callback started at 606.754374, and it
finished at 606.754430, so it's taking 606.754430-606.754374=0.05ms.

Changelog:
v1->v2:
1: Remove ktime_to_ns() in TP_fast_assign()
2: Combine debugobjects and trace as Thomas's suggestion
v2->v3:
1: Remove function address from hrtimer_expire and hrtimer_cancel
   as Thomas's suggestion
2: Remove debug_and_trace_hrtimer_expire() as Thomas's suggestion
3: Rename trace_hrtimer_entry() and trace_hrtimer_exit() to match this patch
v3->v4:
1: Rename debug_and_trace_*() to debug_*() as Peter Zijlstra's suggestion
2: Move trace_hrtimer_expire() to __run_hrtimer() in order to calculate
   exacts timer latency as Peter Zijlstra's suggestion
3: Integrate Anton Blanchard's patch, which can been found at:
	http://marc.info/?l=linux-kernel&m=124331396919301&w=2

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |  133 ++++++++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c             |   34 +++++++++--
 2 files changed, 162 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index a664afa..dd2f133 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -128,6 +128,139 @@ TRACE_EVENT(timer_cancel,
 	TP_printk("timer=%p", __entry->timer)
 );
 
+/**
+ * hrtimer_init - called when the hrtimer is initialized
+ * @timer: pointer to struct hrtimer
+ * @clockid: the hrtimer's clock
+ * @mode: the hrtimer's mode
+ **/
+TRACE_EVENT(hrtimer_init,
+
+	TP_PROTO(struct hrtimer *timer, clockid_t clockid, enum hrtimer_mode mode),
+
+	TP_ARGS(timer, clockid, mode),
+
+	TP_STRUCT__entry(
+		__field( void *,		timer		)
+		__field( clockid_t,		clockid		)
+		__field( enum hrtimer_mode,	mode		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->clockid	= clockid;
+		__entry->mode		= mode;
+	),
+
+	TP_printk("timer=%p clockid=%s mode=%s", __entry->timer,
+		  __entry->clockid == CLOCK_REALTIME ?
+			"CLOCK_REALTIME" : "CLOCK_MONOTONIC",
+		  __entry->mode == HRTIMER_MODE_ABS ?
+			"HRTIMER_MODE_ABS" : "HRTIMER_MODE_REL")
+);
+
+/**
+ * hrtimer_start - called when the hrtimer is started
+ * @timer: pointer to struct hrtimer
+ **/
+TRACE_EVENT(hrtimer_start,
+
+	TP_PROTO(struct hrtimer *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,	function	)
+		__field( s64,		expires		)
+		__field( s64,		softexpires	)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+		__entry->expires	= hrtimer_get_expires(timer).tv64;
+		__entry->softexpires	= hrtimer_get_softexpires(timer).tv64;
+	),
+
+	TP_printk("timer=%p func=%pf expires=%lluns softexpires=%lluns",
+		  __entry->timer, __entry->function,
+		 (unsigned long long)__entry->expires,
+		 (unsigned long long)__entry->softexpires)
+);
+
+/**
+ * htimmer_expire - called immediately before the hrtimer callback
+ * @timer: pointer to struct hrtimer
+ *
+ * When used in combination with the hrtimer_callback_done tracepoint we can
+ * determine the high res timer latency.
+ **/
+TRACE_EVENT(hrtimer_expire,
+
+	TP_PROTO(struct hrtimer *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+		__field( s64,		now	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+		__entry->now	= timer->base->get_time().tv64;
+	),
+
+	TP_printk("timer=%p now=%lluns", __entry->timer,
+		 (unsigned long long)__entry->now)
+ );
+
+ /**
+  * hrtimer_callback_done - called immediately after the hrtimer callback returns
+  * @timer: pointer to struct hrtimer
+  *
+  * When used in combination with the hrtimer_expire tracepoint we can
+  * determine the high res timer latency.
+  **/
+TRACE_EVENT(hrtimer_callback_done,
+
+	TP_PROTO(struct hrtimer *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+	),
+
+	TP_printk("timer=%p", __entry->timer)
+);
+
+/**
+ * hrtimer_cancel - called when the hrtimer is canceled
+ * @timer: pointer to struct hrtimer
+ **/
+TRACE_EVENT(hrtimer_cancel,
+
+	TP_PROTO(struct hrtimer *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+	),
+
+	TP_printk("timer=%p", __entry->timer)
+);
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e2f91ec..f05c7a1 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -48,6 +48,8 @@
 
 #include <asm/uaccess.h>
 
+#include <trace/events/timer.h>
+
 /*
  * The timer bases:
  *
@@ -441,6 +443,26 @@ static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
 static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
 #endif
 
+static inline void
+debug_init(struct hrtimer *timer, clockid_t clockid,
+	   enum hrtimer_mode mode)
+{
+	debug_hrtimer_init(timer);
+	trace_hrtimer_init(timer, clockid, mode);
+}
+
+static inline void debug_activate(struct hrtimer *timer)
+{
+	debug_hrtimer_activate(timer);
+	trace_hrtimer_start(timer);
+}
+
+static inline void debug_deactivate(struct hrtimer *timer)
+{
+	debug_hrtimer_deactivate(timer);
+	trace_hrtimer_cancel(timer);
+}
+
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -797,7 +819,7 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	struct hrtimer *entry;
 	int leftmost = 1;
 
-	debug_hrtimer_activate(timer);
+	debug_activate(timer);
 
 	/*
 	 * Find the right place in the rbtree:
@@ -883,7 +905,7 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
-		debug_hrtimer_deactivate(timer);
+		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
@@ -1116,7 +1138,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 		  enum hrtimer_mode mode)
 {
-	debug_hrtimer_init(timer);
+	debug_init(timer, clock_id, mode);
 	__hrtimer_init(timer, clock_id, mode);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
@@ -1149,7 +1171,7 @@ static void __run_hrtimer(struct hrtimer *timer)
 
 	WARN_ON(!irqs_disabled());
 
-	debug_hrtimer_deactivate(timer);
+	debug_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 	fn = timer->function;
@@ -1160,7 +1182,9 @@ static void __run_hrtimer(struct hrtimer *timer)
 	 * the timer base.
 	 */
 	spin_unlock(&cpu_base->lock);
+	trace_hrtimer_expire(timer);
 	restart = fn(timer);
+	trace_hrtimer_callback_done(timer);
 	spin_lock(&cpu_base->lock);
 
 	/*
@@ -1569,7 +1593,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
-		debug_hrtimer_deactivate(timer);
+		debug_deactivate(timer);
 
 		/*
 		 * Mark it as STATE_MIGRATE not INACTIVE otherwise the
-- 
1.6.1.2



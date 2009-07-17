Return-Path: <linux-kernel-owner+w=401wt.eu-S934380AbZGQKSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380AbZGQKSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934348AbZGQKSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:18:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934341AbZGQKSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:18:52 -0400
Message-ID: <4A605009.8060806@cn.fujitsu.com>
Date: Fri, 17 Jul 2009 18:18:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/4] ftrace: add tracepoint for hrtimer
References: <4A604E46.5050903@cn.fujitsu.com>
In-Reply-To: <4A604E46.5050903@cn.fujitsu.com>
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
  insmod-5280  [000] 10798.356372: hrtimer_init: timer=d0b044c0 clockid=CLOCK_REALTIME mode=HRTIMER_MODE_ABS
  insmod-5280  [000] 10798.356385: hrtimer_start: timer=d0b044c0 func=hrtimer_fun expires=1246242896000000000 ns softexpires=1246242896000000000 ns
  <idle>-0     [000] 10807.982987: hrtimer_expire: timer=d0b044c0 now=1246242896000906503 ns
  <idle>-0     [000] 10807.982989: hrtimer_cancel: timer=d0b044c0
  <idle>-0     [000] 10807.983562: hrtimer_callback_done: timer=d0b044c0
 
We expect the hrtimer expires at 1246242896000000000 ns, actually the
hrtimer expires at 1246242896000906503 ns, so it is delayed by
1246242896000906503-1246242896000000000 = 906503 ns.
We also realize the hrtimer's callback started at 10807.982987, and it
finished at 10807.983562, so it's taking 10807.983562-10807.982987=0.6ms.

Changelog:
v1->v2:
1: Remove ktime_to_ns() in TP_fast_assign()
2: Combine debugobjects and trace as Thomas's suggestion
v2->v3:
1: Remove function address from hrtimer_expire and hrtimer_cancel
   as Thomas's suggestion
2: Remove debug_and_trace_hrtimer_expire() as Thomas's suggestion
3: Rename trace_hrtimer_entry() and trace_hrtimer_exit() to match this patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |  107 ++++++++++++++++++++++++++++++++++--------
 kernel/hrtimer.c             |   35 +++++++++++---
 2 files changed, 115 insertions(+), 27 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 967e225..8b22b12 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -116,58 +116,125 @@ TRACE_EVENT(timer_cancel,
 	TP_printk("timer=%p", __entry->timer)
 );
 
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
+	TP_printk("timer=%p func=%pf expires=%llu ns softexpires=%llu ns",
+		  __entry->timer, __entry->function,
+		 (unsigned long long)__entry->expires,
+		 (unsigned long long)__entry->softexpires)
+);
+
 /**
- * hrtimer_entry - called immediately before the high res timer callback
+ * htimmer_expire - called before the high res timer callback
  * @timer: pointer to struct hrtimer
  *
- * When used in combination with the hrtimer_exit tracepoint we can
+ * When used in combination with the hrtimer_callback_done tracepoint we can
  * determine the high res timer latency.
  **/
-TRACE_EVENT(hrtimer_entry,
+TRACE_EVENT(hrtimer_expire,
 
-	TP_PROTO(struct hrtimer *timer),
+	TP_PROTO(struct hrtimer *timer, s64 now),
 
-	TP_ARGS(timer),
+	TP_ARGS(timer, now),
 
 	TP_STRUCT__entry(
-		__field(void *, function)
+		__field( void *,	timer	)
+		__field( s64,		now	)
 	),
 
 	TP_fast_assign(
-		__entry->function = timer->function;
+		__entry->timer	= timer;
+		__entry->now	= now;
 	),
 
-	TP_printk("func=%pf", __entry->function)
+	TP_printk("timer=%p now=%llu ns", __entry->timer,
+		 (unsigned long long)__entry->now)
 );
 
 /**
- * hrtimer_exit - called immediately after the high res timer returns
+ * hrtimer_callback_done - called immediately after the high res timer returns
  * @timer: pointer to struct hrtimer
  * @restart: high res timer return value
  *
  * High res timer will restart if @restart is set to HRTIMER_RESTART.
- * When used in combination with the hrtimer_entry tracepoint we can
+ * When used in combination with the hrtimer_expire tracepoint we can
  * determine the high res timer latency.
  **/
-TRACE_EVENT(hrtimer_exit,
+TRACE_EVENT(hrtimer_callback_done,
 
-	TP_PROTO(struct hrtimer *timer, int restart),
+	TP_PROTO(struct hrtimer *timer),
 
-	TP_ARGS(timer, restart),
+	TP_ARGS(timer),
 
 	TP_STRUCT__entry(
-		__field(void *, function)
-		__field(int, restart)
+		__field( void *,	timer	)
 	),
 
 	TP_fast_assign(
-		__entry->function = timer->function;
-		__entry->restart = restart;
+		__entry->timer	= timer;
 	),
 
-	TP_printk("func=%pf restart=%s", __entry->function,
-		(__entry->restart == HRTIMER_RESTART) ?
-			"HRTIMER_RESTART" : "HRTIMER_NORESTART")
+	TP_printk("timer=%p", __entry->timer)
+);
+
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
 );
 
 #endif /*  _TRACE_TIMER_H */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 33317e4..bd21c9b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -442,6 +442,26 @@ static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
 static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
 #endif
 
+static inline void
+debug_and_trace_hrtimer_init(struct hrtimer *timer, clockid_t clockid,
+			     enum hrtimer_mode mode)
+{
+	debug_hrtimer_init(timer);
+	trace_hrtimer_init(timer, clockid, mode);
+}
+
+static inline void debug_and_trace_hrtimer_activate(struct hrtimer *timer)
+{
+	debug_hrtimer_activate(timer);
+	trace_hrtimer_start(timer);
+}
+
+static inline void debug_and_trace_hrtimer_deactivate(struct hrtimer *timer)
+{
+	debug_hrtimer_deactivate(timer);
+	trace_hrtimer_cancel(timer);
+}
+
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -798,7 +818,7 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	struct hrtimer *entry;
 	int leftmost = 1;
 
-	debug_hrtimer_activate(timer);
+	debug_and_trace_hrtimer_activate(timer);
 
 	/*
 	 * Find the right place in the rbtree:
@@ -884,7 +904,7 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
-		debug_hrtimer_deactivate(timer);
+		debug_and_trace_hrtimer_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
@@ -1118,7 +1138,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 		  enum hrtimer_mode mode)
 {
-	debug_hrtimer_init(timer);
+	debug_and_trace_hrtimer_init(timer, clock_id, mode);
 	__hrtimer_init(timer, clock_id, mode);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
@@ -1151,7 +1171,7 @@ static void __run_hrtimer(struct hrtimer *timer)
 
 	WARN_ON(!irqs_disabled());
 
-	debug_hrtimer_deactivate(timer);
+	debug_and_trace_hrtimer_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 	fn = timer->function;
@@ -1162,9 +1182,8 @@ static void __run_hrtimer(struct hrtimer *timer)
 	 * the timer base.
 	 */
 	spin_unlock(&cpu_base->lock);
-	trace_hrtimer_entry(timer);
 	restart = fn(timer);
-	trace_hrtimer_exit(timer, restart);
+	trace_hrtimer_callback_done(timer);
 	spin_lock(&cpu_base->lock);
 
 	/*
@@ -1275,6 +1294,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 				break;
 			}
 
+			trace_hrtimer_expire(timer, basenow.tv64);
 			__run_hrtimer(timer);
 		}
 		base++;
@@ -1397,6 +1417,7 @@ void hrtimer_run_queues(void)
 					hrtimer_get_expires_tv64(timer))
 				break;
 
+			trace_hrtimer_expire(timer, base->softirq_time.tv64);
 			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
@@ -1573,7 +1594,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
-		debug_hrtimer_deactivate(timer);
+		debug_and_trace_hrtimer_deactivate(timer);
 
 		/*
 		 * Mark it as STATE_MIGRATE not INACTIVE otherwise the
-- 
1.6.1.2



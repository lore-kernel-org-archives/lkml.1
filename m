Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbZFQJlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbZFQJlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762542AbZFQJko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:40:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51563 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758516AbZFQJkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:40:43 -0400
Message-ID: <4A38BA33.9050906@cn.fujitsu.com>
Date: Wed, 17 Jun 2009 17:41:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 v2] ftrace: add tracepoint for hrtimer
References: <4A38B9C7.3080802@cn.fujitsu.com>
In-Reply-To: <4A38B9C7.3080802@cn.fujitsu.com>
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
insmod-3821  [001]  3192.239314: hrtimer_init: timer=d08a1480 clockid=CLOCK_REALTIME mode=HRTIMER_MODE_ABS
insmod-3821  [001]  3192.239335: hrtimer_start: timer=d08a1480 func=hrtimer_fun expires=1245162841000000000 ns softexpires=1245162841000000000 ns
<idle>-0     [001]  3201.506127: hrtimer_expire: timer=d08a1480 func=hrtimer_fun now=1245162841010241858
<idle>-0     [001]  3201.506129: hrtimer_cancel: timer=d08a1480 func=hrtimer_fun
 
We expect the hrtimer expires at 1245162841000000000 ns, actually the
hrtimer expires at 1245162841010241858 ns, so it is delayed by
1245162841010241858- 1245162841000000000 = 10241858 ns.

Changelog v1->v2:
1: Remove ktime_to_ns() in TP_fast_assign()
2: Combine debugobjects and trace as Thomas's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |   90 ++++++++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c             |   38 +++++++++++++++--
 2 files changed, 123 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index e9c51ee..8ffb2e2 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -192,6 +192,96 @@ TRACE_EVENT(timer_cancel,
 	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
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
+TRACE_EVENT(hrtimer_expire,
+
+	TP_PROTO(struct hrtimer *timer, s64 now),
+
+	TP_ARGS(timer, now),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,	function	)
+		__field( s64,		now		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+		__entry->now		= now;
+	),
+
+	TP_printk("timer=%p func=%pf now=%llu", __entry->timer, __entry->function,
+		 (unsigned long long)__entry->now)
+);
+
+TRACE_EVENT(hrtimer_cancel,
+
+	TP_PROTO(struct hrtimer *timer),
+	TP_ARGS(timer),
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,	function	)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+	),
+
+	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
+);
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b42429f..f75ba95 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -491,6 +491,32 @@ static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
 static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
 #endif
 
+static inline void
+debug_and_trace_hrtimer_init(struct hrtimer *timer, clockid_t clockid,
+                             enum hrtimer_mode mode)
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
+static inline void debug_and_trace_hrtimer_expire(struct hrtimer *timer,
+                                                  s64 now)
+{
+	trace_hrtimer_expire(timer, now);
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
 
@@ -847,7 +873,7 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	struct hrtimer *entry;
 	int leftmost = 1;
 
-	debug_hrtimer_activate(timer);
+	debug_and_trace_hrtimer_activate(timer);
 
 	/*
 	 * Find the right place in the rbtree:
@@ -933,7 +959,7 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
-		debug_hrtimer_deactivate(timer);
+		debug_and_trace_hrtimer_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
@@ -1167,7 +1193,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 		  enum hrtimer_mode mode)
 {
-	debug_hrtimer_init(timer);
+	debug_and_trace_hrtimer_init(timer, clock_id, mode);
 	__hrtimer_init(timer, clock_id, mode);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
@@ -1200,7 +1226,7 @@ static void __run_hrtimer(struct hrtimer *timer)
 
 	WARN_ON(!irqs_disabled());
 
-	debug_hrtimer_deactivate(timer);
+	debug_and_trace_hrtimer_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 	fn = timer->function;
@@ -1316,6 +1342,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 				break;
 			}
 
+			debug_and_trace_hrtimer_expire(timer, basenow.tv64);
 			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
@@ -1434,6 +1461,7 @@ void hrtimer_run_queues(void)
 					hrtimer_get_expires_tv64(timer))
 				break;
 
+			debug_and_trace_hrtimer_expire(timer, base->softirq_time.tv64);
 			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
@@ -1610,7 +1638,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
-		debug_hrtimer_deactivate(timer);
+		debug_and_trace_hrtimer_deactivate(timer);
 
 		/*
 		 * Mark it as STATE_MIGRATE not INACTIVE otherwise the
-- 
1.6.1.2


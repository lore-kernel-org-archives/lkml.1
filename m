Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbZIBMTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbZIBMTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 08:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZIBMTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 08:19:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:39688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZIBMTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 08:19:04 -0400
Date: Wed, 2 Sep 2009 12:18:33 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, zhaolei@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4A7F8B2B.5020908@cn.fujitsu.com>
References: <4A7F8B2B.5020908@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/tracing] hrtimer: Add tracepoint for hrtimers
Message-ID: <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org>
Git-Commit-ID: c6a2a1770245f654f35f60e1458d4356680f9519
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 12:18:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6a2a1770245f654f35f60e1458d4356680f9519
Gitweb:     http://git.kernel.org/tip/c6a2a1770245f654f35f60e1458d4356680f9519
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 10 Aug 2009 10:51:23 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 29 Aug 2009 14:10:06 +0200

hrtimer: Add tracepoint for hrtimers

Add tracepoints which cover the life cycle of a hrtimer. The
tracepoints are integrated with the already existing debug_object
debug points as far as possible.

[ tglx: Fixed comments, made output conistent, easier to read and
  	parse. Fixed output for 32bit archs which do not use the
  	scalar representation of ktime_t. Hand current time to
  	trace_hrtimer_expiry_entry instead of calling get_time()
  	inside of the trace assignment. ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
LKML-Reference: <4A7F8B2B.5020908@cn.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/trace/events/timer.h |  139 ++++++++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c             |   40 ++++++++++---
 2 files changed, 171 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 725892a..df3c07f 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -5,6 +5,7 @@
 #define _TRACE_TIMER_H
 
 #include <linux/tracepoint.h>
+#include <linux/hrtimer.h>
 #include <linux/timer.h>
 
 /**
@@ -131,6 +132,144 @@ TRACE_EVENT(timer_cancel,
 	TP_printk("timer %p", __entry->timer)
 );
 
+/**
+ * hrtimer_init - called when the hrtimer is initialized
+ * @timer:	pointer to struct hrtimer
+ * @clockid:	the hrtimers clock
+ * @mode:	the hrtimers mode
+ */
+TRACE_EVENT(hrtimer_init,
+
+	TP_PROTO(struct hrtimer *timer, clockid_t clockid,
+		 enum hrtimer_mode mode),
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
+	TP_printk("hrtimer %p, clockid %s, mode %s", __entry->timer,
+		  __entry->clockid == CLOCK_REALTIME ?
+			"CLOCK_REALTIME" : "CLOCK_MONOTONIC",
+		  __entry->mode == HRTIMER_MODE_ABS ?
+			"HRTIMER_MODE_ABS" : "HRTIMER_MODE_REL")
+);
+
+/**
+ * hrtimer_start - called when the hrtimer is started
+ * @timer: pointer to struct hrtimer
+ */
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
+	TP_printk("hrtimer %p, func %pf, expires %llu, softexpires %llu",
+		  __entry->timer, __entry->function,
+		  (unsigned long long)ktime_to_ns((ktime_t) {
+				  .tv64 = __entry->expires }),
+		  (unsigned long long)ktime_to_ns((ktime_t) {
+				  .tv64 = __entry->softexpires }))
+);
+
+/**
+ * htimmer_expire_entry - called immediately before the hrtimer callback
+ * @timer:	pointer to struct hrtimer
+ * @now:	pointer to variable which contains current time of the
+ *		timers base.
+ *
+ * Allows to determine the timer latency.
+ */
+TRACE_EVENT(hrtimer_expire_entry,
+
+	TP_PROTO(struct hrtimer *timer, ktime_t *now),
+
+	TP_ARGS(timer, now),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+		__field( s64,		now	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+		__entry->now	= now->tv64;
+	),
+
+	TP_printk("hrtimer %p, now %llu", __entry->timer,
+		  (unsigned long long)ktime_to_ns((ktime_t) {
+				  .tv64 = __entry->now }))
+ );
+
+/**
+ * hrtimer_expire_exit - called immediately after the hrtimer callback returns
+ * @timer:	pointer to struct hrtimer
+ *
+ * When used in combination with the hrtimer_expire_entry tracepoint we can
+ * determine the runtime of the callback function.
+ */
+TRACE_EVENT(hrtimer_expire_exit,
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
+	TP_printk("hrtimer %p", __entry->timer)
+);
+
+/**
+ * hrtimer_cancel - called when the hrtimer is canceled
+ * @timer:	pointer to struct hrtimer
+ */
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
+	TP_printk("hrtimer %p", __entry->timer)
+);
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e2f91ec..b44d1b0 100644
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
@@ -1140,7 +1162,7 @@ int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
-static void __run_hrtimer(struct hrtimer *timer)
+static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 {
 	struct hrtimer_clock_base *base = timer->base;
 	struct hrtimer_cpu_base *cpu_base = base->cpu_base;
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
+	trace_hrtimer_expire_entry(timer, now);
 	restart = fn(timer);
+	trace_hrtimer_expire_exit(timer);
 	spin_lock(&cpu_base->lock);
 
 	/*
@@ -1271,7 +1295,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 				break;
 			}
 
-			__run_hrtimer(timer);
+			__run_hrtimer(timer, &basenow);
 		}
 		base++;
 	}
@@ -1393,7 +1417,7 @@ void hrtimer_run_queues(void)
 					hrtimer_get_expires_tv64(timer))
 				break;
 
-			__run_hrtimer(timer);
+			__run_hrtimer(timer, &base->softirq_time);
 		}
 		spin_unlock(&cpu_base->lock);
 	}
@@ -1569,7 +1593,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
-		debug_hrtimer_deactivate(timer);
+		debug_deactivate(timer);
 
 		/*
 		 * Mark it as STATE_MIGRATE not INACTIVE otherwise the

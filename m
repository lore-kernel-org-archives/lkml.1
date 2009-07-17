Return-Path: <linux-kernel-owner+w=401wt.eu-S934374AbZGQKPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374AbZGQKPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934360AbZGQKPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:15:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59291 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934314AbZGQKPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:15:04 -0400
Message-ID: <4A604F1E.9010402@cn.fujitsu.com>
Date: Fri, 17 Jul 2009 18:14:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/4] tracing/events: Add timer and high res timer tracepoints
References: <4A604E46.5050903@cn.fujitsu.com>
In-Reply-To: <4A604E46.5050903@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

Add tracepoints for timer and high res timer execution. We add entry and
exit tracepoints so we can calculate timer latency.

Example ftrace output:

<idle>-0     [000]   264.040506: hrtimer_entry: func=.tick_sched_timer
<idle>-0     [000]   264.040508: hrtimer_exit: func=.tick_sched_timer restart=HRTIMER_RESTART
<idle>-0     [000]   264.040530: timer_entry: func=.e1000_watchdog
<idle>-0     [000]   264.040728: timer_exit: func=.e1000_watchdog

Here we can see e1000_watchdog is taking 0.2ms - it might make sense to
move this into a workqueue or kernel thread.

Changelog v1->v2:
1: Rebase this patch against latest tip tree by Xiao Guangrong.
2: Move TRACE_SYSTEM out of #if 

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |  116 ++++++++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c             |    3 +
 kernel/timer.c               |    5 ++
 3 files changed, 124 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/timer.h

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
new file mode 100644
index 0000000..ff2754a
--- /dev/null
+++ b/include/trace/events/timer.h
@@ -0,0 +1,116 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM timer
+
+#if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TIMER_H
+
+#include <linux/tracepoint.h>
+#include <linux/timer.h>
+#include <linux/hrtimer.h>
+
+/**
+ * timer_entry - called immediately before the timer callback
+ * @timer: pointer to struct timer_list
+ *
+ * When used in combination with the timer_exit tracepoint we can
+ * determine the timer latency.
+ **/
+TRACE_EVENT(timer_entry,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field(void *, function)
+	),
+
+	TP_fast_assign(
+		__entry->function = timer->function;
+	),
+
+	TP_printk("func=%pf", __entry->function)
+);
+
+/**
+ * timer_exit - called immediately after the timer returns
+ * @timer: pointer to struct timer_list
+ *
+ * When used in combination with the timer_entry tracepoint we can
+ * determine the timer latency.
+ **/
+TRACE_EVENT(timer_exit,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field(void *, function)
+	),
+
+	TP_fast_assign(
+		__entry->function = timer->function;
+	),
+
+	TP_printk("func=%pf", __entry->function)
+);
+
+/**
+ * hrtimer_entry - called immediately before the high res timer callback
+ * @timer: pointer to struct hrtimer
+ *
+ * When used in combination with the hrtimer_exit tracepoint we can
+ * determine the high res timer latency.
+ **/
+TRACE_EVENT(hrtimer_entry,
+
+	TP_PROTO(struct hrtimer *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field(void *, function)
+	),
+
+	TP_fast_assign(
+		__entry->function = timer->function;
+	),
+
+	TP_printk("func=%pf", __entry->function)
+);
+
+/**
+ * hrtimer_exit - called immediately after the high res timer returns
+ * @timer: pointer to struct hrtimer
+ * @restart: high res timer return value
+ *
+ * High res timer will restart if @restart is set to HRTIMER_RESTART.
+ * When used in combination with the hrtimer_entry tracepoint we can
+ * determine the high res timer latency.
+ **/
+TRACE_EVENT(hrtimer_exit,
+
+	TP_PROTO(struct hrtimer *timer, int restart),
+
+	TP_ARGS(timer, restart),
+
+	TP_STRUCT__entry(
+		__field(void *, function)
+		__field(int, restart)
+	),
+
+	TP_fast_assign(
+		__entry->function = timer->function;
+		__entry->restart = restart;
+	),
+
+	TP_printk("func=%pf restart=%s", __entry->function,
+		(__entry->restart == HRTIMER_RESTART) ?
+			"HRTIMER_RESTART" : "HRTIMER_NORESTART")
+);
+
+#endif /*  _TRACE_TIMER_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ab5eb70..33317e4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -47,6 +47,7 @@
 #include <linux/timer.h>
 
 #include <asm/uaccess.h>
+#include <trace/events/timer.h>
 
 /*
  * The timer bases:
@@ -1161,7 +1162,9 @@ static void __run_hrtimer(struct hrtimer *timer)
 	 * the timer base.
 	 */
 	spin_unlock(&cpu_base->lock);
+	trace_hrtimer_entry(timer);
 	restart = fn(timer);
+	trace_hrtimer_exit(timer, restart);
 	spin_lock(&cpu_base->lock);
 
 	/*
diff --git a/kernel/timer.c b/kernel/timer.c
index 0b36b9e..9385ad5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -46,6 +46,9 @@
 #include <asm/timex.h>
 #include <asm/io.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/timer.h>
+
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
@@ -984,7 +987,9 @@ static inline void __run_timers(struct tvec_base *base)
 				 */
 				lock_map_acquire(&lockdep_map);
 
+				trace_timer_entry(timer);
 				fn(data);
+				trace_timer_exit(timer);
 
 				lock_map_release(&lockdep_map);
 
-- 
1.6.1.2



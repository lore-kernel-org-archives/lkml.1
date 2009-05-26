Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZEZE67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZEZE67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZEZE6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:58:51 -0400
Received: from ozlabs.org ([203.10.76.45]:56670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbZEZE6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:58:51 -0400
Date: Tue, 26 May 2009 14:55:28 +1000
From: Anton Blanchard <anton@samba.org>
To: rostedt@goodmis.org, mingo@elte.hu, tzanussi@gmail.com, jbaron@redhat.com,
       tglx@linutronix.de, fweisbec@gmail.com, kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3] tracing/events: Add timer and high res timer tracepoints
Message-ID: <20090526045528.GF19728@kryten>
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526042643.GB19728@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add tracepoints for timer and high res timer execution. We add entry and
exit tracepoints so we can calculate timer latency.

Example ftrace output:

<idle>-0     [000]   264.040506: hrtimer_entry: func=.tick_sched_timer
<idle>-0     [000]   264.040508: hrtimer_exit: func=.tick_sched_timer restart=HRTIMER_RESTART
<idle>-0     [000]   264.040530: timer_entry: func=.e1000_watchdog
<idle>-0     [000]   264.040728: timer_exit: func=.e1000_watchdog

Here we can see e1000_watchdog is taking 0.2ms - it might make sense to
move this into a workqueue or kernel thread.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---

v2: Changed %pF to %pf to remove always 0 function offset.
v3: Patch was corrupted, must be vi and my fat fingers.

Index: linux-2.6-master/kernel/hrtimer.c
===================================================================
--- linux-2.6-master.orig/kernel/hrtimer.c	2009-05-26 12:55:35.000000000 +1000
+++ linux-2.6-master/kernel/hrtimer.c	2009-05-26 13:09:55.000000000 +1000
@@ -46,6 +46,8 @@
 
 #include <asm/uaccess.h>
 
+#include <trace/events/timer.h>
+
 /**
  * ktime_get - get the monotonic time in ktime_t format
  *
@@ -1161,7 +1163,9 @@
 	 * the timer base.
 	 */
 	spin_unlock(&cpu_base->lock);
+	trace_hrtimer_entry(timer);
 	restart = fn(timer);
+	trace_hrtimer_exit(timer, restart);
 	spin_lock(&cpu_base->lock);
 
 	/*
Index: linux-2.6-master/kernel/timer.c
===================================================================
--- linux-2.6-master.orig/kernel/timer.c	2009-05-26 12:55:35.000000000 +1000
+++ linux-2.6-master/kernel/timer.c	2009-05-26 13:09:55.000000000 +1000
@@ -45,6 +45,9 @@
 #include <asm/timex.h>
 #include <asm/io.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/timer.h>
+
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
@@ -947,7 +950,9 @@
 				 */
 				lock_map_acquire(&lockdep_map);
 
+				trace_timer_entry(timer);
 				fn(data);
+				trace_timer_exit(timer);
 
 				lock_map_release(&lockdep_map);
 
Index: linux-2.6-master/include/trace/events/timer.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-master/include/trace/events/timer.h	2009-05-26 13:57:42.000000000 +1000
@@ -0,0 +1,116 @@
+#if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TIMER_H
+
+#include <linux/tracepoint.h>
+#include <linux/timer.h>
+#include <linux/hrtimer.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM timer
+
+/**
+ * timer_entry - called immediately before the timer
+ * @timer: pointer to struct timer_list
+ *
+ * When used in combination with the timer_exit tracepoint we can
+ * determine the timer latency.
+ */
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
+ */
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
+ * hrtimer_entry - called immediately before the high res timer
+ * @timer: pointer to struct hrtimer
+ *
+ * When used in combination with the hrtimer_exit tracepoint we can
+ * determine the high res timer latency.
+ */
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
+ */
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

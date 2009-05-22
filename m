Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZEVJwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZEVJwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZEVJwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:52:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54439 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZEVJwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:52:46 -0400
Message-ID: <4A167615.7050208@cn.fujitsu.com>
Date: Fri, 22 May 2009 17:53:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@elte.hu
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: [PATCH 1/3] ftrace: add tracepoint for timer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is modify from Mathieu's patch base on ingo's suggestion, the original patch
can be found here: 
	http://marc.info/?l=linux-kernel&m=123791201816247&w=2

This patch can trace timer's whole lifecycle as init/start/expire/cancel

Example ftrace output:
           <...>-2998  [000] 63501.542376: timer_init: timer=e0b374e0
           <...>-2998  [000] 63501.542424: timer_start: timer=e0b374e0 func=test_timerfuc expires=4294941565 cpu=0
	  <idle>-0     [000] 63514.508219: timer_expire: timer=e0b374e0 func=test_timerfuc
          <idle>-0     [000] 63514.508222: timer_cancel: timer=e0b374e0 func=test_timerfuc

We already have debugobject in timer to init/activate/deactivate/free,
but it can't be covered function of there tracepoints, because:
1: We can't get timer's lifecycle information in userspace by debugobject,
   it is necessary for system engineer to investigate system trouble caused
   by using timer.
2: We can't get information of whole lifecycle of timer by debugobject, 
   for example, deactivation of a timer.
3: There are many different tracing code in many kernel subsystem as blktrace,
   debugobject, and tracepoint is designed as generic way to unify these
   tracing way.

Changelog:
1: modify the tracepoint name
2: move tracepoing to suitable position
3: use TRACE_EVENT instead of DEFINE_TRACE/DECLARE_TRACE

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |   94 ++++++++++++++++++++++++++++++++++++++++++
 kernel/timer.c               |    9 ++++-
 2 files changed, 102 insertions(+), 1 deletions(-)
 create mode 100644 include/trace/events/timer.h

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
new file mode 100644
index 0000000..f2f60d8
--- /dev/null
+++ b/include/trace/events/timer.h
@@ -0,0 +1,94 @@
+#if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TIMER_H
+
+#include <linux/tracepoint.h>
+#include <linux/timer.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM timer
+
+TRACE_EVENT(timer_init,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+	),
+
+	TP_printk("timer=%p", __entry->timer)
+);
+
+TRACE_EVENT(timer_start,
+
+	TP_PROTO(struct timer_list *timer, int cpu),
+
+	TP_ARGS(timer, cpu),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,	function	)
+		__field( unsigned long,	expires		)
+		__field( int,		cpu		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+		__entry->expires	= timer->expires;
+		__entry->cpu		= cpu;
+	),
+
+	TP_printk("timer=%p func=%pf expires=%lu cpu=%d", __entry->timer,
+		  __entry->function, __entry->expires, __entry->cpu)
+);
+
+TRACE_EVENT(timer_expire,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,        function	)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function       = timer->function;
+	),
+
+	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
+);
+
+TRACE_EVENT(timer_cancel,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,        function        )
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
+#endif /*  _TRACE_TIMER_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
+
diff --git a/kernel/timer.c b/kernel/timer.c
index 4149033..6cb40ba 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -45,6 +45,9 @@
 #include <asm/timex.h>
 #include <asm/io.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/timer.h>
+
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
@@ -547,6 +550,7 @@ void init_timer_key(struct timer_list *timer,
 {
 	debug_timer_init(timer);
 	__init_timer(timer, name, key);
+	trace_timer_init(timer);
 }
 EXPORT_SYMBOL(init_timer_key);
 
@@ -565,6 +569,7 @@ static inline void detach_timer(struct timer_list *timer,
 	struct list_head *entry = &timer->entry;
 
 	debug_timer_deactivate(timer);
+	trace_timer_cancel(timer);
 
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
@@ -650,7 +655,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires, bool pending_only)
 
 	timer->expires = expires;
 	internal_add_timer(base, timer);
-
+	trace_timer_start(timer, smp_processor_id());
 out_unlock:
 	spin_unlock_irqrestore(&base->lock, flags);
 
@@ -746,6 +751,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	timer_set_base(timer, base);
 	debug_timer_activate(timer);
 	internal_add_timer(base, timer);
+	trace_timer_start(timer, cpu);
 	/*
 	 * Check whether the other CPU is idle and needs to be
 	 * triggered to reevaluate the timer wheel when nohz is
@@ -914,6 +920,7 @@ static inline void __run_timers(struct tvec_base *base)
 			unsigned long data;
 
 			timer = list_first_entry(head, struct timer_list,entry);
+			trace_timer_expire(timer);
 			fn = timer->function;
 			data = timer->data;
 
-- 
1.6.1.2


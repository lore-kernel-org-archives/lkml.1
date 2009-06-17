Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbZFQJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbZFQJjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbZFQJjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:39:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55920 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932391AbZFQJjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:39:02 -0400
Message-ID: <4A38B9C7.3080802@cn.fujitsu.com>
Date: Wed, 17 Jun 2009 17:39:19 +0800
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
Subject: [PATCH v2 1/2] ftrace: add tracepoint for timer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is modify from Mathieu's patch base on Ingo's suggestion, the
original patch can be found here:
	http://marc.info/?l=linux-kernel&m=123791201816247&w=2

Great thanks to Thomas for giving me so many valuable advices.

Those tracepoints are wanted and useful:
1: We can detect a timer's delay
2: We can monitor the lifecycle and behaviors of a timer

Thus they help in analysing and debuging.

Example ftrace output:
   insmod-3743  [001] 217105.738770: timer_init: timer=e0b3e4c8
   insmod-3743  [001] 217105.738868: timer_start: timer=e0b3e4c8 func=timer_fun expires=442863 timeout=50
   <idle>-0     [001] 217105.935436: timer_expire: timer=e0b3e4c8 func=timer_fun jiffies=442863
   <idle>-0     [001] 217105.935440: timer_cancel: timer=e0b3e4c8 func=timer_fun

We expect the timer expires at 442863, after 50 jiffies, actually the timer
expires at 442863, so it is delayed by 0 jiffies.

Changelog v1->v2:
1: Add jiffies info into timer
2: Combine debugobjects and trace as Thomas's suggestion
 
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |   82 ++++++++++++++++++++++++++++++++++++++++++
 kernel/timer.c               |   33 +++++++++++++++--
 2 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 6e7beb5..e9c51ee 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -110,6 +110,88 @@ TRACE_EVENT(hrtimer_exit,
 			"HRTIMER_RESTART" : "HRTIMER_NORESTART")
 );
 
+TRACE_EVENT(timer_init,
+
+	TP_PROTO(struct timer_list *timer),
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
+TRACE_EVENT(timer_start,
+
+	TP_PROTO(struct timer_list *timer, unsigned long expires),
+
+	TP_ARGS(timer, expires),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,	function	)
+		__field( unsigned long,	expires		)
+		__field( int,		timeout		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+		__entry->expires	= expires;
+		__entry->timeout	= timer->expires - jiffies;
+	),
+
+	TP_printk("timer=%p func=%pf expires=%lu timeout=%d", __entry->timer,
+		  __entry->function, __entry->expires, __entry->timeout)
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
+		__field( void *,	function	)
+		__field( unsigned long,	jiffies		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+		__entry->jiffies	= jiffies;
+	),
+
+	TP_printk("timer=%p func=%pf jiffies=%lu", __entry->timer,
+		  __entry->function, __entry->jiffies)
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
diff --git a/kernel/timer.c b/kernel/timer.c
index d07c900..11660c7 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -521,6 +521,30 @@ static inline void debug_timer_activate(struct timer_list *timer) { }
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
 #endif
 
+static inline void debug_and_trace_timer_init(struct timer_list *timer)
+{
+	debug_timer_init(timer);
+	trace_timer_init(timer);
+}
+
+static inline void
+debug_and_trace_timer_activate(struct timer_list *timer, unsigned long expires)
+{
+	debug_timer_activate(timer);
+	trace_timer_start(timer, expires);
+}
+
+static inline void debug_and_trace_timer_expire(struct timer_list *timer)
+{
+	trace_timer_expire(timer);
+}
+
+static inline void debug_and_trace_timer_deactivate(struct timer_list *timer)
+{
+	debug_timer_deactivate(timer);
+	trace_timer_cancel(timer);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key)
@@ -549,7 +573,7 @@ void init_timer_key(struct timer_list *timer,
 		    const char *name,
 		    struct lock_class_key *key)
 {
-	debug_timer_init(timer);
+	debug_and_trace_timer_init(timer);
 	__init_timer(timer, name, key);
 }
 EXPORT_SYMBOL(init_timer_key);
@@ -568,7 +592,7 @@ static inline void detach_timer(struct timer_list *timer,
 {
 	struct list_head *entry = &timer->entry;
 
-	debug_timer_deactivate(timer);
+	debug_and_trace_timer_deactivate(timer);
 
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
@@ -629,7 +653,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 			goto out_unlock;
 	}
 
-	debug_timer_activate(timer);
+	debug_and_trace_timer_activate(timer, expires);
 
 	new_base = __get_cpu_var(tvec_bases);
 
@@ -781,7 +805,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
-	debug_timer_activate(timer);
+	debug_and_trace_timer_activate(timer, timer->expires);
 	internal_add_timer(base, timer);
 	/*
 	 * Check whether the other CPU is idle and needs to be
@@ -952,6 +976,7 @@ static inline void __run_timers(struct tvec_base *base)
 			unsigned long data;
 
 			timer = list_first_entry(head, struct timer_list,entry);
+			debug_and_trace_timer_expire(timer);
 			fn = timer->function;
 			data = timer->data;
 
-- 
1.6.1.2



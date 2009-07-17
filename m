Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbZGQKRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbZGQKRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934360AbZGQKRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:17:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63042 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934353AbZGQKRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:17:01 -0400
Message-ID: <4A604F9B.8010204@cn.fujitsu.com>
Date: Fri, 17 Jul 2009 18:16:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/4] ftrace: add tracepoint for timer
References: <4A604E46.5050903@cn.fujitsu.com>
In-Reply-To: <4A604E46.5050903@cn.fujitsu.com>
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
  insmod-1712  [000]   145.901459: timer_init: timer=d0ace4b4
  insmod-1712  [000]   145.901469: timer_start: timer=d0ace4b4 func=timer_fun expires=4294813629 timeout=199
  <idle>-0     [000]   146.100230: timer_cancel: timer=d0ace4b4
  <idle>-0     [000]   146.100233: timer_expire: timer=d0ace4b4 jiffies=4294813629
  <idle>-0     [000]   146.100627: timer_callback_done: func=d0ace4b4

We expect the timer expires at 4294813629, after 199 jiffies, actually the
timer expires at 4294813629, so it is delayed by 0 jiffies.
We also realize the timer's callback started at 146.100233, and it finished
at 146.100627, so it's taking 146.100627-146.100233=0.4ms.
 
Changelog:
v1->v2:
1: Add jiffies info into timer
2: Combine debugobjects and trace as Thomas's suggestion
v2->v3:
1: Remove function address from timer_expire and timer_cancel
   as Thomas's suggestion
2: Remove debug_and_trace_timer_expire() as Thomas's suggestion
3: Rename trace_timer_entry() and trace_timer_exit() to match this patch

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |   84 ++++++++++++++++++++++++++++++++++++------
 kernel/timer.c               |   31 ++++++++++++---
 2 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index ff2754a..967e225 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -8,52 +8,112 @@
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 
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
 /**
- * timer_entry - called immediately before the timer callback
+ * timer_expire - called immediately before the timer callback
  * @timer: pointer to struct timer_list
  *
- * When used in combination with the timer_exit tracepoint we can
+ * When used in combination with the timer_callback_done tracepoint we can
  * determine the timer latency.
  **/
-TRACE_EVENT(timer_entry,
+TRACE_EVENT(timer_expire,
 
 	TP_PROTO(struct timer_list *timer),
 
 	TP_ARGS(timer),
 
 	TP_STRUCT__entry(
-		__field(void *, function)
+		__field( void *,	timer	)
+		__field( unsigned long,	jiffies	)
 	),
 
 	TP_fast_assign(
-		__entry->function = timer->function;
+		__entry->timer		= timer;
+		__entry->jiffies	= jiffies;
 	),
 
-	TP_printk("func=%pf", __entry->function)
+	TP_printk("timer=%p jiffies=%lu", __entry->timer, __entry->jiffies)
 );
 
 /**
- * timer_exit - called immediately after the timer returns
+ * timer_callback_done - called immediately after the timer returns
  * @timer: pointer to struct timer_list
  *
- * When used in combination with the timer_entry tracepoint we can
+ * When used in combination with the timer_expire tracepoint we can
  * determine the timer latency.
  **/
-TRACE_EVENT(timer_exit,
+TRACE_EVENT(timer_callback_done,
 
 	TP_PROTO(struct timer_list *timer),
 
 	TP_ARGS(timer),
 
 	TP_STRUCT__entry(
-		__field(void *, function)
+		__field(void *,	timer	)
 	),
 
 	TP_fast_assign(
-		__entry->function = timer->function;
+		__entry->timer	= timer;
 	),
 
-	TP_printk("func=%pf", __entry->function)
+	TP_printk("func=%p", __entry->timer)
+);
+
+TRACE_EVENT(timer_cancel,
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
 );
 
 /**
diff --git a/kernel/timer.c b/kernel/timer.c
index 9385ad5..0f53710 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -523,6 +523,25 @@ static inline void debug_timer_activate(struct timer_list *timer) { }
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
+static inline void debug_and_trace_timer_deactivate(struct timer_list *timer)
+{
+	debug_timer_deactivate(timer);
+	trace_timer_cancel(timer);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key)
@@ -551,7 +570,7 @@ void init_timer_key(struct timer_list *timer,
 		    const char *name,
 		    struct lock_class_key *key)
 {
-	debug_timer_init(timer);
+	debug_and_trace_timer_init(timer);
 	__init_timer(timer, name, key);
 }
 EXPORT_SYMBOL(init_timer_key);
@@ -570,7 +589,7 @@ static inline void detach_timer(struct timer_list *timer,
 {
 	struct list_head *entry = &timer->entry;
 
-	debug_timer_deactivate(timer);
+	debug_and_trace_timer_deactivate(timer);
 
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
@@ -631,7 +650,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 			goto out_unlock;
 	}
 
-	debug_timer_activate(timer);
+	debug_and_trace_timer_activate(timer, expires);
 
 	new_base = __get_cpu_var(tvec_bases);
 
@@ -783,7 +802,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
-	debug_timer_activate(timer);
+	debug_and_trace_timer_activate(timer, timer->expires);
 	internal_add_timer(base, timer);
 	/*
 	 * Check whether the other CPU is idle and needs to be
@@ -987,9 +1006,9 @@ static inline void __run_timers(struct tvec_base *base)
 				 */
 				lock_map_acquire(&lockdep_map);
 
-				trace_timer_entry(timer);
+				trace_timer_expire(timer);
 				fn(data);
-				trace_timer_exit(timer);
+				trace_timer_callback_done(timer);
 
 				lock_map_release(&lockdep_map);
 
-- 
1.6.1.2



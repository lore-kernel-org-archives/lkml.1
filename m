Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbZIBMTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbZIBMTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 08:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZIBMTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 08:19:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:39682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZIBMTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 08:19:02 -0400
Date: Wed, 2 Sep 2009 12:18:19 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
       peterz@infradead.org, zhaolei@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4A7F8A9B.3040201@cn.fujitsu.com>
References: <4A7F8A9B.3040201@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/tracing] timers: Add tracepoints for timer_list timers
Message-ID: <tip-2b022e3d4bf9885f781221c59d86283a2cdfc2ed@git.kernel.org>
Git-Commit-ID: 2b022e3d4bf9885f781221c59d86283a2cdfc2ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 12:18:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b022e3d4bf9885f781221c59d86283a2cdfc2ed
Gitweb:     http://git.kernel.org/tip/2b022e3d4bf9885f781221c59d86283a2cdfc2ed
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 10 Aug 2009 10:48:59 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 29 Aug 2009 14:10:06 +0200

timers: Add tracepoints for timer_list timers

Add tracepoints which cover the timer life cycle. The tracepoints are
integrated with the already existing debug_object debug points as far
as possible.

Based on patches from 
Mathieu: http://marc.info/?l=linux-kernel&m=123791201816247&w=2
and 
Anton: http://marc.info/?l=linux-kernel&m=124331396919301&w=2

[ tglx: Fixed timeout value in timer_start tracepoint, massaged
  comments and made the printk's more readable ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
LKML-Reference: <4A7F8A9B.3040201@cn.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/trace/events/timer.h |  137 ++++++++++++++++++++++++++++++++++++++++++
 kernel/timer.c               |   32 +++++++++-
 2 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
new file mode 100644
index 0000000..725892a
--- /dev/null
+++ b/include/trace/events/timer.h
@@ -0,0 +1,137 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM timer
+
+#if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TIMER_H
+
+#include <linux/tracepoint.h>
+#include <linux/timer.h>
+
+/**
+ * timer_init - called when the timer is initialized
+ * @timer:	pointer to struct timer_list
+ */
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
+	TP_printk("timer %p", __entry->timer)
+);
+
+/**
+ * timer_start - called when the timer is started
+ * @timer:	pointer to struct timer_list
+ * @expires:	the timers expiry time
+ */
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
+		__field( unsigned long,	now		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+		__entry->expires	= expires;
+		__entry->now		= jiffies;
+	),
+
+	TP_printk("timer %p: func %pf, expires %lu, timeout %ld",
+		  __entry->timer, __entry->function, __entry->expires,
+		  (long)__entry->expires - __entry->now)
+);
+
+/**
+ * timer_expire_entry - called immediately before the timer callback
+ * @timer:	pointer to struct timer_list
+ *
+ * Allows to determine the timer latency.
+ */
+TRACE_EVENT(timer_expire_entry,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+		__field( unsigned long,	now	)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->now		= jiffies;
+	),
+
+	TP_printk("timer %p: now %lu", __entry->timer, __entry->now)
+);
+
+/**
+ * timer_expire_exit - called immediately after the timer callback returns
+ * @timer:	pointer to struct timer_list
+ *
+ * When used in combination with the timer_expire_entry tracepoint we can
+ * determine the runtime of the timer callback function.
+ *
+ * NOTE: Do NOT derefernce timer in TP_fast_assign. The pointer might
+ * be invalid. We solely track the pointer.
+ */
+TRACE_EVENT(timer_expire_exit,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field(void *,	timer	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+	),
+
+	TP_printk("timer %p", __entry->timer)
+);
+
+/**
+ * timer_cancel - called when the timer is canceled
+ * @timer:	pointer to struct timer_list
+ */
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
+	TP_printk("timer %p", __entry->timer)
+);
+
+#endif /*  _TRACE_TIMER_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/timer.c b/kernel/timer.c
index 8e92be6..a7352b0 100644
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
@@ -521,6 +524,25 @@ static inline void debug_timer_activate(struct timer_list *timer) { }
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
 #endif
 
+static inline void debug_init(struct timer_list *timer)
+{
+	debug_timer_init(timer);
+	trace_timer_init(timer);
+}
+
+static inline void
+debug_activate(struct timer_list *timer, unsigned long expires)
+{
+	debug_timer_activate(timer);
+	trace_timer_start(timer, expires);
+}
+
+static inline void debug_deactivate(struct timer_list *timer)
+{
+	debug_timer_deactivate(timer);
+	trace_timer_cancel(timer);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key)
@@ -549,7 +571,7 @@ void init_timer_key(struct timer_list *timer,
 		    const char *name,
 		    struct lock_class_key *key)
 {
-	debug_timer_init(timer);
+	debug_init(timer);
 	__init_timer(timer, name, key);
 }
 EXPORT_SYMBOL(init_timer_key);
@@ -568,7 +590,7 @@ static inline void detach_timer(struct timer_list *timer,
 {
 	struct list_head *entry = &timer->entry;
 
-	debug_timer_deactivate(timer);
+	debug_deactivate(timer);
 
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
@@ -632,7 +654,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 			goto out_unlock;
 	}
 
-	debug_timer_activate(timer);
+	debug_activate(timer, expires);
 
 	new_base = __get_cpu_var(tvec_bases);
 
@@ -787,7 +809,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
-	debug_timer_activate(timer);
+	debug_activate(timer, timer->expires);
 	if (time_before(timer->expires, base->next_timer) &&
 	    !tbase_get_deferrable(timer->base))
 		base->next_timer = timer->expires;
@@ -1000,7 +1022,9 @@ static inline void __run_timers(struct tvec_base *base)
 				 */
 				lock_map_acquire(&lockdep_map);
 
+				trace_timer_expire_entry(timer);
 				fn(data);
+				trace_timer_expire_exit(timer);
 
 				lock_map_release(&lockdep_map);
 

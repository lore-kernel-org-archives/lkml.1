Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZEVJxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZEVJxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbZEVJxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:53:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54439 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZEVJxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:53:43 -0400
Message-ID: <4A16764F.2040307@cn.fujitsu.com>
Date: Fri, 22 May 2009 17:54:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@elte.hu
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: [PATCH 2/3] ftrace: add tracepoint for hrtimer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch can trace hrtimer init/start/expire/cancle event

Example ftrace output:
	   <...>-3628  [001] 64228.304772: hrtimer_init: timer=e0b404cc clockid=CLOCK_REALTIME mode=HRTIMER_MODE_ABS
           <...>-3628  [001] 64228.304793: hrtimer_start: timer=e0b404cc func=test_hrtime expires=1242920654000000000 ns softexpires=1242920654000000000 ns
     ksoftirqd/1-7     [001] 64228.304858: hrtimer_expire: timer=e0b404cc func=test_hrtime
     ksoftirqd/1-7     [001] 64228.304860: hrtimer_cancel: timer=e0b404cc func=test_hrtime

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |   89 ++++++++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c             |    5 ++
 2 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index f2f60d8..e5dc9d5 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -86,6 +86,95 @@ TRACE_EVENT(timer_cancel,
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
+		__entry->timer	   = timer;
+		__entry->clockid   = clockid;
+		__entry->mode	   = mode;
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
+		__entry->expires	= ktime_to_ns(hrtimer_get_expires(timer));
+		__entry->softexpires	= ktime_to_ns(hrtimer_get_softexpires(timer));
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
+	TP_PROTO(struct hrtimer *timer),
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
+TRACE_EVENT(hrtimer_cancel,
+
+	TP_PROTO(struct hrtimer *timer),
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
+		__entry->function       = timer->function;
+	),
+
+	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
+);
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cb8a15c..d3cecdc 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/err.h>
 #include <linux/debugobjects.h>
+#include <trace/events/timer.h>
 
 #include <asm/uaccess.h>
 
@@ -832,6 +833,7 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	 * state of a possibly running callback.
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
+	trace_hrtimer_start(timer);
 
 	return leftmost;
 }
@@ -864,6 +866,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		rb_erase(&timer->node, &base->active);
 	}
 	timer->state = newstate;
+	trace_hrtimer_cancel(timer);
 }
 
 /*
@@ -1119,6 +1122,7 @@ void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 {
 	debug_hrtimer_init(timer);
 	__hrtimer_init(timer, clock_id, mode);
+	trace_hrtimer_init(timer, clock_id, mode);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
@@ -1151,6 +1155,7 @@ static void __run_hrtimer(struct hrtimer *timer)
 	WARN_ON(!irqs_disabled());
 
 	debug_hrtimer_deactivate(timer);
+	trace_hrtimer_expire(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 	fn = timer->function;
-- 
1.6.1.2


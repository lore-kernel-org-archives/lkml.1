Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZFIBsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZFIBsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZFIBrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:47:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52726 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZFIBrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:47:46 -0400
Message-Id: <20090609014746.709245674@goodmis.org>
References: <20090609014534.790466803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 08 Jun 2009 21:45:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: [RFC PATCH 3/5] tracing/events: modify irq print to new format
Content-Disposition: inline; filename=0003-tracing-events-modify-irq-print-to-new-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use new format for better parsing of irq events.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/irq.h |   35 ++++++++++++++++-------------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index b0c7ede..e1350fc 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -7,18 +7,18 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM irq
 
-#define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
-#define show_softirq_name(val)			\
-	__print_symbolic(val,			\
-			 softirq_name(HI),	\
-			 softirq_name(TIMER),	\
-			 softirq_name(NET_TX),	\
-			 softirq_name(NET_RX),	\
-			 softirq_name(BLOCK),	\
-			 softirq_name(TASKLET),	\
-			 softirq_name(SCHED),	\
-			 softirq_name(HRTIMER),	\
-			 softirq_name(RCU))
+#define softirq_name(sirq) sirq##_SOFTIRQ, #sirq
+#define show_softirq_name(val)						\
+	"%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s>",	\
+		softirq_name(HI),					\
+		softirq_name(TIMER),					\
+		softirq_name(NET_TX),					\
+		softirq_name(NET_RX),					\
+		softirq_name(BLOCK),					\
+		softirq_name(TASKLET),					\
+		softirq_name(SCHED),					\
+		softirq_name(HRTIMER),					\
+		softirq_name(RCU)
 
 /**
  * irq_handler_entry - called immediately before the irq action handler
@@ -47,7 +47,7 @@ TRACE_EVENT(irq_handler_entry,
 		__assign_str(name, action->name);
 	),
 
-	TP_printk("irq=%d handler=%s", __entry->irq, __get_str(name))
+	TP_FORMAT("irq=<int:irq> handler=<string:name>")
 );
 
 /**
@@ -77,8 +77,7 @@ TRACE_EVENT(irq_handler_exit,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("irq=%d return=%s",
-		  __entry->irq, __entry->ret ? "handled" : "unhandled")
+	TP_FORMAT("irq=<int:irq> return=<if:ret:handled:unhandled>")
 );
 
 /**
@@ -106,8 +105,7 @@ TRACE_EVENT(softirq_entry,
 		__entry->vec = (int)(h - vec);
 	),
 
-	TP_printk("softirq=%d action=%s", __entry->vec,
-		  show_softirq_name(__entry->vec))
+	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name(__entry->vec))
 );
 
 /**
@@ -135,8 +133,7 @@ TRACE_EVENT(softirq_exit,
 		__entry->vec = (int)(h - vec);
 	),
 
-	TP_printk("softirq=%d action=%s", __entry->vec,
-		  show_softirq_name(__entry->vec))
+	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name(__entry->vec))
 );
 
 #endif /*  _TRACE_IRQ_H */
-- 
1.6.3.1

-- 

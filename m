Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZFIVyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZFIVyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbZFIVxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:53:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbZFIVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:53:38 -0400
Message-Id: <20090609215339.384594898@goodmis.org>
References: <20090609215211.307980196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 17:52:15 -0400
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
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/8] tracing/events: modify irq print to new format
Content-Disposition: inline; filename=0004-tracing-events-modify-irq-print-to-new-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use new format for better parsing of irq events.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/irq.h |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index b0c7ede..c6c0ff1 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -7,18 +7,19 @@
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
+#define show_softirq_name_format(val)					\
+	"%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s>"
+#define show_softirq_name_args()					\
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
@@ -47,7 +48,7 @@ TRACE_EVENT(irq_handler_entry,
 		__assign_str(name, action->name);
 	),
 
-	TP_printk("irq=%d handler=%s", __entry->irq, __get_str(name))
+	TP_FORMAT("irq=<int:irq> handler=<string:name>")
 );
 
 /**
@@ -77,8 +78,7 @@ TRACE_EVENT(irq_handler_exit,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("irq=%d return=%s",
-		  __entry->irq, __entry->ret ? "handled" : "unhandled")
+	TP_FORMAT("irq=<int:irq> return=<if:ret:handled:unhandled>")
 );
 
 /**
@@ -106,8 +106,8 @@ TRACE_EVENT(softirq_entry,
 		__entry->vec = (int)(h - vec);
 	),
 
-	TP_printk("softirq=%d action=%s", __entry->vec,
-		  show_softirq_name(__entry->vec))
+	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name_format(),
+		  show_softirq_name_args())
 );
 
 /**
@@ -135,8 +135,8 @@ TRACE_EVENT(softirq_exit,
 		__entry->vec = (int)(h - vec);
 	),
 
-	TP_printk("softirq=%d action=%s", __entry->vec,
-		  show_softirq_name(__entry->vec))
+	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name_format(),
+		  show_softirq_name_args())
 );
 
 #endif /*  _TRACE_IRQ_H */
-- 
1.6.3.1

-- 

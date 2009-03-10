Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZCJE7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZCJE7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZCJE6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:58:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZCJE6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:58:14 -0400
Message-Id: <20090310045811.724984182@goodmis.org>
References: <20090310045710.286915983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 00:57:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/7] tracing: convert irq trace points to new macros
Content-Disposition: inline; filename=0006-tracing-convert-irq-trace-points-to-new-macros.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: enhancement

Converted the two irq trace point macros. The entry macro copies
the name of the irq handler, thus it is better to simply use the
TRACE_FORMAT macro which uses the trace_printk.

The return of the handler does not need to record the name, thus
the faster C style handler is more approriate.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/irq_event_types.h |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
index 0147d9e..43bcb74 100644
--- a/include/trace/irq_event_types.h
+++ b/include/trace/irq_event_types.h
@@ -8,26 +8,36 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM irq
 
-TRACE_EVENT_FORMAT(irq_handler_entry,
+/*
+ * Tracepoint for entry of interrupt handler:
+ */
+TRACE_FORMAT(irq_handler_entry,
 	TP_PROTO(int irq, struct irqaction *action),
 	TP_ARGS(irq, action),
-	TP_FMT("irq=%d handler=%s", irq, action->name),
-	TRACE_STRUCT(
-		TRACE_FIELD(int, irq, irq)
-	),
-	TP_RAW_FMT("irq %d")
+	TP_FMT("irq=%d handler=%s", irq, action->name)
 	);
 
-TRACE_EVENT_FORMAT(irq_handler_exit,
+/*
+ * Tracepoint for return of an interrupt handler:
+ */
+TRACE_EVENT(irq_handler_exit,
+
 	TP_PROTO(int irq, struct irqaction *action, int ret),
+
 	TP_ARGS(irq, action, ret),
-	TP_FMT("irq=%d handler=%s return=%s",
-		irq, action->name, ret ? "handled" : "unhandled"),
-	TRACE_STRUCT(
-		TRACE_FIELD(int, irq, irq)
-		TRACE_FIELD(int, ret, ret)
+
+	TP_STRUCT__entry(
+		__field(	int,	irq	)
+		__field(	int,	ret	)
 	),
-	TP_RAW_FMT("irq %d ret %d")
-	);
+
+	TP_printk("irq=%d return=%s",
+		  __entry->irq, __entry->ret ? "handled" : "unhandled"),
+
+	TP_fast_assign(
+		__entry->irq	= irq;
+		__entry->ret	= ret;
+	)
+);
 
 #undef TRACE_SYSTEM
-- 
1.6.1.3

-- 

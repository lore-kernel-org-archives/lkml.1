Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZDYE1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZDYE1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 00:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZDYE0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 00:26:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZDYE0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 00:26:32 -0400
Message-Id: <20090425042630.348109173@goodmis.org>
References: <20090425042030.431477667@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 25 Apr 2009 00:20:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/5] tracing/irq: convert irq traces to use TRACE_EVENT macro
Content-Disposition: inline; filename=0002-tracing-irq-convert-irq-traces-to-use-TRACE_EVENT-m.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The TRACE_FORMAT will soon be deprecated. This patch converts it to
the TRACE_EVENT macro.

Note, this change should also speed up the tracing.

[ Impact: remove a user of deprecated TRACE_FORMAT ]

Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/irq.h |   57 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 75e3468..7686864 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -10,11 +10,24 @@
 /*
  * Tracepoint for entry of interrupt handler:
  */
-TRACE_FORMAT(irq_handler_entry,
+TRACE_EVENT(irq_handler_entry,
+
 	TP_PROTO(int irq, struct irqaction *action),
+
 	TP_ARGS(irq, action),
-	TP_FMT("irq=%d handler=%s", irq, action->name)
-	);
+
+	TP_STRUCT__entry(
+		__field(	int,	irq		)
+		__string(	name,	action->name	)
+	),
+
+	TP_fast_assign(
+		__entry->irq = irq;
+		__assign_str(name, action->name);
+	),
+
+	TP_printk("irq=%d handler=%s", __entry->irq, __get_str(name))
+);
 
 /*
  * Tracepoint for return of an interrupt handler:
@@ -39,17 +52,43 @@ TRACE_EVENT(irq_handler_exit,
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
-TRACE_FORMAT(softirq_entry,
+TRACE_EVENT(softirq_entry,
+
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+
 	TP_ARGS(h, vec),
-	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
-	);
 
-TRACE_FORMAT(softirq_exit,
+	TP_STRUCT__entry(
+		__field(	int,	vec			)
+		__string(	name,	softirq_to_name[h-vec]	)
+	),
+
+	TP_fast_assign(
+		__entry->vec = (int)(h - vec);
+		__assign_str(name, softirq_to_name[h-vec]);
+	),
+
+	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
+);
+
+TRACE_EVENT(softirq_exit,
+
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+
 	TP_ARGS(h, vec),
-	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
-	);
+
+	TP_STRUCT__entry(
+		__field(	int,	vec			)
+		__string(	name,	softirq_to_name[h-vec]	)
+	),
+
+	TP_fast_assign(
+		__entry->vec = (int)(h - vec);
+		__assign_str(name, softirq_to_name[h-vec]);
+	),
+
+	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
+);
 
 #endif /*  _TRACE_IRQ_H */
 
-- 
1.6.2.1

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZEUDTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZEUDTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZEUDRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:17:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZEUDRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:17:50 -0400
Message-Id: <20090521031749.639465433@goodmis.org>
References: <20090521031711.494593605@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 23:17:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 5/5] tracing: convert irq events to use __print_symbolic
Content-Disposition: inline; filename=0005-tracing-convert-irq-events-to-use-__print_symbolic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The recording of the names at trace time is inefficient. This patch
implements the softirq event recording to only record the vector
and then use the __print_symbolic interface to print out the names.

[ Impact: faster recording of softirq events ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/irq.h |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 32a9f7e..683fb36 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -7,6 +7,19 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM irq
 
+#define softirq_name(sirq) { sirq, #sirq }
+#define show_softirq_name(val)						\
+	__print_symbolic(val,						\
+			 softirq_name(HI_SOFTIRQ),			\
+			 softirq_name(TIMER_SOFTIRQ),			\
+			 softirq_name(NET_TX_SOFTIRQ),			\
+			 softirq_name(NET_RX_SOFTIRQ),			\
+			 softirq_name(BLOCK_SOFTIRQ),			\
+			 softirq_name(TASKLET_SOFTIRQ),			\
+			 softirq_name(SCHED_SOFTIRQ),			\
+			 softirq_name(HRTIMER_SOFTIRQ),			\
+			 softirq_name(RCU_SOFTIRQ))
+
 /**
  * irq_handler_entry - called immediately before the irq action handler
  * @irq: irq number
@@ -87,15 +100,14 @@ TRACE_EVENT(softirq_entry,
 
 	TP_STRUCT__entry(
 		__field(	int,	vec			)
-		__string(	name,	softirq_to_name[h-vec]	)
 	),
 
 	TP_fast_assign(
 		__entry->vec = (int)(h - vec);
-		__assign_str(name, softirq_to_name[h-vec]);
 	),
 
-	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
+	TP_printk("softirq=%d action=%s", __entry->vec,
+		  show_softirq_name(__entry->vec))
 );
 
 /**
@@ -117,15 +129,14 @@ TRACE_EVENT(softirq_exit,
 
 	TP_STRUCT__entry(
 		__field(	int,	vec			)
-		__string(	name,	softirq_to_name[h-vec]	)
 	),
 
 	TP_fast_assign(
 		__entry->vec = (int)(h - vec);
-		__assign_str(name, softirq_to_name[h-vec]);
 	),
 
-	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
+	TP_printk("softirq=%d action=%s", __entry->vec,
+		  show_softirq_name(__entry->vec))
 );
 
 #endif /*  _TRACE_IRQ_H */
-- 
1.6.2.4

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbZD2RtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbZD2RtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759801AbZD2Rsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:48:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35609 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288AbZD2Rst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:48:49 -0400
Date: Wed, 29 Apr 2009 13:45:33 -0400
Message-Id: <200904291745.n3THjX3g019550@ns3.rdu.redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org,
       fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       randy.dunlap@oracle.com, wcohen@redhat.com
From: Jason Baron <jbaron@redhat.com>
Subject: [PATCH 3/3] add irq tracepoint documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Document irqs for the newly created docbook.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 Documentation/DocBook/tracepoint.tmpl |    5 +++
 include/trace/events/irq.h            |   46 ++++++++++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
index 2639a8b..8b7fb48 100644
--- a/Documentation/DocBook/tracepoint.tmpl
+++ b/Documentation/DocBook/tracepoint.tmpl
@@ -81,4 +81,9 @@
    </para>
   </chapter>
 
+  <chapter id="irq">
+   <title>IRQ</title>
+!Iinclude/trace/events/irq.h
+  </chapter>
+
 </book>
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 7686864..bb5bbec 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -7,8 +7,16 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM irq
 
-/*
- * Tracepoint for entry of interrupt handler:
+/**
+ * irq_handler_entry - called immediately before the irq action handler
+ * @irq: irq number
+ * @action: pointer to struct irqaction
+ *
+ * The struct irqaction pointed to by the 'action' parameter contains
+ * various information about the handler, including the device name,
+ * action->name, and the device id, action->dev_id. When used in
+ * conjunction with the irq_handler_exit tracepoint, we can figure
+ * out irq handler latencies.
  */
 TRACE_EVENT(irq_handler_entry,
 
@@ -29,8 +37,16 @@ TRACE_EVENT(irq_handler_entry,
 	TP_printk("irq=%d handler=%s", __entry->irq, __get_str(name))
 );
 
-/*
- * Tracepoint for return of an interrupt handler:
+/**
+ * irq_handler_exit - called immediately after the irq action handler returns
+ * @irq: irq number
+ * @action: pointer to struct irqaction
+ * @ret: return value
+ *
+ * If the 'ret' value is set to IRQ_HANDLED, then we know that the corresponding
+ * action->handler scuccessully handled this irq. Otherwise, the irq might be
+ * a shared irq line, or the irq was not handled successfully. Can be used in
+ * conjunction with the irq_handler_entry to understand irq handler latencies.
  */
 TRACE_EVENT(irq_handler_exit,
 
@@ -52,6 +68,17 @@ TRACE_EVENT(irq_handler_exit,
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
+/**
+ * softirq_entry - called immediately before the softirq handler
+ * @h: pointer to struct softirq_action
+ * @vec: pointer to first struct softirq_action in softirq_vec array
+ *
+ * The 'h' parameter, contains a pointer to the struct softirq_action
+ * which has a pointer to the action handler that is called. By subtracting
+ * the 'vec' pointer from the 'h' pointer, we can determine the softirq
+ * number. Also, when used in combination with the softirq_exit tracepoint
+ * we can determine the softirq latency.
+ */
 TRACE_EVENT(softirq_entry,
 
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
@@ -71,6 +98,17 @@ TRACE_EVENT(softirq_entry,
 	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
 );
 
+/**
+ * softirq_exit - called immediately after the softirq handler returns
+ * @h: pointer to struct softirq_action
+ * @vec: pointer to first struct softirq_action in softirq_vec array
+ *
+ * The 'h' parameter contains a pointer to the struct softirq_action
+ * that has handled the softirq. By subtracting the 'vec' pointer from
+ * the 'h' pointer, we can determine the softirq number. Also, when used in
+ * combination with the softirq_exit tracepoint we can determine the softirq
+ * latency.
+ */
 TRACE_EVENT(softirq_exit,
 
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
-- 
1.5.4.5


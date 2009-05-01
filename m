Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbZEANb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbZEANb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762065AbZEAN30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:29:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:58541 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761919AbZEAN3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:29:24 -0400
Date: Fri, 1 May 2009 13:28:47 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbaron@redhat.com, tglx@linutronix.de, randy.dunlap@oracle.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jbaron@redhat.com, randy.dunlap@oracle.com,
       mingo@elte.hu
In-Reply-To: <73ff42be3420157667ec548e9b0e409c3cfad05f.1241107197.git.jbaron@redhat.com>
References: <73ff42be3420157667ec548e9b0e409c3cfad05f.1241107197.git.jbaron@redhat.com>
Subject: [tip:tracing/core] tracing: add irq tracepoint documentation
Message-ID: <tip-9ee1983c9aa18f12388ef660d0c76a23dc112959@git.kernel.org>
Git-Commit-ID: 9ee1983c9aa18f12388ef660d0c76a23dc112959
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 13:28:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ee1983c9aa18f12388ef660d0c76a23dc112959
Gitweb:     http://git.kernel.org/tip/9ee1983c9aa18f12388ef660d0c76a23dc112959
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Thu, 30 Apr 2009 13:29:47 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 May 2009 14:03:36 +0200

tracing: add irq tracepoint documentation

Document irqs for the newly created docbook.

[ Impact: add documentation ]

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org
Cc: rostedt@goodmis.org
Cc: fweisbec@gmail.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: wcohen@redhat.com
LKML-Reference: <73ff42be3420157667ec548e9b0e409c3cfad05f.1241107197.git.jbaron@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/DocBook/tracepoint.tmpl |    5 +++
 include/trace/events/irq.h            |   46 ++++++++++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
index 70891bc..b0756d0 100644
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
index 7686864..32a9f7e 100644
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
+ * The struct irqaction pointed to by @action contains various
+ * information about the handler, including the device name,
+ * @action->name, and the device id, @action->dev_id. When used in
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
+ * If the @ret value is set to IRQ_HANDLED, then we know that the corresponding
+ * @action->handler scuccessully handled this irq. Otherwise, the irq might be
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
+ * The @h parameter, contains a pointer to the struct softirq_action
+ * which has a pointer to the action handler that is called. By subtracting
+ * the @vec pointer from the @h pointer, we can determine the softirq
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
+ * The @h parameter contains a pointer to the struct softirq_action
+ * that has handled the softirq. By subtracting the @vec pointer from
+ * the @h pointer, we can determine the softirq number. Also, when used in
+ * combination with the softirq_entry tracepoint we can determine the softirq
+ * latency.
+ */
 TRACE_EVENT(softirq_exit,
 
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),

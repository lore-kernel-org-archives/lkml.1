Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZEZEib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZEZEib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZEZEiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:38:13 -0400
Received: from ozlabs.org ([203.10.76.45]:43359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbZEZEiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:38:12 -0400
Date: Tue, 26 May 2009 14:36:58 +1000
From: Anton Blanchard <anton@samba.org>
To: rostedt@goodmis.org, mingo@elte.hu, tzanussi@gmail.com, jbaron@redhat.com,
       tglx@linutronix.de, fweisbec@gmail.com, kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: tracing/events: Add tasklet tracepoints
Message-ID: <20090526043658.GE19728@kryten>
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten> <20090526043123.GC19728@kryten> <20090526043257.GD19728@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526043257.GD19728@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add tracepoints for tasklets. We add entry and exit tracepoints so we can
calculate tasklet latency.

Example ftrace output:

<idle>-0     [000]   327.349213: tasklet_entry: func=.rpavscsi_task
<idle>-0     [000]   327.349217: tasklet_exit: func=.rpavscsi_task

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-master/kernel/softirq.c
===================================================================
--- linux-2.6-master.orig/kernel/softirq.c	2009-05-26 13:56:58.000000000 +1000
+++ linux-2.6-master/kernel/softirq.c	2009-05-26 13:57:46.000000000 +1000
@@ -412,7 +412,9 @@
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				trace_tasklet_entry(t);
 				t->func(t->data);
+				trace_tasklet_exit(t);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -447,7 +449,9 @@
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				trace_tasklet_entry(t);
 				t->func(t->data);
+				trace_tasklet_exit(t);
 				tasklet_unlock(t);
 				continue;
 			}
Index: linux-2.6-master/include/trace/events/irq.h
===================================================================
--- linux-2.6-master.orig/include/trace/events/irq.h	2009-05-26 13:56:58.000000000 +1000
+++ linux-2.6-master/include/trace/events/irq.h	2009-05-26 14:35:09.000000000 +1000
@@ -128,6 +128,54 @@
 	TP_printk("softirq=%d action=%s", __entry->vec, __get_str(name))
 );
 
+/**
+ * tasklet_entry - called immediately before the tasklet handler
+ * @t: pointer to struct tasklet_struct
+ *
+ * When used in combination with the tasklet_exit tracepoint we can
+ * determine the tasklet latency.
+ */
+TRACE_EVENT(tasklet_entry,
+
+	TP_PROTO(struct tasklet_struct *t),
+
+	TP_ARGS(t),
+
+	TP_STRUCT__entry(
+		__field(void *, func)
+	),
+
+	TP_fast_assign(
+		__entry->func = t->func;
+	),
+
+	TP_printk("func=%pf", __entry->func)
+);
+
+/**
+ * tasklet_exit - called immediately after the tasklet handler returns
+ * @t: pointer to struct tasklet_struct
+ *
+ * When used in combination with the tasklet_entry tracepoint we can
+ * determine the tasklet latency.
+ */
+TRACE_EVENT(tasklet_exit,
+
+	TP_PROTO(struct tasklet_struct *t),
+
+	TP_ARGS(t),
+
+	TP_STRUCT__entry(
+		__field(void *, func)
+	),
+
+	TP_fast_assign(
+		__entry->func = t->func;
+	),
+
+	TP_printk("func=%pf", __entry->func)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */

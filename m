Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbZKZInm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbZKZInm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759992AbZKZInk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:43:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:58685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbZKZInh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:43:37 -0500
Date: Thu, 26 Nov 2009 08:43:04 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0E287F.4030708@cn.fujitsu.com>
References: <4B0E287F.4030708@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert softirq events to DEFINE_EVENT
Message-ID: <tip-c467307c1a812c3150b27a68c2b2d3397bb40a4f@git.kernel.org>
Git-Commit-ID: c467307c1a812c3150b27a68c2b2d3397bb40a4f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c467307c1a812c3150b27a68c2b2d3397bb40a4f
Gitweb:     http://git.kernel.org/tip/c467307c1a812c3150b27a68c2b2d3397bb40a4f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:04:31 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:03 +0100

tracing: Convert softirq events to DEFINE_EVENT

Use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
  12781     952      36   13769    35c9 kernel/softirq.o.old
  11981     952      32   12965    32a5 kernel/softirq.o

Two events are converted:

  softirq: softirq_entry, softirq_exit

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0E287F.4030708@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/irq.h |   46 ++++++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index dcfcd44..0e4cfb6 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -82,18 +82,7 @@ TRACE_EVENT(irq_handler_exit,
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
-/**
- * softirq_entry - called immediately before the softirq handler
- * @h: pointer to struct softirq_action
- * @vec: pointer to first struct softirq_action in softirq_vec array
- *
- * The @h parameter, contains a pointer to the struct softirq_action
- * which has a pointer to the action handler that is called. By subtracting
- * the @vec pointer from the @h pointer, we can determine the softirq
- * number. Also, when used in combination with the softirq_exit tracepoint
- * we can determine the softirq latency.
- */
-TRACE_EVENT(softirq_entry,
+DECLARE_EVENT_CLASS(softirq,
 
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
 
@@ -112,6 +101,24 @@ TRACE_EVENT(softirq_entry,
 );
 
 /**
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
+DEFINE_EVENT(softirq, softirq_entry,
+
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+
+	TP_ARGS(h, vec)
+);
+
+/**
  * softirq_exit - called immediately after the softirq handler returns
  * @h: pointer to struct softirq_action
  * @vec: pointer to first struct softirq_action in softirq_vec array
@@ -122,22 +129,11 @@ TRACE_EVENT(softirq_entry,
  * combination with the softirq_entry tracepoint we can determine the softirq
  * latency.
  */
-TRACE_EVENT(softirq_exit,
+DEFINE_EVENT(softirq, softirq_exit,
 
 	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
 
-	TP_ARGS(h, vec),
-
-	TP_STRUCT__entry(
-		__field(	int,	vec			)
-	),
-
-	TP_fast_assign(
-		__entry->vec = (int)(h - vec);
-	),
-
-	TP_printk("vec=%d [action=%s]", __entry->vec,
-		  show_softirq_name(__entry->vec))
+	TP_ARGS(h, vec)
 );
 
 #endif /*  _TRACE_IRQ_H */

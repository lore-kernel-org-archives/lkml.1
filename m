Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZKZHEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZKZHEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbZKZHEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:04:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62454 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758583AbZKZHEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:04:53 -0500
Message-ID: <4B0E287F.4030708@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:04:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] tracing: Convert softirq events to DEFINE_EVENT
References: <4B0E2807.4060102@cn.fujitsu.com>
In-Reply-To: <4B0E2807.4060102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TRACE_EVENT_TEMPLATE to remove duplicate code:

   text    data     bss     dec     hex filename
  12781     952      36   13769    35c9 kernel/softirq.o.old
  11981     952      32   12965    32a5 kernel/softirq.o

Two events are converted:

  softirq: softirq_entry, softirq_exit

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/irq.h |   46 ++++++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index dcfcd44..f8a94d7 100644
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
+TRACE_EVENT_TEMPLATE(softirq,
 
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
-- 
1.6.3


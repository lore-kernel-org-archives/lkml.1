Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbZCMCnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbZCMCnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbZCMCij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65360 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbZCMCi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:29 -0400
Message-Id: <20090313023827.595432605@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 13/16] tracing: tracepoints for softirq entry/exit - tracepoints
Content-Disposition: inline; filename=0013-tracing-tracepoints-for-softirq-entry-exit-tracep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Introduce softirq entry/exit tracepoints. These are useful for
augmenting existing tracers, and to figure out softirq frequencies and
timings.

[
  s/irq_softirq_/softirq_/ for trace point names and
  Fixed printf format in TRACE_FORMAT macro
   - Steven Rostedt
]

LKML-Reference: <20090312183603.GC3352@redhat.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/irq_event_types.h |   12 ++++++++++++
 kernel/softirq.c                |    7 ++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
index 214bb92..85964eb 100644
--- a/include/trace/irq_event_types.h
+++ b/include/trace/irq_event_types.h
@@ -40,4 +40,16 @@ TRACE_EVENT(irq_handler_exit,
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
+TRACE_FORMAT(softirq_entry,
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_ARGS(h, vec),
+	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
+	);
+
+TRACE_FORMAT(softirq_exit,
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_ARGS(h, vec),
+	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
+	);
+
 #undef TRACE_SYSTEM
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 9f90fdc..a5e8123 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -24,6 +24,7 @@
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <trace/irq.h>
 
 #include <asm/irq.h>
 /*
@@ -186,6 +187,9 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  */
 #define MAX_SOFTIRQ_RESTART 10
 
+DEFINE_TRACE(softirq_entry);
+DEFINE_TRACE(softirq_exit);
+
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
@@ -212,8 +216,9 @@ restart:
 		if (pending & 1) {
 			int prev_count = preempt_count();
 
+			trace_softirq_entry(h, softirq_vec);
 			h->action(h);
-
+			trace_softirq_exit(h, softirq_vec);
 			if (unlikely(prev_count != preempt_count())) {
 				printk(KERN_ERR "huh, entered softirq %td %s %p"
 				       "with preempt_count %08x,"
-- 
1.6.1.3

-- 

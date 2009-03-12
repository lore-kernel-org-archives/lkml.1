Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbZCLSiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbZCLSiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZCLSiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:38:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbZCLSiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:38:01 -0400
Date: Thu, 12 Mar 2009 14:36:03 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
       fche@redhat.com, peterz@infradead.org, compudj@krystal.dyndns.org
Subject: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
Message-ID: <20090312183603.GC3352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


introduce softirq entry/exit tracepoints. These are useful for
augmenting existing tracers, and to figure out softirq frequencies and
timings.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 include/trace/irq_event_types.h |   12 ++++++++++++
 kernel/softirq.c                |    7 ++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)


diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
index 214bb92..38b4bdd 100644
--- a/include/trace/irq_event_types.h
+++ b/include/trace/irq_event_types.h
@@ -40,4 +40,16 @@ TRACE_EVENT(irq_handler_exit,
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
+TRACE_FORMAT(irq_softirq_entry,
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_ARGS(h, vec),
+	TP_FMT("softirq=%d action=%s", h - vec, softirq_to_name[h-vec])
+	);
+
+TRACE_FORMAT(irq_softirq_exit,
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+	TP_ARGS(h, vec),
+	TP_FMT("softirq=%d action=%s", h - vec, softirq_to_name[h-vec])
+	);
+
 #undef TRACE_SYSTEM
diff --git a/kernel/softirq.c b/kernel/softirq.c
index ba1511f..c378d53 100644
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
 
+DEFINE_TRACE(irq_softirq_entry);
+DEFINE_TRACE(irq_softirq_exit);
+
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
@@ -212,8 +216,9 @@ restart:
 		if (pending & 1) {
 			int prev_count = preempt_count();
 
+			trace_irq_softirq_entry(h, softirq_vec);
 			h->action(h);
-
+			trace_irq_softirq_exit(h, softirq_vec);
 			if (unlikely(prev_count != preempt_count())) {
 				printk(KERN_ERR "huh, entered softirq %td %s %p"
 				       "with preempt_count %08x,"

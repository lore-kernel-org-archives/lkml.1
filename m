Return-Path: <linux-kernel-owner+w=401wt.eu-S1750950AbZCMEEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950AbZCMEEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZCMEDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:03:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:38071 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbZCMEDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:03:45 -0400
Date: Fri, 13 Mar 2009 04:03:06 GMT
From: Jason Baron <jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <20090312183603.GC3352@redhat.com>
References: <20090312183603.GC3352@redhat.com>
Subject: [tip:tracing/ftrace] tracing: tracepoints for softirq entry/exit - tracepoints
Message-ID: <tip-39842323ceb368d2ea36ab7696aedbe296e13b61@git.kernel.org>
Git-Commit-ID: 39842323ceb368d2ea36ab7696aedbe296e13b61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 04:03:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39842323ceb368d2ea36ab7696aedbe296e13b61
Gitweb:     http://git.kernel.org/tip/39842323ceb368d2ea36ab7696aedbe296e13b61
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Thu, 12 Mar 2009 14:36:03 -0400
Commit:     Steven Rostedt <srostedt@redhat.com>
CommitDate: Thu, 12 Mar 2009 21:20:58 -0400

tracing: tracepoints for softirq entry/exit - tracepoints

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

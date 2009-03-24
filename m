Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbZCXQ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbZCXQ2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932155AbZCXQ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:26:41 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41883 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbZCXQ0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:26:40 -0400
Message-Id: <20090324160148.238795468@polymtl.ca>
References: <20090324155625.420966314@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 11:56:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 3/9] LTTng instrumentation tasklets
Content-Disposition: inline; filename=lttng-instrumentation-tasklets.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 24 Mar 2009 16:22:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklet entry and exit events.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jason Baron <jbaron@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/trace/irq.h |   13 +++++++++++++
 kernel/softirq.c    |   10 ++++++++++
 2 files changed, 23 insertions(+)

Index: linux-2.6-lttng/kernel/softirq.c
===================================================================
--- linux-2.6-lttng.orig/kernel/softirq.c	2009-03-24 11:46:28.000000000 -0400
+++ linux-2.6-lttng/kernel/softirq.c	2009-03-24 11:48:36.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <trace/irq.h>
 
 #include <asm/irq.h>
 /*
@@ -52,6 +53,11 @@ static struct softirq_action softirq_vec
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
+DEFINE_TRACE(irq_tasklet_high_entry);
+DEFINE_TRACE(irq_tasklet_high_exit);
+DEFINE_TRACE(irq_tasklet_low_entry);
+DEFINE_TRACE(irq_tasklet_low_exit);
+
 /*
  * we cannot loop indefinitely here to avoid userspace starvation,
  * but we also don't want to introduce a worst case 1/HZ latency
@@ -380,7 +386,9 @@ static void tasklet_action(struct softir
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				trace_irq_tasklet_low_entry(t);
 				t->func(t->data);
+				trace_irq_tasklet_low_exit(t);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -415,7 +423,9 @@ static void tasklet_hi_action(struct sof
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				trace_irq_tasklet_high_entry(t);
 				t->func(t->data);
+				trace_irq_tasklet_high_exit(t);
 				tasklet_unlock(t);
 				continue;
 			}
Index: linux-2.6-lttng/include/trace/irq.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/irq.h	2009-03-24 11:46:29.000000000 -0400
+++ linux-2.6-lttng/include/trace/irq.h	2009-03-24 11:48:36.000000000 -0400
@@ -19,4 +19,17 @@ DECLARE_TRACE(irq_next_handler,
 	TPPROTO(unsigned int id, struct irqaction *action, irqreturn_t ret),
 		TPARGS(id, action, ret));
 
+DECLARE_TRACE(irq_tasklet_low_entry,
+	TPPROTO(struct tasklet_struct *t),
+		TPARGS(t));
+DECLARE_TRACE(irq_tasklet_low_exit,
+	TPPROTO(struct tasklet_struct *t),
+		TPARGS(t));
+DECLARE_TRACE(irq_tasklet_high_entry,
+	TPPROTO(struct tasklet_struct *t),
+		TPARGS(t));
+DECLARE_TRACE(irq_tasklet_high_exit,
+	TPPROTO(struct tasklet_struct *t),
+		TPARGS(t));
+
 #endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

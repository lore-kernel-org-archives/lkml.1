Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbZCXQ2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbZCXQ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762950AbZCXQ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:26:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41916 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbZCXQ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:26:42 -0400
Message-Id: <20090324160148.080628193@polymtl.ca>
References: <20090324155625.420966314@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 11:56:27 -0400
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
Subject: [patch 2/9] LTTng instrumentation - irq
Content-Disposition: inline; filename=lttng-instrumentation-irq.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 24 Mar 2009 16:22:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrumentation of IRQ related events : irq_entry, irq_exit and
irq_next_handler.

It allows tracers to perform latency analysis on those various types of
interrupts and to detect interrupts with max/min/avg duration. It helps
detecting driver or hardware problems which cause an ISR to take ages to
execute. It has been shown to be the case with bogus hardware causing an mmio
read to take a few milliseconds.

Those tracepoints are used by LTTng.

About the performance impact of tracepoints (which is comparable to markers),
even without immediate values optimizations, tests done by Hideo Aoki on ia64
show no regression. His test case was using hackbench on a kernel where
scheduler instrumentation (about 5 events in code scheduler code) was added.
See the "Tracepoints" patch header for performance result detail.

irq_entry and irq_exit not declared static because they appear in x86 arch code.

The idea behind logging irq/softirq/tasklet/(and eventually syscall) entry and
exit events is to be able to recreate the kernel execution state at a given
point in time. Knowing which execution context is responsible for a given trace
event is _very_ valuable in trace data analysis.

The IRQ instrumentation instruments the IRQ handler entry and exit. Jason
instrumented the irq notifier chain calls (irq_handler_entry/exit). His approach
provides information about which handler is being called, but does not map
correctly to the fact that _multiple_ handlers are being called from within the
same interrupt handler. From an interrupt latency analysis POV, this is
incorrect.

I propose we save the "action" in the irq_entry, and use the irq exit "retval"
to know the return value of the last interrupt handler. So in common cases where
only one interrupt handler is connected to an interrupt line, we only have 2
events. Then we also add a irq_next_handler, which saves the previous interrupt
handler return value and the next handler action when there are more than 1
handler called. That would generate the minimum amount of traffic to save all
the information both Jason and I need.

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
 include/trace/irq.h |   22 ++++++++++++++++++++++
 kernel/irq/handle.c |   45 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 59 insertions(+), 8 deletions(-)

Index: linux-2.6-lttng/kernel/irq/handle.c
===================================================================
--- linux-2.6-lttng.orig/kernel/irq/handle.c	2009-03-24 10:10:36.000000000 -0400
+++ linux-2.6-lttng/kernel/irq/handle.c	2009-03-24 11:35:55.000000000 -0400
@@ -17,10 +17,18 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
+#include <trace/irq.h>
 
 #include "internals.h"
 
 /*
+ * Also used in architecture-specific code.
+ */
+DEFINE_TRACE(irq_entry);
+DEFINE_TRACE(irq_exit);
+DEFINE_TRACE(irq_next_handler);
+
+/*
  * lockdep: we want to handle all irq_desc locks as a single lock-class:
  */
 struct lock_class_key irq_desc_lock_class;
@@ -316,6 +324,19 @@ irqreturn_t no_action(int cpl, void *dev
 	return IRQ_NONE;
 }
 
+static irqreturn_t __handle_irq_next_handler(unsigned int irq,
+	struct irqaction **action, irqreturn_t *retval, unsigned int *status)
+{
+	irqreturn_t ret;
+
+	ret = (*action)->handler(irq, (*action)->dev_id);
+	if (ret == IRQ_HANDLED)
+		*status |= (*action)->flags;
+	*retval |= ret;
+	*action = (*action)->next;
+	return ret;
+}
+
 static irqreturn_t _handle_IRQ_event(unsigned int irq, struct irqaction *action)
 {
 	irqreturn_t ret, retval = IRQ_NONE;
@@ -324,13 +345,12 @@ static irqreturn_t _handle_IRQ_event(uns
 	if (!(action->flags & IRQF_DISABLED))
 		local_irq_enable_in_hardirq();
 
-	do {
-		ret = action->handler(irq, action->dev_id);
-		if (ret == IRQ_HANDLED)
-			status |= action->flags;
-		retval |= ret;
-		action = action->next;
-	} while (action);
+	ret = __handle_irq_next_handler(irq, &action, &retval, &status);
+
+	while (action) {
+		trace_irq_next_handler(irq, action, ret);
+		ret = __handle_irq_next_handler(irq, &action, &retval, &status);
+	}
 
 	if (status & IRQF_SAMPLE_RANDOM)
 		add_interrupt_randomness(irq);
@@ -348,7 +368,12 @@ static irqreturn_t _handle_IRQ_event(uns
  */
 irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 {
-	return _handle_IRQ_event(irq, action);
+	irqreturn_t ret;
+
+	trace_irq_entry(irq, NULL, action);
+	ret = _handle_IRQ_event(irq, action);
+	trace_irq_exit(ret);
+	return ret;
 }
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
@@ -383,7 +408,9 @@ unsigned int __do_IRQ(unsigned int irq)
 			desc = irq_remap_to_desc(irq, desc);
 		}
 		if (likely(!(desc->status & IRQ_DISABLED))) {
+			trace_irq_entry(irq, NULL, desc->action);
 			action_ret = _handle_IRQ_event(irq, desc->action);
+			trace_irq_exit(action_ret);
 			if (!noirqdebug)
 				note_interrupt(irq, desc, action_ret);
 		}
@@ -439,7 +466,9 @@ unsigned int __do_IRQ(unsigned int irq)
 
 		spin_unlock(&desc->lock);
 
+		trace_irq_entry(irq, NULL, action);
 		action_ret = _handle_IRQ_event(irq, action);
+		trace_irq_exit(action_ret);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 
Index: linux-2.6-lttng/include/trace/irq.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/trace/irq.h	2009-03-24 11:48:58.000000000 -0400
@@ -0,0 +1,22 @@
+#ifndef _TRACE_IRQ_H
+#define _TRACE_IRQ_H
+
+#include <linux/kdebug.h>
+#include <linux/interrupt.h>
+#include <linux/tracepoint.h>
+
+/*
+ * action can be NULL if not available.
+ */
+DECLARE_TRACE(irq_entry,
+	TPPROTO(unsigned int id, struct pt_regs *regs,
+			struct irqaction *action),
+		TPARGS(id, regs, action));
+DECLARE_TRACE(irq_exit,
+	TPPROTO(irqreturn_t retval),
+		TPARGS(retval));
+DECLARE_TRACE(irq_next_handler,
+	TPPROTO(unsigned int id, struct irqaction *action, irqreturn_t ret),
+		TPARGS(id, action, ret));
+
+#endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbYGIPFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbYGIPFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYGIPDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:03:38 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41342 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854AbYGIPDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:03:36 -0400
Message-Id: <20080709150044.698254444@polymtl.ca>
References: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 04/15] LTTng instrumentation - irq
Content-Disposition: inline; filename=lttng-instrumentation-irq.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrumentation of IRQ related events : irq, softirq, tasklet entry and exit and
softirq "raise" events.

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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/irq-trace.h  |   36 ++++++++++++++++++++++++++++++++++++
 kernel/irq/handle.c |    6 ++++++
 kernel/softirq.c    |    8 ++++++++
 3 files changed, 50 insertions(+)

Index: linux-2.6-lttng/kernel/irq/handle.c
===================================================================
--- linux-2.6-lttng.orig/kernel/irq/handle.c	2008-07-09 10:57:33.000000000 -0400
+++ linux-2.6-lttng/kernel/irq/handle.c	2008-07-09 10:57:35.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/random.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include "../irq-trace.h"
 
 #include "internals.h"
 
@@ -130,6 +131,9 @@ irqreturn_t handle_IRQ_event(unsigned in
 {
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
+	struct pt_regs *regs = get_irq_regs();
+
+	trace_irq_entry(irq, regs);
 
 	handle_dynamic_tick(action);
 
@@ -148,6 +152,8 @@ irqreturn_t handle_IRQ_event(unsigned in
 		add_interrupt_randomness(irq);
 	local_irq_disable();
 
+	trace_irq_exit();
+
 	return retval;
 }
 
Index: linux-2.6-lttng/kernel/softirq.c
===================================================================
--- linux-2.6-lttng.orig/kernel/softirq.c	2008-07-09 10:57:33.000000000 -0400
+++ linux-2.6-lttng/kernel/softirq.c	2008-07-09 10:57:35.000000000 -0400
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include "irq-trace.h"
 
 #include <asm/irq.h>
 /*
@@ -205,7 +206,9 @@ restart:
 
 	do {
 		if (pending & 1) {
+			trace_irq_softirq_entry(h, softirq_vec);
 			h->action(h);
+			trace_irq_softirq_exit(h, softirq_vec);
 			rcu_bh_qsctr_inc(cpu);
 		}
 		h++;
@@ -297,6 +300,7 @@ void irq_exit(void)
  */
 inline void raise_softirq_irqoff(unsigned int nr)
 {
+	trace_irq_softirq_raise(nr);
 	__raise_softirq_irqoff(nr);
 
 	/*
@@ -394,7 +398,9 @@ static void tasklet_action(struct softir
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				trace_irq_tasklet_low_entry(t);
 				t->func(t->data);
+				trace_irq_tasklet_low_exit(t);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -429,7 +435,9 @@ static void tasklet_hi_action(struct sof
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
+				trace_irq_tasklet_high_entry(t);
 				t->func(t->data);
+				trace_irq_tasklet_high_exit(t);
 				tasklet_unlock(t);
 				continue;
 			}
Index: linux-2.6-lttng/kernel/irq-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/irq-trace.h	2008-07-09 10:57:35.000000000 -0400
@@ -0,0 +1,36 @@
+#ifndef _IRQ_TRACE_H
+#define _IRQ_TRACE_H
+
+#include <linux/kdebug.h>
+#include <linux/interrupt.h>
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(irq_entry,
+	TPPROTO(unsigned int id, struct pt_regs *regs),
+	TPARGS(id, regs));
+DEFINE_TRACE(irq_exit,
+	TPPROTO(void),
+	TPARGS());
+DEFINE_TRACE(irq_softirq_entry,
+	TPPROTO(struct softirq_action *h, struct softirq_action *softirq_vec),
+	TPARGS(h, softirq_vec));
+DEFINE_TRACE(irq_softirq_exit,
+	TPPROTO(struct softirq_action *h, struct softirq_action *softirq_vec),
+	TPARGS(h, softirq_vec));
+DEFINE_TRACE(irq_softirq_raise,
+	TPPROTO(unsigned int nr),
+	TPARGS(nr));
+DEFINE_TRACE(irq_tasklet_low_entry,
+	TPPROTO(struct tasklet_struct *t),
+	TPARGS(t));
+DEFINE_TRACE(irq_tasklet_low_exit,
+	TPPROTO(struct tasklet_struct *t),
+	TPARGS(t));
+DEFINE_TRACE(irq_tasklet_high_entry,
+	TPPROTO(struct tasklet_struct *t),
+	TPARGS(t));
+DEFINE_TRACE(irq_tasklet_high_exit,
+	TPPROTO(struct tasklet_struct *t),
+	TPARGS(t));
+
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

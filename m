Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbZCXQ01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbZCXQ01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762862AbZCXQYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:24:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40669 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762858AbZCXQYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:24:09 -0400
Message-Id: <20090324160148.396496293@polymtl.ca>
References: <20090324155625.420966314@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 11:56:29 -0400
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
Subject: [patch 4/9] LTTng instrumentation softirq
Content-Disposition: inline; filename=lttng-instrumentation-softirq.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 24 Mar 2009 16:22:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compared to Jason's patch, this patch also instruments softirq raise event.

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
 include/trace/irq.h |   10 ++++++++++
 kernel/softirq.c    |    7 +++++++
 2 files changed, 17 insertions(+)

Index: linux-2.6-lttng/include/trace/irq.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/irq.h	2009-03-24 11:48:36.000000000 -0400
+++ linux-2.6-lttng/include/trace/irq.h	2009-03-24 11:48:56.000000000 -0400
@@ -32,4 +32,14 @@ DECLARE_TRACE(irq_tasklet_high_exit,
 	TPPROTO(struct tasklet_struct *t),
 		TPARGS(t));
 
+DECLARE_TRACE(irq_softirq_entry,
+	TPPROTO(struct softirq_action *h, struct softirq_action *softirq_vec),
+		TPARGS(h, softirq_vec));
+DECLARE_TRACE(irq_softirq_exit,
+	TPPROTO(struct softirq_action *h, struct softirq_action *softirq_vec),
+		TPARGS(h, softirq_vec));
+DECLARE_TRACE(irq_softirq_raise,
+	TPPROTO(unsigned int nr),
+		TPARGS(nr));
+
 #endif
Index: linux-2.6-lttng/kernel/softirq.c
===================================================================
--- linux-2.6-lttng.orig/kernel/softirq.c	2009-03-24 11:48:36.000000000 -0400
+++ linux-2.6-lttng/kernel/softirq.c	2009-03-24 11:48:56.000000000 -0400
@@ -58,6 +58,10 @@ DEFINE_TRACE(irq_tasklet_high_exit);
 DEFINE_TRACE(irq_tasklet_low_entry);
 DEFINE_TRACE(irq_tasklet_low_exit);
 
+DEFINE_TRACE(irq_softirq_entry);
+DEFINE_TRACE(irq_softirq_exit);
+DEFINE_TRACE(irq_softirq_raise);
+
 /*
  * we cannot loop indefinitely here to avoid userspace starvation,
  * but we also don't want to introduce a worst case 1/HZ latency
@@ -201,7 +205,9 @@ restart:
 		if (pending & 1) {
 			int prev_count = preempt_count();
 
+			trace_irq_softirq_entry(h, softirq_vec);
 			h->action(h);
+			trace_irq_softirq_exit(h, softirq_vec);
 
 			if (unlikely(prev_count != preempt_count())) {
 				printk(KERN_ERR "huh, entered softirq %td %p"
@@ -300,6 +306,7 @@ void irq_exit(void)
  */
 inline void raise_softirq_irqoff(unsigned int nr)
 {
+	trace_irq_softirq_raise(nr);
 	__raise_softirq_irqoff(nr);
 
 	/*

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

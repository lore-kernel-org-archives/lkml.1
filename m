Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYIIBUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYIIBUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYIIBU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:20:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38310 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbYIIBUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:20:24 -0400
Message-Id: <20080909005116.694358963@polymtl.ca>
References: <20080909003403.836661865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 08 Sep 2008 20:34:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Joe Perches <joe@perches.com>,
       Wei Weng <wweng@acedsl.com>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC PATCH 4/5] Priority Sifting Reader-Writer Lock Sample
Content-Disposition: inline; filename=psrwlock-sample.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue,  9 Sep 2008 00:55:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sample module to show how to use psrwlock.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Joe Perches <joe@perches.com>
CC: Wei Weng <wweng@acedsl.com>
---
 samples/Kconfig                     |    5 +
 samples/Makefile                    |    2 
 samples/psrwlock/Makefile           |    4 
 samples/psrwlock/psrwlock_example.c |  173 ++++++++++++++++++++++++++++++++++++
 4 files changed, 183 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/samples/Makefile
===================================================================
--- linux-2.6-lttng.orig/samples/Makefile	2008-09-06 14:05:34.000000000 -0400
+++ linux-2.6-lttng/samples/Makefile	2008-09-06 14:12:42.000000000 -0400
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ psrwlock/
Index: linux-2.6-lttng/samples/psrwlock/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/psrwlock/Makefile	2008-09-06 14:12:42.000000000 -0400
@@ -0,0 +1,4 @@
+# builds the writer-biased rwlock example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+obj-$(CONFIG_SAMPLE_PSRWLOCK) += psrwlock_example.o
Index: linux-2.6-lttng/samples/psrwlock/psrwlock_example.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/psrwlock/psrwlock_example.c	2008-09-06 14:21:22.000000000 -0400
@@ -0,0 +1,173 @@
+/*
+ * Priority Sifting Reader-Writer Lock Example
+ *
+ * Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/psrwlock.h>
+
+/*
+ * Define which execution contexts can access the lock in read or write mode.
+ * See psrwlock.h and psrwlock-types.h for details.
+ *
+ * In this example, the writer is in preemptable context and the readers either
+ * in IRQ context, softirq context, non-preemptable context or preemptable
+ * context.
+ */
+#define SAMPLE_ALL_WCTX		PSRW_PRIO_P
+#define SAMPLE_ALL_RCTX		(PSR_IRQ | PSR_BH | PSR_NPTHREAD | PSR_PTHREAD)
+
+static DEFINE_PSRWLOCK(sample_rwlock, SAMPLE_ALL_WCTX, SAMPLE_ALL_RCTX);
+CHECK_PSRWLOCK_MAP(sample_rwlock, SAMPLE_ALL_WCTX, SAMPLE_ALL_RCTX);
+
+/*
+ * Reader in IRQ context.
+ */
+static void executed_in_irq(void)
+{
+	psread_lock_irq(&sample_rwlock);
+	/* read structure */
+	psread_unlock(&sample_rwlock);
+}
+
+/*
+ * Reader in Softirq context.
+ */
+static void executed_in_bh(void)
+{
+	psread_lock_bh(&sample_rwlock);
+	/* read structure */
+	psread_unlock(&sample_rwlock);
+}
+
+/*
+ * Reader in non-preemptable context.
+ */
+static void executed_inatomic(void)
+{
+	psread_lock_inatomic(&sample_rwlock);
+	/* read structure */
+	psread_unlock(&sample_rwlock);
+}
+
+/*
+ * Reader in preemptable context.
+ */
+static void reader_executed_preemptable(void)
+{
+	psread_lock(&sample_rwlock);
+	/* read structure */
+	psread_unlock(&sample_rwlock);
+}
+
+/*
+ * Writer in preemptable context.
+ */
+static void writer_executed_preemptable(void)
+{
+	pswrite_lock(&sample_rwlock, SAMPLE_ALL_WCTX, SAMPLE_ALL_RCTX);
+	/* read structure */
+	pswrite_unlock(&sample_rwlock, SAMPLE_ALL_WCTX, SAMPLE_ALL_RCTX);
+}
+
+/*
+ * Execute readers in all contexts.
+ */
+static void sample_all_context(void)
+{
+	local_irq_disable();
+	executed_in_irq();
+	local_irq_enable();
+
+	local_bh_disable();
+	executed_in_bh();
+	local_bh_enable();
+
+	preempt_disable();
+	executed_inatomic();
+	preempt_enable();
+
+	reader_executed_preemptable();
+
+	writer_executed_preemptable();
+}
+
+
+/*
+ * In this second example, the writer is in non-preemptable context and the
+ * readers either in IRQ context or softirq context only.
+ */
+static DEFINE_PSRWLOCK(sample_wnp_rbh_rirq_rwlock,
+	PSRW_PRIO_P, PSR_IRQ | PSR_BH);
+CHECK_PSRWLOCK_MAP(sample_wnp_rbh_rirq_rwlock,
+	PSRW_PRIO_P, PSR_IRQ | PSR_BH);
+
+/*
+ * Reader in IRQ context.
+ */
+static void wnp_rbh_rirq_executed_in_irq(void)
+{
+	psread_lock_irq(&sample_wnp_rbh_rirq_rwlock);
+	/* read structure */
+	psread_unlock(&sample_wnp_rbh_rirq_rwlock);
+}
+
+/*
+ * Reader in Softirq context.
+ */
+static void wnp_rbh_rirq_executed_in_bh(void)
+{
+	psread_lock_bh(&sample_wnp_rbh_rirq_rwlock);
+	/* read structure */
+	psread_unlock(&sample_wnp_rbh_rirq_rwlock);
+}
+
+/*
+ * Writer in preemptable context.
+ */
+static void wnp_rbh_rirq_writer_executed_non_preemptable(void)
+{
+	pswrite_lock(&sample_wnp_rbh_rirq_rwlock,
+				PSRW_PRIO_P, PSR_IRQ | PSR_BH);
+	/* read structure */
+	pswrite_unlock(&sample_wnp_rbh_rirq_rwlock,
+				PSRW_PRIO_P, PSR_IRQ | PSR_BH);
+}
+
+/*
+ * Execute readers in all contexts.
+ */
+static void sample_wnp_rbh_rirq_context(void)
+{
+	local_irq_disable();
+	wnp_rbh_rirq_executed_in_irq();
+	local_irq_enable();
+
+	local_bh_disable();
+	wnp_rbh_rirq_executed_in_bh();
+	local_bh_enable();
+
+	preempt_disable();
+	wnp_rbh_rirq_writer_executed_non_preemptable();
+	preempt_enable();
+}
+
+static int __init init_example(void)
+{
+	sample_all_context();
+	sample_wnp_rbh_rirq_context();
+
+	return 0;
+}
+
+static void __exit exit_example(void)
+{
+}
+
+module_init(init_example)
+module_exit(exit_example)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("psrwlock example");
Index: linux-2.6-lttng/samples/Kconfig
===================================================================
--- linux-2.6-lttng.orig/samples/Kconfig	2008-09-06 14:05:34.000000000 -0400
+++ linux-2.6-lttng/samples/Kconfig	2008-09-06 14:12:42.000000000 -0400
@@ -33,5 +33,10 @@ config SAMPLE_KRETPROBES
 	default m
 	depends on SAMPLE_KPROBES && KRETPROBES
 
+config SAMPLE_PSRWLOCK
+	tristate "Build psrwlock example -- loadable modules only"
+	default m
+	depends on m
+
 endif # SAMPLES
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

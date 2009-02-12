Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZBLITx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZBLITx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZBLITn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:19:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46782 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbZBLITm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:19:42 -0500
Date: Thu, 12 Feb 2009 09:19:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: [patch] rt: fix ipi kfree(), introduce IPI_SOFTIRQ
Message-ID: <20090212081923.GA26838@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere> <20090212081801.GA22979@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212081801.GA22979@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, that's a complex one - we do kfree() from IPI context, [...]

The patch below might do the trick - it offloads this to a softirq.
Not tested yet.

	Ingo

------------------>
Subject: rt: fix ipi kfree(), introduce IPI_SOFTIRQ
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Feb 12 09:06:11 CET 2009

in 2.6.28 generic_smp_call_function_interrupt() grew a kfree(),
which is a rather complex, sleepable method under -rt. But the
IPI code runs as a hardirq - which cannot run such code.

So defer this work to a softirq context instead. It still stays
on the same CPU so the percpu IPI assumptions are upheld.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/interrupt.h |    1 +
 include/linux/smp.h       |    3 +++
 init/main.c               |    1 +
 kernel/smp.c              |   15 +++++++++++++--
 4 files changed, 18 insertions(+), 2 deletions(-)

Index: tip/include/linux/interrupt.h
===================================================================
--- tip.orig/include/linux/interrupt.h
+++ tip/include/linux/interrupt.h
@@ -257,6 +257,7 @@ enum
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
 	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
+	IPI_SOFTIRQ,
 	/* Entries after this are ignored in split softirq mode */
 	MAX_SOFTIRQ,
 
Index: tip/include/linux/smp.h
===================================================================
--- tip.orig/include/linux/smp.h
+++ tip/include/linux/smp.h
@@ -104,6 +104,9 @@ void ipi_call_lock(void);
 void ipi_call_unlock(void);
 void ipi_call_lock_irq(void);
 void ipi_call_unlock_irq(void);
+void ipi_init(void);
+#else
+static inline void ipi_init(void) { }
 #endif
 
 /*
Index: tip/init/main.c
===================================================================
--- tip.orig/init/main.c
+++ tip/init/main.c
@@ -606,6 +606,7 @@ asmlinkage void __init start_kernel(void
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
+	ipi_init();
 	pidhash_init();
 	init_timers();
 	hrtimers_init();
Index: tip/kernel/smp.c
===================================================================
--- tip.orig/kernel/smp.c
+++ tip/kernel/smp.c
@@ -4,12 +4,13 @@
  * (C) Jens Axboe <jens.axboe@oracle.com> 2008
  *
  */
+#include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/rcupdate.h>
 #include <linux/rculist.h>
-#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 static LIST_HEAD(call_function_queue);
@@ -152,6 +153,11 @@ void generic_smp_call_function_interrupt
  */
 void generic_smp_call_function_single_interrupt(void)
 {
+	raise_softirq_irqoff(IPI_SOFTIRQ);
+}
+
+static void run_generic_smp_call_function_single(struct softirq_action *h)
+{
 	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
 	LIST_HEAD(list);
 
@@ -430,3 +436,8 @@ void ipi_call_unlock_irq(void)
 {
 	spin_unlock_irq(&call_function_lock);
 }
+
+void __init ipi_init(void)
+{
+	open_softirq(IPI_SOFTIRQ, run_generic_smp_call_function_single);
+}

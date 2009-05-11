Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbZEKFqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbZEKFqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 01:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZEKFqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 01:46:22 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46668 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZEKFqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 01:46:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18951.48034.485580.498953@drongo.ozlabs.ibm.com>
Date: Mon, 11 May 2009 15:46:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] perf_counter: don't count scheduler ticks as context switches
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The context-switch software counter gives inflated values at present
because each scheduler tick and each process-wide counter
enable/disable prctl gets counted as a context switch.  This happens
because perf_counter_task_tick, perf_counter_task_disable and
perf_counter_task_enable all call perf_counter_task_sched_out, which
calls perf_swcounter_event to record a context switch event.

This fixes it by introducing a variant of perf_counter_task_sched_out
with two underscores in front for internal use within the perf_counter
code, and makes perf_counter_task_{tick,disable,enable} call it.  This
variant doesn't record a context switch event, and takes a struct
perf_counter_context *.  This adds the new variant rather than
changing the behaviour or interface of perf_counter_task_sched_out
because that is called from other code.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_counter.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a5bdc93..7373b96 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -837,6 +837,14 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
 	cpuctx->task_ctx = NULL;
 }
 
+static void __perf_counter_task_sched_out(struct perf_counter_context *ctx)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+
+	__perf_counter_sched_out(ctx, cpuctx);
+	cpuctx->task_ctx = NULL;
+}
+
 static void perf_counter_cpu_sched_out(struct perf_cpu_context *cpuctx)
 {
 	__perf_counter_sched_out(&cpuctx->ctx, cpuctx);
@@ -943,15 +951,13 @@ int perf_counter_task_disable(void)
 	struct perf_counter *counter;
 	unsigned long flags;
 	u64 perf_flags;
-	int cpu;
 
 	if (likely(!ctx->nr_counters))
 		return 0;
 
 	local_irq_save(flags);
-	cpu = smp_processor_id();
 
-	perf_counter_task_sched_out(curr, cpu);
+	__perf_counter_task_sched_out(ctx);
 
 	spin_lock(&ctx->lock);
 
@@ -989,7 +995,7 @@ int perf_counter_task_enable(void)
 	local_irq_save(flags);
 	cpu = smp_processor_id();
 
-	perf_counter_task_sched_out(curr, cpu);
+	__perf_counter_task_sched_out(ctx);
 
 	spin_lock(&ctx->lock);
 
@@ -1054,7 +1060,7 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 	ctx = &curr->perf_counter_ctx;
 
 	perf_counter_cpu_sched_out(cpuctx);
-	perf_counter_task_sched_out(curr, cpu);
+	__perf_counter_task_sched_out(ctx);
 
 	rotate_ctx(&cpuctx->ctx);
 	rotate_ctx(ctx);

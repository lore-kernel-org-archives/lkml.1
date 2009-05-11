Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbZEKKPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbZEKKPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbZEKKNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:50845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730AbZEKKNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:45 -0400
Date: Mon, 11 May 2009 10:12:41 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18951.48034.485580.498953@drongo.ozlabs.ibm.com>
References: <18951.48034.485580.498953@drongo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: don't count scheduler ticks as context switches
Message-ID: <tip-a08b159fc243dbfe415250466d24cfc5010deee5@git.kernel.org>
Git-Commit-ID: a08b159fc243dbfe415250466d24cfc5010deee5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 10:12:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a08b159fc243dbfe415250466d24cfc5010deee5
Gitweb:     http://git.kernel.org/tip/a08b159fc243dbfe415250466d24cfc5010deee5
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 11 May 2009 15:46:10 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 12:10:53 +0200

perf_counter: don't count scheduler ticks as context switches

The context-switch software counter gives inflated values at present
because each scheduler tick and each process-wide counter
enable/disable prctl gets counted as a context switch.

This happens because perf_counter_task_tick, perf_counter_task_disable
and perf_counter_task_enable all call perf_counter_task_sched_out,
which calls perf_swcounter_event to record a context switch event.

This fixes it by introducing a variant of perf_counter_task_sched_out
with two underscores in front for internal use within the perf_counter
code, and makes perf_counter_task_{tick,disable,enable} call it.  This
variant doesn't record a context switch event, and takes a struct
perf_counter_context *.  This adds the new variant rather than
changing the behaviour or interface of perf_counter_task_sched_out
because that is called from other code.

[ Impact: fix inflated context-switch event counts ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <18951.48034.485580.498953@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

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

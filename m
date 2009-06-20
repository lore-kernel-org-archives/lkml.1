Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZFTL2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZFTL2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZFTL2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:28:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:48583 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZFTL2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:28:14 -0400
Date: Sat, 20 Jun 2009 11:27:40 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Push perf_sample_data through the swcounter code
Message-ID: <tip-92bf309a9cd5fedd6c8eefbce0b9a95ada82d0a9@git.kernel.org>
Git-Commit-ID: 92bf309a9cd5fedd6c8eefbce0b9a95ada82d0a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 20 Jun 2009 11:27:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92bf309a9cd5fedd6c8eefbce0b9a95ada82d0a9
Gitweb:     http://git.kernel.org/tip/92bf309a9cd5fedd6c8eefbce0b9a95ada82d0a9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 19 Jun 2009 18:11:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 20 Jun 2009 12:30:30 +0200

perf_counter: Push perf_sample_data through the swcounter code

Push the perf_sample_data further outwards to the swcounter interface,
to abstract it away some more.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   55 +++++++++++++++++++++++++-----------------------
 1 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index adb6ae5..1a933a2 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3171,20 +3171,15 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 }
 
 static void perf_swcounter_overflow(struct perf_counter *counter,
-				    int nmi, struct pt_regs *regs, u64 addr)
+				    int nmi, struct perf_sample_data *data)
 {
-	struct perf_sample_data data = {
-		.regs	= regs,
-		.addr	= addr,
-		.period	= counter->hw.last_period,
-	};
+	data->period = counter->hw.last_period;
 
 	perf_swcounter_update(counter);
 	perf_swcounter_set_period(counter);
-	if (perf_counter_overflow(counter, nmi, &data))
+	if (perf_counter_overflow(counter, nmi, data))
 		/* soft-disable the counter */
 		;
-
 }
 
 static int perf_swcounter_is_counting(struct perf_counter *counter)
@@ -3249,18 +3244,18 @@ static int perf_swcounter_match(struct perf_counter *counter,
 }
 
 static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
-			       int nmi, struct pt_regs *regs, u64 addr)
+			       int nmi, struct perf_sample_data *data)
 {
 	int neg = atomic64_add_negative(nr, &counter->hw.count);
 
-	if (counter->hw.sample_period && !neg && regs)
-		perf_swcounter_overflow(counter, nmi, regs, addr);
+	if (counter->hw.sample_period && !neg && data->regs)
+		perf_swcounter_overflow(counter, nmi, data);
 }
 
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
-				     enum perf_type_id type, u32 event,
-				     u64 nr, int nmi, struct pt_regs *regs,
-				     u64 addr)
+				     enum perf_type_id type,
+				     u32 event, u64 nr, int nmi,
+				     struct perf_sample_data *data)
 {
 	struct perf_counter *counter;
 
@@ -3269,8 +3264,8 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_swcounter_match(counter, type, event, regs))
-			perf_swcounter_add(counter, nr, nmi, regs, addr);
+		if (perf_swcounter_match(counter, type, event, data->regs))
+			perf_swcounter_add(counter, nr, nmi, data);
 	}
 	rcu_read_unlock();
 }
@@ -3289,9 +3284,9 @@ static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
 	return &cpuctx->recursion[0];
 }
 
-static void __perf_swcounter_event(enum perf_type_id type, u32 event,
-				   u64 nr, int nmi, struct pt_regs *regs,
-				   u64 addr)
+static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
+				    u64 nr, int nmi,
+				    struct perf_sample_data *data)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
 	int *recursion = perf_swcounter_recursion_context(cpuctx);
@@ -3304,7 +3299,7 @@ static void __perf_swcounter_event(enum perf_type_id type, u32 event,
 	barrier();
 
 	perf_swcounter_ctx_event(&cpuctx->ctx, type, event,
-				 nr, nmi, regs, addr);
+				 nr, nmi, data);
 	rcu_read_lock();
 	/*
 	 * doesn't really matter which of the child contexts the
@@ -3312,7 +3307,7 @@ static void __perf_swcounter_event(enum perf_type_id type, u32 event,
 	 */
 	ctx = rcu_dereference(current->perf_counter_ctxp);
 	if (ctx)
-		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, regs, addr);
+		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, data);
 	rcu_read_unlock();
 
 	barrier();
@@ -3325,7 +3320,12 @@ out:
 void
 perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
-	__perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, regs, addr);
+	struct perf_sample_data data = {
+		.regs = regs,
+		.addr = addr,
+	};
+
+	do_perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, &data);
 }
 
 static void perf_swcounter_read(struct perf_counter *counter)
@@ -3469,12 +3469,15 @@ static const struct pmu perf_ops_task_clock = {
 #ifdef CONFIG_EVENT_PROFILE
 void perf_tpcounter_event(int event_id)
 {
-	struct pt_regs *regs = get_irq_regs();
+	struct perf_sample_data data = {
+		.regs = get_irq_regs();
+		.addr = 0,
+	};
 
-	if (!regs)
-		regs = task_pt_regs(current);
+	if (!data.regs)
+		data.regs = task_pt_regs(current);
 
-	__perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, regs, 0);
+	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, &data);
 }
 EXPORT_SYMBOL_GPL(perf_tpcounter_event);
 

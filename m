Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZDFJo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZDFJo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZDFJog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbZDFJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:35 -0400
Message-Id: <20090406094518.618876874@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:13 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 15/15] perf_counter: minimize context time updates
Content-Disposition: inline; filename=perf_counter-frop.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the update_context_time() calls up the stack so that we get less
invokations and thereby a less noisy output:

before:

 # ./perfstat -e 1:0 -e 1:1 -e 1:1 -e 1:1 -l ls > /dev/null

 Performance counter stats for 'ls':

      10.163691  cpu clock ticks      (msecs)  (scaled from 98.94%)
      10.215360  task clock ticks     (msecs)  (scaled from 98.18%)
      10.185549  task clock ticks     (msecs)  (scaled from 98.53%)
      10.183581  task clock ticks     (msecs)  (scaled from 98.71%)

 Wall-clock time elapsed:    11.912858 msecs

after:

 # ./perfstat -e 1:0 -e 1:1 -e 1:1 -e 1:1 -l ls > /dev/null

 Performance counter stats for 'ls':

       9.316630  cpu clock ticks      (msecs)
       9.280789  task clock ticks     (msecs)
       9.280789  task clock ticks     (msecs)
       9.280789  task clock ticks     (msecs)

 Wall-clock time elapsed:     9.574872 msecs

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -319,6 +319,8 @@ static void __perf_counter_disable(void 
 
 	spin_lock_irqsave(&ctx->lock, flags);
 
+	update_context_time(ctx);
+
 	/*
 	 * If the counter is on, turn it off.
 	 * If it is in error state, leave it in error state.
@@ -797,6 +799,8 @@ void perf_counter_task_sched_out(struct 
 	if (likely(!cpuctx->task_ctx))
 		return;
 
+	update_context_time(ctx);
+
 	regs = task_pt_regs(task);
 	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs);
 	__perf_counter_sched_out(ctx, cpuctx);
@@ -2336,7 +2340,6 @@ static void task_clock_perf_counter_upda
 	u64 prev, now;
 	s64 delta;
 
-	update_context_time(counter->ctx);
 	now = counter->ctx->time;
 
 	prev = atomic64_xchg(&counter->hw.prev_count, now);
@@ -2349,7 +2352,6 @@ static int task_clock_perf_counter_enabl
 	struct hw_perf_counter *hwc = &counter->hw;
 	u64 now;
 
-	update_context_time(counter->ctx);
 	now = counter->ctx->time;
 
 	atomic64_set(&hwc->prev_count, now);
@@ -2372,6 +2374,7 @@ static void task_clock_perf_counter_disa
 
 static void task_clock_perf_counter_read(struct perf_counter *counter)
 {
+	update_context_time(counter->ctx);
 	task_clock_perf_counter_update(counter);
 }
 

-- 


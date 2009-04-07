Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZDGJN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZDGJN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbZDGJKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:10:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39067 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbZDGJKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:10:19 -0400
Date: Tue, 7 Apr 2009 09:09:38 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094518.618876874@chello.nl>
References: <20090406094518.618876874@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: minimize context time updates
Message-ID: <tip-bce379bf358738ab8efc8cda2594a299ac685085@git.kernel.org>
Git-Commit-ID: bce379bf358738ab8efc8cda2594a299ac685085
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:09:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bce379bf358738ab8efc8cda2594a299ac685085
Gitweb:     http://git.kernel.org/tip/bce379bf358738ab8efc8cda2594a299ac685085
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:49:01 +0200

perf_counter: minimize context time updates

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
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094518.618876874@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f4f7596..863703b 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -319,6 +319,8 @@ static void __perf_counter_disable(void *info)
 
 	spin_lock_irqsave(&ctx->lock, flags);
 
+	update_context_time(ctx);
+
 	/*
 	 * If the counter is on, turn it off.
 	 * If it is in error state, leave it in error state.
@@ -797,6 +799,8 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
 	if (likely(!cpuctx->task_ctx))
 		return;
 
+	update_context_time(ctx);
+
 	regs = task_pt_regs(task);
 	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs);
 	__perf_counter_sched_out(ctx, cpuctx);
@@ -2336,7 +2340,6 @@ static void task_clock_perf_counter_update(struct perf_counter *counter)
 	u64 prev, now;
 	s64 delta;
 
-	update_context_time(counter->ctx);
 	now = counter->ctx->time;
 
 	prev = atomic64_xchg(&counter->hw.prev_count, now);
@@ -2349,7 +2352,6 @@ static int task_clock_perf_counter_enable(struct perf_counter *counter)
 	struct hw_perf_counter *hwc = &counter->hw;
 	u64 now;
 
-	update_context_time(counter->ctx);
 	now = counter->ctx->time;
 
 	atomic64_set(&hwc->prev_count, now);
@@ -2372,6 +2374,7 @@ static void task_clock_perf_counter_disable(struct perf_counter *counter)
 
 static void task_clock_perf_counter_read(struct perf_counter *counter)
 {
+	update_context_time(counter->ctx);
 	task_clock_perf_counter_update(counter);
 }
 

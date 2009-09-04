Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbZIEABq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbZIEABq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934446AbZIEABj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210AbZIEABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:25 -0400
Message-Id: <20090905000127.100299259@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/18] tracing: report error in trace if we fail to swap latency buffer
Content-Disposition: inline; filename=0016-tracing-report-error-in-trace-if-we-fail-to-swap-lat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The irqsoff tracer will fail to swap the cpu buffer with the max
buffer if it preempts a commit. Instead of ignoring this, this patch
makes the tracer report it if the last max latency failed due to preempting
a current commit.

The output of the latency tracer will look like this:

 # tracer: irqsoff
 #
 # irqsoff latency trace v1.1.5 on 2.6.31-rc5
 # --------------------------------------------------------------------
 # latency: 112 us, #1/1, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
 #    -----------------
 #    | task: -4281 (uid:0 nice:0 policy:0 rt_prio:0)
 #    -----------------
 #  => started at: save_args
 #  => ended at:   __do_softirq
 #
 #
 #                  _------=> CPU#
 #                 / _-----=> irqs-off
 #                | / _----=> need-resched
 #                || / _---=> hardirq/softirq
 #                ||| / _--=> preempt-depth
 #                |||| /
 #                |||||     delay
 #  cmd     pid   ||||| time  |   caller
 #     \   /      |||||   \   |   /
    bash-4281    1d.s6  265us : update_max_tr_single: Failed to swap buffers due to commit in progress

Note the latency time and the functions that disabled the irqs or preemption
will still be listed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ef08328..6df9861 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -482,9 +482,20 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
 
+	if (ret == -EBUSY) {
+		/*
+		 * We failed to swap the buffer due to a commit taking
+		 * place on this CPU. We fail to record, but we reset
+		 * the max trace buffer (no one writes directly to it)
+		 * and flag that it failed.
+		 */
+		trace_array_printk(&max_tr, _THIS_IP_,
+			"Failed to swap buffers due to commit in progress\n");
+	}
+
 	ftrace_enable_cpu();
 
-	WARN_ON_ONCE(ret && ret != -EAGAIN);
+	WARN_ON_ONCE(ret && ret != -EAGAIN && ret != -EBUSY);
 
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
-- 
1.6.3.3

-- 

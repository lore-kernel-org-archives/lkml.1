Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZAUX6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZAUX6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZAUX6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:58:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42910 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZAUX6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:58:08 -0500
Message-Id: <20090121235806.431954276@goodmis.org>
References: <20090121235306.224764198@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 21 Jan 2009 18:53:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] wakeup-tracer: show scheduling data in output
Content-Disposition: inline; filename=0004-wakeup-tracer-show-scheduling-data-in-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: better data for wakeup tracer

This patch adds the wakeup and schedule calls that are used by
the scheduler tracer to make the wakeup tracer more readable.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index f489578..93cecda 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -153,6 +153,7 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 		goto out_unlock;
 
 	trace_function(wakeup_trace, data, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
+	tracing_sched_switch_trace(wakeup_trace, data, prev, next, flags, pc);
 
 	/*
 	 * usecs conversion is slow so we try to delay the conversion
@@ -214,6 +215,7 @@ static void wakeup_reset(struct trace_array *tr)
 static void
 probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 {
+	struct trace_array_cpu *data;
 	int cpu = smp_processor_id();
 	unsigned long flags;
 	long disabled;
@@ -253,9 +255,12 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 
 	local_save_flags(flags);
 
-	wakeup_trace->data[wakeup_cpu]->preempt_timestamp = ftrace_now(cpu);
-	trace_function(wakeup_trace, wakeup_trace->data[wakeup_cpu],
-		       CALLER_ADDR1, CALLER_ADDR2, flags, pc);
+	data = wakeup_trace->data[wakeup_cpu];
+	data->preempt_timestamp = ftrace_now(cpu);
+	tracing_sched_wakeup_trace(wakeup_trace, data, p, current,
+				   flags, pc);
+	trace_function(wakeup_trace, data, CALLER_ADDR1, CALLER_ADDR2,
+		       flags, pc);
 
 out_locked:
 	__raw_spin_unlock(&wakeup_lock);
-- 
1.5.6.5

-- 

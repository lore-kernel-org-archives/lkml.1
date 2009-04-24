Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZDXEbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZDXEbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZDXEbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:31:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZDXEbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:31:12 -0400
Message-Id: <20090424043110.981570564@goodmis.org>
References: <20090424043005.338878133@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 24 Apr 2009 00:30:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/6] tracing/wakeup: move access to wakeup_cpu into spinlock
Content-Disposition: inline; filename=0001-tracing-wakeup-move-access-to-wakeup_cpu-into-spinl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code had the following outside the lock:

        if (next != wakeup_task)
                return;

        pc = preempt_count();

        /* The task we are waiting for is waking up */
        data = wakeup_trace->data[wakeup_cpu];

On initialization, wakeup_task is NULL and wakeup_cpu -1. This code
is not under a lock. If wakeup_task is set on another CPU as that
task is waking up, we can see the wakeup_task before wakeup_cpu is
set. If we read wakeup_cpu while it is still -1 then we will have
a bad data pointer.

This patch moves the reading of wakeup_cpu within the protection of
the spinlock used to protect the writing of wakeup_cpu and wakeup_task.

[ Impact: remove possible race causing invalid pointer dereference ]

Reported-by: Maneesh Soni <maneesh@in.ibm.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index b8b13c5..eacb272 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -138,9 +138,6 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 
 	pc = preempt_count();
 
-	/* The task we are waiting for is waking up */
-	data = wakeup_trace->data[wakeup_cpu];
-
 	/* disable local data, not wakeup_cpu data */
 	cpu = raw_smp_processor_id();
 	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
@@ -154,6 +151,9 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
+	/* The task we are waiting for is waking up */
+	data = wakeup_trace->data[wakeup_cpu];
+
 	trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
-- 
1.6.2.1

-- 

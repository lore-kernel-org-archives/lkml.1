Return-Path: <linux-kernel-owner+w=401wt.eu-S937565AbZDDAeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937565AbZDDAeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936798AbZDDA2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:28:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936705AbZDDA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:28:12 -0400
Message-Id: <20090404002809.819480855@goodmis.org>
References: <20090404002703.627460459@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 20:27:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 09/10] ftrace: Clean up enable logic for sched_switch
Content-Disposition: inline; filename=0009-ftrace-Clean-up-enable-logic-for-sched_switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

Unify sched_switch and sched_wakeup's action to following logic:
Do record_cmdline when start_cmdline_record() is called.
Start tracing events when the tracer is started.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
LKML-Reference: <49D1C596.5050203@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_switch.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 9117cea..9d8cccd 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -29,13 +29,13 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	int cpu;
 	int pc;
 
-	if (!sched_ref || sched_stopped)
+	if (unlikely(!sched_ref))
 		return;
 
 	tracing_record_cmdline(prev);
 	tracing_record_cmdline(next);
 
-	if (!tracer_enabled)
+	if (!tracer_enabled || sched_stopped)
 		return;
 
 	pc = preempt_count();
@@ -56,15 +56,15 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 	unsigned long flags;
 	int cpu, pc;
 
-	if (!likely(tracer_enabled))
+	if (unlikely(!sched_ref))
 		return;
 
-	pc = preempt_count();
 	tracing_record_cmdline(current);
 
-	if (sched_stopped)
+	if (!tracer_enabled || sched_stopped)
 		return;
 
+	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
-- 
1.6.2.1

-- 

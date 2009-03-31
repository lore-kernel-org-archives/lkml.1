Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbZCaH3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbZCaH3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZCaH3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:29:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbZCaH3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:29:09 -0400
Message-ID: <49D1C596.5050203@cn.fujitsu.com>
Date: Tue, 31 Mar 2009 15:26:14 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ftrace: Clean up enable logic for sched_switch
References: <49D1C51C.7000407@cn.fujitsu.com>
In-Reply-To: <49D1C51C.7000407@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify sched_switch and sched_wakeup's action to following logic:
Do record_cmdline when start_cmdline_record() called.
Trace event when trace is inited and started.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
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
1.5.5.3



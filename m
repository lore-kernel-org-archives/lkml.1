Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZIMBui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZIMBui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 21:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZIMBuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 21:50:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZIMBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 21:50:21 -0400
Message-Id: <20090913015023.650251718@goodmis.org>
References: <20090913014906.407896305@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 21:49:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Carsten Emde <Carsten.Emde@osadl.org>, Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 3/3] tracing: do not update tracing_max_latency when tracer is stopped
Content-Disposition: inline; filename=0003-tracing-do-not-update-tracing_max_latency-when-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <Carsten.Emde@osadl.org>

The state of the function pair tracing_stop()/tracing_start() is
correctly considered when tracer data are updated. However, the global
and externally accessible variable tracing_max_latency is always updated
- even when tracing is stopped.

The update should only occur, if tracing was not stopped.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |    5 +++++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |    6 ++++--
 kernel/trace/trace_sched_wakeup.c |    6 ++++--
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 45c3f03..ef82a7f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -825,6 +825,11 @@ static void trace_init_cmdlines(void)
 	cmdline_idx = 0;
 }
 
+int is_tracing_stopped(void)
+{
+	return trace_stop_count;
+}
+
 /**
  * ftrace_off_permanent - disable all ftrace code permanently
  *
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 28247ce..4ad4e1d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -461,6 +461,7 @@ void tracing_stop_sched_switch_record(void);
 void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
+int is_tracing_stopped(void);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 06f8ea9..3aa7eaa 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -157,8 +157,10 @@ check_critical_timing(struct trace_array *tr,
 
 	data->critical_end = parent_ip;
 
-	tracing_max_latency = delta;
-	update_max_tr_single(tr, current, cpu);
+	if (likely(!is_tracing_stopped())) {
+		tracing_max_latency = delta;
+		update_max_tr_single(tr, current, cpu);
+	}
 
 	max_sequence++;
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 6e1529b..26185d7 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -162,8 +162,10 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (!report_latency(delta))
 		goto out_unlock;
 
-	tracing_max_latency = delta;
-	update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
+	if (likely(!is_tracing_stopped())) {
+		tracing_max_latency = delta;
+		update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
+	}
 
 out_unlock:
 	__wakeup_reset(wakeup_trace);
-- 
1.6.3.3

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S934494AbZIEADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbZIEADb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934228AbZIEADW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:03:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62243 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934119AbZIEABW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:22 -0400
Message-Id: <20090905000123.801815459@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/18] tracing: print out start and stop in latency traces
Content-Disposition: inline; filename=0008-tracing-print-out-start-and-stop-in-latency-traces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

During development of the tracer, we would copy information from
the live tracer to the max tracer with one memcpy. Since then we
added a generic ring buffer and we handle the copies differently now.
Unfortunately, we never copied the critical section information, and
we lost the output:

 #  => started at: kmem_cache_alloc
 #  => ended at:   kmem_cache_alloc

This patch adds back the critical start and end copying as well as
removes the unused "trace_idx" and "overrun" fields of the
trace_array_cpu structure.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   19 +++++++++++--------
 kernel/trace/trace.h |    3 ---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0f08816..df2c9f7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -407,19 +407,22 @@ static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	struct trace_array_cpu *data = tr->data[cpu];
+	struct trace_array_cpu *max_data = tr->data[cpu];
 
 	max_tr.cpu = cpu;
 	max_tr.time_start = data->preempt_timestamp;
 
-	data = max_tr.data[cpu];
-	data->saved_latency = tracing_max_latency;
+	max_data = max_tr.data[cpu];
+	max_data->saved_latency = tracing_max_latency;
+	max_data->critical_start = data->critical_start;
+	max_data->critical_end = data->critical_end;
 
 	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
-	data->pid = tsk->pid;
-	data->uid = task_uid(tsk);
-	data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
-	data->policy = tsk->policy;
-	data->rt_priority = tsk->rt_priority;
+	max_data->pid = tsk->pid;
+	max_data->uid = task_uid(tsk);
+	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
+	max_data->policy = tsk->policy;
+	max_data->rt_priority = tsk->rt_priority;
 
 	/* record this tasks comm */
 	tracing_record_cmdline(tsk);
@@ -1501,7 +1504,7 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 		seq_puts(m, "\n#  => ended at:   ");
 		seq_print_ip_sym(&iter->seq, data->critical_end, sym_flags);
 		trace_print_seq(m, &iter->seq);
-		seq_puts(m, "#\n");
+		seq_puts(m, "\n#\n");
 	}
 
 	seq_puts(m, "#\n");
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e2c06b2..f2af713 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -234,9 +234,6 @@ struct trace_array_cpu {
 	atomic_t		disabled;
 	void			*buffer_page;	/* ring buffer spare */
 
-	/* these fields get copied into max-trace: */
-	unsigned long		trace_idx;
-	unsigned long		overrun;
 	unsigned long		saved_latency;
 	unsigned long		critical_start;
 	unsigned long		critical_end;
-- 
1.6.3.3

-- 

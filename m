Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZAUX76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZAUX76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbZAUX6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:58:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbZAUX6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:58:08 -0500
Message-Id: <20090121235806.289123098@goodmis.org>
References: <20090121235306.224764198@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 21 Jan 2009 18:53:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] trace: separate out rt tasks from wakeup tracer
Content-Disposition: inline; filename=0003-trace-separate-out-rt-tasks-from-wakeup-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: add option to trace all tasks or just RT tasks

The current wakeup tracer only traces RT task wakeups. This is
fine for those interested in wake up timings of RT tasks, but
it is useless for those that are interested in the causes
of long wakeups for non RT tasks.

This patch creates a "wakeup_rt" to implement the tracing of just
RT tasks (as the current "wakeup" does). And makes "wakeup" now
trace all tasks as an average developer would expect.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index e27adef..f489578 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -25,6 +25,7 @@ static int __read_mostly	tracer_enabled;
 static struct task_struct	*wakeup_task;
 static int			wakeup_cpu;
 static unsigned			wakeup_prio = -1;
+static int			wakeup_rt;
 
 static raw_spinlock_t wakeup_lock =
 	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
@@ -224,7 +225,7 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 	tracing_record_cmdline(p);
 	tracing_record_cmdline(current);
 
-	if (likely(!rt_task(p)) ||
+	if ((wakeup_rt && !rt_task(p)) ||
 			p->prio >= wakeup_prio ||
 			p->prio >= current->prio)
 		return;
@@ -321,7 +322,7 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 	unregister_trace_sched_wakeup(probe_wakeup);
 }
 
-static int wakeup_tracer_init(struct trace_array *tr)
+static int __wakeup_tracer_init(struct trace_array *tr)
 {
 	tracing_max_latency = 0;
 	wakeup_trace = tr;
@@ -329,6 +330,18 @@ static int wakeup_tracer_init(struct trace_array *tr)
 	return 0;
 }
 
+static int wakeup_tracer_init(struct trace_array *tr)
+{
+	wakeup_rt = 0;
+	return __wakeup_tracer_init(tr);
+}
+
+static int wakeup_rt_tracer_init(struct trace_array *tr)
+{
+	wakeup_rt = 1;
+	return __wakeup_tracer_init(tr);
+}
+
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
 	stop_wakeup_tracer(tr);
@@ -360,6 +373,19 @@ static struct tracer wakeup_tracer __read_mostly =
 #endif
 };
 
+static struct tracer wakeup_rt_tracer __read_mostly =
+{
+	.name		= "wakeup_rt",
+	.init		= wakeup_rt_tracer_init,
+	.reset		= wakeup_tracer_reset,
+	.start		= wakeup_tracer_start,
+	.stop		= wakeup_tracer_stop,
+	.print_max	= 1,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest    = trace_selftest_startup_wakeup,
+#endif
+};
+
 __init static int init_wakeup_tracer(void)
 {
 	int ret;
@@ -368,6 +394,10 @@ __init static int init_wakeup_tracer(void)
 	if (ret)
 		return ret;
 
+	ret = register_tracer(&wakeup_rt_tracer);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 device_initcall(init_wakeup_tracer);
-- 
1.5.6.5

-- 

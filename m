Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbZF3GHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbZF3GHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZF3GH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:07:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50077 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZF3GH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:07:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19017.43927.838745.689203@cargo.ozlabs.ibm.com>
Date: Tue, 30 Jun 2009 16:07:19 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] perf_counter: Provide a way to enable counters on exec
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a way to mark a counter to be enabled on the next exec.
This is useful for measuring the total activity of a program without
including overhead from the process that launches it.

This also changes the perf stat command to use this new facility.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
v2: only unclone if we enabled one or more counters.

This differs from Ingo's approach a little in that I don't keep the
counter force-disabled until exec, and I reuse the comm hook instead
of having a new perf_counter_exec hook (not that a new hook would
necessarily be a bad idea).  Also, my locking is a bit heavier, it's
more or less like the old perf_counter_task_enable().

 include/linux/perf_counter.h |    3 +-
 kernel/perf_counter.c        |   50 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-stat.c    |    6 ++--
 3 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 3078e23..5e970c7 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -179,8 +179,9 @@ struct perf_counter_attr {
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 				inherit_stat   :  1, /* per task counts       */
+				enable_on_exec :  1, /* next exec enables     */
 
-				__reserved_1   : 52;
+				__reserved_1   : 51;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 66ab1e9..d55a50d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1429,6 +1429,53 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 }
 
 /*
+ * Enable all of a task's counters that have been marked enable-on-exec.
+ * This expects task == current.
+ */
+static void perf_counter_enable_on_exec(struct task_struct *task)
+{
+	struct perf_counter_context *ctx;
+	struct perf_counter *counter;
+	unsigned long flags;
+	int enabled = 0;
+
+	local_irq_save(flags);
+	ctx = task->perf_counter_ctxp;
+	if (!ctx || !ctx->nr_counters)
+		goto out;
+
+	__perf_counter_task_sched_out(ctx);
+
+	spin_lock(&ctx->lock);
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (!counter->attr.enable_on_exec)
+			continue;
+		counter->attr.enable_on_exec = 0;
+		if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+			continue;
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->tstamp_enabled =
+			ctx->time - counter->total_time_enabled;
+		enabled = 1;
+	}
+
+	/*
+	 * Unclone this context if we enabled any counter.
+	 */
+	if (enabled && ctx->parent_ctx) {
+		put_ctx(ctx->parent_ctx);
+		ctx->parent_ctx = NULL;
+	}
+
+	spin_unlock(&ctx->lock);
+
+	perf_counter_task_sched_in(task, smp_processor_id());
+ out:
+	local_irq_restore(flags);
+}
+
+/*
  * Cross CPU call to read the hardware counter
  */
 static void __perf_counter_read(void *info)
@@ -2949,6 +2996,9 @@ void perf_counter_comm(struct task_struct *task)
 {
 	struct perf_comm_event comm_event;
 
+	if (task->perf_counter_ctxp)
+		perf_counter_enable_on_exec(task);
+
 	if (!atomic_read(&nr_comm_counters))
 		return;
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 201ef23..2e03524 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -116,8 +116,9 @@ static void create_perf_stat_counter(int counter, int pid)
 					fd[cpu][counter], strerror(errno));
 		}
 	} else {
-		attr->inherit	= inherit;
-		attr->disabled	= 1;
+		attr->inherit	     = inherit;
+		attr->disabled	     = 1;
+		attr->enable_on_exec = 1;
 
 		fd[0][counter] = sys_perf_counter_open(attr, pid, -1, -1, 0);
 		if (fd[0][counter] < 0 && verbose)
@@ -262,7 +263,6 @@ static int run_perf_stat(int argc, const char **argv)
 	 * Enable counters and exec the command:
 	 */
 	t0 = rdclock();
-	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
 
 	close(go_pipe[1]);
 	wait(&status);
-- 
1.6.0.4


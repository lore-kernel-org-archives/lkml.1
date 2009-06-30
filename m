Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZF3KZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZF3KZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZF3KZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:25:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZF3KZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:25:29 -0400
Date: Tue, 30 Jun 2009 10:24:53 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19017.43927.838745.689203@cargo.ozlabs.ibm.com>
References: <19017.43927.838745.689203@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/urgent] perf_counter: Provide a way to enable counters on exec
Message-ID: <tip-57e7986ed142417498155ebcd5eaf617ac37136d@git.kernel.org>
Git-Commit-ID: 57e7986ed142417498155ebcd5eaf617ac37136d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 10:24:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57e7986ed142417498155ebcd5eaf617ac37136d
Gitweb:     http://git.kernel.org/tip/57e7986ed142417498155ebcd5eaf617ac37136d
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 30 Jun 2009 16:07:19 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 30 Jun 2009 12:00:16 +0200

perf_counter: Provide a way to enable counters on exec

This provides a way to mark a counter to be enabled on the next
exec. This is useful for measuring the total activity of a
program without including overhead from the process that
launches it.

This also changes the perf stat command to use this new
facility.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <19017.43927.838745.689203@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
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

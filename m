Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZKHP3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZKHP3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZKHP3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:29:40 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40107 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZKHP3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:29:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nDF8J/O93yJ3uqxmZgvsTVQ8cU/UFP031pdtWs2nyW5Zr96ycHJbbPwh88SUZWE/F5
         IBapLjRyGlfGkXqHnh74qL6yXvcoCZTsno+ilOvhMUObAN1j/dOJ96Fx0l3lnryoZ3Sk
         VO7Y441edk5cUDGAIQ/t18w/imjCBI9pbTCUk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/7 v6] hw-breakpoints: Arbitrate access to pmu following registers constraints
Date: Sun,  8 Nov 2009 16:29:00 +0100
Message-Id: <1257694141-5670-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow or refuse to build a counter using the breakpoints pmu following
given constraints.

We keep track of the pmu users by using three per cpu variables:

- nr_cpu_bp_pinned stores the number of pinned cpu breakpoints counters
  in the given cpu

- nr_bp_flexible stores the number of non-pinned breakpoints counters
  in the given cpu.

- task_bp_pinned stores the number of pinned task breakpoints in a cpu

The latter is not a simple counter but gathers the number of tasks that
have n pinned breakpoints.
Considering HBP_NUM the number of available breakpoint address
registers:
   task_bp_pinned[0] is the number of tasks having 1 breakpoint
   task_bp_pinned[1] is the number of tasks having 2 breakpoints
   [...]
   task_bp_pinned[HBP_NUM - 1] is the number of tasks having the
   maximum number of registers (HBP_NUM).

When a breakpoint counter is created and wants an access to the pmu,
we evaluate the following constraints:

== Non-pinned counter ==

- If attached to a single cpu, check:

    (per_cpu(nr_bp_flexible, cpu) || (per_cpu(nr_cpu_bp_pinned, cpu)
         + max(per_cpu(task_bp_pinned, cpu)))) < HBP_NUM

       -> If there are already non-pinned counters in this cpu, it
          means there is already a free slot for them.
          Otherwise, we check that the maximum number of per task
          breakpoints (for this cpu) plus the number of per cpu
          breakpoint (for this cpu) doesn't cover every registers.

- If attached to every cpus, check:

    (per_cpu(nr_bp_flexible, *) || (max(per_cpu(nr_cpu_bp_pinned, *))
           + max(per_cpu(task_bp_pinned, *)))) < HBP_NUM

       -> This is roughly the same, except we check the number of per
          cpu bp for every cpu and we keep the max one. Same for the
          per tasks breakpoints.

== Pinned counter ==

- If attached to a single cpu, check:

       ((per_cpu(nr_bp_flexible, cpu) > 1)
            + per_cpu(nr_cpu_bp_pinned, cpu)
            + max(per_cpu(task_bp_pinned, cpu))) < HBP_NUM

       -> Same checks as before. But now the nr_bp_flexible, if any,
          must keep one register at least (or flexible breakpoints will
          never be be fed).

- If attached to every cpus, check:

      ((per_cpu(nr_bp_flexible, *) > 1)
           + max(per_cpu(nr_cpu_bp_pinned, *))
           + max(per_cpu(task_bp_pinned, *))) < HBP_NUM

Changes in v2:

- Counter -> event rename

Changes in v5:

- Fix unreleased non-pinned task-bound-only counters. We only released
  it in the first cpu. (Thanks to Paul Mackerras for reporting that)

Changes in v6:

- Currently, events scheduling are done in this order: cpu context
  pinned + cpu context non-pinned + task context pinned + task context
  non-pinned events. Then our current constraints are right theoretically
  but not in practice, because non-pinned counters may be scheduled
  before we can apply every possible pinned counters. So consider
  non-pinned counters as pinned for now.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@web.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 kernel/hw_breakpoint.c |  211 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 205 insertions(+), 6 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 08f6d01..e662dc9 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -16,6 +16,8 @@
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) IBM Corporation, 2009
  * Copyright (C) 2009, Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ * Thanks to Ingo Molnar for his many suggestions.
  */
 
 /*
@@ -44,24 +46,221 @@
 #include <asm/debugreg.h>
 #endif
 
-static atomic_t bp_slot;
+/*
+ * Constraints data
+ */
+
+/* Number of pinned cpu breakpoints in a cpu */
+static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned);
 
-int reserve_bp_slot(struct perf_event *bp)
+/* Number of pinned task breakpoints in a cpu */
+static DEFINE_PER_CPU(unsigned int, task_bp_pinned[HBP_NUM]);
+
+/* Number of non-pinned cpu/task breakpoints in a cpu */
+static DEFINE_PER_CPU(unsigned int, nr_bp_flexible);
+
+/* Gather the number of total pinned and un-pinned bp in a cpuset */
+struct bp_busy_slots {
+	unsigned int pinned;
+	unsigned int flexible;
+};
+
+/* Serialize accesses to the above constraints */
+static DEFINE_MUTEX(nr_bp_mutex);
+
+/*
+ * Report the maximum number of pinned breakpoints a task
+ * have in this cpu
+ */
+static unsigned int max_task_bp_pinned(int cpu)
 {
-	if (atomic_inc_return(&bp_slot) == HBP_NUM) {
-		atomic_dec(&bp_slot);
+	int i;
+	unsigned int *tsk_pinned = per_cpu(task_bp_pinned, cpu);
 
-		return -ENOSPC;
+	for (i = HBP_NUM -1; i >= 0; i--) {
+		if (tsk_pinned[i] > 0)
+			return i + 1;
 	}
 
 	return 0;
 }
 
+/*
+ * Report the number of pinned/un-pinned breakpoints we have in
+ * a given cpu (cpu > -1) or in all of them (cpu = -1).
+ */
+static void fetch_bp_busy_slots(struct bp_busy_slots *slots, int cpu)
+{
+	if (cpu >= 0) {
+		slots->pinned = per_cpu(nr_cpu_bp_pinned, cpu);
+		slots->pinned += max_task_bp_pinned(cpu);
+		slots->flexible = per_cpu(nr_bp_flexible, cpu);
+
+		return;
+	}
+
+	for_each_online_cpu(cpu) {
+		unsigned int nr;
+
+		nr = per_cpu(nr_cpu_bp_pinned, cpu);
+		nr += max_task_bp_pinned(cpu);
+
+		if (nr > slots->pinned)
+			slots->pinned = nr;
+
+		nr = per_cpu(nr_bp_flexible, cpu);
+
+		if (nr > slots->flexible)
+			slots->flexible = nr;
+	}
+}
+
+/*
+ * Add a pinned breakpoint for the given task in our constraint table
+ */
+static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable)
+{
+	int count = 0;
+	struct perf_event *bp;
+	struct perf_event_context *ctx = tsk->perf_event_ctxp;
+	unsigned int *task_bp_pinned;
+	struct list_head *list;
+	unsigned long flags;
+
+	if (WARN_ONCE(!ctx, "No perf context for this task"))
+		return;
+
+	list = &ctx->event_list;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	/*
+	 * The current breakpoint counter is not included in the list
+	 * at the open() callback time
+	 */
+	list_for_each_entry(bp, list, event_entry) {
+		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
+			count++;
+	}
+
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	if (WARN_ONCE(count < 0, "No breakpoint counter found in the counter list"))
+		return;
+
+	task_bp_pinned = per_cpu(task_bp_pinned, cpu);
+	if (enable) {
+		task_bp_pinned[count]++;
+		if (count > 0)
+			task_bp_pinned[count-1]--;
+	} else {
+		task_bp_pinned[count]--;
+		if (count > 0)
+			task_bp_pinned[count-1]++;
+	}
+}
+
+/*
+ * Add/remove the given breakpoint in our constraint table
+ */
+static void toggle_bp_slot(struct perf_event *bp, bool enable)
+{
+	int cpu = bp->cpu;
+	struct task_struct *tsk = bp->ctx->task;
+
+	/* Pinned counter task profiling */
+	if (tsk) {
+		if (cpu >= 0) {
+			toggle_bp_task_slot(tsk, cpu, enable);
+			return;
+		}
+
+		for_each_online_cpu(cpu)
+			toggle_bp_task_slot(tsk, cpu, enable);
+		return;
+	}
+
+	/* Pinned counter cpu profiling */
+	if (enable)
+		per_cpu(nr_cpu_bp_pinned, bp->cpu)++;
+	else
+		per_cpu(nr_cpu_bp_pinned, bp->cpu)--;
+}
+
+/*
+ * Contraints to check before allowing this new breakpoint counter:
+ *
+ *  == Non-pinned counter == (Considered as pinned for now)
+ *
+ *   - If attached to a single cpu, check:
+ *
+ *       (per_cpu(nr_bp_flexible, cpu) || (per_cpu(nr_cpu_bp_pinned, cpu)
+ *           + max(per_cpu(task_bp_pinned, cpu)))) < HBP_NUM
+ *
+ *       -> If there are already non-pinned counters in this cpu, it means
+ *          there is already a free slot for them.
+ *          Otherwise, we check that the maximum number of per task
+ *          breakpoints (for this cpu) plus the number of per cpu breakpoint
+ *          (for this cpu) doesn't cover every registers.
+ *
+ *   - If attached to every cpus, check:
+ *
+ *       (per_cpu(nr_bp_flexible, *) || (max(per_cpu(nr_cpu_bp_pinned, *))
+ *           + max(per_cpu(task_bp_pinned, *)))) < HBP_NUM
+ *
+ *       -> This is roughly the same, except we check the number of per cpu
+ *          bp for every cpu and we keep the max one. Same for the per tasks
+ *          breakpoints.
+ *
+ *
+ * == Pinned counter ==
+ *
+ *   - If attached to a single cpu, check:
+ *
+ *       ((per_cpu(nr_bp_flexible, cpu) > 1) + per_cpu(nr_cpu_bp_pinned, cpu)
+ *            + max(per_cpu(task_bp_pinned, cpu))) < HBP_NUM
+ *
+ *       -> Same checks as before. But now the nr_bp_flexible, if any, must keep
+ *          one register at least (or they will never be fed).
+ *
+ *   - If attached to every cpus, check:
+ *
+ *       ((per_cpu(nr_bp_flexible, *) > 1) + max(per_cpu(nr_cpu_bp_pinned, *))
+ *            + max(per_cpu(task_bp_pinned, *))) < HBP_NUM
+ */
+int reserve_bp_slot(struct perf_event *bp)
+{
+	struct bp_busy_slots slots = {0};
+	int ret = 0;
+
+	mutex_lock(&nr_bp_mutex);
+
+	fetch_bp_busy_slots(&slots, bp->cpu);
+
+	/* Flexible counters need to keep at least one slot */
+	if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
+		ret = -ENOSPC;
+		goto end;
+	}
+
+	toggle_bp_slot(bp, true);
+
+end:
+	mutex_unlock(&nr_bp_mutex);
+
+	return ret;
+}
+
 void release_bp_slot(struct perf_event *bp)
 {
-	atomic_dec(&bp_slot);
+	mutex_lock(&nr_bp_mutex);
+
+	toggle_bp_slot(bp, false);
+
+	mutex_unlock(&nr_bp_mutex);
 }
 
+
 int __register_perf_hw_breakpoint(struct perf_event *bp)
 {
 	int ret;
-- 
1.6.2.3


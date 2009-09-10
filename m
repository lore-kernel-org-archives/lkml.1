Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbZIJIaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbZIJIaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbZIJIaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:30:03 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39709 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZIJI3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IlRW1SHYqYCZr6RsIAOBdnsvJxoF1DAkIbK+5zo7pR4VGExwvlefYbQxThZ42I4FLY
         5lTQ/m/DLGeFHU7ZCVPcvwPp2C1ko8vzNzazRvzLK0YjZn8XJYuL0anga4iMoN75Skv1
         DyshKxcBlyfyrTPR+TnwBlP9Hsxmb6OiwbLP8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 4/5] hw-breakpoints: Arbitrate access to pmu following registers constraints
Date: Thu, 10 Sep 2009 10:29:26 +0200
Message-Id: <1252571367-25876-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
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

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/hw_breakpoint.c |  237 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 231 insertions(+), 6 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 1d6a6e8..d3ab31b 100644
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
@@ -45,24 +47,247 @@
 #include <asm/debugreg.h>
 #endif
 
-static atomic_t bp_slot;
+/*
+ * Constraints data
+ */
+
+/* Number of pinned cpu breakpoints in a cpu */
+static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned);
 
-static int reserve_bp_slot(struct perf_counter *counter)
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
+	struct perf_counter *counter;
+	struct perf_counter_context *ctx = tsk->perf_counter_ctxp;
+	unsigned int *task_bp_pinned;
+	struct list_head *list;
+	unsigned long flags;
+
+	if (WARN_ONCE(!ctx, "No perf context for this task"))
+		return;
+
+	list = &ctx->counter_list;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	/*
+	 * The current breakpoint counter is not included in the list
+	 * at the open() callback time
+	 */
+	list_for_each_entry(counter, list, list_entry) {
+		if (counter->attr.type == PERF_TYPE_BREAKPOINT)
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
+static void toggle_bp_slot(struct perf_counter *counter, bool enable)
+{
+	int cpu = counter->cpu;
+	unsigned int *nr;
+	struct task_struct *tsk = counter->ctx->task;
+
+	/* Flexible */
+	if (!counter->attr.pinned) {
+		if (cpu >= 0) {
+			nr = &per_cpu(nr_bp_flexible, cpu);
+			goto toggle;
+		}
+
+		for_each_online_cpu(cpu) {
+			nr = &per_cpu(nr_bp_flexible, cpu);
+			goto toggle;
+		}
+	}
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
+	nr = &per_cpu(nr_cpu_bp_pinned, counter->cpu);
+
+toggle:
+	*nr = enable ? *nr + 1 : *nr - 1;
+}
+
+/*
+ * Contraints to check before allowing this new breakpoint counter:
+ *
+ *  == Non-pinned counter ==
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
+static int reserve_bp_slot(struct perf_counter *counter)
+{
+	struct bp_busy_slots slots = {0};
+	int ret = 0;
+
+	mutex_lock(&nr_bp_mutex);
+
+	fetch_bp_busy_slots(&slots, counter->cpu);
+
+	if (!counter->attr.pinned) {
+		/*
+		 * If there are already flexible counters here,
+		 * there is at least one slot reserved for all
+		 * of them. Just join the party.
+		 *
+		 * Otherwise, check there is at least one free slot
+		 */
+		if (!slots.flexible && slots.pinned == HBP_NUM) {
+			ret = -ENOSPC;
+			goto end;
+		}
+
+	/* Flexible counters need to keep at least one slot */
+	} else if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
+		ret = -ENOSPC;
+		goto end;
+	}
+
+	toggle_bp_slot(counter, true);
+
+end:
+	mutex_unlock(&nr_bp_mutex);
+
+	return ret;
+}
+
 static void release_bp_slot(struct perf_counter *counter)
 {
-	atomic_dec(&bp_slot);
+	mutex_lock(&nr_bp_mutex);
+
+	toggle_bp_slot(counter, false);
+
+	mutex_unlock(&nr_bp_mutex);
 }
 
+
 int __register_perf_hw_breakpoint(struct perf_counter *counter)
 {
 	int ret;
-- 
1.6.2.3


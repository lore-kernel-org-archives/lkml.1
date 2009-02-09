Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZBILnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZBILnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZBILm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:42:57 -0500
Received: from ozlabs.org ([203.10.76.45]:43497 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZBILm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:42:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18832.5815.706605.434454@cargo.ozlabs.ibm.com>
Date: Mon, 9 Feb 2009 22:42:47 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Make software counters work as per-cpu counters
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: kernel crash fix

Yanmin Zhang reported that using a PERF_COUNT_TASK_CLOCK software
counter as a per-cpu counter would reliably crash the system, because
it calls __task_delta_exec with a null pointer.  The page fault,
context switch and cpu migration counters also won't function
correctly as per-cpu counters since they reference the current task.

This fixes the problem by redirecting the task_clock counter to the
cpu_clock counter when used as a per-cpu counter, and by implementing
per-cpu page fault, context switch and cpu migration counters.

Along the way, this:

- Initializes counter->ctx earlier, in perf_counter_alloc, so that
  sw_perf_counter_init can use it
- Adds code to kernel/sched.c to count task migrations into each
  cpu, in rq->nr_migrations_in
- Exports the per-cpu context switch and task migration counts
  via new functions added to kernel/sched.c
- Makes sure that if sw_perf_counter_init fails, we don't try to
  initialize the counter as a hardware counter.  Since the user has
  passed a negative, non-raw event type, they clearly don't intend
  for it to be interpreted as a hardware event.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
I'm a little concerned about the use of u64 for the existing
rq->nr_switches and the new rq->nr_migrations_in.  On 32-bit machines
this will get updated in two halves, so there is a very small but
non-zero probability that reading it will give a bogus value.  It's
not clear to me what the best way to fix it is, since not all 32-bit
platforms have atomic64_t.  Maybe make nr_switches and
nr_migrations_in unsigned long, or atomic_t?

I have some sort of git problem with my perfcounters.git repository.
I'll let you know when I have that sorted out.

 include/linux/sched.h |    2 +
 kernel/perf_counter.c |   78 ++++++++++++++++++++++++++++--------------------
 kernel/sched.c        |   17 ++++++++++
 3 files changed, 64 insertions(+), 33 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b85b10a..1e5f700 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -137,6 +137,8 @@ extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
+extern u64 cpu_nr_switches(int cpu);
+extern u64 cpu_nr_migrations(int cpu);
 
 struct seq_file;
 struct cfs_rq;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f27a7e9..544193c 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -20,6 +20,8 @@
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
 #include <linux/perf_counter.h>
+#include <linux/mm.h>
+#include <linux/vmstat.h>
 
 /*
  * Each CPU has a list of per CPU counters:
@@ -502,7 +504,6 @@ perf_install_in_context(struct perf_counter_context *ctx,
 {
 	struct task_struct *task = ctx->task;
 
-	counter->ctx = ctx;
 	if (!task) {
 		/*
 		 * Per cpu counters are installed via an smp call and
@@ -1417,11 +1418,19 @@ static const struct hw_perf_counter_ops perf_ops_task_clock = {
 	.read		= task_clock_perf_counter_read,
 };
 
-static u64 get_page_faults(void)
+#ifdef CONFIG_VM_EVENT_COUNTERS
+#define cpu_page_faults()	__get_cpu_var(vm_event_states).event[PGFAULT]
+#else
+#define cpu_page_faults()	0
+#endif
+
+static u64 get_page_faults(struct perf_counter *counter)
 {
-	struct task_struct *curr = current;
+	struct task_struct *curr = counter->ctx->task;
 
-	return curr->maj_flt + curr->min_flt;
+	if (curr)
+		return curr->maj_flt + curr->min_flt;
+	return cpu_page_faults();
 }
 
 static void page_faults_perf_counter_update(struct perf_counter *counter)
@@ -1430,7 +1439,7 @@ static void page_faults_perf_counter_update(struct perf_counter *counter)
 	s64 delta;
 
 	prev = atomic64_read(&counter->hw.prev_count);
-	now = get_page_faults();
+	now = get_page_faults(counter);
 
 	atomic64_set(&counter->hw.prev_count, now);
 
@@ -1446,11 +1455,7 @@ static void page_faults_perf_counter_read(struct perf_counter *counter)
 
 static int page_faults_perf_counter_enable(struct perf_counter *counter)
 {
-	/*
-	 * page-faults is a per-task value already,
-	 * so we dont have to clear it on switch-in.
-	 */
-
+	atomic64_set(&counter->hw.prev_count, get_page_faults(counter));
 	return 0;
 }
 
@@ -1465,11 +1470,13 @@ static const struct hw_perf_counter_ops perf_ops_page_faults = {
 	.read		= page_faults_perf_counter_read,
 };
 
-static u64 get_context_switches(void)
+static u64 get_context_switches(struct perf_counter *counter)
 {
-	struct task_struct *curr = current;
+	struct task_struct *curr = counter->ctx->task;
 
-	return curr->nvcsw + curr->nivcsw;
+	if (curr)
+		return curr->nvcsw + curr->nivcsw;
+	return cpu_nr_switches(smp_processor_id());
 }
 
 static void context_switches_perf_counter_update(struct perf_counter *counter)
@@ -1478,7 +1485,7 @@ static void context_switches_perf_counter_update(struct perf_counter *counter)
 	s64 delta;
 
 	prev = atomic64_read(&counter->hw.prev_count);
-	now = get_context_switches();
+	now = get_context_switches(counter);
 
 	atomic64_set(&counter->hw.prev_count, now);
 
@@ -1494,11 +1501,7 @@ static void context_switches_perf_counter_read(struct perf_counter *counter)
 
 static int context_switches_perf_counter_enable(struct perf_counter *counter)
 {
-	/*
-	 * ->nvcsw + curr->nivcsw is a per-task value already,
-	 * so we dont have to clear it on switch-in.
-	 */
-
+	atomic64_set(&counter->hw.prev_count, get_context_switches(counter));
 	return 0;
 }
 
@@ -1513,9 +1516,13 @@ static const struct hw_perf_counter_ops perf_ops_context_switches = {
 	.read		= context_switches_perf_counter_read,
 };
 
-static inline u64 get_cpu_migrations(void)
+static inline u64 get_cpu_migrations(struct perf_counter *counter)
 {
-	return current->se.nr_migrations;
+	struct task_struct *curr = counter->ctx->task;
+
+	if (curr)
+		return curr->se.nr_migrations;
+	return cpu_nr_migrations(smp_processor_id());
 }
 
 static void cpu_migrations_perf_counter_update(struct perf_counter *counter)
@@ -1524,7 +1531,7 @@ static void cpu_migrations_perf_counter_update(struct perf_counter *counter)
 	s64 delta;
 
 	prev = atomic64_read(&counter->hw.prev_count);
-	now = get_cpu_migrations();
+	now = get_cpu_migrations(counter);
 
 	atomic64_set(&counter->hw.prev_count, now);
 
@@ -1540,11 +1547,7 @@ static void cpu_migrations_perf_counter_read(struct perf_counter *counter)
 
 static int cpu_migrations_perf_counter_enable(struct perf_counter *counter)
 {
-	/*
-	 * se.nr_migrations is a per-task value already,
-	 * so we dont have to clear it on switch-in.
-	 */
-
+	atomic64_set(&counter->hw.prev_count, get_cpu_migrations(counter));
 	return 0;
 }
 
@@ -1569,7 +1572,14 @@ sw_perf_counter_init(struct perf_counter *counter)
 		hw_ops = &perf_ops_cpu_clock;
 		break;
 	case PERF_COUNT_TASK_CLOCK:
-		hw_ops = &perf_ops_task_clock;
+		/*
+		 * If the user instantiates this as a per-cpu counter,
+		 * use the cpu_clock counter instead.
+		 */
+		if (counter->ctx->task)
+			hw_ops = &perf_ops_task_clock;
+		else
+			hw_ops = &perf_ops_cpu_clock;
 		break;
 	case PERF_COUNT_PAGE_FAULTS:
 		hw_ops = &perf_ops_page_faults;
@@ -1592,6 +1602,7 @@ sw_perf_counter_init(struct perf_counter *counter)
 static struct perf_counter *
 perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 		   int cpu,
+		   struct perf_counter_context *ctx,
 		   struct perf_counter *group_leader,
 		   gfp_t gfpflags)
 {
@@ -1623,6 +1634,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	counter->wakeup_pending		= 0;
 	counter->group_leader		= group_leader;
 	counter->hw_ops			= NULL;
+	counter->ctx			= ctx;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	if (hw_event->disabled)
@@ -1631,7 +1643,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	hw_ops = NULL;
 	if (!hw_event->raw && hw_event->type < 0)
 		hw_ops = sw_perf_counter_init(counter);
-	if (!hw_ops)
+	else
 		hw_ops = hw_perf_counter_init(counter);
 
 	if (!hw_ops) {
@@ -1707,7 +1719,8 @@ sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
 	}
 
 	ret = -EINVAL;
-	counter = perf_counter_alloc(&hw_event, cpu, group_leader, GFP_KERNEL);
+	counter = perf_counter_alloc(&hw_event, cpu, ctx, group_leader,
+				     GFP_KERNEL);
 	if (!counter)
 		goto err_put_context;
 
@@ -1777,15 +1790,14 @@ inherit_counter(struct perf_counter *parent_counter,
 		parent_counter = parent_counter->parent;
 
 	child_counter = perf_counter_alloc(&parent_counter->hw_event,
-					    parent_counter->cpu, group_leader,
-					    GFP_KERNEL);
+					   parent_counter->cpu, child_ctx,
+					   group_leader, GFP_KERNEL);
 	if (!child_counter)
 		return NULL;
 
 	/*
 	 * Link it up in the child's context:
 	 */
-	child_counter->ctx = child_ctx;
 	child_counter->task = child;
 	list_add_counter(child_counter, child_ctx);
 	child_ctx->nr_counters++;
diff --git a/kernel/sched.c b/kernel/sched.c
index 8db1a4c..173768f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -558,6 +558,7 @@ struct rq {
 	struct load_weight load;
 	unsigned long nr_load_updates;
 	u64 nr_switches;
+	u64 nr_migrations_in;
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
@@ -1908,6 +1909,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 #endif
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
+		new_rq->nr_migrations_in++;
 #ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
@@ -2811,6 +2813,21 @@ unsigned long nr_active(void)
 }
 
 /*
+ * Externally visible per-cpu scheduler statistics:
+ * cpu_nr_switches(cpu) - number of context switches on that cpu
+ * cpu_nr_migrations(cpu) - number of migrations into that cpu
+ */
+u64 cpu_nr_switches(int cpu)
+{
+	return cpu_rq(cpu)->nr_switches;
+}
+
+u64 cpu_nr_migrations(int cpu)
+{
+	return cpu_rq(cpu)->nr_migrations_in;
+}
+
+/*
  * Update rq->cpu_load[] statistics. This function is usually called every
  * scheduler tick (TICK_NSEC).
  */
-- 
1.6.1.rc1.56.g2dd62


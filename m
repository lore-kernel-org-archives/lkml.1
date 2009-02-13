Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZBMLLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZBMLLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZBMLKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:10:51 -0500
Received: from ozlabs.org ([203.10.76.45]:42994 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbZBMLKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:10:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18837.21802.429822.796289@cargo.ozlabs.ibm.com>
Date: Fri, 13 Feb 2009 22:10:34 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] Make context switch and migration software counters
   work again
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput reported that commit 23a185ca8abbeef caused the
context switch and migration software counters to report zero always.
With that commit, the software counters only count events that occur
between sched-in and sched-out for a task.  This is necessary for the
counter enable/disable prctls and ioctls to work.  However, the
context switch and migration counts are incremented after sched-out
for one task and before sched-in for the next.  Since the increment
doesn't occur while a task is scheduled in (as far as the software
counters are concerned) it doesn't count towards any counter.

Thus the context switch and migration counters need to count events
that occur at any time, provided the counter is enabled, not just
those that occur while the task is scheduled in (from the perf_counter
subsystem's point of view).  The problem though is that the software
counter code can't tell the difference between being enabled and being
scheduled in, and between being disabled and being scheduled out,
since we use the one pair of enable/disable entry points for both.
That is, the high-level disable operation simply arranges for the
counter to not be scheduled in any more, and the high-level enable
operation arranges for it to be scheduled in again.

One way to solve this would be to have sched_in/out operations in the
hw_perf_counter_ops struct as well as enable/disable.  However, this
takes a simpler approach: it adds a 'prev_state' field to the
perf_counter struct that allows a counter's enable method to know
whether the counter was previously disabled or just inactive
(scheduled out), and therefore whether the enable method is being
called as a result of a high-level enable or a schedule-in operation.

This then allows the context switch, migration and page fault counters
to reset their hw.prev_count value in their enable functions only if
they are called as a result of a high-level enable operation.
Although page faults would normally only occur while the counter is
scheduled in, this changes the page fault counter code too in case
there are ever circumstances where page faults get counted against a
task while its counters are not scheduled in.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This was the simplest fix I could come up with that allowed enable/
disable to work properly.  In some ways having separate sched_in/out
and enable/disable operations would be nicer but it started to get
rather invasive.  In future it might be useful to have sched-in/out
separate from enable/disable so that we can optimize sched-in/out.
For example, on the POWER processors we could use the PM mark bit to
turn counting on and off quickly in the case where only one task is
currently using the PMU on a given cpu and there are no per-cpu
counters.

 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |   21 +++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c83f51d..32cd1ac 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -173,6 +173,7 @@ struct perf_counter {
 	const struct hw_perf_counter_ops *hw_ops;
 
 	enum perf_counter_active_state	state;
+	enum perf_counter_active_state	prev_state;
 	atomic64_t			count;
 
 	struct perf_counter_hw_event	hw_event;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index fcefb0a..26e2b47 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -444,6 +444,7 @@ static void __perf_install_in_context(void *info)
 
 	list_add_counter(counter, ctx);
 	ctx->nr_counters++;
+	counter->prev_state = PERF_COUNTER_STATE_OFF;
 
 	/*
 	 * Don't put the counter on if it is disabled or if
@@ -562,6 +563,7 @@ static void __perf_counter_enable(void *info)
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
 
+	counter->prev_state = counter->state;
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
@@ -733,6 +735,7 @@ group_sched_in(struct perf_counter *group_counter,
 	if (ret)
 		return ret < 0 ? ret : 0;
 
+	group_counter->prev_state = group_counter->state;
 	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
 		return -EAGAIN;
 
@@ -740,6 +743,7 @@ group_sched_in(struct perf_counter *group_counter,
 	 * Schedule in siblings as one group (if any):
 	 */
 	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		counter->prev_state = counter->state;
 		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
 			partial_group = counter;
 			goto group_error;
@@ -1398,9 +1402,9 @@ static void task_clock_perf_counter_read(struct perf_counter *counter)
 
 static int task_clock_perf_counter_enable(struct perf_counter *counter)
 {
-	u64 now = task_clock_perf_counter_val(counter, 0);
-
-	atomic64_set(&counter->hw.prev_count, now);
+	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
+		atomic64_set(&counter->hw.prev_count,
+			     task_clock_perf_counter_val(counter, 0));
 
 	return 0;
 }
@@ -1455,7 +1459,8 @@ static void page_faults_perf_counter_read(struct perf_counter *counter)
 
 static int page_faults_perf_counter_enable(struct perf_counter *counter)
 {
-	atomic64_set(&counter->hw.prev_count, get_page_faults(counter));
+	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
+		atomic64_set(&counter->hw.prev_count, get_page_faults(counter));
 	return 0;
 }
 
@@ -1501,7 +1506,9 @@ static void context_switches_perf_counter_read(struct perf_counter *counter)
 
 static int context_switches_perf_counter_enable(struct perf_counter *counter)
 {
-	atomic64_set(&counter->hw.prev_count, get_context_switches(counter));
+	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
+		atomic64_set(&counter->hw.prev_count,
+			     get_context_switches(counter));
 	return 0;
 }
 
@@ -1547,7 +1554,9 @@ static void cpu_migrations_perf_counter_read(struct perf_counter *counter)
 
 static int cpu_migrations_perf_counter_enable(struct perf_counter *counter)
 {
-	atomic64_set(&counter->hw.prev_count, get_cpu_migrations(counter));
+	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
+		atomic64_set(&counter->hw.prev_count,
+			     get_cpu_migrations(counter));
 	return 0;
 }
 

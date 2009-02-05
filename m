Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZBEEwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZBEEwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 23:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZBEEwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 23:52:40 -0500
Received: from ozlabs.org ([203.10.76.45]:34183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbZBEEwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 23:52:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18826.28805.120988.303819@drongo.ozlabs.ibm.com>
Date: Thu, 5 Feb 2009 15:52:21 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Prevent oopses from per-cpu software counters
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: oops fix

Yanmin Zhang reported that using a PERF_COUNT_TASK_CLOCK software
counter as a per-cpu counter would reliably crash the system, because
it calls __task_delta_exec with a null pointer.  And indeed, a "task
clock" counter only makes sense as a per-task counter.  Similarly,
counting page faults, context switches or cpu migrations only makes
sense for a per-task counter.

This fixes the problem by disallowing the use of the task clock,
page fault, context switch and cpu migration software counters as
per-cpu counters, since they all require a task context to obtain their
data.  The only software counter that can be used as a per-cpu counter
is the cpu clock counter (PERF_COUNT_CPU_CYCLES).

In order for sw_perf_counter_init to be able to tell whether we are
setting up a per-task or a per-cpu counter, this arranges for counter->ctx
to be initialized earlier, in perf_counter_alloc.

The other minor change this makes is to ensure that if sw_perf_counter_init
fails, we don't try to initialize the counter as a hardware counter.
Since the user has passed a negative event type (and it isn't raw), they
clearly don't intend it to be interpreted as a hardware event.  This
matters now that sw_perf_counter_init can fail for valid software event
types (because of the check that the counter is a per-task counter).

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is in my perfcounters.git tree master branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

Ingo - pull if you agree with it.  The check in sw_perf_counter_init
may need to be modified if we add more software counters, of course,
but that can happen later.

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f27a7e9..47d91da 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -502,7 +502,6 @@ perf_install_in_context(struct perf_counter_context *ctx,
 {
 	struct task_struct *task = ctx->task;
 
-	counter->ctx = ctx;
 	if (!task) {
 		/*
 		 * Per cpu counters are installed via an smp call and
@@ -1564,6 +1563,15 @@ sw_perf_counter_init(struct perf_counter *counter)
 {
 	const struct hw_perf_counter_ops *hw_ops = NULL;
 
+	/*
+	 * PERF_COUNT_CPU_CLOCK is the only type that is valid
+	 * for a per-cpu counter.  All the others require a task
+	 * context and thus can only be used as per-task counters.
+	 */
+	if (!counter->ctx->task &&
+	    counter->hw_event.type != PERF_COUNT_CPU_CLOCK)
+		return NULL;
+
 	switch (counter->hw_event.type) {
 	case PERF_COUNT_CPU_CLOCK:
 		hw_ops = &perf_ops_cpu_clock;
@@ -1592,6 +1600,7 @@ sw_perf_counter_init(struct perf_counter *counter)
 static struct perf_counter *
 perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 		   int cpu,
+		   struct perf_counter_context *ctx,
 		   struct perf_counter *group_leader,
 		   gfp_t gfpflags)
 {
@@ -1623,6 +1632,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	counter->wakeup_pending		= 0;
 	counter->group_leader		= group_leader;
 	counter->hw_ops			= NULL;
+	counter->ctx			= ctx;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	if (hw_event->disabled)
@@ -1631,7 +1641,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	hw_ops = NULL;
 	if (!hw_event->raw && hw_event->type < 0)
 		hw_ops = sw_perf_counter_init(counter);
-	if (!hw_ops)
+	else
 		hw_ops = hw_perf_counter_init(counter);
 
 	if (!hw_ops) {
@@ -1707,7 +1717,8 @@ sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
 	}
 
 	ret = -EINVAL;
-	counter = perf_counter_alloc(&hw_event, cpu, group_leader, GFP_KERNEL);
+	counter = perf_counter_alloc(&hw_event, cpu, ctx, group_leader,
+				     GFP_KERNEL);
 	if (!counter)
 		goto err_put_context;
 
@@ -1777,15 +1788,14 @@ inherit_counter(struct perf_counter *parent_counter,
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


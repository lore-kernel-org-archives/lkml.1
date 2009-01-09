Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZAIKqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZAIKqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZAIKqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:46:37 -0500
Received: from ozlabs.org ([203.10.76.45]:44273 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZAIKqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:46:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.11004.802571.720430@cargo.ozlabs.ibm.com>
Date: Fri, 9 Jan 2009 21:46:20 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/9] perf_counter: Add optional hw_perf_group_sched_in arch function
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: extend perf_counter infrastructure

This adds an optional hw_perf_group_sched_in() arch function that enables
a whole group of counters in one go.  It returns 1 if it added the group
successfully, 0 if it did nothing (and therefore the core needs to add
the counters individually), or a negative number if an error occurred.
It should add all the counters and enable any software counters in the
group, or else add none of them and return an error.

There are a couple of related changes/improvements in the group handling
here:

* As an optimization, group_sched_out() and group_sched_in() now check the
  state of the group leader, and do nothing if the leader is not active
  or disabled.

* We now call hw_perf_save_disable/hw_perf_restore around the complete
  set of counter enable/disable calls in __perf_counter_sched_in/out,
  to give the arch code the opportunity to defer updating the hardware
  state until the hw_perf_restore call if it wants.

* We no longer stop adding groups after we get to a group that has more
  than one counter.  We will ultimately add an option for a group to be
  exclusive.  The current code doesn't really implement exclusive groups
  anyway, since a group could end up going on with other counters that
  get added before it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index cc3a75a..b21d1ea 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -236,6 +236,9 @@ extern u64 hw_perf_save_disable(void);
 extern void hw_perf_restore(u64 ctrl);
 extern int perf_counter_task_disable(void);
 extern int perf_counter_task_enable(void);
+extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu);
 
 #else
 static inline void
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b7a027a..9ad11e4 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -47,6 +47,12 @@ hw_perf_counter_init(struct perf_counter *counter)
 u64 __weak hw_perf_save_disable(void)		{ return 0; }
 void __weak hw_perf_restore(u64 ctrl)		{ barrier(); }
 void __weak hw_perf_counter_setup(void)		{ barrier(); }
+int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu)
+{
+	return 0;
+}
 
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
@@ -341,6 +347,9 @@ group_sched_out(struct perf_counter *group_counter,
 {
 	struct perf_counter *counter;
 
+	if (group_counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
 	counter_sched_out(group_counter, cpuctx, ctx);
 
 	/*
@@ -354,15 +363,18 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 			      struct perf_cpu_context *cpuctx)
 {
 	struct perf_counter *counter;
+	u64 flags;
 
 	if (likely(!ctx->nr_counters))
 		return;
 
 	spin_lock(&ctx->lock);
+	flags = hw_perf_save_disable();
 	if (ctx->nr_active) {
 		list_for_each_entry(counter, &ctx->counter_list, list_entry)
 			group_sched_out(counter, cpuctx, ctx);
 	}
+	hw_perf_restore(flags);
 	spin_unlock(&ctx->lock);
 }
 
@@ -402,7 +414,14 @@ group_sched_in(struct perf_counter *group_counter,
 	       int cpu)
 {
 	struct perf_counter *counter, *partial_group;
-	int ret = 0;
+	int ret;
+
+	if (group_counter->state == PERF_COUNTER_STATE_OFF)
+		return 0;
+
+	ret = hw_perf_group_sched_in(group_counter, cpuctx, ctx, cpu);
+	if (ret)
+		return ret < 0 ? ret : 0;
 
 	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
 		return -EAGAIN;
@@ -415,10 +434,9 @@ group_sched_in(struct perf_counter *group_counter,
 			partial_group = counter;
 			goto group_error;
 		}
-		ret = -EAGAIN;
 	}
 
-	return ret;
+	return 0;
 
 group_error:
 	/*
@@ -440,11 +458,13 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 			struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct perf_counter *counter;
+	u64 flags;
 
 	if (likely(!ctx->nr_counters))
 		return;
 
 	spin_lock(&ctx->lock);
+	flags = hw_perf_save_disable();
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
 		/*
 		 * Listen to the 'cpu' scheduling filter constraint
@@ -454,12 +474,13 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 			continue;
 
 		/*
-		 * If we scheduled in a group atomically and
-		 * exclusively, break out:
+		 * If we scheduled in a group atomically and exclusively,
+		 * or if this group can't go on, break out:
 		 */
 		if (group_sched_in(counter, cpuctx, ctx, cpu))
 			break;
 	}
+	hw_perf_restore(flags);
 	spin_unlock(&ctx->lock);
 }
 

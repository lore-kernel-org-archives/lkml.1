Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZFYTog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZFYTog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbZFYToG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:44:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:45335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759838AbZFYToE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:44:04 -0400
Date: Thu, 25 Jun 2009 19:43:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Implement more accurate per task statistics
Message-ID: <tip-bfbd3381e63aa2a14c6706afb50ce4630aa0d9a2@git.kernel.org>
Git-Commit-ID: bfbd3381e63aa2a14c6706afb50ce4630aa0d9a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:43:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfbd3381e63aa2a14c6706afb50ce4630aa0d9a2
Gitweb:     http://git.kernel.org/tip/bfbd3381e63aa2a14c6706afb50ce4630aa0d9a2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 24 Jun 2009 21:11:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:07 +0200

perf_counter: Implement more accurate per task statistics

With the introduction of PERF_EVENT_READ we have the
possibility to provide accurate counter values for
individual tasks in a task hierarchy.

However, due to the lazy context switching used for similar
counter contexts our current per task counts are way off.

In order to maintain some of the lazy switch benefits we
don't disable it out-right, but simply iterate the active
counters and flip the values between the contexts.

This only reads the counters but does not need to reprogram
the full PMU.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 ++-
 kernel/perf_counter.c        |   83 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6a384f0..de70a10 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -178,8 +178,9 @@ struct perf_counter_attr {
 				mmap           :  1, /* include mmap data     */
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
+				inherit_stat   :  1, /* per task counts       */
 
-				__reserved_1   : 53;
+				__reserved_1   : 52;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
@@ -602,6 +603,7 @@ struct perf_counter_context {
 	int				nr_counters;
 	int				nr_active;
 	int				is_active;
+	int				nr_stat;
 	atomic_t			refcount;
 	struct task_struct		*task;
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a72c20e..385ca51 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -236,6 +236,8 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 
 	list_add_rcu(&counter->event_entry, &ctx->event_list);
 	ctx->nr_counters++;
+	if (counter->attr.inherit_stat)
+		ctx->nr_stat++;
 }
 
 /*
@@ -250,6 +252,8 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	if (list_empty(&counter->list_entry))
 		return;
 	ctx->nr_counters--;
+	if (counter->attr.inherit_stat)
+		ctx->nr_stat--;
 
 	list_del_init(&counter->list_entry);
 	list_del_rcu(&counter->event_entry);
@@ -1006,6 +1010,76 @@ static int context_equiv(struct perf_counter_context *ctx1,
 		&& !ctx1->pin_count && !ctx2->pin_count;
 }
 
+static void __perf_counter_read(void *counter);
+
+static void __perf_counter_sync_stat(struct perf_counter *counter,
+				     struct perf_counter *next_counter)
+{
+	u64 value;
+
+	if (!counter->attr.inherit_stat)
+		return;
+
+	/*
+	 * Update the counter value, we cannot use perf_counter_read()
+	 * because we're in the middle of a context switch and have IRQs
+	 * disabled, which upsets smp_call_function_single(), however
+	 * we know the counter must be on the current CPU, therefore we
+	 * don't need to use it.
+	 */
+	switch (counter->state) {
+	case PERF_COUNTER_STATE_ACTIVE:
+		__perf_counter_read(counter);
+		break;
+
+	case PERF_COUNTER_STATE_INACTIVE:
+		update_counter_times(counter);
+		break;
+
+	default:
+		break;
+	}
+
+	/*
+	 * In order to keep per-task stats reliable we need to flip the counter
+	 * values when we flip the contexts.
+	 */
+	value = atomic64_read(&next_counter->count);
+	value = atomic64_xchg(&counter->count, value);
+	atomic64_set(&next_counter->count, value);
+
+	/*
+	 * XXX also sync time_enabled and time_running ?
+	 */
+}
+
+#define list_next_entry(pos, member) \
+	list_entry(pos->member.next, typeof(*pos), member)
+
+static void perf_counter_sync_stat(struct perf_counter_context *ctx,
+				   struct perf_counter_context *next_ctx)
+{
+	struct perf_counter *counter, *next_counter;
+
+	if (!ctx->nr_stat)
+		return;
+
+	counter = list_first_entry(&ctx->event_list,
+				   struct perf_counter, event_entry);
+
+	next_counter = list_first_entry(&next_ctx->event_list,
+					struct perf_counter, event_entry);
+
+	while (&counter->event_entry != &ctx->event_list &&
+	       &next_counter->event_entry != &next_ctx->event_list) {
+
+		__perf_counter_sync_stat(counter, next_counter);
+
+		counter = list_next_entry(counter, event_entry);
+		next_counter = list_next_entry(counter, event_entry);
+	}
+}
+
 /*
  * Called from scheduler to remove the counters of the current task,
  * with interrupts disabled.
@@ -1061,6 +1135,8 @@ void perf_counter_task_sched_out(struct task_struct *task,
 			ctx->task = next;
 			next_ctx->task = task;
 			do_switch = 0;
+
+			perf_counter_sync_stat(ctx, next_ctx);
 		}
 		spin_unlock(&next_ctx->lock);
 		spin_unlock(&ctx->lock);
@@ -1350,7 +1426,7 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 /*
  * Cross CPU call to read the hardware counter
  */
-static void __read(void *info)
+static void __perf_counter_read(void *info)
 {
 	struct perf_counter *counter = info;
 	struct perf_counter_context *ctx = counter->ctx;
@@ -1372,7 +1448,7 @@ static u64 perf_counter_read(struct perf_counter *counter)
 	 */
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
 		smp_call_function_single(counter->oncpu,
-					 __read, counter, 1);
+					 __perf_counter_read, counter, 1);
 	} else if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
 		update_counter_times(counter);
 	}
@@ -4050,7 +4126,8 @@ static void sync_child_counter(struct perf_counter *child_counter,
 	struct perf_counter *parent_counter = child_counter->parent;
 	u64 child_val;
 
-	perf_counter_read_event(child_counter, child);
+	if (child_counter->attr.inherit_stat)
+		perf_counter_read_event(child_counter, child);
 
 	child_val = atomic64_read(&child_counter->count);
 

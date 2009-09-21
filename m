Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZIUMw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZIUMw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbZIUMw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:52:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:54208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZIUMw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:52:56 -0400
Date: Mon, 21 Sep 2009 12:52:20 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/rename] perf_counter: Rename list_entry -> group_entry, counter_list -> group_list
Message-ID: <tip-65abc8653c282ded3dbdb9ec1227784140ba28cd@git.kernel.org>
Git-Commit-ID: 65abc8653c282ded3dbdb9ec1227784140ba28cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 12:52:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65abc8653c282ded3dbdb9ec1227784140ba28cd
Gitweb:     http://git.kernel.org/tip/65abc8653c282ded3dbdb9ec1227784140ba28cd
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 21 Sep 2009 10:18:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 21 Sep 2009 12:54:51 +0200

perf_counter: Rename list_entry -> group_entry, counter_list -> group_list

This is in preparation of the big rename, but also makes sense
in a standalone way: 'list_entry' is a bad name as we already
have a list_entry() in list.h.

Also, the 'counter list' is too vague, it doesnt tell us the
purpose of that list.

Clarify these names to show that it's all about the group
hiearchy.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 +-
 kernel/perf_counter.c        |   71 ++++++++++++++++++++---------------------
 2 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 740caad..f648627 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -543,7 +543,7 @@ struct perf_pending_entry {
  */
 struct perf_counter {
 #ifdef CONFIG_PERF_COUNTERS
-	struct list_head		list_entry;
+	struct list_head		group_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
 	int				nr_siblings;
@@ -649,7 +649,7 @@ struct perf_counter_context {
 	 */
 	struct mutex			mutex;
 
-	struct list_head		counter_list;
+	struct list_head		group_list;
 	struct list_head		event_list;
 	int				nr_counters;
 	int				nr_active;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index cc768ab..13ad73a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -258,9 +258,9 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	 * leader's sibling list:
 	 */
 	if (group_leader == counter)
-		list_add_tail(&counter->list_entry, &ctx->counter_list);
+		list_add_tail(&counter->group_entry, &ctx->group_list);
 	else {
-		list_add_tail(&counter->list_entry, &group_leader->sibling_list);
+		list_add_tail(&counter->group_entry, &group_leader->sibling_list);
 		group_leader->nr_siblings++;
 	}
 
@@ -279,13 +279,13 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 {
 	struct perf_counter *sibling, *tmp;
 
-	if (list_empty(&counter->list_entry))
+	if (list_empty(&counter->group_entry))
 		return;
 	ctx->nr_counters--;
 	if (counter->attr.inherit_stat)
 		ctx->nr_stat--;
 
-	list_del_init(&counter->list_entry);
+	list_del_init(&counter->group_entry);
 	list_del_rcu(&counter->event_entry);
 
 	if (counter->group_leader != counter)
@@ -296,10 +296,9 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	 * upgrade the siblings to singleton counters by adding them
 	 * to the context list directly:
 	 */
-	list_for_each_entry_safe(sibling, tmp,
-				 &counter->sibling_list, list_entry) {
+	list_for_each_entry_safe(sibling, tmp, &counter->sibling_list, group_entry) {
 
-		list_move_tail(&sibling->list_entry, &ctx->counter_list);
+		list_move_tail(&sibling->group_entry, &ctx->group_list);
 		sibling->group_leader = sibling;
 	}
 }
@@ -343,7 +342,7 @@ group_sched_out(struct perf_counter *group_counter,
 	/*
 	 * Schedule out siblings (if any):
 	 */
-	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
+	list_for_each_entry(counter, &group_counter->sibling_list, group_entry)
 		counter_sched_out(counter, cpuctx, ctx);
 
 	if (group_counter->attr.exclusive)
@@ -435,7 +434,7 @@ retry:
 	/*
 	 * If the context is active we need to retry the smp call.
 	 */
-	if (ctx->nr_active && !list_empty(&counter->list_entry)) {
+	if (ctx->nr_active && !list_empty(&counter->group_entry)) {
 		spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
@@ -445,7 +444,7 @@ retry:
 	 * can remove the counter safely, if the call above did not
 	 * succeed.
 	 */
-	if (!list_empty(&counter->list_entry)) {
+	if (!list_empty(&counter->group_entry)) {
 		list_del_counter(counter, ctx);
 	}
 	spin_unlock_irq(&ctx->lock);
@@ -497,7 +496,7 @@ static void update_group_times(struct perf_counter *leader)
 	struct perf_counter *counter;
 
 	update_counter_times(leader);
-	list_for_each_entry(counter, &leader->sibling_list, list_entry)
+	list_for_each_entry(counter, &leader->sibling_list, group_entry)
 		update_counter_times(counter);
 }
 
@@ -643,7 +642,7 @@ group_sched_in(struct perf_counter *group_counter,
 	/*
 	 * Schedule in siblings as one group (if any):
 	 */
-	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+	list_for_each_entry(counter, &group_counter->sibling_list, group_entry) {
 		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
 			partial_group = counter;
 			goto group_error;
@@ -657,7 +656,7 @@ group_error:
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:
 	 */
-	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+	list_for_each_entry(counter, &group_counter->sibling_list, group_entry) {
 		if (counter == partial_group)
 			break;
 		counter_sched_out(counter, cpuctx, ctx);
@@ -678,7 +677,7 @@ static int is_software_only_group(struct perf_counter *leader)
 	if (!is_software_counter(leader))
 		return 0;
 
-	list_for_each_entry(counter, &leader->sibling_list, list_entry)
+	list_for_each_entry(counter, &leader->sibling_list, group_entry)
 		if (!is_software_counter(counter))
 			return 0;
 
@@ -842,7 +841,7 @@ retry:
 	/*
 	 * we need to retry the smp call.
 	 */
-	if (ctx->is_active && list_empty(&counter->list_entry)) {
+	if (ctx->is_active && list_empty(&counter->group_entry)) {
 		spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
@@ -852,7 +851,7 @@ retry:
 	 * can add the counter safely, if it the call above did not
 	 * succeed.
 	 */
-	if (list_empty(&counter->list_entry))
+	if (list_empty(&counter->group_entry))
 		add_counter_to_ctx(counter, ctx);
 	spin_unlock_irq(&ctx->lock);
 }
@@ -872,7 +871,7 @@ static void __perf_counter_mark_enabled(struct perf_counter *counter,
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
-	list_for_each_entry(sub, &counter->sibling_list, list_entry)
+	list_for_each_entry(sub, &counter->sibling_list, group_entry)
 		if (sub->state >= PERF_COUNTER_STATE_INACTIVE)
 			sub->tstamp_enabled =
 				ctx->time - sub->total_time_enabled;
@@ -1032,7 +1031,7 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 
 	perf_disable();
 	if (ctx->nr_active) {
-		list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		list_for_each_entry(counter, &ctx->group_list, group_entry) {
 			if (counter != counter->group_leader)
 				counter_sched_out(counter, cpuctx, ctx);
 			else
@@ -1252,7 +1251,7 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
 	 */
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+	list_for_each_entry(counter, &ctx->group_list, group_entry) {
 		if (counter->state <= PERF_COUNTER_STATE_OFF ||
 		    !counter->attr.pinned)
 			continue;
@@ -1276,7 +1275,7 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 		}
 	}
 
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+	list_for_each_entry(counter, &ctx->group_list, group_entry) {
 		/*
 		 * Ignore counters in OFF or ERROR state, and
 		 * ignore pinned counters since we did them already.
@@ -1369,7 +1368,7 @@ static void perf_ctx_adjust_freq(struct perf_counter_context *ctx)
 	u64 interrupts, freq;
 
 	spin_lock(&ctx->lock);
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+	list_for_each_entry(counter, &ctx->group_list, group_entry) {
 		if (counter->state != PERF_COUNTER_STATE_ACTIVE)
 			continue;
 
@@ -1441,8 +1440,8 @@ static void rotate_ctx(struct perf_counter_context *ctx)
 	 * Rotate the first entry last (works just fine for group counters too):
 	 */
 	perf_disable();
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		list_move_tail(&counter->list_entry, &ctx->counter_list);
+	list_for_each_entry(counter, &ctx->group_list, group_entry) {
+		list_move_tail(&counter->group_entry, &ctx->group_list);
 		break;
 	}
 	perf_enable();
@@ -1498,7 +1497,7 @@ static void perf_counter_enable_on_exec(struct task_struct *task)
 
 	spin_lock(&ctx->lock);
 
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+	list_for_each_entry(counter, &ctx->group_list, group_entry) {
 		if (!counter->attr.enable_on_exec)
 			continue;
 		counter->attr.enable_on_exec = 0;
@@ -1575,7 +1574,7 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
-	INIT_LIST_HEAD(&ctx->counter_list);
+	INIT_LIST_HEAD(&ctx->group_list);
 	INIT_LIST_HEAD(&ctx->event_list);
 	atomic_set(&ctx->refcount, 1);
 	ctx->task = task;
@@ -1818,7 +1817,7 @@ static int perf_counter_read_group(struct perf_counter *counter,
 
 	size += err;
 
-	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		err = perf_counter_read_entry(sub, read_format,
 				buf + size);
 		if (err < 0)
@@ -1948,7 +1947,7 @@ static void perf_counter_for_each(struct perf_counter *counter,
 
 	perf_counter_for_each_child(counter, func);
 	func(counter);
-	list_for_each_entry(sibling, &counter->sibling_list, list_entry)
+	list_for_each_entry(sibling, &counter->sibling_list, group_entry)
 		perf_counter_for_each_child(counter, func);
 	mutex_unlock(&ctx->mutex);
 }
@@ -2832,7 +2831,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 
 	perf_output_copy(handle, values, n * sizeof(u64));
 
-	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		n = 0;
 
 		if (sub != counter)
@@ -4118,7 +4117,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	mutex_init(&counter->child_mutex);
 	INIT_LIST_HEAD(&counter->child_list);
 
-	INIT_LIST_HEAD(&counter->list_entry);
+	INIT_LIST_HEAD(&counter->group_entry);
 	INIT_LIST_HEAD(&counter->event_entry);
 	INIT_LIST_HEAD(&counter->sibling_list);
 	init_waitqueue_head(&counter->waitq);
@@ -4544,7 +4543,7 @@ static int inherit_group(struct perf_counter *parent_counter,
 				 child, NULL, child_ctx);
 	if (IS_ERR(leader))
 		return PTR_ERR(leader);
-	list_for_each_entry(sub, &parent_counter->sibling_list, list_entry) {
+	list_for_each_entry(sub, &parent_counter->sibling_list, group_entry) {
 		child_ctr = inherit_counter(sub, parent, parent_ctx,
 					    child, leader, child_ctx);
 		if (IS_ERR(child_ctr))
@@ -4670,8 +4669,8 @@ void perf_counter_exit_task(struct task_struct *child)
 	mutex_lock_nested(&child_ctx->mutex, SINGLE_DEPTH_NESTING);
 
 again:
-	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
-				 list_entry)
+	list_for_each_entry_safe(child_counter, tmp, &child_ctx->group_list,
+				 group_entry)
 		__perf_counter_exit_task(child_counter, child_ctx, child);
 
 	/*
@@ -4679,7 +4678,7 @@ again:
 	 * its siblings to the list, but we obtained 'tmp' before that which
 	 * will still point to the list head terminating the iteration.
 	 */
-	if (!list_empty(&child_ctx->counter_list))
+	if (!list_empty(&child_ctx->group_list))
 		goto again;
 
 	mutex_unlock(&child_ctx->mutex);
@@ -4701,7 +4700,7 @@ void perf_counter_free_task(struct task_struct *task)
 
 	mutex_lock(&ctx->mutex);
 again:
-	list_for_each_entry_safe(counter, tmp, &ctx->counter_list, list_entry) {
+	list_for_each_entry_safe(counter, tmp, &ctx->group_list, group_entry) {
 		struct perf_counter *parent = counter->parent;
 
 		if (WARN_ON_ONCE(!parent))
@@ -4717,7 +4716,7 @@ again:
 		free_counter(counter);
 	}
 
-	if (!list_empty(&ctx->counter_list))
+	if (!list_empty(&ctx->group_list))
 		goto again;
 
 	mutex_unlock(&ctx->mutex);
@@ -4847,7 +4846,7 @@ static void __perf_counter_exit_cpu(void *info)
 	struct perf_counter_context *ctx = &cpuctx->ctx;
 	struct perf_counter *counter, *tmp;
 
-	list_for_each_entry_safe(counter, tmp, &ctx->counter_list, list_entry)
+	list_for_each_entry_safe(counter, tmp, &ctx->group_list, group_entry)
 		__perf_counter_remove_from_context(counter);
 }
 static void perf_counter_exit_cpu(int cpu)

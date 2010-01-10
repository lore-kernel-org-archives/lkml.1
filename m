Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319Ab0AJBic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0AJBic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339Ab0AJBia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:38:30 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49789 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0AJBi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FLs5xx6opiZMphC1zroMjPrp6ulH9O0Id9yioz/O6/rNAo/+9VEZCtVlwKq2e6E/ry
         JcegscFhcq5sjjgLjdZk5RnnPfvYLwrr3EjXplMvmKBoCbY8qWUHfJJZXX0DiID1h5o/
         zjjrwHGeOUuMwP0tnQToswKjGJRWY4bBedKWU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/6 v2] perf/core: Split context's event group list into pinned and non-pinned lists
Date: Sun, 10 Jan 2010 02:38:15 +0100
Message-Id: <1263087500-14215-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split-up struct perf_event_context::group_list into pinned_groups
and flexible_groups (non-pinned).

This first appears to be useless as it duplicates various loops around
the group list handlings.

But it scales better in the fast-path in perf_sched_in(). We don't
anymore iterate twice through the entire list to separate pinned and
non-pinned scheduling. Instead we interate through two distinct lists.

The another desired effect is that it makes easier to define distinct
scheduling rules on both.

Changes in v2:
- Respectively rename pinned_grp_list and
  volatile_grp_list into pinned_groups and flexible_groups as per
  Ingo suggestion.
- Various cleanups

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_event.h |    3 +-
 kernel/perf_event.c        |  227 +++++++++++++++++++++++++++++---------------
 2 files changed, 153 insertions(+), 77 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9a1d276..cdbc2aa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -683,7 +683,8 @@ struct perf_event_context {
 	 */
 	struct mutex			mutex;
 
-	struct list_head		group_list;
+	struct list_head		pinned_groups;
+	struct list_head		flexible_groups;
 	struct list_head		event_list;
 	int				nr_events;
 	int				nr_active;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 27f69a0..c9f8a75 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -289,6 +289,15 @@ static void update_event_times(struct perf_event *event)
 	event->total_time_running = run_end - event->tstamp_running;
 }
 
+static struct list_head *
+ctx_group_list(struct perf_event *event, struct perf_event_context *ctx)
+{
+	if (event->attr.pinned)
+		return &ctx->pinned_groups;
+	else
+		return &ctx->flexible_groups;
+}
+
 /*
  * Add a event from the lists for its context.
  * Must be called with ctx->mutex and ctx->lock held.
@@ -303,9 +312,12 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	 * add it straight to the context's event list, or to the group
 	 * leader's sibling list:
 	 */
-	if (group_leader == event)
-		list_add_tail(&event->group_entry, &ctx->group_list);
-	else {
+	if (group_leader == event) {
+		struct list_head *list;
+
+		list = ctx_group_list(event, ctx);
+		list_add_tail(&event->group_entry, list);
+	} else {
 		list_add_tail(&event->group_entry, &group_leader->sibling_list);
 		group_leader->nr_siblings++;
 	}
@@ -355,8 +367,10 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	 * to the context list directly:
 	 */
 	list_for_each_entry_safe(sibling, tmp, &event->sibling_list, group_entry) {
+		struct list_head *list;
 
-		list_move_tail(&sibling->group_entry, &ctx->group_list);
+		list = ctx_group_list(event, ctx);
+		list_move_tail(&sibling->group_entry, list);
 		sibling->group_leader = sibling;
 	}
 }
@@ -1056,7 +1070,10 @@ void __perf_event_sched_out(struct perf_event_context *ctx,
 
 	perf_disable();
 	if (ctx->nr_active) {
-		list_for_each_entry(event, &ctx->group_list, group_entry)
+		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
+			group_sched_out(event, cpuctx, ctx);
+
+		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
 	perf_enable();
@@ -1271,9 +1288,8 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
 	 */
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
-		if (event->state <= PERF_EVENT_STATE_OFF ||
-		    !event->attr.pinned)
+	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
+		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 		if (event->cpu != -1 && event->cpu != cpu)
 			continue;
@@ -1291,15 +1307,10 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 		}
 	}
 
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
-		/*
-		 * Ignore events in OFF or ERROR state, and
-		 * ignore pinned events since we did them already.
-		 */
-		if (event->state <= PERF_EVENT_STATE_OFF ||
-		    event->attr.pinned)
+	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
+		/* Ignore events in OFF or ERROR state */
+		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-
 		/*
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
@@ -1453,8 +1464,13 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	 * Rotate the first entry last (works just fine for group events too):
 	 */
 	perf_disable();
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
-		list_move_tail(&event->group_entry, &ctx->group_list);
+	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
+		list_move_tail(&event->group_entry, &ctx->pinned_groups);
+		break;
+	}
+
+	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
+		list_move_tail(&event->group_entry, &ctx->flexible_groups);
 		break;
 	}
 	perf_enable();
@@ -1490,6 +1506,21 @@ void perf_event_task_tick(struct task_struct *curr)
 		perf_event_task_sched_in(curr);
 }
 
+static int event_enable_on_exec(struct perf_event *event,
+				struct perf_event_context *ctx)
+{
+	if (!event->attr.enable_on_exec)
+		return 0;
+
+	event->attr.enable_on_exec = 0;
+	if (event->state >= PERF_EVENT_STATE_INACTIVE)
+		return 0;
+
+	__perf_event_mark_enabled(event, ctx);
+
+	return 1;
+}
+
 /*
  * Enable all of a task's events that have been marked enable-on-exec.
  * This expects task == current.
@@ -1500,6 +1531,7 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 	struct perf_event *event;
 	unsigned long flags;
 	int enabled = 0;
+	int ret;
 
 	local_irq_save(flags);
 	ctx = task->perf_event_ctxp;
@@ -1510,14 +1542,16 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 
 	raw_spin_lock(&ctx->lock);
 
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
-		if (!event->attr.enable_on_exec)
-			continue;
-		event->attr.enable_on_exec = 0;
-		if (event->state >= PERF_EVENT_STATE_INACTIVE)
-			continue;
-		__perf_event_mark_enabled(event, ctx);
-		enabled = 1;
+	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
+		ret = event_enable_on_exec(event, ctx);
+		if (ret)
+			enabled = 1;
+	}
+
+	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
+		ret = event_enable_on_exec(event, ctx);
+		if (ret)
+			enabled = 1;
 	}
 
 	/*
@@ -1591,7 +1625,8 @@ __perf_event_init_context(struct perf_event_context *ctx,
 {
 	raw_spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
-	INIT_LIST_HEAD(&ctx->group_list);
+	INIT_LIST_HEAD(&ctx->pinned_groups);
+	INIT_LIST_HEAD(&ctx->flexible_groups);
 	INIT_LIST_HEAD(&ctx->event_list);
 	atomic_set(&ctx->refcount, 1);
 	ctx->task = task;
@@ -5032,7 +5067,11 @@ void perf_event_exit_task(struct task_struct *child)
 	mutex_lock_nested(&child_ctx->mutex, SINGLE_DEPTH_NESTING);
 
 again:
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->group_list,
+	list_for_each_entry_safe(child_event, tmp, &child_ctx->pinned_groups,
+				 group_entry)
+		__perf_event_exit_task(child_event, child_ctx, child);
+
+	list_for_each_entry_safe(child_event, tmp, &child_ctx->flexible_groups,
 				 group_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
@@ -5041,7 +5080,8 @@ again:
 	 * its siblings to the list, but we obtained 'tmp' before that which
 	 * will still point to the list head terminating the iteration.
 	 */
-	if (!list_empty(&child_ctx->group_list))
+	if (!list_empty(&child_ctx->pinned_groups) ||
+	    !list_empty(&child_ctx->flexible_groups))
 		goto again;
 
 	mutex_unlock(&child_ctx->mutex);
@@ -5049,6 +5089,24 @@ again:
 	put_ctx(child_ctx);
 }
 
+static void perf_free_event(struct perf_event *event,
+			    struct perf_event_context *ctx)
+{
+	struct perf_event *parent = event->parent;
+
+	if (WARN_ON_ONCE(!parent))
+		return;
+
+	mutex_lock(&parent->child_mutex);
+	list_del_init(&event->child_list);
+	mutex_unlock(&parent->child_mutex);
+
+	fput(parent->filp);
+
+	list_del_event(event, ctx);
+	free_event(event);
+}
+
 /*
  * free an unexposed, unused context as created by inheritance by
  * init_task below, used by fork() in case of fail.
@@ -5063,36 +5121,70 @@ void perf_event_free_task(struct task_struct *task)
 
 	mutex_lock(&ctx->mutex);
 again:
-	list_for_each_entry_safe(event, tmp, &ctx->group_list, group_entry) {
-		struct perf_event *parent = event->parent;
+	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
+		perf_free_event(event, ctx);
 
-		if (WARN_ON_ONCE(!parent))
-			continue;
+	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups,
+				 group_entry)
+		perf_free_event(event, ctx);
 
-		mutex_lock(&parent->child_mutex);
-		list_del_init(&event->child_list);
-		mutex_unlock(&parent->child_mutex);
+	if (!list_empty(&ctx->pinned_groups) ||
+	    !list_empty(&ctx->flexible_groups))
+		goto again;
 
-		fput(parent->filp);
+	mutex_unlock(&ctx->mutex);
 
-		list_del_event(event, ctx);
-		free_event(event);
+	put_ctx(ctx);
+}
+
+static int
+inherit_task_group(struct perf_event *event, struct task_struct *parent,
+		   struct perf_event_context *parent_ctx,
+		   struct task_struct *child,
+		   int *inherited_all)
+{
+	int ret;
+	struct perf_event_context *child_ctx = child->perf_event_ctxp;
+
+	if (!event->attr.inherit) {
+		*inherited_all = 0;
+		return 0;
 	}
 
-	if (!list_empty(&ctx->group_list))
-		goto again;
+	if (!child_ctx) {
+		/*
+		 * This is executed from the parent task context, so
+		 * inherit events that have been marked for cloning.
+		 * First allocate and initialize a context for the
+		 * child.
+		 */
 
-	mutex_unlock(&ctx->mutex);
+		child_ctx = kzalloc(sizeof(struct perf_event_context),
+				    GFP_KERNEL);
+		if (!child_ctx)
+			return -ENOMEM;
 
-	put_ctx(ctx);
+		__perf_event_init_context(child_ctx, child);
+		child->perf_event_ctxp = child_ctx;
+		get_task_struct(child);
+	}
+
+	ret = inherit_group(event, parent, parent_ctx,
+			    child, child_ctx);
+
+	if (ret)
+		*inherited_all = 0;
+
+	return ret;
 }
 
+
 /*
  * Initialize the perf_event context in task_struct
  */
 int perf_event_init_task(struct task_struct *child)
 {
-	struct perf_event_context *child_ctx = NULL, *parent_ctx;
+	struct perf_event_context *child_ctx, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
 	struct perf_event *event;
 	struct task_struct *parent = current;
@@ -5130,41 +5222,22 @@ int perf_event_init_task(struct task_struct *child)
 	 * We dont have to disable NMIs - we are only looking at
 	 * the list, not manipulating it:
 	 */
-	list_for_each_entry(event, &parent_ctx->group_list, group_entry) {
-
-		if (!event->attr.inherit) {
-			inherited_all = 0;
-			continue;
-		}
-
-		if (!child->perf_event_ctxp) {
-			/*
-			 * This is executed from the parent task context, so
-			 * inherit events that have been marked for cloning.
-			 * First allocate and initialize a context for the
-			 * child.
-			 */
-
-			child_ctx = kzalloc(sizeof(struct perf_event_context),
-					    GFP_KERNEL);
-			if (!child_ctx) {
-				ret = -ENOMEM;
-				break;
-			}
-
-			__perf_event_init_context(child_ctx, child);
-			child->perf_event_ctxp = child_ctx;
-			get_task_struct(child);
-		}
+	list_for_each_entry(event, &parent_ctx->pinned_groups, group_entry) {
+		ret = inherit_task_group(event, parent, parent_ctx, child,
+					 &inherited_all);
+		if (ret)
+			break;
+	}
 
-		ret = inherit_group(event, parent, parent_ctx,
-					     child, child_ctx);
-		if (ret) {
-			inherited_all = 0;
+	list_for_each_entry(event, &parent_ctx->flexible_groups, group_entry) {
+		ret = inherit_task_group(event, parent, parent_ctx, child,
+					 &inherited_all);
+		if (ret)
 			break;
-		}
 	}
 
+	child_ctx = child->perf_event_ctxp;
+
 	if (child_ctx && inherited_all) {
 		/*
 		 * Mark the child context as a clone of the parent
@@ -5213,7 +5286,9 @@ static void __perf_event_exit_cpu(void *info)
 	struct perf_event_context *ctx = &cpuctx->ctx;
 	struct perf_event *event, *tmp;
 
-	list_for_each_entry_safe(event, tmp, &ctx->group_list, group_entry)
+	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
+		__perf_event_remove_from_context(event);
+	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
 		__perf_event_remove_from_context(event);
 }
 static void perf_event_exit_cpu(int cpu)
-- 
1.6.2.3


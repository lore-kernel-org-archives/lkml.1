Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZKHUNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZKHUNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZKHUNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:13:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49789 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZKHUNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bhgjcBLH3GgZC7PWGFo5YqwbmEWuKwIElKsmk/rq4SVBf1WkngftaDd48tD6a9AmEs
         mzglF+8Jd0ofn15d7WK2/V6Y8JB5laUDqav80b8xgKNgGSue4Y+MzkDo6uAWqyiVgwg2
         yU/zFd+tM6xxyB3CfLl8cdyMvv4SvtQA5t+u4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 1/4] perf/core: split context's event group list into pinned and non-pinned lists
Date: Sun,  8 Nov 2009 21:13:23 +0100
Message-Id: <1257711206-12243-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split-up struct perf_event_context::group_list into pinned_grp_list
and volatile_grp_list (non-pinned).

This first appears to be useless as it duplicates various loops around
the group list handlings.

But it scales better in the fast-path in perf_sched_in(). We don't
anymore iterate twice through the entire list to separate pinned and
non-pinned scheduling. Instead we interate through two distinct lists.

The another desired effect is that it makes easier the distinct
scheduling rules for both.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/perf_event.h |    3 +-
 kernel/perf_event.c        |  177 +++++++++++++++++++++++++++++++-------------
 2 files changed, 127 insertions(+), 53 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6ff7c3b..659351c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -662,7 +662,8 @@ struct perf_event_context {
 	 */
 	struct mutex			mutex;
 
-	struct list_head		group_list;
+	struct list_head		pinned_grp_list;
+	struct list_head		volatile_grp_list;
 	struct list_head		event_list;
 	int				nr_events;
 	int				nr_active;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6f4ed3b..b3a31c8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -259,9 +259,15 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	 * add it straight to the context's event list, or to the group
 	 * leader's sibling list:
 	 */
-	if (group_leader == event)
-		list_add_tail(&event->group_entry, &ctx->group_list);
-	else {
+	if (group_leader == event) {
+		struct list_head *list;
+
+		if (event->attr.pinned)
+			list = &ctx->pinned_grp_list;
+		else
+			list = &ctx->volatile_grp_list;
+		list_add_tail(&event->group_entry, list);
+	} else {
 		list_add_tail(&event->group_entry, &group_leader->sibling_list);
 		group_leader->nr_siblings++;
 	}
@@ -299,8 +305,14 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	 * to the context list directly:
 	 */
 	list_for_each_entry_safe(sibling, tmp, &event->sibling_list, group_entry) {
+		struct list_head *list;
+
+		if (sibling->attr.pinned)
+			list = &ctx->pinned_grp_list;
+		else
+			list = &ctx->volatile_grp_list;
 
-		list_move_tail(&sibling->group_entry, &ctx->group_list);
+		list_move_tail(&sibling->group_entry, list);
 		sibling->group_leader = sibling;
 	}
 }
@@ -1032,10 +1044,14 @@ void __perf_event_sched_out(struct perf_event_context *ctx,
 	update_context_time(ctx);
 
 	perf_disable();
-	if (ctx->nr_active)
-		list_for_each_entry(event, &ctx->group_list, group_entry)
+	if (ctx->nr_active) {
+		list_for_each_entry(event, &ctx->pinned_grp_list, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 
+		list_for_each_entry(event, &ctx->volatile_grp_list, group_entry)
+			group_sched_out(event, cpuctx, ctx);
+	}
+
 	perf_enable();
  out:
 	spin_unlock(&ctx->lock);
@@ -1249,9 +1265,8 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
 	 */
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
-		if (event->state <= PERF_EVENT_STATE_OFF ||
-		    !event->attr.pinned)
+	list_for_each_entry(event, &ctx->pinned_grp_list, group_entry) {
+		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 		if (event->cpu != -1 && event->cpu != cpu)
 			continue;
@@ -1269,13 +1284,12 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 		}
 	}
 
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
+	list_for_each_entry(event, &ctx->volatile_grp_list, group_entry) {
 		/*
 		 * Ignore events in OFF or ERROR state, and
 		 * ignore pinned events since we did them already.
 		 */
-		if (event->state <= PERF_EVENT_STATE_OFF ||
-		    event->attr.pinned)
+		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 
 		/*
@@ -1428,8 +1442,13 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	 * Rotate the first entry last (works just fine for group events too):
 	 */
 	perf_disable();
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
-		list_move_tail(&event->group_entry, &ctx->group_list);
+	list_for_each_entry(event, &ctx->pinned_grp_list, group_entry) {
+		list_move_tail(&event->group_entry, &ctx->pinned_grp_list);
+		break;
+	}
+
+	list_for_each_entry(event, &ctx->volatile_grp_list, group_entry) {
+		list_move_tail(&event->group_entry, &ctx->volatile_grp_list);
 		break;
 	}
 	perf_enable();
@@ -1465,6 +1484,22 @@ void perf_event_task_tick(struct task_struct *curr, int cpu)
 		perf_event_task_sched_in(curr, cpu);
 }
 
+static void __perf_event_enable_on_exec(struct perf_event *event,
+					struct perf_event_context *ctx,
+					int *enabled)
+{
+	if (!event->attr.enable_on_exec)
+		return;
+
+	event->attr.enable_on_exec = 0;
+	if (event->state >= PERF_EVENT_STATE_INACTIVE)
+		return;
+
+	__perf_event_mark_enabled(event, ctx);
+
+	*enabled = 1;
+}
+
 /*
  * Enable all of a task's events that have been marked enable-on-exec.
  * This expects task == current.
@@ -1485,15 +1520,11 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 
 	spin_lock(&ctx->lock);
 
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
-		if (!event->attr.enable_on_exec)
-			continue;
-		event->attr.enable_on_exec = 0;
-		if (event->state >= PERF_EVENT_STATE_INACTIVE)
-			continue;
-		__perf_event_mark_enabled(event, ctx);
-		enabled = 1;
-	}
+	list_for_each_entry(event, &ctx->pinned_grp_list, group_entry)
+		__perf_event_enable_on_exec(event, ctx, &enabled);
+
+	list_for_each_entry(event, &ctx->volatile_grp_list, group_entry)
+		__perf_event_enable_on_exec(event, ctx, &enabled);
 
 	/*
 	 * Unclone this context if we enabled any event.
@@ -1562,7 +1593,8 @@ __perf_event_init_context(struct perf_event_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
-	INIT_LIST_HEAD(&ctx->group_list);
+	INIT_LIST_HEAD(&ctx->pinned_grp_list);
+	INIT_LIST_HEAD(&ctx->volatile_grp_list);
 	INIT_LIST_HEAD(&ctx->event_list);
 	atomic_set(&ctx->refcount, 1);
 	ctx->task = task;
@@ -4869,7 +4901,11 @@ void perf_event_exit_task(struct task_struct *child)
 	mutex_lock_nested(&child_ctx->mutex, SINGLE_DEPTH_NESTING);
 
 again:
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->group_list,
+	list_for_each_entry_safe(child_event, tmp, &child_ctx->pinned_grp_list,
+				 group_entry)
+		__perf_event_exit_task(child_event, child_ctx, child);
+
+	list_for_each_entry_safe(child_event, tmp, &child_ctx->volatile_grp_list,
 				 group_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
@@ -4878,7 +4914,8 @@ again:
 	 * its siblings to the list, but we obtained 'tmp' before that which
 	 * will still point to the list head terminating the iteration.
 	 */
-	if (!list_empty(&child_ctx->group_list))
+	if (!list_empty(&child_ctx->pinned_grp_list) ||
+	    !list_empty(&child_ctx->volatile_grp_list))
 		goto again;
 
 	mutex_unlock(&child_ctx->mutex);
@@ -4886,6 +4923,24 @@ again:
 	put_ctx(child_ctx);
 }
 
+static void perf_event_free_event(struct perf_event *event,
+				  struct perf_event_context *ctx)
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
@@ -4900,23 +4955,15 @@ void perf_event_free_task(struct task_struct *task)
 
 	mutex_lock(&ctx->mutex);
 again:
-	list_for_each_entry_safe(event, tmp, &ctx->group_list, group_entry) {
-		struct perf_event *parent = event->parent;
-
-		if (WARN_ON_ONCE(!parent))
-			continue;
-
-		mutex_lock(&parent->child_mutex);
-		list_del_init(&event->child_list);
-		mutex_unlock(&parent->child_mutex);
+	list_for_each_entry_safe(event, tmp, &ctx->pinned_grp_list, group_entry)
+		perf_event_free_event(event, ctx);
 
-		fput(parent->filp);
-
-		list_del_event(event, ctx);
-		free_event(event);
-	}
+	list_for_each_entry_safe(event, tmp, &ctx->volatile_grp_list,
+				 group_entry)
+		perf_event_free_event(event, ctx);
 
-	if (!list_empty(&ctx->group_list))
+	if (!list_empty(&ctx->pinned_grp_list) ||
+	    !list_empty(&ctx->volatile_grp_list))
 		goto again;
 
 	mutex_unlock(&ctx->mutex);
@@ -4924,6 +4971,29 @@ again:
 	put_ctx(ctx);
 }
 
+static int
+perf_event_inherit(struct perf_event *event, struct task_struct *parent,
+		   struct perf_event_context *parent_ctx,
+		   struct task_struct *child,
+		   struct perf_event_context *child_ctx,
+		   int *inherited_all)
+{
+	int ret;
+
+	if (!event->attr.inherit) {
+		*inherited_all = 0;
+		return 0;
+	}
+
+	ret = inherit_group(event, parent, parent_ctx,
+			    child, child_ctx);
+	if (ret)
+		*inherited_all = 0;
+
+	return ret;
+}
+
+
 /*
  * Initialize the perf_event context in task_struct
  */
@@ -4981,19 +5051,20 @@ int perf_event_init_task(struct task_struct *child)
 	 * We dont have to disable NMIs - we are only looking at
 	 * the list, not manipulating it:
 	 */
-	list_for_each_entry(event, &parent_ctx->group_list, group_entry) {
+	list_for_each_entry(event, &parent_ctx->pinned_grp_list, group_entry) {
 
-		if (!event->attr.inherit) {
-			inherited_all = 0;
-			continue;
-		}
+		ret = perf_event_inherit(event, parent, parent_ctx, child,
+					 child_ctx, &inherited_all);
+		if (ret)
+			break;
+	}
+
+	list_for_each_entry(event, &parent_ctx->volatile_grp_list, group_entry) {
 
-		ret = inherit_group(event, parent, parent_ctx,
-					     child, child_ctx);
-		if (ret) {
-			inherited_all = 0;
+		ret = perf_event_inherit(event, parent, parent_ctx, child,
+					 child_ctx, &inherited_all);
+		if (ret)
 			break;
-		}
 	}
 
 	if (inherited_all) {
@@ -5044,7 +5115,9 @@ static void __perf_event_exit_cpu(void *info)
 	struct perf_event_context *ctx = &cpuctx->ctx;
 	struct perf_event *event, *tmp;
 
-	list_for_each_entry_safe(event, tmp, &ctx->group_list, group_entry)
+	list_for_each_entry_safe(event, tmp, &ctx->pinned_grp_list, group_entry)
+		__perf_event_remove_from_context(event);
+	list_for_each_entry_safe(event, tmp, &ctx->volatile_grp_list, group_entry)
 		__perf_event_remove_from_context(event);
 }
 static void perf_event_exit_cpu(int cpu)
-- 
1.6.2.3


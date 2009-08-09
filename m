Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZHILLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZHILLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZHILL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:11:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:43878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZHILLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:11:22 -0400
Date: Sun, 9 Aug 2009 11:10:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, markus.t.metzger@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249667341.17467.5.camel@twins>
References: <1249667341.17467.5.camel@twins>
Subject: [tip:perfcounters/core] perf_counter: Fix a race on perf_counter_ctx
Message-ID: <tip-3a80b4a3539696f4b0574876326860323035a302@git.kernel.org>
Git-Commit-ID: 3a80b4a3539696f4b0574876326860323035a302
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 11:10:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a80b4a3539696f4b0574876326860323035a302
Gitweb:     http://git.kernel.org/tip/3a80b4a3539696f4b0574876326860323035a302
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 7 Aug 2009 19:49:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 12:54:46 +0200

perf_counter: Fix a race on perf_counter_ctx

While extending perfcounters with BTS hw-tracing, Markus
Metzger managed to trigger this warning:

   [  995.557128] WARNING: at kernel/perf_counter.c:1191 __perf_counter_task_sched_out+0x48/0x6b()

triggers because commit
9f498cc5be7e013d8d6e4c616980ed0ffc8680d2 (perf_counter: Full
task tracing) removed clearing of tsk->perf_counter_ctxp out
from under ctx->lock which introduced a race (against
perf_lock_task_context).

Move it back and deal with the exit notification by explicitly
passing along the former task context.

Reported-by: Markus T Metzger <markus.t.metzger@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1249667341.17467.5.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0023105..546e62d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2850,7 +2850,8 @@ perf_counter_read_event(struct perf_counter *counter,
  */
 
 struct perf_task_event {
-	struct task_struct	*task;
+	struct task_struct		*task;
+	struct perf_counter_context	*task_ctx;
 
 	struct {
 		struct perf_event_header	header;
@@ -2910,24 +2911,23 @@ static void perf_counter_task_ctx(struct perf_counter_context *ctx,
 static void perf_counter_task_event(struct perf_task_event *task_event)
 {
 	struct perf_cpu_context *cpuctx;
-	struct perf_counter_context *ctx;
+	struct perf_counter_context *ctx = task_event->task_ctx;
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_counter_task_ctx(&cpuctx->ctx, task_event);
 	put_cpu_var(perf_cpu_context);
 
 	rcu_read_lock();
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
-	ctx = rcu_dereference(current->perf_counter_ctxp);
+	if (!ctx)
+		ctx = rcu_dereference(task_event->task->perf_counter_ctxp);
 	if (ctx)
 		perf_counter_task_ctx(ctx, task_event);
 	rcu_read_unlock();
 }
 
-static void perf_counter_task(struct task_struct *task, int new)
+static void perf_counter_task(struct task_struct *task,
+			      struct perf_counter_context *task_ctx,
+			      int new)
 {
 	struct perf_task_event task_event;
 
@@ -2937,8 +2937,9 @@ static void perf_counter_task(struct task_struct *task, int new)
 		return;
 
 	task_event = (struct perf_task_event){
-		.task	= task,
-		.event  = {
+		.task	  = task,
+		.task_ctx = task_ctx,
+		.event    = {
 			.header = {
 				.type = new ? PERF_EVENT_FORK : PERF_EVENT_EXIT,
 				.misc = 0,
@@ -2956,7 +2957,7 @@ static void perf_counter_task(struct task_struct *task, int new)
 
 void perf_counter_fork(struct task_struct *task)
 {
-	perf_counter_task(task, 1);
+	perf_counter_task(task, NULL, 1);
 }
 
 /*
@@ -4310,7 +4311,7 @@ void perf_counter_exit_task(struct task_struct *child)
 	unsigned long flags;
 
 	if (likely(!child->perf_counter_ctxp)) {
-		perf_counter_task(child, 0);
+		perf_counter_task(child, NULL, 0);
 		return;
 	}
 
@@ -4330,6 +4331,7 @@ void perf_counter_exit_task(struct task_struct *child)
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	spin_lock(&child_ctx->lock);
+	child->perf_counter_ctxp = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
@@ -4343,9 +4345,7 @@ void perf_counter_exit_task(struct task_struct *child)
 	 * won't get any samples after PERF_EVENT_EXIT. We can however still
 	 * get a few PERF_EVENT_READ events.
 	 */
-	perf_counter_task(child, 0);
-
-	child->perf_counter_ctxp = NULL;
+	perf_counter_task(child, child_ctx, 0);
 
 	/*
 	 * We can recurse on the same lock type through:

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZHGRtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZHGRtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZHGRtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:49:21 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:55832 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZHGRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:49:21 -0400
X-SourceIP: 213.93.53.227
Subject: [PATCH] perf_counter: Fix a race on perf_counter_ctx
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090807113349.GA31673@elte.hu>
References: <20090804111412.GA20942@elte.hu>
	 <20090804113555.GA28198@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
	 <1249633282.32113.613.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
	 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
	 <20090807112421.GB30014@elte.hu>  <20090807113349.GA31673@elte.hu>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 19:49:01 +0200
Message-Id: <1249667341.17467.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 13:33 +0200, Ingo Molnar wrote:
>  Peter, any ideas?


> [  995.556131] ------------[ cut here ]------------
> [  995.557128] WARNING: at kernel/perf_counter.c:1191 __perf_counter_task_sched_out+0x48/0x6b()


Some yeah...

---
Subject: perf_counter: Fix a race on perf_counter_ctx

Commit 9f498cc5be7e013d8d6e4c616980ed0ffc8680d2 (perf_counter: Full task
tracing) removed clearing of tsk->perf_counter_ctxp out from under
ctx->lock which introduced a race (probably against
perf_lock_task_context).

Move it back and deal with the exit notification by explicitly passing
along the former task context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 142ae5a..1072778 100644
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



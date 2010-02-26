Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab0BZK02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:26:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:34414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab0BZK0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:26:19 -0500
Date: Fri, 26 Feb 2010 10:25:38 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
       davem@davemloft.net, benh@kernel.crashing.org, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, davem@davemloft.net, benh@kernel.crashing.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1265890918.5396.3.camel@laptop>
References: <1265890918.5396.3.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Simplify code by removing cpu argument to hw_perf_group_sched_in()
Message-ID: <tip-6e37738a2fac964583debe91099bc3248554f6e5@git.kernel.org>
Git-Commit-ID: 6e37738a2fac964583debe91099bc3248554f6e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 10:25:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e37738a2fac964583debe91099bc3248554f6e5
Gitweb:     http://git.kernel.org/tip/6e37738a2fac964583debe91099bc3248554f6e5
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 11 Feb 2010 13:21:58 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 10:56:53 +0100

perf_events: Simplify code by removing cpu argument to hw_perf_group_sched_in()

Since the cpu argument to hw_perf_group_sched_in() is always
smp_processor_id(), simplify the code a little by removing this argument
and using the current cpu where needed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1265890918.5396.3.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_event.c |   10 ++++----
 arch/sparc/kernel/perf_event.c   |   10 ++++----
 arch/x86/kernel/cpu/perf_event.c |   18 +++++++-------
 include/linux/perf_event.h       |    2 +-
 kernel/perf_event.c              |   45 +++++++++++++++----------------------
 5 files changed, 38 insertions(+), 47 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 1eb85fb..b6cf8f1 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -718,10 +718,10 @@ static int collect_events(struct perf_event *group, int max_count,
 	return n;
 }
 
-static void event_sched_in(struct perf_event *event, int cpu)
+static void event_sched_in(struct perf_event *event)
 {
 	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = cpu;
+	event->oncpu = smp_processor_id();
 	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
 	if (is_software_event(event))
 		event->pmu->enable(event);
@@ -735,7 +735,7 @@ static void event_sched_in(struct perf_event *event, int cpu)
  */
 int hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx, int cpu)
+	       struct perf_event_context *ctx)
 {
 	struct cpu_hw_events *cpuhw;
 	long i, n, n0;
@@ -766,10 +766,10 @@ int hw_perf_group_sched_in(struct perf_event *group_leader,
 		cpuhw->event[i]->hw.config = cpuhw->events[i];
 	cpuctx->active_oncpu += n;
 	n = 1;
-	event_sched_in(group_leader, cpu);
+	event_sched_in(group_leader);
 	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
 		if (sub->state != PERF_EVENT_STATE_OFF) {
-			event_sched_in(sub, cpu);
+			event_sched_in(sub);
 			++n;
 		}
 	}
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index e856456..9f2b2ba 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -980,10 +980,10 @@ static int collect_events(struct perf_event *group, int max_count,
 	return n;
 }
 
-static void event_sched_in(struct perf_event *event, int cpu)
+static void event_sched_in(struct perf_event *event)
 {
 	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = cpu;
+	event->oncpu = smp_processor_id();
 	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
 	if (is_software_event(event))
 		event->pmu->enable(event);
@@ -991,7 +991,7 @@ static void event_sched_in(struct perf_event *event, int cpu)
 
 int hw_perf_group_sched_in(struct perf_event *group_leader,
 			   struct perf_cpu_context *cpuctx,
-			   struct perf_event_context *ctx, int cpu)
+			   struct perf_event_context *ctx)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_event *sub;
@@ -1015,10 +1015,10 @@ int hw_perf_group_sched_in(struct perf_event *group_leader,
 
 	cpuctx->active_oncpu += n;
 	n = 1;
-	event_sched_in(group_leader, cpu);
+	event_sched_in(group_leader);
 	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
 		if (sub->state != PERF_EVENT_STATE_OFF) {
-			event_sched_in(sub, cpu);
+			event_sched_in(sub);
 			n++;
 		}
 	}
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index aa12f36..ad09656 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2403,12 +2403,12 @@ done:
 }
 
 static int x86_event_sched_in(struct perf_event *event,
-			  struct perf_cpu_context *cpuctx, int cpu)
+			  struct perf_cpu_context *cpuctx)
 {
 	int ret = 0;
 
 	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = cpu;
+	event->oncpu = smp_processor_id();
 	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
 
 	if (!is_x86_event(event))
@@ -2424,7 +2424,7 @@ static int x86_event_sched_in(struct perf_event *event,
 }
 
 static void x86_event_sched_out(struct perf_event *event,
-			    struct perf_cpu_context *cpuctx, int cpu)
+			    struct perf_cpu_context *cpuctx)
 {
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	event->oncpu = -1;
@@ -2452,9 +2452,9 @@ static void x86_event_sched_out(struct perf_event *event,
  */
 int hw_perf_group_sched_in(struct perf_event *leader,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx, int cpu)
+	       struct perf_event_context *ctx)
 {
-	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_event *sub;
 	int assign[X86_PMC_IDX_MAX];
 	int n0, n1, ret;
@@ -2468,14 +2468,14 @@ int hw_perf_group_sched_in(struct perf_event *leader,
 	if (ret)
 		return ret;
 
-	ret = x86_event_sched_in(leader, cpuctx, cpu);
+	ret = x86_event_sched_in(leader, cpuctx);
 	if (ret)
 		return ret;
 
 	n1 = 1;
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		if (sub->state > PERF_EVENT_STATE_OFF) {
-			ret = x86_event_sched_in(sub, cpuctx, cpu);
+			ret = x86_event_sched_in(sub, cpuctx);
 			if (ret)
 				goto undo;
 			++n1;
@@ -2500,11 +2500,11 @@ int hw_perf_group_sched_in(struct perf_event *leader,
 	 */
 	return 1;
 undo:
-	x86_event_sched_out(leader, cpuctx, cpu);
+	x86_event_sched_out(leader, cpuctx);
 	n0  = 1;
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		if (sub->state == PERF_EVENT_STATE_ACTIVE) {
-			x86_event_sched_out(sub, cpuctx, cpu);
+			x86_event_sched_out(sub, cpuctx);
 			if (++n0 == n1)
 				break;
 		}
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b08dfda..d0e072c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -772,7 +772,7 @@ extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
 extern int hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx, int cpu);
+	       struct perf_event_context *ctx);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index fb4e56e..05b6c6b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -103,7 +103,7 @@ void __weak hw_perf_event_setup_offline(int cpu)	{ barrier(); }
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx, int cpu)
+	       struct perf_event_context *ctx)
 {
 	return 0;
 }
@@ -633,14 +633,13 @@ void perf_event_disable(struct perf_event *event)
 static int
 event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
-		 struct perf_event_context *ctx,
-		 int cpu)
+		 struct perf_event_context *ctx)
 {
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
 	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = cpu;	/* TODO: put 'cpu' into cpuctx->cpu */
+	event->oncpu = smp_processor_id();
 	/*
 	 * The new state must be visible before we turn it on in the hardware:
 	 */
@@ -667,8 +666,7 @@ event_sched_in(struct perf_event *event,
 static int
 group_sched_in(struct perf_event *group_event,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx,
-	       int cpu)
+	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group;
 	int ret;
@@ -676,18 +674,18 @@ group_sched_in(struct perf_event *group_event,
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
-	ret = hw_perf_group_sched_in(group_event, cpuctx, ctx, cpu);
+	ret = hw_perf_group_sched_in(group_event, cpuctx, ctx);
 	if (ret)
 		return ret < 0 ? ret : 0;
 
-	if (event_sched_in(group_event, cpuctx, ctx, cpu))
+	if (event_sched_in(group_event, cpuctx, ctx))
 		return -EAGAIN;
 
 	/*
 	 * Schedule in siblings as one group (if any):
 	 */
 	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
-		if (event_sched_in(event, cpuctx, ctx, cpu)) {
+		if (event_sched_in(event, cpuctx, ctx)) {
 			partial_group = event;
 			goto group_error;
 		}
@@ -761,7 +759,6 @@ static void __perf_install_in_context(void *info)
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_event *leader = event->group_leader;
-	int cpu = smp_processor_id();
 	int err;
 
 	/*
@@ -808,7 +805,7 @@ static void __perf_install_in_context(void *info)
 	if (!group_can_go_on(event, cpuctx, 1))
 		err = -EEXIST;
 	else
-		err = event_sched_in(event, cpuctx, ctx, cpu);
+		err = event_sched_in(event, cpuctx, ctx);
 
 	if (err) {
 		/*
@@ -950,11 +947,9 @@ static void __perf_event_enable(void *info)
 	} else {
 		perf_disable();
 		if (event == leader)
-			err = group_sched_in(event, cpuctx, ctx,
-					     smp_processor_id());
+			err = group_sched_in(event, cpuctx, ctx);
 		else
-			err = event_sched_in(event, cpuctx, ctx,
-					       smp_processor_id());
+			err = event_sched_in(event, cpuctx, ctx);
 		perf_enable();
 	}
 
@@ -1281,19 +1276,18 @@ static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 
 static void
 ctx_pinned_sched_in(struct perf_event_context *ctx,
-		    struct perf_cpu_context *cpuctx,
-		    int cpu)
+		    struct perf_cpu_context *cpuctx)
 {
 	struct perf_event *event;
 
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (event->cpu != -1 && event->cpu != cpu)
+		if (event->cpu != -1 && event->cpu != smp_processor_id())
 			continue;
 
 		if (group_can_go_on(event, cpuctx, 1))
-			group_sched_in(event, cpuctx, ctx, cpu);
+			group_sched_in(event, cpuctx, ctx);
 
 		/*
 		 * If this pinned group hasn't been scheduled,
@@ -1308,8 +1302,7 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx,
-		      int cpu)
+		      struct perf_cpu_context *cpuctx)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1322,11 +1315,11 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (event->cpu != -1 && event->cpu != cpu)
+		if (event->cpu != -1 && event->cpu != smp_processor_id())
 			continue;
 
 		if (group_can_go_on(event, cpuctx, can_add_hw))
-			if (group_sched_in(event, cpuctx, ctx, cpu))
+			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
 	}
 }
@@ -1336,8 +1329,6 @@ ctx_sched_in(struct perf_event_context *ctx,
 	     struct perf_cpu_context *cpuctx,
 	     enum event_type_t event_type)
 {
-	int cpu = smp_processor_id();
-
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	if (likely(!ctx->nr_events))
@@ -1352,11 +1343,11 @@ ctx_sched_in(struct perf_event_context *ctx,
 	 * in order to give them the best chance of going on.
 	 */
 	if (event_type & EVENT_PINNED)
-		ctx_pinned_sched_in(ctx, cpuctx, cpu);
+		ctx_pinned_sched_in(ctx, cpuctx);
 
 	/* Then walk through the lower prio flexible groups */
 	if (event_type & EVENT_FLEXIBLE)
-		ctx_flexible_sched_in(ctx, cpuctx, cpu);
+		ctx_flexible_sched_in(ctx, cpuctx);
 
 	perf_enable();
  out:

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0BKMWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:22:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab0BKMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:22:19 -0500
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       paulus@samba.org
In-Reply-To: <1265799175.11509.271.camel@laptop>
References: <20100208184504.GB5130@lenovo> <20100209041739.GA11280@elte.hu>
	 <20100209223909.GE5068@lenovo> <1265796732.11509.260.camel@laptop>
	 <aa79d98a1002100238v256ca6daw5e00c8b6d8dc4bb6@mail.gmail.com>
	 <1265799175.11509.271.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 13:21:58 +0100
Message-ID: <1265890918.5396.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 11:52 +0100, Peter Zijlstra wrote:
> which suggests we should simply remove that cpu argument 

The below patch does so for all in-tree bits.

Doing this patch reminded me of the mess that is
hw_perf_group_sched_in(), so I'm going to try and fix that next.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_event.c |   10 +++++-----
 arch/sparc/kernel/perf_event.c   |   10 +++++-----
 arch/x86/kernel/cpu/perf_event.c |   18 +++++++++---------
 include/linux/perf_event.h       |    2 +-
 kernel/perf_event.c              |    4 ++--
 5 files changed, 22 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c	2010-02-11 13:06:35.769636948 +0100
+++ linux-2.6/arch/powerpc/kernel/perf_event.c	2010-02-11 13:06:42.709637562 +0100
@@ -718,10 +718,10 @@
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
@@ -735,7 +735,7 @@
  */
 int hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx, int cpu)
+	       struct perf_event_context *ctx)
 {
 	struct cpu_hw_events *cpuhw;
 	long i, n, n0;
@@ -766,10 +766,10 @@
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
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c	2010-02-11 13:06:35.779634028 +0100
+++ linux-2.6/arch/sparc/kernel/perf_event.c	2010-02-11 13:06:42.709637562 +0100
@@ -980,10 +980,10 @@
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
@@ -991,7 +991,7 @@
 
 int hw_perf_group_sched_in(struct perf_event *group_leader,
 			   struct perf_cpu_context *cpuctx,
-			   struct perf_event_context *ctx, int cpu)
+			   struct perf_event_context *ctx)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_event *sub;
@@ -1015,10 +1015,10 @@
 
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
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c	2010-02-11 13:06:42.699628399 +0100
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c	2010-02-11 13:06:42.719650288 +0100
@@ -2386,12 +2386,12 @@
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
@@ -2407,7 +2407,7 @@
 }
 
 static void x86_event_sched_out(struct perf_event *event,
-			    struct perf_cpu_context *cpuctx, int cpu)
+			    struct perf_cpu_context *cpuctx)
 {
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	event->oncpu = -1;
@@ -2435,9 +2435,9 @@
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
@@ -2451,14 +2451,14 @@
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
@@ -2483,11 +2483,11 @@
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
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h	2010-02-11 13:06:35.799627560 +0100
+++ linux-2.6/include/linux/perf_event.h	2010-02-11 13:06:52.279636542 +0100
@@ -768,7 +768,7 @@
 extern int perf_event_task_enable(void);
 extern int hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx, int cpu);
+	       struct perf_event_context *ctx);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c	2010-02-11 13:06:42.659637981 +0100
+++ linux-2.6/kernel/perf_event.c	2010-02-11 13:06:52.289627547 +0100
@@ -103,7 +103,7 @@
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx, int cpu)
+	       struct perf_event_context *ctx)
 {
 	return 0;
 }
@@ -633,14 +633,13 @@
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
@@ -667,8 +666,7 @@
 static int
 group_sched_in(struct perf_event *group_event,
 	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx,
-	       int cpu)
+	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group;
 	int ret;
@@ -676,18 +674,18 @@
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
@@ -761,7 +759,6 @@
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_event *leader = event->group_leader;
-	int cpu = smp_processor_id();
 	int err;
 
 	/*
@@ -808,7 +805,7 @@
 	if (!group_can_go_on(event, cpuctx, 1))
 		err = -EEXIST;
 	else
-		err = event_sched_in(event, cpuctx, ctx, cpu);
+		err = event_sched_in(event, cpuctx, ctx);
 
 	if (err) {
 		/*
@@ -950,11 +947,9 @@
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
 
@@ -1281,19 +1276,18 @@
 
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
@@ -1308,8 +1302,7 @@
 
 static void
 ctx_flexible_sched_in(struct perf_event_context *ctx,
-		      struct perf_cpu_context *cpuctx,
-		      int cpu)
+		      struct perf_cpu_context *cpuctx)
 {
 	struct perf_event *event;
 	int can_add_hw = 1;
@@ -1322,11 +1315,11 @@
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
@@ -1336,8 +1329,6 @@
 	     struct perf_cpu_context *cpuctx,
 	     enum event_type_t event_type)
 {
-	int cpu = smp_processor_id();
-
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	if (likely(!ctx->nr_events))
@@ -1352,11 +1343,11 @@
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



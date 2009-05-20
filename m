Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZETK1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZETK1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbZETK0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:26:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbZETK0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:26:49 -0400
Message-Id: <20090520102553.237504544@chello.nl>
References: <20090520102118.377477360@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 12:21:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/4] perf_counter: solve the rotate_ctx vs inherit race differently
Content-Disposition: inline; filename=perf_counter-fixup-inherit.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of disabling RR scheduling of the counters, use a different list
that does not get rotated to iterate the counters on inheritance.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    1 -
 kernel/perf_counter.c        |   15 +++++----------
 2 files changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -508,7 +508,6 @@ struct perf_counter_context {
 	int			nr_counters;
 	int			nr_active;
 	int			is_active;
-	int			rr_allowed;
 	struct task_struct	*task;
 
 	/*
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1120,8 +1120,7 @@ void perf_counter_task_tick(struct task_
 	__perf_counter_task_sched_out(ctx);
 
 	rotate_ctx(&cpuctx->ctx);
-	if (ctx->rr_allowed)
-		rotate_ctx(ctx);
+	rotate_ctx(ctx);
 
 	perf_counter_cpu_sched_in(cpuctx, cpu);
 	perf_counter_task_sched_in(curr, cpu);
@@ -3109,7 +3108,6 @@ __perf_counter_init_context(struct perf_
 	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->counter_list);
 	INIT_LIST_HEAD(&ctx->event_list);
-	ctx->rr_allowed = 1;
 	ctx->task = task;
 }
 
@@ -3350,14 +3348,14 @@ void perf_counter_init_task(struct task_
 	 */
 	mutex_lock(&parent_ctx->mutex);
 
-	parent_ctx->rr_allowed = 0;
-	barrier(); /* irqs */
-
 	/*
 	 * We dont have to disable NMIs - we are only looking at
 	 * the list, not manipulating it:
 	 */
-	list_for_each_entry(counter, &parent_ctx->counter_list, list_entry) {
+	list_for_each_entry_rcu(counter, &parent_ctx->event_list, event_entry) {
+		if (counter != counter->group_leader)
+			continue;
+
 		if (!counter->hw_event.inherit)
 			continue;
 
@@ -3366,9 +3364,6 @@ void perf_counter_init_task(struct task_
 			break;
 	}
 
-	barrier(); /* irqs */
-	parent_ctx->rr_allowed = 1;
-
 	mutex_unlock(&parent_ctx->mutex);
 }
 

-- 


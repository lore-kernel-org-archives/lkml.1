Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbZEWQbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbZEWQbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZEWQb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:31:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48960 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbZEWQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:31:25 -0400
Message-Id: <20090523163013.032998331@chello.nl>
References: <20090523162854.599719825@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 23 May 2009 18:29:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 7/7] perf_counter: remove perf_counter_context::nr_enabled
Content-Disposition: inline; filename=perf_counter-ctrl-all-cleanup.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now that pctrl() no longer disables other people's counters, remove the
PMU cache code that deals with that.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    1 -
 kernel/perf_counter.c        |   11 +----------
 2 files changed, 1 insertion(+), 11 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -516,7 +516,6 @@ struct perf_counter_context {
 	struct list_head	event_list;
 	int			nr_counters;
 	int			nr_active;
-	int			nr_enabled;
 	int			is_active;
 	atomic_t		refcount;
 	struct task_struct	*task;
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -134,8 +134,6 @@ list_add_counter(struct perf_counter *co
 
 	list_add_rcu(&counter->event_entry, &ctx->event_list);
 	ctx->nr_counters++;
-	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
-		ctx->nr_enabled++;
 }
 
 /*
@@ -150,8 +148,6 @@ list_del_counter(struct perf_counter *co
 	if (list_empty(&counter->list_entry))
 		return;
 	ctx->nr_counters--;
-	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
-		ctx->nr_enabled--;
 
 	list_del_init(&counter->list_entry);
 	list_del_rcu(&counter->event_entry);
@@ -406,7 +402,6 @@ static void __perf_counter_disable(void 
 		else
 			counter_sched_out(counter, cpuctx, ctx);
 		counter->state = PERF_COUNTER_STATE_OFF;
-		ctx->nr_enabled--;
 	}
 
 	spin_unlock_irqrestore(&ctx->lock, flags);
@@ -448,7 +443,6 @@ static void perf_counter_disable(struct 
 	if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
 		update_counter_times(counter);
 		counter->state = PERF_COUNTER_STATE_OFF;
-		ctx->nr_enabled--;
 	}
 
 	spin_unlock_irq(&ctx->lock);
@@ -759,7 +753,6 @@ static void __perf_counter_enable(void *
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
-	ctx->nr_enabled++;
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -850,7 +843,6 @@ static void perf_counter_enable(struct p
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
 		counter->tstamp_enabled =
 			ctx->time - counter->total_time_enabled;
-		ctx->nr_enabled++;
 	}
  out:
 	spin_unlock_irq(&ctx->lock);
@@ -910,8 +902,7 @@ static int context_equiv(struct perf_cou
 			 struct perf_counter_context *ctx2)
 {
 	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
-		&& ctx1->parent_gen == ctx2->parent_gen
-		&& ctx1->nr_enabled == ctx2->nr_enabled;
+		&& ctx1->parent_gen == ctx2->parent_gen;
 }
 
 /*

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZEXHDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZEXHDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZEXHC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:02:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:35732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755AbZEXHCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:02:52 -0400
Date: Sun, 24 May 2009 07:02:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090523163013.032998331@chello.nl>
References: <20090523163013.032998331@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Remove perf_counter_context::nr_enabled
Message-ID: <tip-475c55797323b67435083f6e2eb8ee670f6410ec@git.kernel.org>
Git-Commit-ID: 475c55797323b67435083f6e2eb8ee670f6410ec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 07:02:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  475c55797323b67435083f6e2eb8ee670f6410ec
Gitweb:     http://git.kernel.org/tip/475c55797323b67435083f6e2eb8ee670f6410ec
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 23 May 2009 18:29:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 24 May 2009 08:24:30 +0200

perf_counter: Remove perf_counter_context::nr_enabled

now that pctrl() no longer disables other people's counters,
remove the PMU cache code that deals with that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090523163013.032998331@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    1 -
 kernel/perf_counter.c        |   11 +----------
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 4159ee5..2ddf5e3 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -516,7 +516,6 @@ struct perf_counter_context {
 	struct list_head	event_list;
 	int			nr_counters;
 	int			nr_active;
-	int			nr_enabled;
 	int			is_active;
 	atomic_t		refcount;
 	struct task_struct	*task;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4c86a63..cb40625 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -134,8 +134,6 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 
 	list_add_rcu(&counter->event_entry, &ctx->event_list);
 	ctx->nr_counters++;
-	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
-		ctx->nr_enabled++;
 }
 
 /*
@@ -150,8 +148,6 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	if (list_empty(&counter->list_entry))
 		return;
 	ctx->nr_counters--;
-	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
-		ctx->nr_enabled--;
 
 	list_del_init(&counter->list_entry);
 	list_del_rcu(&counter->event_entry);
@@ -406,7 +402,6 @@ static void __perf_counter_disable(void *info)
 		else
 			counter_sched_out(counter, cpuctx, ctx);
 		counter->state = PERF_COUNTER_STATE_OFF;
-		ctx->nr_enabled--;
 	}
 
 	spin_unlock_irqrestore(&ctx->lock, flags);
@@ -448,7 +443,6 @@ static void perf_counter_disable(struct perf_counter *counter)
 	if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
 		update_counter_times(counter);
 		counter->state = PERF_COUNTER_STATE_OFF;
-		ctx->nr_enabled--;
 	}
 
 	spin_unlock_irq(&ctx->lock);
@@ -759,7 +753,6 @@ static void __perf_counter_enable(void *info)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
-	ctx->nr_enabled++;
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -850,7 +843,6 @@ static void perf_counter_enable(struct perf_counter *counter)
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
 		counter->tstamp_enabled =
 			ctx->time - counter->total_time_enabled;
-		ctx->nr_enabled++;
 	}
  out:
 	spin_unlock_irq(&ctx->lock);
@@ -910,8 +902,7 @@ static int context_equiv(struct perf_counter_context *ctx1,
 			 struct perf_counter_context *ctx2)
 {
 	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
-		&& ctx1->parent_gen == ctx2->parent_gen
-		&& ctx1->nr_enabled == ctx2->nr_enabled;
+		&& ctx1->parent_gen == ctx2->parent_gen;
 }
 
 /*

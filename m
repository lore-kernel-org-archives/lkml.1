Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZETRT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZETRT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZETRTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:19:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:48358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbZETRTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:19:20 -0400
Date: Wed, 20 May 2009 17:18:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090520102553.237504544@chello.nl>
References: <20090520102553.237504544@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Solve the rotate_ctx vs inherit race differently
Message-ID: <tip-d7b629a34fc4134a43c730b5f0197855dc4948d0@git.kernel.org>
Git-Commit-ID: d7b629a34fc4134a43c730b5f0197855dc4948d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 May 2009 17:18:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7b629a34fc4134a43c730b5f0197855dc4948d0
Gitweb:     http://git.kernel.org/tip/d7b629a34fc4134a43c730b5f0197855dc4948d0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 20 May 2009 12:21:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 May 2009 12:43:32 +0200

perf_counter: Solve the rotate_ctx vs inherit race differently

Instead of disabling RR scheduling of the counters, use a different list
that does not get rotated to iterate the counters on inheritance.

[ Impact: cleanup, optimization ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090520102553.237504544@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    1 -
 kernel/perf_counter.c        |   15 +++++----------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 13cb2fb..c8c1dfc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -508,7 +508,6 @@ struct perf_counter_context {
 	int			nr_counters;
 	int			nr_active;
 	int			is_active;
-	int			rr_allowed;
 	struct task_struct	*task;
 
 	/*
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4d8f973..64113e6 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1120,8 +1120,7 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 	__perf_counter_task_sched_out(ctx);
 
 	rotate_ctx(&cpuctx->ctx);
-	if (ctx->rr_allowed)
-		rotate_ctx(ctx);
+	rotate_ctx(ctx);
 
 	perf_counter_cpu_sched_in(cpuctx, cpu);
 	perf_counter_task_sched_in(curr, cpu);
@@ -3109,7 +3108,6 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->counter_list);
 	INIT_LIST_HEAD(&ctx->event_list);
-	ctx->rr_allowed = 1;
 	ctx->task = task;
 }
 
@@ -3350,14 +3348,14 @@ void perf_counter_init_task(struct task_struct *child)
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
 
@@ -3366,9 +3364,6 @@ void perf_counter_init_task(struct task_struct *child)
 			break;
 	}
 
-	barrier(); /* irqs */
-	parent_ctx->rr_allowed = 1;
-
 	mutex_unlock(&parent_ctx->mutex);
 }
 

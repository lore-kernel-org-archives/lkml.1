Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZKUNm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZKUNm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZKUNmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:42:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:60872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbZKUNmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:42:21 -0500
Date: Sat, 21 Nov 2009 13:41:42 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212508.452227115@chello.nl>
References: <20091120212508.452227115@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize perf_event_task_ctx()
Message-ID: <tip-d6ff86cfb50a72df820e7e839836d55d245306fb@git.kernel.org>
Git-Commit-ID: d6ff86cfb50a72df820e7e839836d55d245306fb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6ff86cfb50a72df820e7e839836d55d245306fb
Gitweb:     http://git.kernel.org/tip/d6ff86cfb50a72df820e7e839836d55d245306fb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:36 +0100

perf: Optimize perf_event_task_ctx()

Remove a rcu_read_{,un}lock() pair and a few conditionals.

We can remove the rcu_read_lock() by increasing the scope of one
in the calling function.

We can do away with the system_state check if the machine still
boots after this patch (seems to be the case).

We can do away with the list_empty() check because the bare
list_for_each_entry_rcu() reduces to that now that we've removed
everything else.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212508.452227115@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index cda17ac..2afb305 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3267,15 +3267,10 @@ static void perf_event_task_ctx(struct perf_event_context *ctx,
 {
 	struct perf_event *event;
 
-	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
-		return;
-
-	rcu_read_lock();
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (perf_event_task_match(event))
 			perf_event_task_output(event, task_event);
 	}
-	rcu_read_unlock();
 }
 
 static void perf_event_task_event(struct perf_task_event *task_event)
@@ -3283,11 +3278,11 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx = task_event->task_ctx;
 
+	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_task_ctx(&cpuctx->ctx, task_event);
 	put_cpu_var(perf_cpu_context);
 
-	rcu_read_lock();
 	if (!ctx)
 		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
 	if (ctx)

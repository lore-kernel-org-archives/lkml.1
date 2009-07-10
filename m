Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZGJKlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZGJKlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZGJKl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:41:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:37760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbZGJKl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:41:27 -0400
Date: Fri, 10 Jul 2009 10:40:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Stop open coding unclone_ctx
Message-ID: <tip-71a851b4d2a815adcfac09c1adda7ef6811fde66@git.kernel.org>
Git-Commit-ID: 71a851b4d2a815adcfac09c1adda7ef6811fde66
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:40:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71a851b4d2a815adcfac09c1adda7ef6811fde66
Gitweb:     http://git.kernel.org/tip/71a851b4d2a815adcfac09c1adda7ef6811fde66
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 10 Jul 2009 09:06:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 10:28:40 +0200

perf_counter: Stop open coding unclone_ctx

Instead of open coding the unclone context thingy, put it in
a common function.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d55a50d..8bf997d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -146,6 +146,14 @@ static void put_ctx(struct perf_counter_context *ctx)
 	}
 }
 
+static void unclone_ctx(struct perf_counter_context *ctx)
+{
+	if (ctx->parent_ctx) {
+		put_ctx(ctx->parent_ctx);
+		ctx->parent_ctx = NULL;
+	}
+}
+
 /*
  * Get the perf_counter_context for a task and lock it.
  * This has to cope with with the fact that until it is locked,
@@ -1463,10 +1471,8 @@ static void perf_counter_enable_on_exec(struct task_struct *task)
 	/*
 	 * Unclone this context if we enabled any counter.
 	 */
-	if (enabled && ctx->parent_ctx) {
-		put_ctx(ctx->parent_ctx);
-		ctx->parent_ctx = NULL;
-	}
+	if (enabled)
+		unclone_ctx(ctx);
 
 	spin_unlock(&ctx->lock);
 
@@ -1526,7 +1532,6 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 
 static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 {
-	struct perf_counter_context *parent_ctx;
 	struct perf_counter_context *ctx;
 	struct perf_cpu_context *cpuctx;
 	struct task_struct *task;
@@ -1586,11 +1591,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
  retry:
 	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
-		parent_ctx = ctx->parent_ctx;
-		if (parent_ctx) {
-			put_ctx(parent_ctx);
-			ctx->parent_ctx = NULL;		/* no longer a clone */
-		}
+		unclone_ctx(ctx);
 		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
@@ -4255,15 +4256,12 @@ void perf_counter_exit_task(struct task_struct *child)
 	 */
 	spin_lock(&child_ctx->lock);
 	child->perf_counter_ctxp = NULL;
-	if (child_ctx->parent_ctx) {
-		/*
-		 * This context is a clone; unclone it so it can't get
-		 * swapped to another process while we're removing all
-		 * the counters from it.
-		 */
-		put_ctx(child_ctx->parent_ctx);
-		child_ctx->parent_ctx = NULL;
-	}
+	/*
+	 * If this context is a clone; unclone it so it can't get
+	 * swapped to another process while we're removing all
+	 * the counters from it.
+	 */
+	unclone_ctx(child_ctx);
 	spin_unlock(&child_ctx->lock);
 	local_irq_restore(flags);
 

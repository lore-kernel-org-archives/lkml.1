Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZGFOUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZGFOUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZGFOT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:19:59 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:54532 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbZGFOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:19:58 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH v2] perf_counter: Provide a way to enable counters on
 exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <19017.43927.838745.689203@cargo.ozlabs.ibm.com>
References: <19017.43927.838745.689203@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 16:19:54 +0200
Message-Id: <1246889994.8143.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 16:07 +1000, Paul Mackerras wrote:
> This provides a way to mark a counter to be enabled on the next exec.
> This is useful for measuring the total activity of a program without
> including overhead from the process that launches it.
> 
> This also changes the perf stat command to use this new facility.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> v2: only unclone if we enabled one or more counters.
> 
> This differs from Ingo's approach a little in that I don't keep the
> counter force-disabled until exec, and I reuse the comm hook instead
> of having a new perf_counter_exec hook (not that a new hook would
> necessarily be a bad idea).  Also, my locking is a bit heavier, it's
> more or less like the old perf_counter_task_enable().

Hmm, we might want to add that second hook since this will also trigger
for things like prctl(PR_SET_NAME).

Also, we would probably want this below...

---
Subject: perf_counter: unify unclone context

We have grown multiple unclone sites, stick it in a function.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d55a50d..322e254 100644
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
+	       unclone_ctx(ctx);
 
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
 



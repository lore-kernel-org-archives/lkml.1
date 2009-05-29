Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbZE2M2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbZE2M2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbZE2M2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:28:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:51746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758724AbZE2M2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:28:19 -0400
Date: Fri, 29 May 2009 12:27:34 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix cpuctx->task_ctx races
Message-ID: <tip-3f4dee227348daac32f36daad9a91059efd0723e@git.kernel.org>
Git-Commit-ID: 3f4dee227348daac32f36daad9a91059efd0723e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 12:27:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f4dee227348daac32f36daad9a91059efd0723e
Gitweb:     http://git.kernel.org/tip/3f4dee227348daac32f36daad9a91059efd0723e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 May 2009 11:25:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 14:28:36 +0200

perf_counter: Fix cpuctx->task_ctx races

Peter noticed that we are sometimes reading cpuctx->task_ctx with
interrupts enabled.

Noticed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index db843f8..eb34604 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -234,15 +234,18 @@ static void __perf_counter_remove_from_context(void *info)
 	struct perf_counter_context *ctx = counter->ctx;
 	unsigned long flags;
 
+	local_irq_save(flags);
 	/*
 	 * If this is a task context, we need to check whether it is
 	 * the current task context of this cpu. If not it has been
 	 * scheduled out before the smp call arrived.
 	 */
-	if (ctx->task && cpuctx->task_ctx != ctx)
+	if (ctx->task && cpuctx->task_ctx != ctx) {
+		local_irq_restore(flags);
 		return;
+	}
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock(&ctx->lock);
 	/*
 	 * Protect the list operation against NMI by disabling the
 	 * counters on a global level.
@@ -382,14 +385,17 @@ static void __perf_counter_disable(void *info)
 	struct perf_counter_context *ctx = counter->ctx;
 	unsigned long flags;
 
+	local_irq_save(flags);
 	/*
 	 * If this is a per-task counter, need to check whether this
 	 * counter's task is the current task on this cpu.
 	 */
-	if (ctx->task && cpuctx->task_ctx != ctx)
+	if (ctx->task && cpuctx->task_ctx != ctx) {
+		local_irq_restore(flags);
 		return;
+	}
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock(&ctx->lock);
 
 	/*
 	 * If the counter is on, turn it off.
@@ -615,6 +621,7 @@ static void __perf_install_in_context(void *info)
 	unsigned long flags;
 	int err;
 
+	local_irq_save(flags);
 	/*
 	 * If this is a task context, we need to check whether it is
 	 * the current task context of this cpu. If not it has been
@@ -623,12 +630,14 @@ static void __perf_install_in_context(void *info)
 	 * on this cpu because it had no counters.
 	 */
 	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current)
+		if (cpuctx->task_ctx || ctx->task != current) {
+			local_irq_restore(flags);
 			return;
+		}
 		cpuctx->task_ctx = ctx;
 	}
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
 
@@ -745,17 +754,20 @@ static void __perf_counter_enable(void *info)
 	unsigned long flags;
 	int err;
 
+	local_irq_save(flags);
 	/*
 	 * If this is a per-task counter, need to check whether this
 	 * counter's task is the current task on this cpu.
 	 */
 	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current)
+		if (cpuctx->task_ctx || ctx->task != current) {
+			local_irq_restore(flags);
 			return;
+		}
 		cpuctx->task_ctx = ctx;
 	}
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock(&ctx->lock);
 	ctx->is_active = 1;
 	update_context_time(ctx);
 

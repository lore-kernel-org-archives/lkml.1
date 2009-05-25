Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZEYMsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZEYMsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZEYMrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:47:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:47589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZEYMrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:47:08 -0400
Message-Id: <20090525124600.324656474@chello.nl>
References: <20090525124523.010479297@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 25 May 2009 14:45:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 4/5] perf_counter: propagate inheritance failures down the fork() path
Content-Disposition: inline; filename=perf_counter-init-fail.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fail fork() when we fail inheritance for some reason (-ENOMEM most likely).

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/fork.c         |    5 ++++-
 kernel/perf_counter.c |   20 ++++++++++++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -983,7 +983,9 @@ static struct task_struct *copy_process(
 		goto fork_out;
 
 	rt_mutex_init_task(p);
-	perf_counter_init_task(p);
+	retval = perf_counter_init_task(p);
+	if (retval)
+		goto bad_fork_free;
 
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
@@ -1309,6 +1311,7 @@ bad_fork_cleanup_count:
 	put_cred(p->real_cred);
 	put_cred(p->cred);
 bad_fork_free:
+	perf_counter_exit_task(p);
 	free_task(p);
 fork_out:
 	return ERR_PTR(retval);
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -3434,18 +3434,23 @@ again:
 /*
  * Initialize the perf_counter context in task_struct
  */
-void perf_counter_init_task(struct task_struct *child)
+int perf_counter_init_task(struct task_struct *child)
 {
 	struct perf_counter_context *child_ctx, *parent_ctx;
 	struct perf_counter *counter;
 	struct task_struct *parent = current;
 	int inherited_all = 1;
+	int ret = 0;
 
 	child->perf_counter_ctxp = NULL;
 
 	mutex_init(&child->perf_counter_mutex);
 	INIT_LIST_HEAD(&child->perf_counter_list);
 
+	parent_ctx = parent->perf_counter_ctxp;
+	if (likely(!parent_ctx || !parent_ctx->nr_counters))
+		return 0;
+
 	/*
 	 * This is executed from the parent task context, so inherit
 	 * counters that have been marked for cloning.
@@ -3454,11 +3459,7 @@ void perf_counter_init_task(struct task_
 
 	child_ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
 	if (!child_ctx)
-		return;
-
-	parent_ctx = parent->perf_counter_ctxp;
-	if (likely(!parent_ctx || !parent_ctx->nr_counters))
-		return;
+		return -ENOMEM;
 
 	__perf_counter_init_context(child_ctx, child);
 	child->perf_counter_ctxp = child_ctx;
@@ -3482,8 +3483,9 @@ void perf_counter_init_task(struct task_
 			continue;
 		}
 
-		if (inherit_group(counter, parent,
-				  parent_ctx, child, child_ctx)) {
+		ret = inherit_group(counter, parent, parent_ctx,
+					     child, child_ctx);
+		if (ret) {
 			inherited_all = 0;
 			break;
 		}
@@ -3505,6 +3507,8 @@ void perf_counter_init_task(struct task_
 	}
 
 	mutex_unlock(&parent_ctx->mutex);
+
+	return ret;
 }
 
 static void __cpuinit perf_counter_init_cpu(int cpu)

-- 


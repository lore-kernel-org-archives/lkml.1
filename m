Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZEYNFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZEYNFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbZEYNEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:04:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:53306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbZEYNEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:04:39 -0400
Date: Mon, 25 May 2009 13:04:07 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525124600.324656474@chello.nl>
References: <20090525124600.324656474@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Propagate inheritance failures down the fork() path
Message-ID: <tip-6ab423e0eaca827fbd201ca4ae7d4f8573a366b2@git.kernel.org>
Git-Commit-ID: 6ab423e0eaca827fbd201ca4ae7d4f8573a366b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 13:04:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ab423e0eaca827fbd201ca4ae7d4f8573a366b2
Gitweb:     http://git.kernel.org/tip/6ab423e0eaca827fbd201ca4ae7d4f8573a366b2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 May 2009 14:45:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 14:55:01 +0200

perf_counter: Propagate inheritance failures down the fork() path

Fail fork() when we fail inheritance for some reason (-ENOMEM most likely).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525124600.324656474@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 ++--
 kernel/fork.c                |    6 +++++-
 kernel/perf_counter.c        |   20 ++++++++++++--------
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index b1f2bac..d3e85de 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -566,7 +566,7 @@ extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
 extern void perf_counter_task_sched_out(struct task_struct *task,
 					struct task_struct *next, int cpu);
 extern void perf_counter_task_tick(struct task_struct *task, int cpu);
-extern void perf_counter_init_task(struct task_struct *child);
+extern int perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
 extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
@@ -631,7 +631,7 @@ perf_counter_task_sched_out(struct task_struct *task,
 			    struct task_struct *next, int cpu)		{ }
 static inline void
 perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
-static inline void perf_counter_init_task(struct task_struct *child)	{ }
+static inline int perf_counter_init_task(struct task_struct *child)	{ }
 static inline void perf_counter_exit_task(struct task_struct *child)	{ }
 static inline void perf_counter_do_pending(void)			{ }
 static inline void perf_counter_print_debug(void)			{ }
diff --git a/kernel/fork.c b/kernel/fork.c
index 675e01e..c07c333 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1095,7 +1095,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
-	perf_counter_init_task(p);
+
+	retval = perf_counter_init_task(p);
+	if (retval)
+		goto bad_fork_cleanup_policy;
 
 	if ((retval = audit_alloc(p)))
 		goto bad_fork_cleanup_policy;
@@ -1295,6 +1298,7 @@ bad_fork_cleanup_semundo:
 bad_fork_cleanup_audit:
 	audit_free(p);
 bad_fork_cleanup_policy:
+	perf_counter_exit_task(p);
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 217dbcc..7a7a144 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
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
@@ -3454,11 +3459,7 @@ void perf_counter_init_task(struct task_struct *child)
 
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
@@ -3482,8 +3483,9 @@ void perf_counter_init_task(struct task_struct *child)
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
@@ -3505,6 +3507,8 @@ void perf_counter_init_task(struct task_struct *child)
 	}
 
 	mutex_unlock(&parent_ctx->mutex);
+
+	return ret;
 }
 
 static void __cpuinit perf_counter_init_cpu(int cpu)

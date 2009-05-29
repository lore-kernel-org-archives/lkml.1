Return-Path: <linux-kernel-owner+w=401wt.eu-S1762509AbZE2RRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762509AbZE2RRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762142AbZE2RRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:17:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:57552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761980AbZE2RRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:17:09 -0400
Date: Fri, 29 May 2009 17:16:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Subject: [tip:perfcounters/core] perf_counter: Ammend cleanup in fork() fail
Message-ID: <tip-bbbee90829304d156c12b171c0ac7e6e1aba8b90@git.kernel.org>
Git-Commit-ID: bbbee90829304d156c12b171c0ac7e6e1aba8b90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 17:16:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbbee90829304d156c12b171c0ac7e6e1aba8b90
Gitweb:     http://git.kernel.org/tip/bbbee90829304d156c12b171c0ac7e6e1aba8b90
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 29 May 2009 14:25:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 16:21:52 +0200

perf_counter: Ammend cleanup in fork() fail

When fork() fails we cannot use perf_counter_exit_task() since that
assumes to operate on current. Write a new helper that cleans up
unused/clean contexts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 +
 kernel/fork.c                |    2 +-
 kernel/perf_counter.c        |   43 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 717bf3b..519a41b 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -579,6 +579,7 @@ extern void perf_counter_task_sched_out(struct task_struct *task,
 extern void perf_counter_task_tick(struct task_struct *task, int cpu);
 extern int perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
+extern void perf_counter_free_task(struct task_struct *task);
 extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
 extern void __perf_disable(void);
@@ -644,6 +645,7 @@ static inline void
 perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
 static inline int perf_counter_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_counter_exit_task(struct task_struct *child)	{ }
+static inline void perf_counter_free_task(struct task_struct *task)	{ }
 static inline void perf_counter_do_pending(void)			{ }
 static inline void perf_counter_print_debug(void)			{ }
 static inline void perf_disable(void)					{ }
diff --git a/kernel/fork.c b/kernel/fork.c
index c07c333..23bf757 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1298,7 +1298,7 @@ bad_fork_cleanup_semundo:
 bad_fork_cleanup_audit:
 	audit_free(p);
 bad_fork_cleanup_policy:
-	perf_counter_exit_task(p);
+	perf_counter_free_task(p);
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0c000d3..79c3f26 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3538,8 +3538,7 @@ static void sync_child_counter(struct perf_counter *child_counter,
 }
 
 static void
-__perf_counter_exit_task(struct task_struct *child,
-			 struct perf_counter *child_counter,
+__perf_counter_exit_task(struct perf_counter *child_counter,
 			 struct perf_counter_context *child_ctx)
 {
 	struct perf_counter *parent_counter;
@@ -3605,7 +3604,7 @@ void perf_counter_exit_task(struct task_struct *child)
 again:
 	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
 				 list_entry)
-		__perf_counter_exit_task(child, child_counter, child_ctx);
+		__perf_counter_exit_task(child_counter, child_ctx);
 
 	/*
 	 * If the last counter was a group counter, it will have appended all
@@ -3621,6 +3620,44 @@ again:
 }
 
 /*
+ * free an unexposed, unused context as created by inheritance by
+ * init_task below, used by fork() in case of fail.
+ */
+void perf_counter_free_task(struct task_struct *task)
+{
+	struct perf_counter_context *ctx = task->perf_counter_ctxp;
+	struct perf_counter *counter, *tmp;
+
+	if (!ctx)
+		return;
+
+	mutex_lock(&ctx->mutex);
+again:
+	list_for_each_entry_safe(counter, tmp, &ctx->counter_list, list_entry) {
+		struct perf_counter *parent = counter->parent;
+
+		if (WARN_ON_ONCE(!parent))
+			continue;
+
+		mutex_lock(&parent->child_mutex);
+		list_del_init(&counter->child_list);
+		mutex_unlock(&parent->child_mutex);
+
+		fput(parent->filp);
+
+		list_del_counter(counter, ctx);
+		free_counter(counter);
+	}
+
+	if (!list_empty(&ctx->counter_list))
+		goto again;
+
+	mutex_unlock(&ctx->mutex);
+
+	put_ctx(ctx);
+}
+
+/*
  * Initialize the perf_counter context in task_struct
  */
 int perf_counter_init_task(struct task_struct *child)

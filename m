Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZFSLys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZFSLys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZFSLxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:53:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:46786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbZFSLxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:53:03 -0400
Date: Fri, 19 Jun 2009 11:52:30 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Simplify and fix task migration counting
Message-ID: <tip-e5289d4a181fb6c0b7a7607649af2ffdc491335c@git.kernel.org>
Git-Commit-ID: e5289d4a181fb6c0b7a7607649af2ffdc491335c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 19 Jun 2009 11:52:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5289d4a181fb6c0b7a7607649af2ffdc491335c
Gitweb:     http://git.kernel.org/tip/e5289d4a181fb6c0b7a7607649af2ffdc491335c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 19 Jun 2009 13:22:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 19 Jun 2009 13:43:12 +0200

perf_counter: Simplify and fix task migration counting

The task migrations counter was causing rare and hard to decypher
memory corruptions under load. After a day of debugging and bisection
we found that the problem was introduced with:

  3f731ca: perf_counter: Fix cpu migration counter

Turning them off fixes the crashes. Incidentally, the whole
perf_counter_task_migration() logic can be done simpler as well,
by injecting a proper sw-counter event.

This cleanup also fixed the crashes. The precise failure mode is
not completely clear yet, but we are clearly not unhappy about
having a fix ;-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 ----
 kernel/perf_counter.c        |   23 +----------------------
 kernel/sched.c               |    3 ++-
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e7e7e02..89698d8 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -682,8 +682,6 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)
 extern void perf_counter_comm(struct task_struct *tsk);
 extern void perf_counter_fork(struct task_struct *tsk);
 
-extern void perf_counter_task_migration(struct task_struct *task, int cpu);
-
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
 extern int sysctl_perf_counter_paranoid;
@@ -724,8 +722,6 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)	{ }
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
-static inline void perf_counter_task_migration(struct task_struct *task,
-					       int cpu)			{ }
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7e9108e..8d4f0dd 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -124,7 +124,7 @@ void perf_enable(void)
 
 static void get_ctx(struct perf_counter_context *ctx)
 {
-	atomic_inc(&ctx->refcount);
+	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
 }
 
 static void free_ctx(struct rcu_head *head)
@@ -3467,27 +3467,6 @@ static const struct pmu perf_ops_task_clock = {
 	.read		= task_clock_perf_counter_read,
 };
 
-/*
- * Software counter: cpu migrations
- */
-void perf_counter_task_migration(struct task_struct *task, int cpu)
-{
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
-	struct perf_counter_context *ctx;
-
-	perf_swcounter_ctx_event(&cpuctx->ctx, PERF_TYPE_SOFTWARE,
-				 PERF_COUNT_SW_CPU_MIGRATIONS,
-				 1, 1, NULL, 0);
-
-	ctx = perf_pin_task_context(task);
-	if (ctx) {
-		perf_swcounter_ctx_event(ctx, PERF_TYPE_SOFTWARE,
-					 PERF_COUNT_SW_CPU_MIGRATIONS,
-					 1, 1, NULL, 0);
-		perf_unpin_context(ctx);
-	}
-}
-
 #ifdef CONFIG_EVENT_PROFILE
 void perf_tpcounter_event(int event_id)
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index 8fb88a9..f46540b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1978,7 +1978,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
 #endif
-		perf_counter_task_migration(p, new_cpu);
+		perf_swcounter_event(PERF_COUNT_SW_CPU_MIGRATIONS,
+				     1, 1, NULL, 0);
 	}
 	p->se.vruntime -= old_cfsrq->min_vruntime -
 					 new_cfsrq->min_vruntime;

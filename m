Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYGQHhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYGQHhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbYGQHcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:32:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759357AbYGQHcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:32:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 21/23] tracehook: wait_task_inactive
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Shopping-List: (1) Global mechanical retarders
   (2) Unopened eggplants
   (3) Would-be pharmaceutical detectors
   (4) Sulfurous flying chasers
Message-Id: <20080717073127.EE3CB1541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:31:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends wait_task_inactive() with a new argument so it
can be used in a "soft" mode where it will check for the task
changing state unexpectedly and back off.  There is no change
to existing callers.  This lays the groundwork to allow robust,
noninvasive tracing that can try to sample a blocked thread but
back off safely if it wakes up.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/ia64/kernel/perfmon.c |    4 ++--
 include/linux/sched.h      |    8 ++++++--
 kernel/kthread.c           |    2 +-
 kernel/ptrace.c            |    2 +-
 kernel/sched.c             |   29 +++++++++++++++++++++++++++--
 5 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 19d4493..fc8f350 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2626,7 +2626,7 @@ pfm_task_incompatible(pfm_context_t *ctx, struct task_struct *task)
 	/*
 	 * make sure the task is off any CPU
 	 */
-	wait_task_inactive(task);
+	wait_task_inactive(task, 0);
 
 	/* more to come... */
 
@@ -4774,7 +4774,7 @@ recheck:
 
 		UNPROTECT_CTX(ctx, flags);
 
-		wait_task_inactive(task);
+		wait_task_inactive(task, 0);
 
 		PROTECT_CTX(ctx, flags);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c58e8ab..48832a2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1872,9 +1872,13 @@ extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
-extern void wait_task_inactive(struct task_struct * p);
+extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
-#define wait_task_inactive(p)	do { } while (0)
+static inline unsigned long wait_task_inactive(struct task_struct *p,
+					       long match_state)
+{
+	return 1;
+}
 #endif
 
 #define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
diff --git a/kernel/kthread.c b/kernel/kthread.c
index ac3fb73..88538db 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -176,7 +176,7 @@ void kthread_bind(struct task_struct *k, unsigned int cpu)
 		return;
 	}
 	/* Must have done schedule() in kthread() before we set_task_cpu */
-	wait_task_inactive(k);
+	wait_task_inactive(k, 0);
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
 	k->rt.nr_cpus_allowed = 1;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 8392a9d..082b3fc 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -107,7 +107,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	read_unlock(&tasklist_lock);
 
 	if (!ret && !kill)
-		wait_task_inactive(child);
+		ret = wait_task_inactive(child, TASK_TRACED) ? 0 : -ESRCH;
 
 	/* All systems go.. */
 	return ret;
diff --git a/kernel/sched.c b/kernel/sched.c
index 99e6d85..33aec6d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1946,16 +1946,24 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 /*
  * wait_task_inactive - wait for a thread to unschedule.
  *
+ * If @match_state is nonzero, it's the @p->state value just checked and
+ * not expected to change.  If it changes, i.e. @p might have woken up,
+ * then return zero.  When we succeed in waiting for @p to be off its CPU,
+ * we return a positive number (its total switch count).  If a second call
+ * a short while later returns the same number, the caller can be sure that
+ * @p has remained unscheduled the whole time.
+ *
  * The caller must ensure that the task *will* unschedule sometime soon,
  * else this function might spin for a *long* time. This function can't
  * be called with interrupts off, or it may introduce deadlock with
  * smp_call_function() if an IPI is sent by the same process we are
  * waiting to become inactive.
  */
-void wait_task_inactive(struct task_struct *p)
+unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 {
 	unsigned long flags;
 	int running, on_rq;
+	unsigned long ncsw;
 	struct rq *rq;
 
 	for (;;) {
@@ -1978,8 +1986,11 @@ void wait_task_inactive(struct task_struct *p)
 		 * return false if the runqueue has changed and p
 		 * is actually now running somewhere else!
 		 */
-		while (task_running(rq, p))
+		while (task_running(rq, p)) {
+			if (match_state && unlikely(p->state != match_state))
+				return 0;
 			cpu_relax();
+		}
 
 		/*
 		 * Ok, time to look more closely! We need the rq
@@ -1989,9 +2000,21 @@ void wait_task_inactive(struct task_struct *p)
 		rq = task_rq_lock(p, &flags);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
+		ncsw = 0;
+		if (!match_state || p->state == match_state) {
+			ncsw = p->nivcsw + p->nvcsw;
+			if (unlikely(!ncsw))
+				ncsw = 1;
+		}
 		task_rq_unlock(rq, &flags);
 
 		/*
+		 * If it changed from the expected state, bail out now.
+		 */
+		if (unlikely(!ncsw))
+			break;
+
+		/*
 		 * Was it really running after all now that we
 		 * checked with the proper locks actually held?
 		 *
@@ -2023,6 +2046,8 @@ void wait_task_inactive(struct task_struct *p)
 		 */
 		break;
 	}
+
+	return ncsw;
 }
 
 /***

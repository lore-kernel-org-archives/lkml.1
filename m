Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYGQH3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYGQH3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbYGQH31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:29:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589AbYGQH30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:29:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 07/23] tracehook: release_task
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
Emacs: because you deserve a brk today.
Message-Id: <20080717072921.6E22E1541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:29:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the ptrace-related logic from release_task into tracehook.h and
ptrace.h inlines.  It provides clean hooks both before and after locking
tasklist_lock, for future tracing logic to do more cleanup without the lock.

This also changes release_task() itself in the rare "zap_leader" case to
set the leader to EXIT_DEAD before iterating.  This maintains the
invariant that release_task() only ever handles a task in EXIT_DEAD.
This is a common-sense invariant that is already always true except in
this one arcane case of zombie leader whose parent ignores SIGCHLD.

This change is harmless and only costs one store in this one rare case.
It keeps the expected state more consisently sane, which is nicer when
debugging weirdness in release_task().  It also lets some future code
in the tracehook entry points rely on this invariant for bookkeeping.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h    |   13 +++++++++++++
 include/linux/tracehook.h |   28 ++++++++++++++++++++++++++++
 kernel/exit.c             |   21 +++++++++------------
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index dae6d85..ed69c03 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -176,6 +176,19 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 	}
 }
 
+/**
+ * ptrace_release_task - final ptrace-related cleanup of a zombie being reaped
+ * @task:	task in %EXIT_DEAD state
+ *
+ * Called with write_lock(&tasklist_lock) held.
+ */
+static inline void ptrace_release_task(struct task_struct *task)
+{
+	BUG_ON(!list_empty(&task->ptraced));
+	ptrace_unlink(task);
+	BUG_ON(!list_empty(&task->ptrace_entry));
+}
+
 #ifndef force_successful_syscall_return
 /*
  * System call handlers that, upon successful completion, need to return a
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 830e6e1..9a5b3be 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -228,4 +228,32 @@ static inline void tracehook_report_vfork_done(struct task_struct *child,
 	ptrace_event(PT_TRACE_VFORK_DONE, PTRACE_EVENT_VFORK_DONE, pid);
 }
 
+/**
+ * tracehook_prepare_release_task - task is being reaped, clean up tracing
+ * @task:		task in %EXIT_DEAD state
+ *
+ * This is called in release_task() just before @task gets finally reaped
+ * and freed.  This would be the ideal place to remove and clean up any
+ * tracing-related state for @task.
+ *
+ * Called with no locks held.
+ */
+static inline void tracehook_prepare_release_task(struct task_struct *task)
+{
+}
+
+/**
+ * tracehook_finish_release_task - task is being reaped, clean up tracing
+ * @task:		task in %EXIT_DEAD state
+ *
+ * This is called in release_task() when @task is being in the middle of
+ * being reaped.  After this, there must be no tracing entanglements.
+ *
+ * Called with write_lock_irq(&tasklist_lock) held.
+ */
+static inline void tracehook_finish_release_task(struct task_struct *task)
+{
+	ptrace_release_task(task);
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/exit.c b/kernel/exit.c
index bd243c3..a416a84 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -153,27 +153,17 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	put_task_struct(container_of(rhp, struct task_struct, rcu));
 }
 
-/*
- * Do final ptrace-related cleanup of a zombie being reaped.
- *
- * Called with write_lock(&tasklist_lock) held.
- */
-static void ptrace_release_task(struct task_struct *p)
-{
-	BUG_ON(!list_empty(&p->ptraced));
-	ptrace_unlink(p);
-	BUG_ON(!list_empty(&p->ptrace_entry));
-}
 
 void release_task(struct task_struct * p)
 {
 	struct task_struct *leader;
 	int zap_leader;
 repeat:
+	tracehook_prepare_release_task(p);
 	atomic_dec(&p->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
-	ptrace_release_task(p);
+	tracehook_finish_release_task(p);
 	__exit_signal(p);
 
 	/*
@@ -195,6 +185,13 @@ repeat:
 		 * that case.
 		 */
 		zap_leader = task_detached(leader);
+
+		/*
+		 * This maintains the invariant that release_task()
+		 * only runs on a task in EXIT_DEAD, just for sanity.
+		 */
+		if (zap_leader)
+			leader->exit_state = EXIT_DEAD;
 	}
 
 	write_unlock_irq(&tasklist_lock);

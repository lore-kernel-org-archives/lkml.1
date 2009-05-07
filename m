Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbZEGJ3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbZEGJ3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761686AbZEGJZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:25:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:45061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761835AbZEGJZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:25:02 -0400
Date: Thu, 7 May 2009 09:24:21 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144603.292754000@intel.com>
References: <20090403144603.292754000@intel.com>
Subject: [tip:tracing/core] x86, ptrace: add bts context unconditionally
Message-ID: <tip-0f4814065ff8c24ca8bfd75c9b73502be152c287@git.kernel.org>
Git-Commit-ID: 0f4814065ff8c24ca8bfd75c9b73502be152c287
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:24:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f4814065ff8c24ca8bfd75c9b73502be152c287
Gitweb:     http://git.kernel.org/tip/0f4814065ff8c24ca8bfd75c9b73502be152c287
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:31 +0200

x86, ptrace: add bts context unconditionally

Add the ptrace bts context field to task_struct unconditionally.

Initialize the field directly in copy_process().
Remove all the unneeded functionality used to initialize that field.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144603.292754000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/ptrace.h |    9 ++++-----
 arch/x86/kernel/ptrace.c      |   20 +-------------------
 include/linux/ptrace.h        |   10 ----------
 include/linux/sched.h         |    2 --
 kernel/fork.c                 |    4 ++--
 kernel/ptrace.c               |   10 ----------
 6 files changed, 7 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index e304b66..5cdd19f 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -235,12 +235,11 @@ extern int do_get_thread_area(struct task_struct *p, int idx,
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
-extern void x86_ptrace_untrace(struct task_struct *);
-extern void x86_ptrace_fork(struct task_struct *child,
-			    unsigned long clone_flags);
+#ifdef CONFIG_X86_PTRACE_BTS
+extern void ptrace_bts_untrace(struct task_struct *tsk);
 
-#define arch_ptrace_untrace(tsk) x86_ptrace_untrace(tsk)
-#define arch_ptrace_fork(child, flags) x86_ptrace_fork(child, flags)
+#define arch_ptrace_untrace(tsk)	ptrace_bts_untrace(tsk)
+#endif /* CONFIG_X86_PTRACE_BTS */
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index adbb243..b32a8ee 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -887,37 +887,19 @@ static int ptrace_bts_size(struct task_struct *child)
 	return (trace->ds.top - trace->ds.begin) / trace->ds.size;
 }
 
-static inline void ptrace_bts_fork(struct task_struct *tsk)
-{
-	tsk->bts = NULL;
-}
-
 /*
  * Called from __ptrace_unlink() after the child has been moved back
  * to its original parent.
  */
-static inline void ptrace_bts_untrace(struct task_struct *child)
+void ptrace_bts_untrace(struct task_struct *child)
 {
 	if (unlikely(child->bts)) {
 		free_bts_context(child->bts);
 		child->bts = NULL;
 	}
 }
-#else
-static inline void ptrace_bts_fork(struct task_struct *tsk) {}
-static inline void ptrace_bts_untrace(struct task_struct *child) {}
 #endif /* CONFIG_X86_PTRACE_BTS */
 
-void x86_ptrace_fork(struct task_struct *child, unsigned long clone_flags)
-{
-	ptrace_bts_fork(child);
-}
-
-void x86_ptrace_untrace(struct task_struct *child)
-{
-	ptrace_bts_untrace(child);
-}
-
 /*
  * Called by kernel/ptrace.c when detaching..
  *
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 67c1565..59e133d 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -95,7 +95,6 @@ extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
 extern void exit_ptrace(struct task_struct *tracer);
-extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
@@ -327,15 +326,6 @@ static inline void user_enable_block_step(struct task_struct *task)
 #define arch_ptrace_untrace(task)		do { } while (0)
 #endif
 
-#ifndef arch_ptrace_fork
-/*
- * Do machine-specific work to initialize a new task.
- *
- * This is called from copy_process().
- */
-#define arch_ptrace_fork(child, clone_flags)	do { } while (0)
-#endif
-
 extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 52b8cd0..451186a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1205,13 +1205,11 @@ struct task_struct {
 	struct list_head ptraced;
 	struct list_head ptrace_entry;
 
-#ifdef CONFIG_X86_PTRACE_BTS
 	/*
 	 * This is the tracer handle for the ptrace BTS extension.
 	 * This field actually belongs to the ptracer task.
 	 */
 	struct bts_context *bts;
-#endif /* CONFIG_X86_PTRACE_BTS */
 
 	/* PID/PID hash table linkage. */
 	struct pid_link pids[PIDTYPE_MAX];
diff --git a/kernel/fork.c b/kernel/fork.c
index 660c2b8..69bde7a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1086,8 +1086,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(current->ptrace))
-		ptrace_fork(p, clone_flags);
+
+	p->bts = NULL;
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index aaad0ec..321127d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -27,16 +27,6 @@
 
 
 /*
- * Initialize a new task whose father had been ptraced.
- *
- * Called from copy_process().
- */
-void ptrace_fork(struct task_struct *child, unsigned long clone_flags)
-{
-	arch_ptrace_fork(child, clone_flags);
-}
-
-/*
  * ptrace a task: make the debugger its new parent and
  * move it to the ptrace list.
  *

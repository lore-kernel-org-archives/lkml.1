Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbZCaOet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbZCaOet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbZCaOdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:33:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:61683 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760286AbZCaOdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677497665"
Date: Tue, 31 Mar 2009 15:41:59 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 18/21] x86, ptrace: remove unused functions
Message-ID: <20090331154159.A13479@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some time ago, I added a ptrace_fork() function to initialize branch
tracing stuff when a new task is created.
There is already a ptrace_init_task() function for that.


Add an arch_ variant to ptrace_init_task() and remove the
ptrace_fork() version.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/include/asm/ptrace.h
===================================================================
--- git-tip.orig/arch/x86/include/asm/ptrace.h	2009-03-31 12:42:50.000000000 +0200
+++ git-tip/arch/x86/include/asm/ptrace.h	2009-03-31 13:30:08.000000000 +0200
@@ -235,12 +235,13 @@ extern int do_get_thread_area(struct tas
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
-extern void x86_ptrace_untrace(struct task_struct *);
-extern void x86_ptrace_fork(struct task_struct *child,
-			    unsigned long clone_flags);
+#ifdef CONFIG_X86_PTRACE_BTS
+extern void ptrace_bts_untrace(struct task_struct *tsk);
+extern void ptrace_bts_init_task(struct task_struct *tsk);
 
-#define arch_ptrace_untrace(tsk) x86_ptrace_untrace(tsk)
-#define arch_ptrace_fork(child, flags) x86_ptrace_fork(child, flags)
+#define arch_ptrace_untrace(tsk)	ptrace_bts_untrace(tsk)
+#define arch_ptrace_init_task(tsk)	ptrace_bts_init_task(tsk)
+#endif /* CONFIG_X86_PTRACE_BTS */
 
 #endif /* __KERNEL__ */
 
Index: git-tip/include/linux/ptrace.h
===================================================================
--- git-tip.orig/include/linux/ptrace.h	2009-03-31 12:42:50.000000000 +0200
+++ git-tip/include/linux/ptrace.h	2009-03-31 13:30:08.000000000 +0200
@@ -94,7 +94,6 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
-extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
@@ -154,6 +153,18 @@ static inline int ptrace_event(int mask,
 	return 1;
 }
 
+#ifndef arch_ptrace_init_task
+/**
+ * arch_ptrace_init_task - initialize machine specific state for a new child
+ * @child:		new child task
+ *
+ * This is called immediately after initializing the general ptrace state.
+ *
+ * Called with current's siglock and write_lock_irq(&tasklist_lock) held.
+ */
+#define arch_ptrace_init_task(child)	do { } while (0)
+#endif
+
 /**
  * ptrace_init_task - initialize ptrace state for a new child
  * @child:		new child task
@@ -174,6 +185,8 @@ static inline void ptrace_init_task(stru
 		child->ptrace = current->ptrace;
 		ptrace_link(child, current->parent);
 	}
+
+	arch_ptrace_init_task(child);
 }
 
 /**
@@ -326,15 +339,6 @@ static inline void user_enable_block_ste
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
Index: git-tip/kernel/fork.c
===================================================================
--- git-tip.orig/kernel/fork.c	2009-03-31 12:42:50.000000000 +0200
+++ git-tip/kernel/fork.c	2009-03-31 13:30:08.000000000 +0200
@@ -1100,8 +1100,6 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(current->ptrace))
-		ptrace_fork(p, clone_flags);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
Index: git-tip/kernel/ptrace.c
===================================================================
--- git-tip.orig/kernel/ptrace.c	2009-03-31 12:42:50.000000000 +0200
+++ git-tip/kernel/ptrace.c	2009-03-31 13:30:08.000000000 +0200
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
Index: git-tip/arch/x86/kernel/ptrace.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ptrace.c	2009-03-31 13:29:12.000000000 +0200
+++ git-tip/arch/x86/kernel/ptrace.c	2009-03-31 13:32:23.000000000 +0200
@@ -885,7 +885,7 @@ static int ptrace_bts_size(struct task_s
 	return (trace->ds.top - trace->ds.begin) / trace->ds.size;
 }
 
-static inline void ptrace_bts_fork(struct task_struct *tsk)
+void ptrace_bts_init_task(struct task_struct *tsk)
 {
 	tsk->bts = NULL;
 	tsk->thread.bts_ovfl_signal = 0;
@@ -895,28 +895,15 @@ static inline void ptrace_bts_fork(struc
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
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


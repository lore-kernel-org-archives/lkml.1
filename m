Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZC0JXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZC0JXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZC0JXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:23:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:5066 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZC0JXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:23:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="398014783"
Date: Fri, 27 Mar 2009 10:23:32 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 11/14] x86, ptrace: remove ptrace_fork, use init_task instead
Message-ID: <20090327102332.A11685@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I introduced ptrace_fork to initialize bts tracing for a new task.

Now I've seen that there is already a ptrace_init_task() called from
tracehook that does essentially the same thing.

Remove ptrace_fork and add an arch_ variant to ptrace_init_task.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/include/asm/ptrace.h
===================================================================
--- git-tip.orig/arch/x86/include/asm/ptrace.h	2009-03-27 08:18:46.000000000 +0100
+++ git-tip/arch/x86/include/asm/ptrace.h	2009-03-27 08:29:32.000000000 +0100
@@ -236,13 +236,12 @@ extern int do_set_thread_area(struct tas
 			      struct user_desc __user *info, int can_allocate);
 
 extern void x86_ptrace_untrace(struct task_struct *child);
-extern void x86_ptrace_fork(struct task_struct *child,
-			    unsigned long clone_flags);
+extern void x86_ptrace_init_task(struct task_struct *child);
 extern void x86_ptrace_report_exit(long exit_code);
 
-#define arch_ptrace_untrace(tsk) x86_ptrace_untrace(tsk)
-#define arch_ptrace_fork(child, flags) x86_ptrace_fork(child, flags)
-#define arch_ptrace_report_exit(code) x86_ptrace_report_exit(code)
+#define arch_ptrace_untrace(tsk)	x86_ptrace_untrace(tsk)
+#define arch_ptrace_init_task(child)	x86_ptrace_init_task(child)
+#define arch_ptrace_report_exit(code)	x86_ptrace_report_exit(code)
 
 #endif /* __KERNEL__ */
 
Index: git-tip/include/linux/ptrace.h
===================================================================
--- git-tip.orig/include/linux/ptrace.h	2009-03-27 08:18:46.000000000 +0100
+++ git-tip/include/linux/ptrace.h	2009-03-27 08:29:32.000000000 +0100
@@ -154,6 +154,18 @@ static inline int ptrace_event(int mask,
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
@@ -174,6 +186,8 @@ static inline void ptrace_init_task(stru
 		child->ptrace = current->ptrace;
 		ptrace_link(child, current->parent);
 	}
+
+	arch_ptrace_init_task(child);
 }
 
 /**
@@ -326,15 +340,6 @@ static inline void user_enable_block_ste
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
 #ifndef arch_ptrace_report_exit
 /**
  * arch_ptrace_report_exit - Do machine specific work for exiting ptraced tasks
Index: git-tip/kernel/fork.c
===================================================================
--- git-tip.orig/kernel/fork.c	2009-03-27 08:18:46.000000000 +0100
+++ git-tip/kernel/fork.c	2009-03-27 08:29:32.000000000 +0100
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
--- git-tip.orig/kernel/ptrace.c	2009-03-27 08:18:46.000000000 +0100
+++ git-tip/kernel/ptrace.c	2009-03-27 08:29:32.000000000 +0100
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
--- git-tip.orig/arch/x86/kernel/ptrace.c	2009-03-27 08:29:32.000000000 +0100
+++ git-tip/arch/x86/kernel/ptrace.c	2009-03-27 08:29:32.000000000 +0100
@@ -781,7 +781,7 @@ static int ptrace_bts_size(struct task_s
 	return (trace->ds.top - trace->ds.begin) / trace->ds.size;
 }
 
-static void ptrace_bts_fork(struct task_struct *tsk)
+static void ptrace_bts_init_task(struct task_struct *tsk)
 {
 	tsk->bts = NULL;
 	tsk->bts_buffer = NULL;
@@ -926,15 +926,14 @@ static void ptrace_bts_untrace(struct ta
 	WARN(child->bts, "leaking BTS tracer\n");
 }
 #else
-static inline void ptrace_bts_fork(struct task_struct *tsk) {}
+static inline void ptrace_bts_init_task(struct task_struct *tsk) {}
 static inline void ptrace_bts_untrace(struct task_struct *child) {}
 static inline void ptrace_bts_exit(void) {}
 #endif /* CONFIG_X86_PTRACE_BTS */
 
-void x86_ptrace_fork(struct task_struct *child,
-		     unsigned long clone_flags)
+void x86_ptrace_init_task(struct task_struct *child)
 {
-	ptrace_bts_fork(child);
+	ptrace_bts_init_task(child);
 }
 
 void x86_ptrace_untrace(struct task_struct *child)
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


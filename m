Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYLSOKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYLSOKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 09:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYLSOKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 09:10:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:22354 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbYLSOKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 09:10:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,249,1228118400"; 
   d="scan'208";a="372294800"
Date: Fri, 19 Dec 2008 15:10:24 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com
Subject: [patch 1/2] x86, bts: fork and exit handling
Message-ID: <20081219151024.A4960@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add arch_ptrace_untrace() function that is called when the tracer
detaches (either voluntarily or when the tracing task dies);
ptrace_disable() is only called on a voluntary detach.

Add ptrace_fork() and arch_ptrace_fork(). They are called when a
traced task is forked.

Clear DS and BTS related fields on fork.

Release DS resources and reclaim memory in ptrace_untrace(). This
releases resources already when the tracing task dies. We used to do
that when the traced task dies.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/process_32.c
===================================================================
--- ftrace.orig/arch/x86/kernel/process_32.c	2008-12-19 12:28:23.000000000 +0100
+++ ftrace/arch/x86/kernel/process_32.c	2008-12-19 13:18:52.000000000 +0100
@@ -60,6 +60,7 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/smp.h>
+#include <asm/ds.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -251,17 +252,8 @@
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
-#ifdef CONFIG_X86_DS
-	/* Free any BTS tracers that have not been properly released. */
-	if (unlikely(current->bts)) {
-		ds_release_bts(current->bts);
-		current->bts = NULL;
-
-		kfree(current->bts_buffer);
-		current->bts_buffer = NULL;
-		current->bts_size = 0;
-	}
-#endif /* CONFIG_X86_DS */
+
+	ds_exit_thread(current);
 }
 
 void flush_thread(void)
@@ -343,6 +335,12 @@
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+
+	ds_copy_thread(p, current);
+
+	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
+	p->thread.debugctlmsr = 0;
+
 	return err;
 }
 
Index: ftrace/arch/x86/kernel/process_64.c
===================================================================
--- ftrace.orig/arch/x86/kernel/process_64.c	2008-12-19 12:29:30.000000000 +0100
+++ ftrace/arch/x86/kernel/process_64.c	2008-12-19 12:29:41.000000000 +0100
@@ -54,6 +54,7 @@
 #include <asm/ia32.h>
 #include <asm/idle.h>
 #include <asm/syscalls.h>
+#include <asm/ds.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -248,17 +249,8 @@
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
-#ifdef CONFIG_X86_DS
-	/* Free any BTS tracers that have not been properly released. */
-	if (unlikely(current->bts)) {
-		ds_release_bts(current->bts);
-		current->bts = NULL;
-
-		kfree(current->bts_buffer);
-		current->bts_buffer = NULL;
-		current->bts_size = 0;
-	}
-#endif /* CONFIG_X86_DS */
+
+	ds_exit_thread(current);
 }
 
 void flush_thread(void)
@@ -388,6 +380,12 @@
 		if (err)
 			goto out;
 	}
+
+	ds_copy_thread(p, me);
+
+	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
+	p->thread.debugctlmsr = 0;
+
 	err = 0;
 out:
 	if (err && p->thread.io_bitmap_ptr) {
Index: ftrace/kernel/fork.c
===================================================================
--- ftrace.orig/kernel/fork.c	2008-12-19 12:29:32.000000000 +0100
+++ ftrace/kernel/fork.c	2008-12-19 12:29:41.000000000 +0100
@@ -1102,6 +1102,8 @@
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
+	if (unlikely(ptrace_reparented(current)))
+		ptrace_fork(p, clone_flags);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
Index: ftrace/arch/x86/include/asm/ds.h
===================================================================
--- ftrace.orig/arch/x86/include/asm/ds.h	2008-12-19 12:28:23.000000000 +0100
+++ ftrace/arch/x86/include/asm/ds.h	2008-12-19 12:29:41.000000000 +0100
@@ -252,12 +252,21 @@
  */
 extern void ds_switch_to(struct task_struct *prev, struct task_struct *next);
 
+/*
+ * Task clone/init and cleanup work
+ */
+extern void ds_copy_thread(struct task_struct *tsk, struct task_struct *father);
+extern void ds_exit_thread(struct task_struct *tsk);
+
 #else /* CONFIG_X86_DS */
 
 struct cpuinfo_x86;
 static inline void __cpuinit ds_init_intel(struct cpuinfo_x86 *ignored) {}
 static inline void ds_switch_to(struct task_struct *prev,
 				struct task_struct *next) {}
+static inline void ds_copy_thread(struct task_struct *tsk,
+				  struct task_struct *father) {}
+static inline void ds_exit_thread(struct task_struct *tsk) {}
 
 #endif /* CONFIG_X86_DS */
 #endif /* _ASM_X86_DS_H */
Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-12-19 12:29:30.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-12-19 12:29:41.000000000 +0100
@@ -1022,3 +1022,14 @@
 
 	update_debugctlmsr(next->thread.debugctlmsr);
 }
+
+void ds_copy_thread(struct task_struct *tsk, struct task_struct *father)
+{
+	clear_tsk_thread_flag(tsk, TIF_DS_AREA_MSR);
+	tsk->thread.ds_ctx = NULL;
+}
+
+void ds_exit_thread(struct task_struct *tsk)
+{
+	WARN_ON(tsk->thread.ds_ctx);
+}
Index: ftrace/arch/x86/kernel/ptrace.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ptrace.c	2008-12-19 12:28:23.000000000 +0100
+++ ftrace/arch/x86/kernel/ptrace.c	2008-12-19 13:17:47.000000000 +0100
@@ -769,8 +769,47 @@
 
 	return (trace->ds.top - trace->ds.begin) / trace->ds.size;
 }
+
+static void ptrace_bts_fork(struct task_struct *tsk)
+{
+	tsk->bts = NULL;
+	tsk->bts_buffer = NULL;
+	tsk->bts_size = 0;
+	tsk->thread.bts_ovfl_signal = 0;
+}
+
+static void ptrace_bts_untrace(struct task_struct *child)
+{
+	if (unlikely(child->bts)) {
+		ds_release_bts(child->bts);
+		child->bts = NULL;
+
+		kfree(child->bts_buffer);
+		child->bts_buffer = NULL;
+		child->bts_size = 0;
+	}
+}
+
+static void ptrace_bts_detach(struct task_struct *child)
+{
+	ptrace_bts_untrace(child);
+}
+#else
+static inline void ptrace_bts_fork(struct task_struct *tsk) {}
+static inline void ptrace_bts_detach(struct task_struct *child) {}
+static inline void ptrace_bts_untrace(struct task_struct *child) {}
 #endif /* CONFIG_X86_PTRACE_BTS */
 
+void x86_ptrace_fork(struct task_struct *child, unsigned long clone_flags)
+{
+	ptrace_bts_fork(child);
+}
+
+void x86_ptrace_untrace(struct task_struct *child)
+{
+	ptrace_bts_untrace(child);
+}
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -782,16 +821,7 @@
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
-#ifdef CONFIG_X86_PTRACE_BTS
-	if (child->bts) {
-		ds_release_bts(child->bts);
-		child->bts = NULL;
-
-		kfree(child->bts_buffer);
-		child->bts_buffer = NULL;
-		child->bts_size = 0;
-	}
-#endif /* CONFIG_X86_PTRACE_BTS */
+	ptrace_bts_detach(child);
 }
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
Index: ftrace/include/linux/ptrace.h
===================================================================
--- ftrace.orig/include/linux/ptrace.h	2008-12-19 12:28:23.000000000 +0100
+++ ftrace/include/linux/ptrace.h	2008-12-19 12:29:41.000000000 +0100
@@ -94,6 +94,7 @@
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
+extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
@@ -313,6 +314,27 @@
 #define arch_ptrace_stop(code, info)		do { } while (0)
 #endif
 
+#ifndef arch_ptrace_untrace
+/*
+ * Do machine-specific work before untracing child.
+ *
+ * This is called for a normal detach as well as from ptrace_exit()
+ * when the tracing task dies.
+ *
+ * Called with write_lock(&tasklist_lock) held.
+ */
+#define arch_ptrace_untrace(task)		do { } while (0)
+#endif
+
+#ifndef arch_ptrace_fork
+/*
+ * Do machine-specific work to initialize a new task.
+ *
+ * This is called from copy_process().
+ */
+#define arch_ptrace_fork(child, clone_flags)	do { } while (0)
+#endif
+
 extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
Index: ftrace/kernel/ptrace.c
===================================================================
--- ftrace.orig/kernel/ptrace.c	2008-12-19 12:28:23.000000000 +0100
+++ ftrace/kernel/ptrace.c	2008-12-19 12:29:41.000000000 +0100
@@ -25,6 +25,17 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 
+
+/*
+ * Initialize a new task whose father had been ptraced.
+ *
+ * Called from copy_process().
+ */
+void ptrace_fork(struct task_struct *child, unsigned long clone_flags)
+{
+	arch_ptrace_fork(child, clone_flags);
+}
+
 /*
  * ptrace a task: make the debugger its new parent and
  * move it to the ptrace list.
@@ -72,6 +83,7 @@
 	child->parent = child->real_parent;
 	list_del_init(&child->ptrace_entry);
 
+	arch_ptrace_untrace(child);
 	if (task_is_traced(child))
 		ptrace_untrace(child);
 }
Index: ftrace/arch/x86/include/asm/ptrace.h
===================================================================
--- ftrace.orig/arch/x86/include/asm/ptrace.h	2008-12-19 12:28:23.000000000 +0100
+++ ftrace/arch/x86/include/asm/ptrace.h	2008-12-19 12:29:41.000000000 +0100
@@ -235,6 +235,13 @@
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
+extern void x86_ptrace_untrace(struct task_struct *);
+extern void x86_ptrace_fork(struct task_struct *child,
+			    unsigned long clone_flags);
+
+#define arch_ptrace_untrace(tsk) x86_ptrace_untrace(tsk)
+#define arch_ptrace_fork(child, flags) x86_ptrace_fork(child, flags)
+
 #endif /* __KERNEL__ */
 
 #endif /* !__ASSEMBLY__ */
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


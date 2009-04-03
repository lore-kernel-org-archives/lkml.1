Return-Path: <linux-kernel-owner+w=401wt.eu-S934136AbZDCOwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136AbZDCOwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932767AbZDCOqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:16751 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745AbZDCOqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:09 -0400
Content-Type: multipart/mixed; boundary="===============0499693707=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328376"
Message-Id: <20090403144603.292754000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:48 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 16/20] x86, ptrace: add bts context unconditionally
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0499693707==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ptrace.arch_init_task.patch

Add the ptrace bts context field to task_struct unconditionally.

Initialize the field directly in copy_process().
Remove all the unneeded functionality used to initialize that field.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/ptrace.h |    9 	4 +	5 -	0 !
 arch/x86/kernel/ptrace.c      |   20 	1 +	19 -	0 !
 include/linux/ptrace.h        |   10 	0 +	10 -	0 !
 include/linux/sched.h         |    2 	0 +	2 -	0 !
 kernel/fork.c                 |    4 	2 +	2 -	0 !
 kernel/ptrace.c               |   10 	0 +	10 -	0 !
 6 files changed, 7 insertions(+), 48 deletions(-)

Index: b/arch/x86/include/asm/ptrace.h
===================================================================
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -235,12 +235,11 @@ extern int do_get_thread_area(struct tas
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
 
Index: b/include/linux/ptrace.h
===================================================================
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -94,7 +94,6 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
-extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
@@ -326,15 +325,6 @@ static inline void user_enable_block_ste
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
Index: b/kernel/fork.c
===================================================================
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1100,8 +1100,8 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(current->ptrace))
-		ptrace_fork(p, clone_flags);
+
+	p->bts = NULL;
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
Index: b/kernel/ptrace.c
===================================================================
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
Index: b/arch/x86/kernel/ptrace.c
===================================================================
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -888,37 +888,19 @@ static int ptrace_bts_size(struct task_s
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
Index: b/include/linux/sched.h
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1207,13 +1207,11 @@ struct task_struct {
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

-- 

--===============0499693707==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

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

--===============0499693707==--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbZC0Jfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbZC0Jfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757582AbZC0Jdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:33:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:18096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbZC0Jdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="501272292"
Date: Fri, 27 Mar 2009 09:55:25 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 3/14] x86, ptrace, bts: stop bts tracing early in do_exit
Message-ID: <20090327095525.A11052@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bts tracing had been stopped in __ptrace_unlink() which is called
with interrupts disabled and tasklist_lock write-held.

Release the bts tracer early in do_exit() when interrupts are enabled
and tasklist_lock is not held.

Resolve races between exit and detach by atomically exchanging the
bts tracer pointer with NULL.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/include/asm/ptrace.h
===================================================================
--- git-tip.orig/arch/x86/include/asm/ptrace.h	2009-03-27 07:59:22.000000000 +0100
+++ git-tip/arch/x86/include/asm/ptrace.h	2009-03-27 08:18:46.000000000 +0100
@@ -235,12 +235,14 @@ extern int do_get_thread_area(struct tas
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
-extern void x86_ptrace_untrace(struct task_struct *);
+extern void x86_ptrace_untrace(struct task_struct *child);
 extern void x86_ptrace_fork(struct task_struct *child,
 			    unsigned long clone_flags);
+extern void x86_ptrace_report_exit(long exit_code);
 
 #define arch_ptrace_untrace(tsk) x86_ptrace_untrace(tsk)
 #define arch_ptrace_fork(child, flags) x86_ptrace_fork(child, flags)
+#define arch_ptrace_report_exit(code) x86_ptrace_report_exit(code)
 
 #endif /* __KERNEL__ */
 
Index: git-tip/arch/x86/kernel/ptrace.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ptrace.c	2009-03-27 07:59:23.000000000 +0100
+++ git-tip/arch/x86/kernel/ptrace.c	2009-03-27 08:27:46.000000000 +0100
@@ -789,41 +789,150 @@ static void ptrace_bts_fork(struct task_
 	tsk->thread.bts_ovfl_signal = 0;
 }
 
-static void ptrace_bts_untrace(struct task_struct *child)
+/*
+ * Release child's bts tracer and free the bts trace buffer.
+ *
+ * This is called for:
+ * - a normal detach
+ * - an exiting tracer
+ * - an exiting tracee
+ *
+ * The various calls may race.
+ *
+ * The first to grab the bts tracer pointer will release first the
+ * tracer and then the buffer.
+ *
+ * Tracer and tracee will call this with the tracer's mm.
+ *
+ * Must be called with interrupts enabled and tasklist_lock not held.
+ */
+static void ptrace_bts_release(struct task_struct *child,
+			       struct mm_struct *mm)
 {
-	if (unlikely(child->bts)) {
-		ds_release_bts(child->bts);
-		child->bts = NULL;
-
-		/* We cannot update total_vm and locked_vm since
-		   child's mm is already gone. But we can reclaim the
-		   memory. */
+	struct bts_tracer *tracer;
+
+	tracer = xchg(&child->bts, NULL);
+	if (tracer) {
+		ds_release_bts(tracer);
+
+		release_locked_buffer_on_behalf(mm, child->bts_buffer,
+						child->bts_size);
 		kfree(child->bts_buffer);
 		child->bts_buffer = NULL;
 		child->bts_size = 0;
 	}
 }
 
-static void ptrace_bts_detach(struct task_struct *child)
+static void ptrace_bts_exit_tracer(void)
 {
+	struct task_struct *child, *next;
+
 	/*
-	 * Ptrace_detach() races with ptrace_untrace() in case
-	 * the child dies and is reaped by another thread.
+	 * We must not hold the tasklist_lock when we release the bts
+	 * tracer, since we need to make sure the cpu executing the
+	 * tracee stops tracing before we may free the trace buffer.
 	 *
-	 * We only do the memory accounting at this point and
-	 * leave the buffer deallocation and the bts tracer
-	 * release to ptrace_bts_untrace() which will be called
-	 * later on with tasklist_lock held.
+	 * read_lock(&tasklist_lock) and smp_call_function() may
+	 * deadlock with write_lock_irq(&tasklist_lock).
+	 *
+	 * We need to hold the tasklist_lock while iterating over our list
+	 * of ptraced children, though, to protect against inserts
+	 * (e.g. traceme).
+	 *
+	 * New additions will not have bts tracers, yet. Removals will have
+	 * their bts tracer released by the removing task.
+	 * All we need to care about is that we complete one traversal.
+	 *
+	 * We use the next pointer in the safe walk to detect any changes
+	 * involving the current element that might affect our traversal and
+	 * start over again.
 	 */
-	release_locked_buffer(child->bts_buffer, child->bts_size);
+	read_lock(&tasklist_lock);
+ repeat:
+	list_for_each_entry_safe(child, next, &current->ptraced, ptrace_entry) {
+		int start_over;
+
+		get_task_struct(child);
+		read_unlock(&tasklist_lock);
+
+		ptrace_bts_release(child, current->mm);
+
+		read_lock(&tasklist_lock);
+		start_over =
+			next != list_entry(child->ptrace_entry.next,
+					   typeof(*child), ptrace_entry);
+		put_task_struct(child);
+		if (start_over)
+			goto repeat;
+	}
+	read_unlock(&tasklist_lock);
+}
+
+static void ptrace_bts_exit_tracee(void)
+{
+	struct mm_struct *mm = NULL;
+
+	/*
+	 * This code may race with ptrace reparenting.
+	 *
+	 * We hold the tasklist lock while we check whether we're
+	 * ptraced and grab our ptracer's mm.
+	 *
+	 * It does not really matter if we're reparented,
+	 * afterwards. We hold onto the correct mm.
+	 *
+	 * If we're reparented before we get the tasklist_lock, our
+	 * former ptrace parent will release the bts tracer.
+	 */
+	read_lock(&tasklist_lock);
+	if (current->ptrace)
+		mm = get_task_mm(current->parent);
+	read_unlock(&tasklist_lock);
+
+	if (mm) {
+		ptrace_bts_release(current, mm);
+		mmput(mm);
+	}
+}
+
+/*
+ * Cleanup bts tracing for an exiting task.
+ *
+ * Tracer and tracee may race to release the bts tracer. Whoever
+ * reaches it first, will release it.
+ * Both will use the tracer's mm for refunding the allocated and
+ * locked memory.
+ *
+ * Must be called with interrupts enabled and no locks held.
+ */
+static void ptrace_bts_exit(void)
+{
+	if (unlikely(!list_empty(&current->ptraced)))
+		ptrace_bts_exit_tracer();
+
+	if (unlikely(current->bts))
+		ptrace_bts_exit_tracee();
+}
+
+/*
+ * Called from __ptrace_unlink() after the child has been moved back
+ * to its original parent.
+ *
+ * By then, branch tracing should have been disabled, already; either
+ * via ptrace_detach() or via do_exit() of either tracer or tracee.
+ */
+static void ptrace_bts_untrace(struct task_struct *child)
+{
+	WARN(child->bts, "leaking BTS tracer\n");
 }
 #else
 static inline void ptrace_bts_fork(struct task_struct *tsk) {}
-static inline void ptrace_bts_detach(struct task_struct *child) {}
 static inline void ptrace_bts_untrace(struct task_struct *child) {}
+static inline void ptrace_bts_exit(void) {}
 #endif /* CONFIG_X86_PTRACE_BTS */
 
-void x86_ptrace_fork(struct task_struct *child, unsigned long clone_flags)
+void x86_ptrace_fork(struct task_struct *child,
+		     unsigned long clone_flags)
 {
 	ptrace_bts_fork(child);
 }
@@ -833,6 +942,11 @@ void x86_ptrace_untrace(struct task_stru
 	ptrace_bts_untrace(child);
 }
 
+void x86_ptrace_report_exit(long exit_code)
+{
+	ptrace_bts_exit();
+}
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -844,7 +958,7 @@ void ptrace_disable(struct task_struct *
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
-	ptrace_bts_detach(child);
+	ptrace_bts_release(child, current->mm);
 }
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
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


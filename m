Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXBJL5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXBJL5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbXBJLxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:53:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:55912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933446AbXBJLws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:52:48 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101252.033732000@suse.de>
In-Reply-To: <200702101252.033732000@suse.de>
To: Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review II] [2/10] i386: paravirt CPU hypercall batching mode
Message-Id: <20070210115230.23B5013DCE@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:52:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

The VMI ROM has a mode where hypercalls can be queued and batched.  This turns
out to be a significant win during context switch, but must be done at a
specific point before side effects to CPU state are visible to subsequent
instructions.  This is similar to the MMU batching hooks already provided. 
The same hooks could be used by the Xen backend to implement a context switch
multicall.

To explain a bit more about lazy modes in the paravirt patches, basically, the
idea is that only one of lazy CPU or MMU mode can be active at any given time.
 Lazy MMU mode is similar to this lazy CPU mode, and allows for batching of
multiple PTE updates (say, inside a remap loop), but to avoid keeping some
kind of state machine about when to flush cpu or mmu updates, we just allow
one or the other to be active.  Although there is no real reason a more
comprehensive scheme could not be implemented, there is also no demonstrated
need for this extra complexity.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/paravirt.c   |    1 +
 arch/i386/kernel/process.c    |   25 +++++++++++++++++--------
 include/asm-generic/pgtable.h |   13 +++++++++++++
 include/asm-i386/paravirt.h   |   15 +++++++++++++++
 kernel/sched.c                |    7 +++++++
 5 files changed, 53 insertions(+), 8 deletions(-)

Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -545,6 +545,7 @@ struct paravirt_ops paravirt_ops = {
 	.apic_write_atomic = native_apic_write_atomic,
 	.apic_read = native_apic_read,
 #endif
+	.set_lazy_mode = (void *)native_nop,
 
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
@@ -670,14 +670,6 @@ struct task_struct fastcall * __switch_t
 	load_TLS(next, cpu);
 
 	/*
-	 * Restore %gs if needed (which is common)
-	 */
-	if (prev->gs | next->gs)
-		loadsegment(gs, next->gs);
-
-	write_pda(pcurrent, next_p);
-
-	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
 	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
@@ -686,6 +678,15 @@ struct task_struct fastcall * __switch_t
 
 	disable_tsc(prev_p, next_p);
 
+	/*
+	 * Leave lazy mode, flushing any hypercalls made here.
+	 * This must be done before restoring TLS segments so
+	 * the GDT and LDT are properly updated, and must be
+	 * done before math_state_restore, so the TS bit is up
+	 * to date.
+	 */
+	arch_leave_lazy_cpu_mode();
+
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
@@ -693,6 +694,14 @@ struct task_struct fastcall * __switch_t
 	if (next_p->fpu_counter > 5)
 		math_state_restore();
 
+	/*
+	 * Restore %gs if needed (which is common)
+	 */
+	if (prev->gs | next->gs)
+		loadsegment(gs, next->gs);
+
+	write_pda(pcurrent, next_p);
+
 	return prev_p;
 }
 
Index: linux/include/asm-generic/pgtable.h
===================================================================
--- linux.orig/include/asm-generic/pgtable.h
+++ linux/include/asm-generic/pgtable.h
@@ -183,6 +183,19 @@ static inline void ptep_set_wrprotect(st
 #endif
 
 /*
+ * A facility to provide batching of the reload of page tables with the
+ * actual context switch code for paravirtualized guests.  By convention,
+ * only one of the lazy modes (CPU, MMU) should be active at any given
+ * time, entry should never be nested, and entry and exits should always
+ * be paired.  This is for sanity of maintaining and reasoning about the
+ * kernel code.
+ */
+#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+#define arch_leave_lazy_cpu_mode()	do {} while (0)
+#endif
+
+/*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
  * vma end wraps to 0, rounded up __boundary may wrap to 0 throughout.
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -146,6 +146,8 @@ struct paravirt_ops
 	void (fastcall *pmd_clear)(pmd_t *pmdp);
 #endif
 
+	void (fastcall *set_lazy_mode)(int mode);
+
 	/* These two are jmp to, not actually called. */
 	void (fastcall *irq_enable_sysexit)(void);
 	void (fastcall *iret)(void);
@@ -386,6 +388,19 @@ static inline void pmd_clear(pmd_t *pmdp
 }
 #endif
 
+/* Lazy mode for batching updates / context switch */
+#define PARAVIRT_LAZY_NONE 0
+#define PARAVIRT_LAZY_MMU  1
+#define PARAVIRT_LAZY_CPU  2
+
+#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
+#define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+
+#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
+#define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
 	u8 *instr; 		/* original instructions */
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1843,6 +1843,13 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm = next->mm;
 	struct mm_struct *oldmm = prev->active_mm;
 
+	/*
+	 * For paravirt, this is coupled with an exit in switch_to to
+	 * combine the page table reload and the switch backend into
+	 * one hypercall.
+	 */
+	arch_enter_lazy_cpu_mode();
+
 	if (!mm) {
 		next->active_mm = oldmm;
 		atomic_inc(&oldmm->mm_count);

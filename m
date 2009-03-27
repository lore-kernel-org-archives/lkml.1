Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbZC0SDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbZC0SDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZC0SCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:48 -0400
Received: from gw.goop.org ([64.81.55.164]:58145 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751145AbZC0SCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/8] x86/pvops: replace arch_enter_lazy_cpu_mode with arch_start_context_switch
Date: Fri, 27 Mar 2009 11:02:38 -0700
Message-Id: <1238176963-21093-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: simplification, prepare for later changes

Make lazy cpu mode more specific to context switching, so that
it makes sense to do more context-switch specific things in
the callbacks.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h |    8 +++-----
 arch/x86/kernel/paravirt.c      |   13 -------------
 arch/x86/kernel/process_32.c    |    2 +-
 arch/x86/kernel/process_64.c    |    2 +-
 arch/x86/xen/mmu.c              |    5 +----
 include/asm-frv/pgtable.h       |    4 ++--
 include/asm-generic/pgtable.h   |   21 +++++++++++----------
 kernel/sched.c                  |    2 +-
 8 files changed, 20 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 7727aa8..f79dc89 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1405,19 +1405,17 @@ void paravirt_enter_lazy_mmu(void);
 void paravirt_leave_lazy_mmu(void);
 void paravirt_leave_lazy(enum paravirt_lazy_mode mode);
 
-#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-static inline void arch_enter_lazy_cpu_mode(void)
+#define  __HAVE_ARCH_START_CONTEXT_SWITCH
+static inline void arch_start_context_switch(void)
 {
 	PVOP_VCALL0(pv_cpu_ops.lazy_mode.enter);
 }
 
-static inline void arch_leave_lazy_cpu_mode(void)
+static inline void arch_end_context_switch(void)
 {
 	PVOP_VCALL0(pv_cpu_ops.lazy_mode.leave);
 }
 
-void arch_flush_lazy_cpu_mode(void);
-
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c866521..a53e4fb 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -301,19 +301,6 @@ void arch_flush_lazy_mmu_mode(void)
 	preempt_enable();
 }
 
-void arch_flush_lazy_cpu_mode(void)
-{
-	preempt_disable();
-
-	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU) {
-		WARN_ON(preempt_count() == 1);
-		arch_leave_lazy_cpu_mode();
-		arch_enter_lazy_cpu_mode();
-	}
-
-	preempt_enable();
-}
-
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 14014d7..57e49a8 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -407,7 +407,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_leave_lazy_cpu_mode();
+	arch_end_context_switch();
 
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index abb7e6a..7115e60 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -428,7 +428,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_leave_lazy_cpu_mode();
+	arch_end_context_switch();
 
 	/*
 	 * Switch FS and GS.
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index db3802f..4702c79 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1119,10 +1119,8 @@ static void drop_other_mm_ref(void *info)
 
 	/* If this cpu still has a stale cr3 reference, then make sure
 	   it has been flushed. */
-	if (percpu_read(xen_current_cr3) == __pa(mm->pgd)) {
+	if (percpu_read(xen_current_cr3) == __pa(mm->pgd))
 		load_cr3(swapper_pg_dir);
-		arch_flush_lazy_cpu_mode();
-	}
 }
 
 static void xen_drop_mm_ref(struct mm_struct *mm)
@@ -1135,7 +1133,6 @@ static void xen_drop_mm_ref(struct mm_struct *mm)
 			load_cr3(swapper_pg_dir);
 		else
 			leave_mm(smp_processor_id());
-		arch_flush_lazy_cpu_mode();
 	}
 
 	/* Get the "official" set of cpus referring to our pagetable. */
diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index e16fdb1..235e34a 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -73,8 +73,8 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define pgtable_cache_init()		do {} while (0)
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
+
+#define arch_start_context_switch()	do {} while (0)
 
 #else /* !CONFIG_MMU */
 /*****************************************************************************/
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 8e6d0ca..922f036 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -280,17 +280,18 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
 #endif
 
 /*
- * A facility to provide batching of the reload of page tables with the
- * actual context switch code for paravirtualized guests.  By convention,
- * only one of the lazy modes (CPU, MMU) should be active at any given
- * time, entry should never be nested, and entry and exits should always
- * be paired.  This is for sanity of maintaining and reasoning about the
- * kernel code.
+ * A facility to provide batching of the reload of page tables and
+ * other process state with the actual context switch code for
+ * paravirtualized guests.  By convention, only one of the batched
+ * update (lazy) modes (CPU, MMU) should be active at any given time,
+ * entry should never be nested, and entry and exits should always be
+ * paired.  This is for sanity of maintaining and reasoning about the
+ * kernel code.  In this case, the exit (end of the context switch) is
+ * in architecture-specific code, and so doesn't need a generic
+ * definition.
  */
-#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
-#define arch_flush_lazy_cpu_mode()	do {} while (0)
+#ifndef __HAVE_ARCH_START_CONTEXT_SWITCH
+#define arch_start_context_switch()	do {} while (0)
 #endif
 
 #ifndef __HAVE_PFNMAP_TRACKING
diff --git a/kernel/sched.c b/kernel/sched.c
index 3e827b8..168adaf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2804,7 +2804,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * combine the page table reload and the switch backend into
 	 * one hypercall.
 	 */
-	arch_enter_lazy_cpu_mode();
+	arch_start_context_switch();
 
 	if (unlikely(!mm)) {
 		next->active_mm = oldmm;
-- 
1.6.0.6


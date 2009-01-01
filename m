Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZAAAPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZAAAPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 19:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZAAANu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 19:13:50 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:8044 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZAAANs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 19:13:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fRD34yyjE+PimEnZ2hViVpFoveTjefS08lsjSRuxiugCeXHZipvB/aJKP5crkYPZOo
         SKsW+Z5j6+om/DQpNzejlJtDoyOqJHa2Dfshlh7dZu/u2akJ73UQksqnrpBxsXmeaU0E
         KlnpJVWUcCzUNR3nJXWbbvydqF4EBpN27gjl8=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 4/4] x86-64: Move TLB state from PDA to per-cpu and consolidate with 32-bit.
Date: Wed, 31 Dec 2008 19:13:43 -0500
Message-Id: <1230768823-31037-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
References: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/mmu_context_64.h |   14 +++++++-------
 arch/x86/include/asm/pda.h            |    2 --
 arch/x86/include/asm/tlbflush.h       |    7 ++-----
 arch/x86/kernel/cpu/common.c          |    2 --
 arch/x86/kernel/tlb_32.c              |   12 ++----------
 arch/x86/kernel/tlb_64.c              |   13 ++++++++-----
 arch/x86/xen/mmu.c                    |    6 +-----
 7 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context_64.h b/arch/x86/include/asm/mmu_context_64.h
index 677d36e..8fb6060 100644
--- a/arch/x86/include/asm/mmu_context_64.h
+++ b/arch/x86/include/asm/mmu_context_64.h
@@ -6,8 +6,8 @@
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (read_pda(mmu_state) == TLBSTATE_OK)
-		write_pda(mmu_state, TLBSTATE_LAZY);
+	if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK)
+		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -19,8 +19,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* stop flush ipis for the previous mm */
 		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
-		write_pda(mmu_state, TLBSTATE_OK);
-		write_pda(active_mm, next);
+		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_OK);
+		x86_write_percpu(cpu_tlbstate.active_mm, next);
 #endif
 		cpu_set(cpu, next->cpu_vm_mask);
 		load_cr3(next->pgd);
@@ -30,9 +30,9 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	}
 #ifdef CONFIG_SMP
 	else {
-		write_pda(mmu_state, TLBSTATE_OK);
-		if (read_pda(active_mm) != next)
-			BUG();
+		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_OK);
+		BUG_ON(x86_read_percpu(cpu_tlbstate.active_mm) != next);
+
 		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
 			/* We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 97a95fa..bc3b719 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -23,9 +23,7 @@ struct x8664_pda {
 #endif
 	char *irqstackptr;
 	short nodenumber;		/* number of current node (32k max) */
-	short mmu_state;
 	short isidle;
-	struct mm_struct *active_mm;
 } ____cacheline_aligned_in_smp;
 
 extern void pda_init(int);
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0e7bbb5..b344098 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -148,20 +148,17 @@ void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
 
-#ifdef CONFIG_X86_32
 struct tlb_state {
 	struct mm_struct *active_mm;
 	int state;
-	char __cacheline_padding[L1_CACHE_BYTES-8];
 };
 DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
 
-void reset_lazy_tlbstate(void);
-#else
 static inline void reset_lazy_tlbstate(void)
 {
+	x86_write_percpu(cpu_tlbstate.state, 0);
+	x86_write_percpu(cpu_tlbstate.active_mm, &init_mm);
 }
-#endif
 
 #endif	/* SMP */
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index eaf404f..7bdf87f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -880,8 +880,6 @@ void __cpuinit pda_init(int cpu)
 	pda->irqcount = -1;
 	pda->kernelstack = (unsigned long)stack_thread_info() -
 				 PDA_STACKOFFSET + THREAD_SIZE;
-	pda->active_mm = &init_mm;
-	pda->mmu_state = 0;
 
 	if (cpu == 0) {
 		/* others are initialized in smpboot.c */
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index f4049f3..4c151a9 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -4,8 +4,8 @@
 
 #include <asm/tlbflush.h>
 
-DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
-			____cacheline_aligned = { &init_mm, 0, };
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
+			= { &init_mm, 0, };
 
 /* must come after the send_IPI functions above for inlining */
 #include <mach_ipi.h>
@@ -247,11 +247,3 @@ void flush_tlb_all(void)
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
-void reset_lazy_tlbstate(void)
-{
-	int cpu = raw_smp_processor_id();
-
-	per_cpu(cpu_tlbstate, cpu).state = 0;
-	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
-}
-
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index d4c9a00..938549c 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -18,6 +18,9 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_bau.h>
 
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
+			= { &init_mm, 0, };
+
 #include <mach_ipi.h>
 /*
  *	Smarter SMP flushing macros.
@@ -62,9 +65,9 @@ static DEFINE_PER_CPU(union smp_flush_state, flush_state);
  */
 void leave_mm(int cpu)
 {
-	if (read_pda(mmu_state) == TLBSTATE_OK)
+	if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
-	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
+	cpu_clear(cpu, x86_read_percpu(cpu_tlbstate.active_mm)->cpu_vm_mask);
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -142,8 +145,8 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (f->flush_mm == read_pda(active_mm)) {
-		if (read_pda(mmu_state) == TLBSTATE_OK) {
+	if (f->flush_mm == x86_read_percpu(cpu_tlbstate.active_mm)) {
+		if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -274,7 +277,7 @@ static void do_flush_tlb_all(void *info)
 	unsigned long cpu = smp_processor_id();
 
 	__flush_tlb_all();
-	if (read_pda(mmu_state) == TLBSTATE_LAZY)
+	if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(cpu);
 }
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 636ef4c..49bdd72 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1060,11 +1060,7 @@ static void drop_other_mm_ref(void *info)
 	struct mm_struct *mm = info;
 	struct mm_struct *active_mm;
 
-#ifdef CONFIG_X86_64
-	active_mm = read_pda(active_mm);
-#else
-	active_mm = __get_cpu_var(cpu_tlbstate).active_mm;
-#endif
+	active_mm = x86_read_percpu(cpu_tlbstate.active_mm);
 
 	if (active_mm == mm)
 		leave_mm(smp_processor_id());
-- 
1.6.1.rc1


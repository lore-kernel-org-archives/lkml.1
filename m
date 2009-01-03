Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZACEYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZACEYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbZACEXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:23:39 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:46259 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbZACEXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:23:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NyzEzMrKl8Sf66zNNFfwAg9t9cJL/dAvJ1IUp6BRcLgKDQTnGufreVyHCnC8jbXSrb
         +I58QTvdS3JWOVjFVCrLw1tOBFUohKwyrMNg8zZuzgK7ZqIqhe8TGEZMmYo0dZOsC/bb
         mwWN1zCCoopxH9s6S9AQLymvVv3q1llkCRgJI=
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 4/4] x86-64: Move TLB state from PDA to per-cpu and consolidate with 32-bit.
Date: Fri,  2 Jan 2009 23:23:37 -0500
Message-Id: <1230956617-3353-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1230956617-3353-3-git-send-email-brgerst@gmail.com>
References: <73c1f2160901022022r21586980t67e8baf485183ac7@mail.gmail.com>
 <1230956617-3353-1-git-send-email-brgerst@gmail.com>
 <1230956617-3353-2-git-send-email-brgerst@gmail.com>
 <1230956617-3353-3-git-send-email-brgerst@gmail.com>
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
index d039178..2a696d1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -882,8 +882,6 @@ void __cpuinit pda_init(int cpu)
 	pda->irqcount = -1;
 	pda->kernelstack = (unsigned long)stack_thread_info() -
 				 PDA_STACKOFFSET + THREAD_SIZE;
-	pda->active_mm = &init_mm;
-	pda->mmu_state = 0;
 
 	if (cpu == 0) {
 		/* others are initialized in smpboot.c */
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index ce50546..15833ae 100644
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
@@ -246,11 +246,3 @@ void flush_tlb_all(void)
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
index f8be6f1..3bcb78d 100644
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
index 503c240..0d9ed77 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1063,11 +1063,7 @@ static void drop_other_mm_ref(void *info)
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


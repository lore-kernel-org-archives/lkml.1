Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbZATNQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbZATNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZATNPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:15:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:22949 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993AbZATNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:15:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uQ9b3fJVoZZJM5goV3Hvv1Y4XoV2hlrkG5oNO2Kt9iteWwXkxg5Hy+5rfW1wNmVBO7
         8z8nRvtVdjcA1xHDxJOXSUcrp5A/6LqZw5FBD5iz+skF4TT5RgQg7m8T2n2SopkwD678
         iGIQeQaaive4YZUtJUl2Isvq9QRDsU/xM5rTE=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 4/6] x86: Merge mmu_context.h
Date: Tue, 20 Jan 2009 08:15:43 -0500
Message-Id: <1232457345-12366-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/mmu_context.h    |   64 ++++++++++++++++++++++++++++++--
 arch/x86/include/asm/mmu_context_32.h |   55 ----------------------------
 arch/x86/include/asm/mmu_context_64.h |   52 --------------------------
 3 files changed, 60 insertions(+), 111 deletions(-)
 delete mode 100644 arch/x86/include/asm/mmu_context_32.h
 delete mode 100644 arch/x86/include/asm/mmu_context_64.h

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 8aeeb3f..7bf6a72 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -21,11 +21,55 @@ static inline void paravirt_activate_mm(struct mm_struct *prev,
 int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
 void destroy_context(struct mm_struct *mm);
 
-#ifdef CONFIG_X86_32
-# include "mmu_context_32.h"
-#else
-# include "mmu_context_64.h"
+
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
+{
+#ifdef CONFIG_SMP
+	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+		percpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
+#endif
+}
+
+static inline void switch_mm(struct mm_struct *prev,
+			     struct mm_struct *next,
+			     struct task_struct *tsk)
+{
+	int cpu = smp_processor_id();
+
+	if (likely(prev != next)) {
+		/* stop flush ipis for the previous mm */
+		cpu_clear(cpu, prev->cpu_vm_mask);
+#ifdef CONFIG_SMP
+		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		percpu_write(cpu_tlbstate.active_mm, next);
 #endif
+		cpu_set(cpu, next->cpu_vm_mask);
+
+		/* Re-load page tables */
+		load_cr3(next->pgd);
+
+		/*
+		 * load the LDT, if the LDT is different:
+		 */
+		if (unlikely(prev->context.ldt != next->context.ldt))
+			load_LDT_nolock(&next->context);
+	}
+#ifdef CONFIG_SMP
+	else {
+		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
+
+		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
+			/* We were in lazy tlb mode and leave_mm disabled
+			 * tlb flush IPI delivery. We must reload CR3
+			 * to make sure to use no freed page tables.
+			 */
+			load_cr3(next->pgd);
+			load_LDT_nolock(&next->context);
+		}
+	}
+#endif
+}
 
 #define activate_mm(prev, next)			\
 do {						\
@@ -33,5 +77,17 @@ do {						\
 	switch_mm((prev), (next), NULL);	\
 } while (0);
 
+#ifdef CONFIG_X86_32
+#define deactivate_mm(tsk, mm)			\
+do {						\
+	loadsegment(gs, 0)			\
+} while (0)
+#else
+#define deactivate_mm(tsk, mm)			\
+do {						\
+	load_gs_index(0);			\
+	loadsegment(fs, 0);			\
+} while (0)
+#endif
 
 #endif /* _ASM_X86_MMU_CONTEXT_H */
diff --git a/arch/x86/include/asm/mmu_context_32.h b/arch/x86/include/asm/mmu_context_32.h
deleted file mode 100644
index 08b5345..0000000
--- a/arch/x86/include/asm/mmu_context_32.h
+++ /dev/null
@@ -1,55 +0,0 @@
-#ifndef _ASM_X86_MMU_CONTEXT_32_H
-#define _ASM_X86_MMU_CONTEXT_32_H
-
-static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
-{
-#ifdef CONFIG_SMP
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
-		percpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
-#endif
-}
-
-static inline void switch_mm(struct mm_struct *prev,
-			     struct mm_struct *next,
-			     struct task_struct *tsk)
-{
-	int cpu = smp_processor_id();
-
-	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpu_clear(cpu, prev->cpu_vm_mask);
-#ifdef CONFIG_SMP
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		percpu_write(cpu_tlbstate.active_mm, next);
-#endif
-		cpu_set(cpu, next->cpu_vm_mask);
-
-		/* Re-load page tables */
-		load_cr3(next->pgd);
-
-		/*
-		 * load the LDT, if the LDT is different:
-		 */
-		if (unlikely(prev->context.ldt != next->context.ldt))
-			load_LDT_nolock(&next->context);
-	}
-#ifdef CONFIG_SMP
-	else {
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
-
-		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
-			/* We were in lazy tlb mode and leave_mm disabled
-			 * tlb flush IPI delivery. We must reload %cr3.
-			 */
-			load_cr3(next->pgd);
-			load_LDT_nolock(&next->context);
-		}
-	}
-#endif
-}
-
-#define deactivate_mm(tsk, mm)			\
-	asm("movl %0,%%gs": :"r" (0));
-
-#endif /* _ASM_X86_MMU_CONTEXT_32_H */
diff --git a/arch/x86/include/asm/mmu_context_64.h b/arch/x86/include/asm/mmu_context_64.h
deleted file mode 100644
index c457250..0000000
--- a/arch/x86/include/asm/mmu_context_64.h
+++ /dev/null
@@ -1,52 +0,0 @@
-#ifndef _ASM_X86_MMU_CONTEXT_64_H
-#define _ASM_X86_MMU_CONTEXT_64_H
-
-static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
-{
-#ifdef CONFIG_SMP
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
-		percpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
-#endif
-}
-
-static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
-			     struct task_struct *tsk)
-{
-	unsigned cpu = smp_processor_id();
-	if (likely(prev != next)) {
-		/* stop flush ipis for the previous mm */
-		cpu_clear(cpu, prev->cpu_vm_mask);
-#ifdef CONFIG_SMP
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		percpu_write(cpu_tlbstate.active_mm, next);
-#endif
-		cpu_set(cpu, next->cpu_vm_mask);
-		load_cr3(next->pgd);
-
-		if (unlikely(next->context.ldt != prev->context.ldt))
-			load_LDT_nolock(&next->context);
-	}
-#ifdef CONFIG_SMP
-	else {
-		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
-		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
-
-		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
-			/* We were in lazy tlb mode and leave_mm disabled
-			 * tlb flush IPI delivery. We must reload CR3
-			 * to make sure to use no freed page tables.
-			 */
-			load_cr3(next->pgd);
-			load_LDT_nolock(&next->context);
-		}
-	}
-#endif
-}
-
-#define deactivate_mm(tsk, mm)			\
-do {						\
-	load_gs_index(0);			\
-	asm volatile("movl %0,%%fs"::"r"(0));	\
-} while (0)
-
-#endif /* _ASM_X86_MMU_CONTEXT_64_H */
-- 
1.6.1


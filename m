Return-Path: <linux-kernel-owner+w=401wt.eu-S1763929AbZAUIuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763929AbZAUIuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbZAUIqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:38087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbZAUIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:43 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] x86: prepare for tlb merge
Date: Wed, 21 Jan 2009 17:46:16 +0900
Message-Id: <1232527578-1960-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: clean up, ipi vector number reordering for x86_32

Make the following changes to prepare for tlb merge.

* reorder x86_32 ip vectors

* adjust tlb_32.c and tlb_64.c such that their logics coincide exactly
	- on spurious invalidate ipi, tlb_32 acks the irq
	- tlb_64 now has proper memory barriers around clearing
          flush_cpumask (no change in generated code)

* unexport flush_tlb_page from tlb_32.c, there's no user

* use unsigned int for cpu id

* drop unnecessary includes from tlb_64.c

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/irq_vectors.h |   33 ++++++++++++++++-----------------
 arch/x86/kernel/tlb_32.c           |   10 +++++-----
 arch/x86/kernel/tlb_64.c           |   18 +++++++-----------
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index a16a2ab..4ee8f80 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -49,31 +49,30 @@
  *  some of the following vectors are 'rare', they are merged
  *  into a single vector (CALL_FUNCTION_VECTOR) to save vector space.
  *  TLB, reschedule and local APIC vectors are performance-critical.
- *
- *  Vectors 0xf0-0xfa are free (reserved for future Linux use).
  */
 #ifdef CONFIG_X86_32
 
 # define SPURIOUS_APIC_VECTOR		0xff
 # define ERROR_APIC_VECTOR		0xfe
-# define INVALIDATE_TLB_VECTOR		0xfd
-# define RESCHEDULE_VECTOR		0xfc
-# define CALL_FUNCTION_VECTOR		0xfb
-# define CALL_FUNCTION_SINGLE_VECTOR	0xfa
-# define THERMAL_APIC_VECTOR		0xf0
+# define RESCHEDULE_VECTOR		0xfd
+# define CALL_FUNCTION_VECTOR		0xfc
+# define CALL_FUNCTION_SINGLE_VECTOR	0xfb
+# define THERMAL_APIC_VECTOR		0xfa
+/* 0xf1 - 0xf9 : free */
+# define INVALIDATE_TLB_VECTOR		0xf0
 
 #else
 
-#define SPURIOUS_APIC_VECTOR		0xff
-#define ERROR_APIC_VECTOR		0xfe
-#define RESCHEDULE_VECTOR		0xfd
-#define CALL_FUNCTION_VECTOR		0xfc
-#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
-#define THERMAL_APIC_VECTOR		0xfa
-#define THRESHOLD_APIC_VECTOR		0xf9
-#define UV_BAU_MESSAGE			0xf8
-#define INVALIDATE_TLB_VECTOR_END	0xf7
-#define INVALIDATE_TLB_VECTOR_START	0xf0	/* f0-f7 used for TLB flush */
+# define SPURIOUS_APIC_VECTOR		0xff
+# define ERROR_APIC_VECTOR		0xfe
+# define RESCHEDULE_VECTOR		0xfd
+# define CALL_FUNCTION_VECTOR		0xfc
+# define CALL_FUNCTION_SINGLE_VECTOR	0xfb
+# define THERMAL_APIC_VECTOR		0xfa
+# define THRESHOLD_APIC_VECTOR		0xf9
+# define UV_BAU_MESSAGE			0xf8
+# define INVALIDATE_TLB_VECTOR_END	0xf7
+# define INVALIDATE_TLB_VECTOR_START	0xf0	/* f0-f7 used for TLB flush */
 
 #define NUM_INVALIDATE_TLB_VECTORS	8
 
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index abf0808..93fcb05 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -84,13 +84,15 @@ EXPORT_SYMBOL_GPL(leave_mm);
  *
  * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
  * 2) Leave the mm if we are in the lazy tlb mode.
+ *
+ * Interrupts are disabled.
  */
 
 void smp_invalidate_interrupt(struct pt_regs *regs)
 {
-	unsigned long cpu;
+	unsigned int cpu;
 
-	cpu = get_cpu();
+	cpu = smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, flush_cpumask))
 		goto out;
@@ -112,12 +114,11 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		} else
 			leave_mm(cpu);
 	}
+out:
 	ack_APIC_irq();
 	smp_mb__before_clear_bit();
 	cpumask_clear_cpu(cpu, flush_cpumask);
 	smp_mb__after_clear_bit();
-out:
-	put_cpu_no_resched();
 	inc_irq_stat(irq_tlb_count);
 }
 
@@ -215,7 +216,6 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 		flush_tlb_others(&mm->cpu_vm_mask, mm, va);
 	preempt_enable();
 }
-EXPORT_SYMBOL(flush_tlb_page);
 
 static void do_flush_tlb_all(void *info)
 {
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index b8bed84..19ac661 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -1,20 +1,14 @@
 #include <linux/init.h>
 
 #include <linux/mm.h>
-#include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/smp.h>
-#include <linux/kernel_stat.h>
-#include <linux/mc146818rtc.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 
-#include <asm/mtrr.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
-#include <asm/proto.h>
-#include <asm/apicdef.h>
-#include <asm/idle.h>
+#include <asm/apic.h>
 #include <asm/uv/uv.h>
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
@@ -121,8 +115,8 @@ EXPORT_SYMBOL_GPL(leave_mm);
 
 asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 {
-	int cpu;
-	int sender;
+	unsigned int cpu;
+	unsigned int sender;
 	union smp_flush_state *f;
 
 	cpu = smp_processor_id();
@@ -155,14 +149,16 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 	}
 out:
 	ack_APIC_irq();
+	smp_mb__before_clear_bit();
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
+	smp_mb__after_clear_bit();
 	inc_irq_stat(irq_tlb_count);
 }
 
 static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 				 struct mm_struct *mm, unsigned long va)
 {
-	int sender;
+	unsigned int sender;
 	union smp_flush_state *f;
 
 	/* Caller has disabled preemption */
-- 
1.6.0.2


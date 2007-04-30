Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbXD3Kax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbXD3Kax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXD3K2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:45 -0400
Received: from mail.suse.de ([195.135.220.2]:51187 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbXD3K1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:49 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [15/40] i386: add flush_tlb_others paravirt_op
Message-Id: <20070430102748.B5E00151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
This patch adds a pv_op for flush_tlb_others.  Linux running on native
hardware uses cross-CPU IPIs to flush the TLB on any CPU which may
have a particular mm's pagetable entries cached in its TLB.  This is
inefficient in a paravirtualized environment, since the hypervisor
knows which real CPUs actually contain cached mappings, which may be a
small subset of a guest's VCPUs.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/paravirt.c |    1 +
 arch/i386/kernel/smp.c      |   13 +++++++------
 include/asm-i386/paravirt.h |    9 +++++++++
 include/asm-i386/tlbflush.h |   19 +++++++++++++++++--
 4 files changed, 34 insertions(+), 8 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -300,6 +300,7 @@ struct paravirt_ops paravirt_ops = {
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
+	.flush_tlb_others = native_flush_tlb_others,
 
 	.map_pt_hook = paravirt_nop,
 
Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -256,7 +256,6 @@ static cpumask_t flush_cpumask;
 static struct mm_struct * flush_mm;
 static unsigned long flush_va;
 static DEFINE_SPINLOCK(tlbstate_lock);
-#define FLUSH_ALL	0xffffffff
 
 /*
  * We cannot call mmdrop() because we are in interrupt context, 
@@ -338,7 +337,7 @@ fastcall void smp_invalidate_interrupt(s
 		 
 	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
 		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
-			if (flush_va == FLUSH_ALL)
+			if (flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
 				__flush_tlb_one(flush_va);
@@ -353,9 +352,11 @@ out:
 	put_cpu_no_resched();
 }
 
-static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
-						unsigned long va)
+void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
+			     unsigned long va)
 {
+	cpumask_t cpumask = *cpumaskp;
+
 	/*
 	 * A couple of (to be removed) sanity checks:
 	 *
@@ -417,7 +418,7 @@ void flush_tlb_current_task(void)
 
 	local_flush_tlb();
 	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
@@ -436,7 +437,7 @@ void flush_tlb_mm (struct mm_struct * mm
 			leave_mm(smp_processor_id());
 	}
 	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
 
 	preempt_enable();
 }
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -15,6 +15,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
+#include <linux/cpumask.h>
 
 struct thread_struct;
 struct Xgt_desc_struct;
@@ -165,6 +166,8 @@ struct paravirt_ops
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(unsigned long addr);
+	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
+				 unsigned long va);
 
 	void (*map_pt_hook)(int type, pte_t *va, u32 pfn);
 
@@ -853,6 +856,12 @@ static inline void __flush_tlb_single(un
 	PVOP_VCALL1(flush_tlb_single, addr);
 }
 
+static inline void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+				    unsigned long va)
+{
+	PVOP_VCALL3(flush_tlb_others, &cpumask, mm, va);
+}
+
 static inline void paravirt_map_pt_hook(int type, pte_t *va, u32 pfn)
 {
 	PVOP_VCALL3(map_pt_hook, type, va, pfn);
Index: linux/include/asm-i386/tlbflush.h
===================================================================
--- linux.orig/include/asm-i386/tlbflush.h
+++ linux/include/asm-i386/tlbflush.h
@@ -79,11 +79,15 @@
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
  *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
+ *  - flush_tlb_others(cpumask, mm, va) flushes a TLBs on other cpus
  *
  * ..but the i386 has somewhat limited tlb flushing capabilities,
  * and page-granular flushes are available only on i486 and up.
  */
 
+#define TLB_FLUSH_ALL	0xffffffff
+
+
 #ifndef CONFIG_SMP
 
 #define flush_tlb() __flush_tlb()
@@ -110,7 +114,12 @@ static inline void flush_tlb_range(struc
 		__flush_tlb();
 }
 
-#else
+static inline void native_flush_tlb_others(const cpumask_t *cpumask,
+					   struct mm_struct *mm, unsigned long va)
+{
+}
+
+#else  /* SMP */
 
 #include <asm/smp.h>
 
@@ -129,6 +138,9 @@ static inline void flush_tlb_range(struc
 	flush_tlb_mm(vma->vm_mm);
 }
 
+void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
+			     unsigned long va);
+
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
 
@@ -139,8 +151,11 @@ struct tlb_state
 	char __cacheline_padding[L1_CACHE_BYTES-8];
 };
 DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
+#endif	/* SMP */
 
-
+#ifndef CONFIG_PARAVIRT
+#define flush_tlb_others(mask, mm, va)		\
+	native_flush_tlb_others(&mask, mm, va)
 #endif
 
 #define flush_tlb_kernel_range(start, end) flush_tlb_all()

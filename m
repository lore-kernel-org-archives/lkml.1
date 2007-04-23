Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXDWXNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXDWXNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbXDWXHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:07:35 -0400
Received: from 61.sub-75-208-107.myvzw.com ([75.208.107.61]:38854 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754488AbXDWXHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:07:12 -0400
Message-Id: <20070423215711.742425039@goop.org>
References: <20070423215638.563901986@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 14:56:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/25] xen: xen: lazy-mmu operations
Content-Disposition: inline; filename=xen-lazy-mmu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the lazy-mmu hooks to batch mmu operations where
possible.  This is primarily useful for batching operations applied to
active pagetables, which happens during mprotect, munmap, mremap and
the like (mmap does not do bulk pagetable operations, so it isn't
helped).

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/enlighten.c  |   56 +++++++++++++++++++++++++++-----------------
 arch/i386/xen/mmu.c        |   56 ++++++++++++++++++++++++++++++++------------
 arch/i386/xen/multicalls.c |    4 +--
 3 files changed, 78 insertions(+), 38 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -451,28 +451,38 @@ static void xen_apic_write(unsigned long
 
 static void xen_flush_tlb(void)
 {
-	struct mmuext_op op;
-
-	op.cmd = MMUEXT_TLB_FLUSH_LOCAL;
-	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
-		BUG();
+	struct mmuext_op *op;
+	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+
+	op = mcs.args;
+	op->cmd = MMUEXT_TLB_FLUSH_LOCAL;
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
 static void xen_flush_tlb_single(unsigned long addr)
 {
-	struct mmuext_op op;
-
-	op.cmd = MMUEXT_INVLPG_LOCAL;
-	op.arg1.linear_addr = addr & PAGE_MASK;
-	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
-		BUG();
+	struct mmuext_op *op;
+	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+
+	op = mcs.args;
+	op->cmd = MMUEXT_INVLPG_LOCAL;
+	op->arg1.linear_addr = addr & PAGE_MASK;
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
 static void xen_flush_tlb_others(const cpumask_t *cpus, struct mm_struct *mm,
 				 unsigned long va)
 {
-	struct mmuext_op op;
+	struct {
+		struct mmuext_op op;
+		cpumask_t mask;
+	} *args;
 	cpumask_t cpumask = *cpus;
+	struct multicall_space mcs;
 
 	/*
 	 * A couple of (to be removed) sanity checks:
@@ -489,17 +499,21 @@ static void xen_flush_tlb_others(const c
 	if (cpus_empty(cpumask))
 		return;
 
+	mcs = xen_mc_entry(sizeof(*args));
+	args = mcs.args;
+	args->mask = cpumask;
+	args->op.arg2.vcpumask = &args->mask;
+
 	if (va == TLB_FLUSH_ALL) {
-		op.cmd = MMUEXT_TLB_FLUSH_MULTI;
-		op.arg2.vcpumask = (void *)cpus;
+		args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
 	} else {
-		op.cmd = MMUEXT_INVLPG_MULTI;
-		op.arg1.linear_addr = va;
-		op.arg2.vcpumask = (void *)cpus;
-	}
-
-	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
-		BUG();
+		args->op.cmd = MMUEXT_INVLPG_MULTI;
+		args->op.arg1.linear_addr = va;
+	}
+
+	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
 static unsigned long xen_read_cr2(void)
===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -56,12 +56,20 @@ void make_lowmem_page_readwrite(void *va
 
 void xen_set_pmd(pmd_t *ptr, pmd_t val)
 {
-	struct mmu_update u;
-
-	u.ptr = virt_to_machine(ptr).maddr;
-	u.val = pmd_val_ma(val);
-	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
-		BUG();
+	struct multicall_space mcs;
+	struct mmu_update *u;
+
+	preempt_disable();
+
+	mcs = xen_mc_entry(sizeof(*u));
+	u = mcs.args;
+	u->ptr = virt_to_machine(ptr).maddr;
+	u->val = pmd_val_ma(val);
+	MULTI_mmu_update(mcs.mc, u, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
 }
 
 /*
@@ -104,20 +112,38 @@ void xen_set_pte_at(struct mm_struct *mm
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
-	if ((mm != current->mm && mm != &init_mm) ||
-	    HYPERVISOR_update_va_mapping(addr, pteval, 0) != 0)
-		xen_set_pte(ptep, pteval);
+	if (mm == current->mm || mm == &init_mm) {
+		if (xen_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
+			struct multicall_space mcs;
+			mcs = xen_mc_entry(0);
+
+			MULTI_update_va_mapping(mcs.mc, addr, pteval, 0);
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
+			return;
+		} else
+			if (HYPERVISOR_update_va_mapping(addr, pteval, 0) == 0)
+				return;
+	}
+	xen_set_pte(ptep, pteval);
 }
 
 #ifdef CONFIG_X86_PAE
 void xen_set_pud(pud_t *ptr, pud_t val)
 {
-	struct mmu_update u;
-
-	u.ptr = virt_to_machine(ptr).maddr;
-	u.val = pud_val_ma(val);
-	if (HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF) < 0)
-		BUG();
+	struct multicall_space mcs;
+	struct mmu_update *u;
+
+	preempt_disable();
+
+	mcs = xen_mc_entry(sizeof(*u));
+	u = mcs.args;
+	u->ptr = virt_to_machine(ptr).maddr;
+	u->val = pud_val_ma(val);
+	MULTI_mmu_update(mcs.mc, u, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
 }
 
 void xen_set_pte(pte_t *ptep, pte_t pte)
===================================================================
--- a/arch/i386/xen/multicalls.c
+++ b/arch/i386/xen/multicalls.c
@@ -5,8 +5,8 @@
 
 #include "multicalls.h"
 
-#define MC_BATCH	8
-#define MC_ARGS		(MC_BATCH * 32 / sizeof(u64))
+#define MC_BATCH	32
+#define MC_ARGS		(MC_BATCH * 16 / sizeof(u64))
 
 struct mc_buffer {
 	struct multicall_entry entries[MC_BATCH];

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbYDCTjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbYDCTjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760885AbYDCTdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:16 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53042
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 22/35] x86: KVM guest: hypercall based pte updates and TLB flushes
Date: Thu,  3 Apr 2008 22:32:37 +0300
Message-Id: <1207251170-5013-23-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Hypercall based pte updates are faster than faults, and also allow use
of the lazy MMU mode to batch operations.

Don't report the feature if two dimensional paging is enabled.

[avi:
 - guest/host split
 - fix 32-bit truncation issues
 - adjust to mmu_op]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/kvm.c |  137 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 137 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a8e36da..1bb6e97 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -25,6 +25,7 @@
 #include <linux/kvm_para.h>
 #include <linux/cpu.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 
 /*
  * No need for any "IO delay" on KVM
@@ -33,6 +34,122 @@ static void kvm_io_delay(void)
 {
 }
 
+static void kvm_mmu_op(void *buffer, unsigned len)
+{
+	int r;
+	unsigned long a1, a2;
+
+	do {
+		a1 = __pa(buffer);
+		a2 = 0;   /* on i386 __pa() always returns <4G */
+		r = kvm_hypercall3(KVM_HC_MMU_OP, len, a1, a2);
+		buffer += r;
+		len -= r;
+	} while (len);
+}
+
+static void kvm_mmu_write(void *dest, u64 val)
+{
+	__u64 pte_phys;
+	struct kvm_mmu_op_write_pte wpte;
+
+#ifdef CONFIG_HIGHPTE
+	struct page *page;
+	unsigned long dst = (unsigned long) dest;
+
+	page = kmap_atomic_to_page(dest);
+	pte_phys = page_to_pfn(page);
+	pte_phys <<= PAGE_SHIFT;
+	pte_phys += (dst & ~(PAGE_MASK));
+#else
+	pte_phys = (unsigned long)__pa(dest);
+#endif
+	wpte.header.op = KVM_MMU_OP_WRITE_PTE;
+	wpte.pte_val = val;
+	wpte.pte_phys = pte_phys;
+
+	kvm_mmu_op(&wpte, sizeof wpte);
+}
+
+/*
+ * We only need to hook operations that are MMU writes.  We hook these so that
+ * we can use lazy MMU mode to batch these operations.  We could probably
+ * improve the performance of the host code if we used some of the information
+ * here to simplify processing of batched writes.
+ */
+static void kvm_set_pte(pte_t *ptep, pte_t pte)
+{
+	kvm_mmu_write(ptep, pte_val(pte));
+}
+
+static void kvm_set_pte_at(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep, pte_t pte)
+{
+	kvm_mmu_write(ptep, pte_val(pte));
+}
+
+static void kvm_set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	kvm_mmu_write(pmdp, pmd_val(pmd));
+}
+
+#if PAGETABLE_LEVELS >= 3
+#ifdef CONFIG_X86_PAE
+static void kvm_set_pte_atomic(pte_t *ptep, pte_t pte)
+{
+	kvm_mmu_write(ptep, pte_val(pte));
+}
+
+static void kvm_set_pte_present(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, pte_t pte)
+{
+	kvm_mmu_write(ptep, pte_val(pte));
+}
+
+static void kvm_pte_clear(struct mm_struct *mm,
+			  unsigned long addr, pte_t *ptep)
+{
+	kvm_mmu_write(ptep, 0);
+}
+
+static void kvm_pmd_clear(pmd_t *pmdp)
+{
+	kvm_mmu_write(pmdp, 0);
+}
+#endif
+
+static void kvm_set_pud(pud_t *pudp, pud_t pud)
+{
+	kvm_mmu_write(pudp, pud_val(pud));
+}
+
+#if PAGETABLE_LEVELS == 4
+static void kvm_set_pgd(pgd_t *pgdp, pgd_t pgd)
+{
+	kvm_mmu_write(pgdp, pgd_val(pgd));
+}
+#endif
+#endif /* PAGETABLE_LEVELS >= 3 */
+
+static void kvm_flush_tlb(void)
+{
+	struct kvm_mmu_op_flush_tlb ftlb = {
+		.header.op = KVM_MMU_OP_FLUSH_TLB,
+	};
+
+	kvm_mmu_op(&ftlb, sizeof ftlb);
+}
+
+static void kvm_release_pt(u32 pfn)
+{
+	struct kvm_mmu_op_release_pt rpt = {
+		.header.op = KVM_MMU_OP_RELEASE_PT,
+		.pt_phys = (u64)pfn << PAGE_SHIFT,
+	};
+
+	kvm_mmu_op(&rpt, sizeof rpt);
+}
+
 static void paravirt_ops_setup(void)
 {
 	pv_info.name = "KVM";
@@ -41,6 +158,26 @@ static void paravirt_ops_setup(void)
 	if (kvm_para_has_feature(KVM_FEATURE_NOP_IO_DELAY))
 		pv_cpu_ops.io_delay = kvm_io_delay;
 
+	if (kvm_para_has_feature(KVM_FEATURE_MMU_OP)) {
+		pv_mmu_ops.set_pte = kvm_set_pte;
+		pv_mmu_ops.set_pte_at = kvm_set_pte_at;
+		pv_mmu_ops.set_pmd = kvm_set_pmd;
+#if PAGETABLE_LEVELS >= 3
+#ifdef CONFIG_X86_PAE
+		pv_mmu_ops.set_pte_atomic = kvm_set_pte_atomic;
+		pv_mmu_ops.set_pte_present = kvm_set_pte_present;
+		pv_mmu_ops.pte_clear = kvm_pte_clear;
+		pv_mmu_ops.pmd_clear = kvm_pmd_clear;
+#endif
+		pv_mmu_ops.set_pud = kvm_set_pud;
+#if PAGETABLE_LEVELS == 4
+		pv_mmu_ops.set_pgd = kvm_set_pgd;
+#endif
+#endif
+		pv_mmu_ops.flush_tlb_user = kvm_flush_tlb;
+		pv_mmu_ops.release_pt = kvm_release_pt;
+		pv_mmu_ops.release_pd = kvm_release_pt;
+	}
 }
 
 void __init kvm_guest_init(void)
-- 
1.5.4.5


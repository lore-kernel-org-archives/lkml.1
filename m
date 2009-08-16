Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZHPJeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZHPJeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZHPJcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45369 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/48] KVM: Cache pdptrs
Date: Sun, 16 Aug 2009 12:29:48 +0300
Message-Id: <1250415008-17175-29-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reloading the pdptrs on every entry and exit (vmcs writes on vmx,
guest memory access on svm) extract them on demand.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++++
 arch/x86/kvm/kvm_cache_regs.h   |    9 +++++++++
 arch/x86/kvm/mmu.c              |    7 +++++--
 arch/x86/kvm/paging_tmpl.h      |    2 +-
 arch/x86/kvm/svm.c              |   24 ++++++++++++++++++------
 arch/x86/kvm/vmx.c              |   22 ++++++++++++++++++----
 arch/x86/kvm/x86.c              |    8 ++++++++
 7 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 81c68f6..1cc901e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -120,6 +120,10 @@ enum kvm_reg {
 	NR_VCPU_REGS
 };
 
+enum kvm_reg_ex {
+	VCPU_EXREG_PDPTR = NR_VCPU_REGS,
+};
+
 enum {
 	VCPU_SREG_ES,
 	VCPU_SREG_CS,
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 1ff819d..7bcc5b6 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -29,4 +29,13 @@ static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
 	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
 }
 
+static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
+{
+	if (!test_bit(VCPU_EXREG_PDPTR,
+		      (unsigned long *)&vcpu->arch.regs_avail))
+		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_PDPTR);
+
+	return vcpu->arch.pdptrs[index];
+}
+
 #endif
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0ef5bb2..8ee67e3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -18,6 +18,7 @@
  */
 
 #include "mmu.h"
+#include "kvm_cache_regs.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -1954,6 +1955,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 	gfn_t root_gfn;
 	struct kvm_mmu_page *sp;
 	int direct = 0;
+	u64 pdptr;
 
 	root_gfn = vcpu->arch.cr3 >> PAGE_SHIFT;
 
@@ -1981,11 +1983,12 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 
 		ASSERT(!VALID_PAGE(root));
 		if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
-			if (!is_present_pte(vcpu->arch.pdptrs[i])) {
+			pdptr = kvm_pdptr_read(vcpu, i);
+			if (!is_present_pte(pdptr)) {
 				vcpu->arch.mmu.pae_root[i] = 0;
 				continue;
 			}
-			root_gfn = vcpu->arch.pdptrs[i] >> PAGE_SHIFT;
+			root_gfn = pdptr >> PAGE_SHIFT;
 		} else if (vcpu->arch.mmu.root_level == 0)
 			root_gfn = 0;
 		if (mmu_check_root(vcpu, root_gfn))
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 67785f6..4cb1dbf 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -131,7 +131,7 @@ walk:
 	pte = vcpu->arch.cr3;
 #if PTTYPE == 64
 	if (!is_long_mode(vcpu)) {
-		pte = vcpu->arch.pdptrs[(addr >> 30) & 3];
+		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
 		if (!is_present_pte(pte))
 			goto not_present;
 		--walker->level;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 14a98ab..0710e45 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -780,6 +780,18 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	to_svm(vcpu)->vmcb->save.rflags = rflags;
 }
 
+static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+{
+	switch (reg) {
+	case VCPU_EXREG_PDPTR:
+		BUG_ON(!npt_enabled);
+		load_pdptrs(vcpu, vcpu->arch.cr3);
+		break;
+	default:
+		BUG();
+	}
+}
+
 static void svm_set_vintr(struct vcpu_svm *svm)
 {
 	svm->vmcb->control.intercept |= 1ULL << INTERCEPT_VINTR;
@@ -2286,12 +2298,6 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		}
 		vcpu->arch.cr0 = svm->vmcb->save.cr0;
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
-		if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
-			if (!load_pdptrs(vcpu, vcpu->arch.cr3)) {
-				kvm_inject_gp(vcpu, 0);
-				return 1;
-			}
-		}
 		if (mmu_reload) {
 			kvm_mmu_reset_context(vcpu);
 			kvm_mmu_load(vcpu);
@@ -2642,6 +2648,11 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	svm->next_rip = 0;
 
+	if (npt_enabled) {
+		vcpu->arch.regs_avail &= ~(1 << VCPU_EXREG_PDPTR);
+		vcpu->arch.regs_dirty &= ~(1 << VCPU_EXREG_PDPTR);
+	}
+
 	svm_complete_interrupts(svm);
 }
 
@@ -2750,6 +2761,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_gdt = svm_set_gdt,
 	.get_dr = svm_get_dr,
 	.set_dr = svm_set_dr,
+	.cache_reg = svm_cache_reg,
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 752465f..d726dec 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -161,6 +161,8 @@ static struct kvm_vmx_segment_field {
 	VMX_SEGMENT_FIELD(LDTR),
 };
 
+static void ept_save_pdptrs(struct kvm_vcpu *vcpu);
+
 /*
  * Keep MSR_K6_STAR at the end, as setup_msrs() will try to optimize it
  * away by decrementing the array size.
@@ -1047,6 +1049,10 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	case VCPU_REGS_RIP:
 		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
 		break;
+	case VCPU_EXREG_PDPTR:
+		if (enable_ept)
+			ept_save_pdptrs(vcpu);
+		break;
 	default:
 		break;
 	}
@@ -1546,6 +1552,10 @@ static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 
 static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 {
+	if (!test_bit(VCPU_EXREG_PDPTR,
+		      (unsigned long *)&vcpu->arch.regs_dirty))
+		return;
+
 	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
 		vmcs_write64(GUEST_PDPTR0, vcpu->arch.pdptrs[0]);
 		vmcs_write64(GUEST_PDPTR1, vcpu->arch.pdptrs[1]);
@@ -1562,6 +1572,11 @@ static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 		vcpu->arch.pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
 		vcpu->arch.pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
 	}
+
+	__set_bit(VCPU_EXREG_PDPTR,
+		  (unsigned long *)&vcpu->arch.regs_avail);
+	__set_bit(VCPU_EXREG_PDPTR,
+		  (unsigned long *)&vcpu->arch.regs_dirty);
 }
 
 static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
@@ -3255,10 +3270,8 @@ static int vmx_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 
 	/* Access CR3 don't cause VMExit in paging mode, so we need
 	 * to sync with guest real CR3. */
-	if (enable_ept && is_paging(vcpu)) {
+	if (enable_ept && is_paging(vcpu))
 		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-		ept_save_pdptrs(vcpu);
-	}
 
 	if (unlikely(vmx->fail)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
@@ -3567,7 +3580,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 	      );
 
-	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP));
+	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
+				  | (1 << VCPU_EXREG_PDPTR));
 	vcpu->arch.regs_dirty = 0;
 
 	get_debugreg(vcpu->arch.dr6, 6);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75e9df0..2ad8c97 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -246,6 +246,10 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	ret = 1;
 
 	memcpy(vcpu->arch.pdptrs, pdpte, sizeof(vcpu->arch.pdptrs));
+	__set_bit(VCPU_EXREG_PDPTR,
+		  (unsigned long *)&vcpu->arch.regs_avail);
+	__set_bit(VCPU_EXREG_PDPTR,
+		  (unsigned long *)&vcpu->arch.regs_dirty);
 out:
 
 	return ret;
@@ -261,6 +265,10 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	if (is_long_mode(vcpu) || !is_pae(vcpu))
 		return false;
 
+	if (!test_bit(VCPU_EXREG_PDPTR,
+		      (unsigned long *)&vcpu->arch.regs_avail))
+		return true;
+
 	r = kvm_read_guest(vcpu->kvm, vcpu->arch.cr3 & ~31u, pdpte, sizeof(pdpte));
 	if (r < 0)
 		goto out;
-- 
1.6.3.3


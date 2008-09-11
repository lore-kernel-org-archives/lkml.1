Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYIKLUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYIKLUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYIKLUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:20:43 -0400
Received: from il.qumranet.com ([212.179.150.194]:20233 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbYIKLUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:20:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.27-rc6
Date: Thu, 11 Sep 2008 14:20:40 +0300
Message-Id: <1221132040-22598-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, the trio of patches in

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates/2.6.27

fix regressions in the kvm npt and ept support code.  Please pull.

Shortlog, diffstat, and diff below.

Joerg Roedel (2):
      KVM: SVM: fix random segfaults with NPT enabled
      KVM: SVM: fix guest global tlb flushes with NPT

Sheng Yang (1):
      KVM: VMX: Always return old for clear_flush_young() when using EPT

 arch/x86/kvm/mmu.c |    4 ++++
 arch/x86/kvm/svm.c |   12 ++++++++++++
 arch/x86/kvm/vmx.c |    3 +--
 arch/x86/kvm/vmx.h |    2 --
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0bfe2bd..3da2508 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -711,6 +711,10 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp)
 	u64 *spte;
 	int young = 0;
 
+	/* always return old for EPT */
+	if (!shadow_accessed_mask)
+		return 0;
+
 	spte = rmap_next(kvm, rmapp, NULL);
 	while (spte) {
 		int _young;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e2ee264..8233b86 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -62,6 +62,7 @@ static int npt = 1;
 module_param(npt, int, S_IRUGO);
 
 static void kvm_reput_irq(struct vcpu_svm *svm);
+static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
@@ -878,6 +879,10 @@ set:
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long host_cr4_mce = read_cr4() & X86_CR4_MCE;
+	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
+
+	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
+		force_new_asid(vcpu);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
@@ -1027,6 +1032,13 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 		KVMTRACE_3D(TDP_FAULT, &svm->vcpu, error_code,
 			    (u32)fault_address, (u32)(fault_address >> 32),
 			    handler);
+	/*
+	 * FIXME: Tis shouldn't be necessary here, but there is a flush
+	 * missing in the MMU code. Until we find this bug, flush the
+	 * complete TLB here on an NPF
+	 */
+	if (npt_enabled)
+		svm_flush_tlb(&svm->vcpu);
 
 	if (event_injection)
 		kvm_mmu_unprotect_page_virt(&svm->vcpu, fault_address);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2a69773..7041cc5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3301,8 +3301,7 @@ static int __init vmx_init(void)
 		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
 			VMX_EPT_WRITABLE_MASK |
 			VMX_EPT_DEFAULT_MT << VMX_EPT_MT_EPTE_SHIFT);
-		kvm_mmu_set_mask_ptes(0ull, VMX_EPT_FAKE_ACCESSED_MASK,
-				VMX_EPT_FAKE_DIRTY_MASK, 0ull,
+		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
 				VMX_EPT_EXECUTABLE_MASK);
 		kvm_enable_tdp();
 	} else
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 425a134..23e8373 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -370,8 +370,6 @@ enum vmcs_field {
 #define VMX_EPT_READABLE_MASK			0x1ull
 #define VMX_EPT_WRITABLE_MASK			0x2ull
 #define VMX_EPT_EXECUTABLE_MASK			0x4ull
-#define VMX_EPT_FAKE_ACCESSED_MASK		(1ull << 62)
-#define VMX_EPT_FAKE_DIRTY_MASK			(1ull << 63)
 
 #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
 

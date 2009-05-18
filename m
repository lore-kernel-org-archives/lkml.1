Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbZERJjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbZERJjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZERJYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38440 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbZERJXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:12 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 41/43] KVM: VMX: Fold vm_need_ept() into callers
Date: Mon, 18 May 2009 12:23:03 +0300
Message-Id: <1242638585-18470-42-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2f65120..da6461d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -263,11 +263,6 @@ static inline int cpu_has_vmx_ept(void)
 		SECONDARY_EXEC_ENABLE_EPT);
 }
 
-static inline int vm_need_ept(void)
-{
-	return enable_ept;
-}
-
 static inline int vm_need_virtualize_apic_accesses(struct kvm *kvm)
 {
 	return ((cpu_has_vmx_virtualize_apic_accesses()) &&
@@ -382,7 +377,7 @@ static inline void ept_sync_global(void)
 
 static inline void ept_sync_context(u64 eptp)
 {
-	if (vm_need_ept()) {
+	if (enable_ept) {
 		if (cpu_has_vmx_invept_context())
 			__invept(VMX_EPT_EXTENT_CONTEXT, eptp, 0);
 		else
@@ -392,7 +387,7 @@ static inline void ept_sync_context(u64 eptp)
 
 static inline void ept_sync_individual_addr(u64 eptp, gpa_t gpa)
 {
-	if (vm_need_ept()) {
+	if (enable_ept) {
 		if (cpu_has_vmx_invept_individual_addr())
 			__invept(VMX_EPT_EXTENT_INDIVIDUAL_ADDR,
 					eptp, gpa);
@@ -491,7 +486,7 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 	}
 	if (vcpu->arch.rmode.active)
 		eb = ~0;
-	if (vm_need_ept())
+	if (enable_ept)
 		eb &= ~(1u << PF_VECTOR); /* bypass_guest_pf = 0 */
 	vmcs_write32(EXCEPTION_BITMAP, eb);
 }
@@ -1502,7 +1497,7 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	vpid_sync_vcpu_all(to_vmx(vcpu));
-	if (vm_need_ept())
+	if (enable_ept)
 		ept_sync_context(construct_eptp(vcpu->arch.mmu.root_hpa));
 }
 
@@ -1587,7 +1582,7 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 #endif
 
-	if (vm_need_ept())
+	if (enable_ept)
 		ept_update_paging_mode_cr0(&hw_cr0, cr0, vcpu);
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
@@ -1616,7 +1611,7 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	u64 eptp;
 
 	guest_cr3 = cr3;
-	if (vm_need_ept()) {
+	if (enable_ept) {
 		eptp = construct_eptp(cr3);
 		vmcs_write64(EPT_POINTER, eptp);
 		ept_sync_context(eptp);
@@ -1637,7 +1632,7 @@ static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		    KVM_RMODE_VM_CR4_ALWAYS_ON : KVM_PMODE_VM_CR4_ALWAYS_ON);
 
 	vcpu->arch.cr4 = cr4;
-	if (vm_need_ept())
+	if (enable_ept)
 		ept_update_paging_mode_cr4(&hw_cr4, vcpu);
 
 	vmcs_writel(CR4_READ_SHADOW, cr4);
@@ -1999,7 +1994,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	pfn_t identity_map_pfn;
 	u32 tmp;
 
-	if (!vm_need_ept())
+	if (!enable_ept)
 		return 1;
 	if (unlikely(!kvm->arch.ept_identity_pagetable)) {
 		printk(KERN_ERR "EPT: identity-mapping pagetable "
@@ -2163,7 +2158,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 				CPU_BASED_CR8_LOAD_EXITING;
 #endif
 	}
-	if (!vm_need_ept())
+	if (!enable_ept)
 		exec_control |= CPU_BASED_CR3_STORE_EXITING |
 				CPU_BASED_CR3_LOAD_EXITING  |
 				CPU_BASED_INVLPG_EXITING;
@@ -2176,7 +2171,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 				~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
 		if (vmx->vpid == 0)
 			exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
-		if (!vm_need_ept())
+		if (!enable_ept)
 			exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
 	}
@@ -2637,7 +2632,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	if (is_page_fault(intr_info)) {
 		/* EPT won't cause page fault directly */
-		if (vm_need_ept())
+		if (enable_ept)
 			BUG();
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
 		KVMTRACE_3D(PAGE_FAULT, vcpu, error_code, (u32)cr2,
@@ -3187,7 +3182,7 @@ static int vmx_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 
 	/* Access CR3 don't cause VMExit in paging mode, so we need
 	 * to sync with guest real CR3. */
-	if (vm_need_ept() && is_paging(vcpu)) {
+	if (enable_ept && is_paging(vcpu)) {
 		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
 		ept_load_pdptrs(vcpu);
 	}
@@ -3602,7 +3597,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 		if (alloc_apic_access_page(kvm) != 0)
 			goto free_vmcs;
 
-	if (vm_need_ept())
+	if (enable_ept)
 		if (alloc_identity_pagetable(kvm) != 0)
 			goto free_vmcs;
 
@@ -3753,7 +3748,7 @@ static int __init vmx_init(void)
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
 
-	if (vm_need_ept()) {
+	if (enable_ept) {
 		bypass_guest_pf = 0;
 		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
 			VMX_EPT_WRITABLE_MASK);
-- 
1.6.0.6


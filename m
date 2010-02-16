Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab0BPKgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:36:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/38] KVM: Rename vcpu->shadow_efer to efer
Date: Tue, 16 Feb 2010 12:35:16 +0200
Message-Id: <1266316536-28936-19-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of the other registers have the shadow_ prefix.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |    2 +-
 arch/x86/kvm/svm.c              |   12 ++++++------
 arch/x86/kvm/vmx.c              |   14 +++++++-------
 arch/x86/kvm/x86.c              |   14 +++++++-------
 arch/x86/kvm/x86.h              |    2 +-
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7ebf9fe..1522337 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -277,7 +277,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr8;
 	u32 hflags;
 	u64 pdptrs[4]; /* pae */
-	u64 shadow_efer;
+	u64 efer;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
 	int32_t apic_arb_prio;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6f7158f..599c422 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -237,7 +237,7 @@ static int is_cpuid_PSE36(void)
 
 static int is_nx(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.shadow_efer & EFER_NX;
+	return vcpu->arch.efer & EFER_NX;
 }
 
 static int is_shadow_present_pte(u64 pte)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 800208a..9596cc8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -231,7 +231,7 @@ static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		efer &= ~EFER_LME;
 
 	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
-	vcpu->arch.shadow_efer = efer;
+	vcpu->arch.efer = efer;
 }
 
 static void svm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
@@ -996,14 +996,14 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->arch.shadow_efer & EFER_LME) {
+	if (vcpu->arch.efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
-			vcpu->arch.shadow_efer |= EFER_LMA;
+			vcpu->arch.efer |= EFER_LMA;
 			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
 		}
 
 		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG)) {
-			vcpu->arch.shadow_efer &= ~EFER_LMA;
+			vcpu->arch.efer &= ~EFER_LMA;
 			svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
 		}
 	}
@@ -1361,7 +1361,7 @@ static int vmmcall_interception(struct vcpu_svm *svm)
 
 static int nested_svm_check_permissions(struct vcpu_svm *svm)
 {
-	if (!(svm->vcpu.arch.shadow_efer & EFER_SVME)
+	if (!(svm->vcpu.arch.efer & EFER_SVME)
 	    || !is_paging(&svm->vcpu)) {
 		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 		return 1;
@@ -1764,7 +1764,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	hsave->save.ds     = vmcb->save.ds;
 	hsave->save.gdtr   = vmcb->save.gdtr;
 	hsave->save.idtr   = vmcb->save.idtr;
-	hsave->save.efer   = svm->vcpu.arch.shadow_efer;
+	hsave->save.efer   = svm->vcpu.arch.efer;
 	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	hsave->save.cr4    = svm->vcpu.arch.cr4;
 	hsave->save.rflags = vmcb->save.rflags;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2e89495..a680d93 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -613,7 +613,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 	u64 guest_efer;
 	u64 ignore_bits;
 
-	guest_efer = vmx->vcpu.arch.shadow_efer;
+	guest_efer = vmx->vcpu.arch.efer;
 
 	/*
 	 * NX is emulated; LMA and LME handled by hardware; SCE meaninless
@@ -955,7 +955,7 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		 * if efer.sce is enabled.
 		 */
 		index = __find_msr_index(vmx, MSR_K6_STAR);
-		if ((index >= 0) && (vmx->vcpu.arch.shadow_efer & EFER_SCE))
+		if ((index >= 0) && (vmx->vcpu.arch.efer & EFER_SCE))
 			move_msr_up(vmx, index, save_nmsrs++);
 	}
 #endif
@@ -1600,7 +1600,7 @@ static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	 * of this msr depends on is_long_mode().
 	 */
 	vmx_load_host_state(to_vmx(vcpu));
-	vcpu->arch.shadow_efer = efer;
+	vcpu->arch.efer = efer;
 	if (!msr)
 		return;
 	if (efer & EFER_LMA) {
@@ -1632,13 +1632,13 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 			     (guest_tr_ar & ~AR_TYPE_MASK)
 			     | AR_TYPE_BUSY_64_TSS);
 	}
-	vcpu->arch.shadow_efer |= EFER_LMA;
-	vmx_set_efer(vcpu, vcpu->arch.shadow_efer);
+	vcpu->arch.efer |= EFER_LMA;
+	vmx_set_efer(vcpu, vcpu->arch.efer);
 }
 
 static void exit_lmode(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.shadow_efer &= ~EFER_LMA;
+	vcpu->arch.efer &= ~EFER_LMA;
 
 	vmcs_write32(VM_ENTRY_CONTROLS,
 		     vmcs_read32(VM_ENTRY_CONTROLS)
@@ -1745,7 +1745,7 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		enter_rmode(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->arch.shadow_efer & EFER_LME) {
+	if (vcpu->arch.efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG))
 			enter_lmode(vcpu);
 		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4a7d18..27af6e3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -456,7 +456,7 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 #ifdef CONFIG_X86_64
-		if ((vcpu->arch.shadow_efer & EFER_LME)) {
+		if ((vcpu->arch.efer & EFER_LME)) {
 			int cs_db, cs_l;
 
 			if (!is_pae(vcpu)) {
@@ -655,7 +655,7 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	}
 
 	if (is_paging(vcpu)
-	    && (vcpu->arch.shadow_efer & EFER_LME) != (efer & EFER_LME)) {
+	    && (vcpu->arch.efer & EFER_LME) != (efer & EFER_LME)) {
 		printk(KERN_DEBUG "set_efer: #GP, change LME while paging\n");
 		kvm_inject_gp(vcpu, 0);
 		return;
@@ -686,9 +686,9 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	kvm_x86_ops->set_efer(vcpu, efer);
 
 	efer &= ~EFER_LMA;
-	efer |= vcpu->arch.shadow_efer & EFER_LMA;
+	efer |= vcpu->arch.efer & EFER_LMA;
 
-	vcpu->arch.shadow_efer = efer;
+	vcpu->arch.efer = efer;
 
 	vcpu->arch.mmu.base_role.nxe = (efer & EFER_NX) && !tdp_enabled;
 	kvm_mmu_reset_context(vcpu);
@@ -1426,7 +1426,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		data |= (((uint64_t)4ULL) << 40);
 		break;
 	case MSR_EFER:
-		data = vcpu->arch.shadow_efer;
+		data = vcpu->arch.efer;
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		data = vcpu->kvm->arch.wall_clock;
@@ -4569,7 +4569,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->cr3 = vcpu->arch.cr3;
 	sregs->cr4 = kvm_read_cr4(vcpu);
 	sregs->cr8 = kvm_get_cr8(vcpu);
-	sregs->efer = vcpu->arch.shadow_efer;
+	sregs->efer = vcpu->arch.efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
 
 	memset(sregs->interrupt_bitmap, 0, sizeof sregs->interrupt_bitmap);
@@ -5059,7 +5059,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
-	mmu_reset_needed |= vcpu->arch.shadow_efer != sregs->efer;
+	mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
 	kvm_x86_ops->set_efer(vcpu, sregs->efer);
 	kvm_set_apic_base(vcpu, sregs->apic_base);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2dc24a7..2d10163 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -44,7 +44,7 @@ static inline bool is_protmode(struct kvm_vcpu *vcpu)
 static inline int is_long_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
-	return vcpu->arch.shadow_efer & EFER_LMA;
+	return vcpu->arch.efer & EFER_LMA;
 #else
 	return 0;
 #endif
-- 
1.6.5.3


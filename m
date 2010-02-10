Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0BJRal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:30:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/40] KVM: Add accessor for reading cr4 (or some bits of cr4)
Date: Wed, 10 Feb 2010 19:22:35 +0200
Message-Id: <1265822589-11155-7-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bits of cr4 can be owned by the guest on vmx, so when we read them,
we copy them to the vcpu structure.  In preparation for making the set of
guest-owned bits dynamic, use helpers to access these bits so we don't need
to know where the bit resides.

No changes to svm since all bits are host-owned there.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/kvm_cache_regs.h   |   12 ++++++++++++
 arch/x86/kvm/mmu.h              |    5 +++--
 arch/x86/kvm/vmx.c              |   13 ++++++++-----
 arch/x86/kvm/x86.c              |   16 ++++++----------
 5 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index da6dee8..e9f4f12 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -272,6 +272,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr2;
 	unsigned long cr3;
 	unsigned long cr4;
+	unsigned long cr4_guest_owned_bits;
 	unsigned long cr8;
 	u32 hflags;
 	u64 pdptrs[4]; /* pae */
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 7bcc5b6..35acc36 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -38,4 +38,16 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 	return vcpu->arch.pdptrs[index];
 }
 
+static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
+{
+	if (mask & vcpu->arch.cr4_guest_owned_bits)
+		kvm_x86_ops->decache_cr4_guest_bits(vcpu);
+	return vcpu->arch.cr4 & mask;
+}
+
+static inline ulong kvm_read_cr4(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr4_bits(vcpu, ~0UL);
+}
+
 #endif
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 61a1b38..4567d80 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -2,6 +2,7 @@
 #define __KVM_X86_MMU_H
 
 #include <linux/kvm_host.h>
+#include "kvm_cache_regs.h"
 
 #define PT64_PT_BITS 9
 #define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
@@ -64,12 +65,12 @@ static inline int is_long_mode(struct kvm_vcpu *vcpu)
 
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.cr4 & X86_CR4_PAE;
+	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);
 }
 
 static inline int is_pse(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.cr4 & X86_CR4_PSE;
+	return kvm_read_cr4_bits(vcpu, X86_CR4_PSE);
 }
 
 static inline int is_paging(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index efbb614..284e905 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1615,8 +1615,10 @@ static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 
 static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.cr4 &= KVM_GUEST_CR4_MASK;
-	vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & ~KVM_GUEST_CR4_MASK;
+	ulong cr4_guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
+
+	vcpu->arch.cr4 &= ~cr4_guest_owned_bits;
+	vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & cr4_guest_owned_bits;
 }
 
 static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
@@ -1661,7 +1663,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 			     (CPU_BASED_CR3_LOAD_EXITING |
 			      CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
-		vmx_set_cr4(vcpu, vcpu->arch.cr4);
+		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	} else if (!is_paging(vcpu)) {
 		/* From nonpaging to paging */
 		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
@@ -1669,7 +1671,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 			     ~(CPU_BASED_CR3_LOAD_EXITING |
 			       CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
-		vmx_set_cr4(vcpu, vcpu->arch.cr4);
+		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	}
 
 	if (!(cr0 & X86_CR0_WP))
@@ -2420,6 +2422,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
+	vmx->vcpu.arch.cr4_guest_owned_bits = ~KVM_GUEST_CR4_MASK;
 
 	tsc_base = vmx->vcpu.kvm->arch.vm_init_tsc;
 	rdtscll(tsc_this);
@@ -3050,7 +3053,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 				vcpu->arch.eff_db[dr] = val;
 			break;
 		case 4 ... 5:
-			if (vcpu->arch.cr4 & X86_CR4_DE)
+			if (kvm_read_cr4_bits(vcpu, X86_CR4_DE))
 				kvm_queue_exception(vcpu, UD_VECTOR);
 			break;
 		case 6:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47fab87..fd67f88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -482,7 +482,7 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
 
 void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	unsigned long old_cr4 = vcpu->arch.cr4;
+	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE;
 
 	if (cr4 & CR4_RESERVED_BITS) {
@@ -1900,7 +1900,7 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 		return 0;
 	if (mce->status & MCI_STATUS_UC) {
 		if ((vcpu->arch.mcg_status & MCG_STATUS_MCIP) ||
-		    !(vcpu->arch.cr4 & X86_CR4_MCE)) {
+		    !kvm_read_cr4_bits(vcpu, X86_CR4_MCE)) {
 			printk(KERN_DEBUG "kvm: set_mce: "
 			       "injects mce exception while "
 			       "previous one is in progress!\n");
@@ -3617,7 +3617,6 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 {
 	unsigned long value;
 
-	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 	switch (cr) {
 	case 0:
 		value = vcpu->arch.cr0;
@@ -3629,7 +3628,7 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 		value = vcpu->arch.cr3;
 		break;
 	case 4:
-		value = vcpu->arch.cr4;
+		value = kvm_read_cr4(vcpu);
 		break;
 	case 8:
 		value = kvm_get_cr8(vcpu);
@@ -3657,7 +3656,7 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 		kvm_set_cr3(vcpu, val);
 		break;
 	case 4:
-		kvm_set_cr4(vcpu, mk_cr_64(vcpu->arch.cr4, val));
+		kvm_set_cr4(vcpu, mk_cr_64(kvm_read_cr4(vcpu), val));
 		break;
 	case 8:
 		kvm_set_cr8(vcpu, val & 0xfUL);
@@ -4238,11 +4237,10 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->gdt.limit = dt.limit;
 	sregs->gdt.base = dt.base;
 
-	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 	sregs->cr0 = vcpu->arch.cr0;
 	sregs->cr2 = vcpu->arch.cr2;
 	sregs->cr3 = vcpu->arch.cr3;
-	sregs->cr4 = vcpu->arch.cr4;
+	sregs->cr4 = kvm_read_cr4(vcpu);
 	sregs->cr8 = kvm_get_cr8(vcpu);
 	sregs->efer = vcpu->arch.shadow_efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
@@ -4738,13 +4736,11 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	kvm_x86_ops->set_efer(vcpu, sregs->efer);
 	kvm_set_apic_base(vcpu, sregs->apic_base);
 
-	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
-
 	mmu_reset_needed |= vcpu->arch.cr0 != sregs->cr0;
 	kvm_x86_ops->set_cr0(vcpu, sregs->cr0);
 	vcpu->arch.cr0 = sregs->cr0;
 
-	mmu_reset_needed |= vcpu->arch.cr4 != sregs->cr4;
+	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
 	if (!is_long_mode(vcpu) && is_pae(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.cr3);
-- 
1.6.5.3


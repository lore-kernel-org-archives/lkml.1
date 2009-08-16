Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbZHPJcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbZHPJcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZHPJcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45375 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbZHPJaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 39/48] KVM: VMX: Support Unrestricted Guest feature
Date: Sun, 16 Aug 2009 12:29:59 +0300
Message-Id: <1250415008-17175-40-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

"Unrestricted Guest" feature is added in the VMX specification.
Intel Westmere and onwards processors will support this feature.

    It allows kvm guests to run real mode and unpaged mode
code natively in the VMX mode when EPT is turned on. With the
unrestricted guest there is no need to emulate the guest real mode code
in the vm86 container or in the emulator. Also the guest big real mode
code works like native.

  The attached patch enhances KVM to use the unrestricted guest feature
if available on the processor. It also adds a new kernel/module
parameter to disable the unrestricted guest feature at the boot time.

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   12 ++++---
 arch/x86/include/asm/vmx.h      |    1 +
 arch/x86/kvm/vmx.c              |   60 +++++++++++++++++++++++++++++++++++----
 3 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1cc901e..a1a96a5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -37,12 +37,14 @@
 #define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS |	\
 				  0xFFFFFF0000000000ULL)
 
-#define KVM_GUEST_CR0_MASK				   \
-	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE \
-	 | X86_CR0_NW | X86_CR0_CD)
+#define KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST				\
+	(X86_CR0_WP | X86_CR0_NE | X86_CR0_NW | X86_CR0_CD)
+#define KVM_GUEST_CR0_MASK						\
+	(KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
+#define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST				\
+	(X86_CR0_WP | X86_CR0_NE | X86_CR0_TS | X86_CR0_MP)
 #define KVM_VM_CR0_ALWAYS_ON						\
-	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE | X86_CR0_TS \
-	 | X86_CR0_MP)
+	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
 #define KVM_GUEST_CR4_MASK						\
 	(X86_CR4_VME | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_PGE | X86_CR4_VMXE)
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 11be5ad..e7927a6 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -55,6 +55,7 @@
 #define SECONDARY_EXEC_ENABLE_EPT               0x00000002
 #define SECONDARY_EXEC_ENABLE_VPID              0x00000020
 #define SECONDARY_EXEC_WBINVD_EXITING		0x00000040
+#define SECONDARY_EXEC_UNRESTRICTED_GUEST	0x00000080
 
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 959cb59..f0f9773 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -51,6 +51,10 @@ module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
 static int __read_mostly enable_ept = 1;
 module_param_named(ept, enable_ept, bool, S_IRUGO);
 
+static int __read_mostly enable_unrestricted_guest = 1;
+module_param_named(unrestricted_guest,
+			enable_unrestricted_guest, bool, S_IRUGO);
+
 static int __read_mostly emulate_invalid_guest_state = 0;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
@@ -279,6 +283,12 @@ static inline int cpu_has_vmx_ept(void)
 		SECONDARY_EXEC_ENABLE_EPT;
 }
 
+static inline int cpu_has_vmx_unrestricted_guest(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_UNRESTRICTED_GUEST;
+}
+
 static inline int vm_need_virtualize_apic_accesses(struct kvm *kvm)
 {
 	return flexpriority_enabled &&
@@ -1210,7 +1220,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		opt2 = SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
 			SECONDARY_EXEC_WBINVD_EXITING |
 			SECONDARY_EXEC_ENABLE_VPID |
-			SECONDARY_EXEC_ENABLE_EPT;
+			SECONDARY_EXEC_ENABLE_EPT |
+			SECONDARY_EXEC_UNRESTRICTED_GUEST;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -1340,8 +1351,13 @@ static __init int hardware_setup(void)
 	if (!cpu_has_vmx_vpid())
 		enable_vpid = 0;
 
-	if (!cpu_has_vmx_ept())
+	if (!cpu_has_vmx_ept()) {
 		enable_ept = 0;
+		enable_unrestricted_guest = 0;
+	}
+
+	if (!cpu_has_vmx_unrestricted_guest())
+		enable_unrestricted_guest = 0;
 
 	if (!cpu_has_vmx_flexpriority())
 		flexpriority_enabled = 0;
@@ -1440,6 +1456,9 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (enable_unrestricted_guest)
+		return;
+
 	vmx->emulation_required = 1;
 	vcpu->arch.rmode.vm86_active = 1;
 
@@ -1593,7 +1612,6 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 			      CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, vcpu->arch.cr4);
-		*hw_cr0 |= X86_CR0_PE | X86_CR0_PG;
 		*hw_cr0 &= ~X86_CR0_WP;
 	} else if (!is_paging(vcpu)) {
 		/* From nonpaging to paging */
@@ -1620,8 +1638,13 @@ static void ept_update_paging_mode_cr4(unsigned long *hw_cr4,
 
 static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
-	unsigned long hw_cr0 = (cr0 & ~KVM_GUEST_CR0_MASK) |
-				KVM_VM_CR0_ALWAYS_ON;
+	unsigned long hw_cr0;
+
+	if (enable_unrestricted_guest)
+		hw_cr0 = (cr0 & ~KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST)
+			| KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
+	else
+		hw_cr0 = (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON;
 
 	vmx_fpu_deactivate(vcpu);
 
@@ -1786,6 +1809,21 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
 		ar = 0xf3;
 	} else
 		ar = vmx_segment_access_rights(var);
+
+	/*
+	 *   Fix the "Accessed" bit in AR field of segment registers for older
+	 * qemu binaries.
+	 *   IA32 arch specifies that at the time of processor reset the
+	 * "Accessed" bit in the AR field of segment registers is 1. And qemu
+	 * is setting it to 0 in the usedland code. This causes invalid guest
+	 * state vmexit when "unrestricted guest" mode is turned on.
+	 *    Fix for this setup issue in cpu_reset is being pushed in the qemu
+	 * tree. Newer qemu binaries with that qemu fix would not need this
+	 * kvm hack.
+	 */
+	if (enable_unrestricted_guest && (seg != VCPU_SREG_LDTR))
+		ar |= 0x1; /* Accessed */
+
 	vmcs_write32(sf->ar_bytes, ar);
 }
 
@@ -2082,11 +2120,19 @@ out:
 static void seg_setup(int seg)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+	unsigned int ar;
 
 	vmcs_write16(sf->selector, 0);
 	vmcs_writel(sf->base, 0);
 	vmcs_write32(sf->limit, 0xffff);
-	vmcs_write32(sf->ar_bytes, 0xf3);
+	if (enable_unrestricted_guest) {
+		ar = 0x93;
+		if (seg == VCPU_SREG_CS)
+			ar |= 0x08; /* code segment */
+	} else
+		ar = 0xf3;
+
+	vmcs_write32(sf->ar_bytes, ar);
 }
 
 static int alloc_apic_access_page(struct kvm *kvm)
@@ -2229,6 +2275,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 			exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
 		if (!enable_ept)
 			exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
+		if (!enable_unrestricted_guest)
+			exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
 	}
 
-- 
1.6.3.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXD2Pv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXD2Pv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933318AbXD2Pur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:50:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:34344 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbXD2PuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:50:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 2/7] KVM: VMX: Add lazy FPU support for VT
Date: Sun, 29 Apr 2007 18:50:17 +0300
Message-Id: <1177861822300-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1177861822889-git-send-email-avi@qumranet.com>
References: <1177861822889-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

Only save/restore the FPU host state when the guest is actually using the
FPU.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 0960811..1d2b41b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -101,6 +101,13 @@ static inline int is_page_fault(u32 intr_info)
 		(INTR_TYPE_EXCEPTION | PF_VECTOR | INTR_INFO_VALID_MASK);
 }
 
+static inline int is_no_device(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
+			     INTR_INFO_VALID_MASK)) ==
+		(INTR_TYPE_EXCEPTION | NM_VECTOR | INTR_INFO_VALID_MASK);
+}
+
 static inline int is_external_interrupt(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
@@ -216,6 +223,16 @@ static void vmcs_write64(unsigned long field, u64 value)
 #endif
 }
 
+static void vmcs_clear_bits(unsigned long field, u32 mask)
+{
+	vmcs_writel(field, vmcs_readl(field) & ~mask);
+}
+
+static void vmcs_set_bits(unsigned long field, u32 mask)
+{
+	vmcs_writel(field, vmcs_readl(field) | mask);
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
@@ -833,6 +850,11 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 #endif
 
+	if (!(cr0 & CR0_TS_MASK)) {
+		vcpu->fpu_active = 1;
+		vmcs_clear_bits(EXCEPTION_BITMAP, CR0_TS_MASK);
+	}
+
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0,
 		    (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
@@ -842,6 +864,12 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	vmcs_writel(GUEST_CR3, cr3);
+
+	if (!(vcpu->cr0 & CR0_TS_MASK)) {
+		vcpu->fpu_active = 0;
+		vmcs_set_bits(GUEST_CR0, CR0_TS_MASK);
+		vmcs_set_bits(EXCEPTION_BITMAP, 1 << NM_VECTOR);
+	}
 }
 
 static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -1368,6 +1396,15 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		asm ("int $2");
 		return 1;
 	}
+
+	if (is_no_device(intr_info)) {
+		vcpu->fpu_active = 1;
+		vmcs_clear_bits(EXCEPTION_BITMAP, 1 << NM_VECTOR);
+		if (!(vcpu->cr0 & CR0_TS_MASK))
+			vmcs_clear_bits(GUEST_CR0, CR0_TS_MASK);
+		return 1;
+	}
+
 	error_code = 0;
 	rip = vmcs_readl(GUEST_RIP);
 	if (intr_info & INTR_INFO_DELIEVER_CODE_MASK)
@@ -1556,7 +1593,11 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		break;
 	case 2: /* clts */
 		vcpu_load_rsp_rip(vcpu);
-		set_cr0(vcpu, vcpu->cr0 & ~CR0_TS_MASK);
+		vcpu->fpu_active = 1;
+		vmcs_clear_bits(EXCEPTION_BITMAP, 1 << NM_VECTOR);
+		vmcs_clear_bits(GUEST_CR0, CR0_TS_MASK);
+		vcpu->cr0 &= ~CR0_TS_MASK;
+		vmcs_writel(CR0_READ_SHADOW, vcpu->cr0);
 		skip_emulated_instruction(vcpu);
 		return 1;
 	case 1: /*mov from cr*/
@@ -1806,8 +1847,10 @@ again:
 	if (vcpu->guest_debug.enabled)
 		kvm_guest_debug_pre(vcpu);
 
-	fx_save(vcpu->host_fx_image);
-	fx_restore(vcpu->guest_fx_image);
+	if (vcpu->fpu_active) {
+		fx_save(vcpu->host_fx_image);
+		fx_restore(vcpu->guest_fx_image);
+	}
 
 #ifdef CONFIG_X86_64
 	if (is_long_mode(vcpu)) {
@@ -1965,8 +2008,11 @@ again:
 	}
 #endif
 
-	fx_save(vcpu->guest_fx_image);
-	fx_restore(vcpu->host_fx_image);
+	if (vcpu->fpu_active) {
+		fx_save(vcpu->guest_fx_image);
+		fx_restore(vcpu->host_fx_image);
+	}
+
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
@@ -2078,6 +2124,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmcs_clear(vmcs);
 	vcpu->vmcs = vmcs;
 	vcpu->launched = 0;
+	vcpu->fpu_active = 1;
 
 	return 0;
 
-- 
1.5.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbZB1Bt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbZB1Bt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZB1Bms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41787 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbZB1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:59 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/30] KVM: VMX: Update necessary state when guest enters long mode
Date: Sat, 28 Feb 2009 03:41:46 +0200
Message-Id: <1235785309-12835-28-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

setup_msrs() should be called when entering long mode to save the
shadow state for the 64-bit guest state.

Using vmx_set_efer() in enter_lmode() removes some duplicated code
and also ensures we call setup_msrs(). We can safely pass the value
of shadow_efer to vmx_set_efer() as no other bits in the efer change
while enabling long mode (guest first sets EFER.LME, then sets CR0.PG
which causes a vmexit where we activate long mode).

With this fix, is_long_mode() can check for EFER.LMA set instead of
EFER.LME and 5e23049e86dd298b72e206b420513dbc3a240cd9 can be reverted.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   54 +++++++++++++++++++++++----------------------------
 1 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index cb27ffc..48063a0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1430,6 +1430,29 @@ continue_rmode:
 	init_rmode(vcpu->kvm);
 }
 
+static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
+
+	vcpu->arch.shadow_efer = efer;
+	if (!msr)
+		return;
+	if (efer & EFER_LMA) {
+		vmcs_write32(VM_ENTRY_CONTROLS,
+			     vmcs_read32(VM_ENTRY_CONTROLS) |
+			     VM_ENTRY_IA32E_MODE);
+		msr->data = efer;
+	} else {
+		vmcs_write32(VM_ENTRY_CONTROLS,
+			     vmcs_read32(VM_ENTRY_CONTROLS) &
+			     ~VM_ENTRY_IA32E_MODE);
+
+		msr->data = efer & ~EFER_LME;
+	}
+	setup_msrs(vmx);
+}
+
 #ifdef CONFIG_X86_64
 
 static void enter_lmode(struct kvm_vcpu *vcpu)
@@ -1444,13 +1467,8 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 			     (guest_tr_ar & ~AR_TYPE_MASK)
 			     | AR_TYPE_BUSY_64_TSS);
 	}
-
 	vcpu->arch.shadow_efer |= EFER_LMA;
-
-	find_msr_entry(to_vmx(vcpu), MSR_EFER)->data |= EFER_LMA | EFER_LME;
-	vmcs_write32(VM_ENTRY_CONTROLS,
-		     vmcs_read32(VM_ENTRY_CONTROLS)
-		     | VM_ENTRY_IA32E_MODE);
+	vmx_set_efer(vcpu, vcpu->arch.shadow_efer);
 }
 
 static void exit_lmode(struct kvm_vcpu *vcpu)
@@ -1609,30 +1627,6 @@ static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	vmcs_writel(GUEST_CR4, hw_cr4);
 }
 
-static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
-
-	vcpu->arch.shadow_efer = efer;
-	if (!msr)
-		return;
-	if (efer & EFER_LMA) {
-		vmcs_write32(VM_ENTRY_CONTROLS,
-				     vmcs_read32(VM_ENTRY_CONTROLS) |
-				     VM_ENTRY_IA32E_MODE);
-		msr->data = efer;
-
-	} else {
-		vmcs_write32(VM_ENTRY_CONTROLS,
-				     vmcs_read32(VM_ENTRY_CONTROLS) &
-				     ~VM_ENTRY_IA32E_MODE);
-
-		msr->data = efer & ~EFER_LME;
-	}
-	setup_msrs(vmx);
-}
-
 static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
-- 
1.6.0.6


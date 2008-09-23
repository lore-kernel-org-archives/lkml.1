Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYIWNtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYIWNtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYIWNrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYIWNrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 08/40] KVM: VMX: Move nmi injection failure processing to vm exit path
Date: Tue, 23 Sep 2008 16:46:22 +0300
Message-Id: <1222177614-26669-9-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Instead of processing nmi injection failure in the vm entry path, move
it to the vm exit path (vm_complete_interrupts()).  This separates nmi
injection from nmi post-processing, and moves the nmi state from the VT
state into vcpu state (new variable nmi_injected specifying an injection
in progress).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c         |   49 ++++++++++++++++++++++++++++---------------
 include/asm-x86/kvm_host.h |    1 +
 2 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2adfacb..ce13b53 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2151,7 +2151,6 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
-	vcpu->arch.nmi_pending = 0;
 }
 
 static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
@@ -2820,8 +2819,11 @@ static void enable_intr_window(struct kvm_vcpu *vcpu)
 static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 {
 	u32 exit_intr_info;
+	u32 idt_vectoring_info;
 	bool unblock_nmi;
 	u8 vector;
+	int type;
+	bool idtv_info_valid;
 
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if (cpu_has_virtual_nmis()) {
@@ -2836,18 +2838,34 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
 				      GUEST_INTR_STATE_NMI);
 	}
+
+	idt_vectoring_info = vmx->idt_vectoring_info;
+	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
+	vector = idt_vectoring_info & VECTORING_INFO_VECTOR_MASK;
+	type = idt_vectoring_info & VECTORING_INFO_TYPE_MASK;
+	if (vmx->vcpu.arch.nmi_injected) {
+		/*
+		 * SDM 3: 25.7.1.2
+		 * Clear bit "block by NMI" before VM entry if a NMI delivery
+		 * faulted.
+		 */
+		if (idtv_info_valid && type == INTR_TYPE_NMI_INTR)
+			vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
+					GUEST_INTR_STATE_NMI);
+		else
+			vmx->vcpu.arch.nmi_injected = false;
+	}
 }
 
 static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 idtv_info_field, intr_info_field, exit_intr_info_field;
+	u32 idtv_info_field, intr_info_field;
 	int vector;
 
 	update_tpr_threshold(vcpu);
 
 	intr_info_field = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
-	exit_intr_info_field = vmcs_read32(VM_EXIT_INTR_INFO);
 	idtv_info_field = vmx->idt_vectoring_info;
 	if (intr_info_field & INTR_INFO_VALID_MASK) {
 		if (idtv_info_field & INTR_INFO_VALID_MASK) {
@@ -2871,17 +2889,6 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 
 		KVMTRACE_1D(REDELIVER_EVT, vcpu, idtv_info_field, handler);
 
-		/*
-		 * SDM 3: 25.7.1.2
-		 * Clear bit "block by NMI" before VM entry if a NMI delivery
-		 * faulted.
-		 */
-		if ((idtv_info_field & VECTORING_INFO_TYPE_MASK)
-		    == INTR_TYPE_NMI_INTR && cpu_has_virtual_nmis())
-			vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
-				vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-				~GUEST_INTR_STATE_NMI);
-
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, idtv_info_field
 				& ~INTR_INFO_RESVD_BITS_MASK);
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
@@ -2894,9 +2901,17 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 		return;
 	}
 	if (cpu_has_virtual_nmis()) {
-		if (vcpu->arch.nmi_pending) {
-			if (vmx_nmi_enabled(vcpu))
-				vmx_inject_nmi(vcpu);
+		if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
+			if (vmx_nmi_enabled(vcpu)) {
+				vcpu->arch.nmi_pending = false;
+				vcpu->arch.nmi_injected = true;
+			} else {
+				enable_intr_window(vcpu);
+				return;
+			}
+		}
+		if (vcpu->arch.nmi_injected) {
+			vmx_inject_nmi(vcpu);
 			enable_intr_window(vcpu);
 			return;
 		}
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index b016fef..501d215 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -300,6 +300,7 @@ struct kvm_vcpu_arch {
 	struct page *time_page;
 
 	bool nmi_pending;
+	bool nmi_injected;
 
 	u64 mtrr[0x100];
 };
-- 
1.6.0.1


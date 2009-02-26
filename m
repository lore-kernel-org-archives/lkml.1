Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbZBZOby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbZBZOby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZBZOR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43061 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 12/40] KVM: VMX: Support for injecting software exceptions
Date: Thu, 26 Feb 2009 16:15:02 +0200
Message-Id: <1235657730-27683-13-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

VMX differentiates between processor and software generated exceptions
when injecting them into the guest. Extend vmx_queue_exception
accordingly (and refactor related constants) so that we can use this
service reliably for the new guest debugging framework.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/vmx.h |    3 ++-
 arch/x86/kvm/vmx.c         |   35 ++++++++++++++++++++---------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index d0238e6..32159f0 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -270,8 +270,9 @@ enum vmcs_field {
 
 #define INTR_TYPE_EXT_INTR              (0 << 8) /* external interrupt */
 #define INTR_TYPE_NMI_INTR		(2 << 8) /* NMI */
-#define INTR_TYPE_EXCEPTION             (3 << 8) /* processor exception */
+#define INTR_TYPE_HARD_EXCEPTION	(3 << 8) /* processor exception */
 #define INTR_TYPE_SOFT_INTR             (4 << 8) /* software interrupt */
+#define INTR_TYPE_SOFT_EXCEPTION	(6 << 8) /* software exception */
 
 /* GUEST_INTERRUPTIBILITY_INFO flags. */
 #define GUEST_INTR_STATE_STI		0x00000001
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7611af5..1d974c1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -189,21 +189,21 @@ static inline int is_page_fault(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
 			     INTR_INFO_VALID_MASK)) ==
-		(INTR_TYPE_EXCEPTION | PF_VECTOR | INTR_INFO_VALID_MASK);
+		(INTR_TYPE_HARD_EXCEPTION | PF_VECTOR | INTR_INFO_VALID_MASK);
 }
 
 static inline int is_no_device(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
 			     INTR_INFO_VALID_MASK)) ==
-		(INTR_TYPE_EXCEPTION | NM_VECTOR | INTR_INFO_VALID_MASK);
+		(INTR_TYPE_HARD_EXCEPTION | NM_VECTOR | INTR_INFO_VALID_MASK);
 }
 
 static inline int is_invalid_opcode(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
 			     INTR_INFO_VALID_MASK)) ==
-		(INTR_TYPE_EXCEPTION | UD_VECTOR | INTR_INFO_VALID_MASK);
+		(INTR_TYPE_HARD_EXCEPTION | UD_VECTOR | INTR_INFO_VALID_MASK);
 }
 
 static inline int is_external_interrupt(u32 intr_info)
@@ -747,29 +747,33 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 				bool has_error_code, u32 error_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
-	if (has_error_code)
+	if (has_error_code) {
 		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
+		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
+	}
 
 	if (vcpu->arch.rmode.active) {
 		vmx->rmode.irq.pending = true;
 		vmx->rmode.irq.vector = nr;
 		vmx->rmode.irq.rip = kvm_rip_read(vcpu);
-		if (nr == BP_VECTOR)
+		if (nr == BP_VECTOR || nr == OF_VECTOR)
 			vmx->rmode.irq.rip++;
-		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-			     nr | INTR_TYPE_SOFT_INTR
-			     | (has_error_code ? INTR_INFO_DELIVER_CODE_MASK : 0)
-			     | INTR_INFO_VALID_MASK);
+		intr_info |= INTR_TYPE_SOFT_INTR;
+		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
 		kvm_rip_write(vcpu, vmx->rmode.irq.rip - 1);
 		return;
 	}
 
-	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-		     nr | INTR_TYPE_EXCEPTION
-		     | (has_error_code ? INTR_INFO_DELIVER_CODE_MASK : 0)
-		     | INTR_INFO_VALID_MASK);
+	if (nr == BP_VECTOR || nr == OF_VECTOR) {
+		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
+		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
+	} else
+		intr_info |= INTR_TYPE_HARD_EXCEPTION;
+
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 }
 
 static bool vmx_exception_injected(struct kvm_vcpu *vcpu)
@@ -2650,7 +2654,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	if ((intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK)) ==
-	    (INTR_TYPE_EXCEPTION | 1)) {
+	    (INTR_TYPE_HARD_EXCEPTION | 1)) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		return 0;
 	}
@@ -3238,7 +3242,8 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 			vmx->vcpu.arch.nmi_injected = false;
 	}
 	kvm_clear_exception_queue(&vmx->vcpu);
-	if (idtv_info_valid && type == INTR_TYPE_EXCEPTION) {
+	if (idtv_info_valid && (type == INTR_TYPE_HARD_EXCEPTION ||
+				type == INTR_TYPE_SOFT_EXCEPTION)) {
 		if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
 			error = vmcs_read32(IDT_VECTORING_ERROR_CODE);
 			kvm_queue_exception_e(&vmx->vcpu, vector, error);
-- 
1.6.0.6


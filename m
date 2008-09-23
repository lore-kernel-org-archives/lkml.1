Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYIWNvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYIWNvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYIWNr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52367 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYIWNrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:17 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 12/40] KVM: VMX: Move interrupt post-processing to vmx_complete_interrupts()
Date: Tue, 23 Sep 2008 16:46:26 +0300
Message-Id: <1222177614-26669-13-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Instead of looking at failed injections in the vm entry path, move
processing to the exit path in vmx_complete_interrupts().  This simplifes
the logic and removes any state that is hidden in vmx registers.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   77 +++++++++++++--------------------------------------
 1 files changed, 20 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ed4fe8e..e8fed9b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1002,17 +1002,9 @@ static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 
 static int vmx_get_irq(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 idtv_info_field;
-
-	idtv_info_field = vmx->idt_vectoring_info;
-	if (idtv_info_field & INTR_INFO_VALID_MASK) {
-		if (is_external_interrupt(idtv_info_field))
-			return idtv_info_field & VECTORING_INFO_VECTOR_MASK;
-		else
-			printk(KERN_DEBUG "pending exception: not handled yet\n");
-	}
-	return -1;
+	if (!vcpu->arch.interrupt.pending)
+		return -1;
+	return vcpu->arch.interrupt.nr;
 }
 
 static __init int cpu_has_kvm_support(void)
@@ -2293,7 +2285,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
 		KVMTRACE_3D(PAGE_FAULT, vcpu, error_code, (u32)cr2,
 			    (u32)((u64)cr2 >> 32), handler);
-		if (vect_info & VECTORING_INFO_VALID_MASK)
+		if (vcpu->arch.interrupt.pending || vcpu->arch.exception.pending)
 			kvm_mmu_unprotect_page_virt(vcpu, cr2);
 		return kvm_mmu_page_fault(vcpu, cr2, error_code);
 	}
@@ -2864,51 +2856,20 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 			kvm_queue_exception(&vmx->vcpu, vector);
 		vmx->idt_vectoring_info = 0;
 	}
+	kvm_clear_interrupt_queue(&vmx->vcpu);
+	if (idtv_info_valid && type == INTR_TYPE_EXT_INTR) {
+		kvm_queue_interrupt(&vmx->vcpu, vector);
+		vmx->idt_vectoring_info = 0;
+	}
 }
 
 static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 idtv_info_field, intr_info_field;
-	int vector;
+	u32 intr_info_field;
 
 	update_tpr_threshold(vcpu);
 
 	intr_info_field = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
-	idtv_info_field = vmx->idt_vectoring_info;
-	if (intr_info_field & INTR_INFO_VALID_MASK) {
-		if (idtv_info_field & INTR_INFO_VALID_MASK) {
-			/* TODO: fault when IDT_Vectoring */
-			if (printk_ratelimit())
-				printk(KERN_ERR "Fault when IDT_Vectoring\n");
-		}
-		enable_intr_window(vcpu);
-		return;
-	}
-	if (unlikely(idtv_info_field & INTR_INFO_VALID_MASK)) {
-		if ((idtv_info_field & VECTORING_INFO_TYPE_MASK)
-		    == INTR_TYPE_EXT_INTR
-		    && vcpu->arch.rmode.active) {
-			u8 vect = idtv_info_field & VECTORING_INFO_VECTOR_MASK;
-
-			vmx_inject_irq(vcpu, vect);
-			enable_intr_window(vcpu);
-			return;
-		}
-
-		KVMTRACE_1D(REDELIVER_EVT, vcpu, idtv_info_field, handler);
-
-		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, idtv_info_field
-				& ~INTR_INFO_RESVD_BITS_MASK);
-		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
-				vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
-
-		if (unlikely(idtv_info_field & INTR_INFO_DELIVER_CODE_MASK))
-			vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE,
-				vmcs_read32(IDT_VECTORING_ERROR_CODE));
-		enable_intr_window(vcpu);
-		return;
-	}
 	if (cpu_has_virtual_nmis()) {
 		if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
 			if (vmx_nmi_enabled(vcpu)) {
@@ -2925,14 +2886,16 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 			return;
 		}
 	}
-	if (!kvm_cpu_has_interrupt(vcpu))
-		return;
-	if (vmx_irq_enabled(vcpu)) {
-		vector = kvm_cpu_get_interrupt(vcpu);
-		vmx_inject_irq(vcpu, vector);
-		kvm_timer_intr_post(vcpu, vector);
-	} else
-		enable_irq_window(vcpu);
+	if (!vcpu->arch.interrupt.pending && kvm_cpu_has_interrupt(vcpu)) {
+		if (vmx_irq_enabled(vcpu))
+			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
+		else
+			enable_irq_window(vcpu);
+	}
+	if (vcpu->arch.interrupt.pending) {
+		vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
+		kvm_timer_intr_post(vcpu, vcpu->arch.interrupt.nr);
+	}
 }
 
 /*
-- 
1.6.0.1


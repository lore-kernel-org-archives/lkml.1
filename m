Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbZETLax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbZETLax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbZETLVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbZETLSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:48 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 12/46] KVM: VMX: Rewrite vmx_complete_interrupt()'s twisted maze of if() statements
Date: Wed, 20 May 2009 14:18:09 +0300
Message-Id: <1242818323-10413-13-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

...with a more straightforward switch().

Also fix a bug when NMI could be dropped on exit. Although this should
never happen in practice, since NMIs can only be injected, never triggered
internally by the guest like exceptions.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   43 +++++++++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 631f9b7..577aa95 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3277,7 +3277,6 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 	u8 vector;
 	int type;
 	bool idtv_info_valid;
-	u32 error;
 
 	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
@@ -3302,34 +3301,42 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 		vmx->vnmi_blocked_time +=
 			ktime_to_ns(ktime_sub(ktime_get(), vmx->entry_time));
 
+	vmx->vcpu.arch.nmi_injected = false;
+	kvm_clear_exception_queue(&vmx->vcpu);
+	kvm_clear_interrupt_queue(&vmx->vcpu);
+
+	if (!idtv_info_valid)
+		return;
+
 	vector = idt_vectoring_info & VECTORING_INFO_VECTOR_MASK;
 	type = idt_vectoring_info & VECTORING_INFO_TYPE_MASK;
-	if (vmx->vcpu.arch.nmi_injected) {
+
+	switch(type) {
+	case INTR_TYPE_NMI_INTR:
+		vmx->vcpu.arch.nmi_injected = true;
 		/*
 		 * SDM 3: 27.7.1.2 (September 2008)
-		 * Clear bit "block by NMI" before VM entry if a NMI delivery
-		 * faulted.
+		 * Clear bit "block by NMI" before VM entry if a NMI
+		 * delivery faulted.
 		 */
-		if (idtv_info_valid && type == INTR_TYPE_NMI_INTR)
-			vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
-					GUEST_INTR_STATE_NMI);
-		else
-			vmx->vcpu.arch.nmi_injected = false;
-	}
-	kvm_clear_exception_queue(&vmx->vcpu);
-	if (idtv_info_valid && (type == INTR_TYPE_HARD_EXCEPTION ||
-				type == INTR_TYPE_SOFT_EXCEPTION)) {
+		vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
+				GUEST_INTR_STATE_NMI);
+		break;
+	case INTR_TYPE_HARD_EXCEPTION:
+	case INTR_TYPE_SOFT_EXCEPTION:
 		if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
-			error = vmcs_read32(IDT_VECTORING_ERROR_CODE);
-			kvm_queue_exception_e(&vmx->vcpu, vector, error);
+			u32 err = vmcs_read32(IDT_VECTORING_ERROR_CODE);
+			kvm_queue_exception_e(&vmx->vcpu, vector, err);
 		} else
 			kvm_queue_exception(&vmx->vcpu, vector);
 		vmx->idt_vectoring_info = 0;
-	}
-	kvm_clear_interrupt_queue(&vmx->vcpu);
-	if (idtv_info_valid && type == INTR_TYPE_EXT_INTR) {
+		break;
+	case INTR_TYPE_EXT_INTR:
 		kvm_queue_interrupt(&vmx->vcpu, vector);
 		vmx->idt_vectoring_info = 0;
+		break;
+	default:
+		break;
 	}
 }
 
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZETLbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZETLbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbZETLVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55263 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbZETLSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 11/46] KVM: VMX: Fix handling of a fault during NMI unblocked due to IRET
Date: Wed, 20 May 2009 14:18:08 +0300
Message-Id: <1242818323-10413-12-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Bit 12 is undefined in any of the following cases:
 If the VM exit sets the valid bit in the IDT-vectoring information field.
 If the VM exit is due to a double fault.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7d7b0d6..631f9b7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3272,36 +3272,41 @@ static void update_tpr_threshold(struct kvm_vcpu *vcpu)
 static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 {
 	u32 exit_intr_info;
-	u32 idt_vectoring_info;
+	u32 idt_vectoring_info = vmx->idt_vectoring_info;
 	bool unblock_nmi;
 	u8 vector;
 	int type;
 	bool idtv_info_valid;
 	u32 error;
 
+	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if (cpu_has_virtual_nmis()) {
 		unblock_nmi = (exit_intr_info & INTR_INFO_UNBLOCK_NMI) != 0;
 		vector = exit_intr_info & INTR_INFO_VECTOR_MASK;
 		/*
-		 * SDM 3: 25.7.1.2
+		 * SDM 3: 27.7.1.2 (September 2008)
 		 * Re-set bit "block by NMI" before VM entry if vmexit caused by
 		 * a guest IRET fault.
+		 * SDM 3: 23.2.2 (September 2008)
+		 * Bit 12 is undefined in any of the following cases:
+		 *  If the VM exit sets the valid bit in the IDT-vectoring
+		 *   information field.
+		 *  If the VM exit is due to a double fault.
 		 */
-		if (unblock_nmi && vector != DF_VECTOR)
+		if ((exit_intr_info & INTR_INFO_VALID_MASK) && unblock_nmi &&
+		    vector != DF_VECTOR && !idtv_info_valid)
 			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
 				      GUEST_INTR_STATE_NMI);
 	} else if (unlikely(vmx->soft_vnmi_blocked))
 		vmx->vnmi_blocked_time +=
 			ktime_to_ns(ktime_sub(ktime_get(), vmx->entry_time));
 
-	idt_vectoring_info = vmx->idt_vectoring_info;
-	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 	vector = idt_vectoring_info & VECTORING_INFO_VECTOR_MASK;
 	type = idt_vectoring_info & VECTORING_INFO_TYPE_MASK;
 	if (vmx->vcpu.arch.nmi_injected) {
 		/*
-		 * SDM 3: 25.7.1.2
+		 * SDM 3: 27.7.1.2 (September 2008)
 		 * Clear bit "block by NMI" before VM entry if a NMI delivery
 		 * faulted.
 		 */
-- 
1.6.0.6


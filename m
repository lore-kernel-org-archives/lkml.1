Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbZEXPws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbZEXPws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZEXPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41860 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 45/45] KVM: Move "exit due to NMI" handling into vmx_complete_interrupts()
Date: Sun, 24 May 2009 18:50:30 +0300
Message-Id: <1243180230-2480-46-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

To save us one reading of VM_EXIT_INTR_INFO.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 29b49f0..fe2ce2b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3261,8 +3261,17 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 	int type;
 	bool idtv_info_valid;
 
-	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+
+	/* We need to handle NMIs before interrupts are enabled */
+	if ((exit_intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
+	    (exit_intr_info & INTR_INFO_VALID_MASK)) {
+		KVMTRACE_0D(NMI, &vmx->vcpu, handler);
+		asm("int $2");
+	}
+
+	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
+
 	if (cpu_has_virtual_nmis()) {
 		unblock_nmi = (exit_intr_info & INTR_INFO_UNBLOCK_NMI) != 0;
 		vector = exit_intr_info & INTR_INFO_VECTOR_MASK;
@@ -3363,7 +3372,6 @@ static void fixup_rmode_irq(struct vcpu_vmx *vmx)
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 intr_info;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked))
@@ -3490,15 +3498,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	asm("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 	vmx->launched = 1;
 
-	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-
-	/* We need to handle NMIs before interrupts are enabled */
-	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
-	    (intr_info & INTR_INFO_VALID_MASK)) {
-		KVMTRACE_0D(NMI, vcpu, handler);
-		asm("int $2");
-	}
-
 	vmx_complete_interrupts(vmx);
 }
 
-- 
1.6.0.6


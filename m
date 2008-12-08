Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYLHLih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYLHLih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYLHLhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48213 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbYLHLhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:02 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 04/45] KVM: VMX: Support for NMI task gates
Date: Mon,  8 Dec 2008 13:36:15 +0200
Message-Id: <1228736216-15787-5-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Properly set GUEST_INTR_STATE_NMI and reset nmi_injected when a
task-switch vmexit happened due to a task gate being used for handling
NMIs. Also avoid the false warning about valid vectoring info in
kvm_handle_exit.

Based on original patch by Gleb Natapov.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 81cf12b..8d0fc68 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2832,6 +2832,7 @@ static int handle_apic_access(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_task_switch(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qualification;
 	u16 tss_selector;
 	int reason;
@@ -2839,6 +2840,15 @@ static int handle_task_switch(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 
 	reason = (u32)exit_qualification >> 30;
+	if (reason == TASK_SWITCH_GATE && vmx->vcpu.arch.nmi_injected &&
+	    (vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
+	    (vmx->idt_vectoring_info & VECTORING_INFO_TYPE_MASK)
+	    == INTR_TYPE_NMI_INTR) {
+		vcpu->arch.nmi_injected = false;
+		if (cpu_has_virtual_nmis())
+			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
+				      GUEST_INTR_STATE_NMI);
+	}
 	tss_selector = exit_qualification;
 
 	return kvm_task_switch(vcpu, tss_selector, reason);
@@ -3012,9 +3022,11 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
 			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
-			exit_reason != EXIT_REASON_EPT_VIOLATION))
-		printk(KERN_WARNING "%s: unexpected, valid vectoring info and "
-		       "exit reason is 0x%x\n", __func__, exit_reason);
+			exit_reason != EXIT_REASON_EPT_VIOLATION &&
+			exit_reason != EXIT_REASON_TASK_SWITCH))
+		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
+		       "(0x%x) and exit reason is 0x%x\n",
+		       __func__, vectoring_info, exit_reason);
 	if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu, kvm_run);
-- 
1.6.0.3


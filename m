Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYLHLw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYLHLw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYLHLij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48233 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 06/45] KVM: VMX: refactor/fix IRQ and NMI injectability determination
Date: Mon,  8 Dec 2008 13:36:17 +0200
Message-Id: <1228736216-15787-7-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

There are currently two ways in VMX to check if an IRQ or NMI can be
injected:
 - vmx_{nmi|irq}_enabled and
 - vcpu.arch.{nmi|interrupt}_window_open.
Even worse, one test (at the end of vmx_vcpu_run) uses an inconsistent,
likely incorrect logic.

This patch consolidates and unifies the tests over
{nmi|interrupt}_window_open as cache + vmx_update_window_states
for updating the cache content.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx.c              |   46 +++++++++++++++++---------------------
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8346be8..bfbbdea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -327,6 +327,7 @@ struct kvm_vcpu_arch {
 
 	bool nmi_pending;
 	bool nmi_injected;
+	bool nmi_window_open;
 
 	u64 mtrr[0x100];
 };
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 8d0fc68..f0866e1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2362,6 +2362,21 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 }
 
+static void vmx_update_window_states(struct kvm_vcpu *vcpu)
+{
+	u32 guest_intr = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+
+	vcpu->arch.nmi_window_open =
+		!(guest_intr & (GUEST_INTR_STATE_STI |
+				GUEST_INTR_STATE_MOV_SS |
+				GUEST_INTR_STATE_NMI));
+
+	vcpu->arch.interrupt_window_open =
+		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
+		 !(guest_intr & (GUEST_INTR_STATE_STI |
+				 GUEST_INTR_STATE_MOV_SS)));
+}
+
 static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 {
 	int word_index = __ffs(vcpu->arch.irq_summary);
@@ -2374,15 +2389,12 @@ static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 	kvm_queue_interrupt(vcpu, irq);
 }
 
-
 static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 				       struct kvm_run *kvm_run)
 {
 	u32 cpu_based_vm_exec_control;
 
-	vcpu->arch.interrupt_window_open =
-		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
-		 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0);
+	vmx_update_window_states(vcpu);
 
 	if (vcpu->arch.interrupt_window_open &&
 	    vcpu->arch.irq_summary && !vcpu->arch.interrupt.pending)
@@ -3075,22 +3087,6 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
 }
 
-static int vmx_nmi_enabled(struct kvm_vcpu *vcpu)
-{
-	u32 guest_intr = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
-	return !(guest_intr & (GUEST_INTR_STATE_NMI |
-			       GUEST_INTR_STATE_MOV_SS |
-			       GUEST_INTR_STATE_STI));
-}
-
-static int vmx_irq_enabled(struct kvm_vcpu *vcpu)
-{
-	u32 guest_intr = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
-	return (!(guest_intr & (GUEST_INTR_STATE_MOV_SS |
-			       GUEST_INTR_STATE_STI)) &&
-		(vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF));
-}
-
 static void enable_intr_window(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.nmi_pending)
@@ -3159,11 +3155,13 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 {
 	update_tpr_threshold(vcpu);
 
+	vmx_update_window_states(vcpu);
+
 	if (cpu_has_virtual_nmis()) {
 		if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
 			if (vcpu->arch.interrupt.pending) {
 				enable_nmi_window(vcpu);
-			} else if (vmx_nmi_enabled(vcpu)) {
+			} else if (vcpu->arch.nmi_window_open) {
 				vcpu->arch.nmi_pending = false;
 				vcpu->arch.nmi_injected = true;
 			} else {
@@ -3178,7 +3176,7 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 		}
 	}
 	if (!vcpu->arch.interrupt.pending && kvm_cpu_has_interrupt(vcpu)) {
-		if (vmx_irq_enabled(vcpu))
+		if (vcpu->arch.interrupt_window_open)
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
 		else
 			enable_irq_window(vcpu);
@@ -3339,9 +3337,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (vmx->rmode.irq.pending)
 		fixup_rmode_irq(vmx);
 
-	vcpu->arch.interrupt_window_open =
-		(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-		 (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)) == 0;
+	vmx_update_window_states(vcpu);
 
 	asm("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 	vmx->launched = 1;
-- 
1.6.0.3


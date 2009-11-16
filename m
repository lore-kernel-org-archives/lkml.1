Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZKPMUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZKPMUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZKPMUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbZKPMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:41 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 21/42] KVM: VMX: Enhance invalid guest state emulation
Date: Mon, 16 Nov 2009 14:19:22 +0200
Message-Id: <1258373983-8693-22-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

- Change returned handle_invalid_guest_state() to return relevant exit codes
- Move triggering the emulation from vmx_vcpu_run() to vmx_handle_exit()
- Return to userspace instead of repeatedly trying to emulate instructions that have already failed

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |   44 ++++++++++++++++++++------------------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4635298..73cb5dd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -107,7 +107,6 @@ struct vcpu_vmx {
 	} rmode;
 	int vpid;
 	bool emulation_required;
-	enum emulation_result invalid_state_emulation_result;
 
 	/* Support for vnmi-less CPUs */
 	int soft_vnmi_blocked;
@@ -3322,35 +3321,37 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static void handle_invalid_guest_state(struct kvm_vcpu *vcpu)
+static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	enum emulation_result err = EMULATE_DONE;
-
-	local_irq_enable();
-	preempt_enable();
+	int ret = 1;
 
 	while (!guest_state_valid(vcpu)) {
 		err = emulate_instruction(vcpu, 0, 0, 0);
 
-		if (err == EMULATE_DO_MMIO)
-			break;
+		if (err == EMULATE_DO_MMIO) {
+			ret = 0;
+			goto out;
+		}
 
 		if (err != EMULATE_DONE) {
 			kvm_report_emulation_failure(vcpu, "emulation failure");
-			break;
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+			ret = 0;
+			goto out;
 		}
 
 		if (signal_pending(current))
-			break;
+			goto out;
 		if (need_resched())
 			schedule();
 	}
 
-	preempt_disable();
-	local_irq_disable();
-
-	vmx->invalid_state_emulation_result = err;
+	vmx->emulation_required = 0;
+out:
+	return ret;
 }
 
 /*
@@ -3406,13 +3407,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 
 	trace_kvm_exit(exit_reason, kvm_rip_read(vcpu));
 
-	/* If we need to emulate an MMIO from handle_invalid_guest_state
-	 * we just return 0 */
-	if (vmx->emulation_required && emulate_invalid_guest_state) {
-		if (guest_state_valid(vcpu))
-			vmx->emulation_required = 0;
-		return vmx->invalid_state_emulation_result != EMULATE_DO_MMIO;
-	}
+	/* If guest state is invalid, start emulating */
+	if (vmx->emulation_required && emulate_invalid_guest_state)
+		return handle_invalid_guest_state(vcpu);
 
 	/* Access CR3 don't cause VMExit in paging mode, so we need
 	 * to sync with guest real CR3. */
@@ -3607,11 +3604,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked))
 		vmx->entry_time = ktime_get();
 
-	/* Handle invalid guest state instead of entering VMX */
-	if (vmx->emulation_required && emulate_invalid_guest_state) {
-		handle_invalid_guest_state(vcpu);
+	/* Don't enter VMX if guest state is invalid, let the exit handler
+	   start emulation until we arrive back to a valid state */
+	if (vmx->emulation_required && emulate_invalid_guest_state)
 		return;
-	}
 
 	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
-- 
1.6.5.2


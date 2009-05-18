Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbZERJil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbZERJil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZERJYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38441 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZERJXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:12 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 43/43] KVM: Fix interrupt unhalting a vcpu when it shouldn't
Date: Mon, 18 May 2009 12:23:05 +0300
Message-Id: <1242638585-18470-44-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

kvm_vcpu_block() unhalts vpu on an interrupt/timer without checking
if interrupt window is actually opened.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c        |    6 ++++++
 arch/powerpc/kvm/powerpc.c      |    6 ++++++
 arch/s390/kvm/interrupt.c       |    6 ++++++
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/svm.c              |   10 ++++++++++
 arch/x86/kvm/vmx.c              |    8 +++++++-
 arch/x86/kvm/x86.c              |    5 +++++
 include/linux/kvm_host.h        |    1 +
 virt/kvm/kvm_main.c             |    3 ++-
 9 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d2a90fd..3bf0a34 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1963,6 +1963,12 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	/* do real check here */
+	return 1;
+}
+
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.timer_fired;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 9057335..2cf915e 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -41,6 +41,12 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	return !!(v->arch.pending_exceptions);
 }
 
+int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	/* do real check here */
+	return 1;
+}
+
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	return !(v->arch.msr & MSR_WE);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 0189356..4ed4c3a 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -318,6 +318,12 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
+int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	/* do real check here */
+	return 1;
+}
+
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4627627..8351c4d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -521,7 +521,7 @@ struct kvm_x86_ops {
 	void (*inject_pending_irq)(struct kvm_vcpu *vcpu);
 	void (*inject_pending_vectors)(struct kvm_vcpu *vcpu,
 				       struct kvm_run *run);
-
+	int (*interrupt_allowed)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
 	int (*get_mt_mask_shift)(void);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index aa528db..de74104 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2270,6 +2270,15 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 		vmcb->control.intercept_cr_write |= INTERCEPT_CR8_MASK;
 }
 
+static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
+	return (vmcb->save.rflags & X86_EFLAGS_IF) &&
+		!(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
+		(svm->vcpu.arch.hflags & HF_GIF_MASK);
+}
+
 static void svm_intr_assist(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2649,6 +2658,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.exception_injected = svm_exception_injected,
 	.inject_pending_irq = svm_intr_assist,
 	.inject_pending_vectors = do_interrupt_requests,
+	.interrupt_allowed = svm_interrupt_allowed,
 
 	.set_tss_addr = svm_set_tss_addr,
 	.get_tdp_level = get_npt_level,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index da6461d..b9e06b0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2490,6 +2490,12 @@ static void vmx_update_window_states(struct kvm_vcpu *vcpu)
 				 GUEST_INTR_STATE_MOV_SS)));
 }
 
+static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	vmx_update_window_states(vcpu);
+	return vcpu->arch.interrupt_window_open;
+}
+
 static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 				       struct kvm_run *kvm_run)
 {
@@ -3691,7 +3697,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.exception_injected = vmx_exception_injected,
 	.inject_pending_irq = vmx_intr_assist,
 	.inject_pending_vectors = do_interrupt_requests,
-
+	.interrupt_allowed = vmx_interrupt_allowed,
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
 	.get_mt_mask_shift = vmx_get_mt_mask_shift,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa8b585..ab61ea6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4471,3 +4471,8 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
 	put_cpu();
 }
+
+int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	return kvm_x86_ops->interrupt_allowed(vcpu);
+}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 40e49ed..72d5684 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -298,6 +298,7 @@ int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
+int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 
 void kvm_free_physmem(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ffe2826..3265566 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1610,7 +1610,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	for (;;) {
 		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
-		if (kvm_cpu_has_interrupt(vcpu) ||
+		if ((kvm_arch_interrupt_allowed(vcpu) &&
+					kvm_cpu_has_interrupt(vcpu)) ||
 				kvm_arch_vcpu_runnable(vcpu)) {
 			set_bit(KVM_REQ_UNHALT, &vcpu->requests);
 			break;
-- 
1.6.0.6


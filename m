Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbZETLYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbZETLYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbZETLTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55298 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbZETLSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:52 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 46/46] KVM: Remove exception_injected() callback.
Date: Wed, 20 May 2009 14:18:43 +0300
Message-Id: <1242818323-10413-47-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

It always return false for VMX/SVM now.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/svm.c              |    6 ------
 arch/x86/kvm/vmx.c              |    6 ------
 arch/x86/kvm/x86.c              |    2 --
 4 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5edae35..ea3741e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -516,7 +516,6 @@ struct kvm_x86_ops {
 	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
 	void (*queue_exception)(struct kvm_vcpu *vcpu, unsigned nr,
 				bool has_error_code, u32 error_code);
-	bool (*exception_injected)(struct kvm_vcpu *vcpu);
 	void (*inject_pending_irq)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	void (*inject_pending_vectors)(struct kvm_vcpu *vcpu,
 				       struct kvm_run *run);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a80ffaa..8fa5a0e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -196,11 +196,6 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 	svm->vmcb->control.event_inj_err = error_code;
 }
 
-static bool svm_exception_injected(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
-
 static int is_external_interrupt(u32 info)
 {
 	info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
@@ -2659,7 +2654,6 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.get_irq = svm_get_irq,
 	.set_irq = svm_set_irq,
 	.queue_exception = svm_queue_exception,
-	.exception_injected = svm_exception_injected,
 	.inject_pending_irq = svm_intr_assist,
 	.inject_pending_vectors = svm_intr_assist,
 	.interrupt_allowed = svm_interrupt_allowed,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9eb518f..3186fcf 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -789,11 +789,6 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 }
 
-static bool vmx_exception_injected(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
-
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
@@ -3697,7 +3692,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.get_irq = vmx_get_irq,
 	.set_irq = vmx_inject_irq,
 	.queue_exception = vmx_queue_exception,
-	.exception_injected = vmx_exception_injected,
 	.inject_pending_irq = vmx_intr_assist,
 	.inject_pending_vectors = vmx_intr_assist,
 	.interrupt_allowed = vmx_interrupt_allowed,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28919d2..2683d7e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3233,8 +3233,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		profile_hit(KVM_PROFILING, (void *)rip);
 	}
 
-	if (vcpu->arch.exception.pending && kvm_x86_ops->exception_injected(vcpu))
-		vcpu->arch.exception.pending = false;
 
 	kvm_lapic_sync_from_vapic(vcpu);
 
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZETLVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZETLVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZETLTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55296 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbZETLSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:52 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 41/46] KVM: Make kvm_cpu_(has|get)_interrupt() work for userspace irqchip too
Date: Wed, 20 May 2009 14:18:38 +0300
Message-Id: <1242818323-10413-42-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

At the vector level, kernel and userspace irqchip are fairly similar.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/irq.c |    7 +++++++
 arch/x86/kvm/svm.c |   11 +++++++----
 arch/x86/kvm/vmx.c |   18 +++++++++---------
 arch/x86/kvm/x86.c |    4 ++--
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index cf17ed5..11c2757 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -24,6 +24,7 @@
 
 #include "irq.h"
 #include "i8254.h"
+#include "x86.h"
 
 /*
  * check if there are pending timer events
@@ -48,6 +49,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 {
 	struct kvm_pic *s;
 
+	if (!irqchip_in_kernel(v->kvm))
+		return v->arch.irq_summary;
+
 	if (kvm_apic_has_interrupt(v) == -1) {	/* LAPIC */
 		if (kvm_apic_accept_pic_intr(v)) {
 			s = pic_irqchip(v->kvm);	/* PIC */
@@ -67,6 +71,9 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 	struct kvm_pic *s;
 	int vector;
 
+	if (!irqchip_in_kernel(v->kvm))
+		return kvm_pop_irq(v);
+
 	vector = kvm_get_apic_interrupt(v);	/* APIC */
 	if (vector == -1) {
 		if (kvm_apic_accept_pic_intr(v)) {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8fc6eea..6eef6d2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2091,8 +2091,9 @@ static int interrupt_window_interception(struct vcpu_svm *svm,
 	 * If the user space waits to inject interrupts, exit as soon as
 	 * possible
 	 */
-	if (kvm_run->request_interrupt_window &&
-	    !svm->vcpu.arch.irq_summary) {
+	if (!irqchip_in_kernel(svm->vcpu.kvm) &&
+	    kvm_run->request_interrupt_window &&
+	    !kvm_cpu_has_interrupt(&svm->vcpu)) {
 		++svm->vcpu.stat.irq_window_exits;
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		return 0;
@@ -2373,7 +2374,8 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 		 (svm->vmcb->save.rflags & X86_EFLAGS_IF) &&
 		 (svm->vcpu.arch.hflags & HF_GIF_MASK));
 
-	if (svm->vcpu.arch.interrupt_window_open && svm->vcpu.arch.irq_summary)
+	if (svm->vcpu.arch.interrupt_window_open &&
+	    kvm_cpu_has_interrupt(&svm->vcpu))
 		/*
 		 * If interrupts enabled, and not blocked by sti or mov ss. Good.
 		 */
@@ -2383,7 +2385,8 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 	 * Interrupts blocked.  Wait for unblock.
 	 */
 	if (!svm->vcpu.arch.interrupt_window_open &&
-	    (svm->vcpu.arch.irq_summary || kvm_run->request_interrupt_window))
+	    (kvm_cpu_has_interrupt(&svm->vcpu) ||
+	     kvm_run->request_interrupt_window))
 		svm_set_vintr(svm);
 	else
 		svm_clear_vintr(svm);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c6997c0..b3292c1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2535,21 +2535,20 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 		vmx_inject_nmi(vcpu);
 		if (vcpu->arch.nmi_pending)
 			enable_nmi_window(vcpu);
-		else if (vcpu->arch.irq_summary
-			 || kvm_run->request_interrupt_window)
+		else if (kvm_cpu_has_interrupt(vcpu) ||
+			 kvm_run->request_interrupt_window)
 			enable_irq_window(vcpu);
 		return;
 	}
 
 	if (vcpu->arch.interrupt_window_open) {
-		if (vcpu->arch.irq_summary && !vcpu->arch.interrupt.pending)
-			kvm_queue_interrupt(vcpu, kvm_pop_irq(vcpu));
+		if (kvm_cpu_has_interrupt(vcpu) && !vcpu->arch.interrupt.pending)
+			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
 
 		if (vcpu->arch.interrupt.pending)
 			vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
-	}
-	if (!vcpu->arch.interrupt_window_open &&
-	    (vcpu->arch.irq_summary || kvm_run->request_interrupt_window))
+	} else if(kvm_cpu_has_interrupt(vcpu) ||
+		  kvm_run->request_interrupt_window)
 		enable_irq_window(vcpu);
 }
 
@@ -2976,8 +2975,9 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 	 * If the user space waits to inject interrupts, exit as soon as
 	 * possible
 	 */
-	if (kvm_run->request_interrupt_window &&
-	    !vcpu->arch.irq_summary) {
+	if (!irqchip_in_kernel(vcpu->kvm) &&
+	    kvm_run->request_interrupt_window &&
+	    !kvm_cpu_has_interrupt(vcpu)) {
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		return 0;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6fc53bb..0c9c13c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3065,7 +3065,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
 					  struct kvm_run *kvm_run)
 {
-	return (!vcpu->arch.irq_summary &&
+	return (!irqchip_in_kernel(vcpu->kvm) && !kvm_cpu_has_interrupt(vcpu) &&
 		kvm_run->request_interrupt_window &&
 		vcpu->arch.interrupt_window_open &&
 		(kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF));
@@ -3082,7 +3082,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 	else
 		kvm_run->ready_for_interrupt_injection =
 					(vcpu->arch.interrupt_window_open &&
-					 vcpu->arch.irq_summary == 0);
+					 !kvm_cpu_has_interrupt(vcpu));
 }
 
 static void vapic_enter(struct kvm_vcpu *vcpu)
-- 
1.6.0.6


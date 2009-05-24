Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZEXPwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZEXPwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZEXPvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41862 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 42/45] KVM: inject NMI after IRET from a previous NMI, not before.
Date: Sun, 24 May 2009 18:50:27 +0300
Message-Id: <1243180230-2480-43-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

If NMI is received during handling of another NMI it should be injected
immediately after IRET from previous NMI handler, but SVM intercept IRET
before instruction execution so we can't inject pending NMI at this
point and there is not way to request exit when NMI window opens. This
patch fix SVM code to open NMI window after IRET by single stepping over
IRET instruction.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/svm.c              |   62 +++++++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d6c3f7..8212943 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -358,6 +358,7 @@ struct kvm_vcpu_arch {
 	unsigned int time_offset;
 	struct page *time_page;
 
+	bool singlestep; /* guest is single stepped by KVM */
 	bool nmi_pending;
 	bool nmi_injected;
 
@@ -771,6 +772,7 @@ enum {
 #define HF_HIF_MASK		(1 << 1)
 #define HF_VINTR_MASK		(1 << 2)
 #define HF_NMI_MASK		(1 << 3)
+#define HF_IRET_MASK		(1 << 4)
 
 /*
  * Hardware virtualization extension instructions may fault if a
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 377c4f1..71510e0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -965,15 +965,16 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 
 }
 
-static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
+static void update_db_intercept(struct kvm_vcpu *vcpu)
 {
-	int old_debug = vcpu->guest_debug;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	vcpu->guest_debug = dbg->control;
-
 	svm->vmcb->control.intercept_exceptions &=
 		~((1 << DB_VECTOR) | (1 << BP_VECTOR));
+
+	if (vcpu->arch.singlestep)
+		svm->vmcb->control.intercept_exceptions |= (1 << DB_VECTOR);
+
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
 		if (vcpu->guest_debug &
 		    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
@@ -984,6 +985,16 @@ static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 				1 << BP_VECTOR;
 	} else
 		vcpu->guest_debug = 0;
+}
+
+static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
+{
+	int old_debug = vcpu->guest_debug;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	vcpu->guest_debug = dbg->control;
+
+	update_db_intercept(vcpu);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
 		svm->vmcb->save.dr7 = dbg->arch.debugreg[7];
@@ -1133,14 +1144,30 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int db_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	if (!(svm->vcpu.guest_debug &
-	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
+	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
+		!svm->vcpu.arch.singlestep) {
 		kvm_queue_exception(&svm->vcpu, DB_VECTOR);
 		return 1;
 	}
-	kvm_run->exit_reason = KVM_EXIT_DEBUG;
-	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
-	kvm_run->debug.arch.exception = DB_VECTOR;
-	return 0;
+
+	if (svm->vcpu.arch.singlestep) {
+		svm->vcpu.arch.singlestep = false;
+		if (!(svm->vcpu.guest_debug & KVM_GUESTDBG_SINGLESTEP))
+			svm->vmcb->save.rflags &=
+				~(X86_EFLAGS_TF | X86_EFLAGS_RF);
+		update_db_intercept(&svm->vcpu);
+	}
+
+	if (svm->vcpu.guest_debug &
+	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)){
+		kvm_run->exit_reason = KVM_EXIT_DEBUG;
+		kvm_run->debug.arch.pc =
+			svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+		kvm_run->debug.arch.exception = DB_VECTOR;
+		return 0;
+	}
+
+	return 1;
 }
 
 static int bp_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
@@ -1887,7 +1914,7 @@ static int iret_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	++svm->vcpu.stat.nmi_window_exits;
 	svm->vmcb->control.intercept &= ~(1UL << INTERCEPT_IRET);
-	svm->vcpu.arch.hflags &= ~HF_NMI_MASK;
+	svm->vcpu.arch.hflags |= HF_IRET_MASK;
 	return 1;
 }
 
@@ -2357,8 +2384,16 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (svm->vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK)
-		enable_irq_window(vcpu);
+	if ((svm->vcpu.arch.hflags & (HF_NMI_MASK | HF_IRET_MASK))
+	    == HF_NMI_MASK)
+		return; /* IRET will cause a vm exit */
+
+	/* Something prevents NMI from been injected. Single step over
+	   possible problem (IRET or exception injection or interrupt
+	   shadow) */
+	vcpu->arch.singlestep = true;
+	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
+	update_db_intercept(vcpu);
 }
 
 static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
@@ -2401,6 +2436,9 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 	int type;
 	u32 exitintinfo = svm->vmcb->control.exit_int_info;
 
+	if (svm->vcpu.arch.hflags & HF_IRET_MASK)
+		svm->vcpu.arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
+
 	svm->vcpu.arch.nmi_injected = false;
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
-- 
1.6.0.6


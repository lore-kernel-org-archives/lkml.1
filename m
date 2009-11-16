Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZKPMWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZKPMWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZKPMUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 34/42] KVM: x86: Refactor guest debug IOCTL handling
Date: Mon, 16 Nov 2009 14:19:35 +0200
Message-Id: <1258373983-8693-35-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

Much of so far vendor-specific code for setting up guest debug can
actually be handled by the generic code. This also fixes a minor deficit
in the SVM part /wrt processing KVM_GUESTDBG_ENABLE.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++--
 arch/x86/kvm/svm.c              |   14 ++------------
 arch/x86/kvm/vmx.c              |   18 +-----------------
 arch/x86/kvm/x86.c              |   28 +++++++++++++++++++++-------
 4 files changed, 26 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 295c7c4..e7f8708 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -475,8 +475,8 @@ struct kvm_x86_ops {
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
-	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
-			       struct kvm_guest_debug *dbg);
+	void (*set_guest_debug)(struct kvm_vcpu *vcpu,
+				struct kvm_guest_debug *dbg);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
 	int (*set_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 02a4269..279a2ae 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1065,26 +1065,16 @@ static void update_db_intercept(struct kvm_vcpu *vcpu)
 		vcpu->guest_debug = 0;
 }
 
-static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
+static void svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 {
-	int old_debug = vcpu->guest_debug;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	vcpu->guest_debug = dbg->control;
-
-	update_db_intercept(vcpu);
-
 	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
 		svm->vmcb->save.dr7 = dbg->arch.debugreg[7];
 	else
 		svm->vmcb->save.dr7 = vcpu->arch.dr7;
 
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		svm->vmcb->save.rflags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
-	else if (old_debug & KVM_GUESTDBG_SINGLESTEP)
-		svm->vmcb->save.rflags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
-
-	return 0;
+	update_db_intercept(vcpu);
 }
 
 static void load_host_msrs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 97f4265..70020e5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1096,30 +1096,14 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
+static void set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 {
-	int old_debug = vcpu->guest_debug;
-	unsigned long flags;
-
-	vcpu->guest_debug = dbg->control;
-	if (!(vcpu->guest_debug & KVM_GUESTDBG_ENABLE))
-		vcpu->guest_debug = 0;
-
 	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
 		vmcs_writel(GUEST_DR7, dbg->arch.debugreg[7]);
 	else
 		vmcs_writel(GUEST_DR7, vcpu->arch.dr7);
 
-	flags = vmcs_readl(GUEST_RFLAGS);
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		flags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
-	else if (old_debug & KVM_GUESTDBG_SINGLESTEP)
-		flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
-	vmcs_writel(GUEST_RFLAGS, flags);
-
 	update_exception_bitmap(vcpu);
-
-	return 0;
 }
 
 static __init int cpu_has_kvm_support(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f44d56..a06f88e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4472,12 +4472,19 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
-	int i, r;
+	unsigned long rflags;
+	int old_debug;
+	int i;
 
 	vcpu_load(vcpu);
 
-	if ((dbg->control & (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP)) ==
-	    (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP)) {
+	old_debug = vcpu->guest_debug;
+
+	vcpu->guest_debug = dbg->control;
+	if (!(vcpu->guest_debug & KVM_GUESTDBG_ENABLE))
+		vcpu->guest_debug = 0;
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
 		for (i = 0; i < KVM_NR_DB_REGS; ++i)
 			vcpu->arch.eff_db[i] = dbg->arch.debugreg[i];
 		vcpu->arch.switch_db_regs =
@@ -4488,16 +4495,23 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 		vcpu->arch.switch_db_regs = (vcpu->arch.dr7 & DR7_BP_EN_MASK);
 	}
 
-	r = kvm_x86_ops->set_guest_debug(vcpu, dbg);
+	rflags = kvm_x86_ops->get_rflags(vcpu);
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		rflags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
+	else if (old_debug & KVM_GUESTDBG_SINGLESTEP)
+		rflags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
+	kvm_x86_ops->set_rflags(vcpu, rflags);
 
-	if (dbg->control & KVM_GUESTDBG_INJECT_DB)
+	kvm_x86_ops->set_guest_debug(vcpu, dbg);
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_INJECT_DB)
 		kvm_queue_exception(vcpu, DB_VECTOR);
-	else if (dbg->control & KVM_GUESTDBG_INJECT_BP)
+	else if (vcpu->guest_debug & KVM_GUESTDBG_INJECT_BP)
 		kvm_queue_exception(vcpu, BP_VECTOR);
 
 	vcpu_put(vcpu);
 
-	return r;
+	return 0;
 }
 
 /*
-- 
1.6.5.2


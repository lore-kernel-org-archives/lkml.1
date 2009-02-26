Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbZBZO3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbZBZO3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZBZORW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43078 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 16/40] KVM: x86: Wire-up hardware breakpoints for guest debugging
Date: Thu, 26 Feb 2009 16:15:06 +0200
Message-Id: <1235657730-27683-17-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Add the remaining bits to make use of debug registers also for guest
debugging, thus enabling the use of hardware breakpoints and
watchpoints.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    5 +++++
 arch/x86/kvm/vmx.c |    5 +++++
 arch/x86/kvm/x86.c |   14 +++++++++++++-
 3 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 815f50e..b3a7a31 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -958,6 +958,11 @@ static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 	} else
 		vcpu->guest_debug = 0;
 
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		svm->vmcb->save.dr7 = dbg->arch.debugreg[7];
+	else
+		svm->vmcb->save.dr7 = vcpu->arch.dr7;
+
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		svm->vmcb->save.rflags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
 	else if (old_debug & KVM_GUESTDBG_SINGLESTEP)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0989776..cee81c9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1017,6 +1017,11 @@ static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 	if (!(vcpu->guest_debug & KVM_GUESTDBG_ENABLE))
 		vcpu->guest_debug = 0;
 
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		vmcs_writel(GUEST_DR7, dbg->arch.debugreg[7]);
+	else
+		vmcs_writel(GUEST_DR7, vcpu->arch.dr7);
+
 	flags = vmcs_readl(GUEST_RFLAGS);
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		flags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 300bc4d..2477e87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3861,10 +3861,22 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
-	int r;
+	int i, r;
 
 	vcpu_load(vcpu);
 
+	if ((dbg->control & (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP)) ==
+	    (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP)) {
+		for (i = 0; i < KVM_NR_DB_REGS; ++i)
+			vcpu->arch.eff_db[i] = dbg->arch.debugreg[i];
+		vcpu->arch.switch_db_regs =
+			(dbg->arch.debugreg[7] & DR7_BP_EN_MASK);
+	} else {
+		for (i = 0; i < KVM_NR_DB_REGS; i++)
+			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
+		vcpu->arch.switch_db_regs = (vcpu->arch.dr7 & DR7_BP_EN_MASK);
+	}
+
 	r = kvm_x86_ops->set_guest_debug(vcpu, dbg);
 
 	if (dbg->control & KVM_GUESTDBG_INJECT_DB)
-- 
1.6.0.6


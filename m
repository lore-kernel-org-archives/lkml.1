Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZKSNj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZKSNj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbZKSNj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 12/35] KVM: x86: Fix guest single-stepping while interruptible
Date: Thu, 19 Nov 2009 15:34:48 +0200
Message-Id: <1258637711-11674-13-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

Commit 705c5323 opened the doors of hell by unconditionally injecting
single-step flags as long as guest_debug signaled this. This doesn't
work when the guest branches into some interrupt or exception handler
and triggers a vmexit with flag reloading.

Fix it by saving cs:rip when user space requests single-stepping and
restricting the trace flag injection to this guest code position.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 +++
 arch/x86/kvm/x86.c              |   47 +++++++++++++++++++++++---------------
 2 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 36f3b53..2536fbd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -371,6 +371,10 @@ struct kvm_vcpu_arch {
 	u64 mcg_status;
 	u64 mcg_ctl;
 	u64 *mce_banks;
+
+	/* used for guest single stepping over the given code position */
+	u16 singlestep_cs;
+	unsigned long singlestep_rip;
 };
 
 struct kvm_mem_alias {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb842db..13f30aa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -235,25 +235,6 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 }
 EXPORT_SYMBOL_GPL(kvm_require_cpl);
 
-unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
-{
-	unsigned long rflags;
-
-	rflags = kvm_x86_ops->get_rflags(vcpu);
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		rflags &= ~(unsigned long)(X86_EFLAGS_TF | X86_EFLAGS_RF);
-	return rflags;
-}
-EXPORT_SYMBOL_GPL(kvm_get_rflags);
-
-void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
-{
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		rflags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
-	kvm_x86_ops->set_rflags(vcpu, rflags);
-}
-EXPORT_SYMBOL_GPL(kvm_set_rflags);
-
 /*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
@@ -4565,6 +4546,12 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 		vcpu->arch.switch_db_regs = (vcpu->arch.dr7 & DR7_BP_EN_MASK);
 	}
 
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+		vcpu->arch.singlestep_cs =
+			get_segment_selector(vcpu, VCPU_SREG_CS);
+		vcpu->arch.singlestep_rip = kvm_rip_read(vcpu);
+	}
+
 	/*
 	 * Trigger an rflags update that will inject or remove the trace
 	 * flags.
@@ -5031,6 +5018,28 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 	return kvm_x86_ops->interrupt_allowed(vcpu);
 }
 
+unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
+{
+	unsigned long rflags;
+
+	rflags = kvm_x86_ops->get_rflags(vcpu);
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		rflags &= ~(unsigned long)(X86_EFLAGS_TF | X86_EFLAGS_RF);
+	return rflags;
+}
+EXPORT_SYMBOL_GPL(kvm_get_rflags);
+
+void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
+{
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
+	    vcpu->arch.singlestep_cs ==
+			get_segment_selector(vcpu, VCPU_SREG_CS) &&
+	    vcpu->arch.singlestep_rip == kvm_rip_read(vcpu))
+		rflags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
+	kvm_x86_ops->set_rflags(vcpu, rflags);
+}
+EXPORT_SYMBOL_GPL(kvm_set_rflags);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
-- 
1.6.5.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab0BPKnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:43:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/38] KVM: VMX: Clean up DR6 emulation
Date: Tue, 16 Feb 2010 12:35:06 +0200
Message-Id: <1266316536-28936-9-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

As we trap all debug register accesses, we do not need to switch real
DR6 at all. Clean up update_exception_bitmap at this chance, too.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c7b99e1..b7e812e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -579,17 +579,12 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	u32 eb;
 
-	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR)
-		| (1u << NM_VECTOR);
-	/*
-	 * Unconditionally intercept #DB so we can maintain dr6 without
-	 * reading it every exit.
-	 */
-	eb |= 1u << DB_VECTOR;
-	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
-			eb |= 1u << BP_VECTOR;
-	}
+	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR) |
+	     (1u << NM_VECTOR) | (1u << DB_VECTOR);
+	if ((vcpu->guest_debug &
+	     (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)) ==
+	    (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP))
+		eb |= 1u << BP_VECTOR;
 	if (to_vmx(vcpu)->rmode.vm86_active)
 		eb = ~0;
 	if (enable_ept)
@@ -3777,9 +3772,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	vmcs_writel(HOST_CR0, read_cr0());
 
-	if (vcpu->arch.switch_db_regs)
-		set_debugreg(vcpu->arch.dr6, 6);
-
 	asm(
 		/* Store host registers */
 		"push %%"R"dx; push %%"R"bp;"
@@ -3880,9 +3872,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 				  | (1 << VCPU_EXREG_PDPTR));
 	vcpu->arch.regs_dirty = 0;
 
-	if (vcpu->arch.switch_db_regs)
-		get_debugreg(vcpu->arch.dr6, 6);
-
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 	if (vmx->rmode.irq.pending)
 		fixup_rmode_irq(vmx);
-- 
1.6.5.3


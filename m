Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYIYMAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYIYMAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYIYLzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48551 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834AbYIYLzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:41 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 12/39] KVM: VMX: Modify mode switching and vmentry functions
Date: Thu, 25 Sep 2008 14:54:44 +0300
Message-Id: <1222343711-12508-13-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

This patch modifies mode switching and vmentry function in order to
drive invalid guest state emulation.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index eae1f2c..9840f37 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1298,7 +1298,9 @@ static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
 static void enter_pmode(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	vmx->emulation_required = 1;
 	vcpu->arch.rmode.active = 0;
 
 	vmcs_writel(GUEST_TR_BASE, vcpu->arch.rmode.tr.base);
@@ -1315,6 +1317,9 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 
 	update_exception_bitmap(vcpu);
 
+	if (emulate_invalid_guest_state)
+		return;
+
 	fix_pmode_dataseg(VCPU_SREG_ES, &vcpu->arch.rmode.es);
 	fix_pmode_dataseg(VCPU_SREG_DS, &vcpu->arch.rmode.ds);
 	fix_pmode_dataseg(VCPU_SREG_GS, &vcpu->arch.rmode.gs);
@@ -1355,7 +1360,9 @@ static void fix_rmode_seg(int seg, struct kvm_save_segment *save)
 static void enter_rmode(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	vmx->emulation_required = 1;
 	vcpu->arch.rmode.active = 1;
 
 	vcpu->arch.rmode.tr.base = vmcs_readl(GUEST_TR_BASE);
@@ -1377,6 +1384,9 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);
 	update_exception_bitmap(vcpu);
 
+	if (emulate_invalid_guest_state)
+		goto continue_rmode;
+
 	vmcs_write16(GUEST_SS_SELECTOR, vmcs_readl(GUEST_SS_BASE) >> 4);
 	vmcs_write32(GUEST_SS_LIMIT, 0xffff);
 	vmcs_write32(GUEST_SS_AR_BYTES, 0xf3);
@@ -1392,6 +1402,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	fix_rmode_seg(VCPU_SREG_GS, &vcpu->arch.rmode.gs);
 	fix_rmode_seg(VCPU_SREG_FS, &vcpu->arch.rmode.fs);
 
+continue_rmode:
 	kvm_mmu_reset_context(vcpu);
 	init_rmode(vcpu->kvm);
 }
@@ -2317,6 +2328,9 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	ret = 0;
 
+	/* HACK: Don't enable emulation on guest boot/reset */
+	vmx->emulation_required = 0;
+
 out:
 	up_read(&vcpu->kvm->slots_lock);
 	return ret;
@@ -3190,6 +3204,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 intr_info;
 
+	/* Handle invalid guest state instead of entering VMX */
+	if (vmx->emulation_required && emulate_invalid_guest_state) {
+		handle_invalid_guest_state(vcpu, kvm_run);
+		return;
+	}
+
 	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
 	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
-- 
1.6.0.1


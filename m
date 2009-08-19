Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZHSNJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZHSNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZHSNJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50564 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751962AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/47] KVM: x86 emulator: Add sysexit emulation
Date: Wed, 19 Aug 2009 16:02:26 +0300
Message-Id: <1250686963-8357-31-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Handle #UD intercept of the sysexit instruction in 64bit mode returning to
32bit compat mode on an AMD host.
Setup the segment descriptors for CS and SS and the EIP/ESP registers
according to the manual.

Signed-off-by: Christoph Egger <christoph.egger@amd.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   72 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 7a9bddb..c6663d4 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1541,6 +1541,73 @@ emulate_sysenter(struct x86_emulate_ctxt *ctxt)
 	return 0;
 }
 
+static int
+emulate_sysexit(struct x86_emulate_ctxt *ctxt)
+{
+	struct decode_cache *c = &ctxt->decode;
+	struct kvm_segment cs, ss;
+	u64 msr_data;
+	int usermode;
+
+	/* inject #UD if LOCK prefix is used */
+	if (c->lock_prefix)
+		return -1;
+
+	/* inject #GP if in real mode or paging is disabled */
+	if (ctxt->mode == X86EMUL_MODE_REAL
+		|| !(ctxt->vcpu->arch.cr0 & X86_CR0_PE)) {
+		kvm_inject_gp(ctxt->vcpu, 0);
+		return -1;
+	}
+
+	/* sysexit must be called from CPL 0 */
+	if (kvm_x86_ops->get_cpl(ctxt->vcpu) != 0) {
+		kvm_inject_gp(ctxt->vcpu, 0);
+		return -1;
+	}
+
+	setup_syscalls_segments(ctxt, &cs, &ss);
+
+	if ((c->rex_prefix & 0x8) != 0x0)
+		usermode = X86EMUL_MODE_PROT64;
+	else
+		usermode = X86EMUL_MODE_PROT32;
+
+	cs.dpl = 3;
+	ss.dpl = 3;
+	kvm_x86_ops->get_msr(ctxt->vcpu, MSR_IA32_SYSENTER_CS, &msr_data);
+	switch (usermode) {
+	case X86EMUL_MODE_PROT32:
+		cs.selector = (u16)(msr_data + 16);
+		if ((msr_data & 0xfffc) == 0x0) {
+			kvm_inject_gp(ctxt->vcpu, 0);
+			return -1;
+		}
+		ss.selector = (u16)(msr_data + 24);
+		break;
+	case X86EMUL_MODE_PROT64:
+		cs.selector = (u16)(msr_data + 32);
+		if (msr_data == 0x0) {
+			kvm_inject_gp(ctxt->vcpu, 0);
+			return -1;
+		}
+		ss.selector = cs.selector + 8;
+		cs.db = 0;
+		cs.l = 1;
+		break;
+	}
+	cs.selector |= SELECTOR_RPL_MASK;
+	ss.selector |= SELECTOR_RPL_MASK;
+
+	kvm_x86_ops->set_segment(ctxt->vcpu, &cs, VCPU_SREG_CS);
+	kvm_x86_ops->set_segment(ctxt->vcpu, &ss, VCPU_SREG_SS);
+
+	c->eip = ctxt->vcpu->arch.regs[VCPU_REGS_RDX];
+	c->regs[VCPU_REGS_RSP] = ctxt->vcpu->arch.regs[VCPU_REGS_RCX];
+
+	return 0;
+}
+
 int
 x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
@@ -2215,7 +2282,10 @@ twobyte_insn:
 			goto writeback;
 		break;
 	case 0x35:		/* sysexit */
-		goto cannot_emulate;
+		if (emulate_sysexit(ctxt) == -1)
+			goto cannot_emulate;
+		else
+			goto writeback;
 		break;
 	case 0x40 ... 0x4f:	/* cmov */
 		c->dst.val = c->dst.orig_val = c->src.val;
-- 
1.6.3.3


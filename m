Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZHSNJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZHSNJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZHSNJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50569 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751968AbZHSNCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/47] KVM: x86 emulator: add syscall emulation
Date: Wed, 19 Aug 2009 16:02:24 +0300
Message-Id: <1250686963-8357-29-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Handle #UD intercept of the syscall instruction in 32bit compat mode on
an Intel host.
Setup the segment descriptors for CS and SS and the EIP/ESP registers
according to the manual. Save the RIP and EFLAGS to the correct registers.

[avi: fix build on i386 due to missing R11]

Signed-off-by: Christoph Egger <christoph.egger@amd.com>
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   84 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index b0da29d..4d7256d 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1397,6 +1397,85 @@ static void toggle_interruptibility(struct x86_emulate_ctxt *ctxt, u32 mask)
 		ctxt->interruptibility = mask;
 }
 
+static inline void
+setup_syscalls_segments(struct x86_emulate_ctxt *ctxt,
+	struct kvm_segment *cs, struct kvm_segment *ss)
+{
+	memset(cs, 0, sizeof(struct kvm_segment));
+	kvm_x86_ops->get_segment(ctxt->vcpu, cs, VCPU_SREG_CS);
+	memset(ss, 0, sizeof(struct kvm_segment));
+
+	cs->l = 0;		/* will be adjusted later */
+	cs->base = 0;		/* flat segment */
+	cs->g = 1;		/* 4kb granularity */
+	cs->limit = 0xffffffff;	/* 4GB limit */
+	cs->type = 0x0b;	/* Read, Execute, Accessed */
+	cs->s = 1;
+	cs->dpl = 0;		/* will be adjusted later */
+	cs->present = 1;
+	cs->db = 1;
+
+	ss->unusable = 0;
+	ss->base = 0;		/* flat segment */
+	ss->limit = 0xffffffff;	/* 4GB limit */
+	ss->g = 1;		/* 4kb granularity */
+	ss->s = 1;
+	ss->type = 0x03;	/* Read/Write, Accessed */
+	ss->db = 1;		/* 32bit stack segment */
+	ss->dpl = 0;
+	ss->present = 1;
+}
+
+static int
+emulate_syscall(struct x86_emulate_ctxt *ctxt)
+{
+	struct decode_cache *c = &ctxt->decode;
+	struct kvm_segment cs, ss;
+	u64 msr_data;
+
+	/* syscall is not available in real mode */
+	if (c->lock_prefix || ctxt->mode == X86EMUL_MODE_REAL
+		|| !(ctxt->vcpu->arch.cr0 & X86_CR0_PE))
+		return -1;
+
+	setup_syscalls_segments(ctxt, &cs, &ss);
+
+	kvm_x86_ops->get_msr(ctxt->vcpu, MSR_STAR, &msr_data);
+	msr_data >>= 32;
+	cs.selector = (u16)(msr_data & 0xfffc);
+	ss.selector = (u16)(msr_data + 8);
+
+	if (is_long_mode(ctxt->vcpu)) {
+		cs.db = 0;
+		cs.l = 1;
+	}
+	kvm_x86_ops->set_segment(ctxt->vcpu, &cs, VCPU_SREG_CS);
+	kvm_x86_ops->set_segment(ctxt->vcpu, &ss, VCPU_SREG_SS);
+
+	c->regs[VCPU_REGS_RCX] = c->eip;
+	if (is_long_mode(ctxt->vcpu)) {
+#ifdef CONFIG_X86_64
+		c->regs[VCPU_REGS_R11] = ctxt->eflags & ~EFLG_RF;
+
+		kvm_x86_ops->get_msr(ctxt->vcpu,
+			ctxt->mode == X86EMUL_MODE_PROT64 ?
+			MSR_LSTAR : MSR_CSTAR, &msr_data);
+		c->eip = msr_data;
+
+		kvm_x86_ops->get_msr(ctxt->vcpu, MSR_SYSCALL_MASK, &msr_data);
+		ctxt->eflags &= ~(msr_data | EFLG_RF);
+#endif
+	} else {
+		/* legacy mode */
+		kvm_x86_ops->get_msr(ctxt->vcpu, MSR_STAR, &msr_data);
+		c->eip = (u32)msr_data;
+
+		ctxt->eflags &= ~(EFLG_VM | EFLG_IF | EFLG_RF);
+	}
+
+	return 0;
+}
+
 int
 x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
@@ -1993,7 +2072,10 @@ twobyte_insn:
 		}
 		break;
 	case 0x05: 		/* syscall */
-		goto cannot_emulate;
+		if (emulate_syscall(ctxt) == -1)
+			goto cannot_emulate;
+		else
+			goto writeback;
 		break;
 	case 0x06:
 		emulate_clts(ctxt->vcpu);
-- 
1.6.3.3


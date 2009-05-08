Return-Path: <linux-kernel-owner+w=401wt.eu-S1763054AbZEHUXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763054AbZEHUXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbZEHUXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:23:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33809 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbZEHUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:23:12 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 2/2] deal with interrupt shadow state for emulated instruction
Date: Fri,  8 May 2009 16:23:07 -0400
Message-Id: <1241814187-5973-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1241814187-5973-2-git-send-email-glommer@redhat.com>
References: <1241814187-5973-1-git-send-email-glommer@redhat.com>
 <1241814187-5973-2-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we currently unblock shadow interrupt state when we skip an instruction,
but failing to do so when we actually emulate one. This blocks interrupts
in key instruction blocks, in particular sti; hlt; sequences

If the instruction emulated is an sti, we have to block shadow interrupts.
The same goes for mov ss. pop ss also needs it, but we don't currently
emulate it.

Without this patch, I cannot boot gpxe option roms at vmx machines.
This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/kvm_x86_emulate.h |    3 +++
 arch/x86/kvm/x86.c                     |    7 ++++++-
 arch/x86/kvm/x86_emulate.c             |   21 ++++++++++++++++++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_x86_emulate.h
index be40d6e..b7ed2c4 100644
--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -155,6 +155,9 @@ struct x86_emulate_ctxt {
 	int mode;
 	u32 cs_base;
 
+	/* interruptibility state, as a result of execution of STI or MOV SS */
+	int interruptibility;
+
 	/* decode cache */
 	struct decode_cache decode;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d8fcc5..c456aa5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2362,7 +2362,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 			u16 error_code,
 			int emulation_type)
 {
-	int r;
+	int r, shadow_mask;
 	struct decode_cache *c;
 
 	kvm_clear_exception_queue(vcpu);
@@ -2415,7 +2415,12 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		return EMULATE_DONE;
 	}
 
+	vcpu->arch.emulate_ctxt.interruptibility = 0;
 	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
+	shadow_mask = vcpu->arch.emulate_ctxt.interruptibility;
+
+	if (r == 0)
+		kvm_x86_ops->set_interrupt_shadow(vcpu, shadow_mask);
 
 	if (vcpu->arch.pio.string)
 		return EMULATE_DO_MMIO;
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index d2664fc..1d042d4 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1618,6 +1618,14 @@ special_insn:
 		int err;
 
 		sel = c->src.val;
+		if (c->modrm_reg == VCPU_SREG_SS) {
+			u32 int_shadow =
+				kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu);
+			/* See sti emulation for an explanation of this */
+			if (!(int_shadow & X86_SHADOW_INT_MOV_SS))
+				ctxt->interruptibility = X86_SHADOW_INT_MOV_SS;
+		}
+
 		if (c->modrm_reg <= 5) {
 			type_bits = (c->modrm_reg == 1) ? 9 : 1;
 			err = kvm_load_segment_descriptor(ctxt->vcpu, sel,
@@ -1846,10 +1854,21 @@ special_insn:
 		ctxt->eflags &= ~X86_EFLAGS_IF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
-	case 0xfb: /* sti */
+	case 0xfb: { /* sti */
+		u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu);
+		/*
+		 * an sti; sti; sequence only disable interrupts for the first
+		 * instruction. So, if the last instruction, be it emulated or
+		 * not, left the system with the INT_STI flag enabled, it
+		 * means that the last instruction is an sti. We should not
+		 * leave the flag on in this case
+		 */
+		if (!(int_shadow & X86_SHADOW_INT_STI))
+			ctxt->interruptibility = X86_SHADOW_INT_STI;
 		ctxt->eflags |= X86_EFLAGS_IF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
+	}
 	case 0xfc: /* cld */
 		ctxt->eflags &= ~EFLG_DF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
-- 
1.5.6.6


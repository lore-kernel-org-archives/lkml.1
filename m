Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZKPMVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZKPMVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZKPMUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbZKPMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:41 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 05/42] KVM: x86 emulator: Add 'push/pop sreg' instructions
Date: Mon, 16 Nov 2009 14:19:06 +0200
Message-Id: <1258373983-8693-6-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

[avi: avoid buffer overflow]

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |  107 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1be5cd6..1cdfec5 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -92,19 +92,22 @@ static u32 opcode_table[256] = {
 	/* 0x00 - 0x07 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm, 0, 0,
+	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm,
+	ImplicitOps | Stack, ImplicitOps | Stack,
 	/* 0x08 - 0x0F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	0, 0, 0, 0,
+	0, 0, ImplicitOps | Stack, 0,
 	/* 0x10 - 0x17 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm, 0, 0,
+	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm,
+	ImplicitOps | Stack, ImplicitOps | Stack,
 	/* 0x18 - 0x1F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm, 0, 0,
+	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm,
+	ImplicitOps | Stack, ImplicitOps | Stack,
 	/* 0x20 - 0x27 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
@@ -244,11 +247,13 @@ static u32 twobyte_table[256] = {
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xA0 - 0xA7 */
-	0, 0, 0, DstMem | SrcReg | ModRM | BitOp,
+	ImplicitOps | Stack, ImplicitOps | Stack,
+	0, DstMem | SrcReg | ModRM | BitOp,
 	DstMem | SrcReg | Src2ImmByte | ModRM,
 	DstMem | SrcReg | Src2CL | ModRM, 0, 0,
 	/* 0xA8 - 0xAF */
-	0, 0, 0, DstMem | SrcReg | ModRM | BitOp,
+	ImplicitOps | Stack, ImplicitOps | Stack,
+	0, DstMem | SrcReg | ModRM | BitOp,
 	DstMem | SrcReg | Src2ImmByte | ModRM,
 	DstMem | SrcReg | Src2CL | ModRM,
 	ModRM, 0,
@@ -1186,6 +1191,32 @@ static int emulate_pop(struct x86_emulate_ctxt *ctxt,
 	return rc;
 }
 
+static void emulate_push_sreg(struct x86_emulate_ctxt *ctxt, int seg)
+{
+	struct decode_cache *c = &ctxt->decode;
+	struct kvm_segment segment;
+
+	kvm_x86_ops->get_segment(ctxt->vcpu, &segment, seg);
+
+	c->src.val = segment.selector;
+	emulate_push(ctxt);
+}
+
+static int emulate_pop_sreg(struct x86_emulate_ctxt *ctxt,
+			     struct x86_emulate_ops *ops, int seg)
+{
+	struct decode_cache *c = &ctxt->decode;
+	unsigned long selector;
+	int rc;
+
+	rc = emulate_pop(ctxt, ops, &selector, c->op_bytes);
+	if (rc != 0)
+		return rc;
+
+	rc = kvm_load_segment_descriptor(ctxt->vcpu, (u16)selector, 1, seg);
+	return rc;
+}
+
 static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 				struct x86_emulate_ops *ops)
 {
@@ -1707,18 +1738,66 @@ special_insn:
 	      add:		/* add */
 		emulate_2op_SrcV("add", c->src, c->dst, ctxt->eflags);
 		break;
+	case 0x06:		/* push es */
+		if (ctxt->mode == X86EMUL_MODE_PROT64)
+			goto cannot_emulate;
+
+		emulate_push_sreg(ctxt, VCPU_SREG_ES);
+		break;
+	case 0x07:		/* pop es */
+                if (ctxt->mode == X86EMUL_MODE_PROT64)
+                        goto cannot_emulate;
+
+		rc = emulate_pop_sreg(ctxt, ops, VCPU_SREG_ES);
+		if (rc != 0)
+			goto done;
+		break;
 	case 0x08 ... 0x0d:
 	      or:		/* or */
 		emulate_2op_SrcV("or", c->src, c->dst, ctxt->eflags);
 		break;
+	case 0x0e:		/* push cs */
+                if (ctxt->mode == X86EMUL_MODE_PROT64)
+                        goto cannot_emulate;
+
+		emulate_push_sreg(ctxt, VCPU_SREG_CS);
+		break;
 	case 0x10 ... 0x15:
 	      adc:		/* adc */
 		emulate_2op_SrcV("adc", c->src, c->dst, ctxt->eflags);
 		break;
+	case 0x16:		/* push ss */
+                if (ctxt->mode == X86EMUL_MODE_PROT64)
+                        goto cannot_emulate;
+
+		emulate_push_sreg(ctxt, VCPU_SREG_SS);
+		break;
+	case 0x17:		/* pop ss */
+                if (ctxt->mode == X86EMUL_MODE_PROT64)
+                        goto cannot_emulate;
+
+		rc = emulate_pop_sreg(ctxt, ops, VCPU_SREG_SS);
+		if (rc != 0)
+			goto done;
+		break;
 	case 0x18 ... 0x1d:
 	      sbb:		/* sbb */
 		emulate_2op_SrcV("sbb", c->src, c->dst, ctxt->eflags);
 		break;
+	case 0x1e:		/* push ds */
+                if (ctxt->mode == X86EMUL_MODE_PROT64)
+                        goto cannot_emulate;
+
+		emulate_push_sreg(ctxt, VCPU_SREG_DS);
+		break;
+	case 0x1f:		/* pop ds */
+                if (ctxt->mode == X86EMUL_MODE_PROT64)
+                        goto cannot_emulate;
+
+		rc = emulate_pop_sreg(ctxt, ops, VCPU_SREG_DS);
+		if (rc != 0)
+			goto done;
+		break;
 	case 0x20 ... 0x25:
 	      and:		/* and */
 		emulate_2op_SrcV("and", c->src, c->dst, ctxt->eflags);
@@ -2297,6 +2376,14 @@ twobyte_insn:
 			jmp_rel(c, c->src.val);
 		c->dst.type = OP_NONE;
 		break;
+	case 0xa0:	  /* push fs */
+		emulate_push_sreg(ctxt, VCPU_SREG_FS);
+		break;
+	case 0xa1:	 /* pop fs */
+		rc = emulate_pop_sreg(ctxt, ops, VCPU_SREG_FS);
+		if (rc != 0)
+			goto done;
+		break;
 	case 0xa3:
 	      bt:		/* bt */
 		c->dst.type = OP_NONE;
@@ -2308,6 +2395,14 @@ twobyte_insn:
 	case 0xa5: /* shld cl, r, r/m */
 		emulate_2op_cl("shld", c->src2, c->src, c->dst, ctxt->eflags);
 		break;
+	case 0xa8:	/* push gs */
+		emulate_push_sreg(ctxt, VCPU_SREG_GS);
+		break;
+	case 0xa9:	/* pop gs */
+		rc = emulate_pop_sreg(ctxt, ops, VCPU_SREG_GS);
+		if (rc != 0)
+			goto done;
+		break;
 	case 0xab:
 	      bts:		/* bts */
 		/* only subword offset */
-- 
1.6.5.2


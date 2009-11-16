Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZKPMU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZKPMU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZKPMUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZKPMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:41 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 06/42] KVM: x86 emulator: Introduce No64 decode option
Date: Mon, 16 Nov 2009 14:19:07 +0200
Message-Id: <1258373983-8693-7-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

Introduces a new decode option "No64", which is used for instructions that are
invalid in long mode.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |   42 ++++++++++++++----------------------------
 1 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1cdfec5..1f0ff4a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -75,6 +75,8 @@
 #define Group       (1<<14)     /* Bits 3:5 of modrm byte extend opcode */
 #define GroupDual   (1<<15)     /* Alternate decoding of mod == 3 */
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
+/* Misc flags */
+#define No64	    (1<<28)
 /* Source 2 operand type */
 #define Src2None    (0<<29)
 #define Src2CL      (1<<29)
@@ -93,21 +95,21 @@ static u32 opcode_table[256] = {
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
 	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm,
-	ImplicitOps | Stack, ImplicitOps | Stack,
+	ImplicitOps | Stack | No64, ImplicitOps | Stack | No64,
 	/* 0x08 - 0x0F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	0, 0, ImplicitOps | Stack, 0,
+	0, 0, ImplicitOps | Stack | No64, 0,
 	/* 0x10 - 0x17 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
 	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm,
-	ImplicitOps | Stack, ImplicitOps | Stack,
+	ImplicitOps | Stack | No64, ImplicitOps | Stack | No64,
 	/* 0x18 - 0x1F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
 	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm,
-	ImplicitOps | Stack, ImplicitOps | Stack,
+	ImplicitOps | Stack | No64, ImplicitOps | Stack | No64,
 	/* 0x20 - 0x27 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
@@ -161,7 +163,7 @@ static u32 opcode_table[256] = {
 	/* 0x90 - 0x97 */
 	DstReg, DstReg, DstReg, DstReg,	DstReg, DstReg, DstReg, DstReg,
 	/* 0x98 - 0x9F */
-	0, 0, SrcImm | Src2Imm16, 0,
+	0, 0, SrcImm | Src2Imm16 | No64, 0,
 	ImplicitOps | Stack, ImplicitOps | Stack, 0, 0,
 	/* 0xA0 - 0xA7 */
 	ByteOp | DstReg | SrcMem | Mov | MemAbs, DstReg | SrcMem | Mov | MemAbs,
@@ -188,7 +190,7 @@ static u32 opcode_table[256] = {
 	ByteOp | DstMem | SrcImm | ModRM | Mov, DstMem | SrcImm | ModRM | Mov,
 	/* 0xC8 - 0xCF */
 	0, 0, 0, ImplicitOps | Stack,
-	ImplicitOps, SrcImmByte, ImplicitOps, ImplicitOps,
+	ImplicitOps, SrcImmByte, ImplicitOps | No64, ImplicitOps,
 	/* 0xD0 - 0xD7 */
 	ByteOp | DstMem | SrcImplicit | ModRM, DstMem | SrcImplicit | ModRM,
 	ByteOp | DstMem | SrcImplicit | ModRM, DstMem | SrcImplicit | ModRM,
@@ -201,7 +203,7 @@ static u32 opcode_table[256] = {
 	ByteOp | SrcImmUByte, SrcImmUByte,
 	/* 0xE8 - 0xEF */
 	SrcImm | Stack, SrcImm | ImplicitOps,
-	SrcImmU | Src2Imm16, SrcImmByte | ImplicitOps,
+	SrcImmU | Src2Imm16 | No64, SrcImmByte | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xF0 - 0xF7 */
@@ -967,6 +969,11 @@ done_prefixes:
 		}
 	}
 
+	if (mode == X86EMUL_MODE_PROT64 && (c->d & No64)) {
+		kvm_report_emulation_failure(ctxt->vcpu, "invalid x86/64 instruction");;
+		return -1;
+	}
+
 	if (c->d & Group) {
 		group = c->d & GroupMask;
 		c->modrm = insn_fetch(u8, 1, c->eip);
@@ -1739,15 +1746,9 @@ special_insn:
 		emulate_2op_SrcV("add", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x06:		/* push es */
-		if (ctxt->mode == X86EMUL_MODE_PROT64)
-			goto cannot_emulate;
-
 		emulate_push_sreg(ctxt, VCPU_SREG_ES);
 		break;
 	case 0x07:		/* pop es */
-                if (ctxt->mode == X86EMUL_MODE_PROT64)
-                        goto cannot_emulate;
-
 		rc = emulate_pop_sreg(ctxt, ops, VCPU_SREG_ES);
 		if (rc != 0)
 			goto done;
@@ -1757,9 +1758,6 @@ special_insn:
 		emulate_2op_SrcV("or", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x0e:		/* push cs */
-                if (ctxt->mode == X86EMUL_MODE_PROT64)
-                        goto cannot_emulate;
-
 		emulate_push_sreg(ctxt, VCPU_SREG_CS);
 		break;
 	case 0x10 ... 0x15:
@@ -1767,15 +1765,9 @@ special_insn:
 		emulate_2op_SrcV("adc", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x16:		/* push ss */
-                if (ctxt->mode == X86EMUL_MODE_PROT64)
-                        goto cannot_emulate;
-
 		emulate_push_sreg(ctxt, VCPU_SREG_SS);
 		break;
 	case 0x17:		/* pop ss */
-                if (ctxt->mode == X86EMUL_MODE_PROT64)
-                        goto cannot_emulate;
-
 		rc = emulate_pop_sreg(ctxt, ops, VCPU_SREG_SS);
 		if (rc != 0)
 			goto done;
@@ -1785,15 +1777,9 @@ special_insn:
 		emulate_2op_SrcV("sbb", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x1e:		/* push ds */
-                if (ctxt->mode == X86EMUL_MODE_PROT64)
-                        goto cannot_emulate;
-
 		emulate_push_sreg(ctxt, VCPU_SREG_DS);
 		break;
 	case 0x1f:		/* pop ds */
-                if (ctxt->mode == X86EMUL_MODE_PROT64)
-                        goto cannot_emulate;
-
 		rc = emulate_pop_sreg(ctxt, ops, VCPU_SREG_DS);
 		if (rc != 0)
 			goto done;
-- 
1.6.5.2


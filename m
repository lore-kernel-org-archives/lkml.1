Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbXLZLQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbXLZLQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXLZLGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:47 -0500
Received: from il.qumranet.com ([82.166.9.18]:50488 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 28/55] KVM: x86 emulator: centralize decoding of one-byte register access insns
Date: Wed, 26 Dec 2007 13:05:33 +0200
Message-Id: <1198667160-22953-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instructions like 'inc reg' that have the register operand encoded
in the opcode are currently specially decoded.  Extend
decode_register_operand() to handle that case, indicated by having
DstReg or SrcReg without ModRM.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |  103 ++++++++++++++++++++-------------------------
 drivers/kvm/x86_emulate.h |    1 +
 2 files changed, 47 insertions(+), 57 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 58ceb66..884e4a2 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -99,17 +99,13 @@ static u16 opcode_table[256] = {
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
 	0, 0, 0, 0,
 	/* 0x40 - 0x47 */
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	DstReg, DstReg, DstReg, DstReg, DstReg, DstReg, DstReg, DstReg,
 	/* 0x48 - 0x4F */
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	DstReg, DstReg, DstReg, DstReg,	DstReg, DstReg, DstReg, DstReg,
 	/* 0x50 - 0x57 */
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	SrcReg, SrcReg, SrcReg, SrcReg, SrcReg, SrcReg, SrcReg, SrcReg,
 	/* 0x58 - 0x5F */
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	DstReg, DstReg, DstReg, DstReg,	DstReg, DstReg, DstReg, DstReg,
 	/* 0x60 - 0x67 */
 	0, 0, 0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
 	0, 0, 0, 0,
@@ -525,13 +521,17 @@ static void decode_register_operand(struct operand *op,
 				    int highbyte_regs,
 				    int inhibit_bytereg)
 {
+	unsigned reg = c->modrm_reg;
+
+	if (!(c->d & ModRM))
+		reg = (c->b & 7) | ((c->rex_prefix & 1) << 3);
 	op->type = OP_REG;
 	if ((c->d & ByteOp) && !inhibit_bytereg) {
-		op->ptr = decode_register(c->modrm_reg, c->regs, highbyte_regs);
+		op->ptr = decode_register(reg, c->regs, highbyte_regs);
 		op->val = *(u8 *)op->ptr;
 		op->bytes = 1;
 	} else {
-		op->ptr = decode_register(c->modrm_reg, c->regs, 0);
+		op->ptr = decode_register(reg, c->regs, 0);
 		op->bytes = c->op_bytes;
 		switch (op->bytes) {
 		case 2:
@@ -552,7 +552,7 @@ int
 x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
-	u8 sib, rex_prefix = 0;
+	u8 sib;
 	int rc = 0;
 	int mode = ctxt->mode;
 	int index_reg = 0, base_reg = 0, scale, rip_relative = 0;
@@ -616,7 +616,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		case 0x40 ... 0x4f: /* REX */
 			if (mode != X86EMUL_MODE_PROT64)
 				goto done_prefixes;
-			rex_prefix = c->b;
+			c->rex_prefix = c->b;
 			continue;
 		case 0xf0:	/* LOCK */
 			c->lock_prefix = 1;
@@ -631,18 +631,18 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 
 		/* Any legacy prefix after a REX prefix nullifies its effect. */
 
-		rex_prefix = 0;
+		c->rex_prefix = 0;
 	}
 
 done_prefixes:
 
 	/* REX prefix. */
-	if (rex_prefix) {
-		if (rex_prefix & 8)
+	if (c->rex_prefix) {
+		if (c->rex_prefix & 8)
 			c->op_bytes = 8;	/* REX.W */
-		c->modrm_reg = (rex_prefix & 4) << 1;	/* REX.R */
-		index_reg = (rex_prefix & 2) << 2; /* REX.X */
-		c->modrm_rm = base_reg = (rex_prefix & 1) << 3; /* REG.B */
+		c->modrm_reg = (c->rex_prefix & 4) << 1;	/* REX.R */
+		index_reg = (c->rex_prefix & 2) << 2; /* REX.X */
+		c->modrm_rm = base_reg = (c->rex_prefix & 1) << 3; /* REG.B */
 	}
 
 	/* Opcode byte(s). */
@@ -837,7 +837,7 @@ modrm_done:
 	case SrcNone:
 		break;
 	case SrcReg:
-		decode_register_operand(&c->src, c, rex_prefix == 0, 0);
+		decode_register_operand(&c->src, c, c->rex_prefix == 0, 0);
 		break;
 	case SrcMem16:
 		c->src.bytes = 2;
@@ -895,7 +895,7 @@ modrm_done:
 		/* Special instructions do their own operand decoding. */
 		return 0;
 	case DstReg:
-		decode_register_operand(&c->dst, c, rex_prefix == 0,
+		decode_register_operand(&c->dst, c, c->rex_prefix == 0,
 			 c->twobyte && (c->b == 0xb6 || c->b == 0xb7));
 		break;
 	case DstMem:
@@ -1258,6 +1258,32 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	      cmp:		/* cmp */
 		emulate_2op_SrcV("cmp", c->src, c->dst, ctxt->eflags);
 		break;
+	case 0x40 ... 0x47: /* inc r16/r32 */
+		emulate_1op("inc", c->dst, ctxt->eflags);
+		break;
+	case 0x48 ... 0x4f: /* dec r16/r32 */
+		emulate_1op("dec", c->dst, ctxt->eflags);
+		break;
+	case 0x50 ... 0x57:  /* push reg */
+		c->dst.type  = OP_MEM;
+		c->dst.bytes = c->op_bytes;
+		c->dst.val = c->src.val;
+		register_address_increment(c->regs[VCPU_REGS_RSP],
+					   -c->op_bytes);
+		c->dst.ptr = (void *) register_address(
+			ctxt->ss_base, c->regs[VCPU_REGS_RSP]);
+		break;
+	case 0x58 ... 0x5f: /* pop reg */
+	pop_instruction:
+		if ((rc = ops->read_std(register_address(ctxt->ss_base,
+			c->regs[VCPU_REGS_RSP]), c->dst.ptr,
+			c->op_bytes, ctxt->vcpu)) != 0)
+			goto done;
+
+		register_address_increment(c->regs[VCPU_REGS_RSP],
+					   c->op_bytes);
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
 	case 0x63:		/* movsxd */
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
 			goto cannot_emulate;
@@ -1373,43 +1399,6 @@ special_insn:
 	if (c->twobyte)
 		goto twobyte_special_insn;
 	switch (c->b) {
-	case 0x40 ... 0x47: /* inc r16/r32 */
-		c->dst.bytes = c->op_bytes;
-		c->dst.ptr = (unsigned long *)&c->regs[c->b & 0x7];
-		c->dst.val = *c->dst.ptr;
-		emulate_1op("inc", c->dst, ctxt->eflags);
-		break;
-	case 0x48 ... 0x4f: /* dec r16/r32 */
-		c->dst.bytes = c->op_bytes;
-		c->dst.ptr = (unsigned long *)&c->regs[c->b & 0x7];
-		c->dst.val = *c->dst.ptr;
-		emulate_1op("dec", c->dst, ctxt->eflags);
-		break;
-	case 0x50 ... 0x57:  /* push reg */
-		if (c->op_bytes == 2)
-			c->src.val = (u16) c->regs[c->b & 0x7];
-		else
-			c->src.val = (u32) c->regs[c->b & 0x7];
-		c->dst.type  = OP_MEM;
-		c->dst.bytes = c->op_bytes;
-		c->dst.val = c->src.val;
-		register_address_increment(c->regs[VCPU_REGS_RSP],
-					   -c->op_bytes);
-		c->dst.ptr = (void *) register_address(
-			ctxt->ss_base, c->regs[VCPU_REGS_RSP]);
-		break;
-	case 0x58 ... 0x5f: /* pop reg */
-		c->dst.ptr = (unsigned long *)&c->regs[c->b & 0x7];
-	pop_instruction:
-		if ((rc = ops->read_std(register_address(ctxt->ss_base,
-			c->regs[VCPU_REGS_RSP]), c->dst.ptr,
-			c->op_bytes, ctxt->vcpu)) != 0)
-			goto done;
-
-		register_address_increment(c->regs[VCPU_REGS_RSP],
-					   c->op_bytes);
-		c->dst.type = OP_NONE;	/* Disable writeback. */
-		break;
 	case 0x6a: /* push imm8 */
 		c->src.val = 0L;
 		c->src.val = insn_fetch(s8, 1, c->eip);
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index f03b128..e34868b 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -126,6 +126,7 @@ struct decode_cache {
 	u8 rep_prefix;
 	u8 op_bytes;
 	u8 ad_bytes;
+	u8 rex_prefix;
 	struct operand src;
 	struct operand dst;
 	unsigned long *override_base;
-- 
1.5.3.7


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbXLZLOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbXLZLOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXLZLGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:41 -0500
Received: from il.qumranet.com ([82.166.9.18]:50469 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 31/55] KVM: x86 emulator: Hoist modrm and abs decoding into separate functions
Date: Wed, 26 Dec 2007 13:05:36 +0200
Message-Id: <1198667160-22953-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |  337 ++++++++++++++++++++++++---------------------
 1 files changed, 177 insertions(+), 160 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index b352a6c..64888a6 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -548,14 +548,182 @@ static void decode_register_operand(struct operand *op,
 	op->orig_val = op->val;
 }
 
+static int decode_modrm(struct x86_emulate_ctxt *ctxt,
+			struct x86_emulate_ops *ops)
+{
+	struct decode_cache *c = &ctxt->decode;
+	u8 sib;
+	int index_reg = 0, base_reg = 0, scale, rip_relative = 0;
+	int rc = 0;
+
+	if (c->rex_prefix) {
+		c->modrm_reg = (c->rex_prefix & 4) << 1;	/* REX.R */
+		index_reg = (c->rex_prefix & 2) << 2; /* REX.X */
+		c->modrm_rm = base_reg = (c->rex_prefix & 1) << 3; /* REG.B */
+	}
+
+	c->modrm = insn_fetch(u8, 1, c->eip);
+	c->modrm_mod |= (c->modrm & 0xc0) >> 6;
+	c->modrm_reg |= (c->modrm & 0x38) >> 3;
+	c->modrm_rm |= (c->modrm & 0x07);
+	c->modrm_ea = 0;
+	c->use_modrm_ea = 1;
+
+	if (c->modrm_mod == 3) {
+		c->modrm_val = *(unsigned long *)
+			decode_register(c->modrm_rm, c->regs, c->d & ByteOp);
+		return rc;
+	}
+
+	if (c->ad_bytes == 2) {
+		unsigned bx = c->regs[VCPU_REGS_RBX];
+		unsigned bp = c->regs[VCPU_REGS_RBP];
+		unsigned si = c->regs[VCPU_REGS_RSI];
+		unsigned di = c->regs[VCPU_REGS_RDI];
+
+		/* 16-bit ModR/M decode. */
+		switch (c->modrm_mod) {
+		case 0:
+			if (c->modrm_rm == 6)
+				c->modrm_ea += insn_fetch(u16, 2, c->eip);
+			break;
+		case 1:
+			c->modrm_ea += insn_fetch(s8, 1, c->eip);
+			break;
+		case 2:
+			c->modrm_ea += insn_fetch(u16, 2, c->eip);
+			break;
+		}
+		switch (c->modrm_rm) {
+		case 0:
+			c->modrm_ea += bx + si;
+			break;
+		case 1:
+			c->modrm_ea += bx + di;
+			break;
+		case 2:
+			c->modrm_ea += bp + si;
+			break;
+		case 3:
+			c->modrm_ea += bp + di;
+			break;
+		case 4:
+			c->modrm_ea += si;
+			break;
+		case 5:
+			c->modrm_ea += di;
+			break;
+		case 6:
+			if (c->modrm_mod != 0)
+				c->modrm_ea += bp;
+			break;
+		case 7:
+			c->modrm_ea += bx;
+			break;
+		}
+		if (c->modrm_rm == 2 || c->modrm_rm == 3 ||
+		    (c->modrm_rm == 6 && c->modrm_mod != 0))
+			if (!c->override_base)
+				c->override_base = &ctxt->ss_base;
+		c->modrm_ea = (u16)c->modrm_ea;
+	} else {
+		/* 32/64-bit ModR/M decode. */
+		switch (c->modrm_rm) {
+		case 4:
+		case 12:
+			sib = insn_fetch(u8, 1, c->eip);
+			index_reg |= (sib >> 3) & 7;
+			base_reg |= sib & 7;
+			scale = sib >> 6;
+
+			switch (base_reg) {
+			case 5:
+				if (c->modrm_mod != 0)
+					c->modrm_ea += c->regs[base_reg];
+				else
+					c->modrm_ea +=
+						insn_fetch(s32, 4, c->eip);
+				break;
+			default:
+				c->modrm_ea += c->regs[base_reg];
+			}
+			switch (index_reg) {
+			case 4:
+				break;
+			default:
+				c->modrm_ea += c->regs[index_reg] << scale;
+			}
+			break;
+		case 5:
+			if (c->modrm_mod != 0)
+				c->modrm_ea += c->regs[c->modrm_rm];
+			else if (ctxt->mode == X86EMUL_MODE_PROT64)
+				rip_relative = 1;
+			break;
+		default:
+			c->modrm_ea += c->regs[c->modrm_rm];
+			break;
+		}
+		switch (c->modrm_mod) {
+		case 0:
+			if (c->modrm_rm == 5)
+				c->modrm_ea += insn_fetch(s32, 4, c->eip);
+			break;
+		case 1:
+			c->modrm_ea += insn_fetch(s8, 1, c->eip);
+			break;
+		case 2:
+			c->modrm_ea += insn_fetch(s32, 4, c->eip);
+			break;
+		}
+	}
+	if (rip_relative) {
+		c->modrm_ea += c->eip;
+		switch (c->d & SrcMask) {
+		case SrcImmByte:
+			c->modrm_ea += 1;
+			break;
+		case SrcImm:
+			if (c->d & ByteOp)
+				c->modrm_ea += 1;
+			else
+				if (c->op_bytes == 8)
+					c->modrm_ea += 4;
+				else
+					c->modrm_ea += c->op_bytes;
+		}
+	}
+done:
+	return rc;
+}
+
+static int decode_abs(struct x86_emulate_ctxt *ctxt,
+		      struct x86_emulate_ops *ops)
+{
+	struct decode_cache *c = &ctxt->decode;
+	int rc = 0;
+
+	switch (c->ad_bytes) {
+	case 2:
+		c->modrm_ea = insn_fetch(u16, 2, c->eip);
+		break;
+	case 4:
+		c->modrm_ea = insn_fetch(u32, 4, c->eip);
+		break;
+	case 8:
+		c->modrm_ea = insn_fetch(u64, 8, c->eip);
+		break;
+	}
+done:
+	return rc;
+}
+
 int
 x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
-	u8 sib;
 	int rc = 0;
 	int mode = ctxt->mode;
-	int index_reg = 0, base_reg = 0, scale, rip_relative = 0;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
 
@@ -637,13 +805,9 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 done_prefixes:
 
 	/* REX prefix. */
-	if (c->rex_prefix) {
+	if (c->rex_prefix)
 		if (c->rex_prefix & 8)
 			c->op_bytes = 8;	/* REX.W */
-		c->modrm_reg = (c->rex_prefix & 4) << 1;	/* REX.R */
-		index_reg = (c->rex_prefix & 2) << 2; /* REX.X */
-		c->modrm_rm = base_reg = (c->rex_prefix & 1) << 3; /* REG.B */
-	}
 
 	/* Opcode byte(s). */
 	c->d = opcode_table[c->b];
@@ -663,159 +827,12 @@ done_prefixes:
 	}
 
 	/* ModRM and SIB bytes. */
-	if (c->d & ModRM) {
-		c->modrm = insn_fetch(u8, 1, c->eip);
-		c->modrm_mod |= (c->modrm & 0xc0) >> 6;
-		c->modrm_reg |= (c->modrm & 0x38) >> 3;
-		c->modrm_rm |= (c->modrm & 0x07);
-		c->modrm_ea = 0;
-		c->use_modrm_ea = 1;
-
-		if (c->modrm_mod == 3) {
-			c->modrm_val = *(unsigned long *)
-			  decode_register(c->modrm_rm, c->regs, c->d & ByteOp);
-			goto modrm_done;
-		}
-
-		if (c->ad_bytes == 2) {
-			unsigned bx = c->regs[VCPU_REGS_RBX];
-			unsigned bp = c->regs[VCPU_REGS_RBP];
-			unsigned si = c->regs[VCPU_REGS_RSI];
-			unsigned di = c->regs[VCPU_REGS_RDI];
-
-			/* 16-bit ModR/M decode. */
-			switch (c->modrm_mod) {
-			case 0:
-				if (c->modrm_rm == 6)
-					c->modrm_ea +=
-						insn_fetch(u16, 2, c->eip);
-				break;
-			case 1:
-				c->modrm_ea += insn_fetch(s8, 1, c->eip);
-				break;
-			case 2:
-				c->modrm_ea += insn_fetch(u16, 2, c->eip);
-				break;
-			}
-			switch (c->modrm_rm) {
-			case 0:
-				c->modrm_ea += bx + si;
-				break;
-			case 1:
-				c->modrm_ea += bx + di;
-				break;
-			case 2:
-				c->modrm_ea += bp + si;
-				break;
-			case 3:
-				c->modrm_ea += bp + di;
-				break;
-			case 4:
-				c->modrm_ea += si;
-				break;
-			case 5:
-				c->modrm_ea += di;
-				break;
-			case 6:
-				if (c->modrm_mod != 0)
-					c->modrm_ea += bp;
-				break;
-			case 7:
-				c->modrm_ea += bx;
-				break;
-			}
-			if (c->modrm_rm == 2 || c->modrm_rm == 3 ||
-			    (c->modrm_rm == 6 && c->modrm_mod != 0))
-				if (!c->override_base)
-					c->override_base = &ctxt->ss_base;
-			c->modrm_ea = (u16)c->modrm_ea;
-		} else {
-			/* 32/64-bit ModR/M decode. */
-			switch (c->modrm_rm) {
-			case 4:
-			case 12:
-				sib = insn_fetch(u8, 1, c->eip);
-				index_reg |= (sib >> 3) & 7;
-				base_reg |= sib & 7;
-				scale = sib >> 6;
-
-				switch (base_reg) {
-				case 5:
-					if (c->modrm_mod != 0)
-						c->modrm_ea +=
-							c->regs[base_reg];
-					else
-						c->modrm_ea +=
-						    insn_fetch(s32, 4, c->eip);
-					break;
-				default:
-					c->modrm_ea += c->regs[base_reg];
-				}
-				switch (index_reg) {
-				case 4:
-					break;
-				default:
-					c->modrm_ea +=
-						c->regs[index_reg] << scale;
-
-				}
-				break;
-			case 5:
-				if (c->modrm_mod != 0)
-					c->modrm_ea += c->regs[c->modrm_rm];
-				else if (mode == X86EMUL_MODE_PROT64)
-					rip_relative = 1;
-				break;
-			default:
-				c->modrm_ea += c->regs[c->modrm_rm];
-				break;
-			}
-			switch (c->modrm_mod) {
-			case 0:
-				if (c->modrm_rm == 5)
-					c->modrm_ea +=
-						insn_fetch(s32, 4, c->eip);
-				break;
-			case 1:
-				c->modrm_ea += insn_fetch(s8, 1, c->eip);
-				break;
-			case 2:
-				c->modrm_ea += insn_fetch(s32, 4, c->eip);
-				break;
-			}
-		}
-		if (rip_relative) {
-			c->modrm_ea += c->eip;
-			switch (c->d & SrcMask) {
-			case SrcImmByte:
-				c->modrm_ea += 1;
-				break;
-			case SrcImm:
-				if (c->d & ByteOp)
-					c->modrm_ea += 1;
-				else
-					if (c->op_bytes == 8)
-						c->modrm_ea += 4;
-					else
-						c->modrm_ea += c->op_bytes;
-			}
-		}
-modrm_done:
-		;
-	} else if (c->d & MemAbs) {
-		switch (c->ad_bytes) {
-		case 2:
-			c->modrm_ea = insn_fetch(u16, 2, c->eip);
-			break;
-		case 4:
-			c->modrm_ea = insn_fetch(u32, 4, c->eip);
-			break;
-		case 8:
-			c->modrm_ea = insn_fetch(u64, 8, c->eip);
-			break;
-		}
-
-	}
+	if (c->d & ModRM)
+		rc = decode_modrm(ctxt, ops);
+	else if (c->d & MemAbs)
+		rc = decode_abs(ctxt, ops);
+	if (rc)
+		goto done;
 
 	if (!c->override_base)
 		c->override_base = &ctxt->ds_base;
-- 
1.5.3.7


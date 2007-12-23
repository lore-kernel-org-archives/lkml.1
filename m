Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXLWO5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXLWO5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbXLWOv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:57 -0500
Received: from il.qumranet.com ([82.166.9.18]:35913 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbXLWOvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 13/50] KVM: x86 emulator: remove _eflags and use directly ctxt->eflags.
Date: Sun, 23 Dec 2007 16:50:58 +0200
Message-Id: <1198421495-31481-14-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Remove _eflags and use directly ctxt->eflags. Caching eflags is not needed as
it is restored to vcpu by kvm_main.c:emulate_instruction() from ctxt->eflags
only if emulation doesn't fail.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |  121 ++++++++++++++++++++++-----------------------
 1 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index a108736..45beeb9 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -941,37 +941,37 @@ static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 	return 0;
 }
 
-static inline void emulate_grp2(struct decode_cache *c, unsigned long *_eflags)
+static inline void emulate_grp2(struct x86_emulate_ctxt *ctxt)
 {
+	struct decode_cache *c = &ctxt->decode;
 	switch (c->modrm_reg) {
 	case 0:	/* rol */
-		emulate_2op_SrcB("rol", c->src, c->dst, *_eflags);
+		emulate_2op_SrcB("rol", c->src, c->dst, ctxt->eflags);
 		break;
 	case 1:	/* ror */
-		emulate_2op_SrcB("ror", c->src, c->dst, *_eflags);
+		emulate_2op_SrcB("ror", c->src, c->dst, ctxt->eflags);
 		break;
 	case 2:	/* rcl */
-		emulate_2op_SrcB("rcl", c->src, c->dst, *_eflags);
+		emulate_2op_SrcB("rcl", c->src, c->dst, ctxt->eflags);
 		break;
 	case 3:	/* rcr */
-		emulate_2op_SrcB("rcr", c->src, c->dst, *_eflags);
+		emulate_2op_SrcB("rcr", c->src, c->dst, ctxt->eflags);
 		break;
 	case 4:	/* sal/shl */
 	case 6:	/* sal/shl */
-		emulate_2op_SrcB("sal", c->src, c->dst, *_eflags);
+		emulate_2op_SrcB("sal", c->src, c->dst, ctxt->eflags);
 		break;
 	case 5:	/* shr */
-		emulate_2op_SrcB("shr", c->src, c->dst, *_eflags);
+		emulate_2op_SrcB("shr", c->src, c->dst, ctxt->eflags);
 		break;
 	case 7:	/* sar */
-		emulate_2op_SrcB("sar", c->src, c->dst, *_eflags);
+		emulate_2op_SrcB("sar", c->src, c->dst, ctxt->eflags);
 		break;
 	}
 }
 
 static inline int emulate_grp3(struct x86_emulate_ctxt *ctxt,
-			       struct x86_emulate_ops *ops,
-			       unsigned long *_eflags)
+			       struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
 	int rc = 0;
@@ -998,13 +998,13 @@ static inline int emulate_grp3(struct x86_emulate_ctxt *ctxt,
 			c->src.val = insn_fetch(s32, 4, c->eip);
 			break;
 		}
-		emulate_2op_SrcV("test", c->src, c->dst, *_eflags);
+		emulate_2op_SrcV("test", c->src, c->dst, ctxt->eflags);
 		break;
 	case 2:	/* not */
 		c->dst.val = ~c->dst.val;
 		break;
 	case 3:	/* neg */
-		emulate_1op("neg", c->dst, *_eflags);
+		emulate_1op("neg", c->dst, ctxt->eflags);
 		break;
 	default:
 		DPRINTF("Cannot emulate %02x\n", c->b);
@@ -1017,7 +1017,6 @@ done:
 
 static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 			       struct x86_emulate_ops *ops,
-			       unsigned long *_eflags,
 			       int *no_wb)
 {
 	struct decode_cache *c = &ctxt->decode;
@@ -1025,10 +1024,10 @@ static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 
 	switch (c->modrm_reg) {
 	case 0:	/* inc */
-		emulate_1op("inc", c->dst, *_eflags);
+		emulate_1op("inc", c->dst, ctxt->eflags);
 		break;
 	case 1:	/* dec */
-		emulate_1op("dec", c->dst, *_eflags);
+		emulate_1op("dec", c->dst, ctxt->eflags);
 		break;
 	case 4: /* jmp abs */
 		if (c->b == 0xff)
@@ -1067,7 +1066,6 @@ static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 
 static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
 			       struct x86_emulate_ops *ops,
-			       unsigned long *_eflags,
 			       unsigned long cr2)
 {
 	struct decode_cache *c = &ctxt->decode;
@@ -1083,7 +1081,7 @@ static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
 
 		c->regs[VCPU_REGS_RAX] = (u32) (old >> 0);
 		c->regs[VCPU_REGS_RDX] = (u32) (old >> 32);
-		*_eflags &= ~EFLG_ZF;
+		ctxt->eflags &= ~EFLG_ZF;
 
 	} else {
 		new = ((u64)c->regs[VCPU_REGS_RCX] << 32) |
@@ -1092,7 +1090,7 @@ static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
 		rc = ops->cmpxchg_emulated(cr2, &old, &new, 8, ctxt->vcpu);
 		if (rc != 0)
 			return rc;
-		*_eflags |= EFLG_ZF;
+		ctxt->eflags |= EFLG_ZF;
 	}
 	return 0;
 }
@@ -1152,7 +1150,6 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	int no_wb = 0;
 	u64 msr_data;
 	unsigned long saved_eip = 0;
-	unsigned long _eflags = ctxt->eflags;
 	struct decode_cache *c = &ctxt->decode;
 	int rc = 0;
 
@@ -1207,23 +1204,23 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	switch (c->b) {
 	case 0x00 ... 0x05:
 	      add:		/* add */
-		emulate_2op_SrcV("add", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("add", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x08 ... 0x0d:
 	      or:		/* or */
-		emulate_2op_SrcV("or", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("or", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x10 ... 0x15:
 	      adc:		/* adc */
-		emulate_2op_SrcV("adc", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("adc", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x18 ... 0x1d:
 	      sbb:		/* sbb */
-		emulate_2op_SrcV("sbb", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("sbb", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x20 ... 0x23:
 	      and:		/* and */
-		emulate_2op_SrcV("and", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("and", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x24:              /* and al imm8 */
 		c->dst.type = OP_REG;
@@ -1244,15 +1241,15 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		goto and;
 	case 0x28 ... 0x2d:
 	      sub:		/* sub */
-		emulate_2op_SrcV("sub", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("sub", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x30 ... 0x35:
 	      xor:		/* xor */
-		emulate_2op_SrcV("xor", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("xor", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x38 ... 0x3d:
 	      cmp:		/* cmp */
-		emulate_2op_SrcV("cmp", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("cmp", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x63:		/* movsxd */
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
@@ -1280,7 +1277,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		}
 		break;
 	case 0x84 ... 0x85:
-		emulate_2op_SrcV("test", c->src, c->dst, _eflags);
+		emulate_2op_SrcV("test", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x86 ... 0x87:	/* xchg */
 		/* Write back the register source. */
@@ -1327,7 +1324,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		c->eip += c->ad_bytes;
 		break;
 	case 0xc0 ... 0xc1:
-		emulate_grp2(c, &_eflags);
+		emulate_grp2(ctxt);
 		break;
 	case 0xc6 ... 0xc7:	/* mov (sole member of Grp11) */
 	mov:
@@ -1335,19 +1332,19 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		break;
 	case 0xd0 ... 0xd1:	/* Grp2 */
 		c->src.val = 1;
-		emulate_grp2(c, &_eflags);
+		emulate_grp2(ctxt);
 		break;
 	case 0xd2 ... 0xd3:	/* Grp2 */
 		c->src.val = c->regs[VCPU_REGS_RCX];
-		emulate_grp2(c, &_eflags);
+		emulate_grp2(ctxt);
 		break;
 	case 0xf6 ... 0xf7:	/* Grp3 */
-		rc = emulate_grp3(ctxt, ops, &_eflags);
+		rc = emulate_grp3(ctxt, ops);
 		if (rc != 0)
 			goto done;
 		break;
 	case 0xfe ... 0xff:	/* Grp4/Grp5 */
-		rc = emulate_grp45(ctxt, ops, &_eflags, &no_wb);
+		rc = emulate_grp45(ctxt, ops, &no_wb);
 		if (rc != 0)
 			goto done;
 		break;
@@ -1362,7 +1359,6 @@ writeback:
 
 	/* Commit shadow register state. */
 	memcpy(ctxt->vcpu->regs, c->regs, sizeof c->regs);
-	ctxt->eflags = _eflags;
 	ctxt->vcpu->rip = c->eip;
 
 done:
@@ -1413,7 +1409,7 @@ special_insn:
 				(c->d & ByteOp) ? 1 : c->op_bytes,
 				c->rep_prefix ?
 				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
-				(_eflags & EFLG_DF),
+				(ctxt->eflags & EFLG_DF),
 				register_address(ctxt->es_base,
 						 c->regs[VCPU_REGS_RDI]),
 				c->rep_prefix,
@@ -1429,7 +1425,7 @@ special_insn:
 				(c->d & ByteOp) ? 1 : c->op_bytes,
 				c->rep_prefix ?
 				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
-				(_eflags & EFLG_DF),
+				(ctxt->eflags & EFLG_DF),
 				register_address(c->override_base ?
 							*c->override_base :
 							ctxt->ds_base,
@@ -1443,16 +1439,16 @@ special_insn:
 	case 0x70 ... 0x7f: /* jcc (short) */ {
 		int rel = insn_fetch(s8, 1, c->eip);
 
-		if (test_cc(c->b, _eflags))
+		if (test_cc(c->b, ctxt->eflags))
 		JMP_REL(rel);
 		break;
 	}
 	case 0x9c: /* pushf */
-		c->src.val =  (unsigned long) _eflags;
+		c->src.val =  (unsigned long) ctxt->eflags;
 		emulate_push(ctxt);
 		break;
 	case 0x9d: /* popf */
-		c->dst.ptr = (unsigned long *) &_eflags;
+		c->dst.ptr = (unsigned long *) &ctxt->eflags;
 		goto pop_instruction;
 	case 0xc3: /* ret */
 		c->dst.ptr = &c->eip;
@@ -1484,10 +1480,10 @@ special_insn:
 					c->dst.bytes, ctxt->vcpu)) != 0)
 			goto done;
 		register_address_increment(c->regs[VCPU_REGS_RSI],
-				       (_eflags & EFLG_DF) ? -c->dst.bytes
+				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		register_address_increment(c->regs[VCPU_REGS_RDI],
-				       (_eflags & EFLG_DF) ? -c->dst.bytes
+				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		break;
 	case 0xa6 ... 0xa7:	/* cmps */
@@ -1499,7 +1495,7 @@ special_insn:
 		c->dst.ptr = (unsigned long *)cr2;
 		c->dst.val = c->regs[VCPU_REGS_RAX];
 		register_address_increment(c->regs[VCPU_REGS_RDI],
-				       (_eflags & EFLG_DF) ? -c->dst.bytes
+				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		break;
 	case 0xac ... 0xad:	/* lods */
@@ -1511,7 +1507,7 @@ special_insn:
 					     ctxt->vcpu)) != 0)
 			goto done;
 		register_address_increment(c->regs[VCPU_REGS_RSI],
-				       (_eflags & EFLG_DF) ? -c->dst.bytes
+				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		break;
 	case 0xae ... 0xaf:	/* scas */
@@ -1599,7 +1595,8 @@ twobyte_insn:
 		case 6: /* lmsw */
 			if (c->modrm_mod != 3)
 				goto cannot_emulate;
-			realmode_lmsw(ctxt->vcpu, (u16)c->modrm_val, &_eflags);
+			realmode_lmsw(ctxt->vcpu, (u16)c->modrm_val,
+						  &ctxt->eflags);
 			break;
 		case 7: /* invlpg*/
 			emulate_invlpg(ctxt->vcpu, cr2);
@@ -1630,29 +1627,29 @@ twobyte_insn:
 		 */
 		switch ((c->b & 15) >> 1) {
 		case 0:	/* cmovo */
-			no_wb = (_eflags & EFLG_OF) ? 0 : 1;
+			no_wb = (ctxt->eflags & EFLG_OF) ? 0 : 1;
 			break;
 		case 1:	/* cmovb/cmovc/cmovnae */
-			no_wb = (_eflags & EFLG_CF) ? 0 : 1;
+			no_wb = (ctxt->eflags & EFLG_CF) ? 0 : 1;
 			break;
 		case 2:	/* cmovz/cmove */
-			no_wb = (_eflags & EFLG_ZF) ? 0 : 1;
+			no_wb = (ctxt->eflags & EFLG_ZF) ? 0 : 1;
 			break;
 		case 3:	/* cmovbe/cmovna */
-			no_wb = (_eflags & (EFLG_CF | EFLG_ZF)) ? 0 : 1;
+			no_wb = (ctxt->eflags & (EFLG_CF | EFLG_ZF)) ? 0 : 1;
 			break;
 		case 4:	/* cmovs */
-			no_wb = (_eflags & EFLG_SF) ? 0 : 1;
+			no_wb = (ctxt->eflags & EFLG_SF) ? 0 : 1;
 			break;
 		case 5:	/* cmovp/cmovpe */
-			no_wb = (_eflags & EFLG_PF) ? 0 : 1;
+			no_wb = (ctxt->eflags & EFLG_PF) ? 0 : 1;
 			break;
 		case 7:	/* cmovle/cmovng */
-			no_wb = (_eflags & EFLG_ZF) ? 0 : 1;
+			no_wb = (ctxt->eflags & EFLG_ZF) ? 0 : 1;
 			/* fall through */
 		case 6:	/* cmovl/cmovnge */
-			no_wb &= (!(_eflags & EFLG_SF) !=
-			      !(_eflags & EFLG_OF)) ? 0 : 1;
+			no_wb &= (!(ctxt->eflags & EFLG_SF) !=
+			      !(ctxt->eflags & EFLG_OF)) ? 0 : 1;
 			break;
 		}
 		/* Odd cmov opcodes (lsb == 1) have inverted sense. */
@@ -1662,13 +1659,13 @@ twobyte_insn:
 	      bt:		/* bt */
 		/* only subword offset */
 		c->src.val &= (c->dst.bytes << 3) - 1;
-		emulate_2op_SrcV_nobyte("bt", c->src, c->dst, _eflags);
+		emulate_2op_SrcV_nobyte("bt", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0xab:
 	      bts:		/* bts */
 		/* only subword offset */
 		c->src.val &= (c->dst.bytes << 3) - 1;
-		emulate_2op_SrcV_nobyte("bts", c->src, c->dst, _eflags);
+		emulate_2op_SrcV_nobyte("bts", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0xb0 ... 0xb1:	/* cmpxchg */
 		/*
@@ -1677,8 +1674,8 @@ twobyte_insn:
 		 */
 		c->src.orig_val = c->src.val;
 		c->src.val = c->regs[VCPU_REGS_RAX];
-		emulate_2op_SrcV("cmp", c->src, c->dst, _eflags);
-		if (_eflags & EFLG_ZF) {
+		emulate_2op_SrcV("cmp", c->src, c->dst, ctxt->eflags);
+		if (ctxt->eflags & EFLG_ZF) {
 			/* Success: write back to memory. */
 			c->dst.val = c->src.orig_val;
 		} else {
@@ -1691,7 +1688,7 @@ twobyte_insn:
 	      btr:		/* btr */
 		/* only subword offset */
 		c->src.val &= (c->dst.bytes << 3) - 1;
-		emulate_2op_SrcV_nobyte("btr", c->src, c->dst, _eflags);
+		emulate_2op_SrcV_nobyte("btr", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0xb6 ... 0xb7:	/* movzx */
 		c->dst.bytes = c->op_bytes;
@@ -1714,7 +1711,7 @@ twobyte_insn:
 	      btc:		/* btc */
 		/* only subword offset */
 		c->src.val &= (c->dst.bytes << 3) - 1;
-		emulate_2op_SrcV_nobyte("btc", c->src, c->dst, _eflags);
+		emulate_2op_SrcV_nobyte("btc", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0xbe ... 0xbf:	/* movsx */
 		c->dst.bytes = c->op_bytes;
@@ -1753,7 +1750,7 @@ twobyte_special_insn:
 		if (c->modrm_mod != 3)
 			goto cannot_emulate;
 		realmode_set_cr(ctxt->vcpu,
-				c->modrm_reg, c->modrm_val, &_eflags);
+				c->modrm_reg, c->modrm_val, &ctxt->eflags);
 		break;
 	case 0x30:
 		/* wrmsr */
@@ -1795,12 +1792,12 @@ twobyte_special_insn:
 			DPRINTF("jnz: Invalid op_bytes\n");
 			goto cannot_emulate;
 		}
-		if (test_cc(c->b, _eflags))
+		if (test_cc(c->b, ctxt->eflags))
 			JMP_REL(rel);
 		break;
 	}
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
-		rc = emulate_grp9(ctxt, ops, &_eflags, cr2);
+		rc = emulate_grp9(ctxt, ops, cr2);
 		if (rc != 0)
 			goto done;
 		break;
-- 
1.5.3.7


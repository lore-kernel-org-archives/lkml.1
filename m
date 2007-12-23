Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbXLWO4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbXLWO4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbXLWOvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:52 -0500
Received: from il.qumranet.com ([82.166.9.18]:35909 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbXLWOvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:41 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 12/50] KVM: x86 emulator: split some decoding into functions for readability
Date: Sun, 23 Dec 2007 16:50:57 +0200
Message-Id: <1198421495-31481-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

To improve readability, move push, writeback, and grp 1a/2/3/4/5/9 emulation
parts into functions.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |  451 ++++++++++++++++++++++++++------------------
 1 files changed, 266 insertions(+), 185 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index cab1719..a108736 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -907,6 +907,244 @@ done:
 	return (rc == X86EMUL_UNHANDLEABLE) ? -1 : 0;
 }
 
+static inline void emulate_push(struct x86_emulate_ctxt *ctxt)
+{
+	struct decode_cache *c = &ctxt->decode;
+
+	c->dst.type  = OP_MEM;
+	c->dst.bytes = c->op_bytes;
+	c->dst.val = c->src.val;
+	register_address_increment(c->regs[VCPU_REGS_RSP], -c->op_bytes);
+	c->dst.ptr = (void *) register_address(ctxt->ss_base,
+					       c->regs[VCPU_REGS_RSP]);
+}
+
+static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
+				struct x86_emulate_ops *ops)
+{
+	struct decode_cache *c = &ctxt->decode;
+	int rc;
+
+	/* 64-bit mode: POP always pops a 64-bit operand. */
+
+	if (ctxt->mode == X86EMUL_MODE_PROT64)
+		c->dst.bytes = 8;
+
+	rc = ops->read_std(register_address(ctxt->ss_base,
+					    c->regs[VCPU_REGS_RSP]),
+			   &c->dst.val, c->dst.bytes, ctxt->vcpu);
+	if (rc != 0)
+		return rc;
+
+	register_address_increment(c->regs[VCPU_REGS_RSP], c->dst.bytes);
+
+	return 0;
+}
+
+static inline void emulate_grp2(struct decode_cache *c, unsigned long *_eflags)
+{
+	switch (c->modrm_reg) {
+	case 0:	/* rol */
+		emulate_2op_SrcB("rol", c->src, c->dst, *_eflags);
+		break;
+	case 1:	/* ror */
+		emulate_2op_SrcB("ror", c->src, c->dst, *_eflags);
+		break;
+	case 2:	/* rcl */
+		emulate_2op_SrcB("rcl", c->src, c->dst, *_eflags);
+		break;
+	case 3:	/* rcr */
+		emulate_2op_SrcB("rcr", c->src, c->dst, *_eflags);
+		break;
+	case 4:	/* sal/shl */
+	case 6:	/* sal/shl */
+		emulate_2op_SrcB("sal", c->src, c->dst, *_eflags);
+		break;
+	case 5:	/* shr */
+		emulate_2op_SrcB("shr", c->src, c->dst, *_eflags);
+		break;
+	case 7:	/* sar */
+		emulate_2op_SrcB("sar", c->src, c->dst, *_eflags);
+		break;
+	}
+}
+
+static inline int emulate_grp3(struct x86_emulate_ctxt *ctxt,
+			       struct x86_emulate_ops *ops,
+			       unsigned long *_eflags)
+{
+	struct decode_cache *c = &ctxt->decode;
+	int rc = 0;
+
+	switch (c->modrm_reg) {
+	case 0 ... 1:	/* test */
+		/*
+		 * Special case in Grp3: test has an immediate
+		 * source operand.
+		 */
+		c->src.type = OP_IMM;
+		c->src.ptr = (unsigned long *)c->eip;
+		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		if (c->src.bytes == 8)
+			c->src.bytes = 4;
+		switch (c->src.bytes) {
+		case 1:
+			c->src.val = insn_fetch(s8, 1, c->eip);
+			break;
+		case 2:
+			c->src.val = insn_fetch(s16, 2, c->eip);
+			break;
+		case 4:
+			c->src.val = insn_fetch(s32, 4, c->eip);
+			break;
+		}
+		emulate_2op_SrcV("test", c->src, c->dst, *_eflags);
+		break;
+	case 2:	/* not */
+		c->dst.val = ~c->dst.val;
+		break;
+	case 3:	/* neg */
+		emulate_1op("neg", c->dst, *_eflags);
+		break;
+	default:
+		DPRINTF("Cannot emulate %02x\n", c->b);
+		rc = X86EMUL_UNHANDLEABLE;
+		break;
+	}
+done:
+	return rc;
+}
+
+static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
+			       struct x86_emulate_ops *ops,
+			       unsigned long *_eflags,
+			       int *no_wb)
+{
+	struct decode_cache *c = &ctxt->decode;
+	int rc;
+
+	switch (c->modrm_reg) {
+	case 0:	/* inc */
+		emulate_1op("inc", c->dst, *_eflags);
+		break;
+	case 1:	/* dec */
+		emulate_1op("dec", c->dst, *_eflags);
+		break;
+	case 4: /* jmp abs */
+		if (c->b == 0xff)
+			c->eip = c->dst.val;
+		else {
+			DPRINTF("Cannot emulate %02x\n", c->b);
+			return X86EMUL_UNHANDLEABLE;
+		}
+		break;
+	case 6:	/* push */
+
+		/* 64-bit mode: PUSH always pushes a 64-bit operand. */
+
+		if (ctxt->mode == X86EMUL_MODE_PROT64) {
+			c->dst.bytes = 8;
+			rc = ops->read_std((unsigned long)c->dst.ptr,
+					   &c->dst.val, 8, ctxt->vcpu);
+			if (rc != 0)
+				return rc;
+		}
+		register_address_increment(c->regs[VCPU_REGS_RSP],
+					   -c->dst.bytes);
+		rc = ops->write_emulated(register_address(ctxt->ss_base,
+				    c->regs[VCPU_REGS_RSP]), &c->dst.val,
+				    c->dst.bytes, ctxt->vcpu);
+		if (rc != 0)
+			return rc;
+		*no_wb = 1;
+		break;
+	default:
+		DPRINTF("Cannot emulate %02x\n", c->b);
+		return X86EMUL_UNHANDLEABLE;
+	}
+	return 0;
+}
+
+static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
+			       struct x86_emulate_ops *ops,
+			       unsigned long *_eflags,
+			       unsigned long cr2)
+{
+	struct decode_cache *c = &ctxt->decode;
+	u64 old, new;
+	int rc;
+
+	rc = ops->read_emulated(cr2, &old, 8, ctxt->vcpu);
+	if (rc != 0)
+		return rc;
+
+	if (((u32) (old >> 0) != (u32) c->regs[VCPU_REGS_RAX]) ||
+	    ((u32) (old >> 32) != (u32) c->regs[VCPU_REGS_RDX])) {
+
+		c->regs[VCPU_REGS_RAX] = (u32) (old >> 0);
+		c->regs[VCPU_REGS_RDX] = (u32) (old >> 32);
+		*_eflags &= ~EFLG_ZF;
+
+	} else {
+		new = ((u64)c->regs[VCPU_REGS_RCX] << 32) |
+		       (u32) c->regs[VCPU_REGS_RBX];
+
+		rc = ops->cmpxchg_emulated(cr2, &old, &new, 8, ctxt->vcpu);
+		if (rc != 0)
+			return rc;
+		*_eflags |= EFLG_ZF;
+	}
+	return 0;
+}
+
+static inline int writeback(struct x86_emulate_ctxt *ctxt,
+			    struct x86_emulate_ops *ops)
+{
+	int rc;
+	struct decode_cache *c = &ctxt->decode;
+
+	switch (c->dst.type) {
+	case OP_REG:
+		/* The 4-byte case *is* correct:
+		 * in 64-bit mode we zero-extend.
+		 */
+		switch (c->dst.bytes) {
+		case 1:
+			*(u8 *)c->dst.ptr = (u8)c->dst.val;
+			break;
+		case 2:
+			*(u16 *)c->dst.ptr = (u16)c->dst.val;
+			break;
+		case 4:
+			*c->dst.ptr = (u32)c->dst.val;
+			break;	/* 64b: zero-ext */
+		case 8:
+			*c->dst.ptr = c->dst.val;
+			break;
+		}
+		break;
+	case OP_MEM:
+		if (c->lock_prefix)
+			rc = ops->cmpxchg_emulated(
+					(unsigned long)c->dst.ptr,
+					&c->dst.orig_val,
+					&c->dst.val,
+					c->dst.bytes,
+					ctxt->vcpu);
+		else
+			rc = ops->write_emulated(
+					(unsigned long)c->dst.ptr,
+					&c->dst.val,
+					c->dst.bytes,
+					ctxt->vcpu);
+		if (rc != 0)
+			return rc;
+	default:
+		break;
+	}
+	return 0;
+}
+
 int
 x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
@@ -1042,7 +1280,6 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		}
 		break;
 	case 0x84 ... 0x85:
-	      test:		/* test */
 		emulate_2op_SrcV("test", c->src, c->dst, _eflags);
 		break;
 	case 0x86 ... 0x87:	/* xchg */
@@ -1074,18 +1311,9 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		c->dst.val = c->modrm_val;
 		break;
 	case 0x8f:		/* pop (sole member of Grp1a) */
-		/* 64-bit mode: POP always pops a 64-bit operand. */
-		if (ctxt->mode == X86EMUL_MODE_PROT64)
-			c->dst.bytes = 8;
-		if ((rc = ops->read_std(register_address(
-						   ctxt->ss_base,
-						   c->regs[VCPU_REGS_RSP]),
-						   &c->dst.val,
-						   c->dst.bytes,
-						   ctxt->vcpu)) != 0)
+		rc = emulate_grp1a(ctxt, ops);
+		if (rc != 0)
 			goto done;
-		register_address_increment(c->regs[VCPU_REGS_RSP],
-					   c->dst.bytes);
 		break;
 	case 0xa0 ... 0xa1:	/* mov */
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
@@ -1099,31 +1327,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		c->eip += c->ad_bytes;
 		break;
 	case 0xc0 ... 0xc1:
-	      grp2:		/* Grp2 */
-		switch (c->modrm_reg) {
-		case 0:	/* rol */
-			emulate_2op_SrcB("rol", c->src, c->dst, _eflags);
-			break;
-		case 1:	/* ror */
-			emulate_2op_SrcB("ror", c->src, c->dst, _eflags);
-			break;
-		case 2:	/* rcl */
-			emulate_2op_SrcB("rcl", c->src, c->dst, _eflags);
-			break;
-		case 3:	/* rcr */
-			emulate_2op_SrcB("rcr", c->src, c->dst, _eflags);
-			break;
-		case 4:	/* sal/shl */
-		case 6:	/* sal/shl */
-			emulate_2op_SrcB("sal", c->src, c->dst, _eflags);
-			break;
-		case 5:	/* shr */
-			emulate_2op_SrcB("shr", c->src, c->dst, _eflags);
-			break;
-		case 7:	/* sar */
-			emulate_2op_SrcB("sar", c->src, c->dst, _eflags);
-			break;
-		}
+		emulate_grp2(c, &_eflags);
 		break;
 	case 0xc6 ... 0xc7:	/* mov (sole member of Grp11) */
 	mov:
@@ -1131,126 +1335,29 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		break;
 	case 0xd0 ... 0xd1:	/* Grp2 */
 		c->src.val = 1;
-		goto grp2;
+		emulate_grp2(c, &_eflags);
+		break;
 	case 0xd2 ... 0xd3:	/* Grp2 */
 		c->src.val = c->regs[VCPU_REGS_RCX];
-		goto grp2;
+		emulate_grp2(c, &_eflags);
+		break;
 	case 0xf6 ... 0xf7:	/* Grp3 */
-		switch (c->modrm_reg) {
-		case 0 ... 1:	/* test */
-			/*
-			 * Special case in Grp3: test has an immediate
-			 * source operand.
-			 */
-			c->src.type = OP_IMM;
-			c->src.ptr = (unsigned long *)c->eip;
-			c->src.bytes = (c->d & ByteOp) ? 1 :
-							       c->op_bytes;
-			if (c->src.bytes == 8)
-				c->src.bytes = 4;
-			switch (c->src.bytes) {
-			case 1:
-				c->src.val = insn_fetch(s8, 1, c->eip);
-				break;
-			case 2:
-				c->src.val = insn_fetch(s16, 2, c->eip);
-				break;
-			case 4:
-				c->src.val = insn_fetch(s32, 4, c->eip);
-				break;
-			}
-			goto test;
-		case 2:	/* not */
-			c->dst.val = ~c->dst.val;
-			break;
-		case 3:	/* neg */
-			emulate_1op("neg", c->dst, _eflags);
-			break;
-		default:
-			goto cannot_emulate;
-		}
+		rc = emulate_grp3(ctxt, ops, &_eflags);
+		if (rc != 0)
+			goto done;
 		break;
 	case 0xfe ... 0xff:	/* Grp4/Grp5 */
-		switch (c->modrm_reg) {
-		case 0:	/* inc */
-			emulate_1op("inc", c->dst, _eflags);
-			break;
-		case 1:	/* dec */
-			emulate_1op("dec", c->dst, _eflags);
-			break;
-		case 4: /* jmp abs */
-			if (c->b == 0xff)
-				c->eip = c->dst.val;
-			else
-				goto cannot_emulate;
-			break;
-		case 6:	/* push */
-			/* 64-bit mode: PUSH always pushes a 64-bit operand. */
-			if (ctxt->mode == X86EMUL_MODE_PROT64) {
-				c->dst.bytes = 8;
-				if ((rc = ops->read_std(
-						 (unsigned long)c->dst.ptr,
-						 &c->dst.val, 8,
-						 ctxt->vcpu)) != 0)
-					goto done;
-			}
-			register_address_increment(c->regs[VCPU_REGS_RSP],
-						   -c->dst.bytes);
-			if ((rc = ops->write_emulated(
-				     register_address(ctxt->ss_base,
-					  c->regs[VCPU_REGS_RSP]),
-					  &c->dst.val,
-					   c->dst.bytes, ctxt->vcpu)) != 0)
-				goto done;
-			no_wb = 1;
-			break;
-		default:
-			goto cannot_emulate;
-		}
+		rc = emulate_grp45(ctxt, ops, &_eflags, &no_wb);
+		if (rc != 0)
+			goto done;
 		break;
 	}
 
 writeback:
 	if (!no_wb) {
-		switch (c->dst.type) {
-		case OP_REG:
-			/* The 4-byte case *is* correct:
-			 * in 64-bit mode we zero-extend.
-			 */
-			switch (c->dst.bytes) {
-			case 1:
-				*(u8 *)c->dst.ptr = (u8)c->dst.val;
-				break;
-			case 2:
-				*(u16 *)c->dst.ptr = (u16)c->dst.val;
-				break;
-			case 4:
-				*c->dst.ptr = (u32)c->dst.val;
-				break;	/* 64b: zero-ext */
-			case 8:
-				*c->dst.ptr = c->dst.val;
-				break;
-			}
-			break;
-		case OP_MEM:
-			if (c->lock_prefix)
-				rc = ops->cmpxchg_emulated(
-						(unsigned long)c->dst.ptr,
-						&c->dst.orig_val,
-						&c->dst.val,
-						c->dst.bytes,
-						ctxt->vcpu);
-			else
-				rc = ops->write_emulated(
-						(unsigned long)c->dst.ptr,
-						&c->dst.val,
-						c->dst.bytes,
-						ctxt->vcpu);
-			if (rc != 0)
-				goto done;
-		default:
-			break;
-		}
+		rc = writeback(ctxt, ops);
+		if (rc != 0)
+			goto done;
 	}
 
 	/* Commit shadow register state. */
@@ -1283,8 +1390,7 @@ special_insn:
 			ctxt->ss_base, c->regs[VCPU_REGS_RSP]);
 		break;
 	case 0x58 ... 0x5f: /* pop reg */
-		c->dst.ptr =
-				(unsigned long *)&c->regs[c->b & 0x7];
+		c->dst.ptr = (unsigned long *)&c->regs[c->b & 0x7];
 	pop_instruction:
 		if ((rc = ops->read_std(register_address(ctxt->ss_base,
 			c->regs[VCPU_REGS_RSP]), c->dst.ptr,
@@ -1298,14 +1404,7 @@ special_insn:
 	case 0x6a: /* push imm8 */
 		c->src.val = 0L;
 		c->src.val = insn_fetch(s8, 1, c->eip);
-push:
-		c->dst.type  = OP_MEM;
-		c->dst.bytes = c->op_bytes;
-		c->dst.val = c->src.val;
-		register_address_increment(c->regs[VCPU_REGS_RSP],
-					   -c->op_bytes);
-		c->dst.ptr = (void *) register_address(ctxt->ss_base,
-						       c->regs[VCPU_REGS_RSP]);
+		emulate_push(ctxt);
 		break;
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
@@ -1350,7 +1449,8 @@ push:
 	}
 	case 0x9c: /* pushf */
 		c->src.val =  (unsigned long) _eflags;
-		goto push;
+		emulate_push(ctxt);
+		break;
 	case 0x9d: /* popf */
 		c->dst.ptr = (unsigned long *) &_eflags;
 		goto pop_instruction;
@@ -1436,7 +1536,8 @@ push:
 		c->src.val = (unsigned long) c->eip;
 		JMP_REL(rel);
 		c->op_bytes = c->ad_bytes;
-		goto push;
+		emulate_push(ctxt);
+		break;
 	}
 	case 0xe9: /* jmp rel */
 	case 0xeb: /* jmp rel short */
@@ -1511,8 +1612,7 @@ twobyte_insn:
 		no_wb = 1;
 		if (c->modrm_mod != 3)
 			goto cannot_emulate;
-		rc = emulator_get_dr(ctxt, c->modrm_reg,
-				     &c->regs[c->modrm_rm]);
+		rc = emulator_get_dr(ctxt, c->modrm_reg, &c->regs[c->modrm_rm]);
 		break;
 	case 0x23: /* mov from reg to dr */
 		no_wb = 1;
@@ -1668,8 +1768,7 @@ twobyte_special_insn:
 		break;
 	case 0x32:
 		/* rdmsr */
-		rc = kvm_get_msr(ctxt->vcpu,
-				 c->regs[VCPU_REGS_RCX], &msr_data);
+		rc = kvm_get_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], &msr_data);
 		if (rc) {
 			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
 			c->eip = ctxt->vcpu->rip;
@@ -1701,28 +1800,10 @@ twobyte_special_insn:
 		break;
 	}
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
-		{
-			u64 old, new;
-			if ((rc = ops->read_emulated(cr2, &old, 8, ctxt->vcpu))
-									!= 0)
-				goto done;
-			if (((u32) (old >> 0) !=
-					(u32) c->regs[VCPU_REGS_RAX]) ||
-			    ((u32) (old >> 32) !=
-					(u32) c->regs[VCPU_REGS_RDX])) {
-				c->regs[VCPU_REGS_RAX] = (u32) (old >> 0);
-				c->regs[VCPU_REGS_RDX] = (u32) (old >> 32);
-				_eflags &= ~EFLG_ZF;
-			} else {
-				new = ((u64)c->regs[VCPU_REGS_RCX] << 32)
-					| (u32) c->regs[VCPU_REGS_RBX];
-				if ((rc = ops->cmpxchg_emulated(cr2, &old,
-							  &new, 8, ctxt->vcpu)) != 0)
-					goto done;
-				_eflags |= EFLG_ZF;
-			}
-			break;
-		}
+		rc = emulate_grp9(ctxt, ops, &_eflags, cr2);
+		if (rc != 0)
+			goto done;
+		break;
 	}
 	goto writeback;
 
-- 
1.5.3.7


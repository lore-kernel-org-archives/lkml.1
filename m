Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbYAAPyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbYAAPyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYAAPhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:33799 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 18/54] KVM: x86 emulator: unify four switch statements into two
Date: Tue,  1 Jan 2008 17:35:44 +0200
Message-Id: <1199201780-14001-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the special instruction switch with the regular instruction switch,
and the two byte special instruction switch with the regular two byte
instruction switch.  That makes it much easier to find an instruction or
the place an instruction needs to be added in.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |  342 ++++++++++++++++++++++-----------------------
 1 files changed, 168 insertions(+), 174 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 499d1ad..3e3eba7 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1294,6 +1294,8 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	}
 	c->dst.orig_val = c->dst.val;
 
+special_insn:
+
 	if (c->twobyte)
 		goto twobyte_insn;
 
@@ -1378,6 +1380,52 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 			goto cannot_emulate;
 		c->dst.val = (s32) c->src.val;
 		break;
+	case 0x6a: /* push imm8 */
+		c->src.val = 0L;
+		c->src.val = insn_fetch(s8, 1, c->eip);
+		emulate_push(ctxt);
+		break;
+	case 0x6c:		/* insb */
+	case 0x6d:		/* insw/insd */
+		 if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
+				1,
+				(c->d & ByteOp) ? 1 : c->op_bytes,
+				c->rep_prefix ?
+				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
+				(ctxt->eflags & EFLG_DF),
+				register_address(ctxt->es_base,
+						 c->regs[VCPU_REGS_RDI]),
+				c->rep_prefix,
+				c->regs[VCPU_REGS_RDX]) == 0) {
+			c->eip = saved_eip;
+			return -1;
+		}
+		return 0;
+	case 0x6e:		/* outsb */
+	case 0x6f:		/* outsw/outsd */
+		if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
+				0,
+				(c->d & ByteOp) ? 1 : c->op_bytes,
+				c->rep_prefix ?
+				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
+				(ctxt->eflags & EFLG_DF),
+				register_address(c->override_base ?
+							*c->override_base :
+							ctxt->ds_base,
+						 c->regs[VCPU_REGS_RSI]),
+				c->rep_prefix,
+				c->regs[VCPU_REGS_RDX]) == 0) {
+			c->eip = saved_eip;
+			return -1;
+		}
+		return 0;
+	case 0x70 ... 0x7f: /* jcc (short) */ {
+		int rel = insn_fetch(s8, 1, c->eip);
+
+		if (test_cc(c->b, ctxt->eflags))
+			JMP_REL(rel);
+		break;
+	}
 	case 0x80 ... 0x83:	/* Grp1 */
 		switch (c->modrm_reg) {
 		case 0:
@@ -1434,106 +1482,6 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		if (rc != 0)
 			goto done;
 		break;
-	case 0xa0 ... 0xa1:	/* mov */
-		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
-		c->dst.val = c->src.val;
-		break;
-	case 0xa2 ... 0xa3:	/* mov */
-		c->dst.val = (unsigned long)c->regs[VCPU_REGS_RAX];
-		break;
-	case 0xc0 ... 0xc1:
-		emulate_grp2(ctxt);
-		break;
-	case 0xc6 ... 0xc7:	/* mov (sole member of Grp11) */
-	mov:
-		c->dst.val = c->src.val;
-		break;
-	case 0xd0 ... 0xd1:	/* Grp2 */
-		c->src.val = 1;
-		emulate_grp2(ctxt);
-		break;
-	case 0xd2 ... 0xd3:	/* Grp2 */
-		c->src.val = c->regs[VCPU_REGS_RCX];
-		emulate_grp2(ctxt);
-		break;
-	case 0xf6 ... 0xf7:	/* Grp3 */
-		rc = emulate_grp3(ctxt, ops);
-		if (rc != 0)
-			goto done;
-		break;
-	case 0xfe ... 0xff:	/* Grp4/Grp5 */
-		rc = emulate_grp45(ctxt, ops);
-		if (rc != 0)
-			goto done;
-		break;
-	}
-
-writeback:
-	rc = writeback(ctxt, ops);
-	if (rc != 0)
-		goto done;
-
-	/* Commit shadow register state. */
-	memcpy(ctxt->vcpu->regs, c->regs, sizeof c->regs);
-	ctxt->vcpu->rip = c->eip;
-
-done:
-	if (rc == X86EMUL_UNHANDLEABLE) {
-		c->eip = saved_eip;
-		return -1;
-	}
-	return 0;
-
-special_insn:
-	if (c->twobyte)
-		goto twobyte_special_insn;
-	switch (c->b) {
-	case 0x6a: /* push imm8 */
-		c->src.val = 0L;
-		c->src.val = insn_fetch(s8, 1, c->eip);
-		emulate_push(ctxt);
-		break;
-	case 0x6c:		/* insb */
-	case 0x6d:		/* insw/insd */
-		 if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
-				1,
-				(c->d & ByteOp) ? 1 : c->op_bytes,
-				c->rep_prefix ?
-				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
-				(ctxt->eflags & EFLG_DF),
-				register_address(ctxt->es_base,
-						 c->regs[VCPU_REGS_RDI]),
-				c->rep_prefix,
-				c->regs[VCPU_REGS_RDX]) == 0) {
-			c->eip = saved_eip;
-			return -1;
-		}
-		return 0;
-	case 0x6e:		/* outsb */
-	case 0x6f:		/* outsw/outsd */
-		if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
-				0,
-				(c->d & ByteOp) ? 1 : c->op_bytes,
-				c->rep_prefix ?
-				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
-				(ctxt->eflags & EFLG_DF),
-				register_address(c->override_base ?
-							*c->override_base :
-							ctxt->ds_base,
-						 c->regs[VCPU_REGS_RSI]),
-				c->rep_prefix,
-				c->regs[VCPU_REGS_RDX]) == 0) {
-			c->eip = saved_eip;
-			return -1;
-		}
-		return 0;
-	case 0x70 ... 0x7f: /* jcc (short) */ {
-		int rel = insn_fetch(s8, 1, c->eip);
-
-		if (test_cc(c->b, ctxt->eflags))
-		JMP_REL(rel);
-		break;
-	}
 	case 0x9c: /* pushf */
 		c->src.val =  (unsigned long) ctxt->eflags;
 		emulate_push(ctxt);
@@ -1541,6 +1489,13 @@ special_insn:
 	case 0x9d: /* popf */
 		c->dst.ptr = (unsigned long *) &ctxt->eflags;
 		goto pop_instruction;
+	case 0xa0 ... 0xa1:	/* mov */
+		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
+		c->dst.val = c->src.val;
+		break;
+	case 0xa2 ... 0xa3:	/* mov */
+		c->dst.val = (unsigned long)c->regs[VCPU_REGS_RAX];
+		break;
 	case 0xa4 ... 0xa5:	/* movs */
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
@@ -1627,9 +1582,24 @@ special_insn:
 	case 0xae ... 0xaf:	/* scas */
 		DPRINTF("Urk! I don't handle SCAS.\n");
 		goto cannot_emulate;
+	case 0xc0 ... 0xc1:
+		emulate_grp2(ctxt);
+		break;
 	case 0xc3: /* ret */
 		c->dst.ptr = &c->eip;
 		goto pop_instruction;
+	case 0xc6 ... 0xc7:	/* mov (sole member of Grp11) */
+	mov:
+		c->dst.val = c->src.val;
+		break;
+	case 0xd0 ... 0xd1:	/* Grp2 */
+		c->src.val = 1;
+		emulate_grp2(ctxt);
+		break;
+	case 0xd2 ... 0xd3:	/* Grp2 */
+		c->src.val = c->regs[VCPU_REGS_RCX];
+		emulate_grp2(ctxt);
+		break;
 	case 0xe8: /* call (near) */ {
 		long int rel;
 		switch (c->op_bytes) {
@@ -1662,6 +1632,11 @@ special_insn:
 		ctxt->eflags ^= EFLG_CF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
+	case 0xf6 ... 0xf7:	/* Grp3 */
+		rc = emulate_grp3(ctxt, ops);
+		if (rc != 0)
+			goto done;
+		break;
 	case 0xf8: /* clc */
 		ctxt->eflags &= ~EFLG_CF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
@@ -1674,8 +1649,28 @@ special_insn:
 		ctxt->eflags |= X86_EFLAGS_IF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
+	case 0xfe ... 0xff:	/* Grp4/Grp5 */
+		rc = emulate_grp45(ctxt, ops);
+		if (rc != 0)
+			goto done;
+		break;
 	}
-	goto writeback;
+
+writeback:
+	rc = writeback(ctxt, ops);
+	if (rc != 0)
+		goto done;
+
+	/* Commit shadow register state. */
+	memcpy(ctxt->vcpu->regs, c->regs, sizeof c->regs);
+	ctxt->vcpu->rip = c->eip;
+
+done:
+	if (rc == X86EMUL_UNHANDLEABLE) {
+		c->eip = saved_eip;
+		return -1;
+	}
+	return 0;
 
 twobyte_insn:
 	switch (c->b) {
@@ -1737,6 +1732,23 @@ twobyte_insn:
 		/* Disable writeback. */
 		c->dst.type = OP_NONE;
 		break;
+	case 0x06:
+		emulate_clts(ctxt->vcpu);
+		c->dst.type = OP_NONE;
+		break;
+	case 0x08:		/* invd */
+	case 0x09:		/* wbinvd */
+	case 0x0d:		/* GrpP (prefetch) */
+	case 0x18:		/* Grp16 (prefetch/nop) */
+		c->dst.type = OP_NONE;
+		break;
+	case 0x20: /* mov cr, reg */
+		if (c->modrm_mod != 3)
+			goto cannot_emulate;
+		c->regs[c->modrm_rm] =
+				realmode_get_cr(ctxt->vcpu, c->modrm_reg);
+		c->dst.type = OP_NONE;	/* no writeback */
+		break;
 	case 0x21: /* mov from dr to reg */
 		if (c->modrm_mod != 3)
 			goto cannot_emulate;
@@ -1745,6 +1757,13 @@ twobyte_insn:
 			goto cannot_emulate;
 		c->dst.type = OP_NONE;	/* no writeback */
 		break;
+	case 0x22: /* mov reg, cr */
+		if (c->modrm_mod != 3)
+			goto cannot_emulate;
+		realmode_set_cr(ctxt->vcpu,
+				c->modrm_reg, c->modrm_val, &ctxt->eflags);
+		c->dst.type = OP_NONE;
+		break;
 	case 0x23: /* mov from reg to dr */
 		if (c->modrm_mod != 3)
 			goto cannot_emulate;
@@ -1754,11 +1773,58 @@ twobyte_insn:
 			goto cannot_emulate;
 		c->dst.type = OP_NONE;	/* no writeback */
 		break;
+	case 0x30:
+		/* wrmsr */
+		msr_data = (u32)c->regs[VCPU_REGS_RAX]
+			| ((u64)c->regs[VCPU_REGS_RDX] << 32);
+		rc = kvm_set_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], msr_data);
+		if (rc) {
+			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
+			c->eip = ctxt->vcpu->rip;
+		}
+		rc = X86EMUL_CONTINUE;
+		c->dst.type = OP_NONE;
+		break;
+	case 0x32:
+		/* rdmsr */
+		rc = kvm_get_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], &msr_data);
+		if (rc) {
+			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
+			c->eip = ctxt->vcpu->rip;
+		} else {
+			c->regs[VCPU_REGS_RAX] = (u32)msr_data;
+			c->regs[VCPU_REGS_RDX] = msr_data >> 32;
+		}
+		rc = X86EMUL_CONTINUE;
+		c->dst.type = OP_NONE;
+		break;
 	case 0x40 ... 0x4f:	/* cmov */
 		c->dst.val = c->dst.orig_val = c->src.val;
 		if (!test_cc(c->b, ctxt->eflags))
 			c->dst.type = OP_NONE; /* no writeback */
 		break;
+	case 0x80 ... 0x8f: /* jnz rel, etc*/ {
+		long int rel;
+
+		switch (c->op_bytes) {
+		case 2:
+			rel = insn_fetch(s16, 2, c->eip);
+			break;
+		case 4:
+			rel = insn_fetch(s32, 4, c->eip);
+			break;
+		case 8:
+			rel = insn_fetch(s64, 8, c->eip);
+			break;
+		default:
+			DPRINTF("jnz: Invalid op_bytes\n");
+			goto cannot_emulate;
+		}
+		if (test_cc(c->b, ctxt->eflags))
+			JMP_REL(rel);
+		c->dst.type = OP_NONE;
+		break;
+	}
 	case 0xa3:
 	      bt:		/* bt */
 		c->dst.type = OP_NONE;
@@ -1828,85 +1894,13 @@ twobyte_insn:
 		c->dst.val = (c->op_bytes == 4) ? (u32) c->src.val :
 							(u64) c->src.val;
 		break;
-	}
-	goto writeback;
-
-twobyte_special_insn:
-	switch (c->b) {
-	case 0x06:
-		emulate_clts(ctxt->vcpu);
-		break;
-	case 0x08:		/* invd */
-		break;
-	case 0x09:		/* wbinvd */
-		break;
-	case 0x0d:		/* GrpP (prefetch) */
-	case 0x18:		/* Grp16 (prefetch/nop) */
-		break;
-	case 0x20: /* mov cr, reg */
-		if (c->modrm_mod != 3)
-			goto cannot_emulate;
-		c->regs[c->modrm_rm] =
-				realmode_get_cr(ctxt->vcpu, c->modrm_reg);
-		break;
-	case 0x22: /* mov reg, cr */
-		if (c->modrm_mod != 3)
-			goto cannot_emulate;
-		realmode_set_cr(ctxt->vcpu,
-				c->modrm_reg, c->modrm_val, &ctxt->eflags);
-		break;
-	case 0x30:
-		/* wrmsr */
-		msr_data = (u32)c->regs[VCPU_REGS_RAX]
-			| ((u64)c->regs[VCPU_REGS_RDX] << 32);
-		rc = kvm_set_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], msr_data);
-		if (rc) {
-			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
-			c->eip = ctxt->vcpu->rip;
-		}
-		rc = X86EMUL_CONTINUE;
-		break;
-	case 0x32:
-		/* rdmsr */
-		rc = kvm_get_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], &msr_data);
-		if (rc) {
-			kvm_x86_ops->inject_gp(ctxt->vcpu, 0);
-			c->eip = ctxt->vcpu->rip;
-		} else {
-			c->regs[VCPU_REGS_RAX] = (u32)msr_data;
-			c->regs[VCPU_REGS_RDX] = msr_data >> 32;
-		}
-		rc = X86EMUL_CONTINUE;
-		break;
-	case 0x80 ... 0x8f: /* jnz rel, etc*/ {
-		long int rel;
-
-		switch (c->op_bytes) {
-		case 2:
-			rel = insn_fetch(s16, 2, c->eip);
-			break;
-		case 4:
-			rel = insn_fetch(s32, 4, c->eip);
-			break;
-		case 8:
-			rel = insn_fetch(s64, 8, c->eip);
-			break;
-		default:
-			DPRINTF("jnz: Invalid op_bytes\n");
-			goto cannot_emulate;
-		}
-		if (test_cc(c->b, ctxt->eflags))
-			JMP_REL(rel);
-		break;
-	}
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
 		rc = emulate_grp9(ctxt, ops, memop);
 		if (rc != 0)
 			goto done;
+		c->dst.type = OP_NONE;
 		break;
 	}
-	/* Disable writeback. */
-	c->dst.type = OP_NONE;
 	goto writeback;
 
 cannot_emulate:
-- 
1.5.3.7


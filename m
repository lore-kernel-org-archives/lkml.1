Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXLWPET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXLWPET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbXLWOwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:23 -0500
Received: from il.qumranet.com ([82.166.9.18]:35914 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbXLWOvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 14/50] KVM: x86 emulator: Remove no_wb, use dst.type = OP_NONE instead
Date: Sun, 23 Dec 2007 16:50:59 +0200
Message-Id: <1198421495-31481-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Remove no_wb, use dst.type = OP_NONE instead, idea stollen from xen-3.1

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   76 ++++++++++++++------------------------------
 drivers/kvm/x86_emulate.h |    2 +-
 2 files changed, 25 insertions(+), 53 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 45beeb9..8b0186f 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1016,8 +1016,7 @@ done:
 }
 
 static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
-			       struct x86_emulate_ops *ops,
-			       int *no_wb)
+			       struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
@@ -1055,7 +1054,7 @@ static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 				    c->dst.bytes, ctxt->vcpu);
 		if (rc != 0)
 			return rc;
-		*no_wb = 1;
+		c->dst.type = OP_NONE;
 		break;
 	default:
 		DPRINTF("Cannot emulate %02x\n", c->b);
@@ -1137,6 +1136,10 @@ static inline int writeback(struct x86_emulate_ctxt *ctxt,
 					ctxt->vcpu);
 		if (rc != 0)
 			return rc;
+		break;
+	case OP_NONE:
+		/* no writeback */
+		break;
 	default:
 		break;
 	}
@@ -1147,7 +1150,6 @@ int
 x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
 	unsigned long cr2 = ctxt->cr2;
-	int no_wb = 0;
 	u64 msr_data;
 	unsigned long saved_eip = 0;
 	struct decode_cache *c = &ctxt->decode;
@@ -1344,18 +1346,16 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 			goto done;
 		break;
 	case 0xfe ... 0xff:	/* Grp4/Grp5 */
-		rc = emulate_grp45(ctxt, ops, &no_wb);
+		rc = emulate_grp45(ctxt, ops);
 		if (rc != 0)
 			goto done;
 		break;
 	}
 
 writeback:
-	if (!no_wb) {
-		rc = writeback(ctxt, ops);
-		if (rc != 0)
-			goto done;
-	}
+	rc = writeback(ctxt, ops);
+	if (rc != 0)
+		goto done;
 
 	/* Commit shadow register state. */
 	memcpy(ctxt->vcpu->regs, c->regs, sizeof c->regs);
@@ -1395,7 +1395,7 @@ special_insn:
 
 		register_address_increment(c->regs[VCPU_REGS_RSP],
 					   c->op_bytes);
-		no_wb = 1; /* Disable writeback. */
+		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
 	case 0x6a: /* push imm8 */
 		c->src.val = 0L;
@@ -1538,7 +1538,7 @@ special_insn:
 	case 0xe9: /* jmp rel */
 	case 0xeb: /* jmp rel short */
 		JMP_REL(c->src.val);
-		no_wb = 1; /* Disable writeback. */
+		c->dst.type = OP_NONE; /* Disable writeback. */
 		break;
 
 
@@ -1548,8 +1548,6 @@ special_insn:
 twobyte_insn:
 	switch (c->b) {
 	case 0x01: /* lgdt, lidt, lmsw */
-		/* Disable writeback. */
-		no_wb = 1;
 		switch (c->modrm_reg) {
 			u16 size;
 			unsigned long address;
@@ -1604,56 +1602,30 @@ twobyte_insn:
 		default:
 			goto cannot_emulate;
 		}
+		/* Disable writeback. */
+		c->dst.type = OP_NONE;
 		break;
 	case 0x21: /* mov from dr to reg */
-		no_wb = 1;
 		if (c->modrm_mod != 3)
 			goto cannot_emulate;
 		rc = emulator_get_dr(ctxt, c->modrm_reg, &c->regs[c->modrm_rm]);
+		if (rc)
+			goto cannot_emulate;
+		c->dst.type = OP_NONE;	/* no writeback */
 		break;
 	case 0x23: /* mov from reg to dr */
-		no_wb = 1;
 		if (c->modrm_mod != 3)
 			goto cannot_emulate;
 		rc = emulator_set_dr(ctxt, c->modrm_reg,
 				     c->regs[c->modrm_rm]);
+		if (rc)
+			goto cannot_emulate;
+		c->dst.type = OP_NONE;	/* no writeback */
 		break;
 	case 0x40 ... 0x4f:	/* cmov */
 		c->dst.val = c->dst.orig_val = c->src.val;
-		no_wb = 1;
-		/*
-		 * First, assume we're decoding an even cmov opcode
-		 * (lsb == 0).
-		 */
-		switch ((c->b & 15) >> 1) {
-		case 0:	/* cmovo */
-			no_wb = (ctxt->eflags & EFLG_OF) ? 0 : 1;
-			break;
-		case 1:	/* cmovb/cmovc/cmovnae */
-			no_wb = (ctxt->eflags & EFLG_CF) ? 0 : 1;
-			break;
-		case 2:	/* cmovz/cmove */
-			no_wb = (ctxt->eflags & EFLG_ZF) ? 0 : 1;
-			break;
-		case 3:	/* cmovbe/cmovna */
-			no_wb = (ctxt->eflags & (EFLG_CF | EFLG_ZF)) ? 0 : 1;
-			break;
-		case 4:	/* cmovs */
-			no_wb = (ctxt->eflags & EFLG_SF) ? 0 : 1;
-			break;
-		case 5:	/* cmovp/cmovpe */
-			no_wb = (ctxt->eflags & EFLG_PF) ? 0 : 1;
-			break;
-		case 7:	/* cmovle/cmovng */
-			no_wb = (ctxt->eflags & EFLG_ZF) ? 0 : 1;
-			/* fall through */
-		case 6:	/* cmovl/cmovnge */
-			no_wb &= (!(ctxt->eflags & EFLG_SF) !=
-			      !(ctxt->eflags & EFLG_OF)) ? 0 : 1;
-			break;
-		}
-		/* Odd cmov opcodes (lsb == 1) have inverted sense. */
-		no_wb ^= c->b & 1;
+		if (!test_cc(c->b, ctxt->eflags))
+			c->dst.type = OP_NONE; /* no writeback */
 		break;
 	case 0xa3:
 	      bt:		/* bt */
@@ -1727,8 +1699,6 @@ twobyte_insn:
 	goto writeback;
 
 twobyte_special_insn:
-	/* Disable writeback. */
-	no_wb = 1;
 	switch (c->b) {
 	case 0x06:
 		emulate_clts(ctxt->vcpu);
@@ -1802,6 +1772,8 @@ twobyte_special_insn:
 			goto done;
 		break;
 	}
+	/* Disable writeback. */
+	c->dst.type = OP_NONE;
 	goto writeback;
 
 cannot_emulate:
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index 28acad4..f03b128 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -114,7 +114,7 @@ struct x86_emulate_ops {
 
 /* Type, address-of, and value of an instruction's operand. */
 struct operand {
-	enum { OP_REG, OP_MEM, OP_IMM } type;
+	enum { OP_REG, OP_MEM, OP_IMM, OP_NONE } type;
 	unsigned int bytes;
 	unsigned long val, orig_val, *ptr;
 };
-- 
1.5.3.7


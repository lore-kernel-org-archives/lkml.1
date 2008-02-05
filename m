Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbYBEBX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbYBEBX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758936AbYBEBXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:23:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:52671 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906AbYBEBXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:23:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JuRrzpfxH4vcGGdoe158kBAfw4WiRQyrTQT5vjTzuc20w0lAfflI64Sq1f+EzgcPGOPE40IBT79JSI6V621bn9UkTaz8aL+ALPe5RgjaKXnSMISiTCkPH89TdyBUSSbYZo5L/+BkEy6gcICgkM47wToyNSf2/llkIZQaAniv3ZI=
Subject: [PATCH 2/2] kvm: replace more defines with functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>, Yaniv Kamay <yaniv@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 17:23:13 -0800
Message-Id: <1202174593.6452.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_address
register_address_increment
jmp_rel

Have a struct decode_cache parameter added instead of having 'c' in
the macro.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kvm/x86_emulate.c |   92 ++++++++++++++++++++++----------------------
 1 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 649e14d..1c0502a 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -440,25 +440,25 @@ static unsigned long address_mask(struct decode_cache *c, unsigned long reg)
 		return reg & ad_mask(c);
 }
 
-#define register_address(base, reg)                                     \
-	((base) + address_mask(c, reg))
-#define register_address_increment(reg, inc)                            \
-	do {								\
-		/* signed type ensures sign extension to long */        \
-		int _inc = (inc);					\
-		if (c->ad_bytes == sizeof(unsigned long))		\
-			(reg) += _inc;					\
-		else							\
-			(reg) = ((reg) & 				\
-				 ~((1UL << (c->ad_bytes << 3)) - 1)) |	\
-				(((reg) + _inc) &			\
-				 ((1UL << (c->ad_bytes << 3)) - 1));	\
-	} while (0)
+static unsigned long register_address(struct decode_cache *c,
+				      unsigned long base, unsigned long reg)
+{
+	return base + address_mask(c, reg);
+}
 
-#define JMP_REL(rel) 							\
-	do {								\
-		register_address_increment(c->eip, rel);		\
-	} while (0)
+static void register_address_increment(struct decode_cache *c,
+				       unsigned long *reg, int inc)
+{
+	if (c->ad_bytes == sizeof(unsigned long))
+		*reg += inc;
+	else
+		*reg = (*reg & ~ad_mask(c)) | ((*reg + inc) & ad_mask(c));
+}
+
+static void jmp_rel(struct decode_cache *c, int rel)
+{
+	register_address_increment(c, &c->eip, rel);
+}
 
 static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
 			      struct x86_emulate_ops *ops,
@@ -994,8 +994,8 @@ static inline void emulate_push(struct x86_emulate_ctxt *ctxt)
 	c->dst.type  = OP_MEM;
 	c->dst.bytes = c->op_bytes;
 	c->dst.val = c->src.val;
-	register_address_increment(c->regs[VCPU_REGS_RSP], -c->op_bytes);
-	c->dst.ptr = (void *) register_address(ctxt->ss_base,
+	register_address_increment(c, &c->regs[VCPU_REGS_RSP], -c->op_bytes);
+	c->dst.ptr = (void *) register_address(c, ctxt->ss_base,
 					       c->regs[VCPU_REGS_RSP]);
 }
 
@@ -1005,13 +1005,13 @@ static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
-	rc = ops->read_std(register_address(ctxt->ss_base,
+	rc = ops->read_std(register_address(c, ctxt->ss_base,
 					    c->regs[VCPU_REGS_RSP]),
 			   &c->dst.val, c->dst.bytes, ctxt->vcpu);
 	if (rc != 0)
 		return rc;
 
-	register_address_increment(c->regs[VCPU_REGS_RSP], c->dst.bytes);
+	register_address_increment(c, &c->regs[VCPU_REGS_RSP], c->dst.bytes);
 
 	return 0;
 }
@@ -1122,9 +1122,9 @@ static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 			if (rc != 0)
 				return rc;
 		}
-		register_address_increment(c->regs[VCPU_REGS_RSP],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
 					   -c->dst.bytes);
-		rc = ops->write_emulated(register_address(ctxt->ss_base,
+		rc = ops->write_emulated(register_address(c, ctxt->ss_base,
 				    c->regs[VCPU_REGS_RSP]), &c->dst.val,
 				    c->dst.bytes, ctxt->vcpu);
 		if (rc != 0)
@@ -1371,19 +1371,19 @@ special_insn:
 		c->dst.type  = OP_MEM;
 		c->dst.bytes = c->op_bytes;
 		c->dst.val = c->src.val;
-		register_address_increment(c->regs[VCPU_REGS_RSP],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
 					   -c->op_bytes);
 		c->dst.ptr = (void *) register_address(
-			ctxt->ss_base, c->regs[VCPU_REGS_RSP]);
+			c, ctxt->ss_base, c->regs[VCPU_REGS_RSP]);
 		break;
 	case 0x58 ... 0x5f: /* pop reg */
 	pop_instruction:
-		if ((rc = ops->read_std(register_address(ctxt->ss_base,
+		if ((rc = ops->read_std(register_address(c, ctxt->ss_base,
 			c->regs[VCPU_REGS_RSP]), c->dst.ptr,
 			c->op_bytes, ctxt->vcpu)) != 0)
 			goto done;
 
-		register_address_increment(c->regs[VCPU_REGS_RSP],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
 					   c->op_bytes);
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
@@ -1405,7 +1405,7 @@ special_insn:
 				c->rep_prefix ?
 				address_mask(c, c->regs[VCPU_REGS_RCX]) : 1,
 				(ctxt->eflags & EFLG_DF),
-				register_address(ctxt->es_base,
+				register_address(c, ctxt->es_base,
 						 c->regs[VCPU_REGS_RDI]),
 				c->rep_prefix,
 				c->regs[VCPU_REGS_RDX]) == 0) {
@@ -1421,7 +1421,7 @@ special_insn:
 				c->rep_prefix ?
 				address_mask(c, c->regs[VCPU_REGS_RCX]) : 1,
 				(ctxt->eflags & EFLG_DF),
-				register_address(c->override_base ?
+				register_address(c, c->override_base ?
 							*c->override_base :
 							ctxt->ds_base,
 						 c->regs[VCPU_REGS_RSI]),
@@ -1435,7 +1435,7 @@ special_insn:
 		int rel = insn_fetch(s8, 1, c->eip);
 
 		if (test_cc(c->b, ctxt->eflags))
-			JMP_REL(rel);
+			jmp_rel(c, rel);
 		break;
 	}
 	case 0x80 ... 0x83:	/* Grp1 */
@@ -1511,27 +1511,27 @@ special_insn:
 	case 0xa4 ... 0xa5:	/* movs */
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.ptr = (unsigned long *)register_address(
+		c->dst.ptr = (unsigned long *)register_address(c,
 						   ctxt->es_base,
 						   c->regs[VCPU_REGS_RDI]);
-		if ((rc = ops->read_emulated(register_address(
+		if ((rc = ops->read_emulated(register_address(c,
 		      c->override_base ? *c->override_base :
 					ctxt->ds_base,
 					c->regs[VCPU_REGS_RSI]),
 					&c->dst.val,
 					c->dst.bytes, ctxt->vcpu)) != 0)
 			goto done;
-		register_address_increment(c->regs[VCPU_REGS_RSI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
-		register_address_increment(c->regs[VCPU_REGS_RDI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RDI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		break;
 	case 0xa6 ... 0xa7:	/* cmps */
 		c->src.type = OP_NONE; /* Disable writeback. */
 		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->src.ptr = (unsigned long *)register_address(
+		c->src.ptr = (unsigned long *)register_address(c,
 				c->override_base ? *c->override_base :
 						   ctxt->ds_base,
 						   c->regs[VCPU_REGS_RSI]);
@@ -1543,7 +1543,7 @@ special_insn:
 
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.ptr = (unsigned long *)register_address(
+		c->dst.ptr = (unsigned long *)register_address(c,
 						   ctxt->es_base,
 						   c->regs[VCPU_REGS_RDI]);
 		if ((rc = ops->read_emulated((unsigned long)c->dst.ptr,
@@ -1556,10 +1556,10 @@ special_insn:
 
 		emulate_2op_SrcV("cmp", c->src, c->dst, ctxt->eflags);
 
-		register_address_increment(c->regs[VCPU_REGS_RSI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSI],
 				       (ctxt->eflags & EFLG_DF) ? -c->src.bytes
 								  : c->src.bytes);
-		register_address_increment(c->regs[VCPU_REGS_RDI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RDI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 								  : c->dst.bytes);
 
@@ -1567,11 +1567,11 @@ special_insn:
 	case 0xaa ... 0xab:	/* stos */
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.ptr = (unsigned long *)register_address(
+		c->dst.ptr = (unsigned long *)register_address(c,
 						   ctxt->es_base,
 						   c->regs[VCPU_REGS_RDI]);
 		c->dst.val = c->regs[VCPU_REGS_RAX];
-		register_address_increment(c->regs[VCPU_REGS_RDI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RDI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		break;
@@ -1579,7 +1579,7 @@ special_insn:
 		c->dst.type = OP_REG;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
-		if ((rc = ops->read_emulated(register_address(
+		if ((rc = ops->read_emulated(register_address(c,
 				c->override_base ? *c->override_base :
 						   ctxt->ds_base,
 						 c->regs[VCPU_REGS_RSI]),
@@ -1587,7 +1587,7 @@ special_insn:
 						 c->dst.bytes,
 						 ctxt->vcpu)) != 0)
 			goto done;
-		register_address_increment(c->regs[VCPU_REGS_RSI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		break;
@@ -1626,14 +1626,14 @@ special_insn:
 			goto cannot_emulate;
 		}
 		c->src.val = (unsigned long) c->eip;
-		JMP_REL(rel);
+		jmp_rel(c, rel);
 		c->op_bytes = c->ad_bytes;
 		emulate_push(ctxt);
 		break;
 	}
 	case 0xe9: /* jmp rel */
 	case 0xeb: /* jmp rel short */
-		JMP_REL(c->src.val);
+		jmp_rel(c, c->src.val);
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		break;
 	case 0xf4:              /* hlt */
@@ -1833,7 +1833,7 @@ twobyte_insn:
 			goto cannot_emulate;
 		}
 		if (test_cc(c->b, ctxt->eflags))
-			JMP_REL(rel);
+			jmp_rel(c, rel);
 		c->dst.type = OP_NONE;
 		break;
 	}
-- 
1.5.4.rc5.1138.g2602


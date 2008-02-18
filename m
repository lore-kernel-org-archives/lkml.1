Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbYBRTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbYBRTNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYBRTMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:12:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:20054 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYBRTMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:12:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q0fuNeodh5PLHnb7VQxvIjkL2IbTXrl3vlgaTjQ3oy6hwSt/y4MvH9tQ2PYWgT0xcfUVJmq+KiHQSlOSuHJdDz9Aht09L40WlQHXF9q88S4gEAEBnBmkwd+e/4Ik5G7sR5Dsx9dwTMFP53rEMhKNecVWOPuNbQJI1BpqZsVtpPA=
Subject: [PATCH 3/3] x86, kvm: make register_address_increment and JMP_REL
	static inlines
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 11:12:51 -0800
Message-Id: <1203361971.5757.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to jmp_rel now that it is a function.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kvm/x86_emulate.c |   58 ++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 5b2cc50..f5508d2 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -447,23 +447,19 @@ register_address(struct decode_cache *c, unsigned long base, unsigned long reg)
 	return base + address_mask(c, reg);
 }
 
-#define register_address_increment(reg, inc)                            \
-	do {								\
-		/* signed type ensures sign extension to long */        \
-		int _inc = (inc);					\
-		if (c->ad_bytes == sizeof(unsigned long))		\
-			(reg) += _inc;					\
-		else							\
-			(reg) = ((reg) & 				\
-				 ~ad_mask(c)) |	\
-				(((reg) + _inc) &			\
-				 ad_mask(c));	\
-	} while (0)
+static inline void
+register_address_increment(struct decode_cache *c, unsigned long *reg, int inc)
+{
+	if (c->ad_bytes == sizeof(unsigned long))
+		*reg += inc;
+	else
+		*reg = (*reg & ~ad_mask(c)) | ((*reg + inc) & ad_mask(c));
+}
 
-#define JMP_REL(rel) 							\
-	do {								\
-		register_address_increment(c->eip, rel);		\
-	} while (0)
+static inline void jmp_rel(struct decode_cache *c, int rel)
+{
+	register_address_increment(c, &c->eip, rel);
+}
 
 static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
 			      struct x86_emulate_ops *ops,
@@ -999,7 +995,7 @@ static inline void emulate_push(struct x86_emulate_ctxt *ctxt)
 	c->dst.type  = OP_MEM;
 	c->dst.bytes = c->op_bytes;
 	c->dst.val = c->src.val;
-	register_address_increment(c->regs[VCPU_REGS_RSP], -c->op_bytes);
+	register_address_increment(c, &c->regs[VCPU_REGS_RSP], -c->op_bytes);
 	c->dst.ptr = (void *) register_address(c, ctxt->ss_base,
 					       c->regs[VCPU_REGS_RSP]);
 }
@@ -1016,7 +1012,7 @@ static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 	if (rc != 0)
 		return rc;
 
-	register_address_increment(c->regs[VCPU_REGS_RSP], c->dst.bytes);
+	register_address_increment(c, &c->regs[VCPU_REGS_RSP], c->dst.bytes);
 
 	return 0;
 }
@@ -1127,7 +1123,7 @@ static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 			if (rc != 0)
 				return rc;
 		}
-		register_address_increment(c->regs[VCPU_REGS_RSP],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
 					   -c->dst.bytes);
 		rc = ops->write_emulated(register_address(c, ctxt->ss_base,
 				    c->regs[VCPU_REGS_RSP]), &c->dst.val,
@@ -1376,7 +1372,7 @@ special_insn:
 		c->dst.type  = OP_MEM;
 		c->dst.bytes = c->op_bytes;
 		c->dst.val = c->src.val;
-		register_address_increment(c->regs[VCPU_REGS_RSP],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
 					   -c->op_bytes);
 		c->dst.ptr = (void *) register_address(
 			c, ctxt->ss_base, c->regs[VCPU_REGS_RSP]);
@@ -1388,7 +1384,7 @@ special_insn:
 			c->op_bytes, ctxt->vcpu)) != 0)
 			goto done;
 
-		register_address_increment(c->regs[VCPU_REGS_RSP],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
 					   c->op_bytes);
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
@@ -1440,7 +1436,7 @@ special_insn:
 		int rel = insn_fetch(s8, 1, c->eip);
 
 		if (test_cc(c->b, ctxt->eflags))
-			JMP_REL(rel);
+			jmp_rel(c, rel);
 		break;
 	}
 	case 0x80 ... 0x83:	/* Grp1 */
@@ -1526,10 +1522,10 @@ special_insn:
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
@@ -1561,10 +1557,10 @@ special_insn:
 
 		emulate_2op_SrcV("cmp", c->src, c->dst, ctxt->eflags);
 
-		register_address_increment(c->regs[VCPU_REGS_RSI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSI],
 				       (ctxt->eflags & EFLG_DF) ? -c->src.bytes
 								  : c->src.bytes);
-		register_address_increment(c->regs[VCPU_REGS_RDI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RDI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 								  : c->dst.bytes);
 
@@ -1576,7 +1572,7 @@ special_insn:
 						   ctxt->es_base,
 						   c->regs[VCPU_REGS_RDI]);
 		c->dst.val = c->regs[VCPU_REGS_RAX];
-		register_address_increment(c->regs[VCPU_REGS_RDI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RDI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		break;
@@ -1592,7 +1588,7 @@ special_insn:
 						 c->dst.bytes,
 						 ctxt->vcpu)) != 0)
 			goto done;
-		register_address_increment(c->regs[VCPU_REGS_RSI],
+		register_address_increment(c, &c->regs[VCPU_REGS_RSI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
 							   : c->dst.bytes);
 		break;
@@ -1631,14 +1627,14 @@ special_insn:
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
@@ -1838,7 +1834,7 @@ twobyte_insn:
 			goto cannot_emulate;
 		}
 		if (test_cc(c->b, ctxt->eflags))
-			JMP_REL(rel);
+			jmp_rel(c, rel);
 		c->dst.type = OP_NONE;
 		break;
 	}
-- 
1.5.4.1.1278.gc75be


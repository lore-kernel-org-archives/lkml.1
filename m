Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYBRTNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYBRTNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYBRTMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:12:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:20054 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYBRTMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:12:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XcJCgjV0JmtvkWFfTTvJT2zDvM6wPsSigGO+8z5/bx5g9wmCgrrzFC6AOoJAHVUvvpdNhekU2KY/q6fQVe2DWQJvr2hKR60W61fOpuWYyI1CoGZIBS0zmgwBR+x0kN9sv7/ofg+MTQLCp65LgDhgqexhX5QQqPk6GF0xKgq2VPc=
Subject: [PATCH 2/3] x86, kvm: make register_address, address_mask static
	inlines
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 11:12:50 -0800
Message-Id: <1203361970.5757.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kvm/x86_emulate.c |   50 ++++++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 7460432..5b2cc50 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -432,11 +432,21 @@ static inline unsigned long ad_mask(struct decode_cache *c)
 }
 
 /* Access/update address held in a register, based on addressing mode. */
-#define address_mask(reg)						\
-	((c->ad_bytes == sizeof(unsigned long)) ? 			\
-		(reg) :	((reg) & ad_mask(c)))
-#define register_address(base, reg)                                     \
-	((base) + address_mask(reg))
+static inline unsigned long
+address_mask(struct decode_cache *c, unsigned long reg)
+{
+	if (c->ad_bytes == sizeof(unsigned long))
+		return reg;
+	else
+		return reg & ad_mask(c);
+}
+
+static inline unsigned long
+register_address(struct decode_cache *c, unsigned long base, unsigned long reg)
+{
+	return base + address_mask(c, reg);
+}
+
 #define register_address_increment(reg, inc)                            \
 	do {								\
 		/* signed type ensures sign extension to long */        \
@@ -990,7 +1000,7 @@ static inline void emulate_push(struct x86_emulate_ctxt *ctxt)
 	c->dst.bytes = c->op_bytes;
 	c->dst.val = c->src.val;
 	register_address_increment(c->regs[VCPU_REGS_RSP], -c->op_bytes);
-	c->dst.ptr = (void *) register_address(ctxt->ss_base,
+	c->dst.ptr = (void *) register_address(c, ctxt->ss_base,
 					       c->regs[VCPU_REGS_RSP]);
 }
 
@@ -1000,7 +1010,7 @@ static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
-	rc = ops->read_std(register_address(ctxt->ss_base,
+	rc = ops->read_std(register_address(c, ctxt->ss_base,
 					    c->regs[VCPU_REGS_RSP]),
 			   &c->dst.val, c->dst.bytes, ctxt->vcpu);
 	if (rc != 0)
@@ -1119,7 +1129,7 @@ static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 		}
 		register_address_increment(c->regs[VCPU_REGS_RSP],
 					   -c->dst.bytes);
-		rc = ops->write_emulated(register_address(ctxt->ss_base,
+		rc = ops->write_emulated(register_address(c, ctxt->ss_base,
 				    c->regs[VCPU_REGS_RSP]), &c->dst.val,
 				    c->dst.bytes, ctxt->vcpu);
 		if (rc != 0)
@@ -1369,11 +1379,11 @@ special_insn:
 		register_address_increment(c->regs[VCPU_REGS_RSP],
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
@@ -1398,9 +1408,9 @@ special_insn:
 				1,
 				(c->d & ByteOp) ? 1 : c->op_bytes,
 				c->rep_prefix ?
-				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
+				address_mask(c, c->regs[VCPU_REGS_RCX]) : 1,
 				(ctxt->eflags & EFLG_DF),
-				register_address(ctxt->es_base,
+				register_address(c, ctxt->es_base,
 						 c->regs[VCPU_REGS_RDI]),
 				c->rep_prefix,
 				c->regs[VCPU_REGS_RDX]) == 0) {
@@ -1414,9 +1424,9 @@ special_insn:
 				0,
 				(c->d & ByteOp) ? 1 : c->op_bytes,
 				c->rep_prefix ?
-				address_mask(c->regs[VCPU_REGS_RCX]) : 1,
+				address_mask(c, c->regs[VCPU_REGS_RCX]) : 1,
 				(ctxt->eflags & EFLG_DF),
-				register_address(c->override_base ?
+				register_address(c, c->override_base ?
 							*c->override_base :
 							ctxt->ds_base,
 						 c->regs[VCPU_REGS_RSI]),
@@ -1506,10 +1516,10 @@ special_insn:
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
@@ -1526,7 +1536,7 @@ special_insn:
 	case 0xa6 ... 0xa7:	/* cmps */
 		c->src.type = OP_NONE; /* Disable writeback. */
 		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->src.ptr = (unsigned long *)register_address(
+		c->src.ptr = (unsigned long *)register_address(c,
 				c->override_base ? *c->override_base :
 						   ctxt->ds_base,
 						   c->regs[VCPU_REGS_RSI]);
@@ -1538,7 +1548,7 @@ special_insn:
 
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.ptr = (unsigned long *)register_address(
+		c->dst.ptr = (unsigned long *)register_address(c,
 						   ctxt->es_base,
 						   c->regs[VCPU_REGS_RDI]);
 		if ((rc = ops->read_emulated((unsigned long)c->dst.ptr,
@@ -1562,7 +1572,7 @@ special_insn:
 	case 0xaa ... 0xab:	/* stos */
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.ptr = (unsigned long *)register_address(
+		c->dst.ptr = (unsigned long *)register_address(c,
 						   ctxt->es_base,
 						   c->regs[VCPU_REGS_RDI]);
 		c->dst.val = c->regs[VCPU_REGS_RAX];
@@ -1574,7 +1584,7 @@ special_insn:
 		c->dst.type = OP_REG;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
-		if ((rc = ops->read_emulated(register_address(
+		if ((rc = ops->read_emulated(register_address(c,
 				c->override_base ? *c->override_base :
 						   ctxt->ds_base,
 						 c->regs[VCPU_REGS_RSI]),
-- 
1.5.4.1.1278.gc75be



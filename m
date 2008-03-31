Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYCaOs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYCaOs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYCaOhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:55 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51308
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYCaOhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 35/40] KVM: x86 emulator: make register_address, address_mask static inlines
Date: Mon, 31 Mar 2008 17:37:19 +0300
Message-Id: <1206974244-9716-36-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   48 ++++++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index f6f6544..008db4d 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -486,11 +486,21 @@ static inline unsigned long ad_mask(struct decode_cache *c)
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
@@ -1056,7 +1066,7 @@ static inline void emulate_push(struct x86_emulate_ctxt *ctxt)
 	c->dst.bytes = c->op_bytes;
 	c->dst.val = c->src.val;
 	register_address_increment(c->regs[VCPU_REGS_RSP], -c->op_bytes);
-	c->dst.ptr = (void *) register_address(ctxt->ss_base,
+	c->dst.ptr = (void *) register_address(c, ctxt->ss_base,
 					       c->regs[VCPU_REGS_RSP]);
 }
 
@@ -1066,7 +1076,7 @@ static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
-	rc = ops->read_std(register_address(ctxt->ss_base,
+	rc = ops->read_std(register_address(c, ctxt->ss_base,
 					    c->regs[VCPU_REGS_RSP]),
 			   &c->dst.val, c->dst.bytes, ctxt->vcpu);
 	if (rc != 0)
@@ -1388,11 +1398,11 @@ special_insn:
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
@@ -1417,9 +1427,9 @@ special_insn:
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
@@ -1433,9 +1443,9 @@ special_insn:
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
@@ -1525,10 +1535,10 @@ special_insn:
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
@@ -1545,7 +1555,7 @@ special_insn:
 	case 0xa6 ... 0xa7:	/* cmps */
 		c->src.type = OP_NONE; /* Disable writeback. */
 		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->src.ptr = (unsigned long *)register_address(
+		c->src.ptr = (unsigned long *)register_address(c,
 				c->override_base ? *c->override_base :
 						   ctxt->ds_base,
 						   c->regs[VCPU_REGS_RSI]);
@@ -1557,7 +1567,7 @@ special_insn:
 
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.ptr = (unsigned long *)register_address(
+		c->dst.ptr = (unsigned long *)register_address(c,
 						   ctxt->es_base,
 						   c->regs[VCPU_REGS_RDI]);
 		if ((rc = ops->read_emulated((unsigned long)c->dst.ptr,
@@ -1581,7 +1591,7 @@ special_insn:
 	case 0xaa ... 0xab:	/* stos */
 		c->dst.type = OP_MEM;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.ptr = (unsigned long *)register_address(
+		c->dst.ptr = (unsigned long *)register_address(c,
 						   ctxt->es_base,
 						   c->regs[VCPU_REGS_RDI]);
 		c->dst.val = c->regs[VCPU_REGS_RAX];
@@ -1593,7 +1603,7 @@ special_insn:
 		c->dst.type = OP_REG;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
-		if ((rc = ops->read_emulated(register_address(
+		if ((rc = ops->read_emulated(register_address(c,
 				c->override_base ? *c->override_base :
 						   ctxt->ds_base,
 						 c->regs[VCPU_REGS_RSI]),
-- 
1.5.4.5


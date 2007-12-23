Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbXLWOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbXLWOzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbXLWOvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:35892 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbXLWOvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:40 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 05/50] KVM: x86 emulator: move all decoding process to function x86_decode_insn()
Date: Sun, 23 Dec 2007 16:50:50 +0200
Message-Id: <1198421495-31481-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Split the decoding process into a new function x86_decode_insn().

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   77 +++++++++++++++++++++++++++++++--------------
 1 files changed, 53 insertions(+), 24 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index f946182..f20534b 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -517,20 +517,16 @@ static int test_cc(unsigned int condition, unsigned int flags)
 }
 
 int
-x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
+x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
 	u8 sib, rex_prefix = 0;
 	unsigned int i;
 	int rc = 0;
-	unsigned long cr2 = ctxt->cr2;
 	int mode = ctxt->mode;
 	int index_reg = 0, base_reg = 0, scale, rip_relative = 0;
-	int no_wb = 0;
-	u64 msr_data;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
-	unsigned long _eflags = ctxt->eflags;
 
 	memset(c, 0, sizeof(struct decode_cache));
 	c->eip = ctxt->vcpu->rip;
@@ -622,8 +618,10 @@ done_prefixes:
 		}
 
 		/* Unrecognised? */
-		if (c->d == 0)
-			goto cannot_emulate;
+		if (c->d == 0) {
+			DPRINTF("Cannot emulate %02x\n", c->b);
+			return -1;
+		}
 	}
 
 	/* ModRM and SIB bytes. */
@@ -776,7 +774,6 @@ done_prefixes:
 		}
 		if (c->ad_bytes != 8)
 			c->modrm_ea = (u32)c->modrm_ea;
-		cr2 = c->modrm_ea;
 	modrm_done:
 		;
 	}
@@ -838,13 +835,6 @@ done_prefixes:
 			break;
 		}
 		c->src.type = OP_MEM;
-		c->src.ptr = (unsigned long *)cr2;
-		c->src.val = 0;
-		if ((rc = ops->read_emulated((unsigned long)c->src.ptr,
-					   &c->src.val,
-					   c->src.bytes, ctxt->vcpu)) != 0)
-			goto done;
-		c->src.orig_val = c->src.val;
 		break;
 	case SrcImm:
 		c->src.type = OP_IMM;
@@ -877,7 +867,7 @@ done_prefixes:
 	switch (c->d & DstMask) {
 	case ImplicitOps:
 		/* Special instructions do their own operand decoding. */
-		goto special_insn;
+		return 0;
 	case DstReg:
 		c->dst.type = OP_REG;
 		if ((c->d & ByteOp)
@@ -905,14 +895,54 @@ done_prefixes:
 		}
 		break;
 	case DstMem:
-		c->dst.type = OP_MEM;
-		c->dst.ptr = (unsigned long *)cr2;
-		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		c->dst.val = 0;
 		if ((c->d & ModRM) && c->modrm_mod == 3) {
 			c->dst.type = OP_REG;
 			break;
 		}
+		c->dst.type = OP_MEM;
+		break;
+	}
+
+done:
+	return (rc == X86EMUL_UNHANDLEABLE) ? -1 : 0;
+}
+
+int
+x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
+{
+	unsigned long cr2 = ctxt->cr2;
+	int no_wb = 0;
+	u64 msr_data;
+	unsigned long _eflags = ctxt->eflags;
+	struct decode_cache *c = &ctxt->decode;
+	int rc;
+
+	rc = x86_decode_insn(ctxt, ops);
+	if (rc)
+		return rc;
+
+	if ((c->d & ModRM) && (c->modrm_mod != 3))
+		cr2 = c->modrm_ea;
+
+	if (c->src.type == OP_MEM) {
+		c->src.ptr = (unsigned long *)cr2;
+		c->src.val = 0;
+		if ((rc = ops->read_emulated((unsigned long)c->src.ptr,
+					     &c->src.val,
+					     c->src.bytes,
+					     ctxt->vcpu)) != 0)
+			goto done;
+		c->src.orig_val = c->src.val;
+	}
+
+	if ((c->d & DstMask) == ImplicitOps)
+		goto special_insn;
+
+
+	if (c->dst.type == OP_MEM) {
+		c->dst.ptr = (unsigned long *)cr2;
+		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
+		c->dst.val = 0;
 		if (c->d & BitOp) {
 			unsigned long mask = ~(c->dst.bytes * 8 - 1);
 
@@ -925,7 +955,6 @@ done_prefixes:
 					   &c->dst.val,
 					  c->dst.bytes, ctxt->vcpu)) != 0))
 			goto done;
-		break;
 	}
 	c->dst.orig_val = c->dst.val;
 
@@ -983,7 +1012,7 @@ done_prefixes:
 		emulate_2op_SrcV("cmp", c->src, c->dst, _eflags);
 		break;
 	case 0x63:		/* movsxd */
-		if (mode != X86EMUL_MODE_PROT64)
+		if (ctxt->mode != X86EMUL_MODE_PROT64)
 			goto cannot_emulate;
 		c->dst.val = (s32) c->src.val;
 		break;
@@ -1041,7 +1070,7 @@ done_prefixes:
 		break;
 	case 0x8f:		/* pop (sole member of Grp1a) */
 		/* 64-bit mode: POP always pops a 64-bit operand. */
-		if (mode == X86EMUL_MODE_PROT64)
+		if (ctxt->mode == X86EMUL_MODE_PROT64)
 			c->dst.bytes = 8;
 		if ((rc = ops->read_std(register_address(
 						   ctxt->ss_base,
@@ -1152,7 +1181,7 @@ done_prefixes:
 			break;
 		case 6:	/* push */
 			/* 64-bit mode: PUSH always pushes a 64-bit operand. */
-			if (mode == X86EMUL_MODE_PROT64) {
+			if (ctxt->mode == X86EMUL_MODE_PROT64) {
 				c->dst.bytes = 8;
 				if ((rc = ops->read_std(
 						 (unsigned long)c->dst.ptr,
-- 
1.5.3.7


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbXLZLNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbXLZLNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXLZLGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:39 -0500
Received: from il.qumranet.com ([82.166.9.18]:50472 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbXLZLGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 27/55] KVM: x86 emulator: Extract the common code of SrcReg and DstReg
Date: Wed, 26 Dec 2007 13:05:32 +0200
Message-Id: <1198667160-22953-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Share the common parts of SrcReg and DstReg decoding.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   80 +++++++++++++++++---------------------------
 1 files changed, 31 insertions(+), 49 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 087a820..58ceb66 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -520,6 +520,34 @@ static int test_cc(unsigned int condition, unsigned int flags)
 	return (!!rc ^ (condition & 1));
 }
 
+static void decode_register_operand(struct operand *op,
+				    struct decode_cache *c,
+				    int highbyte_regs,
+				    int inhibit_bytereg)
+{
+	op->type = OP_REG;
+	if ((c->d & ByteOp) && !inhibit_bytereg) {
+		op->ptr = decode_register(c->modrm_reg, c->regs, highbyte_regs);
+		op->val = *(u8 *)op->ptr;
+		op->bytes = 1;
+	} else {
+		op->ptr = decode_register(c->modrm_reg, c->regs, 0);
+		op->bytes = c->op_bytes;
+		switch (op->bytes) {
+		case 2:
+			op->val = *(u16 *)op->ptr;
+			break;
+		case 4:
+			op->val = *(u32 *)op->ptr;
+			break;
+		case 8:
+			op->val = *(u64 *) op->ptr;
+			break;
+		}
+	}
+	op->orig_val = op->val;
+}
+
 int
 x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
@@ -809,31 +837,7 @@ modrm_done:
 	case SrcNone:
 		break;
 	case SrcReg:
-		c->src.type = OP_REG;
-		if (c->d & ByteOp) {
-			c->src.ptr =
-				decode_register(c->modrm_reg, c->regs,
-						  (rex_prefix == 0));
-			c->src.val = c->src.orig_val = *(u8 *)c->src.ptr;
-			c->src.bytes = 1;
-		} else {
-			c->src.ptr =
-			    decode_register(c->modrm_reg, c->regs, 0);
-			switch ((c->src.bytes = c->op_bytes)) {
-			case 2:
-				c->src.val = c->src.orig_val =
-						       *(u16 *) c->src.ptr;
-				break;
-			case 4:
-				c->src.val = c->src.orig_val =
-						       *(u32 *) c->src.ptr;
-				break;
-			case 8:
-				c->src.val = c->src.orig_val =
-						       *(u64 *) c->src.ptr;
-				break;
-			}
-		}
+		decode_register_operand(&c->src, c, rex_prefix == 0, 0);
 		break;
 	case SrcMem16:
 		c->src.bytes = 2;
@@ -891,30 +895,8 @@ modrm_done:
 		/* Special instructions do their own operand decoding. */
 		return 0;
 	case DstReg:
-		c->dst.type = OP_REG;
-		if ((c->d & ByteOp)
-		    && !(c->twobyte &&
-			(c->b == 0xb6 || c->b == 0xb7))) {
-			c->dst.ptr =
-				decode_register(c->modrm_reg, c->regs,
-						  (rex_prefix == 0));
-			c->dst.val = *(u8 *) c->dst.ptr;
-			c->dst.bytes = 1;
-		} else {
-			c->dst.ptr =
-			    decode_register(c->modrm_reg, c->regs, 0);
-			switch ((c->dst.bytes = c->op_bytes)) {
-			case 2:
-				c->dst.val = *(u16 *)c->dst.ptr;
-				break;
-			case 4:
-				c->dst.val = *(u32 *)c->dst.ptr;
-				break;
-			case 8:
-				c->dst.val = *(u64 *)c->dst.ptr;
-				break;
-			}
-		}
+		decode_register_operand(&c->dst, c, rex_prefix == 0,
+			 c->twobyte && (c->b == 0xb6 || c->b == 0xb7));
 		break;
 	case DstMem:
 		if ((c->d & ModRM) && c->modrm_mod == 3) {
-- 
1.5.3.7


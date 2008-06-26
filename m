Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYFZMi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYFZMi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYFZM3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:24 -0400
Received: from il.qumranet.com ([212.179.150.194]:32349 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYFZM2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 42/50] KVM: x86 emulator: emulate nop and xchg reg, acc (opcodes 0x90 - 0x97)
Date: Thu, 26 Jun 2008 15:28:24 +0300
Message-Id: <1214483312-9265-43-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index b90857c..2808291 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -140,8 +140,9 @@ static u16 opcode_table[256] = {
 	ByteOp | DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
 	DstMem | SrcReg | ModRM | Mov, ModRM | DstReg,
 	DstReg | SrcMem | ModRM | Mov, Group | Group1A,
-	/* 0x90 - 0x9F */
-	0, 0, 0, 0, 0, 0, 0, 0,
+	/* 0x90 - 0x97 */
+	DstReg, DstReg, DstReg, DstReg,	DstReg, DstReg, DstReg, DstReg,
+	/* 0x98 - 0x9F */
 	0, 0, 0, 0, ImplicitOps | Stack, ImplicitOps | Stack, 0, 0,
 	/* 0xA0 - 0xA7 */
 	ByteOp | DstReg | SrcMem | Mov | MemAbs, DstReg | SrcMem | Mov | MemAbs,
@@ -1493,6 +1494,7 @@ special_insn:
 		emulate_2op_SrcV("test", c->src, c->dst, ctxt->eflags);
 		break;
 	case 0x86 ... 0x87:	/* xchg */
+	xchg:
 		/* Write back the register source. */
 		switch (c->dst.bytes) {
 		case 1:
@@ -1560,6 +1562,17 @@ special_insn:
 		if (rc != 0)
 			goto done;
 		break;
+	case 0x90: /* nop / xchg r8,rax */
+		if (!(c->rex_prefix & 1)) { /* nop */
+			c->dst.type = OP_NONE;
+			break;
+		}
+	case 0x91 ... 0x97: /* xchg reg,rax */
+		c->src.type = c->dst.type = OP_REG;
+		c->src.bytes = c->dst.bytes = c->op_bytes;
+		c->src.ptr = (unsigned long *) &c->regs[VCPU_REGS_RAX];
+		c->src.val = *(c->src.ptr);
+		goto xchg;
 	case 0x9c: /* pushf */
 		c->src.val =  (unsigned long) ctxt->eflags;
 		emulate_push(ctxt);
-- 
1.5.6


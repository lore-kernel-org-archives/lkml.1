Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXLZLTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXLZLTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXLZLG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:56 -0500
Received: from il.qumranet.com ([82.166.9.18]:50464 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbXLZLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:05 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 15/55] KVM: x86 emulator: don't depend on cr2 for mov abs emulation
Date: Wed, 26 Dec 2007 13:05:20 +0200
Message-Id: <1198667160-22953-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'mov abs' instruction family (opcodes 0xa0 - 0xa3) still depends on cr2
provided by the page fault handler.  This is wrong for several reasons:

- if an instruction accessed misaligned data that crosses a page boundary,
  and if the fault happened on the second page, cr2 will point at the
  second page, not the data itself.

- if we're emulating in real mode, or due to a FlexPriority exit, there
  is no cr2 generated.

So, this change adds decoding for this instruction form and drops reliance
on cr2.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   50 +++++++++++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 73e3580..087a820 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -63,8 +63,9 @@
 /* Destination is only written; never read. */
 #define Mov         (1<<7)
 #define BitOp       (1<<8)
+#define MemAbs      (1<<9)      /* Memory operand is absolute displacement */
 
-static u8 opcode_table[256] = {
+static u16 opcode_table[256] = {
 	/* 0x00 - 0x07 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
@@ -134,8 +135,8 @@ static u8 opcode_table[256] = {
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps, ImplicitOps, 0, 0,
 	/* 0xA0 - 0xA7 */
-	ByteOp | DstReg | SrcMem | Mov, DstReg | SrcMem | Mov,
-	ByteOp | DstMem | SrcReg | Mov, DstMem | SrcReg | Mov,
+	ByteOp | DstReg | SrcMem | Mov | MemAbs, DstReg | SrcMem | Mov | MemAbs,
+	ByteOp | DstMem | SrcReg | Mov | MemAbs, DstMem | SrcReg | Mov | MemAbs,
 	ByteOp | ImplicitOps | Mov, ImplicitOps | Mov,
 	ByteOp | ImplicitOps, ImplicitOps,
 	/* 0xA8 - 0xAF */
@@ -755,16 +756,6 @@ done_prefixes:
 				break;
 			}
 		}
-		if (!c->override_base)
-			c->override_base = &ctxt->ds_base;
-		if (mode == X86EMUL_MODE_PROT64 &&
-		    c->override_base != &ctxt->fs_base &&
-		    c->override_base != &ctxt->gs_base)
-			c->override_base = NULL;
-
-		if (c->override_base)
-			c->modrm_ea += *c->override_base;
-
 		if (rip_relative) {
 			c->modrm_ea += c->eip;
 			switch (c->d & SrcMask) {
@@ -781,12 +772,35 @@ done_prefixes:
 						c->modrm_ea += c->op_bytes;
 			}
 		}
-		if (c->ad_bytes != 8)
-			c->modrm_ea = (u32)c->modrm_ea;
 modrm_done:
 		;
+	} else if (c->d & MemAbs) {
+		switch (c->ad_bytes) {
+		case 2:
+			c->modrm_ea = insn_fetch(u16, 2, c->eip);
+			break;
+		case 4:
+			c->modrm_ea = insn_fetch(u32, 4, c->eip);
+			break;
+		case 8:
+			c->modrm_ea = insn_fetch(u64, 8, c->eip);
+			break;
+		}
+
 	}
 
+	if (!c->override_base)
+		c->override_base = &ctxt->ds_base;
+	if (mode == X86EMUL_MODE_PROT64 &&
+	    c->override_base != &ctxt->fs_base &&
+	    c->override_base != &ctxt->gs_base)
+		c->override_base = NULL;
+
+	if (c->override_base)
+		c->modrm_ea += *c->override_base;
+
+	if (c->ad_bytes != 8)
+		c->modrm_ea = (u32)c->modrm_ea;
 	/*
 	 * Decode and fetch the source operand: register, memory
 	 * or immediate.
@@ -1171,7 +1185,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	memcpy(c->regs, ctxt->vcpu->regs, sizeof c->regs);
 	saved_eip = c->eip;
 
-	if ((c->d & ModRM) && (c->modrm_mod != 3))
+	if (((c->d & ModRM) && (c->modrm_mod != 3)) || (c->d & MemAbs))
 		cr2 = c->modrm_ea;
 
 	if (c->src.type == OP_MEM) {
@@ -1326,13 +1340,9 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	case 0xa0 ... 0xa1:	/* mov */
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
 		c->dst.val = c->src.val;
-		/* skip src displacement */
-		c->eip += c->ad_bytes;
 		break;
 	case 0xa2 ... 0xa3:	/* mov */
 		c->dst.val = (unsigned long)c->regs[VCPU_REGS_RAX];
-		/* skip c->dst displacement */
-		c->eip += c->ad_bytes;
 		break;
 	case 0xc0 ... 0xc1:
 		emulate_grp2(ctxt);
-- 
1.5.3.7


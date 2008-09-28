Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYI1Pwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYI1Pwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYI1PqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:46:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50914 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbYI1PqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:46:16 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 18/25] KVM: x86 emulator: Use DstAcc for 'and'
Date: Sun, 28 Sep 2008 18:44:54 +0300
Message-Id: <1222616701-1206-19-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

For instruction 'and al,imm' we use DstAcc instead of doing
the emulation directly into the instruction's opcode.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   21 ++-------------------
 1 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 2b43208..ea05117 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -96,7 +96,7 @@ static u16 opcode_table[256] = {
 	/* 0x20 - 0x27 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	SrcImmByte, SrcImm, 0, 0,
+	DstAcc | SrcImmByte, DstAcc | SrcImm, 0, 0,
 	/* 0x28 - 0x2F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
@@ -1392,27 +1392,10 @@ special_insn:
 	      sbb:		/* sbb */
 		emulate_2op_SrcV("sbb", c->src, c->dst, ctxt->eflags);
 		break;
-	case 0x20 ... 0x23:
+	case 0x20 ... 0x25:
 	      and:		/* and */
 		emulate_2op_SrcV("and", c->src, c->dst, ctxt->eflags);
 		break;
-	case 0x24:              /* and al imm8 */
-		c->dst.type = OP_REG;
-		c->dst.ptr = &c->regs[VCPU_REGS_RAX];
-		c->dst.val = *(u8 *)c->dst.ptr;
-		c->dst.bytes = 1;
-		c->dst.orig_val = c->dst.val;
-		goto and;
-	case 0x25:              /* and ax imm16, or eax imm32 */
-		c->dst.type = OP_REG;
-		c->dst.bytes = c->op_bytes;
-		c->dst.ptr = &c->regs[VCPU_REGS_RAX];
-		if (c->op_bytes == 2)
-			c->dst.val = *(u16 *)c->dst.ptr;
-		else
-			c->dst.val = *(u32 *)c->dst.ptr;
-		c->dst.orig_val = c->dst.val;
-		goto and;
 	case 0x28 ... 0x2d:
 	      sub:		/* sub */
 		emulate_2op_SrcV("sub", c->src, c->dst, ctxt->eflags);
-- 
1.6.0.1


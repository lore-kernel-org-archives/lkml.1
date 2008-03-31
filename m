Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbYCaOkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbYCaOkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYCaOhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:36 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51306
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYCaOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/40] KVM: x86 emulator: Group decoding for group 3
Date: Mon, 31 Mar 2008 17:36:49 +0300
Message-Id: <1206974244-9716-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds group decoding support for opcodes 0xf6, 0xf7 (group 3).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   34 ++++++++++------------------------
 1 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index cf1ce7c..52e65ae 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -70,7 +70,7 @@
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
 
 enum {
-	Group1A,
+	Group1A, Group3_Byte, Group3,
 };
 
 static u16 opcode_table[256] = {
@@ -171,8 +171,7 @@ static u16 opcode_table[256] = {
 	0, 0, 0, 0,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
-	ImplicitOps, ImplicitOps,
-	ByteOp | DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
+	ImplicitOps, ImplicitOps, Group | Group3_Byte, Group | Group3,
 	/* 0xF8 - 0xFF */
 	ImplicitOps, 0, ImplicitOps, ImplicitOps,
 	0, 0, ByteOp | DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM
@@ -239,6 +238,14 @@ static u16 twobyte_table[256] = {
 static u16 group_table[] = {
 	[Group1A*8] =
 	DstMem | SrcNone | ModRM | Mov | Stack, 0, 0, 0, 0, 0, 0, 0,
+	[Group3_Byte*8] =
+	ByteOp | SrcImm | DstMem | ModRM, 0,
+	ByteOp | DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
+	0, 0, 0, 0,
+	[Group3*8] =
+	DstMem | SrcImm | ModRM | SrcImm, 0,
+	DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
+	0, 0, 0, 0,
 };
 
 static u16 group2_table[] = {
@@ -1070,26 +1077,6 @@ static inline int emulate_grp3(struct x86_emulate_ctxt *ctxt,
 
 	switch (c->modrm_reg) {
 	case 0 ... 1:	/* test */
-		/*
-		 * Special case in Grp3: test has an immediate
-		 * source operand.
-		 */
-		c->src.type = OP_IMM;
-		c->src.ptr = (unsigned long *)c->eip;
-		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
-		if (c->src.bytes == 8)
-			c->src.bytes = 4;
-		switch (c->src.bytes) {
-		case 1:
-			c->src.val = insn_fetch(s8, 1, c->eip);
-			break;
-		case 2:
-			c->src.val = insn_fetch(s16, 2, c->eip);
-			break;
-		case 4:
-			c->src.val = insn_fetch(s32, 4, c->eip);
-			break;
-		}
 		emulate_2op_SrcV("test", c->src, c->dst, ctxt->eflags);
 		break;
 	case 2:	/* not */
@@ -1103,7 +1090,6 @@ static inline int emulate_grp3(struct x86_emulate_ctxt *ctxt,
 		rc = X86EMUL_UNHANDLEABLE;
 		break;
 	}
-done:
 	return rc;
 }
 
-- 
1.5.4.5


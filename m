Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbZETL2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbZETL2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbZETLU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55274 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbZETLSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:49 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 25/46] KVM: x86 emulator: Complete short/near jcc decoding in decode stage
Date: Wed, 20 May 2009 14:18:22 +0300
Message-Id: <1242818323-10413-26-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   42 ++++++++++--------------------------------
 1 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 8779cf2..14b8ee2 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -136,11 +136,11 @@ static u32 opcode_table[256] = {
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* insb, insw/insd */
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* outsb, outsw/outsd */
 	/* 0x70 - 0x77 */
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	SrcImmByte, SrcImmByte, SrcImmByte, SrcImmByte,
+	SrcImmByte, SrcImmByte, SrcImmByte, SrcImmByte,
 	/* 0x78 - 0x7F */
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	SrcImmByte, SrcImmByte, SrcImmByte, SrcImmByte,
+	SrcImmByte, SrcImmByte, SrcImmByte, SrcImmByte,
 	/* 0x80 - 0x87 */
 	Group | Group1_80, Group | Group1_81,
 	Group | Group1_82, Group | Group1_83,
@@ -232,10 +232,8 @@ static u32 twobyte_table[256] = {
 	/* 0x70 - 0x7F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x80 - 0x8F */
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	SrcImm, SrcImm, SrcImm, SrcImm, SrcImm, SrcImm, SrcImm, SrcImm,
+	SrcImm, SrcImm, SrcImm, SrcImm, SrcImm, SrcImm, SrcImm, SrcImm,
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xA0 - 0xA7 */
@@ -1539,13 +1537,10 @@ special_insn:
 			return -1;
 		}
 		return 0;
-	case 0x70 ... 0x7f: /* jcc (short) */ {
-		int rel = insn_fetch(s8, 1, c->eip);
-
+	case 0x70 ... 0x7f: /* jcc (short) */
 		if (test_cc(c->b, ctxt->eflags))
-			jmp_rel(c, rel);
+			jmp_rel(c, c->src.val);
 		break;
-	}
 	case 0x80 ... 0x83:	/* Grp1 */
 		switch (c->modrm_reg) {
 		case 0:
@@ -2031,28 +2026,11 @@ twobyte_insn:
 		if (!test_cc(c->b, ctxt->eflags))
 			c->dst.type = OP_NONE; /* no writeback */
 		break;
-	case 0x80 ... 0x8f: /* jnz rel, etc*/ {
-		long int rel;
-
-		switch (c->op_bytes) {
-		case 2:
-			rel = insn_fetch(s16, 2, c->eip);
-			break;
-		case 4:
-			rel = insn_fetch(s32, 4, c->eip);
-			break;
-		case 8:
-			rel = insn_fetch(s64, 8, c->eip);
-			break;
-		default:
-			DPRINTF("jnz: Invalid op_bytes\n");
-			goto cannot_emulate;
-		}
+	case 0x80 ... 0x8f: /* jnz rel, etc*/
 		if (test_cc(c->b, ctxt->eflags))
-			jmp_rel(c, rel);
+			jmp_rel(c, c->src.val);
 		c->dst.type = OP_NONE;
 		break;
-	}
 	case 0xa3:
 	      bt:		/* bt */
 		c->dst.type = OP_NONE;
-- 
1.6.0.6


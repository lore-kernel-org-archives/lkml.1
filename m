Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbZETL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbZETL0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbZETLUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55282 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 24/46] KVM: x86 emulator: Complete ljmp decoding at decode stage
Date: Wed, 20 May 2009 14:18:21 +0300
Message-Id: <1242818323-10413-25-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 71b4bee..8779cf2 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -193,7 +193,7 @@ static u32 opcode_table[256] = {
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xE8 - 0xEF */
 	ImplicitOps | Stack, SrcImm | ImplicitOps,
-	ImplicitOps, SrcImmByte | ImplicitOps,
+	SrcImm | Src2Imm16, SrcImmByte | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xF0 - 0xF7 */
@@ -1805,30 +1805,15 @@ special_insn:
 	}
 	case 0xe9: /* jmp rel */
 		goto jmp;
-	case 0xea: /* jmp far */ {
-		uint32_t eip;
-		uint16_t sel;
-
-		switch (c->op_bytes) {
-		case 2:
-			eip = insn_fetch(u16, 2, c->eip);
-			break;
-		case 4:
-			eip = insn_fetch(u32, 4, c->eip);
-			break;
-		default:
-			DPRINTF("jmp far: Invalid op_bytes\n");
-			goto cannot_emulate;
-		}
-		sel = insn_fetch(u16, 2, c->eip);
-		if (kvm_load_segment_descriptor(ctxt->vcpu, sel, 9, VCPU_SREG_CS) < 0) {
+	case 0xea: /* jmp far */
+		if (kvm_load_segment_descriptor(ctxt->vcpu, c->src2.val, 9,
+					VCPU_SREG_CS) < 0) {
 			DPRINTF("jmp far: Failed to load CS descriptor\n");
 			goto cannot_emulate;
 		}
 
-		c->eip = eip;
+		c->eip = c->src.val;
 		break;
-	}
 	case 0xeb:
 	      jmp:		/* jmp rel short */
 		jmp_rel(c, c->src.val);
-- 
1.6.0.6


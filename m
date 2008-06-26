Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYFZMmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYFZMmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbYFZM3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:42 -0400
Received: from il.qumranet.com ([212.179.150.194]:32385 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYFZM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 24/50] KVM: x86 emulator: add support for jmp far 0xea
Date: Thu, 26 Jun 2008 15:28:06 +0300
Message-Id: <1214483312-9265-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add support for jmp far (opcode 0xea) instruction.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index a928aa6..48b62cc 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -168,7 +168,8 @@ static u16 opcode_table[256] = {
 	/* 0xE0 - 0xE7 */
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE8 - 0xEF */
-	ImplicitOps | Stack, SrcImm|ImplicitOps, 0, SrcImmByte|ImplicitOps,
+	ImplicitOps | Stack, SrcImm | ImplicitOps,
+	ImplicitOps, SrcImmByte | ImplicitOps,
 	0, 0, 0, 0,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
@@ -1661,7 +1662,33 @@ special_insn:
 		break;
 	}
 	case 0xe9: /* jmp rel */
-	case 0xeb: /* jmp rel short */
+		goto jmp;
+	case 0xea: /* jmp far */ {
+		uint32_t eip;
+		uint16_t sel;
+
+		switch (c->op_bytes) {
+		case 2:
+			eip = insn_fetch(u16, 2, c->eip);
+			break;
+		case 4:
+			eip = insn_fetch(u32, 4, c->eip);
+			break;
+		default:
+			DPRINTF("jmp far: Invalid op_bytes\n");
+			goto cannot_emulate;
+		}
+		sel = insn_fetch(u16, 2, c->eip);
+		if (kvm_load_segment_descriptor(ctxt->vcpu, sel, 9, VCPU_SREG_CS) < 0) {
+			DPRINTF("jmp far: Failed to load CS descriptor\n");
+			goto cannot_emulate;
+		}
+
+		c->eip = eip;
+		break;
+	}
+	case 0xeb:
+	      jmp:		/* jmp rel short */
 		jmp_rel(c, c->src.val);
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		break;
-- 
1.5.6


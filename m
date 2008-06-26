Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYFZMen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYFZMen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYFZM27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:59 -0400
Received: from il.qumranet.com ([212.179.150.194]:32387 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbYFZM2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 26/50] KVM: x86 emulator: Add support for mov seg, r (0x8e) instruction
Date: Thu, 26 Jun 2008 15:28:08 +0300
Message-Id: <1214483312-9265-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add support for mov r, sreg (0x8c) instruction.

[avi: drop the sreg decoding table in favor of 1:1 encoding]

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 21d7ff6..b049b6b 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -138,7 +138,8 @@ static u16 opcode_table[256] = {
 	/* 0x88 - 0x8F */
 	ByteOp | DstMem | SrcReg | ModRM | Mov, DstMem | SrcReg | ModRM | Mov,
 	ByteOp | DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
-	0, ModRM | DstReg, 0, Group | Group1A,
+	0, ModRM | DstReg,
+	DstReg | SrcMem | ModRM | Mov, Group | Group1A,
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, ImplicitOps | Stack, ImplicitOps | Stack, 0, 0,
@@ -1520,6 +1521,28 @@ special_insn:
 	case 0x8d: /* lea r16/r32, m */
 		c->dst.val = c->modrm_ea;
 		break;
+	case 0x8e: { /* mov seg, r/m16 */
+		uint16_t sel;
+		int type_bits;
+		int err;
+
+		sel = c->src.val;
+		if (c->modrm_reg <= 5) {
+			type_bits = (c->modrm_reg == 1) ? 9 : 1;
+			err = kvm_load_segment_descriptor(ctxt->vcpu, sel,
+							  type_bits, c->modrm_reg);
+		} else {
+			printk(KERN_INFO "Invalid segreg in modrm byte 0x%02x\n",
+					c->modrm);
+			goto cannot_emulate;
+		}
+
+		if (err < 0)
+			goto cannot_emulate;
+
+		c->dst.type = OP_NONE;  /* Disable writeback. */
+		break;
+	}
 	case 0x8f:		/* pop (sole member of Grp1a) */
 		rc = emulate_grp1a(ctxt, ops);
 		if (rc != 0)
-- 
1.5.6


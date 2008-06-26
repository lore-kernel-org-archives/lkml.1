Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYFZMeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYFZMeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYFZM25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:57 -0400
Received: from il.qumranet.com ([212.179.150.194]:32394 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYFZM2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 27/50] KVM: x86 emulator: Add support for mov r, sreg (0x8c) instruction
Date: Thu, 26 Jun 2008 15:28:09 +0300
Message-Id: <1214483312-9265-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add support for mov r, sreg (0x8c) instruction

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index b049b6b..2a9db4d 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -138,7 +138,7 @@ static u16 opcode_table[256] = {
 	/* 0x88 - 0x8F */
 	ByteOp | DstMem | SrcReg | ModRM | Mov, DstMem | SrcReg | ModRM | Mov,
 	ByteOp | DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
-	0, ModRM | DstReg,
+	DstMem | SrcReg | ModRM | Mov, ModRM | DstReg,
 	DstReg | SrcMem | ModRM | Mov, Group | Group1A,
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0,
@@ -1518,6 +1518,19 @@ special_insn:
 		break;
 	case 0x88 ... 0x8b:	/* mov */
 		goto mov;
+	case 0x8c: { /* mov r/m, sreg */
+		struct kvm_segment segreg;
+
+		if (c->modrm_reg <= 5)
+			kvm_get_segment(ctxt->vcpu, &segreg, c->modrm_reg);
+		else {
+			printk(KERN_INFO "0x8c: Invalid segreg in modrm byte 0x%02x\n",
+			       c->modrm);
+			goto cannot_emulate;
+		}
+		c->dst.val = segreg.selector;
+		break;
+	}
 	case 0x8d: /* lea r16/r32, m */
 		c->dst.val = c->modrm_ea;
 		break;
-- 
1.5.6


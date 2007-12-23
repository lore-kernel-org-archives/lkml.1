Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbXLWPEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbXLWPEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbXLWOwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:24 -0500
Received: from il.qumranet.com ([82.166.9.18]:35921 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbXLWOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 42/50] KVM: x86 emulator: Implement emulation of instruction: inc & dec
Date: Sun, 23 Dec 2007 16:51:27 +0200
Message-Id: <1198421495-31481-43-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Instructions:
	inc r16/r32 (opcode 0x40-0x47)
	dec r16/r32 (opcode 0x48-0x4f)

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index b03029e..72621c9 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -96,8 +96,12 @@ static u8 opcode_table[256] = {
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
 	0, 0, 0, 0,
-	/* 0x40 - 0x4F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	/* 0x40 - 0x47 */
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	/* 0x48 - 0x4F */
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	/* 0x50 - 0x57 */
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
@@ -1376,6 +1380,18 @@ special_insn:
 	if (c->twobyte)
 		goto twobyte_special_insn;
 	switch (c->b) {
+	case 0x40 ... 0x47: /* inc r16/r32 */
+		c->dst.bytes = c->op_bytes;
+		c->dst.ptr = (unsigned long *)&c->regs[c->b & 0x7];
+		c->dst.val = *c->dst.ptr;
+		emulate_1op("inc", c->dst, ctxt->eflags);
+		break;
+	case 0x48 ... 0x4f: /* dec r16/r32 */
+		c->dst.bytes = c->op_bytes;
+		c->dst.ptr = (unsigned long *)&c->regs[c->b & 0x7];
+		c->dst.val = *c->dst.ptr;
+		emulate_1op("dec", c->dst, ctxt->eflags);
+		break;
 	case 0x50 ... 0x57:  /* push reg */
 		if (c->op_bytes == 2)
 			c->src.val = (u16) c->regs[c->b & 0x7];
-- 
1.5.3.7


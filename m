Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbXIQI4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbXIQI4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbXIQIdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:37 -0400
Received: from il.qumranet.com ([82.166.9.18]:45265 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbXIQIcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 093/104] KVM: x86 emulator: push imm8
Date: Mon, 17 Sep 2007 10:32:15 +0200
Message-Id: <11900179491827-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement the instruction

    	push imm8
    	opcode: 0x6a

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 86171ca..4fc2da6 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -104,10 +104,11 @@ static u8 opcode_table[256] = {
 	/* 0x58 - 0x5F */
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
-	/* 0x60 - 0x6B */
+	/* 0x60 - 0x67 */
 	0, 0, 0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
-	0, 0, 0, 0, 0, 0, 0, 0,
-	/* 0x6C - 0x6F */
+	0, 0, 0, 0,
+	/* 0x68 - 0x6F */
+	0, 0, ImplicitOps|Mov, 0,
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* insb, insw/insd */
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* outsb, outsw/outsd */
 	/* 0x70 - 0x7F */
@@ -919,6 +920,16 @@ done_prefixes:
 			goto cannot_emulate;
 		dst.val = (s32) src.val;
 		break;
+	case 0x6a: /* push imm8 */
+		src.val = 0L;
+		src.val = insn_fetch(s8, 1, _eip);
+push:
+		dst.type  = OP_MEM;
+		dst.bytes = op_bytes;
+		dst.val = src.val;
+		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
+		dst.ptr = register_address(ctxt->ss_base, _regs[VCPU_REGS_RSP]);
+		break;
 	case 0x80 ... 0x83:	/* Grp1 */
 		switch (modrm_reg) {
 		case 0:
-- 
1.5.3


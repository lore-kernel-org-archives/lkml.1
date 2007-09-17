Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbXIQJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbXIQJBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbXIQIdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:45248 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbXIQIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 056/104] KVM: x86 emulator: implement 'and $imm, %{al|ax|eax}'
Date: Mon, 17 Sep 2007 10:31:38 +0200
Message-Id: <11900179483852-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement emulation of instruction
    and al imm8 (opcode 0x24)
    and ax/eax imm16/imm32 (opcode 0x25)

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index b4f439c..2b94d16 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -83,7 +83,7 @@ static u8 opcode_table[256] = {
 	/* 0x20 - 0x27 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	0, 0, 0, 0,
+	SrcImmByte, SrcImm, 0, 0,
 	/* 0x28 - 0x2F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
@@ -882,10 +882,27 @@ done_prefixes:
 	      sbb:		/* sbb */
 		emulate_2op_SrcV("sbb", src, dst, _eflags);
 		break;
-	case 0x20 ... 0x25:
+	case 0x20 ... 0x23:
 	      and:		/* and */
 		emulate_2op_SrcV("and", src, dst, _eflags);
 		break;
+	case 0x24:              /* and al imm8 */
+		dst.type = OP_REG;
+		dst.ptr = &_regs[VCPU_REGS_RAX];
+		dst.val = *(u8 *)dst.ptr;
+		dst.bytes = 1;
+		dst.orig_val = dst.val;
+		goto and;
+	case 0x25:              /* and ax imm16, or eax imm32 */
+		dst.type = OP_REG;
+		dst.bytes = op_bytes;
+		dst.ptr = &_regs[VCPU_REGS_RAX];
+		if (op_bytes == 2)
+			dst.val = *(u16 *)dst.ptr;
+		else
+			dst.val = *(u32 *)dst.ptr;
+		dst.orig_val = dst.val;
+		goto and;
 	case 0x28 ... 0x2d:
 	      sub:		/* sub */
 		emulate_2op_SrcV("sub", src, dst, _eflags);
-- 
1.5.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbXIQIzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbXIQIzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXIQIdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:35 -0400
Received: from il.qumranet.com ([82.166.9.18]:45331 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbXIQIch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:37 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 095/104] KVM: x86 emulator: pushf
Date: Mon, 17 Sep 2007 10:32:17 +0200
Message-Id: <11900179492320-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement emulation of instruction
	pushf
	opcode: 0x9c

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 9f1772f..18c2b2c 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -123,7 +123,7 @@ static u8 opcode_table[256] = {
 	ByteOp | DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
 	0, 0, 0, DstMem | SrcNone | ModRM | Mov,
 	/* 0x90 - 0x9F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps, 0, 0, 0,
 	/* 0xA0 - 0xA7 */
 	ByteOp | DstReg | SrcMem | Mov, DstReg | SrcMem | Mov,
 	ByteOp | DstMem | SrcReg | Mov, DstMem | SrcReg | Mov,
@@ -928,7 +928,8 @@ push:
 		dst.bytes = op_bytes;
 		dst.val = src.val;
 		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
-		dst.ptr = register_address(ctxt->ss_base, _regs[VCPU_REGS_RSP]);
+		dst.ptr = (void *) register_address(ctxt->ss_base,
+							_regs[VCPU_REGS_RSP]);
 		break;
 	case 0x80 ... 0x83:	/* Grp1 */
 		switch (modrm_reg) {
@@ -1216,6 +1217,12 @@ special_insn:
 				) == 0)
 			return -1;
 		return 0;
+
+	case 0x9c: /* pushf */
+		src.val =  (unsigned long) _eflags;
+		goto push;
+		break;
+
 	}
 	if (rep_prefix) {
 		if (_regs[VCPU_REGS_RCX] == 0) {
-- 
1.5.3


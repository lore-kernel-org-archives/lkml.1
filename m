Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXIQI7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXIQI7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbXIQIdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:45251 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbXIQIcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:31 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 059/104] KVM: x86 emulator: implement 'push reg' (opcodes 0x50-0x57)
Date: Mon, 17 Sep 2007 10:31:41 +0200
Message-Id: <119001794869-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 1036e02..cf895aa 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -99,7 +99,8 @@ static u8 opcode_table[256] = {
 	/* 0x40 - 0x4F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x50 - 0x57 */
-	0, 0, 0, 0, 0, 0, 0, 0,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	/* 0x58 - 0x5F */
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
@@ -1151,6 +1152,19 @@ special_insn:
 	if (twobyte)
 		goto twobyte_special_insn;
 	switch(b) {
+	case 0x50 ... 0x57:  /* push reg */
+		if (op_bytes == 2)
+			src.val = (u16) _regs[b & 0x7];
+		else
+			src.val = (u32) _regs[b & 0x7];
+		dst.type  = OP_MEM;
+		dst.bytes = op_bytes;
+		dst.val = src.val;
+		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
+		dst.ptr = (void *) register_address(
+			ctxt->ss_base, _regs[VCPU_REGS_RSP]);
+		no_wb = 1; /* force writeback */
+		break;
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
 		 if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
-- 
1.5.3


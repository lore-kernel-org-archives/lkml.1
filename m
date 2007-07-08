Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbXGHL5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbXGHL5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXGHLzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:38397 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbXGHLyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Luca Tettamanti <kronos.it@gmail.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 06/20] KVM: Fix x86 emulator writeback
Date: Sun,  8 Jul 2007 14:54:35 +0300
Message-Id: <1183895689798-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luca Tettamanti <kronos.it@gmail.com>

When the old value and new one are the same the emulator skips the
write; this is undesirable when the destination is a MMIO area and the
write shall be performed regardless of the previous value. This
optimization breaks e.g. a Linux guest APIC compiled without
X86_GOOD_APIC.

Remove the check and perform the writeback stage in the emulation unless
it's explicitly disabled (currently push and some 2 bytes instructions
may disable the writeback).

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 92620e4..f60012d 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -485,6 +485,7 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	int mode = ctxt->mode;
 	unsigned long modrm_ea;
 	int use_modrm_ea, index_reg = 0, base_reg = 0, scale, rip_relative = 0;
+	int no_wb = 0;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
 	unsigned long _regs[NR_VCPU_REGS];
@@ -1051,7 +1052,7 @@ done_prefixes:
 						      _regs[VCPU_REGS_RSP]),
 				     &dst.val, dst.bytes, ctxt)) != 0)
 				goto done;
-			dst.val = dst.orig_val;	/* skanky: disable writeback */
+			no_wb = 1;
 			break;
 		default:
 			goto cannot_emulate;
@@ -1060,7 +1061,7 @@ done_prefixes:
 	}
 
 writeback:
-	if ((d & Mov) || (dst.orig_val != dst.val)) {
+	if (!no_wb) {
 		switch (dst.type) {
 		case OP_REG:
 			/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
@@ -1168,7 +1169,7 @@ pop_instruction:
 			goto done;
 
 		register_address_increment(_regs[VCPU_REGS_RSP], op_bytes);
-		dst.orig_val = dst.val; /* Disable writeback. */
+		no_wb = 1; /* Disable writeback. */
 		break;
 	}
 	goto writeback;
@@ -1323,7 +1324,7 @@ twobyte_insn:
 
 twobyte_special_insn:
 	/* Disable writeback. */
-	dst.orig_val = dst.val;
+	no_wb = 1;
 	switch (b) {
 	case 0x09:		/* wbinvd */
 		break;
-- 
1.5.2.2


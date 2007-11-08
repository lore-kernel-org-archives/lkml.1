Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbXKHKfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbXKHKfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbXKHKfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:35:03 -0500
Received: from il.qumranet.com ([82.166.9.18]:52463 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbXKHKfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:35:01 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 1/5] KVM: x86 emulator: fix 'push imm8' emulation
Date: Thu,  8 Nov 2007 12:35:26 +0200
Message-Id: <11945181301821-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11945181301744-git-send-email-avi@qumranet.com>
References: <11945181301744-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

'push imm8' found itself in the wrong switch somehow, so it is never executed.

This fixes Windows 2003 installation.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index a6ace30..da0cdd5 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -980,17 +980,6 @@ done_prefixes:
 			goto cannot_emulate;
 		dst.val = (s32) src.val;
 		break;
-	case 0x6a: /* push imm8 */
-		src.val = 0L;
-		src.val = insn_fetch(s8, 1, _eip);
-push:
-		dst.type  = OP_MEM;
-		dst.bytes = op_bytes;
-		dst.val = src.val;
-		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
-		dst.ptr = (void *) register_address(ctxt->ss_base,
-							_regs[VCPU_REGS_RSP]);
-		break;
 	case 0x80 ... 0x83:	/* Grp1 */
 		switch (modrm_reg) {
 		case 0:
@@ -1243,6 +1232,17 @@ special_insn:
 		register_address_increment(_regs[VCPU_REGS_RSP], op_bytes);
 		no_wb = 1; /* Disable writeback. */
 		break;
+	case 0x6a: /* push imm8 */
+		src.val = 0L;
+		src.val = insn_fetch(s8, 1, _eip);
+	push:
+		dst.type  = OP_MEM;
+		dst.bytes = op_bytes;
+		dst.val = src.val;
+		register_address_increment(_regs[VCPU_REGS_RSP], -op_bytes);
+		dst.ptr = (void *) register_address(ctxt->ss_base,
+							_regs[VCPU_REGS_RSP]);
+		break;
 	case 0x6c:		/* insb */
 	case 0x6d:		/* insw/insd */
 		 if (kvm_emulate_pio_string(ctxt->vcpu, NULL,
-- 
1.5.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbXGHLzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbXGHLzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXGHLyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:54:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:38357 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXGHLyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 01/20] KVM: Implement emulation of "pop reg" instruction (opcode 0x58-0x5f)
Date: Sun,  8 Jul 2007 14:54:30 +0300
Message-Id: <11838956893135-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

For use in real mode.

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index a4a8481..46c3806 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -98,8 +98,11 @@ static u8 opcode_table[256] = {
 	0, 0, 0, 0,
 	/* 0x40 - 0x4F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	/* 0x50 - 0x5F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	/* 0x50 - 0x57 */
+	0, 0, 0, 0, 0, 0, 0, 0,
+	/* 0x58 - 0x5F */
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	/* 0x60 - 0x6F */
 	0, 0, 0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
@@ -1153,6 +1156,16 @@ special_insn:
 	case 0xf4:              /* hlt */
 		ctxt->vcpu->halt_request = 1;
 		goto done;
+	case 0x58 ... 0x5f: /* pop reg */
+		dst.ptr = (unsigned long *)&_regs[b & 0x7];
+
+		if ((rc = ops->read_std(register_address(ctxt->ss_base,
+			_regs[VCPU_REGS_RSP]), dst.ptr, op_bytes, ctxt)) != 0)
+			goto done;
+
+		register_address_increment(_regs[VCPU_REGS_RSP], dst.bytes);
+		dst.orig_val = dst.val; /* Disable writeback. */
+		break;
 	}
 	goto writeback;
 
-- 
1.5.2.2


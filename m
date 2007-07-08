Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbXGHL4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbXGHL4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXGHLyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:54:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:38358 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXGHLyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 02/20] KVM: Implement emulation of instruction "ret" (opcode 0xc3)
Date: Sun,  8 Jul 2007 14:54:31 +0300
Message-Id: <11838956893172-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 46c3806..92620e4 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -131,9 +131,9 @@ static u8 opcode_table[256] = {
 	/* 0xB0 - 0xBF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xC0 - 0xC7 */
-	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImmByte | ModRM, 0, 0,
-	0, 0, ByteOp | DstMem | SrcImm | ModRM | Mov,
-	    DstMem | SrcImm | ModRM | Mov,
+	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImmByte | ModRM,
+	0, ImplicitOps, 0, 0,
+	ByteOp | DstMem | SrcImm | ModRM | Mov, DstMem | SrcImm | ModRM | Mov,
 	/* 0xC8 - 0xCF */
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xD0 - 0xD7 */
@@ -1156,14 +1156,18 @@ special_insn:
 	case 0xf4:              /* hlt */
 		ctxt->vcpu->halt_request = 1;
 		goto done;
+	case 0xc3: /* ret */
+		dst.ptr = &_eip;
+		goto pop_instruction;
 	case 0x58 ... 0x5f: /* pop reg */
 		dst.ptr = (unsigned long *)&_regs[b & 0x7];
 
+pop_instruction:
 		if ((rc = ops->read_std(register_address(ctxt->ss_base,
 			_regs[VCPU_REGS_RSP]), dst.ptr, op_bytes, ctxt)) != 0)
 			goto done;
 
-		register_address_increment(_regs[VCPU_REGS_RSP], dst.bytes);
+		register_address_increment(_regs[VCPU_REGS_RSP], op_bytes);
 		dst.orig_val = dst.val; /* Disable writeback. */
 		break;
 	}
-- 
1.5.2.2


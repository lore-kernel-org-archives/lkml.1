Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXLWPHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXLWPHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbXLWOwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:33 -0500
Received: from il.qumranet.com ([82.166.9.18]:35893 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101AbXLWOvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 44/50] KVM: x86 emulator: cmc, clc, cli, sti
Date: Sun, 23 Dec 2007 16:51:29 +0200
Message-Id: <1198421495-31481-45-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Instruction: cmc, clc, cli, sti
opcodes: 0xf5, 0xf8, 0xfa, 0xfb respectively.

[avi: fix reference to EFLG_IF which is not defined anywhere]

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 72621c9..af98ea1 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -161,10 +161,10 @@ static u8 opcode_table[256] = {
 	ImplicitOps, SrcImm|ImplicitOps, 0, SrcImmByte|ImplicitOps, 0, 0, 0, 0,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
-	ImplicitOps, 0,
+	ImplicitOps, ImplicitOps,
 	ByteOp | DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
 	/* 0xF8 - 0xFF */
-	0, 0, 0, 0,
+	ImplicitOps, 0, ImplicitOps, ImplicitOps,
 	0, 0, ByteOp | DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM
 };
 
@@ -1476,6 +1476,23 @@ special_insn:
 	case 0xf4:              /* hlt */
 		ctxt->vcpu->halt_request = 1;
 		goto done;
+	case 0xf5:	/* cmc */
+		/* complement carry flag from eflags reg */
+		ctxt->eflags ^= EFLG_CF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
+	case 0xf8: /* clc */
+		ctxt->eflags &= ~EFLG_CF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
+	case 0xfa: /* cli */
+		ctxt->eflags &= ~X86_EFLAGS_IF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
+	case 0xfb: /* sti */
+		ctxt->eflags |= X86_EFLAGS_IF;
+		c->dst.type = OP_NONE;	/* Disable writeback. */
+		break;
 	}
 	if (c->rep_prefix) {
 		if (c->regs[VCPU_REGS_RCX] == 0) {
-- 
1.5.3.7


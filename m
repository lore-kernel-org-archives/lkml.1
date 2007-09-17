Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbXIQIzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbXIQIzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbXIQIdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:36 -0400
Received: from il.qumranet.com ([82.166.9.18]:45297 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbXIQIcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 094/104] KVM: x86 emulator: call near
Date: Mon, 17 Sep 2007 10:32:16 +0200
Message-Id: <11900179493946-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement emulation of instruction
	opcode: 0xe8
	call (near)

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 4fc2da6..9f1772f 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -150,7 +150,7 @@ static u8 opcode_table[256] = {
 	/* 0xE0 - 0xE7 */
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE8 - 0xEF */
-	0, SrcImm|ImplicitOps, 0, SrcImmByte|ImplicitOps, 0, 0, 0, 0,
+	ImplicitOps, SrcImm|ImplicitOps, 0, SrcImmByte|ImplicitOps, 0, 0, 0, 0,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
 	ImplicitOps, 0,
@@ -1033,6 +1033,26 @@ push:
 	case 0xd2 ... 0xd3:	/* Grp2 */
 		src.val = _regs[VCPU_REGS_RCX];
 		goto grp2;
+	case 0xe8: /* call (near) */ {
+		long int rel;
+		switch (op_bytes) {
+		case 2:
+			rel = insn_fetch(s16, 2, _eip);
+			break;
+		case 4:
+			rel = insn_fetch(s32, 4, _eip);
+			break;
+		case 8:
+			rel = insn_fetch(s64, 8, _eip);
+			break;
+		default:
+			DPRINTF("Call: Invalid op_bytes\n");
+			goto cannot_emulate;
+		}
+		src.val = (unsigned long) _eip;
+		JMP_REL(rel);
+		goto push;
+	}
 	case 0xe9: /* jmp rel */
 	case 0xeb: /* jmp rel short */
 		JMP_REL(src.val);
-- 
1.5.3


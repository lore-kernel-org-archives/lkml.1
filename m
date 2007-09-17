Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbXIQIyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbXIQIyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbXIQIdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:33 -0400
Received: from il.qumranet.com ([82.166.9.18]:45251 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbXIQIch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:37 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 099/104] KVM: X86 emulator: jump conditional short
Date: Mon, 17 Sep 2007 10:32:21 +0200
Message-Id: <11900179494080-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement emulation of more jump conditional instructions
    jcc shortrel
    opcodes: 0x70 - 0x7f

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index ba53e59..57f1a5a 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -111,8 +111,12 @@ static u8 opcode_table[256] = {
 	0, 0, ImplicitOps|Mov, 0,
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* insb, insw/insd */
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* outsb, outsw/outsd */
-	/* 0x70 - 0x7F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	/* 0x70 - 0x77 */
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	/* 0x78 - 0x7F */
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	/* 0x80 - 0x87 */
 	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImm | ModRM,
 	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImmByte | ModRM,
@@ -1268,6 +1272,13 @@ special_insn:
 				) == 0)
 			return -1;
 		return 0;
+	case 0x70 ... 0x7f: /* jcc (short) */ {
+		int rel = insn_fetch(s8, 1, _eip);
+
+		if (test_cc(b, _eflags))
+		JMP_REL(rel);
+		break;
+	}
 	case 0x9c: /* pushf */
 		src.val =  (unsigned long) _eflags;
 		goto push;
-- 
1.5.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXIQIwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXIQIwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbXIQId2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:28 -0400
Received: from il.qumranet.com ([82.166.9.18]:45296 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbXIQIch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:37 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 098/104] KVM: x86 emulator: imlpement jump conditional relative
Date: Mon, 17 Sep 2007 10:32:20 +0200
Message-Id: <11900179491985-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Implement emulation of instruction:
    jump conditional rel
    opcodes: 0x0f 0x80 - 0x0f 0x8f

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   61 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index e4ce34c..ba53e59 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -188,7 +188,10 @@ static u16 twobyte_table[256] = {
 	/* 0x70 - 0x7F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x80 - 0x8F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
+	ImplicitOps, ImplicitOps, ImplicitOps, ImplicitOps,
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xA0 - 0xA7 */
@@ -479,6 +482,41 @@ static int read_descriptor(struct x86_emulate_ctxt *ctxt,
 	return rc;
 }
 
+static int test_cc(unsigned int condition, unsigned int flags)
+{
+	int rc = 0;
+
+	switch ((condition & 15) >> 1) {
+	case 0: /* o */
+		rc |= (flags & EFLG_OF);
+		break;
+	case 1: /* b/c/nae */
+		rc |= (flags & EFLG_CF);
+		break;
+	case 2: /* z/e */
+		rc |= (flags & EFLG_ZF);
+		break;
+	case 3: /* be/na */
+		rc |= (flags & (EFLG_CF|EFLG_ZF));
+		break;
+	case 4: /* s */
+		rc |= (flags & EFLG_SF);
+		break;
+	case 5: /* p/pe */
+		rc |= (flags & EFLG_PF);
+		break;
+	case 7: /* le/ng */
+		rc |= (flags & EFLG_ZF);
+		/* fall through */
+	case 6: /* l/nge */
+		rc |= (!(flags & EFLG_SF) != !(flags & EFLG_OF));
+		break;
+	}
+
+	/* Odd condition identifiers (lsb == 1) have inverted sense. */
+	return (!!rc ^ (condition & 1));
+}
+
 int
 x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
@@ -1486,6 +1524,27 @@ twobyte_special_insn:
 		}
 		rc = X86EMUL_CONTINUE;
 		break;
+	case 0x80 ... 0x8f: /* jnz rel, etc*/ {
+		long int rel;
+
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
+			DPRINTF("jnz: Invalid op_bytes\n");
+			goto cannot_emulate;
+		}
+		if (test_cc(b, _eflags))
+			JMP_REL(rel);
+		break;
+	}
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
 		{
 			u64 old, new;
-- 
1.5.3


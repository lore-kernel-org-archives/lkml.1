Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXIQJAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXIQJAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXIQIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:45250 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbXIQIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 057/104] KVM: x86 emulator: implement 'jmp rel' instruction (opcode 0xe9)
Date: Mon, 17 Sep 2007 10:31:39 +0200
Message-Id: <11900179481006-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 2b94d16..fa7aa27 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -145,8 +145,10 @@ static u8 opcode_table[256] = {
 	0, 0, 0, 0,
 	/* 0xD8 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0,
-	/* 0xE0 - 0xEF */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	/* 0xE0 - 0xE7 */
+	0, 0, 0, 0, 0, 0, 0, 0,
+	/* 0xE8 - 0xEF */
+	0, SrcImm|ImplicitOps, 0, 0, 0, 0, 0, 0,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
 	ImplicitOps, 0,
@@ -447,6 +449,12 @@ struct operand {
 			   (((reg) + _inc) & ((1UL << (ad_bytes << 3)) - 1)); \
 	} while (0)
 
+#define JMP_REL(rel) 							\
+	do {								\
+		_eip += (int)(rel);					\
+		_eip = ((op_bytes == 2) ? (uint16_t)_eip : (uint32_t)_eip); \
+	} while (0)
+
 /*
  * Given the 'reg' portion of a ModRM byte, and a register block, return a
  * pointer into the block that addresses the relevant register.
@@ -1023,6 +1031,10 @@ done_prefixes:
 	case 0xd2 ... 0xd3:	/* Grp2 */
 		src.val = _regs[VCPU_REGS_RCX];
 		goto grp2;
+	case 0xe9: /* jmp rel */
+		JMP_REL(src.val);
+		no_wb = 1; /* Disable writeback. */
+		break;
 	case 0xf6 ... 0xf7:	/* Grp3 */
 		switch (modrm_reg) {
 		case 0 ... 1:	/* test */
-- 
1.5.3


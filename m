Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbXIQJGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbXIQJGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXIQIeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:45281 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbXIQIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 016/104] KVM: x86 emulator: fix cmov for writeback changes
Date: Mon, 17 Sep 2007 10:30:58 +0200
Message-Id: <11900179474127-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The writeback fixes (02c03a326a5df825cc01de426f72e160db2b9538) broke
cmov emulation.  Fix.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index db9f955..82b4ea6 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1235,40 +1235,40 @@ twobyte_insn:
 		break;
 	case 0x40 ... 0x4f:	/* cmov */
 		dst.val = dst.orig_val = src.val;
-		d &= ~Mov;	/* default to no move */
+		no_wb = 1;
 		/*
 		 * First, assume we're decoding an even cmov opcode
 		 * (lsb == 0).
 		 */
 		switch ((b & 15) >> 1) {
 		case 0:	/* cmovo */
-			d |= (_eflags & EFLG_OF) ? Mov : 0;
+			no_wb = (_eflags & EFLG_OF) ? 0 : 1;
 			break;
 		case 1:	/* cmovb/cmovc/cmovnae */
-			d |= (_eflags & EFLG_CF) ? Mov : 0;
+			no_wb = (_eflags & EFLG_CF) ? 0 : 1;
 			break;
 		case 2:	/* cmovz/cmove */
-			d |= (_eflags & EFLG_ZF) ? Mov : 0;
+			no_wb = (_eflags & EFLG_ZF) ? 0 : 1;
 			break;
 		case 3:	/* cmovbe/cmovna */
-			d |= (_eflags & (EFLG_CF | EFLG_ZF)) ? Mov : 0;
+			no_wb = (_eflags & (EFLG_CF | EFLG_ZF)) ? 0 : 1;
 			break;
 		case 4:	/* cmovs */
-			d |= (_eflags & EFLG_SF) ? Mov : 0;
+			no_wb = (_eflags & EFLG_SF) ? 0 : 1;
 			break;
 		case 5:	/* cmovp/cmovpe */
-			d |= (_eflags & EFLG_PF) ? Mov : 0;
+			no_wb = (_eflags & EFLG_PF) ? 0 : 1;
 			break;
 		case 7:	/* cmovle/cmovng */
-			d |= (_eflags & EFLG_ZF) ? Mov : 0;
+			no_wb = (_eflags & EFLG_ZF) ? 0 : 1;
 			/* fall through */
 		case 6:	/* cmovl/cmovnge */
-			d |= (!(_eflags & EFLG_SF) !=
-			      !(_eflags & EFLG_OF)) ? Mov : 0;
+			no_wb &= (!(_eflags & EFLG_SF) !=
+			      !(_eflags & EFLG_OF)) ? 0 : 1;
 			break;
 		}
 		/* Odd cmov opcodes (lsb == 1) have inverted sense. */
-		d ^= (b & 1) ? Mov : 0;
+		no_wb ^= b & 1;
 		break;
 	case 0xb0 ... 0xb1:	/* cmpxchg */
 		/*
-- 
1.5.3


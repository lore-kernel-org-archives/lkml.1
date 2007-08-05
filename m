Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbXHEHQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbXHEHQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 03:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXHEHQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 03:16:03 -0400
Received: from il.qumranet.com ([82.166.9.18]:48255 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbXHEHQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 03:16:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Alistair John Strachan <alistair@devzero.co.uk>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH RESEND] KVM: x86 emulator: fix debug reg mov instructions
Date: Sun,  5 Aug 2007 10:16:11 +0300
Message-Id: <11862981712121-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

More fallout from the writeback fixes: debug register transfer instructions
do their own writeback and thus need to disable the general writeback
mechanism.  This fixes oopses and some guest failures on AMD machines (the
Intel variant decodes the instruction in hardware and thus does not need
emulation).

Cc: Alistair John Strachan <alistair@devzero.co.uk>
Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 1f979cb..4b8a0cc 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1217,11 +1217,13 @@ twobyte_insn:
 		}
 		break;
 	case 0x21: /* mov from dr to reg */
+		no_wb = 1;
 		if (modrm_mod != 3)
 			goto cannot_emulate;
 		rc = emulator_get_dr(ctxt, modrm_reg, &_regs[modrm_rm]);
 		break;
 	case 0x23: /* mov from reg to dr */
+		no_wb = 1;
 		if (modrm_mod != 3)
 			goto cannot_emulate;
 		rc = emulator_set_dr(ctxt, modrm_reg, _regs[modrm_rm]);

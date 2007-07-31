Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXGaHuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXGaHuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXGaHuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:50:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:45072 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXGaHuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:50:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Alistair John Strachan <alistair@devzero.co.uk>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH] KVM: x86 emulator: fix debug reg mov instructions
Date: Tue, 31 Jul 2007 10:50:11 +0300
Message-Id: <11858682112876-git-send-email-avi@qumranet.com>
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

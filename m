Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbXLBLT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbXLBLT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXLBLSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:13 -0500
Received: from il.qumranet.com ([82.166.9.18]:41419 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbXLBLSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Sheng Yang <sheng.yang@intel.com>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 01/10] KVM: x86 emulator: implement 'movnti mem, reg'
Date: Sun,  2 Dec 2007 13:18:38 +0200
Message-Id: <11965943273722-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

Implement emulation of instruction:
    movnti m32/m64, r32/r64
    opcode: 0x0f 0xc3

Needed to support Linux 2.6.16 as guest (used for mmio).

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 4b8a0cc..804e86c 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -198,7 +198,8 @@ static u16 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
-	0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | Mov, 0, 0, 0, ImplicitOps | ModRM,
+	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xD0 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE0 - 0xEF */
@@ -1324,6 +1325,10 @@ twobyte_insn:
 		dst.bytes = op_bytes;
 		dst.val = (d & ByteOp) ? (s8) src.val : (s16) src.val;
 		break;
+	case 0xc3:		/* movnti */
+		dst.bytes = op_bytes;
+		dst.val = (op_bytes == 4) ? (u32) src.val : (u64) src.val;
+		break;
 	}
 	goto writeback;
 
-- 
1.5.3


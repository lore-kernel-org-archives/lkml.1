Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbXJULJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbXJULJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXJULH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:58 -0400
Received: from il.qumranet.com ([82.166.9.18]:58443 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXJULHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:54 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 06/11] KVM: x86 emulator: implement 'movnti mem, reg'
Date: Sun, 21 Oct 2007 13:08:07 +0200
Message-Id: <1192964892551-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

Implement emulation of instruction:
    movnti m32/m64, r32/r64
    opcode: 0x0f 0xc3

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 80b1758..0a8696d 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -212,7 +212,8 @@ static u16 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
-	0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | Mov, 0, 0, 0, ImplicitOps | ModRM,
+	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xD0 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE0 - 0xEF */
@@ -1501,6 +1502,10 @@ twobyte_insn:
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


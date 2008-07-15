Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYGOMP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYGOMP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbYGOMMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:52 -0400
Received: from il.qumranet.com ([212.179.150.194]:30355 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbYGOMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 18/19] KVM: x86 emulator: emulate clflush
Date: Tue, 15 Jul 2008 15:12:37 +0300
Message-Id: <1216123958-10717-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

If the guest issues a clflush in a mmio address, the instruction
can trap into the hypervisor. Currently, we do not decode clflush
properly, causing the guest to hang. This patch fixes this emulating
clflush (opcode 0f ae).

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 8bc63f6..f2f9046 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -219,7 +219,7 @@ static u16 twobyte_table[256] = {
 	/* 0xA0 - 0xA7 */
 	0, 0, 0, DstMem | SrcReg | ModRM | BitOp, 0, 0, 0, 0,
 	/* 0xA8 - 0xAF */
-	0, 0, 0, DstMem | SrcReg | ModRM | BitOp, 0, 0, 0, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | BitOp, 0, 0, ModRM, 0,
 	/* 0xB0 - 0xB7 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM, 0,
 	    DstMem | SrcReg | ModRM | BitOp,
@@ -1947,6 +1947,8 @@ twobyte_insn:
 		c->src.val &= (c->dst.bytes << 3) - 1;
 		emulate_2op_SrcV_nobyte("bts", c->src, c->dst, ctxt->eflags);
 		break;
+	case 0xae:              /* clflush */
+		break;
 	case 0xb0 ... 0xb1:	/* cmpxchg */
 		/*
 		 * Save real source value, then compare EAX against
-- 
1.5.6.1


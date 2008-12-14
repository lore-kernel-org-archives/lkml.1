Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYLNIUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYLNIUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYLNIIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59951 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbYLNIHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:23 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 30/36] KVM: x86 emulator: add the emulation of shld and shrd instructions
Date: Sun, 14 Dec 2008 10:07:03 +0200
Message-Id: <1229242029-13410-31-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add emulation of shld and shrd instructions

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 9ae6d5b..219dc31 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -237,9 +237,14 @@ static u32 twobyte_table[256] = {
 	/* 0x90 - 0x9F */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xA0 - 0xA7 */
-	0, 0, 0, DstMem | SrcReg | ModRM | BitOp, 0, 0, 0, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | BitOp,
+	DstMem | SrcReg | Src2ImmByte | ModRM,
+	DstMem | SrcReg | Src2CL | ModRM, 0, 0,
 	/* 0xA8 - 0xAF */
-	0, 0, 0, DstMem | SrcReg | ModRM | BitOp, 0, 0, ModRM, 0,
+	0, 0, 0, DstMem | SrcReg | ModRM | BitOp,
+	DstMem | SrcReg | Src2ImmByte | ModRM,
+	DstMem | SrcReg | Src2CL | ModRM,
+	ModRM, 0,
 	/* 0xB0 - 0xB7 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM, 0,
 	    DstMem | SrcReg | ModRM | BitOp,
@@ -2037,12 +2042,20 @@ twobyte_insn:
 		c->src.val &= (c->dst.bytes << 3) - 1;
 		emulate_2op_SrcV_nobyte("bt", c->src, c->dst, ctxt->eflags);
 		break;
+	case 0xa4: /* shld imm8, r, r/m */
+	case 0xa5: /* shld cl, r, r/m */
+		emulate_2op_cl("shld", c->src2, c->src, c->dst, ctxt->eflags);
+		break;
 	case 0xab:
 	      bts:		/* bts */
 		/* only subword offset */
 		c->src.val &= (c->dst.bytes << 3) - 1;
 		emulate_2op_SrcV_nobyte("bts", c->src, c->dst, ctxt->eflags);
 		break;
+	case 0xac: /* shrd imm8, r, r/m */
+	case 0xad: /* shrd cl, r, r/m */
+		emulate_2op_cl("shrd", c->src2, c->src, c->dst, ctxt->eflags);
+		break;
 	case 0xae:              /* clflush */
 		break;
 	case 0xb0 ... 0xb1:	/* cmpxchg */
-- 
1.6.0.3


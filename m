Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZHPJjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZHPJjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZHPJix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45337 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/48] KVM: x86 emulator: Implement zero-extended immediate decoding
Date: Sun, 16 Aug 2009 12:29:26 +0300
Message-Id: <1250415008-17175-7-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Absolute jumps use zero extended immediate operands.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 616de46..a30d5fc 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -60,6 +60,7 @@
 #define SrcImmByte  (6<<4)	/* 8-bit sign-extended immediate operand. */
 #define SrcOne      (7<<4)	/* Implied '1' */
 #define SrcImmUByte (8<<4)      /* 8-bit unsigned immediate operand. */
+#define SrcImmU     (9<<4)      /* Immediate operand, unsigned */
 #define SrcMask     (0xf<<4)
 /* Generic ModRM decode. */
 #define ModRM       (1<<8)
@@ -1027,6 +1028,7 @@ done_prefixes:
 		c->src.type = OP_MEM;
 		break;
 	case SrcImm:
+	case SrcImmU:
 		c->src.type = OP_IMM;
 		c->src.ptr = (unsigned long *)c->eip;
 		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
@@ -1044,6 +1046,19 @@ done_prefixes:
 			c->src.val = insn_fetch(s32, 4, c->eip);
 			break;
 		}
+		if ((c->d & SrcMask) == SrcImmU) {
+			switch (c->src.bytes) {
+			case 1:
+				c->src.val &= 0xff;
+				break;
+			case 2:
+				c->src.val &= 0xffff;
+				break;
+			case 4:
+				c->src.val &= 0xffffffff;
+				break;
+			}
+		}
 		break;
 	case SrcImmByte:
 	case SrcImmUByte:
-- 
1.6.3.3


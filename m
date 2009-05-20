Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZETLZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZETLZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbZETLTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 27/46] KVM: x86 emulator: Add unsigned byte immediate decode
Date: Wed, 20 May 2009 14:18:24 +0300
Message-Id: <1242818323-10413-28-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Extend "Source operand type" opcode description field to 4 bites
to accommodate new option.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 4a9cd4c..0988a13 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -59,13 +59,14 @@
 #define SrcImm      (5<<4)	/* Immediate operand. */
 #define SrcImmByte  (6<<4)	/* 8-bit sign-extended immediate operand. */
 #define SrcOne      (7<<4)	/* Implied '1' */
-#define SrcMask     (7<<4)
+#define SrcImmUByte (8<<4)      /* 8-bit unsigned immediate operand. */
+#define SrcMask     (0xf<<4)
 /* Generic ModRM decode. */
-#define ModRM       (1<<7)
+#define ModRM       (1<<8)
 /* Destination is only written; never read. */
-#define Mov         (1<<8)
-#define BitOp       (1<<9)
-#define MemAbs      (1<<10)      /* Memory operand is absolute displacement */
+#define Mov         (1<<9)
+#define BitOp       (1<<10)
+#define MemAbs      (1<<11)      /* Memory operand is absolute displacement */
 #define String      (1<<12)     /* String instruction (rep capable) */
 #define Stack       (1<<13)     /* Stack instruction (push/pop) */
 #define Group       (1<<14)     /* Bits 3:5 of modrm byte extend opcode */
@@ -1044,10 +1045,14 @@ done_prefixes:
 		}
 		break;
 	case SrcImmByte:
+	case SrcImmUByte:
 		c->src.type = OP_IMM;
 		c->src.ptr = (unsigned long *)c->eip;
 		c->src.bytes = 1;
-		c->src.val = insn_fetch(s8, 1, c->eip);
+		if ((c->d & SrcMask) == SrcImmByte)
+			c->src.val = insn_fetch(s8, 1, c->eip);
+		else
+			c->src.val = insn_fetch(u8, 1, c->eip);
 		break;
 	case SrcOne:
 		c->src.bytes = 1;
-- 
1.6.0.6


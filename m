Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYI1PwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYI1PwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYI1PqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:46:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYI1PqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:46:17 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 16/25] KVM: x86 emulator: Add DstAcc operand type
Date: Sun, 28 Sep 2008 18:44:52 +0300
Message-Id: <1222616701-1206-17-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add DstAcc operand type. That means that there are 4 bits now for
DstMask.

"In the good old days cpus would have only one register that was able to
 fully participate in arithmetic operations, typically called A for
 Accumulator.  The x86 retains this tradition by having special, shorter
 encodings for the A register (like the cmp opcode), and even some
 instructions that only operate on A (like mul).

 SrcAcc and DstAcc would accommodate these instructions by decoding A
 into the corresponding 'struct operand'."
  -- Avi Kivity

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   50 +++++++++++++++++++++++++++++--------------
 1 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 0c120c4..4390ec8 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -47,25 +47,26 @@
 #define ImplicitOps (1<<1)	/* Implicit in opcode. No generic decode. */
 #define DstReg      (2<<1)	/* Register operand. */
 #define DstMem      (3<<1)	/* Memory operand. */
-#define DstMask     (3<<1)
+#define DstAcc      (4<<1)      /* Destination Accumulator */
+#define DstMask     (7<<1)
 /* Source operand type. */
-#define SrcNone     (0<<3)	/* No source operand. */
-#define SrcImplicit (0<<3)	/* Source operand is implicit in the opcode. */
-#define SrcReg      (1<<3)	/* Register operand. */
-#define SrcMem      (2<<3)	/* Memory operand. */
-#define SrcMem16    (3<<3)	/* Memory operand (16-bit). */
-#define SrcMem32    (4<<3)	/* Memory operand (32-bit). */
-#define SrcImm      (5<<3)	/* Immediate operand. */
-#define SrcImmByte  (6<<3)	/* 8-bit sign-extended immediate operand. */
-#define SrcMask     (7<<3)
+#define SrcNone     (0<<4)	/* No source operand. */
+#define SrcImplicit (0<<4)	/* Source operand is implicit in the opcode. */
+#define SrcReg      (1<<4)	/* Register operand. */
+#define SrcMem      (2<<4)	/* Memory operand. */
+#define SrcMem16    (3<<4)	/* Memory operand (16-bit). */
+#define SrcMem32    (4<<4)	/* Memory operand (32-bit). */
+#define SrcImm      (5<<4)	/* Immediate operand. */
+#define SrcImmByte  (6<<4)	/* 8-bit sign-extended immediate operand. */
+#define SrcMask     (7<<4)
 /* Generic ModRM decode. */
-#define ModRM       (1<<6)
+#define ModRM       (1<<7)
 /* Destination is only written; never read. */
-#define Mov         (1<<7)
-#define BitOp       (1<<8)
-#define MemAbs      (1<<9)      /* Memory operand is absolute displacement */
-#define String      (1<<10)     /* String instruction (rep capable) */
-#define Stack       (1<<11)     /* Stack instruction (push/pop) */
+#define Mov         (1<<8)
+#define BitOp       (1<<9)
+#define MemAbs      (1<<10)      /* Memory operand is absolute displacement */
+#define String      (1<<12)     /* String instruction (rep capable) */
+#define Stack       (1<<13)     /* Stack instruction (push/pop) */
 #define Group       (1<<14)     /* Bits 3:5 of modrm byte extend opcode */
 #define GroupDual   (1<<15)     /* Alternate decoding of mod == 3 */
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
@@ -1060,6 +1061,23 @@ done_prefixes:
 		}
 		c->dst.type = OP_MEM;
 		break;
+	case DstAcc:
+		c->dst.type = OP_REG;
+		c->dst.bytes = c->op_bytes;
+		c->dst.ptr = &c->regs[VCPU_REGS_RAX];
+		switch (c->op_bytes) {
+			case 1:
+				c->dst.val = *(u8 *)c->dst.ptr;
+				break;
+			case 2:
+				c->dst.val = *(u16 *)c->dst.ptr;
+				break;
+			case 4:
+				c->dst.val = *(u32 *)c->dst.ptr;
+				break;
+		}
+		c->dst.orig_val = c->dst.val;
+		break;
 	}
 
 	if (c->rip_relative)
-- 
1.6.0.1


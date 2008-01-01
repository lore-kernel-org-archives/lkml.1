Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbYAAPrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbYAAPrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYAAPgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:51 -0500
Received: from il.qumranet.com ([82.166.9.18]:33793 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbYAAPg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:29 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 39/54] KVM: x86 emulator: Fix stack instructions on 64-bit mode
Date: Tue,  1 Jan 2008 17:36:05 +0200
Message-Id: <1199201780-14001-40-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stack instructions are always 64-bit on 64-bit mode; many of the
emulated stack instructions did not take that into account.  Fix by
adding a 'Stack' bitflag and setting the operand size appropriately
during the decode stage (except for 'push r/m', which is in a group
with a few other instructions, so it gets its own treatment).

This fixes random crashes on Vista x64.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index f423b0e..0a6ab06 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -65,6 +65,7 @@
 #define BitOp       (1<<8)
 #define MemAbs      (1<<9)      /* Memory operand is absolute displacement */
 #define String      (1<<10)     /* String instruction (rep capable) */
+#define Stack       (1<<11)     /* Stack instruction (push/pop) */
 
 static u16 opcode_table[256] = {
 	/* 0x00 - 0x07 */
@@ -104,14 +105,16 @@ static u16 opcode_table[256] = {
 	/* 0x48 - 0x4F */
 	DstReg, DstReg, DstReg, DstReg,	DstReg, DstReg, DstReg, DstReg,
 	/* 0x50 - 0x57 */
-	SrcReg, SrcReg, SrcReg, SrcReg, SrcReg, SrcReg, SrcReg, SrcReg,
+	SrcReg | Stack, SrcReg | Stack, SrcReg | Stack, SrcReg | Stack,
+	SrcReg | Stack, SrcReg | Stack, SrcReg | Stack, SrcReg | Stack,
 	/* 0x58 - 0x5F */
-	DstReg, DstReg, DstReg, DstReg,	DstReg, DstReg, DstReg, DstReg,
+	DstReg | Stack, DstReg | Stack, DstReg | Stack, DstReg | Stack,
+	DstReg | Stack, DstReg | Stack, DstReg | Stack, DstReg | Stack,
 	/* 0x60 - 0x67 */
 	0, 0, 0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
 	0, 0, 0, 0,
 	/* 0x68 - 0x6F */
-	0, 0, ImplicitOps|Mov, 0,
+	0, 0, ImplicitOps | Mov | Stack, 0,
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* insb, insw/insd */
 	SrcNone  | ByteOp  | ImplicitOps, SrcNone  | ImplicitOps, /* outsb, outsw/outsd */
 	/* 0x70 - 0x77 */
@@ -128,9 +131,10 @@ static u16 opcode_table[256] = {
 	/* 0x88 - 0x8F */
 	ByteOp | DstMem | SrcReg | ModRM | Mov, DstMem | SrcReg | ModRM | Mov,
 	ByteOp | DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
-	0, ModRM | DstReg, 0, DstMem | SrcNone | ModRM | Mov,
+	0, ModRM | DstReg, 0, DstMem | SrcNone | ModRM | Mov | Stack,
 	/* 0x90 - 0x9F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps, ImplicitOps, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, ImplicitOps | Stack, ImplicitOps | Stack, 0, 0,
 	/* 0xA0 - 0xA7 */
 	ByteOp | DstReg | SrcMem | Mov | MemAbs, DstReg | SrcMem | Mov | MemAbs,
 	ByteOp | DstMem | SrcReg | Mov | MemAbs, DstMem | SrcReg | Mov | MemAbs,
@@ -144,7 +148,7 @@ static u16 opcode_table[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xC0 - 0xC7 */
 	ByteOp | DstMem | SrcImm | ModRM, DstMem | SrcImmByte | ModRM,
-	0, ImplicitOps, 0, 0,
+	0, ImplicitOps | Stack, 0, 0,
 	ByteOp | DstMem | SrcImm | ModRM | Mov, DstMem | SrcImm | ModRM | Mov,
 	/* 0xC8 - 0xCF */
 	0, 0, 0, 0, 0, 0, 0, 0,
@@ -157,7 +161,8 @@ static u16 opcode_table[256] = {
 	/* 0xE0 - 0xE7 */
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE8 - 0xEF */
-	ImplicitOps, SrcImm|ImplicitOps, 0, SrcImmByte|ImplicitOps, 0, 0, 0, 0,
+	ImplicitOps | Stack, SrcImm|ImplicitOps, 0, SrcImmByte|ImplicitOps,
+	0, 0, 0, 0,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
 	ImplicitOps, ImplicitOps,
@@ -868,6 +873,9 @@ done_prefixes:
 		}
 	}
 
+	if (mode == X86EMUL_MODE_PROT64 && (c->d & Stack))
+		c->op_bytes = 8;
+
 	/* ModRM and SIB bytes. */
 	if (c->d & ModRM)
 		rc = decode_modrm(ctxt, ops);
@@ -988,11 +996,6 @@ static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
-	/* 64-bit mode: POP always pops a 64-bit operand. */
-
-	if (ctxt->mode == X86EMUL_MODE_PROT64)
-		c->dst.bytes = 8;
-
 	rc = ops->read_std(register_address(ctxt->ss_base,
 					    c->regs[VCPU_REGS_RSP]),
 			   &c->dst.val, c->dst.bytes, ctxt->vcpu);
-- 
1.5.3.7


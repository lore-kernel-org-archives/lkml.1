Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298Ab0BQNsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:48:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939Ab0BQNpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:38 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] KVM: x86 emulator: Check CPL level during privilege instruction emulation
Date: Wed, 17 Feb 2010 15:45:26 +0200
Message-Id: <1266414330-27444-17-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Add CPL checking in case emulator is tricked into emulating
privilege instruction from userspace.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1782387..d632111 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -76,6 +76,7 @@
 #define GroupDual   (1<<15)     /* Alternate decoding of mod == 3 */
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
 /* Misc flags */
+#define Priv        (1<<27) /* instruction generates #GP if current CPL != 0 */
 #define No64	    (1<<28)
 /* Source 2 operand type */
 #define Src2None    (0<<29)
@@ -211,7 +212,7 @@ static u32 opcode_table[256] = {
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
-	ImplicitOps, ImplicitOps, Group | Group3_Byte, Group | Group3,
+	ImplicitOps | Priv, ImplicitOps, Group | Group3_Byte, Group | Group3,
 	/* 0xF8 - 0xFF */
 	ImplicitOps, 0, ImplicitOps, ImplicitOps,
 	ImplicitOps, ImplicitOps, Group | Group4, Group | Group5,
@@ -219,16 +220,20 @@ static u32 opcode_table[256] = {
 
 static u32 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
-	0, Group | GroupDual | Group7, 0, 0, 0, ImplicitOps, ImplicitOps, 0,
-	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
+	0, Group | GroupDual | Group7, 0, 0,
+	0, ImplicitOps, ImplicitOps | Priv, 0,
+	ImplicitOps | Priv, ImplicitOps | Priv, 0, 0,
+	0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x20 - 0x2F */
-	ModRM | ImplicitOps, ModRM, ModRM | ImplicitOps, ModRM, 0, 0, 0, 0,
+	ModRM | ImplicitOps | Priv, ModRM | Priv,
+	ModRM | ImplicitOps | Priv, ModRM | Priv,
+	0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x30 - 0x3F */
-	ImplicitOps, 0, ImplicitOps, 0,
-	ImplicitOps, ImplicitOps, 0, 0,
+	ImplicitOps | Priv, 0, ImplicitOps | Priv, 0,
+	ImplicitOps, ImplicitOps | Priv, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x40 - 0x47 */
 	DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
@@ -322,9 +327,9 @@ static u32 group_table[] = {
 	SrcMem | ModRM | Stack, 0,
 	SrcMem | ModRM | Stack, 0, SrcMem | ModRM | Stack, 0,
 	[Group7*8] =
-	0, 0, ModRM | SrcMem, ModRM | SrcMem,
+	0, 0, ModRM | SrcMem | Priv, ModRM | SrcMem | Priv,
 	SrcNone | ModRM | DstMem | Mov, 0,
-	SrcMem16 | ModRM | Mov, SrcMem | ModRM | ByteOp,
+	SrcMem16 | ModRM | Mov | Priv, SrcMem | ModRM | ByteOp | Priv,
 	[Group8*8] =
 	0, 0, 0, 0,
 	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
@@ -335,7 +340,7 @@ static u32 group_table[] = {
 
 static u32 group2_table[] = {
 	[Group7*8] =
-	SrcNone | ModRM, 0, 0, SrcNone | ModRM,
+	SrcNone | ModRM | Priv, 0, 0, SrcNone | ModRM,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, 0,
 	[Group9*8] =
@@ -1700,12 +1705,6 @@ emulate_sysexit(struct x86_emulate_ctxt *ctxt)
 		return -1;
 	}
 
-	/* sysexit must be called from CPL 0 */
-	if (kvm_x86_ops->get_cpl(ctxt->vcpu) != 0) {
-		kvm_inject_gp(ctxt->vcpu, 0);
-		return -1;
-	}
-
 	setup_syscalls_segments(ctxt, &cs, &ss);
 
 	if ((c->rex_prefix & 0x8) != 0x0)
@@ -1820,6 +1819,12 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 	saved_eip = c->eip;
 
+	/* Privileged instruction can be executed only in CPL=0 */
+	if ((c->d & Priv) && kvm_x86_ops->get_cpl(ctxt->vcpu)) {
+		kvm_inject_gp(ctxt->vcpu, 0);
+		goto done;
+	}
+
 	if (((c->d & ModRM) && (c->modrm_mod != 3)) || (c->d & MemAbs))
 		memop = c->modrm_ea;
 
-- 
1.6.5.3


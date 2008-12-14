Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbYLNIUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbYLNIUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:20:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYLNIIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbYLNIHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:23 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 27/36] KVM: x86 emulator: add Src2 decode set
Date: Sun, 14 Dec 2008 10:07:00 +0200
Message-Id: <1229242029-13410-28-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Instruction like shld has three operands, so we need to add a Src2
decode set. We start with Src2None, Src2CL, and Src2ImmByte, Src2One to
support shld/shrd and we will expand it later.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_x86_emulate.h |    1 +
 arch/x86/kvm/x86_emulate.c             |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_x86_emulate.h
index 16a0026..6a15973 100644
--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -123,6 +123,7 @@ struct decode_cache {
 	u8 ad_bytes;
 	u8 rex_prefix;
 	struct operand src;
+	struct operand src2;
 	struct operand dst;
 	bool has_seg_override;
 	u8 seg_override;
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 7a07ca4..7f5cd62 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -70,6 +70,12 @@
 #define Group       (1<<14)     /* Bits 3:5 of modrm byte extend opcode */
 #define GroupDual   (1<<15)     /* Alternate decoding of mod == 3 */
 #define GroupMask   0xff        /* Group number stored in bits 0:7 */
+/* Source 2 operand type */
+#define Src2None    (0<<29)
+#define Src2CL      (1<<29)
+#define Src2ImmByte (2<<29)
+#define Src2One     (3<<29)
+#define Src2Mask    (7<<29)
 
 enum {
 	Group1_80, Group1_81, Group1_82, Group1_83,
@@ -1000,6 +1006,29 @@ done_prefixes:
 		break;
 	}
 
+	/*
+	 * Decode and fetch the second source operand: register, memory
+	 * or immediate.
+	 */
+	switch (c->d & Src2Mask) {
+	case Src2None:
+		break;
+	case Src2CL:
+		c->src2.bytes = 1;
+		c->src2.val = c->regs[VCPU_REGS_RCX] & 0x8;
+		break;
+	case Src2ImmByte:
+		c->src2.type = OP_IMM;
+		c->src2.ptr = (unsigned long *)c->eip;
+		c->src2.bytes = 1;
+		c->src2.val = insn_fetch(u8, 1, c->eip);
+		break;
+	case Src2One:
+		c->src2.bytes = 1;
+		c->src2.val = 1;
+		break;
+	}
+
 	/* Decode and fetch the destination operand: register or memory. */
 	switch (c->d & DstMask) {
 	case ImplicitOps:
-- 
1.6.0.3


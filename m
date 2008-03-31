Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbYCaOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbYCaOiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYCaOhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:31 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51279
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYCaOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/40] KVM: x86 emulator: add support for group decoding
Date: Mon, 31 Mar 2008 17:36:47 +0300
Message-Id: <1206974244-9716-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain x86 instructions use bits 3:5 of the byte following the opcode as an
opcode extension, with the decode sometimes depending on bits 6:7 as well.
Add support for this in the main decoding table rather than an ad-hock
adaptation per opcode.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 7958600..46ecf34 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -65,6 +65,9 @@
 #define MemAbs      (1<<9)      /* Memory operand is absolute displacement */
 #define String      (1<<10)     /* String instruction (rep capable) */
 #define Stack       (1<<11)     /* Stack instruction (push/pop) */
+#define Group       (1<<14)     /* Bits 3:5 of modrm byte extend opcode */
+#define GroupDual   (1<<15)     /* Alternate decoding of mod == 3 */
+#define GroupMask   0xff        /* Group number stored in bits 0:7 */
 
 static u16 opcode_table[256] = {
 	/* 0x00 - 0x07 */
@@ -229,6 +232,12 @@ static u16 twobyte_table[256] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
+static u16 group_table[] = {
+};
+
+static u16 group2_table[] = {
+};
+
 /* EFLAGS bit definitions. */
 #define EFLG_OF (1<<11)
 #define EFLG_DF (1<<10)
@@ -763,7 +772,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	struct decode_cache *c = &ctxt->decode;
 	int rc = 0;
 	int mode = ctxt->mode;
-	int def_op_bytes, def_ad_bytes;
+	int def_op_bytes, def_ad_bytes, group;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
 
@@ -864,12 +873,24 @@ done_prefixes:
 			c->b = insn_fetch(u8, 1, c->eip);
 			c->d = twobyte_table[c->b];
 		}
+	}
 
-		/* Unrecognised? */
-		if (c->d == 0) {
-			DPRINTF("Cannot emulate %02x\n", c->b);
-			return -1;
-		}
+	if (c->d & Group) {
+		group = c->d & GroupMask;
+		c->modrm = insn_fetch(u8, 1, c->eip);
+		--c->eip;
+
+		group = (group << 3) + ((c->modrm >> 3) & 7);
+		if ((c->d & GroupDual) && (c->modrm >> 6) == 3)
+			c->d = group2_table[group];
+		else
+			c->d = group_table[group];
+	}
+
+	/* Unrecognised? */
+	if (c->d == 0) {
+		DPRINTF("Cannot emulate %02x\n", c->b);
+		return -1;
 	}
 
 	if (mode == X86EMUL_MODE_PROT64 && (c->d & Stack))
-- 
1.5.4.5


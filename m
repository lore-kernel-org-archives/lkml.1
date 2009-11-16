Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZKPM03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZKPM03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZKPMUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 20/42] KVM: x86 emulator: Add pusha and popa instructions
Date: Mon, 16 Nov 2009 14:19:21 +0200
Message-Id: <1258373983-8693-21-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

This adds pusha and popa instructions (opcodes 0x60-0x61), this enables booting
MINIX with invalid guest state emulation on.

[marcelo: remove unused variable]

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index db0820d..d226dff 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -139,7 +139,8 @@ static u32 opcode_table[256] = {
 	DstReg | Stack, DstReg | Stack, DstReg | Stack, DstReg | Stack,
 	DstReg | Stack, DstReg | Stack, DstReg | Stack, DstReg | Stack,
 	/* 0x60 - 0x67 */
-	0, 0, 0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
+	ImplicitOps | Stack | No64, ImplicitOps | Stack | No64,
+	0, DstReg | SrcMem32 | ModRM | Mov /* movsxd (x86/64) */ ,
 	0, 0, 0, 0,
 	/* 0x68 - 0x6F */
 	SrcImm | Mov | Stack, 0, SrcImmByte | Mov | Stack, 0,
@@ -1225,6 +1226,43 @@ static int emulate_pop_sreg(struct x86_emulate_ctxt *ctxt,
 	return rc;
 }
 
+static void emulate_pusha(struct x86_emulate_ctxt *ctxt)
+{
+	struct decode_cache *c = &ctxt->decode;
+	unsigned long old_esp = c->regs[VCPU_REGS_RSP];
+	int reg = VCPU_REGS_RAX;
+
+	while (reg <= VCPU_REGS_RDI) {
+		(reg == VCPU_REGS_RSP) ?
+		(c->src.val = old_esp) : (c->src.val = c->regs[reg]);
+
+		emulate_push(ctxt);
+		++reg;
+	}
+}
+
+static int emulate_popa(struct x86_emulate_ctxt *ctxt,
+			struct x86_emulate_ops *ops)
+{
+	struct decode_cache *c = &ctxt->decode;
+	int rc = 0;
+	int reg = VCPU_REGS_RDI;
+
+	while (reg >= VCPU_REGS_RAX) {
+		if (reg == VCPU_REGS_RSP) {
+			register_address_increment(c, &c->regs[VCPU_REGS_RSP],
+							c->op_bytes);
+			--reg;
+		}
+
+		rc = emulate_pop(ctxt, ops, &c->regs[reg], c->op_bytes);
+		if (rc != 0)
+			break;
+		--reg;
+	}
+	return rc;
+}
+
 static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 				struct x86_emulate_ops *ops)
 {
@@ -1816,6 +1854,14 @@ special_insn:
 		if (rc != 0)
 			goto done;
 		break;
+	case 0x60:	/* pusha */
+		emulate_pusha(ctxt);
+		break;
+	case 0x61:	/* popa */
+		rc = emulate_popa(ctxt, ops);
+		if (rc != 0)
+			goto done;
+		break;
 	case 0x63:		/* movsxd */
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
 			goto cannot_emulate;
-- 
1.6.5.2


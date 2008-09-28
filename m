Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYI1PrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYI1PrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYI1PpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbYI1PpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:14 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 05/25] KVM: x86 emulator: Add in/out instructions (opcodes 0xe4-0xe7, 0xec-0xef)
Date: Sun, 28 Sep 2008 18:44:41 +0300
Message-Id: <1222616701-1206-6-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

The patch adds in/out instructions to the x86 emulator.

The instruction was encountered while running the BIOS while using
the invalid guest state emulation patch.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   35 +++++++++++++++++++++++++++++++++--
 1 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 944f1f4..3ac2f14 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -177,11 +177,14 @@ static u16 opcode_table[256] = {
 	/* 0xD8 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xE0 - 0xE7 */
-	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0,
+	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
+	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xE8 - 0xEF */
 	ImplicitOps | Stack, SrcImm | ImplicitOps,
 	ImplicitOps, SrcImmByte | ImplicitOps,
-	0, 0, 0, 0,
+	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
+	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xF0 - 0xF7 */
 	0, 0, 0, 0,
 	ImplicitOps, ImplicitOps, Group | Group3_Byte, Group | Group3,
@@ -1259,6 +1262,8 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	u64 msr_data;
 	unsigned long saved_eip = 0;
 	struct decode_cache *c = &ctxt->decode;
+	unsigned int port;
+	int io_dir_in;
 	int rc = 0;
 
 	/* Shadow copy of register state. Committed on successful emulation.
@@ -1687,6 +1692,16 @@ special_insn:
 		c->src.val = c->regs[VCPU_REGS_RCX];
 		emulate_grp2(ctxt);
 		break;
+	case 0xe4: 	/* inb */
+	case 0xe5: 	/* in */
+		port = insn_fetch(u8, 1, c->eip);
+		io_dir_in = 1;
+		goto do_io;
+	case 0xe6: /* outb */
+	case 0xe7: /* out */
+		port = insn_fetch(u8, 1, c->eip);
+		io_dir_in = 0;
+		goto do_io;
 	case 0xe8: /* call (near) */ {
 		long int rel;
 		switch (c->op_bytes) {
@@ -1737,6 +1752,22 @@ special_insn:
 		jmp_rel(c, c->src.val);
 		c->dst.type = OP_NONE; /* Disable writeback. */
 		break;
+	case 0xec: /* in al,dx */
+	case 0xed: /* in (e/r)ax,dx */
+		port = c->regs[VCPU_REGS_RDX];
+		io_dir_in = 1;
+		goto do_io;
+	case 0xee: /* out al,dx */
+	case 0xef: /* out (e/r)ax,dx */
+		port = c->regs[VCPU_REGS_RDX];
+		io_dir_in = 0;
+	do_io:	if (kvm_emulate_pio(ctxt->vcpu, NULL, io_dir_in,
+				   (c->d & ByteOp) ? 1 : c->op_bytes,
+				   port) != 0) {
+			c->eip = saved_eip;
+			goto cannot_emulate;
+		}
+		return 0;
 	case 0xf4:              /* hlt */
 		ctxt->vcpu->arch.halt_request = 1;
 		break;
-- 
1.6.0.1


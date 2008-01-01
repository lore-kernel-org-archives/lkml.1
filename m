Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYAAPl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYAAPl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbYAAPgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:37 -0500
Received: from il.qumranet.com ([82.166.9.18]:33798 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264AbYAAPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:26 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 16/54] KVM: x86 emulator: Move rep processing before instruction execution
Date: Tue,  1 Jan 2008 17:35:42 +0200
Message-Id: <1199201780-14001-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently rep processing is handled somewhere in the middle of instruction
processing.  Move it to a sensible place.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   70 +++++++++++++++++++++++----------------------
 1 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 84e5366..53377f0 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -64,6 +64,7 @@
 #define Mov         (1<<7)
 #define BitOp       (1<<8)
 #define MemAbs      (1<<9)      /* Memory operand is absolute displacement */
+#define String      (1<<10)     /* String instruction (rep capable) */
 
 static u16 opcode_table[256] = {
 	/* 0x00 - 0x07 */
@@ -133,12 +134,12 @@ static u16 opcode_table[256] = {
 	/* 0xA0 - 0xA7 */
 	ByteOp | DstReg | SrcMem | Mov | MemAbs, DstReg | SrcMem | Mov | MemAbs,
 	ByteOp | DstMem | SrcReg | Mov | MemAbs, DstMem | SrcReg | Mov | MemAbs,
-	ByteOp | ImplicitOps | Mov, ImplicitOps | Mov,
-	ByteOp | ImplicitOps, ImplicitOps,
+	ByteOp | ImplicitOps | Mov | String, ImplicitOps | Mov | String,
+	ByteOp | ImplicitOps | String, ImplicitOps | String,
 	/* 0xA8 - 0xAF */
-	0, 0, ByteOp | ImplicitOps | Mov, ImplicitOps | Mov,
-	ByteOp | ImplicitOps | Mov, ImplicitOps | Mov,
-	ByteOp | ImplicitOps, ImplicitOps,
+	0, 0, ByteOp | ImplicitOps | Mov | String, ImplicitOps | Mov | String,
+	ByteOp | ImplicitOps | Mov | String, ImplicitOps | Mov | String,
+	ByteOp | ImplicitOps | String, ImplicitOps | String,
 	/* 0xB0 - 0xBF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xC0 - 0xC7 */
@@ -1228,6 +1229,36 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	if (((c->d & ModRM) && (c->modrm_mod != 3)) || (c->d & MemAbs))
 		memop = c->modrm_ea;
 
+	if (c->rep_prefix && (c->d & String)) {
+		/* All REP prefixes have the same first termination condition */
+		if (c->regs[VCPU_REGS_RCX] == 0) {
+			ctxt->vcpu->rip = c->eip;
+			goto done;
+		}
+		/* The second termination condition only applies for REPE
+		 * and REPNE. Test if the repeat string operation prefix is
+		 * REPE/REPZ or REPNE/REPNZ and if it's the case it tests the
+		 * corresponding termination condition according to:
+		 * 	- if REPE/REPZ and ZF = 0 then done
+		 * 	- if REPNE/REPNZ and ZF = 1 then done
+		 */
+		if ((c->b == 0xa6) || (c->b == 0xa7) ||
+				(c->b == 0xae) || (c->b == 0xaf)) {
+			if ((c->rep_prefix == REPE_PREFIX) &&
+				((ctxt->eflags & EFLG_ZF) == 0)) {
+					ctxt->vcpu->rip = c->eip;
+					goto done;
+			}
+			if ((c->rep_prefix == REPNE_PREFIX) &&
+				((ctxt->eflags & EFLG_ZF) == EFLG_ZF)) {
+				ctxt->vcpu->rip = c->eip;
+				goto done;
+			}
+		}
+		c->regs[VCPU_REGS_RCX]--;
+		c->eip = ctxt->vcpu->rip;
+	}
+
 	if (c->src.type == OP_MEM) {
 		c->src.ptr = (unsigned long *)memop;
 		c->src.val = 0;
@@ -1534,35 +1565,6 @@ special_insn:
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
 	}
-	if (c->rep_prefix) {
-		/* All REP prefixes have the same first termination condition */
-		if (c->regs[VCPU_REGS_RCX] == 0) {
-			ctxt->vcpu->rip = c->eip;
-			goto done;
-		}
-		/* The second termination condition only applies for REPE
-		 * and REPNE. Test if the repeat string operation prefix is
-		 * REPE/REPZ or REPNE/REPNZ and if it's the case it tests the
-		 * corresponding termination condition according to:
-		 * 	- if REPE/REPZ and ZF = 0 then done
-		 * 	- if REPNE/REPNZ and ZF = 1 then done
-		 */
-		if ((c->b == 0xa6) || (c->b == 0xa7) ||
-				(c->b == 0xae) || (c->b == 0xaf)) {
-			if ((c->rep_prefix == REPE_PREFIX) &&
-				((ctxt->eflags & EFLG_ZF) == 0)) {
-					ctxt->vcpu->rip = c->eip;
-					goto done;
-			}
-			if ((c->rep_prefix == REPNE_PREFIX) &&
-				((ctxt->eflags & EFLG_ZF) == EFLG_ZF)) {
-				ctxt->vcpu->rip = c->eip;
-				goto done;
-			}
-		}
-		c->regs[VCPU_REGS_RCX]--;
-		c->eip = ctxt->vcpu->rip;
-	}
 	switch (c->b) {
 	case 0xa4 ... 0xa5:	/* movs */
 		c->dst.type = OP_MEM;
-- 
1.5.3.7


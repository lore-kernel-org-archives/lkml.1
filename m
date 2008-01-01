Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYAAPlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYAAPlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYAAPge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:34 -0500
Received: from il.qumranet.com ([82.166.9.18]:33796 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbYAAPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:25 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 13/54] KVM: x86 emulator: Rename 'cr2' to 'memop'
Date: Tue,  1 Jan 2008 17:35:39 +0200
Message-Id: <1199201780-14001-14-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

Previous patches have removed the dependency on cr2; we can now stop passing
it to the emulator and rename uses to 'memop'.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86.c         |    1 -
 drivers/kvm/x86_emulate.c |   18 +++++++++---------
 drivers/kvm/x86_emulate.h |    1 -
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 5e58156..12f1d6f 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1702,7 +1702,6 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 
 		vcpu->emulate_ctxt.vcpu = vcpu;
 		vcpu->emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
-		vcpu->emulate_ctxt.cr2 = cr2;
 		vcpu->emulate_ctxt.mode =
 			(vcpu->emulate_ctxt.eflags & X86_EFLAGS_VM)
 			? X86EMUL_MODE_REAL : cs_l
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 3be506a..22fdf0a 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1127,13 +1127,13 @@ static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 
 static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
 			       struct x86_emulate_ops *ops,
-			       unsigned long cr2)
+			       unsigned long memop)
 {
 	struct decode_cache *c = &ctxt->decode;
 	u64 old, new;
 	int rc;
 
-	rc = ops->read_emulated(cr2, &old, 8, ctxt->vcpu);
+	rc = ops->read_emulated(memop, &old, 8, ctxt->vcpu);
 	if (rc != 0)
 		return rc;
 
@@ -1148,7 +1148,7 @@ static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
 		new = ((u64)c->regs[VCPU_REGS_RCX] << 32) |
 		       (u32) c->regs[VCPU_REGS_RBX];
 
-		rc = ops->cmpxchg_emulated(cr2, &old, &new, 8, ctxt->vcpu);
+		rc = ops->cmpxchg_emulated(memop, &old, &new, 8, ctxt->vcpu);
 		if (rc != 0)
 			return rc;
 		ctxt->eflags |= EFLG_ZF;
@@ -1211,7 +1211,7 @@ static inline int writeback(struct x86_emulate_ctxt *ctxt,
 int
 x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
-	unsigned long cr2 = ctxt->cr2;
+	unsigned long memop = 0;
 	u64 msr_data;
 	unsigned long saved_eip = 0;
 	struct decode_cache *c = &ctxt->decode;
@@ -1226,10 +1226,10 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	saved_eip = c->eip;
 
 	if (((c->d & ModRM) && (c->modrm_mod != 3)) || (c->d & MemAbs))
-		cr2 = c->modrm_ea;
+		memop = c->modrm_ea;
 
 	if (c->src.type == OP_MEM) {
-		c->src.ptr = (unsigned long *)cr2;
+		c->src.ptr = (unsigned long *)memop;
 		c->src.val = 0;
 		rc = ops->read_emulated((unsigned long)c->src.ptr,
 					&c->src.val,
@@ -1245,7 +1245,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 
 
 	if (c->dst.type == OP_MEM) {
-		c->dst.ptr = (unsigned long *)cr2;
+		c->dst.ptr = (unsigned long *)memop;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.val = 0;
 		if (c->d & BitOp) {
@@ -1677,7 +1677,7 @@ twobyte_insn:
 						  &ctxt->eflags);
 			break;
 		case 7: /* invlpg*/
-			emulate_invlpg(ctxt->vcpu, cr2);
+			emulate_invlpg(ctxt->vcpu, memop);
 			break;
 		default:
 			goto cannot_emulate;
@@ -1848,7 +1848,7 @@ twobyte_special_insn:
 		break;
 	}
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
-		rc = emulate_grp9(ctxt, ops, cr2);
+		rc = emulate_grp9(ctxt, ops, memop);
 		if (rc != 0)
 			goto done;
 		break;
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index 644086e..7db91b9 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -145,7 +145,6 @@ struct x86_emulate_ctxt {
 
 	/* Linear faulting address (if emulating a page-faulting instruction). */
 	unsigned long eflags;
-	unsigned long cr2;
 
 	/* Emulated execution mode, represented by an X86EMUL_MODE value. */
 	int mode;
-- 
1.5.3.7


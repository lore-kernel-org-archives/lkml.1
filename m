Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab0BPKmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:42:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932790Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/38] KVM: x86: Use macros for x86_emulate_ops to avoid future mistakes
Date: Tue, 16 Feb 2010 12:35:03 +0200
Message-Id: <1266316536-28936-6-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

The return values from x86_emulate_ops are defined
in kvm_emulate.h as macros X86EMUL_*.

But in emulate.c, we are comparing the return values
from these ops with 0 to check if they're X86EMUL_CONTINUE
or not: X86EMUL_CONTINUE is defined as 0 now.

To avoid possible mistakes in the future, this patch
substitutes "X86EMUL_CONTINUE" for "0" that are being
compared with the return values from x86_emulate_ops.

  We think that there are more places we should use these
  macros, but the meanings of rc values in x86_emulate_insn()
  were not so clear at a glance. If we use proper macros in
  this function, we would be able to follow the flow of each
  emulation more easily and, maybe, more securely.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/emulate.c |   65 ++++++++++++++++++++++++++---------------------
 1 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0f89e32..48c7f9f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1196,7 +1196,7 @@ static int emulate_pop(struct x86_emulate_ctxt *ctxt,
 	rc = ops->read_emulated(register_address(c, ss_base(ctxt),
 						 c->regs[VCPU_REGS_RSP]),
 				dest, len, ctxt->vcpu);
-	if (rc != 0)
+	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
 	register_address_increment(c, &c->regs[VCPU_REGS_RSP], len);
@@ -1370,7 +1370,7 @@ static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
 	int rc;
 
 	rc = ops->read_emulated(memop, &old, 8, ctxt->vcpu);
-	if (rc != 0)
+	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
 	if (((u32) (old >> 0) != (u32) c->regs[VCPU_REGS_RAX]) ||
@@ -1385,7 +1385,7 @@ static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
 		       (u32) c->regs[VCPU_REGS_RBX];
 
 		rc = ops->cmpxchg_emulated(memop, &old, &new, 8, ctxt->vcpu);
-		if (rc != 0)
+		if (rc != X86EMUL_CONTINUE)
 			return rc;
 		ctxt->eflags |= EFLG_ZF;
 	}
@@ -1451,7 +1451,7 @@ static inline int writeback(struct x86_emulate_ctxt *ctxt,
 					&c->dst.val,
 					c->dst.bytes,
 					ctxt->vcpu);
-		if (rc != 0)
+		if (rc != X86EMUL_CONTINUE)
 			return rc;
 		break;
 	case OP_NONE:
@@ -1749,7 +1749,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 					&c->src.val,
 					c->src.bytes,
 					ctxt->vcpu);
-		if (rc != 0)
+		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		c->src.orig_val = c->src.val;
 	}
@@ -1768,12 +1768,15 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 			c->dst.ptr = (void *)c->dst.ptr +
 						   (c->src.val & mask) / 8;
 		}
-		if (!(c->d & Mov) &&
-				   /* optimisation - avoid slow emulated read */
-		    ((rc = ops->read_emulated((unsigned long)c->dst.ptr,
-					   &c->dst.val,
-					  c->dst.bytes, ctxt->vcpu)) != 0))
-			goto done;
+		if (!(c->d & Mov)) {
+			/* optimisation - avoid slow emulated read */
+			rc = ops->read_emulated((unsigned long)c->dst.ptr,
+						&c->dst.val,
+						c->dst.bytes,
+						ctxt->vcpu);
+			if (rc != X86EMUL_CONTINUE)
+				goto done;
+		}
 	}
 	c->dst.orig_val = c->dst.val;
 
@@ -2039,11 +2042,12 @@ special_insn:
 		c->dst.ptr = (unsigned long *)register_address(c,
 						   es_base(ctxt),
 						   c->regs[VCPU_REGS_RDI]);
-		if ((rc = ops->read_emulated(register_address(c,
-					   seg_override_base(ctxt, c),
-					c->regs[VCPU_REGS_RSI]),
+		rc = ops->read_emulated(register_address(c,
+						seg_override_base(ctxt, c),
+						c->regs[VCPU_REGS_RSI]),
 					&c->dst.val,
-					c->dst.bytes, ctxt->vcpu)) != 0)
+					c->dst.bytes, ctxt->vcpu);
+		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		register_address_increment(c, &c->regs[VCPU_REGS_RSI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
@@ -2058,10 +2062,11 @@ special_insn:
 		c->src.ptr = (unsigned long *)register_address(c,
 				       seg_override_base(ctxt, c),
 						   c->regs[VCPU_REGS_RSI]);
-		if ((rc = ops->read_emulated((unsigned long)c->src.ptr,
-						&c->src.val,
-						c->src.bytes,
-						ctxt->vcpu)) != 0)
+		rc = ops->read_emulated((unsigned long)c->src.ptr,
+					&c->src.val,
+					c->src.bytes,
+					ctxt->vcpu);
+		if (rc != X86EMUL_CONTINUE)
 			goto done;
 
 		c->dst.type = OP_NONE; /* Disable writeback. */
@@ -2069,10 +2074,11 @@ special_insn:
 		c->dst.ptr = (unsigned long *)register_address(c,
 						   es_base(ctxt),
 						   c->regs[VCPU_REGS_RDI]);
-		if ((rc = ops->read_emulated((unsigned long)c->dst.ptr,
-						&c->dst.val,
-						c->dst.bytes,
-						ctxt->vcpu)) != 0)
+		rc = ops->read_emulated((unsigned long)c->dst.ptr,
+					&c->dst.val,
+					c->dst.bytes,
+					ctxt->vcpu);
+		if (rc != X86EMUL_CONTINUE)
 			goto done;
 
 		DPRINTF("cmps: mem1=0x%p mem2=0x%p\n", c->src.ptr, c->dst.ptr);
@@ -2102,12 +2108,13 @@ special_insn:
 		c->dst.type = OP_REG;
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
-		if ((rc = ops->read_emulated(register_address(c,
-						 seg_override_base(ctxt, c),
-						 c->regs[VCPU_REGS_RSI]),
-						 &c->dst.val,
-						 c->dst.bytes,
-						 ctxt->vcpu)) != 0)
+		rc = ops->read_emulated(register_address(c,
+						seg_override_base(ctxt, c),
+						c->regs[VCPU_REGS_RSI]),
+					&c->dst.val,
+					c->dst.bytes,
+					ctxt->vcpu);
+		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		register_address_increment(c, &c->regs[VCPU_REGS_RSI],
 				       (ctxt->eflags & EFLG_DF) ? -c->dst.bytes
-- 
1.6.5.3


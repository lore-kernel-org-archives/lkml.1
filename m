Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab0BQNp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:45:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934194Ab0BQNpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/20] KVM: x86 emulator: Fix popf emulation
Date: Wed, 17 Feb 2010 15:45:25 +0200
Message-Id: <1266414330-27444-16-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

POPF behaves differently depending on current CPU mode. Emulate correct
logic to prevent guest from changing flags that it can't change otherwise.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 296e851..1782387 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -343,11 +343,18 @@ static u32 group2_table[] = {
 };
 
 /* EFLAGS bit definitions. */
+#define EFLG_ID (1<<21)
+#define EFLG_VIP (1<<20)
+#define EFLG_VIF (1<<19)
+#define EFLG_AC (1<<18)
 #define EFLG_VM (1<<17)
 #define EFLG_RF (1<<16)
+#define EFLG_IOPL (3<<12)
+#define EFLG_NT (1<<14)
 #define EFLG_OF (1<<11)
 #define EFLG_DF (1<<10)
 #define EFLG_IF (1<<9)
+#define EFLG_TF (1<<8)
 #define EFLG_SF (1<<7)
 #define EFLG_ZF (1<<6)
 #define EFLG_AF (1<<4)
@@ -1214,6 +1221,49 @@ static int emulate_pop(struct x86_emulate_ctxt *ctxt,
 	return rc;
 }
 
+static int emulate_popf(struct x86_emulate_ctxt *ctxt,
+		       struct x86_emulate_ops *ops,
+		       void *dest, int len)
+{
+	int rc;
+	unsigned long val, change_mask;
+	int iopl = (ctxt->eflags & X86_EFLAGS_IOPL) >> IOPL_SHIFT;
+	int cpl = kvm_x86_ops->get_cpl(ctxt->vcpu);
+
+	rc = emulate_pop(ctxt, ops, &val, len);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	change_mask = EFLG_CF | EFLG_PF | EFLG_AF | EFLG_ZF | EFLG_SF | EFLG_OF
+		| EFLG_TF | EFLG_DF | EFLG_NT | EFLG_RF | EFLG_AC | EFLG_ID;
+
+	switch(ctxt->mode) {
+	case X86EMUL_MODE_PROT64:
+	case X86EMUL_MODE_PROT32:
+	case X86EMUL_MODE_PROT16:
+		if (cpl == 0)
+			change_mask |= EFLG_IOPL;
+		if (cpl <= iopl)
+			change_mask |= EFLG_IF;
+		break;
+	case X86EMUL_MODE_VM86:
+		if (iopl < 3) {
+			kvm_inject_gp(ctxt->vcpu, 0);
+			return X86EMUL_PROPAGATE_FAULT;
+		}
+		change_mask |= EFLG_IF;
+		break;
+	default: /* real mode */
+		change_mask |= (EFLG_IOPL | EFLG_IF);
+		break;
+	}
+
+	*(unsigned long *)dest =
+		(ctxt->eflags & ~change_mask) | (val & change_mask);
+
+	return rc;
+}
+
 static void emulate_push_sreg(struct x86_emulate_ctxt *ctxt, int seg)
 {
 	struct decode_cache *c = &ctxt->decode;
@@ -2099,7 +2149,10 @@ special_insn:
 		c->dst.type = OP_REG;
 		c->dst.ptr = (unsigned long *) &ctxt->eflags;
 		c->dst.bytes = c->op_bytes;
-		goto pop_instruction;
+		rc = emulate_popf(ctxt, ops, &c->dst.val, c->op_bytes);
+		if (rc != X86EMUL_CONTINUE)
+			goto done;
+		break;
 	case 0xa0 ... 0xa1:	/* mov */
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
 		c->dst.val = c->src.val;
-- 
1.6.5.3


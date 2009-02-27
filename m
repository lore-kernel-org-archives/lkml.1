Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbZB0Kbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbZB0Kbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZB0K1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53571 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbZB0K1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/37] KVM: x86 emulator: Make emulate_pop() a little more generic
Date: Fri, 27 Feb 2009 12:26:38 +0200
Message-Id: <1235730420-7929-16-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow emulate_pop() to read into arbitrary memory rather than just the
source operand.  Needed for complicated instructions like far returns.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 54fb098..94459f3 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1136,18 +1136,19 @@ static inline void emulate_push(struct x86_emulate_ctxt *ctxt)
 }
 
 static int emulate_pop(struct x86_emulate_ctxt *ctxt,
-		       struct x86_emulate_ops *ops)
+		       struct x86_emulate_ops *ops,
+		       void *dest, int len)
 {
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
 	rc = ops->read_emulated(register_address(c, ss_base(ctxt),
 						 c->regs[VCPU_REGS_RSP]),
-				&c->src.val, c->src.bytes, ctxt->vcpu);
+				dest, len, ctxt->vcpu);
 	if (rc != 0)
 		return rc;
 
-	register_address_increment(c, &c->regs[VCPU_REGS_RSP], c->src.bytes);
+	register_address_increment(c, &c->regs[VCPU_REGS_RSP], len);
 	return rc;
 }
 
@@ -1157,11 +1158,9 @@ static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
-	c->src.bytes = c->dst.bytes;
-	rc = emulate_pop(ctxt, ops);
+	rc = emulate_pop(ctxt, ops, &c->dst.val, c->dst.bytes);
 	if (rc != 0)
 		return rc;
-	c->dst.val = c->src.val;
 	return 0;
 }
 
@@ -1467,11 +1466,9 @@ special_insn:
 		break;
 	case 0x58 ... 0x5f: /* pop reg */
 	pop_instruction:
-		c->src.bytes = c->op_bytes;
-		rc = emulate_pop(ctxt, ops);
+		rc = emulate_pop(ctxt, ops, &c->dst.val, c->op_bytes);
 		if (rc != 0)
 			goto done;
-		c->dst.val = c->src.val;
 		break;
 	case 0x63:		/* movsxd */
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
-- 
1.6.0.6


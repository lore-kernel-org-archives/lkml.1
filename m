Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZB0Kba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZB0Kba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbZB0K1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53572 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbZB0K1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/37] KVM: x86 emulator: implement 'ret far' instruction (opcode 0xcb)
Date: Fri, 27 Feb 2009 12:26:40 +0200
Message-Id: <1235730420-7929-18-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 94459f3..ca91749 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -178,7 +178,7 @@ static u32 opcode_table[256] = {
 	0, ImplicitOps | Stack, 0, 0,
 	ByteOp | DstMem | SrcImm | ModRM | Mov, DstMem | SrcImm | ModRM | Mov,
 	/* 0xC8 - 0xCF */
-	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, ImplicitOps | Stack, 0, 0, 0, 0,
 	/* 0xD0 - 0xD7 */
 	ByteOp | DstMem | SrcImplicit | ModRM, DstMem | SrcImplicit | ModRM,
 	ByteOp | DstMem | SrcImplicit | ModRM, DstMem | SrcImplicit | ModRM,
@@ -1278,6 +1278,25 @@ static inline int emulate_grp9(struct x86_emulate_ctxt *ctxt,
 	return 0;
 }
 
+static int emulate_ret_far(struct x86_emulate_ctxt *ctxt,
+			   struct x86_emulate_ops *ops)
+{
+	struct decode_cache *c = &ctxt->decode;
+	int rc;
+	unsigned long cs;
+
+	rc = emulate_pop(ctxt, ops, &c->eip, c->op_bytes);
+	if (rc)
+		return rc;
+	if (c->op_bytes == 4)
+		c->eip = (u32)c->eip;
+	rc = emulate_pop(ctxt, ops, &cs, c->op_bytes);
+	if (rc)
+		return rc;
+	rc = kvm_load_segment_descriptor(ctxt->vcpu, (u16)cs, 1, VCPU_SREG_CS);
+	return rc;
+}
+
 static inline int writeback(struct x86_emulate_ctxt *ctxt,
 			    struct x86_emulate_ops *ops)
 {
@@ -1735,6 +1754,11 @@ special_insn:
 	mov:
 		c->dst.val = c->src.val;
 		break;
+	case 0xcb:		/* ret far */
+		rc = emulate_ret_far(ctxt, ops);
+		if (rc)
+			goto done;
+		break;
 	case 0xd0 ... 0xd1:	/* Grp2 */
 		c->src.val = 1;
 		emulate_grp2(ctxt);
-- 
1.6.0.6


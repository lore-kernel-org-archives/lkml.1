Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYLNIJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYLNIJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYLNIHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/36] KVM: x86 emulator: switch 'pop reg' instruction to emulate_pop()
Date: Sun, 14 Dec 2008 10:06:41 +0200
Message-Id: <1229242029-13410-9-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 70242f5..702de98 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1389,14 +1389,11 @@ special_insn:
 		break;
 	case 0x58 ... 0x5f: /* pop reg */
 	pop_instruction:
-		if ((rc = ops->read_std(register_address(c, ss_base(ctxt),
-			c->regs[VCPU_REGS_RSP]), c->dst.ptr,
-			c->op_bytes, ctxt->vcpu)) != 0)
+		c->src.bytes = c->op_bytes;
+		rc = emulate_pop(ctxt, ops);
+		if (rc != 0)
 			goto done;
-
-		register_address_increment(c, &c->regs[VCPU_REGS_RSP],
-					   c->op_bytes);
-		c->dst.type = OP_NONE;	/* Disable writeback. */
+		c->dst.val = c->src.val;
 		break;
 	case 0x63:		/* movsxd */
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
-- 
1.6.0.3


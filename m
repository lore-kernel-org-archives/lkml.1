Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYI1Pri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYI1Pri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYI1Pp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbYI1PpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:17 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 07/25] KVM: x86 emulator: Add call near absolute instruction (opcode 0xff/2)
Date: Sun, 28 Sep 2008 18:44:43 +0300
Message-Id: <1222616701-1206-8-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

Add call near absolute instruction.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 3ac2f14..0630d21 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -286,7 +286,8 @@ static u16 group_table[] = {
 	ByteOp | DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
 	0, 0, 0, 0, 0, 0,
 	[Group5*8] =
-	DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM, 0, 0,
+	DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
+	SrcMem | ModRM | Stack, 0,
 	SrcMem | ModRM, 0, SrcMem | ModRM | Stack, 0,
 	[Group7*8] =
 	0, 0, ModRM | SrcMem, ModRM | SrcMem,
@@ -1162,6 +1163,14 @@ static inline int emulate_grp45(struct x86_emulate_ctxt *ctxt,
 	case 1:	/* dec */
 		emulate_1op("dec", c->dst, ctxt->eflags);
 		break;
+	case 2: /* call near abs */ {
+		long int old_eip;
+		old_eip = c->eip;
+		c->eip = c->src.val;
+		c->src.val = old_eip;
+		emulate_push(ctxt);
+		break;
+	}
 	case 4: /* jmp abs */
 		c->eip = c->src.val;
 		break;
-- 
1.6.0.1


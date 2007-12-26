Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbXLZLMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbXLZLMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXLZLGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:36 -0500
Received: from il.qumranet.com ([82.166.9.18]:50473 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbXLZLGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 29/55] KVM: Simplify decode_register_operand() calling convention
Date: Wed, 26 Dec 2007 13:05:34 +0200
Message-Id: <1198667160-22953-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that rex_prefix is part of the decode cache, there is no need to pass
it along.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 884e4a2..b352a6c 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -518,10 +518,10 @@ static int test_cc(unsigned int condition, unsigned int flags)
 
 static void decode_register_operand(struct operand *op,
 				    struct decode_cache *c,
-				    int highbyte_regs,
 				    int inhibit_bytereg)
 {
 	unsigned reg = c->modrm_reg;
+	int highbyte_regs = c->rex_prefix == 0;
 
 	if (!(c->d & ModRM))
 		reg = (c->b & 7) | ((c->rex_prefix & 1) << 3);
@@ -837,7 +837,7 @@ modrm_done:
 	case SrcNone:
 		break;
 	case SrcReg:
-		decode_register_operand(&c->src, c, c->rex_prefix == 0, 0);
+		decode_register_operand(&c->src, c, 0);
 		break;
 	case SrcMem16:
 		c->src.bytes = 2;
@@ -895,7 +895,7 @@ modrm_done:
 		/* Special instructions do their own operand decoding. */
 		return 0;
 	case DstReg:
-		decode_register_operand(&c->dst, c, c->rex_prefix == 0,
+		decode_register_operand(&c->dst, c,
 			 c->twobyte && (c->b == 0xb6 || c->b == 0xb7));
 		break;
 	case DstMem:
-- 
1.5.3.7


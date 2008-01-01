Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYAAPjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYAAPjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbYAAPga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:30 -0500
Received: from il.qumranet.com ([82.166.9.18]:33791 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbYAAPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:24 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 10/54] KVM: x86 emulator: address size and operand size overrides are sticky
Date: Tue,  1 Jan 2008 17:35:36 +0200
Message-Id: <1199201780-14001-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation is to toggle, which is incorrect.  Patch ported from
corresponding Xen code.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 9f8d59a..3be506a 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -758,6 +758,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	struct decode_cache *c = &ctxt->decode;
 	int rc = 0;
 	int mode = ctxt->mode;
+	int def_op_bytes, def_ad_bytes;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
 
@@ -768,34 +769,38 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
 	case X86EMUL_MODE_PROT16:
-		c->op_bytes = c->ad_bytes = 2;
+		def_op_bytes = def_ad_bytes = 2;
 		break;
 	case X86EMUL_MODE_PROT32:
-		c->op_bytes = c->ad_bytes = 4;
+		def_op_bytes = def_ad_bytes = 4;
 		break;
 #ifdef CONFIG_X86_64
 	case X86EMUL_MODE_PROT64:
-		c->op_bytes = 4;
-		c->ad_bytes = 8;
+		def_op_bytes = 4;
+		def_ad_bytes = 8;
 		break;
 #endif
 	default:
 		return -1;
 	}
 
+	c->op_bytes = def_op_bytes;
+	c->ad_bytes = def_ad_bytes;
+
 	/* Legacy prefixes. */
 	for (;;) {
 		switch (c->b = insn_fetch(u8, 1, c->eip)) {
 		case 0x66:	/* operand-size override */
-			c->op_bytes ^= 6;	/* switch between 2/4 bytes */
+			/* switch between 2/4 bytes */
+			c->op_bytes = def_op_bytes ^ 6;
 			break;
 		case 0x67:	/* address-size override */
 			if (mode == X86EMUL_MODE_PROT64)
 				/* switch between 4/8 bytes */
-				c->ad_bytes ^= 12;
+				c->ad_bytes = def_ad_bytes ^ 12;
 			else
 				/* switch between 2/4 bytes */
-				c->ad_bytes ^= 6;
+				c->ad_bytes = def_ad_bytes ^ 6;
 			break;
 		case 0x2e:	/* CS override */
 			c->override_base = &ctxt->cs_base;
-- 
1.5.3.7


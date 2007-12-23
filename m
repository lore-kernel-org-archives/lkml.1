Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbXLWO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbXLWO4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbXLWOvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:35897 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbXLWOvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 17/50] KVM: x86 emulator: Any legacy prefix after a REX prefix nullifies its effect
Date: Sun, 23 Dec 2007 16:51:02 +0200
Message-Id: <1198421495-31481-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch modifies the management of REX prefix according behavior
I saw in Xen 3.1.  In Xen, this modification has been introduced by
Jan Beulich.

http://lists.xensource.com/archives/html/xen-changelog/2007-01/msg00081.html

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index fe50317..e6b213b 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -521,7 +521,6 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
 	u8 sib, rex_prefix = 0;
-	unsigned int i;
 	int rc = 0;
 	int mode = ctxt->mode;
 	int index_reg = 0, base_reg = 0, scale, rip_relative = 0;
@@ -551,7 +550,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	}
 
 	/* Legacy prefixes. */
-	for (i = 0; i < 8; i++) {
+	for (;;) {
 		switch (c->b = insn_fetch(u8, 1, c->eip)) {
 		case 0x66:	/* operand-size override */
 			c->op_bytes ^= 6;	/* switch between 2/4 bytes */
@@ -582,6 +581,11 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		case 0x36:	/* SS override */
 			c->override_base = &ctxt->ss_base;
 			break;
+		case 0x40 ... 0x4f: /* REX */
+			if (mode != X86EMUL_MODE_PROT64)
+				goto done_prefixes;
+			rex_prefix = c->b;
+			continue;
 		case 0xf0:	/* LOCK */
 			c->lock_prefix = 1;
 			break;
@@ -592,19 +596,21 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 		default:
 			goto done_prefixes;
 		}
+
+		/* Any legacy prefix after a REX prefix nullifies its effect. */
+
+		rex_prefix = 0;
 	}
 
 done_prefixes:
 
 	/* REX prefix. */
-	if ((mode == X86EMUL_MODE_PROT64) && ((c->b & 0xf0) == 0x40)) {
-		rex_prefix = c->b;
-		if (c->b & 8)
+	if (rex_prefix) {
+		if (rex_prefix & 8)
 			c->op_bytes = 8;	/* REX.W */
-		c->modrm_reg = (c->b & 4) << 1;	/* REX.R */
-		index_reg = (c->b & 2) << 2; /* REX.X */
-		c->modrm_rm = base_reg = (c->b & 1) << 3; /* REG.B */
-		c->b = insn_fetch(u8, 1, c->eip);
+		c->modrm_reg = (rex_prefix & 4) << 1;	/* REX.R */
+		index_reg = (rex_prefix & 2) << 2; /* REX.X */
+		c->modrm_rm = base_reg = (rex_prefix & 1) << 3; /* REG.B */
 	}
 
 	/* Opcode byte(s). */
-- 
1.5.3.7


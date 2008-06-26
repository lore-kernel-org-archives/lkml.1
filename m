Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYFZMiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYFZMiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYFZM3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:19 -0400
Received: from il.qumranet.com ([212.179.150.194]:32384 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYFZM2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 45/50] KVM: x86 emulator: simplify r/m decoding
Date: Thu, 26 Jun 2008 15:28:27 +0300
Message-Id: <1214483312-9265-46-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the duplicated code when not in any special case.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index ca7ab24..c3a8231 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -740,9 +740,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		c->modrm_ea = (u16)c->modrm_ea;
 	} else {
 		/* 32/64-bit ModR/M decode. */
-		switch (c->modrm_rm) {
-		case 4:
-		case 12:
+		if ((c->modrm_rm & 7) == 4) {
 			sib = insn_fetch(u8, 1, c->eip);
 			index_reg |= (sib >> 3) & 7;
 			base_reg |= sib & 7;
@@ -754,18 +752,11 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 				c->modrm_ea += c->regs[base_reg];
 			if (index_reg != 4)
 				c->modrm_ea += c->regs[index_reg] << scale;
-			break;
-		case 5:
-		case 13:
-			if (c->modrm_mod != 0)
-				c->modrm_ea += c->regs[c->modrm_rm];
-			else if (ctxt->mode == X86EMUL_MODE_PROT64)
+		} else if ((c->modrm_rm & 7) == 5 && c->modrm_mod == 0) {
+			if (ctxt->mode == X86EMUL_MODE_PROT64)
 				rip_relative = 1;
-			break;
-		default:
+		} else
 			c->modrm_ea += c->regs[c->modrm_rm];
-			break;
-		}
 		switch (c->modrm_mod) {
 		case 0:
 			if (c->modrm_rm == 5)
-- 
1.5.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbYFZMhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbYFZMhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbYFZM3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:21 -0400
Received: from il.qumranet.com ([212.179.150.194]:32385 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbYFZM2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 44/50] KVM: x86 emulator: simplify sib decoding
Date: Thu, 26 Jun 2008 15:28:26 +0300
Message-Id: <1214483312-9265-45-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using sparse switches, use simpler if/else sequences.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 3721cfd..ca7ab24 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -748,24 +748,12 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 			base_reg |= sib & 7;
 			scale = sib >> 6;
 
-			switch (base_reg) {
-			case 5:
-			case 13:
-				if (c->modrm_mod != 0)
-					c->modrm_ea += c->regs[base_reg];
-				else
-					c->modrm_ea +=
-						insn_fetch(s32, 4, c->eip);
-				break;
-			default:
+			if ((base_reg & 7) == 5 && c->modrm_mod == 0)
+				c->modrm_ea += insn_fetch(s32, 4, c->eip);
+			else
 				c->modrm_ea += c->regs[base_reg];
-			}
-			switch (index_reg) {
-			case 4:
-				break;
-			default:
+			if (index_reg != 4)
 				c->modrm_ea += c->regs[index_reg] << scale;
-			}
 			break;
 		case 5:
 		case 13:
-- 
1.5.6


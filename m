Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYFZMh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYFZMh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYFZM3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:18 -0400
Received: from il.qumranet.com ([212.179.150.194]:32363 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbYFZM2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 46/50] KVM: x86 emulator: simplify rip relative decoding
Date: Thu, 26 Jun 2008 15:28:28 +0300
Message-Id: <1214483312-9265-47-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rip relative decoding is relative to the instruction pointer of the next
instruction; by moving address adjustment until after decoding is complete,
we remove the need to determine the instruction size.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c        |   23 +++++------------------
 include/asm-x86/kvm_x86_emulate.h |    1 +
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index c3a8231..20b6044 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -664,7 +664,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 {
 	struct decode_cache *c = &ctxt->decode;
 	u8 sib;
-	int index_reg = 0, base_reg = 0, scale, rip_relative = 0;
+	int index_reg = 0, base_reg = 0, scale;
 	int rc = 0;
 
 	if (c->rex_prefix) {
@@ -754,7 +754,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 				c->modrm_ea += c->regs[index_reg] << scale;
 		} else if ((c->modrm_rm & 7) == 5 && c->modrm_mod == 0) {
 			if (ctxt->mode == X86EMUL_MODE_PROT64)
-				rip_relative = 1;
+				c->rip_relative = 1;
 		} else
 			c->modrm_ea += c->regs[c->modrm_rm];
 		switch (c->modrm_mod) {
@@ -770,22 +770,6 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 			break;
 		}
 	}
-	if (rip_relative) {
-		c->modrm_ea += c->eip;
-		switch (c->d & SrcMask) {
-		case SrcImmByte:
-			c->modrm_ea += 1;
-			break;
-		case SrcImm:
-			if (c->d & ByteOp)
-				c->modrm_ea += 1;
-			else
-				if (c->op_bytes == 8)
-					c->modrm_ea += 4;
-				else
-					c->modrm_ea += c->op_bytes;
-		}
-	}
 done:
 	return rc;
 }
@@ -1044,6 +1028,9 @@ done_prefixes:
 		break;
 	}
 
+	if (c->rip_relative)
+		c->modrm_ea += c->eip;
+
 done:
 	return (rc == X86EMUL_UNHANDLEABLE) ? -1 : 0;
 }
diff --git a/include/asm-x86/kvm_x86_emulate.h b/include/asm-x86/kvm_x86_emulate.h
index b877bbd..9fda4b3 100644
--- a/include/asm-x86/kvm_x86_emulate.h
+++ b/include/asm-x86/kvm_x86_emulate.h
@@ -134,6 +134,7 @@ struct decode_cache {
 	u8 modrm_reg;
 	u8 modrm_rm;
 	u8 use_modrm_ea;
+	bool rip_relative;
 	unsigned long modrm_ea;
 	void *modrm_ptr;
 	unsigned long modrm_val;
-- 
1.5.6


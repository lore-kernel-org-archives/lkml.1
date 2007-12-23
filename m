Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbXLWOxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbXLWOxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbXLWOvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:45 -0500
Received: from il.qumranet.com ([82.166.9.18]:35893 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXLWOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:39 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 06/50] KVM: emulate_instruction() calls now x86_decode_insn() and x86_emulate_insn()
Date: Sun, 23 Dec 2007 16:50:51 +0200
Message-Id: <1198421495-31481-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

emulate_instruction() calls now x86_decode_insn() and x86_emulate_insn().
x86_emulate_insn() is x86_emulate_memop() without the decoding part.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c    |    5 ++++-
 drivers/kvm/x86_emulate.c |    8 ++------
 drivers/kvm/x86_emulate.h |   11 ++++-------
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9668e9c..39c54d5 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1287,7 +1287,10 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 
 	vcpu->mmio_is_write = 0;
 	vcpu->pio.string = 0;
-	r = x86_emulate_memop(&emulate_ctxt, &emulate_ops);
+	r = x86_decode_insn(&emulate_ctxt, &emulate_ops);
+	if (r == 0)
+		r = x86_emulate_insn(&emulate_ctxt, &emulate_ops);
+
 	if (vcpu->pio.string)
 		return EMULATE_DO_MMIO;
 
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index f20534b..9290083 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -908,18 +908,14 @@ done:
 }
 
 int
-x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
+x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
 	unsigned long cr2 = ctxt->cr2;
 	int no_wb = 0;
 	u64 msr_data;
 	unsigned long _eflags = ctxt->eflags;
 	struct decode_cache *c = &ctxt->decode;
-	int rc;
-
-	rc = x86_decode_insn(ctxt, ops);
-	if (rc)
-		return rc;
+	int rc = 0;
 
 	if ((c->d & ModRM) && (c->modrm_mod != 3))
 		cr2 = c->modrm_ea;
diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index c354200..28acad4 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -178,12 +178,9 @@ struct x86_emulate_ctxt {
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT64
 #endif
 
-/*
- * x86_emulate_memop: Emulate an instruction that faulted attempting to
- *                    read/write a 'special' memory area.
- * Returns -1 on failure, 0 on success.
- */
-int x86_emulate_memop(struct x86_emulate_ctxt *ctxt,
-		      struct x86_emulate_ops *ops);
+int x86_decode_insn(struct x86_emulate_ctxt *ctxt,
+		    struct x86_emulate_ops *ops);
+int x86_emulate_insn(struct x86_emulate_ctxt *ctxt,
+		     struct x86_emulate_ops *ops);
 
 #endif				/* __X86_EMULATE_H__ */
-- 
1.5.3.7


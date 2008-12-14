Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYLNILS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYLNILS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYLNIH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59912 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/36] KVM: x86 emulator: Extract 'pop' sequence into a function
Date: Sun, 14 Dec 2008 10:06:39 +0200
Message-Id: <1229242029-13410-7-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch 'pop r/m' instruction to use the new function.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index a11af6f..2555762 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1057,20 +1057,33 @@ static inline void emulate_push(struct x86_emulate_ctxt *ctxt)
 					       c->regs[VCPU_REGS_RSP]);
 }
 
-static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
-				struct x86_emulate_ops *ops)
+static int emulate_pop(struct x86_emulate_ctxt *ctxt,
+		       struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
 	int rc;
 
 	rc = ops->read_std(register_address(c, ss_base(ctxt),
 					    c->regs[VCPU_REGS_RSP]),
-			   &c->dst.val, c->dst.bytes, ctxt->vcpu);
+			   &c->src.val, c->src.bytes, ctxt->vcpu);
 	if (rc != 0)
 		return rc;
 
-	register_address_increment(c, &c->regs[VCPU_REGS_RSP], c->dst.bytes);
+	register_address_increment(c, &c->regs[VCPU_REGS_RSP], c->src.bytes);
+	return rc;
+}
 
+static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
+				struct x86_emulate_ops *ops)
+{
+	struct decode_cache *c = &ctxt->decode;
+	int rc;
+
+	c->src.bytes = c->dst.bytes;
+	rc = emulate_pop(ctxt, ops);
+	if (rc != 0)
+		return rc;
+	c->dst.val = c->src.val;
 	return 0;
 }
 
-- 
1.6.0.3


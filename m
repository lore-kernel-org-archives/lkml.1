Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbXLWPJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbXLWPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbXLWOwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:37 -0500
Received: from il.qumranet.com ([82.166.9.18]:35915 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbXLWOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 16/50] KVM: Purify x86_decode_insn() error case management
Date: Sun, 23 Dec 2007 16:51:01 +0200
Message-Id: <1198421495-31481-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

The only valid case is on protected page access, other cases are errors.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index b10fd7e..f7566b9 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1251,7 +1251,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 			u16 error_code,
 			int no_decode)
 {
-	int r = 0;
+	int r;
 
 	vcpu->mmio_fault_cr2 = cr2;
 	kvm_x86_ops->cache_regs(vcpu);
@@ -1294,10 +1294,14 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 					get_segment_base(vcpu, VCPU_SREG_FS);
 
 		r = x86_decode_insn(&vcpu->emulate_ctxt, &emulate_ops);
+		if (r)  {
+			if (kvm_mmu_unprotect_page_virt(vcpu, cr2))
+				return EMULATE_DONE;
+			return EMULATE_FAIL;
+		}
 	}
 
-	if (r == 0)
-		r = x86_emulate_insn(&vcpu->emulate_ctxt, &emulate_ops);
+	r = x86_emulate_insn(&vcpu->emulate_ctxt, &emulate_ops);
 
 	if (vcpu->pio.string)
 		return EMULATE_DO_MMIO;
-- 
1.5.3.7


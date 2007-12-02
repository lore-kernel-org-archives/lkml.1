Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbXLBLU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbXLBLU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXLBLSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:18 -0500
Received: from il.qumranet.com ([82.166.9.18]:41440 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXLBLSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:11 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Amit Shah <amit.shah@qumranet.com>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/10] KVM: SVM: Fix FPU leak while emulating clts
Date: Sun,  2 Dec 2007 13:18:44 +0200
Message-Id: <11965943273853-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

The clts code didn't use set_cr0 properly, so our lazy FPU
processing wasn't being done by the clts instruction at all.

(this isn't called on Intel as the hardware does the decode for us)

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index b514dfb..504e81d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1163,10 +1163,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
-	unsigned long cr0;
-
-	cr0 = vcpu->cr0 & ~CR0_TS_MASK;
-	kvm_arch_ops->set_cr0(vcpu, cr0);
+	kvm_arch_ops->set_cr0(vcpu, vcpu->cr0 & ~X86_CR0_TS);
 	return X86EMUL_CONTINUE;
 }
 
-- 
1.5.3


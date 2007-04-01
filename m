Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXDAOfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXDAOfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbXDAOfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:35:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:47528 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbXDAOfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Dor Laor <dor.laor@qumranet.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 01/41] KVM: Fix guest register corruption on paravirt hypercall
Date: Sun,  1 Apr 2007 17:34:58 +0300
Message-Id: <11754381381990-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438138288-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dor Laor <dor.laor@qumranet.com>

The hypercall code mixes up the ->cache_regs() and ->decache_regs()
callbacks, resulting in guest register corruption.

Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index dc7a8c7..ff7c836 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1177,7 +1177,7 @@ int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	unsigned long nr, a0, a1, a2, a3, a4, a5, ret;
 
-	kvm_arch_ops->decache_regs(vcpu);
+	kvm_arch_ops->cache_regs(vcpu);
 	ret = -KVM_EINVAL;
 #ifdef CONFIG_X86_64
 	if (is_long_mode(vcpu)) {
@@ -1204,7 +1204,7 @@ int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		;
 	}
 	vcpu->regs[VCPU_REGS_RAX] = ret;
-	kvm_arch_ops->cache_regs(vcpu);
+	kvm_arch_ops->decache_regs(vcpu);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(kvm_hypercall);
-- 
1.5.0.5


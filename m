Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXDAOmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXDAOmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXDAOfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:35:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:47532 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106AbXDAOfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Dor Laor <dor.laor@qumranet.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 02/41] KVM: Use the generic skip_emulated_instruction() in hypercall code
Date: Sun,  1 Apr 2007 17:34:59 +0300
Message-Id: <11754381384009-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381381990-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dor Laor <dor.laor@qumranet.com>

Instead of twiddling the rip registers directly, use the
skip_emulated_instruction() function to do that for us.

Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    3 ++-
 drivers/kvm/vmx.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 3d8ea7a..6787f11 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1078,7 +1078,8 @@ static int halt_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int vmmcall_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	vcpu->svm->vmcb->save.rip += 3;
+	vcpu->svm->next_rip = vcpu->svm->vmcb->save.rip + 3;
+	skip_emulated_instruction(vcpu);
 	return kvm_hypercall(vcpu, kvm_run);
 }
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index fbbf9d6..a721b60 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1658,7 +1658,7 @@ static int handle_halt(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static int handle_vmcall(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	vmcs_writel(GUEST_RIP, vmcs_readl(GUEST_RIP)+3);
+	skip_emulated_instruction(vcpu);
 	return kvm_hypercall(vcpu, kvm_run);
 }
 
-- 
1.5.0.5


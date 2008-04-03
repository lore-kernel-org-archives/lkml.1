Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbYDCTf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbYDCTf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbYDCTdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:01 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53025
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbYDCTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 10/35] KVM: Use kzalloc to avoid allocating kvm_regs from kernel stack
Date: Thu,  3 Apr 2008 22:32:25 +0300
Message-Id: <1207251170-5013-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Since the size of kvm_regs is too big to allocate from kernel stack on ia64,
use kzalloc to allocate it.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0dabf58..30bf832 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -849,28 +849,39 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
 		break;
 	case KVM_GET_REGS: {
-		struct kvm_regs kvm_regs;
+		struct kvm_regs *kvm_regs;
 
-		memset(&kvm_regs, 0, sizeof kvm_regs);
-		r = kvm_arch_vcpu_ioctl_get_regs(vcpu, &kvm_regs);
-		if (r)
+		r = -ENOMEM;
+		kvm_regs = kzalloc(sizeof(struct kvm_regs), GFP_KERNEL);
+		if (!kvm_regs)
 			goto out;
+		r = kvm_arch_vcpu_ioctl_get_regs(vcpu, kvm_regs);
+		if (r)
+			goto out_free1;
 		r = -EFAULT;
-		if (copy_to_user(argp, &kvm_regs, sizeof kvm_regs))
-			goto out;
+		if (copy_to_user(argp, kvm_regs, sizeof(struct kvm_regs)))
+			goto out_free1;
 		r = 0;
+out_free1:
+		kfree(kvm_regs);
 		break;
 	}
 	case KVM_SET_REGS: {
-		struct kvm_regs kvm_regs;
+		struct kvm_regs *kvm_regs;
 
-		r = -EFAULT;
-		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
+		r = -ENOMEM;
+		kvm_regs = kzalloc(sizeof(struct kvm_regs), GFP_KERNEL);
+		if (!kvm_regs)
 			goto out;
-		r = kvm_arch_vcpu_ioctl_set_regs(vcpu, &kvm_regs);
+		r = -EFAULT;
+		if (copy_from_user(kvm_regs, argp, sizeof(struct kvm_regs)))
+			goto out_free2;
+		r = kvm_arch_vcpu_ioctl_set_regs(vcpu, kvm_regs);
 		if (r)
-			goto out;
+			goto out_free2;
 		r = 0;
+out_free2:
+		kfree(kvm_regs);
 		break;
 	}
 	case KVM_GET_SREGS: {
-- 
1.5.4.5


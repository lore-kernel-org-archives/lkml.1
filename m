Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYIWN7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYIWN7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYIWNt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:49:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43470 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbYIWNt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:49:56 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 38/40] KVM: Reduce stack usage in kvm_vcpu_ioctl()
Date: Tue, 23 Sep 2008 16:46:52 +0300
Message-Id: <1222177614-26669-39-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |   46 ++++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5eb96c7..0309571 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1126,6 +1126,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r;
+	struct kvm_fpu *fpu = NULL;
+	struct kvm_sregs *kvm_sregs = NULL;
 
 	if (vcpu->kvm->mm != current->mm)
 		return -EIO;
@@ -1173,25 +1175,28 @@ out_free2:
 		break;
 	}
 	case KVM_GET_SREGS: {
-		struct kvm_sregs kvm_sregs;
-
-		memset(&kvm_sregs, 0, sizeof kvm_sregs);
-		r = kvm_arch_vcpu_ioctl_get_sregs(vcpu, &kvm_sregs);
+		kvm_sregs = kzalloc(sizeof(struct kvm_sregs), GFP_KERNEL);
+		r = -ENOMEM;
+		if (!kvm_sregs)
+			goto out;
+		r = kvm_arch_vcpu_ioctl_get_sregs(vcpu, kvm_sregs);
 		if (r)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user(argp, &kvm_sregs, sizeof kvm_sregs))
+		if (copy_to_user(argp, kvm_sregs, sizeof(struct kvm_sregs)))
 			goto out;
 		r = 0;
 		break;
 	}
 	case KVM_SET_SREGS: {
-		struct kvm_sregs kvm_sregs;
-
+		kvm_sregs = kmalloc(sizeof(struct kvm_sregs), GFP_KERNEL);
+		r = -ENOMEM;
+		if (!kvm_sregs)
+			goto out;
 		r = -EFAULT;
-		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
+		if (copy_from_user(kvm_sregs, argp, sizeof(struct kvm_sregs)))
 			goto out;
-		r = kvm_arch_vcpu_ioctl_set_sregs(vcpu, &kvm_sregs);
+		r = kvm_arch_vcpu_ioctl_set_sregs(vcpu, kvm_sregs);
 		if (r)
 			goto out;
 		r = 0;
@@ -1272,25 +1277,28 @@ out_free2:
 		break;
 	}
 	case KVM_GET_FPU: {
-		struct kvm_fpu fpu;
-
-		memset(&fpu, 0, sizeof fpu);
-		r = kvm_arch_vcpu_ioctl_get_fpu(vcpu, &fpu);
+		fpu = kzalloc(sizeof(struct kvm_fpu), GFP_KERNEL);
+		r = -ENOMEM;
+		if (!fpu)
+			goto out;
+		r = kvm_arch_vcpu_ioctl_get_fpu(vcpu, fpu);
 		if (r)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user(argp, &fpu, sizeof fpu))
+		if (copy_to_user(argp, fpu, sizeof(struct kvm_fpu)))
 			goto out;
 		r = 0;
 		break;
 	}
 	case KVM_SET_FPU: {
-		struct kvm_fpu fpu;
-
+		fpu = kmalloc(sizeof(struct kvm_fpu), GFP_KERNEL);
+		r = -ENOMEM;
+		if (!fpu)
+			goto out;
 		r = -EFAULT;
-		if (copy_from_user(&fpu, argp, sizeof fpu))
+		if (copy_from_user(fpu, argp, sizeof(struct kvm_fpu)))
 			goto out;
-		r = kvm_arch_vcpu_ioctl_set_fpu(vcpu, &fpu);
+		r = kvm_arch_vcpu_ioctl_set_fpu(vcpu, fpu);
 		if (r)
 			goto out;
 		r = 0;
@@ -1300,6 +1308,8 @@ out_free2:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
 out:
+	kfree(fpu);
+	kfree(kvm_sregs);
 	return r;
 }
 
-- 
1.6.0.1


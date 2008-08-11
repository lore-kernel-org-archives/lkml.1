Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYHKRCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYHKRCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYHKRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:01:53 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44689 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYHKRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:01:51 -0400
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@argo.co.il>
Cc: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 2/4] reduce stack usage in kvm_vcpu_ioctl()
Date: Mon, 11 Aug 2008 10:01:46 -0700
Message-Id: <1218474106-14711-1-git-send-email-dave@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c1
In-Reply-To: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
References: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same as the last one, but this time we use kmalloc()
for all of the uses.

Note that the kfree()s take advantage of the fact that
kfree() is OK on NULL.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   46 ++++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7dd9b0b..9a19907 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1118,6 +1118,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r;
+	struct kvm_fpu *fpu = NULL;
+	struct kvm_sregs *kvm_sregs = NULL;
 
 	if (vcpu->kvm->mm != current->mm)
 		return -EIO;
@@ -1165,25 +1167,28 @@ out_free2:
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
@@ -1264,25 +1269,28 @@ out_free2:
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
@@ -1292,6 +1300,8 @@ out_free2:
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
 out:
+	kfree(fpu);
+	kfree(kvm_sregs);
 	return r;
 }
 
-- 
1.5.4.3


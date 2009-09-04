Return-Path: <linux-kernel-owner+w=401wt.eu-S934004AbZIDUO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004AbZIDUO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934024AbZIDUO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:26 -0400
Received: from kroah.org ([198.145.64.141]:36151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934003AbZIDUOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:52 2009
Message-Id: <20090904200852.437826917@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 15/48] KVM: Reduce stack usage in kvm_vcpu_ioctl()
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-reduce-stack-usage-in-kvm_vcpu_ioctl.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>

(cherry picked from commit fa3795a7308df099f0f2c9e5ca2c20a5ff65bdc4)

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/kvm_main.c |   46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1118,6 +1118,8 @@ static long kvm_vcpu_ioctl(struct file *
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
 



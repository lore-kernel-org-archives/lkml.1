Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYIWOAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYIWOAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYIWNvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:51:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43530 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbYIWNvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:51:10 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 39/40] KVM: Reduce stack usage in kvm_arch_vcpu_ioctl()
Date: Tue, 23 Sep 2008 16:46:53 +0300
Message-Id: <1222177614-26669-40-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

[sheng: fix KVM_GET_LAPIC using wrong size]

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 87d4342..f1b0223 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1542,28 +1542,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r;
+	struct kvm_lapic_state *lapic = NULL;
 
 	switch (ioctl) {
 	case KVM_GET_LAPIC: {
-		struct kvm_lapic_state lapic;
+		lapic = kzalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
 
-		memset(&lapic, 0, sizeof lapic);
-		r = kvm_vcpu_ioctl_get_lapic(vcpu, &lapic);
+		r = -ENOMEM;
+		if (!lapic)
+			goto out;
+		r = kvm_vcpu_ioctl_get_lapic(vcpu, lapic);
 		if (r)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user(argp, &lapic, sizeof lapic))
+		if (copy_to_user(argp, lapic, sizeof(struct kvm_lapic_state)))
 			goto out;
 		r = 0;
 		break;
 	}
 	case KVM_SET_LAPIC: {
-		struct kvm_lapic_state lapic;
-
+		lapic = kmalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
+		r = -ENOMEM;
+		if (!lapic)
+			goto out;
 		r = -EFAULT;
-		if (copy_from_user(&lapic, argp, sizeof lapic))
+		if (copy_from_user(lapic, argp, sizeof(struct kvm_lapic_state)))
 			goto out;
-		r = kvm_vcpu_ioctl_set_lapic(vcpu, &lapic);;
+		r = kvm_vcpu_ioctl_set_lapic(vcpu, lapic);
 		if (r)
 			goto out;
 		r = 0;
@@ -1661,6 +1666,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 	}
 out:
+	if (lapic)
+		kfree(lapic);
 	return r;
 }
 
-- 
1.6.0.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbYHKRCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbYHKRCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYHKRCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:02:06 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48127 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbYHKRCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:02:05 -0400
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@argo.co.il>
Cc: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 3/4] reduce stack usage in kvm_arch_vcpu_ioctl()
Date: Mon, 11 Aug 2008 10:01:47 -0700
Message-Id: <1218474107-14744-1-git-send-email-dave@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c1
In-Reply-To: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
References: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time it is kvm_arch_vcpu_ioctl().  Use dynamic
allocations to reduce its stack usage.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f5f8bd..fc765d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1303,13 +1303,16 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
@@ -1319,12 +1322,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
@@ -1422,6 +1427,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 	}
 out:
+	kfree(lapic);
 	return r;
 }
 
-- 
1.5.4.3


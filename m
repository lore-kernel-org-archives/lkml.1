Return-Path: <linux-kernel-owner+w=401wt.eu-S934046AbZIDUOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046AbZIDUOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934034AbZIDUO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:28 -0400
Received: from kroah.org ([198.145.64.141]:36154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934004AbZIDUOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:52 2009
Message-Id: <20090904200852.685554919@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sheng Yang <sheng.yang@intel.com>, Avi Kivity <avi@redhat.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Avi Kivity <avi@qumranet.com>
Subject: [patch 16/48] KVM: Reduce stack usage in kvm_arch_vcpu_ioctl()
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-reduce-stack-usage-in-kvm_arch_vcpu_ioctl.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>

(cherry picked from commit b772ff362ec6b821c8a5227a3355e263f917bfad)

[sheng: fix KVM_GET_LAPIC using wrong size]

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1303,28 +1303,33 @@ long kvm_arch_vcpu_ioctl(struct file *fi
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
@@ -1422,6 +1427,8 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = -EINVAL;
 	}
 out:
+	if (lapic)
+		kfree(lapic);
 	return r;
 }
 



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXLZLVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXLZLVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXLZLHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:03 -0500
Received: from il.qumranet.com ([82.166.9.18]:50479 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXLZLGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:12 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 53/55] KVM: Portability: move KVM_CHECK_EXTENSION
Date: Wed, 26 Dec 2007 13:05:58 +0200
Message-Id: <1198667160-22953-54-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Make KVM_CHECK_EXTENSION code into a function, all archs can define its
capability independently.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |   18 ++----------------
 drivers/kvm/x86.c      |   20 ++++++++++++++++++++
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 96d9c7d..a7be073 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -628,6 +628,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
+
+int kvm_dev_ioctl_check_extension(long ext);
+
 int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   struct
 				   kvm_userspace_memory_region *mem,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5d6d5d4..9d63a10 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1198,23 +1198,9 @@ static long kvm_dev_ioctl(struct file *filp,
 			goto out;
 		r = kvm_dev_ioctl_create_vm();
 		break;
-	case KVM_CHECK_EXTENSION: {
-		int ext = (long)argp;
-
-		switch (ext) {
-		case KVM_CAP_IRQCHIP:
-		case KVM_CAP_HLT:
-		case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
-		case KVM_CAP_USER_MEMORY:
-		case KVM_CAP_SET_TSS_ADDR:
-			r = 1;
-			break;
-		default:
-			r = 0;
-			break;
-		}
+	case KVM_CHECK_EXTENSION:
+		r = kvm_dev_ioctl_check_extension((long)argp);
 		break;
-	}
 	case KVM_GET_VCPU_MMAP_SIZE:
 		r = -EINVAL;
 		if (arg)
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index bbfa810..6097926 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -599,6 +599,26 @@ void decache_vcpus_on_cpu(int cpu)
 	spin_unlock(&kvm_lock);
 }
 
+int kvm_dev_ioctl_check_extension(long ext)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_IRQCHIP:
+	case KVM_CAP_HLT:
+	case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
+	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_SET_TSS_ADDR:
+		r = 1;
+		break;
+	default:
+		r = 0;
+		break;
+	}
+	return r;
+
+}
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
-- 
1.5.3.7


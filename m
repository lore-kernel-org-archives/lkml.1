Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbZB0Ke2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbZB0Ke2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbZB0K1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53588 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/37] KVM: Add support to disable MSI for assigned device
Date: Fri, 27 Feb 2009 12:26:44 +0200
Message-Id: <1235730420-7929-22-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

MSI is always enabled by default for msi2intx=1. But if msi2intx=0, we
have to disable MSI if guest require to do so.

The patch also discard unnecessary msi2intx judgment if guest want to update
MSI state.

Notice KVM_DEV_IRQ_ASSIGN_MSI_ACTION is a mask which should cover all MSI
related operations, though we only got one for now.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h |    1 +
 virt/kvm/kvm_main.c |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ae7a12c..73f3480 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -550,6 +550,7 @@ struct kvm_assigned_irq {
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
+#define KVM_DEV_IRQ_ASSIGN_MSI_ACTION	KVM_DEV_IRQ_ASSIGN_ENABLE_MSI
 #define KVM_DEV_IRQ_ASSIGN_ENABLE_MSI	(1 << 0)
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f83ef9c..04401e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -343,6 +343,14 @@ static int assigned_device_update_msi(struct kvm *kvm,
 		adev->irq_requested_type &= ~KVM_ASSIGNED_DEV_GUEST_MSI;
 		adev->guest_irq = airq->guest_irq;
 		adev->ack_notifier.gsi = airq->guest_irq;
+	} else {
+		/*
+		 * Guest require to disable device MSI, we disable MSI and
+		 * re-enable INTx by default again. Notice it's only for
+		 * non-msi2intx.
+		 */
+		assigned_device_update_intx(kvm, adev, airq);
+		return 0;
 	}
 
 	if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)
@@ -379,6 +387,7 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 {
 	int r = 0;
 	struct kvm_assigned_dev_kernel *match;
+	u32 current_flags = 0, changed_flags;
 
 	mutex_lock(&kvm->lock);
 
@@ -416,8 +425,13 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 		}
 	}
 
-	if ((!msi2intx &&
-	     (assigned_irq->flags & KVM_DEV_IRQ_ASSIGN_ENABLE_MSI)) ||
+	if ((match->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI) &&
+		 (match->irq_requested_type & KVM_ASSIGNED_DEV_GUEST_MSI))
+		current_flags |= KVM_DEV_IRQ_ASSIGN_ENABLE_MSI;
+
+	changed_flags = assigned_irq->flags ^ current_flags;
+
+	if ((changed_flags & KVM_DEV_IRQ_ASSIGN_MSI_ACTION) ||
 	    (msi2intx && match->dev->msi_enabled)) {
 #ifdef CONFIG_X86
 		r = assigned_device_update_msi(kvm, match, assigned_irq);
-- 
1.6.0.6


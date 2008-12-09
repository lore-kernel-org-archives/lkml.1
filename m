Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYLIUam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYLIUam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYLIUXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbYLIUXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 42/44] KVM: Enable MSI for device assignment
Date: Tue,  9 Dec 2008 22:22:57 +0200
Message-Id: <1228854179-23002-43-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

We enable guest MSI and host MSI support in this patch. The userspace want to
enable MSI should set KVM_DEV_IRQ_ASSIGN_ENABLE_MSI in the assigned_irq's flag.
Function would return -ENOTTY if can't enable MSI, userspace shouldn't set MSI
Enable bit when KVM_ASSIGN_IRQ return -ENOTTY with
KVM_DEV_IRQ_ASSIGN_ENABLE_MSI.

Userspace can tell the support of MSI device from #ifdef KVM_CAP_DEVICE_MSI.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h |    3 ++
 virt/kvm/kvm_main.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index bb283c3..0997e6f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -392,6 +392,9 @@ struct kvm_trace_rec {
 #endif
 #define KVM_CAP_IOMMU 18
 #define KVM_CAP_NMI 19
+#if defined(CONFIG_X86)
+#define KVM_CAP_DEVICE_MSI 20
+#endif
 
 /*
  * ioctls for VM fds
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 228c1d1..bf36ae9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -159,9 +159,15 @@ static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 	 * finer-grained lock, update this
 	 */
 	mutex_lock(&assigned_dev->kvm->lock);
-	kvm_set_irq(assigned_dev->kvm,
-		    assigned_dev->irq_source_id,
-		    assigned_dev->guest_irq, 1);
+	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_GUEST_INTX)
+		kvm_set_irq(assigned_dev->kvm,
+			    assigned_dev->irq_source_id,
+			    assigned_dev->guest_irq, 1);
+	else if (assigned_dev->irq_requested_type &
+				KVM_ASSIGNED_DEV_GUEST_MSI) {
+		assigned_device_msi_dispatch(assigned_dev);
+		enable_irq(assigned_dev->host_irq);
+	}
 	mutex_unlock(&assigned_dev->kvm->lock);
 	kvm_put_kvm(assigned_dev->kvm);
 }
@@ -197,6 +203,8 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 {
 	if (irqchip_in_kernel(kvm) && assigned_dev->irq_requested_type)
 		free_irq(assigned_dev->host_irq, (void *)assigned_dev);
+	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)
+		pci_disable_msi(assigned_dev->dev);
 
 	kvm_unregister_irq_ack_notifier(&assigned_dev->ack_notifier);
 	kvm_free_irq_source_id(kvm, assigned_dev->irq_source_id);
@@ -242,6 +250,11 @@ static int assigned_device_update_intx(struct kvm *kvm,
 		return 0;
 
 	if (irqchip_in_kernel(kvm)) {
+		if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI) {
+			free_irq(adev->host_irq, (void *)kvm);
+			pci_disable_msi(adev->dev);
+		}
+
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
 
@@ -265,6 +278,41 @@ static int assigned_device_update_intx(struct kvm *kvm,
 	return 0;
 }
 
+#ifdef CONFIG_X86
+static int assigned_device_update_msi(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *adev,
+			struct kvm_assigned_irq *airq)
+{
+	int r;
+
+	/* x86 don't care upper address of guest msi message addr */
+	adev->guest_msi.address_lo = airq->guest_msi.addr_lo;
+	adev->guest_msi.data = airq->guest_msi.data;
+	adev->ack_notifier.gsi = -1;
+
+	if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)
+		return 0;
+
+	if (irqchip_in_kernel(kvm)) {
+		if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_INTX)
+			free_irq(adev->host_irq, (void *)adev);
+
+		r = pci_enable_msi(adev->dev);
+		if (r)
+			return r;
+
+		adev->host_irq = adev->dev->irq;
+		if (request_irq(adev->host_irq, kvm_assigned_dev_intr, 0,
+				"kvm_assigned_msi_device", (void *)adev))
+			return -EIO;
+	}
+
+	adev->irq_requested_type = KVM_ASSIGNED_DEV_GUEST_MSI |
+				   KVM_ASSIGNED_DEV_HOST_MSI;
+	return 0;
+}
+#endif
+
 static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 				   struct kvm_assigned_irq
 				   *assigned_irq)
@@ -301,9 +349,30 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 		}
 	}
 
-	r = assigned_device_update_intx(kvm, match, assigned_irq);
-	if (r)
-		goto out_release;
+	if (assigned_irq->flags & KVM_DEV_IRQ_ASSIGN_ENABLE_MSI) {
+#ifdef CONFIG_X86
+		r = assigned_device_update_msi(kvm, match, assigned_irq);
+		if (r) {
+			printk(KERN_WARNING "kvm: failed to enable "
+					"MSI device!\n");
+			goto out_release;
+		}
+#else
+		r = -ENOTTY;
+#endif
+	} else if (assigned_irq->host_irq == 0 && match->dev->irq == 0) {
+		/* Host device IRQ 0 means don't support INTx */
+		printk(KERN_WARNING "kvm: wait device to enable MSI!\n");
+		r = 0;
+	} else {
+		/* Non-sharing INTx mode */
+		r = assigned_device_update_intx(kvm, match, assigned_irq);
+		if (r) {
+			printk(KERN_WARNING "kvm: failed to enable "
+					"INTx device!\n");
+			goto out_release;
+		}
+	}
 
 	mutex_unlock(&kvm->lock);
 	return r;
-- 
1.6.0.3


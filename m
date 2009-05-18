Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZERJnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZERJnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZERJZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38430 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 30/43] KVM: Device assignment framework rework
Date: Mon, 18 May 2009 12:22:52 +0300
Message-Id: <1242638585-18470-31-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

After discussion with Marcelo, we decided to rework device assignment framework
together. The old problems are kernel logic is unnecessary complex. So Marcelo
suggest to split it into a more elegant way:

1. Split host IRQ assign and guest IRQ assign. And userspace determine the
combination. Also discard msi2intx parameter, userspace can specific
KVM_DEV_IRQ_HOST_MSI | KVM_DEV_IRQ_GUEST_INTX in assigned_irq->flags to
enable MSI to INTx convertion.

2. Split assign IRQ and deassign IRQ. Import two new ioctls:
KVM_ASSIGN_DEV_IRQ and KVM_DEASSIGN_DEV_IRQ.

This patch also fixed the reversed _IOR vs _IOW in definition(by deprecated the
old interface).

[avi: replace homemade bitcount() by hweight_long()]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c       |    1 +
 include/linux/kvm.h      |   26 ++-
 include/linux/kvm_host.h |    5 -
 virt/kvm/kvm_main.c      |  486 ++++++++++++++++++++++++----------------------
 4 files changed, 276 insertions(+), 242 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cac6e63..a27a64c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1022,6 +1022,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_REINJECT_CONTROL:
 	case KVM_CAP_IRQ_INJECT_STATUS:
+	case KVM_CAP_ASSIGN_DEV_IRQ:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 640835e..644e3a9 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -412,6 +412,7 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_MSIX
 #define KVM_CAP_DEVICE_MSIX 28
 #endif
+#define KVM_CAP_ASSIGN_DEV_IRQ 29
 /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
 
@@ -485,8 +486,10 @@ struct kvm_irq_routing {
 #define KVM_ASSIGN_PCI_DEVICE _IOR(KVMIO, 0x69, \
 				   struct kvm_assigned_pci_dev)
 #define KVM_SET_GSI_ROUTING       _IOW(KVMIO, 0x6a, struct kvm_irq_routing)
+/* deprecated, replaced by KVM_ASSIGN_DEV_IRQ */
 #define KVM_ASSIGN_IRQ _IOR(KVMIO, 0x70, \
 			    struct kvm_assigned_irq)
+#define KVM_ASSIGN_DEV_IRQ        _IOW(KVMIO, 0x70, struct kvm_assigned_irq)
 #define KVM_REINJECT_CONTROL      _IO(KVMIO, 0x71)
 #define KVM_DEASSIGN_PCI_DEVICE _IOW(KVMIO, 0x72, \
 				     struct kvm_assigned_pci_dev)
@@ -494,6 +497,7 @@ struct kvm_irq_routing {
 			_IOW(KVMIO, 0x73, struct kvm_assigned_msix_nr)
 #define KVM_ASSIGN_SET_MSIX_ENTRY \
 			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
+#define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
 
 /*
  * ioctls for vcpu fds
@@ -584,6 +588,8 @@ struct kvm_debug_guest {
 #define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
 #define KVM_TRC_PPC_INSTR        (KVM_TRC_HANDLER + 0x19)
 
+#define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
+
 struct kvm_assigned_pci_dev {
 	__u32 assigned_dev_id;
 	__u32 busnr;
@@ -594,6 +600,17 @@ struct kvm_assigned_pci_dev {
 	};
 };
 
+#define KVM_DEV_IRQ_HOST_INTX    (1 << 0)
+#define KVM_DEV_IRQ_HOST_MSI     (1 << 1)
+#define KVM_DEV_IRQ_HOST_MSIX    (1 << 2)
+
+#define KVM_DEV_IRQ_GUEST_INTX   (1 << 8)
+#define KVM_DEV_IRQ_GUEST_MSI    (1 << 9)
+#define KVM_DEV_IRQ_GUEST_MSIX   (1 << 10)
+
+#define KVM_DEV_IRQ_HOST_MASK	 0x00ff
+#define KVM_DEV_IRQ_GUEST_MASK   0xff00
+
 struct kvm_assigned_irq {
 	__u32 assigned_dev_id;
 	__u32 host_irq;
@@ -609,15 +626,6 @@ struct kvm_assigned_irq {
 	};
 };
 
-#define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
-
-#define KVM_DEV_IRQ_ASSIGN_MSI_ACTION	KVM_DEV_IRQ_ASSIGN_ENABLE_MSI
-#define KVM_DEV_IRQ_ASSIGN_ENABLE_MSI	(1 << 0)
-
-#define KVM_DEV_IRQ_ASSIGN_MSIX_ACTION  (KVM_DEV_IRQ_ASSIGN_ENABLE_MSIX |\
-					KVM_DEV_IRQ_ASSIGN_MASK_MSIX)
-#define KVM_DEV_IRQ_ASSIGN_ENABLE_MSIX  (1 << 1)
-#define KVM_DEV_IRQ_ASSIGN_MASK_MSIX    (1 << 2)
 
 struct kvm_assigned_msix_nr {
 	__u32 assigned_dev_id;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb60f31..40e49ed 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -339,11 +339,6 @@ struct kvm_assigned_dev_kernel {
 	struct msix_entry *host_msix_entries;
 	int guest_irq;
 	struct kvm_guest_msix_entry *guest_msix_entries;
-#define KVM_ASSIGNED_DEV_GUEST_INTX	(1 << 0)
-#define KVM_ASSIGNED_DEV_GUEST_MSI	(1 << 1)
-#define KVM_ASSIGNED_DEV_HOST_INTX	(1 << 8)
-#define KVM_ASSIGNED_DEV_HOST_MSI	(1 << 9)
-#define KVM_ASSIGNED_DEV_MSIX		((1 << 2) | (1 << 10))
 	unsigned long irq_requested_type;
 	int irq_source_id;
 	int flags;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 034ed43..231ca3c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -41,6 +41,7 @@
 #include <linux/pagemap.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
+#include <linux/bitops.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -60,9 +61,6 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
-static int msi2intx = 1;
-module_param(msi2intx, bool, 0);
-
 DEFINE_SPINLOCK(kvm_lock);
 LIST_HEAD(vm_list);
 
@@ -132,7 +130,7 @@ static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 	 * finer-grained lock, update this
 	 */
 	mutex_lock(&kvm->lock);
-	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_MSIX) {
+	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX) {
 		struct kvm_guest_msix_entry *guest_entries =
 			assigned_dev->guest_msix_entries;
 		for (i = 0; i < assigned_dev->entries_nr; i++) {
@@ -152,7 +150,7 @@ static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
 		kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
 			    assigned_dev->guest_irq, 1);
 		if (assigned_dev->irq_requested_type &
-				KVM_ASSIGNED_DEV_GUEST_MSI) {
+				KVM_DEV_IRQ_GUEST_MSI) {
 			enable_irq(assigned_dev->host_irq);
 			assigned_dev->host_irq_disabled = false;
 		}
@@ -166,7 +164,7 @@ static irqreturn_t kvm_assigned_dev_intr(int irq, void *dev_id)
 	struct kvm_assigned_dev_kernel *assigned_dev =
 		(struct kvm_assigned_dev_kernel *) dev_id;
 
-	if (assigned_dev->irq_requested_type == KVM_ASSIGNED_DEV_MSIX) {
+	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX) {
 		int index = find_index_from_host_irq(assigned_dev, irq);
 		if (index < 0)
 			return IRQ_HANDLED;
@@ -204,22 +202,22 @@ static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
 	}
 }
 
-/* The function implicit hold kvm->lock mutex due to cancel_work_sync() */
-static void kvm_free_assigned_irq(struct kvm *kvm,
-				  struct kvm_assigned_dev_kernel *assigned_dev)
+static void deassign_guest_irq(struct kvm *kvm,
+			       struct kvm_assigned_dev_kernel *assigned_dev)
 {
-	if (!irqchip_in_kernel(kvm))
-		return;
-
 	kvm_unregister_irq_ack_notifier(&assigned_dev->ack_notifier);
+	assigned_dev->ack_notifier.gsi = -1;
 
 	if (assigned_dev->irq_source_id != -1)
 		kvm_free_irq_source_id(kvm, assigned_dev->irq_source_id);
 	assigned_dev->irq_source_id = -1;
+	assigned_dev->irq_requested_type &= ~(KVM_DEV_IRQ_GUEST_MASK);
+}
 
-	if (!assigned_dev->irq_requested_type)
-		return;
-
+/* The function implicit hold kvm->lock mutex due to cancel_work_sync() */
+static void deassign_host_irq(struct kvm *kvm,
+			      struct kvm_assigned_dev_kernel *assigned_dev)
+{
 	/*
 	 * In kvm_free_device_irq, cancel_work_sync return true if:
 	 * 1. work is scheduled, and then cancelled.
@@ -236,7 +234,7 @@ static void kvm_free_assigned_irq(struct kvm *kvm,
 	 * now, the kvm state is still legal for probably we also have to wait
 	 * interrupt_work done.
 	 */
-	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_MSIX) {
+	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX) {
 		int i;
 		for (i = 0; i < assigned_dev->entries_nr; i++)
 			disable_irq_nosync(assigned_dev->
@@ -259,14 +257,41 @@ static void kvm_free_assigned_irq(struct kvm *kvm,
 
 		free_irq(assigned_dev->host_irq, (void *)assigned_dev);
 
-		if (assigned_dev->irq_requested_type &
-				KVM_ASSIGNED_DEV_HOST_MSI)
+		if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI)
 			pci_disable_msi(assigned_dev->dev);
 	}
 
-	assigned_dev->irq_requested_type = 0;
+	assigned_dev->irq_requested_type &= ~(KVM_DEV_IRQ_HOST_MASK);
+}
+
+static int kvm_deassign_irq(struct kvm *kvm,
+			    struct kvm_assigned_dev_kernel *assigned_dev,
+			    unsigned long irq_requested_type)
+{
+	unsigned long guest_irq_type, host_irq_type;
+
+	if (!irqchip_in_kernel(kvm))
+		return -EINVAL;
+	/* no irq assignment to deassign */
+	if (!assigned_dev->irq_requested_type)
+		return -ENXIO;
+
+	host_irq_type = irq_requested_type & KVM_DEV_IRQ_HOST_MASK;
+	guest_irq_type = irq_requested_type & KVM_DEV_IRQ_GUEST_MASK;
+
+	if (host_irq_type)
+		deassign_host_irq(kvm, assigned_dev);
+	if (guest_irq_type)
+		deassign_guest_irq(kvm, assigned_dev);
+
+	return 0;
 }
 
+static void kvm_free_assigned_irq(struct kvm *kvm,
+				  struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	kvm_deassign_irq(kvm, assigned_dev, assigned_dev->irq_requested_type);
+}
 
 static void kvm_free_assigned_device(struct kvm *kvm,
 				     struct kvm_assigned_dev_kernel
@@ -298,256 +323,244 @@ void kvm_free_all_assigned_devices(struct kvm *kvm)
 	}
 }
 
-static int assigned_device_update_intx(struct kvm *kvm,
-			struct kvm_assigned_dev_kernel *adev,
-			struct kvm_assigned_irq *airq)
+static int assigned_device_enable_host_intx(struct kvm *kvm,
+					    struct kvm_assigned_dev_kernel *dev)
 {
-	adev->guest_irq = airq->guest_irq;
-	adev->ack_notifier.gsi = airq->guest_irq;
-
-	if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_INTX)
-		return 0;
-
-	if (irqchip_in_kernel(kvm)) {
-		if (!msi2intx &&
-		    (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)) {
-			free_irq(adev->host_irq, (void *)adev);
-			pci_disable_msi(adev->dev);
-		}
+	dev->host_irq = dev->dev->irq;
+	/* Even though this is PCI, we don't want to use shared
+	 * interrupts. Sharing host devices with guest-assigned devices
+	 * on the same interrupt line is not a happy situation: there
+	 * are going to be long delays in accepting, acking, etc.
+	 */
+	if (request_irq(dev->host_irq, kvm_assigned_dev_intr,
+			0, "kvm_assigned_intx_device", (void *)dev))
+		return -EIO;
+	return 0;
+}
 
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
+#ifdef __KVM_HAVE_MSI
+static int assigned_device_enable_host_msi(struct kvm *kvm,
+					   struct kvm_assigned_dev_kernel *dev)
+{
+	int r;
 
-		if (airq->host_irq)
-			adev->host_irq = airq->host_irq;
-		else
-			adev->host_irq = adev->dev->irq;
+	if (!dev->dev->msi_enabled) {
+		r = pci_enable_msi(dev->dev);
+		if (r)
+			return r;
+	}
 
-		/* Even though this is PCI, we don't want to use shared
-		 * interrupts. Sharing host devices with guest-assigned devices
-		 * on the same interrupt line is not a happy situation: there
-		 * are going to be long delays in accepting, acking, etc.
-		 */
-		if (request_irq(adev->host_irq, kvm_assigned_dev_intr,
-				0, "kvm_assigned_intx_device", (void *)adev))
-			return -EIO;
+	dev->host_irq = dev->dev->irq;
+	if (request_irq(dev->host_irq, kvm_assigned_dev_intr, 0,
+			"kvm_assigned_msi_device", (void *)dev)) {
+		pci_disable_msi(dev->dev);
+		return -EIO;
 	}
 
-	adev->irq_requested_type = KVM_ASSIGNED_DEV_GUEST_INTX |
-				   KVM_ASSIGNED_DEV_HOST_INTX;
 	return 0;
 }
+#endif
 
-#ifdef CONFIG_X86
-static int assigned_device_update_msi(struct kvm *kvm,
-			struct kvm_assigned_dev_kernel *adev,
-			struct kvm_assigned_irq *airq)
+#ifdef __KVM_HAVE_MSIX
+static int assigned_device_enable_host_msix(struct kvm *kvm,
+					    struct kvm_assigned_dev_kernel *dev)
 {
-	int r;
+	int i, r = -EINVAL;
 
-	adev->guest_irq = airq->guest_irq;
-	if (airq->flags & KVM_DEV_IRQ_ASSIGN_ENABLE_MSI) {
-		/* x86 don't care upper address of guest msi message addr */
-		adev->irq_requested_type |= KVM_ASSIGNED_DEV_GUEST_MSI;
-		adev->irq_requested_type &= ~KVM_ASSIGNED_DEV_GUEST_INTX;
-		adev->ack_notifier.gsi = -1;
-	} else if (msi2intx) {
-		adev->irq_requested_type |= KVM_ASSIGNED_DEV_GUEST_INTX;
-		adev->irq_requested_type &= ~KVM_ASSIGNED_DEV_GUEST_MSI;
-		adev->ack_notifier.gsi = airq->guest_irq;
-	} else {
-		/*
-		 * Guest require to disable device MSI, we disable MSI and
-		 * re-enable INTx by default again. Notice it's only for
-		 * non-msi2intx.
-		 */
-		assigned_device_update_intx(kvm, adev, airq);
-		return 0;
-	}
+	/* host_msix_entries and guest_msix_entries should have been
+	 * initialized */
+	if (dev->entries_nr == 0)
+		return r;
 
-	if (adev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)
-		return 0;
+	r = pci_enable_msix(dev->dev, dev->host_msix_entries, dev->entries_nr);
+	if (r)
+		return r;
 
-	if (irqchip_in_kernel(kvm)) {
-		if (!msi2intx) {
-			if (adev->irq_requested_type &
-					KVM_ASSIGNED_DEV_HOST_INTX)
-				free_irq(adev->host_irq, (void *)adev);
+	for (i = 0; i < dev->entries_nr; i++) {
+		r = request_irq(dev->host_msix_entries[i].vector,
+				kvm_assigned_dev_intr, 0,
+				"kvm_assigned_msix_device",
+				(void *)dev);
+		/* FIXME: free requested_irq's on failure */
+		if (r)
+			return r;
+	}
 
-			r = pci_enable_msi(adev->dev);
-			if (r)
-				return r;
-		}
+	return 0;
+}
 
-		adev->host_irq = adev->dev->irq;
-		if (request_irq(adev->host_irq, kvm_assigned_dev_intr, 0,
-				"kvm_assigned_msi_device", (void *)adev))
-			return -EIO;
-	}
+#endif
 
-	if (!msi2intx)
-		adev->irq_requested_type = KVM_ASSIGNED_DEV_GUEST_MSI;
+static int assigned_device_enable_guest_intx(struct kvm *kvm,
+				struct kvm_assigned_dev_kernel *dev,
+				struct kvm_assigned_irq *irq)
+{
+	dev->guest_irq = irq->guest_irq;
+	dev->ack_notifier.gsi = irq->guest_irq;
+	return 0;
+}
 
-	adev->irq_requested_type |= KVM_ASSIGNED_DEV_HOST_MSI;
+#ifdef __KVM_HAVE_MSI
+static int assigned_device_enable_guest_msi(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *dev,
+			struct kvm_assigned_irq *irq)
+{
+	dev->guest_irq = irq->guest_irq;
+	dev->ack_notifier.gsi = -1;
 	return 0;
 }
 #endif
+#ifdef __KVM_HAVE_MSIX
+static int assigned_device_enable_guest_msix(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *dev,
+			struct kvm_assigned_irq *irq)
+{
+	dev->guest_irq = irq->guest_irq;
+	dev->ack_notifier.gsi = -1;
+	return 0;
+}
+#endif
+
+static int assign_host_irq(struct kvm *kvm,
+			   struct kvm_assigned_dev_kernel *dev,
+			   __u32 host_irq_type)
+{
+	int r = -EEXIST;
+
+	if (dev->irq_requested_type & KVM_DEV_IRQ_HOST_MASK)
+		return r;
 
+	switch (host_irq_type) {
+	case KVM_DEV_IRQ_HOST_INTX:
+		r = assigned_device_enable_host_intx(kvm, dev);
+		break;
+#ifdef __KVM_HAVE_MSI
+	case KVM_DEV_IRQ_HOST_MSI:
+		r = assigned_device_enable_host_msi(kvm, dev);
+		break;
+#endif
 #ifdef __KVM_HAVE_MSIX
-static int assigned_device_update_msix(struct kvm *kvm,
-			struct kvm_assigned_dev_kernel *adev,
-			struct kvm_assigned_irq *airq)
-{
-	/* TODO Deal with KVM_DEV_IRQ_ASSIGNED_MASK_MSIX */
-	int i, r;
-
-	adev->ack_notifier.gsi = -1;
-
-	if (irqchip_in_kernel(kvm)) {
-		if (airq->flags & KVM_DEV_IRQ_ASSIGN_MASK_MSIX)
-			return -ENOTTY;
-
-		if (!(airq->flags & KVM_DEV_IRQ_ASSIGN_ENABLE_MSIX)) {
-			/* Guest disable MSI-X */
-			kvm_free_assigned_irq(kvm, adev);
-			if (msi2intx) {
-				pci_enable_msi(adev->dev);
-				if (adev->dev->msi_enabled)
-					return assigned_device_update_msi(kvm,
-							adev, airq);
-			}
-			return assigned_device_update_intx(kvm, adev, airq);
-		}
+	case KVM_DEV_IRQ_HOST_MSIX:
+		r = assigned_device_enable_host_msix(kvm, dev);
+		break;
+#endif
+	default:
+		r = -EINVAL;
+	}
 
-		/* host_msix_entries and guest_msix_entries should have been
-		 * initialized */
-		if (adev->entries_nr == 0)
-			return -EINVAL;
+	if (!r)
+		dev->irq_requested_type |= host_irq_type;
 
-		kvm_free_assigned_irq(kvm, adev);
+	return r;
+}
 
-		r = pci_enable_msix(adev->dev, adev->host_msix_entries,
-				    adev->entries_nr);
-		if (r)
-			return r;
+static int assign_guest_irq(struct kvm *kvm,
+			    struct kvm_assigned_dev_kernel *dev,
+			    struct kvm_assigned_irq *irq,
+			    unsigned long guest_irq_type)
+{
+	int id;
+	int r = -EEXIST;
 
-		for (i = 0; i < adev->entries_nr; i++) {
-			r = request_irq((adev->host_msix_entries + i)->vector,
-					kvm_assigned_dev_intr, 0,
-					"kvm_assigned_msix_device",
-					(void *)adev);
-			if (r)
-				return r;
-		}
+	if (dev->irq_requested_type & KVM_DEV_IRQ_GUEST_MASK)
+		return r;
+
+	id = kvm_request_irq_source_id(kvm);
+	if (id < 0)
+		return id;
+
+	dev->irq_source_id = id;
+
+	switch (guest_irq_type) {
+	case KVM_DEV_IRQ_GUEST_INTX:
+		r = assigned_device_enable_guest_intx(kvm, dev, irq);
+		break;
+#ifdef __KVM_HAVE_MSI
+	case KVM_DEV_IRQ_GUEST_MSI:
+		r = assigned_device_enable_guest_msi(kvm, dev, irq);
+		break;
+#endif
+#ifdef __KVM_HAVE_MSIX
+	case KVM_DEV_IRQ_GUEST_MSIX:
+		r = assigned_device_enable_guest_msix(kvm, dev, irq);
+		break;
+#endif
+	default:
+		r = -EINVAL;
 	}
 
-	adev->irq_requested_type |= KVM_ASSIGNED_DEV_MSIX;
+	if (!r) {
+		dev->irq_requested_type |= guest_irq_type;
+		kvm_register_irq_ack_notifier(kvm, &dev->ack_notifier);
+	} else
+		kvm_free_irq_source_id(kvm, dev->irq_source_id);
 
-	return 0;
+	return r;
 }
-#endif
 
+/* TODO Deal with KVM_DEV_IRQ_ASSIGNED_MASK_MSIX */
 static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
-				   struct kvm_assigned_irq
-				   *assigned_irq)
+				   struct kvm_assigned_irq *assigned_irq)
 {
-	int r = 0;
+	int r = -EINVAL;
 	struct kvm_assigned_dev_kernel *match;
-	u32 current_flags = 0, changed_flags;
+	unsigned long host_irq_type, guest_irq_type;
 
-	mutex_lock(&kvm->lock);
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 
+	if (!irqchip_in_kernel(kvm))
+		return r;
+
+	mutex_lock(&kvm->lock);
+	r = -ENODEV;
 	match = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
 				      assigned_irq->assigned_dev_id);
-	if (!match) {
-		mutex_unlock(&kvm->lock);
-		return -EINVAL;
-	}
-
-	if (!match->irq_requested_type) {
-		INIT_WORK(&match->interrupt_work,
-				kvm_assigned_dev_interrupt_work_handler);
-		if (irqchip_in_kernel(kvm)) {
-			/* Register ack nofitier */
-			match->ack_notifier.gsi = -1;
-			match->ack_notifier.irq_acked =
-					kvm_assigned_dev_ack_irq;
-			kvm_register_irq_ack_notifier(kvm,
-					&match->ack_notifier);
-
-			/* Request IRQ source ID */
-			r = kvm_request_irq_source_id(kvm);
-			if (r < 0)
-				goto out_release;
-			else
-				match->irq_source_id = r;
-
-#ifdef CONFIG_X86
-			/* Determine host device irq type, we can know the
-			 * result from dev->msi_enabled */
-			if (msi2intx)
-				pci_enable_msi(match->dev);
-#endif
-		}
-	}
+	if (!match)
+		goto out;
 
-	if (match->irq_requested_type & KVM_ASSIGNED_DEV_MSIX)
-		current_flags |= KVM_DEV_IRQ_ASSIGN_ENABLE_MSIX;
-	else if ((match->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI) &&
-		 (match->irq_requested_type & KVM_ASSIGNED_DEV_GUEST_MSI))
-		current_flags |= KVM_DEV_IRQ_ASSIGN_ENABLE_MSI;
+	host_irq_type = (assigned_irq->flags & KVM_DEV_IRQ_HOST_MASK);
+	guest_irq_type = (assigned_irq->flags & KVM_DEV_IRQ_GUEST_MASK);
 
-	changed_flags = assigned_irq->flags ^ current_flags;
+	r = -EINVAL;
+	/* can only assign one type at a time */
+	if (hweight_long(host_irq_type) > 1)
+		goto out;
+	if (hweight_long(guest_irq_type) > 1)
+		goto out;
+	if (host_irq_type == 0 && guest_irq_type == 0)
+		goto out;
 
-#ifdef __KVM_HAVE_MSIX
-	if (changed_flags & KVM_DEV_IRQ_ASSIGN_MSIX_ACTION) {
-		r = assigned_device_update_msix(kvm, match, assigned_irq);
-		if (r) {
-			printk(KERN_WARNING "kvm: failed to execute "
-					"MSI-X action!\n");
-			goto out_release;
-		}
-	} else
-#endif
-	if ((changed_flags & KVM_DEV_IRQ_ASSIGN_MSI_ACTION) ||
-	    (msi2intx && match->dev->msi_enabled)) {
-#ifdef CONFIG_X86
-		r = assigned_device_update_msi(kvm, match, assigned_irq);
-		if (r) {
-			printk(KERN_WARNING "kvm: failed to enable "
-					"MSI device!\n");
-			goto out_release;
-		}
-#else
-		r = -ENOTTY;
-#endif
-	} else if (assigned_irq->host_irq == 0 && match->dev->irq == 0) {
-		/* Host device IRQ 0 means don't support INTx */
-		if (!msi2intx) {
-			printk(KERN_WARNING
-			       "kvm: wait device to enable MSI!\n");
-			r = 0;
-		} else {
-			printk(KERN_WARNING
-			       "kvm: failed to enable MSI device!\n");
-			r = -ENOTTY;
-			goto out_release;
-		}
-	} else {
-		/* Non-sharing INTx mode */
-		r = assigned_device_update_intx(kvm, match, assigned_irq);
-		if (r) {
-			printk(KERN_WARNING "kvm: failed to enable "
-					"INTx device!\n");
-			goto out_release;
-		}
-	}
+	r = 0;
+	if (host_irq_type)
+		r = assign_host_irq(kvm, match, host_irq_type);
+	if (r)
+		goto out;
 
+	if (guest_irq_type)
+		r = assign_guest_irq(kvm, match, assigned_irq, guest_irq_type);
+out:
 	mutex_unlock(&kvm->lock);
 	return r;
-out_release:
+}
+
+static int kvm_vm_ioctl_deassign_dev_irq(struct kvm *kvm,
+					 struct kvm_assigned_irq
+					 *assigned_irq)
+{
+	int r = -ENODEV;
+	struct kvm_assigned_dev_kernel *match;
+
+	mutex_lock(&kvm->lock);
+
+	match = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
+				      assigned_irq->assigned_dev_id);
+	if (!match)
+		goto out;
+
+	r = kvm_deassign_irq(kvm, match, assigned_irq->flags);
+out:
 	mutex_unlock(&kvm->lock);
-	kvm_free_assigned_device(kvm, match);
 	return r;
 }
 
@@ -565,7 +578,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 				      assigned_dev->assigned_dev_id);
 	if (match) {
 		/* device already assigned */
-		r = -EINVAL;
+		r = -EEXIST;
 		goto out;
 	}
 
@@ -604,6 +617,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	match->dev = dev;
 	match->irq_source_id = -1;
 	match->kvm = kvm;
+	match->ack_notifier.irq_acked = kvm_assigned_dev_ack_irq;
+	INIT_WORK(&match->interrupt_work,
+		  kvm_assigned_dev_interrupt_work_handler);
 
 	list_add(&match->list, &kvm->arch.assigned_dev_head);
 
@@ -2084,6 +2100,11 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_ASSIGN_IRQ: {
+		r = -EOPNOTSUPP;
+		break;
+	}
+#ifdef KVM_CAP_ASSIGN_DEV_IRQ
+	case KVM_ASSIGN_DEV_IRQ: {
 		struct kvm_assigned_irq assigned_irq;
 
 		r = -EFAULT;
@@ -2094,6 +2115,18 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
+	case KVM_DEASSIGN_DEV_IRQ: {
+		struct kvm_assigned_irq assigned_irq;
+
+		r = -EFAULT;
+		if (copy_from_user(&assigned_irq, argp, sizeof assigned_irq))
+			goto out;
+		r = kvm_vm_ioctl_deassign_dev_irq(kvm, &assigned_irq);
+		if (r)
+			goto out;
+		break;
+	}
+#endif
 #endif
 #ifdef KVM_CAP_DEVICE_DEASSIGNMENT
 	case KVM_DEASSIGN_PCI_DEVICE: {
@@ -2595,9 +2628,6 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
-#ifndef CONFIG_X86
-	msi2intx = 0;
-#endif
 
 	return 0;
 
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZERJd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZERJd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756511AbZERJX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 10/43] KVM: Enable MSI-X for KVM assigned device
Date: Mon, 18 May 2009 12:22:32 +0300
Message-Id: <1242638585-18470-11-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

This patch finally enable MSI-X.

What we need for MSI-X:
1. Intercept one page in MMIO region of device. So that we can get guest desired
MSI-X table and set up the real one. Now this have been done by guest, and
transfer to kernel using ioctl KVM_SET_MSIX_NR and KVM_SET_MSIX_ENTRY.

2. Information for incoming interrupt. Now one device can have more than one
interrupt, and they are all handled by one workqueue structure. So we need to
identify them. The previous patch enable gsi_msg_pending_bitmap get this done.

3. Mapping from host IRQ to guest gsi as well as guest gsi to real MSI/MSI-X
message address/data. We used same entry number for the host and guest here, so
that it's easy to find the correlated guest gsi.

What we lack for now:
1. The PCI spec said nothing can existed with MSI-X table in the same page of
MMIO region, except pending bits. The patch ignore pending bits as the first
step (so they are always 0 - no pending).

2. The PCI spec allowed to change MSI-X table dynamically. That means, the OS
can enable MSI-X, then mask one MSI-X entry, modify it, and unmask it. The patch
didn't support this, and Linux also don't work in this way.

3. The patch didn't implement MSI-X mask all and mask single entry. I would
implement the former in driver/pci/msi.c later. And for single entry, userspace
should have reposibility to handle it.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm.h |    1 +
 include/linux/kvm.h        |    8 ++++
 virt/kvm/kvm_main.c        |   98 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index dc3f6cf..125be8b 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -16,6 +16,7 @@
 #define __KVM_HAVE_MSI
 #define __KVM_HAVE_USER_NMI
 #define __KVM_HAVE_GUEST_DEBUG
+#define __KVM_HAVE_MSIX
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 78cdee8..640835e 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -409,6 +409,9 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
 #define KVM_CAP_DEVICE_DEASSIGNMENT 27
 #endif
+#ifdef __KVM_HAVE_MSIX
+#define KVM_CAP_DEVICE_MSIX 28
+#endif
 /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
 
@@ -611,6 +614,11 @@ struct kvm_assigned_irq {
 #define KVM_DEV_IRQ_ASSIGN_MSI_ACTION	KVM_DEV_IRQ_ASSIGN_ENABLE_MSI
 #define KVM_DEV_IRQ_ASSIGN_ENABLE_MSI	(1 << 0)
 
+#define KVM_DEV_IRQ_ASSIGN_MSIX_ACTION  (KVM_DEV_IRQ_ASSIGN_ENABLE_MSIX |\
+					KVM_DEV_IRQ_ASSIGN_MASK_MSIX)
+#define KVM_DEV_IRQ_ASSIGN_ENABLE_MSIX  (1 << 1)
+#define KVM_DEV_IRQ_ASSIGN_MASK_MSIX    (1 << 2)
+
 struct kvm_assigned_msix_nr {
 	__u32 assigned_dev_id;
 	__u16 entry_nr;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7c20e06..034ed43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -236,13 +236,33 @@ static void kvm_free_assigned_irq(struct kvm *kvm,
 	 * now, the kvm state is still legal for probably we also have to wait
 	 * interrupt_work done.
 	 */
-	disable_irq_nosync(assigned_dev->host_irq);
-	cancel_work_sync(&assigned_dev->interrupt_work);
+	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_MSIX) {
+		int i;
+		for (i = 0; i < assigned_dev->entries_nr; i++)
+			disable_irq_nosync(assigned_dev->
+					   host_msix_entries[i].vector);
+
+		cancel_work_sync(&assigned_dev->interrupt_work);
 
-	free_irq(assigned_dev->host_irq, (void *)assigned_dev);
+		for (i = 0; i < assigned_dev->entries_nr; i++)
+			free_irq(assigned_dev->host_msix_entries[i].vector,
+				 (void *)assigned_dev);
 
-	if (assigned_dev->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI)
-		pci_disable_msi(assigned_dev->dev);
+		assigned_dev->entries_nr = 0;
+		kfree(assigned_dev->host_msix_entries);
+		kfree(assigned_dev->guest_msix_entries);
+		pci_disable_msix(assigned_dev->dev);
+	} else {
+		/* Deal with MSI and INTx */
+		disable_irq_nosync(assigned_dev->host_irq);
+		cancel_work_sync(&assigned_dev->interrupt_work);
+
+		free_irq(assigned_dev->host_irq, (void *)assigned_dev);
+
+		if (assigned_dev->irq_requested_type &
+				KVM_ASSIGNED_DEV_HOST_MSI)
+			pci_disable_msi(assigned_dev->dev);
+	}
 
 	assigned_dev->irq_requested_type = 0;
 }
@@ -373,6 +393,60 @@ static int assigned_device_update_msi(struct kvm *kvm,
 }
 #endif
 
+#ifdef __KVM_HAVE_MSIX
+static int assigned_device_update_msix(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *adev,
+			struct kvm_assigned_irq *airq)
+{
+	/* TODO Deal with KVM_DEV_IRQ_ASSIGNED_MASK_MSIX */
+	int i, r;
+
+	adev->ack_notifier.gsi = -1;
+
+	if (irqchip_in_kernel(kvm)) {
+		if (airq->flags & KVM_DEV_IRQ_ASSIGN_MASK_MSIX)
+			return -ENOTTY;
+
+		if (!(airq->flags & KVM_DEV_IRQ_ASSIGN_ENABLE_MSIX)) {
+			/* Guest disable MSI-X */
+			kvm_free_assigned_irq(kvm, adev);
+			if (msi2intx) {
+				pci_enable_msi(adev->dev);
+				if (adev->dev->msi_enabled)
+					return assigned_device_update_msi(kvm,
+							adev, airq);
+			}
+			return assigned_device_update_intx(kvm, adev, airq);
+		}
+
+		/* host_msix_entries and guest_msix_entries should have been
+		 * initialized */
+		if (adev->entries_nr == 0)
+			return -EINVAL;
+
+		kvm_free_assigned_irq(kvm, adev);
+
+		r = pci_enable_msix(adev->dev, adev->host_msix_entries,
+				    adev->entries_nr);
+		if (r)
+			return r;
+
+		for (i = 0; i < adev->entries_nr; i++) {
+			r = request_irq((adev->host_msix_entries + i)->vector,
+					kvm_assigned_dev_intr, 0,
+					"kvm_assigned_msix_device",
+					(void *)adev);
+			if (r)
+				return r;
+		}
+	}
+
+	adev->irq_requested_type |= KVM_ASSIGNED_DEV_MSIX;
+
+	return 0;
+}
+#endif
+
 static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 				   struct kvm_assigned_irq
 				   *assigned_irq)
@@ -417,12 +491,24 @@ static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
 		}
 	}
 
-	if ((match->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI) &&
+	if (match->irq_requested_type & KVM_ASSIGNED_DEV_MSIX)
+		current_flags |= KVM_DEV_IRQ_ASSIGN_ENABLE_MSIX;
+	else if ((match->irq_requested_type & KVM_ASSIGNED_DEV_HOST_MSI) &&
 		 (match->irq_requested_type & KVM_ASSIGNED_DEV_GUEST_MSI))
 		current_flags |= KVM_DEV_IRQ_ASSIGN_ENABLE_MSI;
 
 	changed_flags = assigned_irq->flags ^ current_flags;
 
+#ifdef __KVM_HAVE_MSIX
+	if (changed_flags & KVM_DEV_IRQ_ASSIGN_MSIX_ACTION) {
+		r = assigned_device_update_msix(kvm, match, assigned_irq);
+		if (r) {
+			printk(KERN_WARNING "kvm: failed to execute "
+					"MSI-X action!\n");
+			goto out_release;
+		}
+	} else
+#endif
 	if ((changed_flags & KVM_DEV_IRQ_ASSIGN_MSI_ACTION) ||
 	    (msi2intx && match->dev->msi_enabled)) {
 #ifdef CONFIG_X86
-- 
1.6.0.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab0BPKgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:36:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/38] KVM: enable PCI multiple-segments for pass-through device
Date: Tue, 16 Feb 2010 12:35:28 +0200
Message-Id: <1266316536-28936-31-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhai, Edwin <edwin.zhai@intel.com>

Enable optional parameter (default 0) - PCI segment (or domain) besides
BDF, when assigning PCI device to guest.

Signed-off-by: Zhai Edwin <edwin.zhai@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c       |    1 +
 include/linux/kvm.h      |    4 +++-
 include/linux/kvm_host.h |    1 +
 virt/kvm/assigned-dev.c  |    4 +++-
 virt/kvm/iommu.c         |    9 ++++++---
 5 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d47ceda..0bf3df5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1569,6 +1569,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_HYPERV:
 	case KVM_CAP_HYPERV_VAPIC:
 	case KVM_CAP_HYPERV_SPIN:
+	case KVM_CAP_PCI_SEGMENT:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 4c4937e..dfa54be 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -500,6 +500,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_HYPERV 44
 #define KVM_CAP_HYPERV_VAPIC 45
 #define KVM_CAP_HYPERV_SPIN 46
+#define KVM_CAP_PCI_SEGMENT 47
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -694,8 +695,9 @@ struct kvm_assigned_pci_dev {
 	__u32 busnr;
 	__u32 devfn;
 	__u32 flags;
+	__u32 segnr;
 	union {
-		__u32 reserved[12];
+		__u32 reserved[11];
 	};
 };
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dfde04b..665c370 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -400,6 +400,7 @@ struct kvm_assigned_dev_kernel {
 	struct work_struct interrupt_work;
 	struct list_head list;
 	int assigned_dev_id;
+	int host_segnr;
 	int host_busnr;
 	int host_devfn;
 	unsigned int entries_nr;
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index f51e684..057e2cc 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -526,7 +526,8 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 		r = -ENOMEM;
 		goto out;
 	}
-	dev = pci_get_bus_and_slot(assigned_dev->busnr,
+	dev = pci_get_domain_bus_and_slot(assigned_dev->segnr,
+				   assigned_dev->busnr,
 				   assigned_dev->devfn);
 	if (!dev) {
 		printk(KERN_INFO "%s: host device not found\n", __func__);
@@ -548,6 +549,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	pci_reset_function(dev);
 
 	match->assigned_dev_id = assigned_dev->assigned_dev_id;
+	match->host_segnr = assigned_dev->segnr;
 	match->host_busnr = assigned_dev->busnr;
 	match->host_devfn = assigned_dev->devfn;
 	match->flags = assigned_dev->flags;
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 65a5143..80fd3ad 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -106,7 +106,8 @@ int kvm_assign_device(struct kvm *kvm,
 
 	r = iommu_attach_device(domain, &pdev->dev);
 	if (r) {
-		printk(KERN_ERR "assign device %x:%x.%x failed",
+		printk(KERN_ERR "assign device %x:%x:%x.%x failed",
+			pci_domain_nr(pdev->bus),
 			pdev->bus->number,
 			PCI_SLOT(pdev->devfn),
 			PCI_FUNC(pdev->devfn));
@@ -127,7 +128,8 @@ int kvm_assign_device(struct kvm *kvm,
 			goto out_unmap;
 	}
 
-	printk(KERN_DEBUG "assign device: host bdf = %x:%x:%x\n",
+	printk(KERN_DEBUG "assign device %x:%x:%x.%x\n",
+		assigned_dev->host_segnr,
 		assigned_dev->host_busnr,
 		PCI_SLOT(assigned_dev->host_devfn),
 		PCI_FUNC(assigned_dev->host_devfn));
@@ -154,7 +156,8 @@ int kvm_deassign_device(struct kvm *kvm,
 
 	iommu_detach_device(domain, &pdev->dev);
 
-	printk(KERN_DEBUG "deassign device: host bdf = %x:%x:%x\n",
+	printk(KERN_DEBUG "deassign device %x:%x:%x.%x\n",
+		assigned_dev->host_segnr,
 		assigned_dev->host_busnr,
 		PCI_SLOT(assigned_dev->host_devfn),
 		PCI_FUNC(assigned_dev->host_devfn));
-- 
1.6.5.3


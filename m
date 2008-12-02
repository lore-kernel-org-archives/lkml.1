Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYLBNDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYLBNDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbYLBNBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:01:48 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50111 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbYLBNBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:45 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KB92UA-04-VCK-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Weidong Han <weidong.han@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/12] KVM: change to use new APIs for kvm vtd
Date: Tue, 2 Dec 2008 14:01:13 +0100
Message-ID: <1228222883-17207-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0800 (UTC) FILETIME=[142EE580:01C9547E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weidong Han <weidong.han@intel.com>

This patch changes to use new APIs for KVM VT-d, and add device
deassignment for hotplug.

[Joerg: coding style cleanups]

Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm.h      |    5 ++
 include/linux/kvm_host.h |   23 ++++++++--
 virt/kvm/kvm_main.c      |   49 ++++++++++++++++++++-
 virt/kvm/vtd.c           |  107 +++++++++++++++++++++++++++++++---------------
 4 files changed, 143 insertions(+), 41 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 0997e6f..49432e9 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -395,6 +395,9 @@ struct kvm_trace_rec {
 #if defined(CONFIG_X86)
 #define KVM_CAP_DEVICE_MSI 20
 #endif
+#if defined(CONFIG_X86) || defined(CONFIG_IA64)
+#define KVM_CAP_DEVICE_DEASSIGNMENT 21
+#endif
 
 /*
  * ioctls for VM fds
@@ -428,6 +431,8 @@ struct kvm_trace_rec {
 				   struct kvm_assigned_pci_dev)
 #define KVM_ASSIGN_IRQ _IOR(KVMIO, 0x70, \
 			    struct kvm_assigned_irq)
+#define KVM_DEASSIGN_PCI_DEVICE _IOR(KVMIO, 0x71, \
+				     struct kvm_assigned_pci_dev)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8091a4d..cb1d404 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -329,9 +329,12 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 #ifdef CONFIG_DMAR
 int kvm_iommu_map_pages(struct kvm *kvm, gfn_t base_gfn,
 			unsigned long npages);
-int kvm_iommu_map_guest(struct kvm *kvm,
-			struct kvm_assigned_dev_kernel *assigned_dev);
+int kvm_iommu_map_guest(struct kvm *kvm);
 int kvm_iommu_unmap_guest(struct kvm *kvm);
+int kvm_assign_device(struct kvm *kvm,
+		      struct kvm_assigned_dev_kernel *assigned_dev);
+int kvm_deassign_device(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *assigned_dev);
 #else /* CONFIG_DMAR */
 static inline int kvm_iommu_map_pages(struct kvm *kvm,
 				      gfn_t base_gfn,
@@ -340,9 +343,7 @@ static inline int kvm_iommu_map_pages(struct kvm *kvm,
 	return 0;
 }
 
-static inline int kvm_iommu_map_guest(struct kvm *kvm,
-				      struct kvm_assigned_dev_kernel
-				      *assigned_dev)
+static inline int kvm_iommu_map_guest(struct kvm *kvm)
 {
 	return -ENODEV;
 }
@@ -351,6 +352,18 @@ static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
 {
 	return 0;
 }
+
+static inline int kvm_assign_device(struct kvm *kvm,
+		struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	return 0;
+}
+
+static inline int kvm_deassign_device(struct kvm *kvm,
+		struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	return 0;
+}
 #endif /* CONFIG_DMAR */
 
 static inline void kvm_guest_enter(void)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8dab7ce..fe6aba0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -472,7 +472,12 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	list_add(&match->list, &kvm->arch.assigned_dev_head);
 
 	if (assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU) {
-		r = kvm_iommu_map_guest(kvm, match);
+		if (!kvm->arch.intel_iommu_domain) {
+			r = kvm_iommu_map_guest(kvm);
+			if (r)
+				goto out_list_del;
+		}
+		r = kvm_assign_device(kvm, match);
 		if (r)
 			goto out_list_del;
 	}
@@ -494,6 +499,35 @@ out_free:
 }
 #endif
 
+#ifdef KVM_CAP_DEVICE_DEASSIGNMENT
+static int kvm_vm_ioctl_deassign_device(struct kvm *kvm,
+		struct kvm_assigned_pci_dev *assigned_dev)
+{
+	int r = 0;
+	struct kvm_assigned_dev_kernel *match;
+
+	mutex_lock(&kvm->lock);
+
+	match = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
+				      assigned_dev->assigned_dev_id);
+	if (!match) {
+		printk(KERN_INFO "%s: device hasn't been assigned before, "
+		  "so cannot be deassigned\n", __func__);
+		r = -EINVAL;
+		goto out;
+	}
+
+	if (assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
+		kvm_deassign_device(kvm, match);
+
+	kvm_free_assigned_device(kvm, match);
+
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+#endif
+
 static inline int valid_vcpu(int n)
 {
 	return likely(n >= 0 && n < KVM_MAX_VCPUS);
@@ -1833,6 +1867,19 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
+#ifdef KVM_CAP_DEVICE_DEASSIGNMENT
+	case KVM_DEASSIGN_PCI_DEVICE: {
+		struct kvm_assigned_pci_dev assigned_dev;
+
+		r = -EFAULT;
+		if (copy_from_user(&assigned_dev, argp, sizeof assigned_dev))
+			goto out;
+		r = kvm_vm_ioctl_deassign_device(kvm, &assigned_dev);
+		if (r)
+			goto out;
+		break;
+	}
+#endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
diff --git a/virt/kvm/vtd.c b/virt/kvm/vtd.c
index a770874..832ee04 100644
--- a/virt/kvm/vtd.c
+++ b/virt/kvm/vtd.c
@@ -36,7 +36,8 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 {
 	gfn_t gfn = base_gfn;
 	pfn_t pfn;
-	int i, r = 0;
+	int r = 0;
+	unsigned long i;
 	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
 
 	/* check if iommu exists and in use */
@@ -48,15 +49,15 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 		pfn = (pfn_t)intel_iommu_iova_to_pfn(domain,
 						     gfn_to_gpa(gfn));
 		if (pfn)
-			continue;
+			kvm_iommu_put_pages(kvm, gfn, 1);
 
 		pfn = gfn_to_pfn(kvm, gfn);
-		r = intel_iommu_page_mapping(domain,
-					     gfn_to_gpa(gfn),
-					     pfn_to_hpa(pfn),
-					     PAGE_SIZE,
-					     DMA_PTE_READ |
-					     DMA_PTE_WRITE);
+		r = intel_iommu_map_pages(domain,
+					  gfn_to_gpa(gfn),
+					  pfn_to_hpa(pfn),
+					  PAGE_SIZE,
+					  DMA_PTE_READ |
+					  DMA_PTE_WRITE);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_pages:"
 			       "iommu failed to map pfn=%lx\n", pfn);
@@ -86,50 +87,79 @@ static int kvm_iommu_map_memslots(struct kvm *kvm)
 	return r;
 }
 
-int kvm_iommu_map_guest(struct kvm *kvm,
-			struct kvm_assigned_dev_kernel *assigned_dev)
+int kvm_assign_device(struct kvm *kvm,
+		      struct kvm_assigned_dev_kernel *assigned_dev)
 {
 	struct pci_dev *pdev = NULL;
+	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
 	int r;
 
-	if (!intel_iommu_found()) {
-		printk(KERN_ERR "%s: intel iommu not found\n", __func__);
+	/* check if iommu exists and in use */
+	if (!domain)
+		return 0;
+
+	pdev = assigned_dev->dev;
+	if (pdev == NULL)
 		return -ENODEV;
+
+	r = intel_iommu_assign_device(domain, pdev);
+	if (r) {
+		printk(KERN_ERR "assign device %x:%x.%x failed",
+		       pdev->bus->number,
+		       PCI_SLOT(pdev->devfn),
+		       PCI_FUNC(pdev->devfn));
+		return r;
 	}
 
-	printk(KERN_DEBUG "VT-d direct map: host bdf = %x:%x:%x\n",
+	printk(KERN_DEBUG "assign device: host bdf = %x:%x:%x\n",
 	       assigned_dev->host_busnr,
 	       PCI_SLOT(assigned_dev->host_devfn),
 	       PCI_FUNC(assigned_dev->host_devfn));
 
+	return 0;
+}
+
+int kvm_deassign_device(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct pci_dev *pdev = NULL;
+
+	/* check if iommu exists and in use */
+	if (!domain)
+		return 0;
+
 	pdev = assigned_dev->dev;
+	if (pdev == NULL)
+		return -ENODEV;
 
-	if (pdev == NULL) {
-		if (kvm->arch.intel_iommu_domain) {
-			intel_iommu_domain_exit(kvm->arch.intel_iommu_domain);
-			kvm->arch.intel_iommu_domain = NULL;
-		}
+	intel_iommu_deassign_device(domain, pdev);
+
+	printk(KERN_DEBUG "deassign device: host bdf = %x:%x:%x\n",
+	       assigned_dev->host_busnr,
+	       PCI_SLOT(assigned_dev->host_devfn),
+	       PCI_FUNC(assigned_dev->host_devfn));
+
+	return 0;
+}
+
+int kvm_iommu_map_guest(struct kvm *kvm)
+{
+	int r;
+
+	if (!intel_iommu_found()) {
+		printk(KERN_ERR "%s: intel iommu not found\n", __func__);
 		return -ENODEV;
 	}
 
-	kvm->arch.intel_iommu_domain = intel_iommu_domain_alloc(pdev);
+	kvm->arch.intel_iommu_domain = intel_iommu_alloc_domain();
 	if (!kvm->arch.intel_iommu_domain)
-		return -ENODEV;
+		return -ENOMEM;
 
 	r = kvm_iommu_map_memslots(kvm);
 	if (r)
 		goto out_unmap;
 
-	intel_iommu_detach_dev(kvm->arch.intel_iommu_domain,
-			       pdev->bus->number, pdev->devfn);
-
-	r = intel_iommu_context_mapping(kvm->arch.intel_iommu_domain,
-					pdev);
-	if (r) {
-		printk(KERN_ERR "Domain context map for %s failed",
-		       pci_name(pdev));
-		goto out_unmap;
-	}
 	return 0;
 
 out_unmap:
@@ -138,12 +168,16 @@ out_unmap:
 }
 
 static void kvm_iommu_put_pages(struct kvm *kvm,
-			       gfn_t base_gfn, unsigned long npages)
+				gfn_t base_gfn, unsigned long npages)
 {
 	gfn_t gfn = base_gfn;
 	pfn_t pfn;
 	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
-	int i;
+	unsigned long i;
+
+	/* check if iommu exists and in use */
+	if (!domain)
+		return;
 
 	for (i = 0; i < npages; i++) {
 		pfn = (pfn_t)intel_iommu_iova_to_pfn(domain,
@@ -151,6 +185,10 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 		kvm_release_pfn_clean(pfn);
 		gfn++;
 	}
+
+	intel_iommu_unmap_pages(domain,
+				gfn_to_gpa(base_gfn),
+				PAGE_SIZE * npages);
 }
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
@@ -182,10 +220,9 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
 		       PCI_FUNC(entry->host_devfn));
 
 		/* detach kvm dmar domain */
-		intel_iommu_detach_dev(domain, entry->host_busnr,
-				       entry->host_devfn);
+		intel_iommu_deassign_device(domain, entry->dev);
 	}
 	kvm_iommu_unmap_memslots(kvm);
-	intel_iommu_domain_exit(domain);
+	intel_iommu_free_domain(domain);
 	return 0;
 }
-- 
1.5.6.4



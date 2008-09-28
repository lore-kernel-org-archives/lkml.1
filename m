Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYI1Pww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYI1Pww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYI1Pqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:46:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbYI1Pq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:46:28 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Ben-Ami Yassour <benami@il.ibm.com>
Subject: [PATCH 20/25] KVM: Device Assignment with VT-d
Date: Sun, 28 Sep 2008 18:44:56 +0300
Message-Id: <1222616701-1206-21-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben-Ami Yassour <benami@il.ibm.com>

Based on a patch by: Kay, Allen M <allen.m.kay@intel.com>

This patch enables PCI device assignment based on VT-d support.
When a device is assigned to the guest, the guest memory is pinned and
the mapping is updated in the VT-d IOMMU.

[Amit: Expose KVM_CAP_IOMMU so we can check if an IOMMU is present
and also control enable/disable from userspace]

Signed-off-by: Kay, Allen M <allen.m.kay@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Ben-Ami Yassour <benami@il.ibm.com>
Signed-off-by: Amit Shah <amit.shah@qumranet.com>

Acked-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/Makefile      |    3 +
 arch/x86/kvm/vtd.c         |  198 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c         |   14 +++
 include/asm-x86/kvm_host.h |   23 +-----
 include/linux/kvm.h        |    3 +
 include/linux/kvm_host.h   |   52 ++++++++++++
 virt/kvm/kvm_main.c        |    9 ++-
 7 files changed, 281 insertions(+), 21 deletions(-)
 create mode 100644 arch/x86/kvm/vtd.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index d0e940b..3072b17 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -12,6 +12,9 @@ EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
 
 kvm-objs := $(common-objs) x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
 	i8254.o
+ifeq ($(CONFIG_DMAR),y)
+kvm-objs += vtd.o
+endif
 obj-$(CONFIG_KVM) += kvm.o
 kvm-intel-objs = vmx.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
diff --git a/arch/x86/kvm/vtd.c b/arch/x86/kvm/vtd.c
new file mode 100644
index 0000000..667bf3f
--- /dev/null
+++ b/arch/x86/kvm/vtd.c
@@ -0,0 +1,198 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Copyright IBM Corporation, 2008
+ * Author: Allen M. Kay <allen.m.kay@intel.com>
+ * Author: Weidong Han <weidong.han@intel.com>
+ * Author: Ben-Ami Yassour <benami@il.ibm.com>
+ */
+
+#include <linux/list.h>
+#include <linux/kvm_host.h>
+#include <linux/pci.h>
+#include <linux/dmar.h>
+#include <linux/intel-iommu.h>
+
+static int kvm_iommu_unmap_memslots(struct kvm *kvm);
+static void kvm_iommu_put_pages(struct kvm *kvm,
+				gfn_t base_gfn, unsigned long npages);
+
+int kvm_iommu_map_pages(struct kvm *kvm,
+			gfn_t base_gfn, unsigned long npages)
+{
+	gfn_t gfn = base_gfn;
+	pfn_t pfn;
+	int i, r;
+	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+
+	/* check if iommu exists and in use */
+	if (!domain)
+		return 0;
+
+	r = -EINVAL;
+	for (i = 0; i < npages; i++) {
+		/* check if already mapped */
+		pfn = (pfn_t)intel_iommu_iova_to_pfn(domain,
+						     gfn_to_gpa(gfn));
+		if (pfn && !is_mmio_pfn(pfn))
+			continue;
+
+		pfn = gfn_to_pfn(kvm, gfn);
+		if (!is_mmio_pfn(pfn)) {
+			r = intel_iommu_page_mapping(domain,
+						     gfn_to_gpa(gfn),
+						     pfn_to_hpa(pfn),
+						     PAGE_SIZE,
+						     DMA_PTE_READ |
+						     DMA_PTE_WRITE);
+			if (r) {
+				printk(KERN_DEBUG "kvm_iommu_map_pages:"
+				       "iommu failed to map pfn=%lx\n", pfn);
+				goto unmap_pages;
+			}
+		} else {
+			printk(KERN_DEBUG "kvm_iommu_map_page:"
+			       "invalid pfn=%lx\n", pfn);
+			goto unmap_pages;
+		}
+		gfn++;
+	}
+	return 0;
+
+unmap_pages:
+	kvm_iommu_put_pages(kvm, base_gfn, i);
+	return r;
+}
+
+static int kvm_iommu_map_memslots(struct kvm *kvm)
+{
+	int i, r;
+
+	down_read(&kvm->slots_lock);
+	for (i = 0; i < kvm->nmemslots; i++) {
+		r = kvm_iommu_map_pages(kvm, kvm->memslots[i].base_gfn,
+					kvm->memslots[i].npages);
+		if (r)
+			break;
+	}
+	up_read(&kvm->slots_lock);
+	return r;
+}
+
+int kvm_iommu_map_guest(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *assigned_dev)
+{
+	struct pci_dev *pdev = NULL;
+	int r;
+
+	if (!intel_iommu_found()) {
+		printk(KERN_ERR "%s: intel iommu not found\n", __func__);
+		return -ENODEV;
+	}
+
+	printk(KERN_DEBUG "VT-d direct map: host bdf = %x:%x:%x\n",
+	       assigned_dev->host_busnr,
+	       PCI_SLOT(assigned_dev->host_devfn),
+	       PCI_FUNC(assigned_dev->host_devfn));
+
+	pdev = assigned_dev->dev;
+
+	if (pdev == NULL) {
+		if (kvm->arch.intel_iommu_domain) {
+			intel_iommu_domain_exit(kvm->arch.intel_iommu_domain);
+			kvm->arch.intel_iommu_domain = NULL;
+		}
+		return -ENODEV;
+	}
+
+	kvm->arch.intel_iommu_domain = intel_iommu_domain_alloc(pdev);
+	if (!kvm->arch.intel_iommu_domain)
+		return -ENODEV;
+
+	r = kvm_iommu_map_memslots(kvm);
+	if (r)
+		goto out_unmap;
+
+	intel_iommu_detach_dev(kvm->arch.intel_iommu_domain,
+			       pdev->bus->number, pdev->devfn);
+
+	r = intel_iommu_context_mapping(kvm->arch.intel_iommu_domain,
+					pdev);
+	if (r) {
+		printk(KERN_ERR "Domain context map for %s failed",
+		       pci_name(pdev));
+		goto out_unmap;
+	}
+	return 0;
+
+out_unmap:
+	kvm_iommu_unmap_memslots(kvm);
+	return r;
+}
+
+static void kvm_iommu_put_pages(struct kvm *kvm,
+			       gfn_t base_gfn, unsigned long npages)
+{
+	gfn_t gfn = base_gfn;
+	pfn_t pfn;
+	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	int i;
+
+	for (i = 0; i < npages; i++) {
+		pfn = (pfn_t)intel_iommu_iova_to_pfn(domain,
+						     gfn_to_gpa(gfn));
+		kvm_release_pfn_clean(pfn);
+		gfn++;
+	}
+}
+
+static int kvm_iommu_unmap_memslots(struct kvm *kvm)
+{
+	int i;
+	down_read(&kvm->slots_lock);
+	for (i = 0; i < kvm->nmemslots; i++) {
+		kvm_iommu_put_pages(kvm, kvm->memslots[i].base_gfn,
+				    kvm->memslots[i].npages);
+	}
+	up_read(&kvm->slots_lock);
+
+	return 0;
+}
+
+int kvm_iommu_unmap_guest(struct kvm *kvm)
+{
+	struct kvm_assigned_dev_kernel *entry;
+	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+
+	/* check if iommu exists and in use */
+	if (!domain)
+		return 0;
+
+	list_for_each_entry(entry, &kvm->arch.assigned_dev_head, list) {
+		printk(KERN_DEBUG "VT-d unmap: host bdf = %x:%x:%x\n",
+		       entry->host_busnr,
+		       PCI_SLOT(entry->host_devfn),
+		       PCI_FUNC(entry->host_devfn));
+
+		/* detach kvm dmar domain */
+		intel_iommu_detach_dev(domain, entry->host_busnr,
+				       entry->host_devfn);
+	}
+	kvm_iommu_unmap_memslots(kvm);
+	intel_iommu_domain_exit(domain);
+	return 0;
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2134f3e..c8a2793 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/highmem.h>
+#include <linux/intel-iommu.h>
 
 #include <asm/uaccess.h>
 #include <asm/msr.h>
@@ -277,9 +278,18 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 
 	list_add(&match->list, &kvm->arch.assigned_dev_head);
 
+	if (assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU) {
+		r = kvm_iommu_map_guest(kvm, match);
+		if (r)
+			goto out_list_del;
+	}
+
 out:
 	mutex_unlock(&kvm->lock);
 	return r;
+out_list_del:
+	list_del(&match->list);
+	pci_release_regions(dev);
 out_disable:
 	pci_disable_device(dev);
 out_put:
@@ -1147,6 +1157,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_PV_MMU:
 		r = !tdp_enabled;
 		break;
+	case KVM_CAP_IOMMU:
+		r = intel_iommu_found();
+		break;
 	default:
 		r = 0;
 		break;
@@ -4282,6 +4295,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	kvm_iommu_unmap_guest(kvm);
 	kvm_free_assigned_devices(kvm);
 	kvm_free_pit(kvm);
 	kfree(kvm->arch.vpic);
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 815efc3..d1175b8 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -331,26 +331,6 @@ struct kvm_mem_alias {
 	gfn_t target_gfn;
 };
 
-struct kvm_irq_ack_notifier {
-	struct hlist_node link;
-	unsigned gsi;
-	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
-};
-
-struct kvm_assigned_dev_kernel {
-	struct kvm_irq_ack_notifier ack_notifier;
-	struct work_struct interrupt_work;
-	struct list_head list;
-	int assigned_dev_id;
-	int host_busnr;
-	int host_devfn;
-	int host_irq;
-	int guest_irq;
-	int irq_requested;
-	struct pci_dev *dev;
-	struct kvm *kvm;
-};
-
 struct kvm_arch{
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
@@ -364,6 +344,7 @@ struct kvm_arch{
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head assigned_dev_head;
+	struct dmar_domain *intel_iommu_domain;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
@@ -514,6 +495,8 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 		  gpa_t addr, unsigned long *ret);
 
+int is_mmio_pfn(pfn_t pfn);
+
 extern bool tdp_enabled;
 
 enum emulation_result {
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ef4bc6f..4269be1 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -384,6 +384,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_COALESCED_MMIO 15
 #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
 #define KVM_CAP_DEVICE_ASSIGNMENT 17
+#define KVM_CAP_IOMMU 18
 
 /*
  * ioctls for VM fds
@@ -495,4 +496,6 @@ struct kvm_assigned_irq {
 	__u32 flags;
 };
 
+#define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
+
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4b03643..6252802 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -286,6 +286,53 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
+struct kvm_irq_ack_notifier {
+	struct hlist_node link;
+	unsigned gsi;
+	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
+};
+
+struct kvm_assigned_dev_kernel {
+	struct kvm_irq_ack_notifier ack_notifier;
+	struct work_struct interrupt_work;
+	struct list_head list;
+	int assigned_dev_id;
+	int host_busnr;
+	int host_devfn;
+	int host_irq;
+	int guest_irq;
+	int irq_requested;
+	struct pci_dev *dev;
+	struct kvm *kvm;
+};
+
+#ifdef CONFIG_DMAR
+int kvm_iommu_map_pages(struct kvm *kvm, gfn_t base_gfn,
+			unsigned long npages);
+int kvm_iommu_map_guest(struct kvm *kvm,
+			struct kvm_assigned_dev_kernel *assigned_dev);
+int kvm_iommu_unmap_guest(struct kvm *kvm);
+#else /* CONFIG_DMAR */
+static inline int kvm_iommu_map_pages(struct kvm *kvm,
+				      gfn_t base_gfn,
+				      unsigned long npages)
+{
+	return 0;
+}
+
+static inline int kvm_iommu_map_guest(struct kvm *kvm,
+				      struct kvm_assigned_dev_kernel
+				      *assigned_dev)
+{
+	return -ENODEV;
+}
+
+static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
+{
+	return 0;
+}
+#endif /* CONFIG_DMAR */
+
 static inline void kvm_guest_enter(void)
 {
 	account_system_vtime(current);
@@ -308,6 +355,11 @@ static inline gpa_t gfn_to_gpa(gfn_t gfn)
 	return (gpa_t)gfn << PAGE_SHIFT;
 }
 
+static inline hpa_t pfn_to_hpa(pfn_t pfn)
+{
+	return (hpa_t)pfn << PAGE_SHIFT;
+}
+
 static inline void kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	set_bit(KVM_REQ_MIGRATE_TIMER, &vcpu->requests);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 63e661b..f42d5c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -41,6 +41,7 @@
 #include <linux/pagemap.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
+#include <linux/intel-iommu.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -76,7 +77,7 @@ static inline int valid_vcpu(int n)
 	return likely(n >= 0 && n < KVM_MAX_VCPUS);
 }
 
-static inline int is_mmio_pfn(pfn_t pfn)
+inline int is_mmio_pfn(pfn_t pfn)
 {
 	if (pfn_valid(pfn))
 		return PageReserved(pfn_to_page(pfn));
@@ -578,6 +579,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	kvm_free_physmem_slot(&old, &new);
+
+	/* map the pages in iommu page table */
+	r = kvm_iommu_map_pages(kvm, base_gfn, npages);
+	if (r)
+		goto out;
+
 	return 0;
 
 out_free:
-- 
1.6.0.1


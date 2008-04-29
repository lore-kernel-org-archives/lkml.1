Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbYD2Kij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbYD2Kij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYD2Khg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:37:36 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:10901
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYD2Khd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:37:33 -0400
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: virtualization@lists.linux-foundation.org, muli@il.ibm.com,
       BENAMI@il.ibm.com, gcosta@redhat.com, chrisw@redhat.com,
       dor.laor@qumranet.com, allen.m.kay@intel.com, avi@qumranet.com,
       linux-kernel@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH] KVM PV Guest: Implement paravirtualized DMA
Date: Tue, 29 Apr 2008 13:37:31 +0300
Message-Id: <1209465451-3758-4-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1209465451-3758-3-git-send-email-amit.shah@qumranet.com>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com>
 <1209465451-3758-2-git-send-email-amit.shah@qumranet.com>
 <1209465451-3758-3-git-send-email-amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We make the dma_mapping_ops structure to point to our structure
so that every DMA access goes through us.

We make a hypercall for every device that does a DMA operation
to find out if it is an assigned device -- so that we can make
hypercalls on each DMA access. The result of this hypercall is
cached, so that this hypercall is made only once for each device

This can be compiled as a module, but that's only used for debugging.
It can be compiled into the guest kernel directly without any side
effects (if you ignore one error message about the hypercall
failing for hard disks).

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 arch/x86/Kconfig             |    8 +
 arch/x86/kernel/Makefile     |    1 +
 arch/x86/kernel/kvm_pv_dma.c |  391 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 400 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/kvm_pv_dma.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e5790fe..aad16d9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -392,6 +392,14 @@ config KVM_GUEST
 	 This option enables various optimizations for running under the KVM
 	 hypervisor.
 
+config KVM_PV_DMA
+	tristate "KVM paravirtualized DMA access"
+	---help---
+	Provides support for DMA operations in the guest. A hypercall
+	is raised to the host to enable devices owned by guest to use
+	DMA. Select this if compiling a guest kernel and you need
+	paravirtualized DMA operations.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index fa19c38..0adb37b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
+obj-$(CONFIG_KVM_PV_DMA)	+= kvm_pv_dma.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 
 ifdef CONFIG_INPUT_PCSPKR
diff --git a/arch/x86/kernel/kvm_pv_dma.c b/arch/x86/kernel/kvm_pv_dma.c
new file mode 100644
index 0000000..db83324
--- /dev/null
+++ b/arch/x86/kernel/kvm_pv_dma.c
@@ -0,0 +1,391 @@
+/*
+ * KVM guest DMA para-virtualization driver
+ *
+ * Copyright (C) 2007, Qumranet, Inc., Amit Shah <amit.shah@qumranet.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ */
+
+#include <asm/page.h>
+#include <linux/io.h>
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/miscdevice.h>
+#include <linux/kvm_para.h>
+
+MODULE_AUTHOR("Amit Shah");
+MODULE_DESCRIPTION("Implements guest para-virtualized DMA");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1");
+
+#define KVM_DMA_MINOR MISC_DYNAMIC_MINOR
+
+static struct page *page;
+static unsigned long page_gfn;
+
+const struct dma_mapping_ops *orig_dma_ops;
+
+#include <linux/list.h>
+struct pv_passthrough_dev_list {
+	struct list_head list;
+	struct kvm_pci_pt_info pv_pci_info;
+	int is_pv;
+};
+static LIST_HEAD(pt_devs_head);
+
+static struct pv_passthrough_dev_list*
+find_matching_pt_dev(struct list_head *head,
+		     struct kvm_pci_pt_info *pv_pci_info)
+{
+	struct list_head *ptr;
+	struct pv_passthrough_dev_list *match;
+
+	list_for_each(ptr, head) {
+		match = list_entry(ptr, struct pv_passthrough_dev_list, list);
+		if (match &&
+		    (match->pv_pci_info.busnr == pv_pci_info->busnr) &&
+		    (match->pv_pci_info.devfn == pv_pci_info->devfn))
+			return match;
+	}
+	return NULL;
+}
+
+void empty_pt_dev_list(struct list_head *head)
+{
+	struct pv_passthrough_dev_list *match;
+
+	while (!list_empty(head)) {
+		match = list_entry(head->next, \
+				   struct pv_passthrough_dev_list, list);
+		list_del(&match->list);
+	}
+}
+
+static int kvm_is_pv_device(struct device *dev, const char *name)
+{
+	int r;
+	struct pci_dev *pci_dev;
+	struct kvm_pci_pt_info pv_pci_info;
+	struct pv_passthrough_dev_list *match;
+
+	pci_dev = to_pci_dev(dev);
+	pv_pci_info.busnr = pci_dev->bus->number;
+	pv_pci_info.devfn = pci_dev->devfn;
+
+	match = find_matching_pt_dev(&pt_devs_head, &pv_pci_info);
+	if (match) {
+		r = match->is_pv;
+		goto out;
+	}
+
+	memcpy(page_address(page), &pv_pci_info, sizeof(pv_pci_info));
+	r = kvm_hypercall1(KVM_PV_PCI_DEVICE, page_gfn);
+	if (r < 1) {
+		printk(KERN_INFO "%s: Error doing hypercall!\n", __func__);
+		r = 0;
+		goto out;
+	}
+
+	match = kmalloc(sizeof(struct pv_passthrough_dev_list), GFP_KERNEL);
+	if (match == NULL) {
+		printk(KERN_INFO "%s: Out of memory\n", __func__);
+		r = 0;
+		goto out;
+	}
+	match->pv_pci_info.busnr = pv_pci_info.busnr;
+	match->pv_pci_info.devfn = pv_pci_info.devfn;
+	match->is_pv = r;
+	list_add(&match->list, &pt_devs_head);
+ out:
+	return r;
+}
+
+static void *kvm_dma_map(void *vaddr, size_t size, dma_addr_t *dma_handle)
+{
+	int npages, i;
+	unsigned long *dma_addr;
+	dma_addr_t host_addr = bad_dma_address;
+
+	if (page == NULL)
+		goto out;
+
+	npages = get_order(size) + 1;
+	dma_addr = page_address(page);
+
+	/* We have to take into consideration the offsets for the
+	 * virtual address provided by the calling
+	 * functions. Currently both, pci_alloc_consistent and
+	 * pci_map_single call this function. We have to change it so
+	 * that we can also pass to the host the offset of the addr in
+	 * the page it is in.
+	 */
+
+	if (*dma_handle == bad_dma_address)
+		goto out;
+
+	/* It's not really OK to use dma_handle here, as the IOMMU or
+	 * swiotlb could have mapped it elsewhere. But what's a better
+	 * solution?
+	 */
+	*dma_addr++ = *dma_handle;
+	if (npages > 1) {
+		/* All of the pages will be contiguous in guest
+		 * physical memory in both, pci_map_consistent and
+		 * pci_map_single cases (see DMA-API.txt)
+		 */
+		/* FIXME: we're currently not crossing over to
+		 * multiple pages to be sent to host, in case
+		 * we have a lot of pages that we can't
+		 * accomodate in one page.
+		 */
+		for (i = 1; i < min((unsigned long)npages, MAX_PVDMA_PAGES); i++)
+			*dma_addr++ = virt_to_phys(vaddr + PAGE_SIZE * i);
+	}
+
+	/* Maybe we need more arguments (we have first two):
+	 * @npages: number of gpas pages in this hypercall
+	 * @page: page we pass to host with all the gpas in them
+	 * @more: are there any more pages coming?
+	 * @offset: offset of the address in the first page
+	 * @direction: direction for the mapping (only for pci_map_single)
+	 */
+	npages = kvm_hypercall2(KVM_PV_DMA_MAP, npages, page_gfn);
+	if (!npages)
+		host_addr = bad_dma_address;
+	else
+		host_addr = *(unsigned long *)page_address(page);
+
+ out:
+	*dma_handle = host_addr;
+	if (host_addr == bad_dma_address)
+		vaddr = NULL;
+	return vaddr;
+}
+
+static void kvm_dma_unmap(dma_addr_t dma_handle)
+{
+	kvm_hypercall1(KVM_PV_DMA_UNMAP, dma_handle);
+	return;
+}
+
+static void *kvm_dma_alloc_coherent(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *vaddr = NULL;
+	if ((*dma_handle == bad_dma_address)
+	    || !dma_ops->is_pv_device(dev, dev->bus_id))
+		goto out;
+
+	vaddr = bus_to_virt(*(unsigned long *)dma_handle);
+	vaddr = kvm_dma_map(vaddr, size, dma_handle);
+ out:
+	return vaddr;
+}
+
+static void kvm_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+				  dma_addr_t dma_handle)
+{
+	kvm_dma_unmap(dma_handle);
+}
+
+static dma_addr_t kvm_dma_map_single(struct device *dev, phys_addr_t paddr,
+				     size_t size, int direction)
+{
+	dma_addr_t r;
+
+	r = orig_dma_ops->map_single(dev, paddr, size, direction);
+
+	if (r != bad_dma_address && kvm_is_pv_device(dev, dev->bus_id))
+		kvm_dma_map(phys_to_virt(paddr), size, &r);
+	return r;
+}
+
+static inline void kvm_dma_unmap_single(struct device *dev, dma_addr_t addr,
+					size_t size, int direction)
+{
+	kvm_dma_unmap(addr);
+}
+
+int kvm_pv_dma_mapping_error(dma_addr_t dma_addr)
+{
+	if (orig_dma_ops->mapping_error)
+		return orig_dma_ops->mapping_error(dma_addr);
+
+	printk(KERN_ERR "%s: Unhandled PV DMA operation. Report this.\n",
+	       __func__);
+	return dma_addr == bad_dma_address;
+}
+
+/* like map_single, but doesn't check the device mask */
+dma_addr_t kvm_pv_dma_map_simple(struct device *hwdev, phys_addr_t paddr,
+				 size_t size, int direction)
+{
+	return orig_dma_ops->map_simple(hwdev, paddr, size, direction);
+}
+
+void kvm_pv_dma_sync_single_for_cpu(struct device *hwdev,
+				    dma_addr_t dma_handle, size_t size,
+				    int direction)
+{
+	if (orig_dma_ops->sync_single_for_cpu)
+		orig_dma_ops->sync_single_for_cpu(hwdev, dma_handle,
+						  size, direction);
+}
+
+void kvm_pv_dma_sync_single_for_device(struct device *hwdev,
+				       dma_addr_t dma_handle, size_t size,
+				       int direction)
+{
+	if (orig_dma_ops->sync_single_for_device)
+		orig_dma_ops->sync_single_for_device(hwdev, dma_handle,
+						     size, direction);
+}
+
+void kvm_pv_dma_sync_single_range_for_cpu(struct device *hwdev,
+					  dma_addr_t dma_handle,
+					  unsigned long offset,
+					  size_t size, int direction)
+{
+	if (orig_dma_ops->sync_single_range_for_cpu)
+		orig_dma_ops->sync_single_range_for_cpu(hwdev, dma_handle,
+							offset, size,
+							direction);
+}
+
+void kvm_pv_dma_sync_single_range_for_device(struct device *hwdev,
+					     dma_addr_t dma_handle,
+					     unsigned long offset,
+					     size_t size, int direction)
+{
+	if (orig_dma_ops->sync_single_range_for_device)
+		orig_dma_ops->sync_single_range_for_device(hwdev, dma_handle,
+							   offset, size,
+							   direction);
+}
+
+void kvm_pv_dma_sync_sg_for_cpu(struct device *hwdev,
+		     struct scatterlist *sg, int nelems,
+		     int direction)
+{
+	if (orig_dma_ops->sync_sg_for_cpu)
+		orig_dma_ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
+}
+
+void kvm_pv_dma_sync_sg_for_device(struct device *hwdev,
+				   struct scatterlist *sg, int nelems,
+				   int direction)
+{
+	if (orig_dma_ops->sync_sg_for_device)
+		orig_dma_ops->sync_sg_for_device(hwdev, sg, nelems, direction);
+}
+
+int kvm_pv_dma_map_sg(struct device *hwdev, struct scatterlist *sg,
+		      int nents, int direction)
+{
+	return orig_dma_ops->map_sg(hwdev, sg, nents, direction);
+	printk(KERN_ERR "%s: Unhandled PV DMA operation. Report this.\n",
+	       __func__);
+	return 0;
+}
+
+void kvm_pv_dma_unmap_sg(struct device *hwdev,
+			 struct scatterlist *sg, int nents,
+			 int direction)
+{
+	if (orig_dma_ops->unmap_sg)
+		orig_dma_ops->unmap_sg(hwdev, sg, nents, direction);
+}
+
+int kvm_pv_dma_dma_supported(struct device *hwdev, u64 mask)
+{
+	if (orig_dma_ops->dma_supported)
+		return orig_dma_ops->dma_supported(hwdev, mask);
+	printk(KERN_ERR "%s: Unhandled PV DMA operation. Report this.\n",
+	       __func__);
+	return 0;
+}
+
+static const struct dma_mapping_ops kvm_dma_ops = {
+	.alloc_coherent	= kvm_dma_alloc_coherent,
+	.free_coherent	= kvm_dma_free_coherent,
+	.map_single	= kvm_dma_map_single,
+	.unmap_single	= kvm_dma_unmap_single,
+	.is_pv_device	= kvm_is_pv_device,
+
+	.mapping_error  = kvm_pv_dma_mapping_error,
+	.map_simple	= kvm_pv_dma_map_simple,
+	.sync_single_for_cpu = kvm_pv_dma_sync_single_for_cpu,
+	.sync_single_for_device = kvm_pv_dma_sync_single_for_device,
+	.sync_single_range_for_cpu = kvm_pv_dma_sync_single_range_for_cpu,
+	.sync_single_range_for_device = kvm_pv_dma_sync_single_range_for_device,
+	.sync_sg_for_cpu = kvm_pv_dma_sync_sg_for_cpu,
+	.sync_sg_for_device = kvm_pv_dma_sync_sg_for_device,
+	.map_sg		= kvm_pv_dma_map_sg,
+	.unmap_sg	= kvm_pv_dma_unmap_sg,
+};
+
+static struct file_operations dma_chardev_ops;
+static struct miscdevice kvm_dma_dev = {
+	KVM_DMA_MINOR,
+	"kvm_dma",
+	&dma_chardev_ops,
+};
+
+int __init kvm_pv_dma_init(void)
+{
+	int r;
+
+	dma_chardev_ops.owner = THIS_MODULE;
+	if (misc_register(&kvm_dma_dev)) {
+		printk(KERN_ERR "%s: misc device register failed\n",
+		       __func__);
+		r = -EBUSY;
+		goto out;
+	}
+	if (!kvm_para_available()) {
+		printk(KERN_ERR "KVM paravirt support not available\n");
+		r = -ENODEV;
+		goto out_dereg;
+	}
+
+	/* FIXME: check for hypercall support */
+	page = alloc_page(GFP_ATOMIC);
+	if (page == NULL) {
+		printk(KERN_ERR "%s: Could not allocate page\n", __func__);
+		r = -ENOMEM;
+		goto out_dereg;
+	}
+	page_gfn = page_to_pfn(page);
+
+	orig_dma_ops = dma_ops;
+	dma_ops = &kvm_dma_ops;
+
+	printk(KERN_INFO "KVM PV DMA engine registered\n");
+	return 0;
+	goto out;
+	goto out_free;
+
+ out_free:
+	__free_page(page);
+ out_dereg:
+	misc_deregister(&kvm_dma_dev);
+ out:
+	return r;
+}
+
+static void __exit kvm_pv_dma_exit(void)
+{
+	dma_ops = orig_dma_ops;
+
+	__free_page(page);
+
+	empty_pt_dev_list(&pt_devs_head);
+
+	misc_deregister(&kvm_dma_dev);
+}
+
+module_init(kvm_pv_dma_init);
+module_exit(kvm_pv_dma_exit);
-- 
1.5.4.3


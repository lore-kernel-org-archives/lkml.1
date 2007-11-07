Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbXKGOVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbXKGOVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbXKGOUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:45 -0500
Received: from il.qumranet.com ([82.166.9.18]:50637 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649AbXKGOUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:41 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 3/8] KVM: PVDMA Guest: Guest-side routines for paravirtualized DMA
Date: Wed,  7 Nov 2007 16:21:04 +0200
Message-Id: <11944452694052-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11944452692774-git-send-email-amit.shah@qumranet.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
 <11944452691714-git-send-email-amit.shah@qumranet.com>
 <11944452692774-git-send-email-amit.shah@qumranet.com>
Message-Id: <609d5d611a5fb58ab5a7184be7b6d29494023ba0.1194445109.git.amit.shah@qumranet.com>
In-Reply-To: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We make the dma_mapping_ops structure to point to our structure
so that every DMA access goes through us. (This is the reason this
only works for 64-bit guest. 32-bit guest doesn't yet have a dma_ops
struct.)

We make a hypercall for every device that does a DMA operation
to find out if it is a passthroughed device -- so that we can
make hypercalls on each DMA access. The result of this hypercall
is cached, so that this hypercall is made only once for each device

Right now, this only works as a module: compiling it in causes
it to freeze during the HD bring-up.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 drivers/kvm/kvm_pv_dma.c |  398 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 398 insertions(+), 0 deletions(-)
 create mode 100644 drivers/kvm/kvm_pv_dma.c

diff --git a/drivers/kvm/kvm_pv_dma.c b/drivers/kvm/kvm_pv_dma.c
new file mode 100644
index 0000000..8d98d98
--- /dev/null
+++ b/drivers/kvm/kvm_pv_dma.c
@@ -0,0 +1,398 @@
+/*
+ * KVM guest DMA para-virtualization driver
+ *
+ * Copyright (C) 2007, Qumranet, Inc., Amit Shah <amit.shah@qumranet.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ */
+
+#include <asm/io.h>
+#include <asm/page.h>
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
+	struct kvm_pv_pci_info pv_pci_info;
+	int is_pv;
+};
+static LIST_HEAD(pt_devs_head);
+
+static struct pv_passthrough_dev_list*
+find_matching_pt_dev(struct list_head *head,
+		     struct kvm_pv_pci_info *pv_pci_info)
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
+void
+empty_pt_dev_list(struct list_head *head)
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
+static int
+kvm_is_pv_device(struct device *dev, const char *name)
+{
+	int r;
+	struct pci_dev *pci_dev;
+	struct kvm_pv_pci_info pv_pci_info;
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
+		printk(KERN_INFO "%s: Errror doing hypercall!\n", __FUNCTION__);
+		r = 0;
+		goto out;
+	}
+
+	match = kmalloc(sizeof(struct pv_passthrough_dev_list), GFP_KERNEL);
+	if (match == NULL) {
+		printk(KERN_INFO "%s: Out of memory\n", __FUNCTION__);
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
+static void *
+kvm_dma_map(void *vaddr, size_t size, dma_addr_t *dma_handle)
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
+static void
+kvm_dma_unmap(dma_addr_t dma_handle)
+{
+	kvm_hypercall1(KVM_PV_DMA_UNMAP, dma_handle);
+	return;
+}
+
+static void *
+kvm_dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		       gfp_t gfp)
+{
+	void *vaddr = NULL;
+	if ((*dma_handle == bad_dma_address)
+	    || !dma_ops->is_pv_device(dev, dev->bus_id))
+		goto out;
+
+	vaddr = bus_to_virt((unsigned long)dma_handle);
+	vaddr = kvm_dma_map(vaddr, size, dma_handle);
+ out:
+	return vaddr;
+}
+
+static void
+kvm_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+		      dma_addr_t dma_handle)
+{
+	kvm_dma_unmap(dma_handle);
+}
+
+static dma_addr_t
+kvm_dma_map_single(struct device *dev, void *ptr, size_t size, int direction)
+{
+	dma_addr_t r;
+
+	r = orig_dma_ops->map_single(dev, ptr, size, direction);
+
+	if (r != bad_dma_address && kvm_is_pv_device(dev, dev->bus_id))
+		kvm_dma_map(ptr, size, &r);
+	return r;
+}
+
+static inline void
+kvm_dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
+		     int direction)
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
+	       __FUNCTION__);
+	return dma_addr == bad_dma_address;
+}
+
+/* like map_single, but doesn't check the device mask */
+dma_addr_t kvm_pv_dma_map_simple(struct device *hwdev, char *ptr,
+				 size_t size, int direction)
+{
+	return orig_dma_ops->map_simple(hwdev, ptr, size, direction);
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
+	       __FUNCTION__);
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
+	       __FUNCTION__);
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
+		       __FUNCTION__);
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
+		printk(KERN_ERR "%s: Could not allocate page\n", __FUNCTION__);
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
1.5.3


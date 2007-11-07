Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbXKGOVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbXKGOVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbXKGOUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:43 -0500
Received: from il.qumranet.com ([82.166.9.18]:50634 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536AbXKGOUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:41 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 1/8] KVM: PVDMA Host: Handle reqeusts for guest DMA mappings
Date: Wed,  7 Nov 2007 16:21:02 +0200
Message-Id: <11944452691714-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1194445269752-git-send-email-amit.shah@qumranet.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
Message-Id: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce three hypercalls and one ioctl for enabling guest
DMA mappings.

An ioctl comes from userspace (qemu) to notify of a physical
device being assigned to a guest. Guests make a hypercall (once
per device) to find out if the device is a passthrough device
and if any DMA translations are necessary.

Two other hypercalls map and unmap DMA regions respectively
for the guest. We basically look up the host page address
and return it in case of a single-page request.

For a multi-page request, we do a dma_map_sg.

Since guests are pageable, we pin all the pages under the DMA
operation on the map request and unpin them on the unmap
operation.

Major tasks still to be done: implement proper locking (get a
vm-lock), we never free some part of memory

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 drivers/kvm/x86.c          |  273 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kvm_para.h |   23 ++++-
 include/linux/kvm.h        |    3 +
 3 files changed, 297 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index e905d46..60ea93a 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -21,8 +21,11 @@
 
 #include <linux/kvm.h>
 #include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 
@@ -61,6 +64,254 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+/* Paravirt DMA: We pin the host-side pages for the GPAs that we get
+ * for the DMA operation. We do a sg_map on the host pages for a DMA
+ * operation on the guest side. We un-pin the pages on the
+ * unmap_hypercall.
+ */
+struct dma_map {
+	struct list_head list;
+	int nents;
+	struct scatterlist *sg;
+};
+
+/* This list is to store the guest bus:device:function and host
+ * bus:device:function mapping for passthrough'ed devices.
+ */
+/* FIXME: make this per-vm */
+/* FIXME: delete this list at the end of a vm session */
+struct pv_pci_dev_list {
+	struct list_head list;
+	struct kvm_pv_passthrough_dev pt_dev;
+};
+
+/* FIXME: This should be a per-vm list */
+static LIST_HEAD(dmap_head);
+static LIST_HEAD(pt_dev_head);
+
+static struct dma_map*
+find_matching_dmap(struct list_head *head, dma_addr_t dma)
+{
+	struct list_head *ptr;
+	struct dma_map *match;
+
+	list_for_each(ptr, head) {
+		match = list_entry(ptr, struct dma_map, list);
+		if (match && match->sg[0].dma_address == dma)
+			return match;
+	}
+	return NULL;
+}
+
+static void
+prepare_sg_entry(struct scatterlist *sg, unsigned long addr)
+{
+	unsigned int offset, len;
+
+	offset = addr & ~PAGE_MASK;
+	len = PAGE_SIZE - offset;
+
+	/* FIXME: Use the sg chaining features */
+	sg_set_page(sg, pfn_to_page(addr >> PAGE_SHIFT),
+		    len, offset);
+}
+
+static int pv_map_hypercall(struct kvm_vcpu *vcpu, int npages, gfn_t page_gfn)
+{
+	int i, r = 0;
+	gpa_t gpa;
+	hpa_t page_hpa, hpa;
+	struct dma_map *dmap;
+	struct page *host_page;
+	struct scatterlist *sg;
+	unsigned long *shared_addr, *hcall_page;
+
+	/* We currently don't support dma mappings which have more than
+	 * PAGE_SIZE/sizeof(unsigned long *) pages
+	 */
+	if (!npages || npages > MAX_PVDMA_PAGES) {
+		printk(KERN_INFO "%s: Illegal number of pages: %d\n",
+		       __FUNCTION__, npages);
+		goto out;
+	}
+
+	page_hpa = gpa_to_hpa(vcpu->kvm, page_gfn << PAGE_SHIFT);
+	if (is_error_hpa(page_hpa)) {
+		printk(KERN_INFO "%s: page hpa %p not valid for page_gfn %p\n",
+		       __FUNCTION__, (void *)page_hpa, (void *)page_gfn);
+		goto out;
+	}
+	host_page = pfn_to_page(page_hpa >> PAGE_SHIFT);
+	hcall_page = shared_addr = kmap(host_page);
+
+	/* scatterlist to map guest dma pages into host physical
+	 * memory -- if they exceed the DMA map limit
+	 */
+	sg = kcalloc(npages, sizeof(struct scatterlist), GFP_KERNEL);
+	if (sg == NULL) {
+		printk(KERN_INFO "%s: Couldn't allocate memory (sg)\n",
+		       __FUNCTION__);
+		goto out_unmap;
+	}
+
+	/* List to store all guest pages mapped into host. This will
+	 * be used later to free pages on the host. Think of this as a
+	 * translation table from guest dma addresses into host dma
+	 * addresses
+	 */
+	dmap = kmalloc(sizeof(struct dma_map), GFP_KERNEL);
+	if (dmap == NULL) {
+		printk(KERN_INFO "%s: Couldn't allocate memory\n",
+		       __FUNCTION__);
+		goto out_unmap_sg;
+	}
+
+	/* FIXME: consider the length of the last page. Guest should
+	 * send this info.
+	 */
+	for (i = 0; i < npages; i++) {
+		gpa = *shared_addr++;
+		hpa = gpa_to_hpa(vcpu->kvm, gpa);
+		if (is_error_hpa(hpa)) {
+			int j;
+			printk(KERN_INFO "kvm %s: hpa %p not valid "
+			       "for gpa %p\n",
+			       __FUNCTION__, (void *)gpa, (void *)hpa);
+
+			for (j = 0; j < i; j++)
+				put_page(sg_page(&sg[j]));
+			goto out_unmap_sg;
+		}
+		prepare_sg_entry(&sg[i], hpa);
+		get_page(sg_page(&sg[i]));
+	}
+
+	/* Put this on the dmap_head list, so that we can find it
+	 * later for the 'free' operation
+	 */
+	dmap->sg = sg;
+	dmap->nents = npages;
+	list_add(&dmap->list, &dmap_head);
+
+	/* FIXME: guest should send the direction */
+	r = dma_ops->map_sg(NULL, sg, npages, PCI_DMA_BIDIRECTIONAL);
+	if (r) {
+		r = npages;
+		*hcall_page = sg[0].dma_address;
+	}
+
+ out_unmap:
+	if (!r)
+		*hcall_page = bad_dma_address;
+	kunmap(host_page);
+ out:
+	return r;
+ out_unmap_sg:
+	kfree(dmap);
+	kfree(sg);
+	goto out_unmap;
+}
+
+/* FIXME: the argument passed from guest can be 32-bit. We need 64-bit for
+ * dma_addr_t. Send the dma address in a page.
+ */
+static int pv_unmap_hypercall(struct kvm_vcpu *vcpu, dma_addr_t dma)
+{
+	int i, r = 0;
+	struct dma_map *dmap;
+
+	/* dma is the address we have to 'unmap'. Check if it exists
+	 * in the dma_map list. If yes, free it.
+	 */
+	dmap = find_matching_dmap(&dmap_head, dma);
+	if (dmap) {
+		for (i = 0; i < dmap->nents; i++)
+			put_page(sg_page(&dmap->sg[i]));
+
+		dma_ops->unmap_sg(NULL, dmap->sg, dmap->nents,
+				  PCI_DMA_BIDIRECTIONAL);
+		kfree(dmap->sg);
+		list_del(&dmap->list);
+	} else
+		r = 1;
+
+	return r;
+}
+
+static struct pv_pci_dev_list*
+find_matching_pt_dev(struct list_head *head,
+		     struct kvm_pv_pci_info *pv_pci_info)
+{
+	struct list_head *ptr;
+	struct pv_pci_dev_list *match;
+
+	list_for_each(ptr, head) {
+		match = list_entry(ptr, struct pv_pci_dev_list, list);
+		/* We use guest_name for comparison since we also use this
+		 * function from the hypercall which the guest issues to
+		 * find out if it's a pv device
+		 */
+		if (match &&
+		    (match->pt_dev.guest.busnr == pv_pci_info->busnr) &&
+		    (match->pt_dev.guest.devfn == pv_pci_info->devfn))
+			return match;
+	}
+	return NULL;
+}
+
+static int
+pv_mapped_pci_device_hypercall(struct kvm_vcpu *vcpu, gfn_t page_gfn)
+{
+	int r = -1;
+	hpa_t page_hpa;
+	unsigned long *shared_addr;
+	struct page *host_page;
+	struct kvm_pv_pci_info pv_pci_info;
+
+	page_hpa = gpa_to_hpa(vcpu->kvm, page_gfn << PAGE_SHIFT);
+	if (is_error_hpa(page_hpa)) {
+		printk(KERN_INFO "%s: page hpa %p not valid for page_gfn %p\n",
+		       __FUNCTION__, (void *)page_hpa, (void *)page_gfn);
+		goto out;
+	}
+	host_page = pfn_to_page(page_hpa >> PAGE_SHIFT);
+	shared_addr = kmap(host_page);
+	memcpy(&pv_pci_info, shared_addr, sizeof(struct kvm_pv_pci_info));
+
+	if (find_matching_pt_dev(&pt_dev_head, &pv_pci_info))
+		r = 1;
+	else
+		r = 0;
+
+	kunmap(host_page);
+ out:
+	return r;
+}
+
+static int kvm_vm_ioctl_pv_pt_dev(struct kvm_pv_passthrough_dev *pv_pci_dev)
+{
+	int r = 0;
+	struct pv_pci_dev_list *match;
+
+	/* Has this been added already? */
+	if (find_matching_pt_dev(&pt_dev_head, &pv_pci_dev->guest))
+		goto out;
+
+	match = kmalloc(sizeof(struct pv_pci_dev_list), GFP_KERNEL);
+	if (match == NULL) {
+		printk(KERN_INFO "%s: Couldn't allocate memory\n",
+		       __FUNCTION__);
+		r = -ENOMEM;
+		goto out;
+	}
+	match->pt_dev.guest.busnr = pv_pci_dev->guest.busnr;
+	match->pt_dev.guest.devfn = pv_pci_dev->guest.devfn;
+	match->pt_dev.mach.busnr  = pv_pci_dev->mach.busnr;
+	match->pt_dev.mach.devfn  = pv_pci_dev->mach.devfn;
+	list_add(&match->list, &pt_dev_head);
+ out:
+	return r;
+}
 
 unsigned long segment_base(u16 selector)
 {
@@ -983,6 +1234,19 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_ASSIGN_PV_PCI_DEV: {
+		struct kvm_pv_passthrough_dev pv_pci_dev;
+
+		r = -EFAULT;
+		if (copy_from_user(&pv_pci_dev, argp, sizeof pv_pci_dev)) {
+			printk("pv_register: failing copy from user\n");
+			goto out;
+		}
+		r = kvm_vm_ioctl_pv_pt_dev(&pv_pci_dev);
+		if (r)
+			goto out;
+		break;
+	}
 	default:
 		;
 	}
@@ -1649,6 +1913,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	}
 
 	switch (nr) {
+	case KVM_PV_DMA_MAP:
+		ret = pv_map_hypercall(vcpu, a0, a1);
+		break;
+	case KVM_PV_DMA_UNMAP:
+		ret = pv_unmap_hypercall(vcpu, a0);
+		break;
+	case KVM_PV_PCI_DEVICE:
+		ret = pv_mapped_pci_device_hypercall(vcpu, a0);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index c6f3fd8..c4b2be0 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -17,7 +17,13 @@
 /* This instruction is vmcall.  On non-VT architectures, it will generate a
  * trap that we will then rewrite to the appropriate instruction.
  */
-#define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
+#define KVM_HYPERCALL ".byte 0x0f,0x01,0xd9"
+
+/* Hypercall numbers */
+#define KVM_PV_UNUSED		0
+#define KVM_PV_DMA_MAP		1
+#define KVM_PV_DMA_UNMAP	2
+#define KVM_PV_PCI_DEVICE	3
 
 /* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
  * instruction.  The hypervisor may replace it with something else but only the
@@ -101,5 +107,18 @@ static inline unsigned int kvm_arch_para_features(void)
 }
 
 #endif
-
+/* Info stored for identifying paravirtualized PCI devices in the host kernel */
+struct kvm_pv_pci_info {
+	unsigned char busnr;
+	unsigned int devfn;
+};
+
+/* Mapping between host and guest PCI device */
+struct kvm_pv_passthrough_dev {
+	struct kvm_pv_pci_info guest;
+	struct kvm_pv_pci_info mach;
+};
+
+/* Max. DMA pages we send from guest to host for mapping */
+#define MAX_PVDMA_PAGES (PAGE_SIZE / sizeof(unsigned long *))
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 71d33d6..38fbebb 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -9,6 +9,7 @@
 
 #include <asm/types.h>
 #include <linux/ioctl.h>
+#include <linux/kvm_para.h>
 
 #define KVM_API_VERSION 12
 
@@ -381,6 +382,8 @@ struct kvm_signal_mask {
 #define KVM_IRQ_LINE		  _IOW(KVMIO, 0x61, struct kvm_irq_level)
 #define KVM_GET_IRQCHIP		  _IOWR(KVMIO, 0x62, struct kvm_irqchip)
 #define KVM_SET_IRQCHIP		  _IOR(KVMIO,  0x63, struct kvm_irqchip)
+#define KVM_ASSIGN_PV_PCI_DEV	  _IOR(KVMIO, 0x64, \
+				       struct kvm_pv_passthrough_dev)
 
 /*
  * ioctls for vcpu fds
-- 
1.5.3


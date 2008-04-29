Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbYD2KiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbYD2KiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYD2Khf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:37:35 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:10890
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYD2Khd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:37:33 -0400
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: virtualization@lists.linux-foundation.org, muli@il.ibm.com,
       BENAMI@il.ibm.com, gcosta@redhat.com, chrisw@redhat.com,
       dor.laor@qumranet.com, allen.m.kay@intel.com, avi@qumranet.com,
       linux-kernel@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH] KVM x86: Handle hypercalls for assigned PCI devices
Date: Tue, 29 Apr 2008 13:37:30 +0300
Message-Id: <1209465451-3758-3-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1209465451-3758-2-git-send-email-amit.shah@qumranet.com>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com>
 <1209465451-3758-2-git-send-email-amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduce three hypercalls:
1. When the guest wants to check if a particular device is an assigned device
   (this is done once per device by the guest to enable / disable hypercall-
   based translation of addresses)

2. map: to convert guest phyical addresses to host physical address to pass on
   to the device for DMA. We also pin the pages thus requested so that they're
   not swapped out.

3. unmap: to unpin the pages and free any information we might have stored.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 arch/x86/kvm/x86.c         |  211 +++++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/kvm_host.h |   15 +++
 include/asm-x86/kvm_para.h |    8 ++
 3 files changed, 233 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb9b329..94ee4db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -24,8 +24,11 @@
 #include <linux/interrupt.h>
 #include <linux/kvm.h>
 #include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/highmem.h>
 #include <linux/mman.h>
 #include <linux/highmem.h>
 
@@ -76,6 +79,9 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "halt_exits", VCPU_STAT(halt_exits) },
 	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
 	{ "hypercalls", VCPU_STAT(hypercalls) },
+	{ "hypercall_map", VCPU_STAT(hypercall_map) },
+	{ "hypercall_unmap", VCPU_STAT(hypercall_unmap) },
+	{ "hypercall_pv_dev", VCPU_STAT(hypercall_pv_dev) },
 	{ "request_irq", VCPU_STAT(request_irq_exits) },
 	{ "irq_exits", VCPU_STAT(irq_exits) },
 	{ "host_state_reload", VCPU_STAT(host_state_reload) },
@@ -95,9 +101,164 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+static struct kvm_pv_dma_map*
+find_pci_pv_dmap(struct list_head *head, dma_addr_t dma)
+{
+	struct list_head *ptr;
+	struct kvm_pv_dma_map *match;
+
+	list_for_each(ptr, head) {
+		match = list_entry(ptr, struct kvm_pv_dma_map, list);
+		if (match && match->sg[0].dma_address == dma)
+			return match;
+	}
+	return NULL;
+}
+
+static void prepare_sg_entry(struct scatterlist *sg, struct page *page)
+{
+	unsigned int offset, len;
+
+	offset = page_to_phys(page) & ~PAGE_MASK;
+	len = PAGE_SIZE - offset;
+
+	/* FIXME: Use the sg chaining features */
+	sg_set_page(sg, page, len, offset);
+}
+
+static int pv_map_hypercall(struct kvm_vcpu *vcpu, int npages, gfn_t page_gfn)
+{
+	int i, r = 0;
+	struct page *host_page;
+	struct scatterlist *sg;
+	struct kvm_pv_dma_map *dmap;
+	unsigned long *shared_addr, *hcall_page;
+
+	/* We currently don't support dma mappings which have more than
+	 * PAGE_SIZE/sizeof(unsigned long *) pages
+	 */
+	if (!npages || npages > MAX_PVDMA_PAGES) {
+		printk(KERN_INFO "%s: Illegal number of pages: %d\n",
+		       __func__, npages);
+		goto out;
+	}
+
+	host_page = gfn_to_page(vcpu->kvm, page_gfn);
+	if (is_error_page(host_page)) {
+		printk(KERN_INFO "%s: Bad gfn %p\n", __func__,
+		       (void *)page_gfn);
+		goto out;
+	}
+	hcall_page = shared_addr = kmap(host_page);
+
+	/* scatterlist to map guest dma pages into host physical
+	 * memory -- if they exceed the DMA map limit
+	 */
+	sg = kcalloc(npages, sizeof(struct scatterlist), GFP_KERNEL);
+	if (sg == NULL) {
+		printk(KERN_INFO "%s: Couldn't allocate memory (sg)\n",
+		       __func__);
+		goto out_unmap;
+	}
+
+	/* List to store all guest pages mapped into host. This will
+	 * be used later to free pages on the host. Think of this as a
+	 * translation table from guest dma addresses into host dma
+	 * addresses
+	 */
+	dmap = kzalloc(sizeof(*dmap), GFP_KERNEL);
+	if (dmap == NULL) {
+		printk(KERN_INFO "%s: Couldn't allocate memory\n",
+		       __func__);
+		goto out_unmap_sg;
+	}
+
+	/* FIXME: consider the length of the last page. Guest should
+	 * send this info.
+	 */
+	for (i = 0; i < npages; i++) {
+		struct page *page;
+		gpa_t gpa;
+
+		gpa = *shared_addr++;
+		page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+		if (is_error_page(page)) {
+			int j;
+			printk(KERN_INFO "kvm %s: gpa %p not valid\n",
+			       __func__, (void *)gpa);
+
+			for (j = 0; j < i; j++)
+				put_page(sg_page(&sg[j]));
+			goto out_unmap_sg_dmap;
+		}
+		prepare_sg_entry(&sg[i], page);
+		get_page(sg_page(&sg[i]));
+	}
+
+	/* Put this on the dmap_head list, so that we can find it
+	 * later for the 'free' operation
+	 */
+	dmap->sg = sg;
+	dmap->nents = npages;
+	list_add(&dmap->list, &vcpu->kvm->arch.pci_pv_dmap_head);
+
+	/* FIXME: guest should send the direction */
+	r = dma_ops->map_sg(NULL, sg, npages, PCI_DMA_BIDIRECTIONAL);
+	if (r) {
+		r = npages;
+		*hcall_page = sg[0].dma_address | (*hcall_page & ~PAGE_MASK);
+	}
+
+ out_unmap:
+	if (!r)
+		*hcall_page = bad_dma_address;
+	kunmap(host_page);
+ out:
+	++vcpu->stat.hypercall_map;
+	return r;
+ out_unmap_sg_dmap:
+	kfree(dmap);
+ out_unmap_sg:
+	kfree(sg);
+	goto out_unmap;
+}
+
+static int free_dmap(struct kvm_pv_dma_map *dmap, struct list_head *head)
+{
+	int i;
+
+	if (!dmap)
+		return 1;
+
+	for (i = 0; i < dmap->nents; i++)
+		put_page(sg_page(&dmap->sg[i]));
+
+	if (dma_ops->unmap_sg)
+		dma_ops->unmap_sg(NULL, dmap->sg, dmap->nents,
+				  PCI_DMA_BIDIRECTIONAL);
+	kfree(dmap->sg);
+	list_del(&dmap->list);
+	kfree(dmap);
+
+	return 0;
+}
+
+/* FIXME: the argument passed from guest can be 32-bit. We need 64-bit for
+ * dma_addr_t. Send the dma address in a page (or split in two registers)
+ */
+static int pv_unmap_hypercall(struct kvm_vcpu *vcpu, dma_addr_t dma)
+{
+	struct kvm_pv_dma_map *dmap;
+
+	++vcpu->stat.hypercall_unmap;
+
+	dmap = find_pci_pv_dmap(&vcpu->kvm->arch.pci_pv_dmap_head, dma);
+	return free_dmap(dmap, &vcpu->kvm->arch.pci_pv_dmap_head);
+}
+
 /*
  * Used to find a registered host PCI device (a "passthrough" device)
- * during ioctls, interrupts or EOI
+ * during hypercalls, ioctls or interrupts or EOI
  */
 static struct kvm_pci_pt_dev_list *
 find_pci_pt_dev(struct list_head *head,
@@ -136,6 +297,34 @@ find_pci_pt_dev(struct list_head *head,
 	return NULL;
 }
 
+static int
+pv_mapped_pci_device_hypercall(struct kvm_vcpu *vcpu, gfn_t page_gfn)
+{
+	int r = 0;
+	unsigned long *shared_addr;
+	struct page *host_page;
+	struct kvm_pci_pt_info pci_pt_info;
+
+	host_page = gfn_to_page(vcpu->kvm, page_gfn);
+	if (is_error_page(host_page)) {
+		printk(KERN_INFO "%s: gfn %p not valid\n",
+		       __func__, (void *)page_gfn);
+		r = -1;
+		goto out;
+	}
+	shared_addr = kmap(host_page);
+	memcpy(&pci_pt_info, shared_addr, sizeof(pci_pt_info));
+
+	if (find_pci_pt_dev(&vcpu->kvm->arch.pci_pt_dev_head,
+			    &pci_pt_info, 0, KVM_PT_SOURCE_ASSIGN))
+		r++; /* We have assigned the device */
+
+	kunmap(host_page);
+ out:
+	++vcpu->stat.hypercall_pv_dev;
+	return r;
+}
+
 static DECLARE_BITMAP(pt_irq_pending, NR_IRQS);
 static DECLARE_BITMAP(pt_irq_handled, NR_IRQS);
 
@@ -218,6 +407,10 @@ static int kvm_vm_ioctl_pci_pt_dev(struct kvm *kvm,
 		set_bit(pci_pt_dev->host.irq, pt_irq_handled);
 	}
 	list_add(&match->list, &kvm->arch.pci_pt_dev_head);
+
+	printk(KERN_INFO "kvm: Handling hypercalls for device %02x:%02x.%1x\n",
+	       pci_pt_dev->host.busnr, PCI_SLOT(pci_pt_dev->host.devfn),
+	       PCI_FUNC(pci_pt_dev->host.devfn));
  out:
 	return r;
  out_free:
@@ -248,6 +441,7 @@ static void kvm_free_pci_passthrough(struct kvm *kvm)
 {
 	struct list_head *ptr, *ptr2;
 	struct kvm_pci_pt_dev_list *pci_pt_dev;
+	struct kvm_pv_dma_map *dmap;
 
 	list_for_each_safe(ptr, ptr2, &kvm->arch.pci_pt_dev_head) {
 		pci_pt_dev = list_entry(ptr, struct kvm_pci_pt_dev_list, list);
@@ -257,6 +451,11 @@ static void kvm_free_pci_passthrough(struct kvm *kvm)
 
 		list_del(&pci_pt_dev->list);
 	}
+
+	list_for_each_safe(ptr, ptr2, &kvm->arch.pci_pv_dmap_head) {
+		dmap = list_entry(ptr, struct kvm_pv_dma_map, list);
+		free_dmap(dmap, &kvm->arch.pci_pv_dmap_head);
+	}
 }
 
 unsigned long segment_base(u16 selector)
@@ -2672,6 +2871,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
 		break;
@@ -4059,6 +4267,7 @@ struct  kvm *kvm_arch_create_vm(void)
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.pci_pt_dev_head);
+	INIT_LIST_HEAD(&kvm->arch.pci_pv_dmap_head);
 
 	return kvm;
 }
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 3b9cb50..d52e44e 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -298,6 +298,17 @@ struct kvm_mem_alias {
 #define KVM_PT_SOURCE_IRQ_ACK	2
 #define KVM_PT_SOURCE_ASSIGN	3
 
+/* Paravirt DMA: We pin the host-side pages for the GPAs that we get
+ * for the DMA operation. We do a sg_map on the host pages for a DMA
+ * operation on the guest side. We un-pin the pages on the
+ * unmap_hypercall.
+ */
+struct kvm_pv_dma_map {
+	struct list_head list;
+	int nents;
+	struct scatterlist *sg;
+};
+
 /* This list is to store the guest bus:device:function-irq and host
  * bus:device:function-irq mapping for assigned devices.
  */
@@ -319,6 +330,7 @@ struct kvm_arch{
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head pci_pt_dev_head;
+	struct list_head pci_pv_dmap_head;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
@@ -366,6 +378,9 @@ struct kvm_vcpu_stat {
 	u32 insn_emulation;
 	u32 insn_emulation_fail;
 	u32 hypercalls;
+	u32 hypercall_map;
+	u32 hypercall_unmap;
+	u32 hypercall_pv_dev;
 };
 
 struct descriptor_table {
diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index 5f93b78..e13bf4c 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -74,6 +74,12 @@ extern void kvmclock_init(void);
  */
 #define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
 
+/* Hypercall numbers */
+#define KVM_PV_UNUSED		0
+#define KVM_PV_DMA_MAP		101
+#define KVM_PV_DMA_UNMAP	102
+#define KVM_PV_PCI_DEVICE	103
+
 /* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
  * instruction.  The hypervisor may replace it with something else but only the
  * instructions are guaranteed to be supported.
@@ -155,6 +161,8 @@ static inline unsigned int kvm_arch_para_features(void)
 	return cpuid_eax(KVM_CPUID_FEATURES);
 }
 
+/* Max. DMA pages we send from guest to host for mapping */
+#define MAX_PVDMA_PAGES (PAGE_SIZE / sizeof(unsigned long *))
 #endif /* KERNEL */
 
 /* Stores information for identifying host PCI devices assigned to the
-- 
1.5.4.3


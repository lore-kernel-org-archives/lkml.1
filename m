Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbYBFVGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbYBFVGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761681AbYBFVGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:06:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43826 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761623AbYBFVGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:06:00 -0500
Date: Wed, 6 Feb 2008 13:04:00 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.17
Message-ID: <20080206210400.GB4742@kroah.com>
References: <20080206210342.GA4742@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206210342.GA4742@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 99c0237..6a949eb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION = .16
+EXTRAVERSION = .17
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 4f2f453..c84b7cc 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -795,7 +795,7 @@ void hash_preload(struct mm_struct *mm, unsigned long ea,
 
 #ifdef CONFIG_PPC_MM_SLICES
 	/* We only prefault standard pages for now */
-	if (unlikely(get_slice_psize(mm, ea) != mm->context.user_psize));
+	if (unlikely(get_slice_psize(mm, ea) != mm->context.user_psize))
 		return;
 #endif
 
diff --git a/arch/sparc64/kernel/chmc.c b/arch/sparc64/kernel/chmc.c
index 777d345..6d4f02e 100644
--- a/arch/sparc64/kernel/chmc.c
+++ b/arch/sparc64/kernel/chmc.c
@@ -1,7 +1,6 @@
-/* $Id: chmc.c,v 1.4 2002/01/08 16:00:14 davem Exp $
- * memctrlr.c: Driver for UltraSPARC-III memory controller.
+/* memctrlr.c: Driver for UltraSPARC-III memory controller.
  *
- * Copyright (C) 2001 David S. Miller (davem@redhat.com)
+ * Copyright (C) 2001, 2007 David S. Miller (davem@davemloft.net)
  */
 
 #include <linux/module.h>
@@ -16,6 +15,7 @@
 #include <linux/init.h>
 #include <asm/spitfire.h>
 #include <asm/chmctrl.h>
+#include <asm/cpudata.h>
 #include <asm/oplib.h>
 #include <asm/prom.h>
 #include <asm/io.h>
@@ -242,8 +242,11 @@ int chmc_getunumber(int syndrome_code,
  */
 static u64 read_mcreg(struct mctrl_info *mp, unsigned long offset)
 {
-	unsigned long ret;
-	int this_cpu = get_cpu();
+	unsigned long ret, this_cpu;
+
+	preempt_disable();
+
+	this_cpu = real_hard_smp_processor_id();
 
 	if (mp->portid == this_cpu) {
 		__asm__ __volatile__("ldxa	[%1] %2, %0"
@@ -255,7 +258,8 @@ static u64 read_mcreg(struct mctrl_info *mp, unsigned long offset)
 				     : "r" (mp->regs + offset),
 				       "i" (ASI_PHYS_BYPASS_EC_E));
 	}
-	put_cpu();
+
+	preempt_enable();
 
 	return ret;
 }
diff --git a/arch/sparc64/kernel/entry.S b/arch/sparc64/kernel/entry.S
index 8059531..193791c 100644
--- a/arch/sparc64/kernel/entry.S
+++ b/arch/sparc64/kernel/entry.S
@@ -2593,3 +2593,15 @@ sun4v_mmustat_info:
 	retl
 	 nop
 	.size	sun4v_mmustat_info, .-sun4v_mmustat_info
+
+	.globl	sun4v_mmu_demap_all
+	.type	sun4v_mmu_demap_all,#function
+sun4v_mmu_demap_all:
+	clr	%o0
+	clr	%o1
+	mov	HV_MMU_ALL, %o2
+	mov	HV_FAST_MMU_DEMAP_ALL, %o5
+	ta	HV_FAST_TRAP
+	retl
+	 nop
+	.size	sun4v_mmu_demap_all, .-sun4v_mmu_demap_all
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index 4dcd7d0..3ddd99c 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -403,7 +403,7 @@ static __inline__ void spitfire_xcall_deliver(u64 data0, u64 data1, u64 data2, c
  */
 static void cheetah_xcall_deliver(u64 data0, u64 data1, u64 data2, cpumask_t mask)
 {
-	u64 pstate, ver;
+	u64 pstate, ver, busy_mask;
 	int nack_busy_id, is_jbus, need_more;
 
 	if (cpus_empty(mask))
@@ -435,14 +435,20 @@ retry:
 			       "i" (ASI_INTR_W));
 
 	nack_busy_id = 0;
+	busy_mask = 0;
 	{
 		int i;
 
 		for_each_cpu_mask(i, mask) {
 			u64 target = (i << 14) | 0x70;
 
-			if (!is_jbus)
+			if (is_jbus) {
+				busy_mask |= (0x1UL << (i * 2));
+			} else {
 				target |= (nack_busy_id << 24);
+				busy_mask |= (0x1UL <<
+					      (nack_busy_id * 2));
+			}
 			__asm__ __volatile__(
 				"stxa	%%g0, [%0] %1\n\t"
 				"membar	#Sync\n\t"
@@ -458,15 +464,16 @@ retry:
 
 	/* Now, poll for completion. */
 	{
-		u64 dispatch_stat;
+		u64 dispatch_stat, nack_mask;
 		long stuck;
 
 		stuck = 100000 * nack_busy_id;
+		nack_mask = busy_mask << 1;
 		do {
 			__asm__ __volatile__("ldxa	[%%g0] %1, %0"
 					     : "=r" (dispatch_stat)
 					     : "i" (ASI_INTR_DISPATCH_STAT));
-			if (dispatch_stat == 0UL) {
+			if (!(dispatch_stat & (busy_mask | nack_mask))) {
 				__asm__ __volatile__("wrpr %0, 0x0, %%pstate"
 						     : : "r" (pstate));
 				if (unlikely(need_more)) {
@@ -483,12 +490,12 @@ retry:
 			}
 			if (!--stuck)
 				break;
-		} while (dispatch_stat & 0x5555555555555555UL);
+		} while (dispatch_stat & busy_mask);
 
 		__asm__ __volatile__("wrpr %0, 0x0, %%pstate"
 				     : : "r" (pstate));
 
-		if ((dispatch_stat & ~(0x5555555555555555UL)) == 0) {
+		if (dispatch_stat & busy_mask) {
 			/* Busy bits will not clear, continue instead
 			 * of freezing up on this cpu.
 			 */
diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index 3010227..ed2484d 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1135,14 +1135,9 @@ static void __init mark_kpte_bitmap(unsigned long start, unsigned long end)
 	}
 }
 
-static void __init kernel_physical_mapping_init(void)
+static void __init init_kpte_bitmap(void)
 {
 	unsigned long i;
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	unsigned long mem_alloced = 0UL;
-#endif
-
-	read_obp_memory("reg", &pall[0], &pall_ents);
 
 	for (i = 0; i < pall_ents; i++) {
 		unsigned long phys_start, phys_end;
@@ -1151,14 +1146,24 @@ static void __init kernel_physical_mapping_init(void)
 		phys_end = phys_start + pall[i].reg_size;
 
 		mark_kpte_bitmap(phys_start, phys_end);
+	}
+}
 
+static void __init kernel_physical_mapping_init(void)
+{
 #ifdef CONFIG_DEBUG_PAGEALLOC
+	unsigned long i, mem_alloced = 0UL;
+
+	for (i = 0; i < pall_ents; i++) {
+		unsigned long phys_start, phys_end;
+
+		phys_start = pall[i].phys_addr;
+		phys_end = phys_start + pall[i].reg_size;
+
 		mem_alloced += kernel_map_range(phys_start, phys_end,
 						PAGE_KERNEL);
-#endif
 	}
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 	printk("Allocated %ld bytes for kernel page tables.\n",
 	       mem_alloced);
 
@@ -1400,6 +1405,10 @@ void __init paging_init(void)
 	
 	inherit_prom_mappings();
 	
+	read_obp_memory("reg", &pall[0], &pall_ents);
+
+	init_kpte_bitmap();
+
 	/* Ok, we can use our TLB miss and window trap handlers safely.  */
 	setup_tba();
 
@@ -1854,7 +1863,9 @@ void __flush_tlb_all(void)
 			     "wrpr	%0, %1, %%pstate"
 			     : "=r" (pstate)
 			     : "i" (PSTATE_IE));
-	if (tlb_type == spitfire) {
+	if (tlb_type == hypervisor) {
+		sun4v_mmu_demap_all();
+	} else if (tlb_type == spitfire) {
 		for (i = 0; i < 64; i++) {
 			/* Spitfire Errata #32 workaround */
 			/* NOTE: Always runs on spitfire, so no
diff --git a/drivers/acpi/dispatcher/dsobject.c b/drivers/acpi/dispatcher/dsobject.c
index a474ca2..954ac8c 100644
--- a/drivers/acpi/dispatcher/dsobject.c
+++ b/drivers/acpi/dispatcher/dsobject.c
@@ -137,6 +137,71 @@ acpi_ds_build_internal_object(struct acpi_walk_state *walk_state,
 				return_ACPI_STATUS(status);
 			}
 		}
+
+		/* Special object resolution for elements of a package */
+
+		if ((op->common.parent->common.aml_opcode == AML_PACKAGE_OP) ||
+		    (op->common.parent->common.aml_opcode ==
+		     AML_VAR_PACKAGE_OP)) {
+			/*
+			 * Attempt to resolve the node to a value before we insert it into
+			 * the package. If this is a reference to a common data type,
+			 * resolve it immediately. According to the ACPI spec, package
+			 * elements can only be "data objects" or method references.
+			 * Attempt to resolve to an Integer, Buffer, String or Package.
+			 * If cannot, return the named reference (for things like Devices,
+			 * Methods, etc.) Buffer Fields and Fields will resolve to simple
+			 * objects (int/buf/str/pkg).
+			 *
+			 * NOTE: References to things like Devices, Methods, Mutexes, etc.
+			 * will remain as named references. This behavior is not described
+			 * in the ACPI spec, but it appears to be an oversight.
+			 */
+			obj_desc = (union acpi_operand_object *)op->common.node;
+
+			status =
+			    acpi_ex_resolve_node_to_value(ACPI_CAST_INDIRECT_PTR
+							  (struct
+							   acpi_namespace_node,
+							   &obj_desc),
+							  walk_state);
+			if (ACPI_FAILURE(status)) {
+				return_ACPI_STATUS(status);
+			}
+
+			switch (op->common.node->type) {
+				/*
+				 * For these types, we need the actual node, not the subobject.
+				 * However, the subobject got an extra reference count above.
+				 */
+			case ACPI_TYPE_MUTEX:
+			case ACPI_TYPE_METHOD:
+			case ACPI_TYPE_POWER:
+			case ACPI_TYPE_PROCESSOR:
+			case ACPI_TYPE_EVENT:
+			case ACPI_TYPE_REGION:
+			case ACPI_TYPE_DEVICE:
+			case ACPI_TYPE_THERMAL:
+
+				obj_desc =
+				    (union acpi_operand_object *)op->common.
+				    node;
+				break;
+
+			default:
+				break;
+			}
+
+			/*
+			 * If above resolved to an operand object, we are done. Otherwise,
+			 * we have a NS node, we must create the package entry as a named
+			 * reference.
+			 */
+			if (ACPI_GET_DESCRIPTOR_TYPE(obj_desc) !=
+			    ACPI_DESC_TYPE_NAMED) {
+				goto exit;
+			}
+		}
 	}
 
 	/* Create and init a new internal ACPI object */
@@ -156,6 +221,7 @@ acpi_ds_build_internal_object(struct acpi_walk_state *walk_state,
 		return_ACPI_STATUS(status);
 	}
 
+      exit:
 	*obj_desc_ptr = obj_desc;
 	return_ACPI_STATUS(AE_OK);
 }
@@ -356,12 +422,25 @@ acpi_ds_build_internal_package_obj(struct acpi_walk_state *walk_state,
 	arg = arg->common.next;
 	for (i = 0; arg && (i < element_count); i++) {
 		if (arg->common.aml_opcode == AML_INT_RETURN_VALUE_OP) {
-
-			/* This package element is already built, just get it */
-
-			obj_desc->package.elements[i] =
-			    ACPI_CAST_PTR(union acpi_operand_object,
-					  arg->common.node);
+			if (arg->common.node->type == ACPI_TYPE_METHOD) {
+				/*
+				 * A method reference "looks" to the parser to be a method
+				 * invocation, so we special case it here
+				 */
+				arg->common.aml_opcode = AML_INT_NAMEPATH_OP;
+				status =
+				    acpi_ds_build_internal_object(walk_state,
+								  arg,
+								  &obj_desc->
+								  package.
+								  elements[i]);
+			} else {
+				/* This package element is already built, just get it */
+
+				obj_desc->package.elements[i] =
+				    ACPI_CAST_PTR(union acpi_operand_object,
+						  arg->common.node);
+			}
 		} else {
 			status = acpi_ds_build_internal_object(walk_state, arg,
 							       &obj_desc->
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 14ced85..0c205b0 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -625,14 +625,6 @@ static int __devinit ns_init_card(int i, struct pci_dev *pcidev)
    if (mac[i] == NULL)
       nicstar_init_eprom(card->membase);
 
-   if (request_irq(pcidev->irq, &ns_irq_handler, IRQF_DISABLED | IRQF_SHARED, "nicstar", card) != 0)
-   {
-      printk("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
-      error = 9;
-      ns_init_card_error(card, error);
-      return error;
-   }
-
    /* Set the VPI/VCI MSb mask to zero so we can receive OAM cells */
    writel(0x00000000, card->membase + VPM);
       
@@ -858,8 +850,6 @@ static int __devinit ns_init_card(int i, struct pci_dev *pcidev)
       card->iovpool.count++;
    }
 
-   card->intcnt = 0;
-
    /* Configure NICStAR */
    if (card->rct_size == 4096)
       ns_cfg_rctsize = NS_CFG_RCTSIZE_4096_ENTRIES;
@@ -868,6 +858,15 @@ static int __devinit ns_init_card(int i, struct pci_dev *pcidev)
 
    card->efbie = 1;
 
+   card->intcnt = 0;
+   if (request_irq(pcidev->irq, &ns_irq_handler, IRQF_DISABLED | IRQF_SHARED, "nicstar", card) != 0)
+   {
+      printk("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
+      error = 9;
+      ns_init_card_error(card, error);
+      return error;
+   }
+
    /* Register device */
    card->atmdev = atm_dev_register("nicstar", &atm_ops, -1, NULL);
    if (card->atmdev == NULL)
diff --git a/drivers/char/drm/drm_vm.c b/drivers/char/drm/drm_vm.c
index b5c5b9f..e2d7be9 100644
--- a/drivers/char/drm/drm_vm.c
+++ b/drivers/char/drm/drm_vm.c
@@ -520,6 +520,7 @@ static int drm_mmap_dma(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_ops = &drm_vm_dma_ops;
 
 	vma->vm_flags |= VM_RESERVED;	/* Don't swap */
+	vma->vm_flags |= VM_DONTEXPAND;
 
 	vma->vm_file = filp;	/* Needed for drm_vm_open() */
 	drm_vm_open_locked(vma);
@@ -669,6 +670,7 @@ static int drm_mmap_locked(struct file *filp, struct vm_area_struct *vma)
 		return -EINVAL;	/* This should never happen. */
 	}
 	vma->vm_flags |= VM_RESERVED;	/* Don't swap */
+	vma->vm_flags |= VM_DONTEXPAND;
 
 	vma->vm_file = filp;	/* Needed for drm_vm_open() */
 	drm_vm_open_locked(vma);
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 7ac3061..5685b7a 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -265,7 +265,8 @@ mspec_mmap(struct file *file, struct vm_area_struct *vma, int type)
 	vdata->refcnt = ATOMIC_INIT(1);
 	vma->vm_private_data = vdata;
 
-	vma->vm_flags |= (VM_IO | VM_LOCKED | VM_RESERVED | VM_PFNMAP);
+	vma->vm_flags |= (VM_IO | VM_LOCKED | VM_RESERVED | VM_PFNMAP |
+			  VM_DONTEXPAND);
 	if (vdata->type == MSPEC_FETCHOP || vdata->type == MSPEC_UNCACHED)
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_ops = &mspec_vm_ops;
diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 296f510..12ceed5 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -99,8 +99,8 @@ int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id
 	spin_unlock_bh(&dev->queue_lock);
 
 	if (found) {
-		atomic_dec(&dev->refcnt);
 		cn_queue_free_callback(cbq);
+		atomic_dec(&dev->refcnt);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 59b9943..ad55baa 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -336,30 +336,6 @@ static inline void cas_mask_intr(struct cas *cp)
 		cas_disable_irq(cp, i);
 }
 
-static inline void cas_buffer_init(cas_page_t *cp)
-{
-	struct page *page = cp->buffer;
-	atomic_set((atomic_t *)&page->lru.next, 1);
-}
-
-static inline int cas_buffer_count(cas_page_t *cp)
-{
-	struct page *page = cp->buffer;
-	return atomic_read((atomic_t *)&page->lru.next);
-}
-
-static inline void cas_buffer_inc(cas_page_t *cp)
-{
-	struct page *page = cp->buffer;
-	atomic_inc((atomic_t *)&page->lru.next);
-}
-
-static inline void cas_buffer_dec(cas_page_t *cp)
-{
-	struct page *page = cp->buffer;
-	atomic_dec((atomic_t *)&page->lru.next);
-}
-
 static void cas_enable_irq(struct cas *cp, const int ring)
 {
 	if (ring == 0) { /* all but TX_DONE */
@@ -497,7 +473,6 @@ static int cas_page_free(struct cas *cp, cas_page_t *page)
 {
 	pci_unmap_page(cp->pdev, page->dma_addr, cp->page_size,
 		       PCI_DMA_FROMDEVICE);
-	cas_buffer_dec(page);
 	__free_pages(page->buffer, cp->page_order);
 	kfree(page);
 	return 0;
@@ -527,7 +502,6 @@ static cas_page_t *cas_page_alloc(struct cas *cp, const gfp_t flags)
 	page->buffer = alloc_pages(flags, cp->page_order);
 	if (!page->buffer)
 		goto page_err;
-	cas_buffer_init(page);
 	page->dma_addr = pci_map_page(cp->pdev, page->buffer, 0,
 				      cp->page_size, PCI_DMA_FROMDEVICE);
 	return page;
@@ -606,7 +580,7 @@ static void cas_spare_recover(struct cas *cp, const gfp_t flags)
 	list_for_each_safe(elem, tmp, &list) {
 		cas_page_t *page = list_entry(elem, cas_page_t, list);
 
-		if (cas_buffer_count(page) > 1)
+		if (page_count(page->buffer) > 1)
 			continue;
 
 		list_del(elem);
@@ -1374,7 +1348,7 @@ static inline cas_page_t *cas_page_spare(struct cas *cp, const int index)
 	cas_page_t *page = cp->rx_pages[1][index];
 	cas_page_t *new;
 
-	if (cas_buffer_count(page) == 1)
+	if (page_count(page->buffer) == 1)
 		return page;
 
 	new = cas_page_dequeue(cp);
@@ -1394,7 +1368,7 @@ static cas_page_t *cas_page_swap(struct cas *cp, const int ring,
 	cas_page_t **page1 = cp->rx_pages[1];
 
 	/* swap if buffer is in use */
-	if (cas_buffer_count(page0[index]) > 1) {
+	if (page_count(page0[index]->buffer) > 1) {
 		cas_page_t *new = cas_page_spare(cp, index);
 		if (new) {
 			page1[index] = page0[index];
@@ -1979,6 +1953,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 	struct cas_page *page;
 	struct sk_buff *skb;
 	void *addr, *crcaddr;
+	__sum16 csum;
 	char *p;
 
 	hlen = CAS_VAL(RX_COMP2_HDR_SIZE, words[1]);
@@ -2062,10 +2037,10 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 
 		skb_shinfo(skb)->nr_frags++;
 		skb->data_len += hlen - swivel;
+		skb->truesize += hlen - swivel;
 		skb->len      += hlen - swivel;
 
 		get_page(page->buffer);
-		cas_buffer_inc(page);
 		frag->page = page->buffer;
 		frag->page_offset = off;
 		frag->size = hlen - swivel;
@@ -2090,7 +2065,6 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 			frag++;
 
 			get_page(page->buffer);
-			cas_buffer_inc(page);
 			frag->page = page->buffer;
 			frag->page_offset = 0;
 			frag->size = hlen;
@@ -2158,14 +2132,15 @@ end_copy_pkt:
 		skb_put(skb, alloclen);
 	}
 
-	i = CAS_VAL(RX_COMP4_TCP_CSUM, words[3]);
+	csum = (__force __sum16)htons(CAS_VAL(RX_COMP4_TCP_CSUM, words[3]));
 	if (cp->crc_size) {
 		/* checksum includes FCS. strip it out. */
-		i = csum_fold(csum_partial(crcaddr, cp->crc_size, i));
+		csum = csum_fold(csum_partial(crcaddr, cp->crc_size,
+					      csum_unfold(csum)));
 		if (addr)
 			cas_page_unmap(addr);
 	}
-	skb->csum = ntohs(i ^ 0xffff);
+	skb->csum = csum_unfold(~csum);
 	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->protocol = eth_type_trans(skb, cp->dev);
 	return len;
@@ -2253,7 +2228,7 @@ static int cas_post_rxds_ringN(struct cas *cp, int ring, int num)
 	released = 0;
 	while (entry != last) {
 		/* make a new buffer if it's still in use */
-		if (cas_buffer_count(page[entry]) > 1) {
+		if (page_count(page[entry]->buffer) > 1) {
 			cas_page_t *new = cas_page_dequeue(cp);
 			if (!new) {
 				/* let the timer know that we need to
diff --git a/drivers/net/cassini.h b/drivers/net/cassini.h
index a970804..a201431 100644
--- a/drivers/net/cassini.h
+++ b/drivers/net/cassini.h
@@ -4122,8 +4122,8 @@ cas_saturn_patch_t cas_saturn_patch[] = {
 							     inserted into
 							     outgoing frame. */
 struct cas_tx_desc {
-	u64     control;
-	u64     buffer;
+	__le64     control;
+	__le64     buffer;
 };
 
 /* descriptor ring for free buffers contains page-sized buffers. the index
@@ -4131,8 +4131,8 @@ struct cas_tx_desc {
  * the completion ring.
  */
 struct cas_rx_desc {
-	u64     index;
-	u64     buffer;
+	__le64     index;
+	__le64     buffer;
 };
 
 /* received packets are put on the completion ring. */
@@ -4210,10 +4210,10 @@ struct cas_rx_desc {
 #define RX_INDEX_RELEASE                  0x0000000000002000ULL
 
 struct cas_rx_comp {
-	u64     word1;
-	u64     word2;
-	u64     word3;
-	u64     word4;
+	__le64     word1;
+	__le64     word2;
+	__le64     word3;
+	__le64     word4;
 };
 
 enum link_state {
@@ -4252,7 +4252,7 @@ struct cas_init_block {
 	struct cas_rx_comp rxcs[N_RX_COMP_RINGS][INIT_BLOCK_RX_COMP];
 	struct cas_rx_desc rxds[N_RX_DESC_RINGS][INIT_BLOCK_RX_DESC];
 	struct cas_tx_desc txds[N_TX_RINGS][INIT_BLOCK_TX];
-	u64 tx_compwb;
+	__le64 tx_compwb;
 };
 
 /* tiny buffers to deal with target abort issue. we allocate a bit
diff --git a/drivers/net/chelsio/cxgb2.c b/drivers/net/chelsio/cxgb2.c
index 231ce43..a82a1fa 100644
--- a/drivers/net/chelsio/cxgb2.c
+++ b/drivers/net/chelsio/cxgb2.c
@@ -370,6 +370,8 @@ static char stats_strings[][ETH_GSTRING_LEN] = {
 	"TxInternalMACXmitError",
 	"TxFramesWithExcessiveDeferral",
 	"TxFCSErrors",
+	"TxJumboFramesOk",
+	"TxJumboOctetsOk",
 
 	"RxOctetsOK",
 	"RxOctetsBad",
@@ -388,15 +390,16 @@ static char stats_strings[][ETH_GSTRING_LEN] = {
 	"RxInRangeLengthErrors",
 	"RxOutOfRangeLengthField",
 	"RxFrameTooLongErrors",
+	"RxJumboFramesOk",
+	"RxJumboOctetsOk",
 
 	/* Port stats */
-	"RxPackets",
 	"RxCsumGood",
-	"TxPackets",
 	"TxCsumOffload",
 	"TxTso",
 	"RxVlan",
 	"TxVlan",
+	"TxNeedHeadroom",
 
 	/* Interrupt stats */
 	"rx drops",
@@ -454,23 +457,56 @@ static void get_stats(struct net_device *dev, struct ethtool_stats *stats,
 	const struct cmac_statistics *s;
 	const struct sge_intr_counts *t;
 	struct sge_port_stats ss;
-	unsigned int len;
 
 	s = mac->ops->statistics_update(mac, MAC_STATS_UPDATE_FULL);
-
-	len = sizeof(u64)*(&s->TxFCSErrors + 1 - &s->TxOctetsOK);
-	memcpy(data, &s->TxOctetsOK, len);
-	data += len;
-
-	len = sizeof(u64)*(&s->RxFrameTooLongErrors + 1 - &s->RxOctetsOK);
-	memcpy(data, &s->RxOctetsOK, len);
-	data += len;
-
+	t = t1_sge_get_intr_counts(adapter->sge);
 	t1_sge_get_port_stats(adapter->sge, dev->if_port, &ss);
-	memcpy(data, &ss, sizeof(ss));
-	data += sizeof(ss);
 
-	t = t1_sge_get_intr_counts(adapter->sge);
+	*data++ = s->TxOctetsOK;
+	*data++ = s->TxOctetsBad;
+	*data++ = s->TxUnicastFramesOK;
+	*data++ = s->TxMulticastFramesOK;
+	*data++ = s->TxBroadcastFramesOK;
+	*data++ = s->TxPauseFrames;
+	*data++ = s->TxFramesWithDeferredXmissions;
+	*data++ = s->TxLateCollisions;
+	*data++ = s->TxTotalCollisions;
+	*data++ = s->TxFramesAbortedDueToXSCollisions;
+	*data++ = s->TxUnderrun;
+	*data++ = s->TxLengthErrors;
+	*data++ = s->TxInternalMACXmitError;
+	*data++ = s->TxFramesWithExcessiveDeferral;
+	*data++ = s->TxFCSErrors;
+	*data++ = s->TxJumboFramesOK;
+	*data++ = s->TxJumboOctetsOK;
+
+	*data++ = s->RxOctetsOK;
+	*data++ = s->RxOctetsBad;
+	*data++ = s->RxUnicastFramesOK;
+	*data++ = s->RxMulticastFramesOK;
+	*data++ = s->RxBroadcastFramesOK;
+	*data++ = s->RxPauseFrames;
+	*data++ = s->RxFCSErrors;
+	*data++ = s->RxAlignErrors;
+	*data++ = s->RxSymbolErrors;
+	*data++ = s->RxDataErrors;
+	*data++ = s->RxSequenceErrors;
+	*data++ = s->RxRuntErrors;
+	*data++ = s->RxJabberErrors;
+	*data++ = s->RxInternalMACRcvError;
+	*data++ = s->RxInRangeLengthErrors;
+	*data++ = s->RxOutOfRangeLengthField;
+	*data++ = s->RxFrameTooLongErrors;
+	*data++ = s->RxJumboFramesOK;
+	*data++ = s->RxJumboOctetsOK;
+
+	*data++ = ss.rx_cso_good;
+	*data++ = ss.tx_cso;
+	*data++ = ss.tx_tso;
+	*data++ = ss.vlan_xtract;
+	*data++ = ss.vlan_insert;
+	*data++ = ss.tx_need_hdrroom;
+
 	*data++ = t->rx_drops;
 	*data++ = t->pure_rsps;
 	*data++ = t->unhandled_irqs;
diff --git a/drivers/net/chelsio/pm3393.c b/drivers/net/chelsio/pm3393.c
index 678778a..2117c4f 100644
--- a/drivers/net/chelsio/pm3393.c
+++ b/drivers/net/chelsio/pm3393.c
@@ -45,7 +45,7 @@
 
 #include <linux/crc32.h>
 
-#define OFFSET(REG_ADDR)    (REG_ADDR << 2)
+#define OFFSET(REG_ADDR)    ((REG_ADDR) << 2)
 
 /* Max frame size PM3393 can handle. Includes Ethernet header and CRC. */
 #define MAX_FRAME_SIZE  9600
@@ -428,69 +428,26 @@ static int pm3393_set_speed_duplex_fc(struct cmac *cmac, int speed, int duplex,
 	return 0;
 }
 
-static void pm3393_rmon_update(struct adapter *adapter, u32 offs, u64 *val,
-			       int over)
-{
-	u32 val0, val1, val2;
-
-	t1_tpi_read(adapter, offs, &val0);
-	t1_tpi_read(adapter, offs + 4, &val1);
-	t1_tpi_read(adapter, offs + 8, &val2);
-
-	*val &= ~0ull << 40;
-	*val |= val0 & 0xffff;
-	*val |= (val1 & 0xffff) << 16;
-	*val |= (u64)(val2 & 0xff) << 32;
-
-	if (over)
-		*val += 1ull << 40;
+#define RMON_UPDATE(mac, name, stat_name) \
+{ \
+	t1_tpi_read((mac)->adapter, OFFSET(name), &val0);     \
+	t1_tpi_read((mac)->adapter, OFFSET((name)+1), &val1); \
+	t1_tpi_read((mac)->adapter, OFFSET((name)+2), &val2); \
+	(mac)->stats.stat_name = (u64)(val0 & 0xffff) | \
+				 ((u64)(val1 & 0xffff) << 16) | \
+				 ((u64)(val2 & 0xff) << 32) | \
+				 ((mac)->stats.stat_name & \
+					0xffffff0000000000ULL); \
+	if (ro & \
+	    (1ULL << ((name - SUNI1x10GEXP_REG_MSTAT_COUNTER_0_LOW) >> 2))) \
+		(mac)->stats.stat_name += 1ULL << 40; \
 }
 
 static const struct cmac_statistics *pm3393_update_statistics(struct cmac *mac,
 							      int flag)
 {
-	static struct {
-		unsigned int reg;
-		unsigned int offset;
-	} hw_stats [] = {
-
-#define HW_STAT(name, stat_name) \
-	{ name, (&((struct cmac_statistics *)NULL)->stat_name) - (u64 *)NULL }
-
-		/* Rx stats */
-		HW_STAT(RxOctetsReceivedOK, RxOctetsOK),
-		HW_STAT(RxUnicastFramesReceivedOK, RxUnicastFramesOK),
-		HW_STAT(RxMulticastFramesReceivedOK, RxMulticastFramesOK),
-		HW_STAT(RxBroadcastFramesReceivedOK, RxBroadcastFramesOK),
-		HW_STAT(RxPAUSEMACCtrlFramesReceived, RxPauseFrames),
-		HW_STAT(RxFrameCheckSequenceErrors, RxFCSErrors),
-		HW_STAT(RxFramesLostDueToInternalMACErrors,
-				RxInternalMACRcvError),
-		HW_STAT(RxSymbolErrors, RxSymbolErrors),
-		HW_STAT(RxInRangeLengthErrors, RxInRangeLengthErrors),
-		HW_STAT(RxFramesTooLongErrors , RxFrameTooLongErrors),
-		HW_STAT(RxJabbers, RxJabberErrors),
-		HW_STAT(RxFragments, RxRuntErrors),
-		HW_STAT(RxUndersizedFrames, RxRuntErrors),
-		HW_STAT(RxJumboFramesReceivedOK, RxJumboFramesOK),
-		HW_STAT(RxJumboOctetsReceivedOK, RxJumboOctetsOK),
-
-		/* Tx stats */
-		HW_STAT(TxOctetsTransmittedOK, TxOctetsOK),
-		HW_STAT(TxFramesLostDueToInternalMACTransmissionError,
-				TxInternalMACXmitError),
-		HW_STAT(TxTransmitSystemError, TxFCSErrors),
-		HW_STAT(TxUnicastFramesTransmittedOK, TxUnicastFramesOK),
-		HW_STAT(TxMulticastFramesTransmittedOK, TxMulticastFramesOK),
-		HW_STAT(TxBroadcastFramesTransmittedOK, TxBroadcastFramesOK),
-		HW_STAT(TxPAUSEMACCtrlFramesTransmitted, TxPauseFrames),
-		HW_STAT(TxJumboFramesReceivedOK, TxJumboFramesOK),
-		HW_STAT(TxJumboOctetsReceivedOK, TxJumboOctetsOK)
-	}, *p = hw_stats;
-	u64 ro;
-	u32 val0, val1, val2, val3;
-	u64 *stats = (u64 *) &mac->stats;
-	unsigned int i;
+	u64	ro;
+	u32	val0, val1, val2, val3;
 
 	/* Snap the counters */
 	pmwrite(mac, SUNI1x10GEXP_REG_MSTAT_CONTROL,
@@ -504,14 +461,35 @@ static const struct cmac_statistics *pm3393_update_statistics(struct cmac *mac,
 	ro = ((u64)val0 & 0xffff) | (((u64)val1 & 0xffff) << 16) |
 		(((u64)val2 & 0xffff) << 32) | (((u64)val3 & 0xffff) << 48);
 
-	for (i = 0; i < ARRAY_SIZE(hw_stats); i++) {
-		unsigned reg = p->reg - SUNI1x10GEXP_REG_MSTAT_COUNTER_0_LOW;
-
-		pm3393_rmon_update((mac)->adapter, OFFSET(p->reg),
-				   stats + p->offset, ro & (reg >> 2));
-	}
-
-
+	/* Rx stats */
+	RMON_UPDATE(mac, RxOctetsReceivedOK, RxOctetsOK);
+	RMON_UPDATE(mac, RxUnicastFramesReceivedOK, RxUnicastFramesOK);
+	RMON_UPDATE(mac, RxMulticastFramesReceivedOK, RxMulticastFramesOK);
+	RMON_UPDATE(mac, RxBroadcastFramesReceivedOK, RxBroadcastFramesOK);
+	RMON_UPDATE(mac, RxPAUSEMACCtrlFramesReceived, RxPauseFrames);
+	RMON_UPDATE(mac, RxFrameCheckSequenceErrors, RxFCSErrors);
+	RMON_UPDATE(mac, RxFramesLostDueToInternalMACErrors,
+				RxInternalMACRcvError);
+	RMON_UPDATE(mac, RxSymbolErrors, RxSymbolErrors);
+	RMON_UPDATE(mac, RxInRangeLengthErrors, RxInRangeLengthErrors);
+	RMON_UPDATE(mac, RxFramesTooLongErrors , RxFrameTooLongErrors);
+	RMON_UPDATE(mac, RxJabbers, RxJabberErrors);
+	RMON_UPDATE(mac, RxFragments, RxRuntErrors);
+	RMON_UPDATE(mac, RxUndersizedFrames, RxRuntErrors);
+	RMON_UPDATE(mac, RxJumboFramesReceivedOK, RxJumboFramesOK);
+	RMON_UPDATE(mac, RxJumboOctetsReceivedOK, RxJumboOctetsOK);
+
+	/* Tx stats */
+	RMON_UPDATE(mac, TxOctetsTransmittedOK, TxOctetsOK);
+	RMON_UPDATE(mac, TxFramesLostDueToInternalMACTransmissionError,
+				TxInternalMACXmitError);
+	RMON_UPDATE(mac, TxTransmitSystemError, TxFCSErrors);
+	RMON_UPDATE(mac, TxUnicastFramesTransmittedOK, TxUnicastFramesOK);
+	RMON_UPDATE(mac, TxMulticastFramesTransmittedOK, TxMulticastFramesOK);
+	RMON_UPDATE(mac, TxBroadcastFramesTransmittedOK, TxBroadcastFramesOK);
+	RMON_UPDATE(mac, TxPAUSEMACCtrlFramesTransmitted, TxPauseFrames);
+	RMON_UPDATE(mac, TxJumboFramesReceivedOK, TxJumboFramesOK);
+	RMON_UPDATE(mac, TxJumboOctetsReceivedOK, TxJumboOctetsOK);
 
 	return &mac->stats;
 }
diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
index e4f874a..d77f1eb 100644
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -986,11 +986,10 @@ void t1_sge_get_port_stats(const struct sge *sge, int port,
 	for_each_possible_cpu(cpu) {
 		struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[port], cpu);
 
-		ss->rx_packets += st->rx_packets;
 		ss->rx_cso_good += st->rx_cso_good;
-		ss->tx_packets += st->tx_packets;
 		ss->tx_cso += st->tx_cso;
 		ss->tx_tso += st->tx_tso;
+		ss->tx_need_hdrroom += st->tx_need_hdrroom;
 		ss->vlan_xtract += st->vlan_xtract;
 		ss->vlan_insert += st->vlan_insert;
 	}
@@ -1379,11 +1378,10 @@ static void sge_rx(struct sge *sge, struct freelQ *fl, unsigned int len)
 	}
 	__skb_pull(skb, sizeof(*p));
 
-	skb->dev->last_rx = jiffies;
 	st = per_cpu_ptr(sge->port_stats[p->iff], smp_processor_id());
-	st->rx_packets++;
 
 	skb->protocol = eth_type_trans(skb, adapter->port[p->iff].dev);
+	skb->dev->last_rx = jiffies;
 	if ((adapter->flags & RX_CSUM_ENABLED) && p->csum == 0xffff &&
 	    skb->protocol == htons(ETH_P_IP) &&
 	    (skb->data[9] == IPPROTO_TCP || skb->data[9] == IPPROTO_UDP)) {
@@ -1851,7 +1849,8 @@ int t1_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct adapter *adapter = dev->priv;
 	struct sge *sge = adapter->sge;
-	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port], smp_processor_id());
+	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port],
+						smp_processor_id());
 	struct cpl_tx_pkt *cpl;
 	struct sk_buff *orig_skb = skb;
 	int ret;
@@ -1859,6 +1858,18 @@ int t1_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (skb->protocol == htons(ETH_P_CPL5))
 		goto send;
 
+	/*
+	 * We are using a non-standard hard_header_len.
+	 * Allocate more header room in the rare cases it is not big enough.
+	 */
+	if (unlikely(skb_headroom(skb) < dev->hard_header_len - ETH_HLEN)) {
+		skb = skb_realloc_headroom(skb, sizeof(struct cpl_tx_pkt_lso));
+		++st->tx_need_hdrroom;
+		dev_kfree_skb_any(orig_skb);
+		if (!skb)
+			return NETDEV_TX_OK;
+	}
+
 	if (skb_shinfo(skb)->gso_size) {
 		int eth_type;
 		struct cpl_tx_pkt_lso *hdr;
@@ -1892,24 +1903,6 @@ int t1_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_OK;
 		}
 
-		/*
-		 * We are using a non-standard hard_header_len and some kernel
-		 * components, such as pktgen, do not handle it right.
-		 * Complain when this happens but try to fix things up.
-		 */
-		if (unlikely(skb_headroom(skb) < dev->hard_header_len - ETH_HLEN)) {
-			pr_debug("%s: headroom %d header_len %d\n", dev->name,
-				 skb_headroom(skb), dev->hard_header_len);
-
-			if (net_ratelimit())
-				printk(KERN_ERR "%s: inadequate headroom in "
-				       "Tx packet\n", dev->name);
-			skb = skb_realloc_headroom(skb, sizeof(*cpl));
-			dev_kfree_skb_any(orig_skb);
-			if (!skb)
-				return NETDEV_TX_OK;
-		}
-
 		if (!(adapter->flags & UDP_CSUM_CAPABLE) &&
 		    skb->ip_summed == CHECKSUM_PARTIAL &&
 		    ip_hdr(skb)->protocol == IPPROTO_UDP) {
@@ -1955,7 +1948,6 @@ int t1_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		cpl->vlan_valid = 0;
 
 send:
-	st->tx_packets++;
 	dev->trans_start = jiffies;
 	ret = t1_sge_tx(skb, adapter, 0, dev);
 
diff --git a/drivers/net/chelsio/sge.h b/drivers/net/chelsio/sge.h
index d132a0e..80165f9 100644
--- a/drivers/net/chelsio/sge.h
+++ b/drivers/net/chelsio/sge.h
@@ -57,13 +57,12 @@ struct sge_intr_counts {
 };
 
 struct sge_port_stats {
-	u64 rx_packets;      /* # of Ethernet packets received */
 	u64 rx_cso_good;     /* # of successful RX csum offloads */
-	u64 tx_packets;      /* # of TX packets */
 	u64 tx_cso;          /* # of TX checksum offloads */
 	u64 tx_tso;          /* # of TSO requests */
 	u64 vlan_xtract;     /* # of VLAN tag extractions */
 	u64 vlan_insert;     /* # of VLAN tag insertions */
+	u64 tx_need_hdrroom; /* # of TX skbs in need of more header room */
 };
 
 struct sk_buff;
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 60d2944..4ebb6ea 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -70,7 +70,7 @@
 #define KAWETH_TX_TIMEOUT		(5 * HZ)
 #define KAWETH_SCRATCH_SIZE		32
 #define KAWETH_FIRMWARE_BUF_SIZE	4096
-#define KAWETH_CONTROL_TIMEOUT		(30 * HZ)
+#define KAWETH_CONTROL_TIMEOUT		(30000)
 
 #define KAWETH_STATUS_BROKEN		0x0000001
 #define KAWETH_STATUS_CLOSING		0x0000002
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 6240b97..3bbc5c4 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -94,7 +94,7 @@ static int mcs7830_get_reg(struct usbnet *dev, u16 index, u16 size, void *data)
 
 	ret = usb_control_msg(xdev, usb_rcvctrlpipe(xdev, 0), MCS7830_RD_BREQ,
 			      MCS7830_RD_BMREQ, 0x0000, index, data,
-			      size, msecs_to_jiffies(MCS7830_CTRL_TIMEOUT));
+			      size, MCS7830_CTRL_TIMEOUT);
 	return ret;
 }
 
@@ -105,7 +105,7 @@ static int mcs7830_set_reg(struct usbnet *dev, u16 index, u16 size, void *data)
 
 	ret = usb_control_msg(xdev, usb_sndctrlpipe(xdev, 0), MCS7830_WR_BREQ,
 			      MCS7830_WR_BMREQ, 0x0000, index, data,
-			      size, msecs_to_jiffies(MCS7830_CTRL_TIMEOUT));
+			      size, MCS7830_CTRL_TIMEOUT);
 	return ret;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 749e7d8..9f90c10 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -465,6 +465,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH7_31, quirk
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_0, quirk_ich6_lpc_acpi );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_2, quirk_ich6_lpc_acpi );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_3, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_1, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_4, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_2, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_4, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_7, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_8, quirk_ich6_lpc_acpi );
 
 /*
  * VIA ACPI: One IO region pointed to by longword at
diff --git a/fs/exec.c b/fs/exec.c
index 3da429d..224e973 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1561,6 +1561,12 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	   but keep the previous behaviour for now. */
 	if (!ispipe && !S_ISREG(inode->i_mode))
 		goto close_fail;
+	/*
+	 * Dont allow local users get cute and trick others to coredump
+	 * into their pre-created files:
+	 */
+	if (inode->i_uid != current->fsuid)
+		goto close_fail;
 	if (!file->f_op)
 		goto close_fail;
 	if (!file->f_op->write)
diff --git a/fs/ncpfs/mmap.c b/fs/ncpfs/mmap.c
index 70a6911..f87de97 100644
--- a/fs/ncpfs/mmap.c
+++ b/fs/ncpfs/mmap.c
@@ -47,9 +47,6 @@ static struct page* ncp_file_mmap_nopage(struct vm_area_struct *area,
 	pos = address - area->vm_start + (area->vm_pgoff << PAGE_SHIFT);
 
 	count = PAGE_SIZE;
-	if (address + PAGE_SIZE > area->vm_end) {
-		count = area->vm_end - address;
-	}
 	/* what we can read in one go */
 	bufsize = NCP_SERVER(inode)->buffer_size;
 
diff --git a/include/asm-sparc64/hypervisor.h b/include/asm-sparc64/hypervisor.h
index db2130a..a63a1f6 100644
--- a/include/asm-sparc64/hypervisor.h
+++ b/include/asm-sparc64/hypervisor.h
@@ -709,6 +709,10 @@ extern unsigned long sun4v_mmu_tsb_ctx0(unsigned long num_descriptions,
  */
 #define HV_FAST_MMU_DEMAP_ALL		0x24
 
+#ifndef __ASSEMBLY__
+extern void sun4v_mmu_demap_all(void);
+#endif
+
 /* mmu_map_perm_addr()
  * TRAP:	HV_FAST_TRAP
  * FUNCTION:	HV_FAST_MMU_MAP_PERM_ADDR
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 887c2ce..c6c9d48 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2285,6 +2285,8 @@
 #define PCI_DEVICE_ID_INTEL_ICH9_4	0x2914
 #define PCI_DEVICE_ID_INTEL_ICH9_5	0x2919
 #define PCI_DEVICE_ID_INTEL_ICH9_6	0x2930
+#define PCI_DEVICE_ID_INTEL_ICH9_7	0x2916
+#define PCI_DEVICE_ID_INTEL_ICH9_8	0x2918
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
 #define PCI_DEVICE_ID_INTEL_82830_HB	0x3575
 #define PCI_DEVICE_ID_INTEL_82830_CGC	0x3577
diff --git a/kernel/relay.c b/kernel/relay.c
index 95db8c7..24db7e8 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -91,6 +91,7 @@ int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	vma->vm_ops = &relay_file_mmap_ops;
+	vma->vm_flags |= VM_DONTEXPAND;
 	vma->vm_private_data = buf;
 	buf->chan->cb->buf_mapped(buf, filp);
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 906ed40..33fb671 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2157,7 +2157,7 @@ int install_special_mapping(struct mm_struct *mm,
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 
-	vma->vm_flags = vm_flags | mm->def_flags;
+	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND;
 	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
 
 	vma->vm_ops = &special_mapping_vmops;
diff --git a/net/atm/mpc.c b/net/atm/mpc.c
index 7c85aa5..181c1c8 100644
--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -542,6 +542,13 @@ static int mpc_send_packet(struct sk_buff *skb, struct net_device *dev)
 	if (eth->h_proto != htons(ETH_P_IP))
 		goto non_ip; /* Multi-Protocol Over ATM :-) */
 
+	/* Weed out funny packets (e.g., AF_PACKET or raw). */
+	if (skb->len < ETH_HLEN + sizeof(struct iphdr))
+		goto non_ip;
+	skb_set_network_header(skb, ETH_HLEN);
+	if (skb->len < ETH_HLEN + ip_hdr(skb)->ihl * 4 || ip_hdr(skb)->ihl < 5)
+		goto non_ip;
+
 	while (i < mpc->number_of_mps_macs) {
 		if (!compare_ether_addr(eth->h_dest, (mpc->mps_macs + i*ETH_ALEN)))
 			if ( send_via_shortcut(skb, mpc) == 0 )           /* try shortcut */
diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index 0ddaff0..8a9f0ac 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -124,7 +124,7 @@ int ax25_rx_iframe(ax25_cb *ax25, struct sk_buff *skb)
 		}
 
 		skb_pull(skb, 1);	/* Remove PID */
-		skb_reset_mac_header(skb);
+		skb->mac_header = skb->network_header;
 		skb_reset_network_header(skb);
 		skb->dev      = ax25->ax25_dev->dev;
 		skb->pkt_type = PACKET_HOST;
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 0dcc245..9607d78 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1030,7 +1030,7 @@ static void inetdev_changename(struct net_device *dev, struct in_device *in_dev)
 		memcpy(ifa->ifa_label, dev->name, IFNAMSIZ);
 		if (named++ == 0)
 			continue;
-		dot = strchr(ifa->ifa_label, ':');
+		dot = strchr(old, ':');
 		if (dot == NULL) {
 			sprintf(old, ":%d", named);
 			dot = old;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 6328293..724b612 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -613,7 +613,7 @@ static int ipgre_rcv(struct sk_buff *skb)
 				offset += 4;
 		}
 
-		skb_reset_mac_header(skb);
+		skb->mac_header = skb->network_header;
 		__pskb_pull(skb, offset);
 		skb_reset_network_header(skb);
 		skb_postpull_rcsum(skb, skb_transport_header(skb), offset);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 4aa2551..8f443ed 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2885,11 +2885,10 @@ int ip_rt_dump(struct sk_buff *skb,  struct netlink_callback *cb)
 	int idx, s_idx;
 
 	s_h = cb->args[0];
+	if (s_h < 0)
+		s_h = 0;
 	s_idx = idx = cb->args[1];
-	for (h = 0; h <= rt_hash_mask; h++) {
-		if (h < s_h) continue;
-		if (h > s_h)
-			s_idx = 0;
+	for (h = s_h; h <= rt_hash_mask; h++) {
 		rcu_read_lock_bh();
 		for (rt = rcu_dereference(rt_hash_table[h].chain), idx = 0; rt;
 		     rt = rcu_dereference(rt->u.dst.rt_next), idx++) {
@@ -2906,6 +2905,7 @@ int ip_rt_dump(struct sk_buff *skb,  struct netlink_callback *cb)
 			dst_release(xchg(&skb->dst, NULL));
 		}
 		rcu_read_unlock_bh();
+		s_idx = 0;
 	}
 
 done:
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index dcd7e32..73708b5 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1115,8 +1115,6 @@ static int irda_create(struct socket *sock, int protocol)
 			self->max_sdu_size_rx = TTP_SAR_UNBOUND;
 			break;
 		default:
-			IRDA_ERROR("%s: protocol not supported!\n",
-				   __FUNCTION__);
 			return -ESOCKTNOSUPPORT;
 		}
 		break;
diff --git a/net/key/af_key.c b/net/key/af_key.c
index ca0db0f..0be3be2 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2777,12 +2777,22 @@ static struct sadb_msg *pfkey_get_base_msg(struct sk_buff *skb, int *errp)
 
 static inline int aalg_tmpl_set(struct xfrm_tmpl *t, struct xfrm_algo_desc *d)
 {
-	return t->aalgos & (1 << d->desc.sadb_alg_id);
+	unsigned int id = d->desc.sadb_alg_id;
+
+	if (id >= sizeof(t->aalgos) * 8)
+		return 0;
+
+	return (t->aalgos >> id) & 1;
 }
 
 static inline int ealg_tmpl_set(struct xfrm_tmpl *t, struct xfrm_algo_desc *d)
 {
-	return t->ealgos & (1 << d->desc.sadb_alg_id);
+	unsigned int id = d->desc.sadb_alg_id;
+
+	if (id >= sizeof(t->ealgos) * 8)
+		return 0;
+
+	return (t->ealgos >> id) & 1;
 }
 
 static int count_ah_combs(struct xfrm_tmpl *t)
diff --git a/net/netrom/nr_dev.c b/net/netrom/nr_dev.c
index c7b5d93..69e77d5 100644
--- a/net/netrom/nr_dev.c
+++ b/net/netrom/nr_dev.c
@@ -56,7 +56,7 @@ int nr_rx_ip(struct sk_buff *skb, struct net_device *dev)
 
 	/* Spoof incoming device */
 	skb->dev      = dev;
-	skb_reset_mac_header(skb);
+	skb->mac_header = skb->network_header;
 	skb_reset_network_header(skb);
 	skb->pkt_type = PACKET_HOST;
 
diff --git a/net/x25/x25_forward.c b/net/x25/x25_forward.c
index 8738ec7..3447803 100644
--- a/net/x25/x25_forward.c
+++ b/net/x25/x25_forward.c
@@ -118,13 +118,14 @@ int x25_forward_data(int lci, struct x25_neigh *from, struct sk_buff *skb) {
 		goto out;
 
 	if ( (skbn = pskb_copy(skb, GFP_ATOMIC)) == NULL){
-		goto out;
+		goto output;
 
 	}
 	x25_transmit_link(skbn, nb);
 
-	x25_neigh_put(nb);
 	rc = 1;
+output:
+	x25_neigh_put(nb);
 out:
 	return rc;
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b48f06f..1c86a23 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1479,8 +1479,9 @@ restart:
 
 	if (sk && sk->sk_policy[1]) {
 		policy = xfrm_sk_policy_lookup(sk, XFRM_POLICY_OUT, fl);
+		err = PTR_ERR(policy);
 		if (IS_ERR(policy))
-			return PTR_ERR(policy);
+			goto dropdst;
 	}
 
 	if (!policy) {
@@ -1491,8 +1492,9 @@ restart:
 
 		policy = flow_cache_lookup(fl, dst_orig->ops->family,
 					   dir, xfrm_policy_lookup);
+		err = PTR_ERR(policy);
 		if (IS_ERR(policy))
-			return PTR_ERR(policy);
+			goto dropdst;
 	}
 
 	if (!policy)
@@ -1661,8 +1663,9 @@ restart:
 	return 0;
 
 error:
-	dst_release(dst_orig);
 	xfrm_pols_put(pols, npols);
+dropdst:
+	dst_release(dst_orig);
 	*dst_p = NULL;
 	return err;
 }
diff --git a/sound/oss/via82cxxx_audio.c b/sound/oss/via82cxxx_audio.c
index 5d3c037..f95aa09 100644
--- a/sound/oss/via82cxxx_audio.c
+++ b/sound/oss/via82cxxx_audio.c
@@ -2104,6 +2104,7 @@ static struct page * via_mm_nopage (struct vm_area_struct * vma,
 {
 	struct via_info *card = vma->vm_private_data;
 	struct via_channel *chan = &card->ch_out;
+	unsigned long max_bufs;
 	struct page *dmapage;
 	unsigned long pgoff;
 	int rd, wr;
@@ -2127,14 +2128,11 @@ static struct page * via_mm_nopage (struct vm_area_struct * vma,
 	rd = card->ch_in.is_mapped;
 	wr = card->ch_out.is_mapped;
 
-#ifndef VIA_NDEBUG
-	{
-	unsigned long max_bufs = chan->frag_number;
-	if (rd && wr) max_bufs *= 2;
-	/* via_dsp_mmap() should ensure this */
-	assert (pgoff < max_bufs);
-	}
-#endif
+	max_bufs = chan->frag_number;
+	if (rd && wr)
+		max_bufs *= 2;
+	if (pgoff >= max_bufs)
+		return NOPAGE_SIGBUS;
 
 	/* if full-duplex (read+write) and we have two sets of bufs,
 	 * then the playback buffers come first, sez soundcard.c */
diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index b76b3dd..e617d7e 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -88,7 +88,7 @@ static int snd_us428ctls_mmap(struct snd_hwdep * hw, struct file *filp, struct v
 		us428->us428ctls_sharedmem->CtlSnapShotLast = -2;
 	}
 	area->vm_ops = &us428ctls_vm_ops;
-	area->vm_flags |= VM_RESERVED;
+	area->vm_flags |= VM_RESERVED | VM_DONTEXPAND;
 	area->vm_private_data = hw->private_data;
 	return 0;
 }
diff --git a/sound/usb/usx2y/usx2yhwdeppcm.c b/sound/usb/usx2y/usx2yhwdeppcm.c
index a5e7bcd..6e70520 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -728,7 +728,7 @@ static int snd_usX2Y_hwdep_pcm_mmap(struct snd_hwdep * hw, struct file *filp, st
 		return -ENODEV;
 	}
 	area->vm_ops = &snd_usX2Y_hwdep_pcm_vm_ops;
-	area->vm_flags |= VM_RESERVED;
+	area->vm_flags |= VM_RESERVED | VM_DONTEXPAND;
 	area->vm_private_data = hw->private_data;
 	return 0;
 }

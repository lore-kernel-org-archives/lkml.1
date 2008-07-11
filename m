Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYGKPPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYGKPPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYGKPO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:14:59 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64588 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbYGKPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:14:57 -0400
X-BigFish: VPS3(zz10d1Izz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3UL0C-04-EOI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/16] AMD IOMMU: add comments to core code
Date: Fri, 11 Jul 2008 17:14:22 +0200
Message-ID: <1215789275-20975-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0039 (UTC) FILETIME=[D471C970:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds comments about how the AMD IOMMU core code works for the DMA
remapping functionality.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  201 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 199 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f2766d8..4bae96c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -34,6 +34,9 @@
 
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 
+/*
+ * general struct to manage commands send to an IOMMU
+ */
 struct command {
 	u32 data[4];
 };
@@ -41,11 +44,22 @@ struct command {
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
 
+/* returns !0 if the IOMMU is caching non-present entries in its TLB */
 static int iommu_has_npcache(struct amd_iommu *iommu)
 {
 	return iommu->cap & IOMMU_CAP_NPCACHE;
 }
 
+/****************************************************************************
+ *
+ * IOMMU command queuing functions
+ *
+ ****************************************************************************/
+
+/*
+ * Writes the command to the IOMMUs command buffer and informs the
+ * hardware about the new command. Must be called with iommu->lock held.
+ */
 static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
 {
 	u32 tail, head;
@@ -63,6 +77,10 @@ static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
 	return 0;
 }
 
+/*
+ * General queuing function for commands. Takes iommu->lock and calls
+ * __iommu_queue_command().
+ */
 static int iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
 {
 	unsigned long flags;
@@ -75,6 +93,13 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
 	return ret;
 }
 
+/*
+ * This function is called whenever we need to ensure that the IOMMU has
+ * completed execution of all commands we sent. It sends a
+ * COMPLETION_WAIT command and waits for it to finish. The IOMMU informs
+ * us about that by writing a value to a physical address we pass with
+ * the command.
+ */
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
 	int ret;
@@ -101,6 +126,9 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	return 0;
 }
 
+/*
+ * Command send function for invalidating a device table entry
+ */
 static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 {
 	struct command cmd;
@@ -116,6 +144,9 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 	return iommu_queue_command(iommu, &cmd);
 }
 
+/*
+ * Generic command send function for invalidaing TLB entries
+ */
 static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 		u64 address, u16 domid, int pde, int s)
 {
@@ -127,9 +158,9 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	cmd.data[1] |= domid;
 	cmd.data[2] = LOW_U32(address);
 	cmd.data[3] = HIGH_U32(address);
-	if (s)
+	if (s) /* size bit - we flush more than one 4kb page */
 		cmd.data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
-	if (pde)
+	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
 		cmd.data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
 
 	iommu->need_sync = 1;
@@ -137,6 +168,11 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	return iommu_queue_command(iommu, &cmd);
 }
 
+/*
+ * TLB invalidation function which is called from the mapping functions.
+ * It invalidates a single PTE if the range to flush is within a single
+ * page. Otherwise it flushes the whole TLB of the IOMMU.
+ */
 static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 		u64 address, size_t size)
 {
@@ -159,6 +195,20 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 	return 0;
 }
 
+/****************************************************************************
+ *
+ * The functions below are used the create the page table mappings for
+ * unity mapped regions.
+ *
+ ****************************************************************************/
+
+/*
+ * Generic mapping functions. It maps a physical address into a DMA
+ * address space. It allocates the page table pages if necessary.
+ * In the future it can be extended to a generic mapping function
+ * supporting all features of AMD IOMMU page tables like level skipping
+ * and full 64 bit address spaces.
+ */
 static int iommu_map(struct protection_domain *dom,
 		     unsigned long bus_addr,
 		     unsigned long phys_addr,
@@ -209,6 +259,10 @@ static int iommu_map(struct protection_domain *dom,
 	return 0;
 }
 
+/*
+ * This function checks if a specific unity mapping entry is needed for
+ * this specific IOMMU.
+ */
 static int iommu_for_unity_map(struct amd_iommu *iommu,
 			       struct unity_map_entry *entry)
 {
@@ -223,6 +277,12 @@ static int iommu_for_unity_map(struct amd_iommu *iommu,
 	return 0;
 }
 
+/*
+ * Init the unity mappings for a specific IOMMU in the system
+ *
+ * Basically iterates over all unity mapping entries and applies them to
+ * the default domain DMA of that IOMMU if necessary.
+ */
 static int iommu_init_unity_mappings(struct amd_iommu *iommu)
 {
 	struct unity_map_entry *entry;
@@ -239,6 +299,10 @@ static int iommu_init_unity_mappings(struct amd_iommu *iommu)
 	return 0;
 }
 
+/*
+ * This function actually applies the mapping to the page table of the
+ * dma_ops domain.
+ */
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e)
 {
@@ -261,6 +325,9 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 	return 0;
 }
 
+/*
+ * Inits the unity mappings required for a specific device
+ */
 static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
 					  u16 devid)
 {
@@ -278,12 +345,26 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
 	return 0;
 }
 
+/****************************************************************************
+ *
+ * The next functions belong to the address allocator for the dma_ops
+ * interface functions. They work like the allocators in the other IOMMU
+ * drivers. Its basically a bitmap which marks the allocated pages in
+ * the aperture. Maybe it could be enhanced in the future to a more
+ * efficient allocator.
+ *
+ ****************************************************************************/
 static unsigned long dma_mask_to_pages(unsigned long mask)
 {
 	return (mask >> PAGE_SHIFT) +
 		(PAGE_ALIGN(mask & ~PAGE_MASK) >> PAGE_SHIFT);
 }
 
+/*
+ * The address allocator core function.
+ *
+ * called with domain->lock held
+ */
 static unsigned long dma_ops_alloc_addresses(struct device *dev,
 					     struct dma_ops_domain *dom,
 					     unsigned int pages)
@@ -317,6 +398,11 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 	return address;
 }
 
+/*
+ * The address free function.
+ *
+ * called with domain->lock held
+ */
 static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 				   unsigned long address,
 				   unsigned int pages)
@@ -325,6 +411,16 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 	iommu_area_free(dom->bitmap, address, pages);
 }
 
+/****************************************************************************
+ *
+ * The next functions belong to the domain allocation. A domain is
+ * allocated for every IOMMU as the default domain. If device isolation
+ * is enabled, every device get its own domain. The most important thing
+ * about domains is the page table mapping the DMA address space they
+ * contain.
+ *
+ ****************************************************************************/
+
 static u16 domain_id_alloc(void)
 {
 	unsigned long flags;
@@ -342,6 +438,10 @@ static u16 domain_id_alloc(void)
 	return id;
 }
 
+/*
+ * Used to reserve address ranges in the aperture (e.g. for exclusion
+ * ranges.
+ */
 static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages)
@@ -382,6 +482,10 @@ static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
 	free_page((unsigned long)p1);
 }
 
+/*
+ * Free a domain, only used if something went wrong in the
+ * allocation path and we need to free an already allocated page table
+ */
 static void dma_ops_domain_free(struct dma_ops_domain *dom)
 {
 	if (!dom)
@@ -396,6 +500,11 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
 	kfree(dom);
 }
 
+/*
+ * Allocates a new protection domain usable for the dma_ops functions.
+ * It also intializes the page table and the address allocator data
+ * structures required for the dma_ops interface
+ */
 static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 						   unsigned order)
 {
@@ -436,6 +545,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->bitmap[0] = 1;
 	dma_dom->next_bit = 0;
 
+	/* Intialize the exclusion range if necessary */
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
 		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
@@ -444,6 +554,11 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
 
+	/*
+	 * At the last step, build the page tables so we don't need to
+	 * allocate page table pages in the dma_ops mapping/unmapping
+	 * path.
+	 */
 	num_pte_pages = dma_dom->aperture_size / (PAGE_SIZE * 512);
 	dma_dom->pte_pages = kzalloc(num_pte_pages * sizeof(void *),
 			GFP_KERNEL);
@@ -472,6 +587,10 @@ free_dma_dom:
 	return NULL;
 }
 
+/*
+ * Find out the protection domain structure for a given PCI device. This
+ * will give us the pointer to the page table root for example.
+ */
 static struct protection_domain *domain_for_device(u16 devid)
 {
 	struct protection_domain *dom;
@@ -484,6 +603,10 @@ static struct protection_domain *domain_for_device(u16 devid)
 	return dom;
 }
 
+/*
+ * If a device is not yet associated with a domain, this function does
+ * assigns it visible for the hardware
+ */
 static void set_device_domain(struct amd_iommu *iommu,
 			      struct protection_domain *domain,
 			      u16 devid)
@@ -508,6 +631,19 @@ static void set_device_domain(struct amd_iommu *iommu,
 	iommu->need_sync = 1;
 }
 
+/*****************************************************************************
+ *
+ * The next functions belong to the dma_ops mapping/unmapping code.
+ *
+ *****************************************************************************/
+
+/*
+ * In the dma_ops path we only have the struct device. This function
+ * finds the corresponding IOMMU, the protection domain and the
+ * requestor id for a given device.
+ * If the device is not yet associated with a domain this is also done
+ * in this function.
+ */
 static int get_device_resources(struct device *dev,
 				struct amd_iommu **iommu,
 				struct protection_domain **domain,
@@ -522,6 +658,7 @@ static int get_device_resources(struct device *dev,
 	pcidev = to_pci_dev(dev);
 	_bdf = (pcidev->bus->number << 8) | pcidev->devfn;
 
+	/* device not translated by any IOMMU in the system? */
 	if (_bdf >= amd_iommu_last_bdf) {
 		*iommu = NULL;
 		*domain = NULL;
@@ -547,6 +684,10 @@ static int get_device_resources(struct device *dev,
 	return 1;
 }
 
+/*
+ * This is the generic map function. It maps one 4kb page at paddr to
+ * the given address in the DMA address space for the domain.
+ */
 static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 				     struct dma_ops_domain *dom,
 				     unsigned long address,
@@ -578,6 +719,9 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 	return (dma_addr_t)address;
 }
 
+/*
+ * The generic unmapping function for on page in the DMA address space.
+ */
 static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 				 struct dma_ops_domain *dom,
 				 unsigned long address)
@@ -597,6 +741,12 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 	*pte = 0ULL;
 }
 
+/*
+ * This function contains common code for mapping of a physically
+ * contiguous memory region into DMA address space. It is uses by all
+ * mapping functions provided by this IOMMU driver.
+ * Must be called with the domain lock held.
+ */
 static dma_addr_t __map_single(struct device *dev,
 			       struct amd_iommu *iommu,
 			       struct dma_ops_domain *dma_dom,
@@ -628,6 +778,10 @@ out:
 	return address;
 }
 
+/*
+ * Does the reverse of the __map_single function. Must be called with
+ * the domain lock held too
+ */
 static void __unmap_single(struct amd_iommu *iommu,
 			   struct dma_ops_domain *dma_dom,
 			   dma_addr_t dma_addr,
@@ -652,6 +806,9 @@ static void __unmap_single(struct amd_iommu *iommu,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 }
 
+/*
+ * The exported map_single function for dma_ops.
+ */
 static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 			     size_t size, int dir)
 {
@@ -664,6 +821,7 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	get_device_resources(dev, &iommu, &domain, &devid);
 
 	if (iommu == NULL || domain == NULL)
+		/* device not handled by any AMD IOMMU */
 		return (dma_addr_t)paddr;
 
 	spin_lock_irqsave(&domain->lock, flags);
@@ -683,6 +841,9 @@ out:
 	return addr;
 }
 
+/*
+ * The exported unmap_single function for dma_ops.
+ */
 static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 			 size_t size, int dir)
 {
@@ -692,6 +853,7 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 	u16 devid;
 
 	if (!get_device_resources(dev, &iommu, &domain, &devid))
+		/* device not handled by any AMD IOMMU */
 		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
@@ -706,6 +868,10 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
+/*
+ * This is a special map_sg function which is used if we should map a
+ * device which is not handled by an AMD IOMMU in the system.
+ */
 static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
 			   int nelems, int dir)
 {
@@ -720,6 +886,10 @@ static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
 	return nelems;
 }
 
+/*
+ * The exported map_sg function for dma_ops (handles scatter-gather
+ * lists).
+ */
 static int map_sg(struct device *dev, struct scatterlist *sglist,
 		  int nelems, int dir)
 {
@@ -775,6 +945,10 @@ unmap:
 	goto out;
 }
 
+/*
+ * The exported map_sg function for dma_ops (handles scatter-gather
+ * lists).
+ */
 static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		     int nelems, int dir)
 {
@@ -804,6 +978,9 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
+/*
+ * The exported alloc_coherent function for dma_ops.
+ */
 static void *alloc_coherent(struct device *dev, size_t size,
 			    dma_addr_t *dma_addr, gfp_t flag)
 {
@@ -851,6 +1028,11 @@ out:
 	return virt_addr;
 }
 
+/*
+ * The exported free_coherent function for dma_ops.
+ * FIXME: fix the generic x86 DMA layer so that it actually calls that
+ *        function.
+ */
 static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr)
 {
@@ -879,6 +1061,8 @@ free_mem:
 }
 
 /*
+ * The function for pre-allocating protection domains.
+ *
  * If the driver core informs the DMA layer if a driver grabs a device
  * we don't need to preallocate the protection domains anymore.
  * For now we have to.
@@ -921,12 +1105,20 @@ static struct dma_mapping_ops amd_iommu_dma_ops = {
 	.unmap_sg = unmap_sg,
 };
 
+/*
+ * The function which clues the AMD IOMMU driver into dma_ops.
+ */
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
 	int order = amd_iommu_aperture_order;
 	int ret;
 
+	/*
+	 * first allocate a default protection domain for every IOMMU we
+	 * found in the system. Devices not assigned to any other
+	 * protection domain will be assigned to the default one.
+	 */
 	list_for_each_entry(iommu, &amd_iommu_list, list) {
 		iommu->default_dom = dma_ops_domain_alloc(iommu, order);
 		if (iommu->default_dom == NULL)
@@ -936,6 +1128,10 @@ int __init amd_iommu_init_dma_ops(void)
 			goto free_domains;
 	}
 
+	/*
+	 * If device isolation is enabled, pre-allocate the protection
+	 * domains for each device.
+	 */
 	if (amd_iommu_isolate)
 		prealloc_protection_domains();
 
@@ -947,6 +1143,7 @@ int __init amd_iommu_init_dma_ops(void)
 	gart_iommu_aperture = 0;
 #endif
 
+	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
 
 	return 0;
-- 
1.5.3.7



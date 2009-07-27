Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbZG0PEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbZG0PEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZG0PEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:04:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39562 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZG0PEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:04:11 -0400
Subject: [RFC] Make AGP work with IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: airlied@linux.ie, Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 16:04:01 +0100
Message-Id: <1248707041.6100.35.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on some patches from Zhenyu that I found at
http://people.freedesktop.org/~zhen/agp-mm-*, this set of patches stops
the Intel graphics drivers from being utterly broken when the IOMMU is
enabled...

	http://git.infradead.org/users/dwmw2/iommu-agp.git

I'm still seeing write faults to seemingly random addresses at startup
when I first enable the IOMMU (and before the gfx driver actually
starts). Those happen even when I don't use any graphics drivers at all,
though.

And I'm slightly confused about the way we use the scratch page without
mask_memory().

commit d8450c7be46afd0b51d2dc171c9d2eb60366ce05
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Mon Jul 27 12:59:57 2009 +0100

    intel_agp: Use PCI DMA API correctly on chipsets new enough to have IOMMU
    
    When graphics dma remapping engine is active, we must fill
    gart table with dma address from dmar engine, as now graphics
    device access to graphics memory must go through dma remapping
    table to get real physical address.
    
    Add this support to all drivers which use intel_i915_insert_entries()
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit ca8cdb1f983c508f586b90870703e85aab87659a
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Thu Jul 23 17:25:49 2009 +0100

    agp: Add generic support for graphics dma remapping
    
    New driver hooks for support graphics memory dma remapping
    are introduced in this patch. It makes generic code can
    tell if current device needs dma remapping, then call driver
    provided interfaces for mapping and unmapping. Change has
    also been made to handle scratch_page in remapping case.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit 42a509b9cd513ddd536c38cc302c7457a3c811d7
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Mon Jul 27 10:27:29 2009 +0100

    agp: Switch mask_memory() method to take address argument again, not page
    
    In commit 07613ba2 ("agp: switch AGP to use page array instead of
    unsigned long array") we switched the mask_memory() method to take a
    'struct page *' instead of an address. This is painful, because in some
    cases it has to be an IOMMU-mapped virtual bus address (in fact,
    shouldn't it _always_ be a dma_addr_t returned from pci_map_xxx(), and
    we just happen to get lucky most of the time?)
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 178e2e9..17e6d0d 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -107,7 +107,7 @@ struct agp_bridge_driver {
 	void (*agp_enable)(struct agp_bridge_data *, u32);
 	void (*cleanup)(void);
 	void (*tlb_flush)(struct agp_memory *);
-	unsigned long (*mask_memory)(struct agp_bridge_data *, struct page *, int);
+	unsigned long (*mask_memory)(struct agp_bridge_data *, dma_addr_t, int);
 	void (*cache_flush)(void);
 	int (*create_gatt_table)(struct agp_bridge_data *);
 	int (*free_gatt_table)(struct agp_bridge_data *);
@@ -121,6 +121,11 @@ struct agp_bridge_driver {
 	void (*agp_destroy_pages)(struct agp_memory *);
 	int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
 	void (*chipset_flush)(struct agp_bridge_data *);
+
+	int (*agp_map_page)(void *addr, dma_addr_t *ret);
+	void (*agp_unmap_page)(void *addr, dma_addr_t dma);
+	int (*agp_map_memory)(struct agp_memory *mem);
+	void (*agp_unmap_memory)(struct agp_memory *mem);
 };
 
 struct agp_bridge_data {
@@ -135,6 +140,7 @@ struct agp_bridge_data {
 	u32 *gatt_table_real;
 	unsigned long scratch_page;
 	unsigned long scratch_page_real;
+	dma_addr_t scratch_page_dma;
 	unsigned long gart_bus_addr;
 	unsigned long gatt_bus_addr;
 	u32 mode;
@@ -291,7 +297,7 @@ int agp_3_5_enable(struct agp_bridge_data *bridge);
 void global_cache_flush(void);
 void get_agp_version(struct agp_bridge_data *bridge);
 unsigned long agp_generic_mask_memory(struct agp_bridge_data *bridge,
-				      struct page *page, int type);
+				      dma_addr_t phys, int type);
 int agp_generic_type_to_mask_type(struct agp_bridge_data *bridge,
 				  int type);
 struct agp_bridge_data *agp_generic_find_bridge(struct pci_dev *pdev);
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index ba9bde7..542a878 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -325,7 +325,9 @@ static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = GET_GATT(addr);
 		writel(agp_generic_mask_memory(agp_bridge,
-			mem->pages[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
+					       phys_to_gart(page_to_phys(mem->pages[i])),
+					       mem->type),
+		       cur_gatt+GET_GATT_OFF(addr));
 		readl(cur_gatt+GET_GATT_OFF(addr));	/* PCI Posting. */
 	}
 	amd_irongate_tlbflush(mem);
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 3bf5dda..e85a5b3 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -79,7 +79,8 @@ static int amd64_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		tmp = agp_bridge->driver->mask_memory(agp_bridge,
-			mem->pages[i], mask_type);
+						      phys_to_gart(page_to_phys(mem->pages[i])),
+						      mask_type);
 
 		BUG_ON(tmp & 0xffffff0000000ffcULL);
 		pte = (tmp & 0x000000ff00000000ULL) >> 28;
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 33656e1..59ebd60 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -302,7 +302,8 @@ static int ati_insert_memory(struct agp_memory * mem,
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = GET_GATT(addr);
 		writel(agp_bridge->driver->mask_memory(agp_bridge,	
-						       mem->pages[i], mem->type),
+						       phys_to_gart(page_to_phys(mem->pages[i])),
+						       mem->type),
 		       cur_gatt+GET_GATT_OFF(addr));
 	}
 	readl(GET_GATT(agp_bridge->gart_bus_addr)); /* PCI posting */
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index cfa5a64..19ac366 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -150,8 +150,17 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 		}
 
 		bridge->scratch_page_real = phys_to_gart(page_to_phys(page));
-		bridge->scratch_page =
-		    bridge->driver->mask_memory(bridge, page, 0);
+		bridge->scratch_page = bridge->driver->mask_memory(bridge,
+					   phys_to_gart(page_to_phys(page)), 0);
+
+		if (bridge->driver->agp_map_page &&
+		    bridge->driver->agp_map_page(phys_to_virt(page_to_phys(page)),
+						&bridge->scratch_page_dma)) {
+			dev_err(&bridge->dev->dev,
+				"unable to dma-map scratch page\n");
+			rc = -ENOMEM;
+			goto err_out_nounmap;
+		}
 	}
 
 	size_value = bridge->driver->fetch_size();
@@ -191,6 +200,13 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 	return 0;
 
 err_out:
+	if (bridge->driver->needs_scratch_page &&
+	    bridge->driver->agp_unmap_page) {
+		void *va = gart_to_virt(bridge->scratch_page_real);
+
+		bridge->driver->agp_unmap_page(va, bridge->scratch_page_dma);
+	}
+err_out_nounmap:
 	if (bridge->driver->needs_scratch_page) {
 		void *va = gart_to_virt(bridge->scratch_page_real);
 
@@ -221,6 +237,10 @@ static void agp_backend_cleanup(struct agp_bridge_data *bridge)
 	    bridge->driver->needs_scratch_page) {
 		void *va = gart_to_virt(bridge->scratch_page_real);
 
+		if (bridge->driver->agp_unmap_page)
+			bridge->driver->agp_unmap_page(va,
+					       bridge->scratch_page_dma);
+
 		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
 		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
 	}
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 1e8b461..28f0208 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -437,6 +437,12 @@ int agp_bind_memory(struct agp_memory *curr, off_t pg_start)
 		curr->bridge->driver->cache_flush();
 		curr->is_flushed = true;
 	}
+
+	if (curr->bridge->driver->agp_map_memory) {
+		ret_val = curr->bridge->driver->agp_map_memory(curr);
+		if (ret_val)
+			return ret_val;
+	}
 	ret_val = curr->bridge->driver->insert_memory(curr, pg_start, curr->type);
 
 	if (ret_val != 0)
@@ -478,6 +484,9 @@ int agp_unbind_memory(struct agp_memory *curr)
 	if (ret_val != 0)
 		return ret_val;
 
+	if (curr->bridge->driver->agp_unmap_memory)
+		curr->bridge->driver->agp_unmap_memory(curr);
+
 	curr->is_bound = false;
 	curr->pg_start = 0;
 	spin_lock(&curr->bridge->mapped_lock);
@@ -1132,7 +1141,9 @@ int agp_generic_insert_memory(struct agp_memory * mem, off_t pg_start, int type)
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
-		writel(bridge->driver->mask_memory(bridge, mem->pages[i], mask_type),
+		writel(bridge->driver->mask_memory(bridge,
+						   phys_to_gart(page_to_phys(mem->pages[i])),
+						   mask_type),
 		       bridge->gatt_table+j);
 	}
 	readl(bridge->gatt_table+j-1);	/* PCI Posting. */
@@ -1347,9 +1358,8 @@ void global_cache_flush(void)
 EXPORT_SYMBOL(global_cache_flush);
 
 unsigned long agp_generic_mask_memory(struct agp_bridge_data *bridge,
-				      struct page *page, int type)
+				      dma_addr_t addr, int type)
 {
-	unsigned long addr = phys_to_gart(page_to_phys(page));
 	/* memory type is ignored in the generic routine */
 	if (bridge->driver->masks)
 		return addr | bridge->driver->masks[0].mask;
diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
index 8f3d4c1..64dbf4b 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -394,10 +394,8 @@ hp_zx1_remove_memory (struct agp_memory *mem, off_t pg_start, int type)
 }
 
 static unsigned long
-hp_zx1_mask_memory (struct agp_bridge_data *bridge,
-		    struct page *page, int type)
+hp_zx1_mask_memory (struct agp_bridge_data *bridge, dma_addr_t addr, int type)
 {
-	unsigned long addr = phys_to_gart(page_to_phys(page));
 	return HP_ZX1_PDIR_VALID_BIT | addr;
 }
 
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index 60cc35b..54191f8 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -61,7 +61,7 @@
 #define WR_FLUSH_GATT(index)	RD_GATT(index)
 
 static unsigned long i460_mask_memory (struct agp_bridge_data *bridge,
-				       unsigned long addr, int type);
+				       dma_addr_t addr, int type);
 
 static struct {
 	void *gatt;				/* ioremap'd GATT area */
@@ -546,20 +546,13 @@ static void i460_destroy_page (struct page *page, int flags)
 #endif /* I460_LARGE_IO_PAGES */
 
 static unsigned long i460_mask_memory (struct agp_bridge_data *bridge,
-				       unsigned long addr, int type)
+				       dma_addr_t addr, int type)
 {
 	/* Make sure the returned address is a valid GATT entry */
 	return bridge->driver->masks[0].mask
 		| (((addr & ~((1 << I460_IO_PAGE_SHIFT) - 1)) & 0xfffff000) >> 12);
 }
 
-static unsigned long i460_page_mask_memory(struct agp_bridge_data *bridge,
-					   struct page *page, int type)
-{
-	unsigned long addr = phys_to_gart(page_to_phys(page));
-	return i460_mask_memory(bridge, addr, type);
-}
-
 const struct agp_bridge_driver intel_i460_driver = {
 	.owner			= THIS_MODULE,
 	.aperture_sizes		= i460_sizes,
@@ -569,7 +562,7 @@ const struct agp_bridge_driver intel_i460_driver = {
 	.fetch_size		= i460_fetch_size,
 	.cleanup		= i460_cleanup,
 	.tlb_flush		= i460_tlb_flush,
-	.mask_memory		= i460_page_mask_memory,
+	.mask_memory		= i460_mask_memory,
 	.masks			= i460_masks,
 	.agp_enable		= agp_generic_enable,
 	.cache_flush		= global_cache_flush,
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 8c9d50d..20fe82b 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -10,6 +10,16 @@
 #include <linux/agp_backend.h>
 #include "agp.h"
 
+/*
+ * If we have Intel graphics, we're not going to have anything other than
+ * an Intel IOMMU. So make the correct use of the PCI DMA API contingent
+ * on the Intel IOMMU support (CONFIG_DMAR).
+ * Only newer chipsets need to bother with this, of course.
+ */
+#ifdef CONFIG_DMAR
+#define USE_PCI_DMA_API 1
+#endif
+
 #define PCI_DEVICE_ID_INTEL_E7221_HB	0x2588
 #define PCI_DEVICE_ID_INTEL_E7221_IG	0x258a
 #define PCI_DEVICE_ID_INTEL_82946GZ_HB      0x2970
@@ -170,6 +180,131 @@ static struct _intel_private {
 	int resource_valid;
 } intel_private;
 
+#ifdef USE_PCI_DMA_API
+static int intel_agp_map_page(void *addr, dma_addr_t *ret)
+{
+	*ret = pci_map_single(intel_private.pcidev, addr,
+			      PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
+	if (pci_dma_mapping_error(intel_private.pcidev, *ret))
+		return -EINVAL;
+	return 0;
+}
+
+static void intel_agp_unmap_page(void *addr, dma_addr_t dma)
+{
+	pci_unmap_single(intel_private.pcidev, dma,
+			 PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
+}
+
+static int intel_agp_map_memory(struct agp_memory *mem)
+{
+	struct scatterlist *sg;
+	int i;
+
+	DBG("try mapping %lu pages\n", (unsigned long)mem->page_count);
+
+	if ((mem->page_count * sizeof(*mem->sg_list)) < 2*PAGE_SIZE)
+		mem->sg_list = kcalloc(mem->page_count, sizeof(*mem->sg_list),
+				       GFP_KERNEL);
+
+	if (mem->sg_list == NULL) {
+		mem->sg_list = vmalloc(mem->page_count * sizeof(*mem->sg_list));
+		mem->sg_vmalloc_flag = 1;
+	}
+
+	if (!mem->sg_list) {
+		mem->sg_vmalloc_flag = 0;
+		return -ENOMEM;
+	}
+	sg_init_table(mem->sg_list, mem->page_count);
+
+	sg = mem->sg_list;
+	for (i = 0 ; i < mem->page_count; i++, sg = sg_next(sg))
+		sg_set_page(sg, mem->pages[i], PAGE_SIZE, 0);
+
+	mem->num_sg = pci_map_sg(intel_private.pcidev, mem->sg_list,
+				 mem->page_count, PCI_DMA_BIDIRECTIONAL);
+	if (!mem->num_sg) {
+		if (mem->sg_vmalloc_flag)
+			vfree(mem->sg_list);
+		else
+			kfree(mem->sg_list);
+		mem->sg_list = NULL;
+		mem->sg_vmalloc_flag = 0;
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void intel_agp_unmap_memory(struct agp_memory *mem)
+{
+	DBG("try unmapping %lu pages\n", (unsigned long)mem->page_count);
+
+	pci_unmap_sg(intel_private.pcidev, mem->sg_list,
+		     mem->page_count, PCI_DMA_BIDIRECTIONAL);
+	if (mem->sg_vmalloc_flag)
+		vfree(mem->sg_list);
+	else
+		kfree(mem->sg_list);
+	mem->sg_vmalloc_flag = 0;
+	mem->sg_list = NULL;
+	mem->num_sg = 0;
+}
+
+static void intel_agp_insert_sg_entries(struct agp_memory *mem,
+					off_t pg_start, int mask_type)
+{
+	struct scatterlist *sg;
+	int i, j;
+
+	j = pg_start;
+
+	WARN_ON(!mem->num_sg);
+
+	if (mem->num_sg == mem->page_count) {
+		for_each_sg(mem->sg_list, sg, mem->page_count, i) {
+			writel(agp_bridge->driver->mask_memory(agp_bridge,
+					sg_dma_address(sg), mask_type),
+					intel_private.gtt+j);
+			j++;
+		}
+	} else {
+		/* sg may merge pages, but we have to seperate
+		 * per-page addr for GTT */
+		unsigned int len, m;
+
+		for_each_sg(mem->sg_list, sg, mem->num_sg, i) {
+			len = sg_dma_len(sg) / PAGE_SIZE;
+			for (m = 0; m < len; m++) {
+				writel(agp_bridge->driver->mask_memory(agp_bridge,
+								       sg_dma_address(sg) + m * PAGE_SIZE,
+								       mask_type),
+				       intel_private.gtt+j);
+				j++;
+			}
+		}
+	}
+	readl(intel_private.gtt+j-1);
+}
+
+#else
+
+static void intel_agp_insert_sg_entries(struct agp_memory *mem,
+					off_t pg_start, int mask_type)
+{
+	int i, j;
+
+	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
+		writel(agp_bridge->driver->mask_memory(agp_bridge,
+			       phys_to_gart(page_to_phys(mem->pages[i])), mask_type),
+		       intel_private.gtt+j);
+	}
+
+	readl(intel_private.gtt+j-1);
+}
+
+#endif
+
 static int intel_i810_fetch_size(void)
 {
 	u32 smram_miscc;
@@ -343,7 +478,7 @@ static int intel_i810_insert_entries(struct agp_memory *mem, off_t pg_start,
 			global_cache_flush();
 		for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 			writel(agp_bridge->driver->mask_memory(agp_bridge,
-							       mem->pages[i],
+							       phys_to_gart(page_to_phys(mem->pages[i])),
 							       mask_type),
 			       intel_private.registers+I810_PTE_BASE+(j*4));
 		}
@@ -461,9 +596,8 @@ static void intel_i810_free_by_type(struct agp_memory *curr)
 }
 
 static unsigned long intel_i810_mask_memory(struct agp_bridge_data *bridge,
-					    struct page *page, int type)
+					    dma_addr_t addr, int type)
 {
-	unsigned long addr = phys_to_gart(page_to_phys(page));
 	/* Type checking must be done elsewhere */
 	return addr | bridge->driver->masks[type].mask;
 }
@@ -851,7 +985,7 @@ static int intel_i830_insert_entries(struct agp_memory *mem, off_t pg_start,
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
-						       mem->pages[i], mask_type),
+			       phys_to_gart(page_to_phys(mem->pages[i])), mask_type),
 		       intel_private.registers+I810_PTE_BASE+(j*4));
 	}
 	readl(intel_private.registers+I810_PTE_BASE+((j-1)*4));
@@ -1004,9 +1138,13 @@ static int intel_i915_configure(void)
 	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
 	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
+#ifndef USE_PCI_DMA_API
+	agp_bridge->scratch_page_dma = agp_bridge->scratch_page;
+#endif
+
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_private.gtt+i);
+			writel(agp_bridge->scratch_page_dma, intel_private.gtt+i);
 		}
 		readl(intel_private.gtt+i-1);	/* PCI Posting. */
 	}
@@ -1039,7 +1177,7 @@ static void intel_i915_chipset_flush(struct agp_bridge_data *bridge)
 static int intel_i915_insert_entries(struct agp_memory *mem, off_t pg_start,
 				     int type)
 {
-	int i, j, num_entries;
+	int num_entries;
 	void *temp;
 	int ret = -EINVAL;
 	int mask_type;
@@ -1063,7 +1201,7 @@ static int intel_i915_insert_entries(struct agp_memory *mem, off_t pg_start,
 	if ((pg_start + mem->page_count) > num_entries)
 		goto out_err;
 
-	/* The i915 can't check the GTT for entries since its read only,
+	/* The i915 can't check the GTT for entries since it's read only;
 	 * depend on the caller to make the correct offset decisions.
 	 */
 
@@ -1079,12 +1217,7 @@ static int intel_i915_insert_entries(struct agp_memory *mem, off_t pg_start,
 	if (!mem->is_flushed)
 		global_cache_flush();
 
-	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
-		writel(agp_bridge->driver->mask_memory(agp_bridge,
-						       mem->pages[i], mask_type), intel_private.gtt+j);
-	}
-
-	readl(intel_private.gtt+j-1);
+	intel_agp_insert_sg_entries(mem, pg_start, mask_type);
 	agp_bridge->driver->tlb_flush(mem);
 
  out:
@@ -1109,7 +1242,7 @@ static int intel_i915_remove_entries(struct agp_memory *mem, off_t pg_start,
 	}
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++)
-		writel(agp_bridge->scratch_page, intel_private.gtt+i);
+		writel(agp_bridge->scratch_page_dma, intel_private.gtt+i);
 
 	readl(intel_private.gtt+i-1);
 
@@ -1196,9 +1329,8 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
  * this conditional.
  */
 static unsigned long intel_i965_mask_memory(struct agp_bridge_data *bridge,
-					    struct page *page, int type)
+					    dma_addr_t addr, int type)
 {
-	dma_addr_t addr = phys_to_gart(page_to_phys(page));
 	/* Shift high bits down */
 	addr |= (addr >> 28) & 0xf0;
 
@@ -2003,6 +2135,12 @@ static const struct agp_bridge_driver intel_915_driver = {
 	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
+#ifdef USE_PCI_DMA_API
+	.agp_map_page		= intel_agp_map_page,
+	.agp_unmap_page		= intel_agp_unmap_page,
+	.agp_map_memory		= intel_agp_map_memory,
+	.agp_unmap_memory	= intel_agp_unmap_memory,
+#endif
 };
 
 static const struct agp_bridge_driver intel_i965_driver = {
@@ -2031,6 +2169,12 @@ static const struct agp_bridge_driver intel_i965_driver = {
 	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type	= intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
+#ifdef USE_PCI_DMA_API
+	.agp_map_page		= intel_agp_map_page,
+	.agp_unmap_page		= intel_agp_unmap_page,
+	.agp_map_memory		= intel_agp_map_memory,
+	.agp_unmap_memory	= intel_agp_unmap_memory,
+#endif
 };
 
 static const struct agp_bridge_driver intel_7505_driver = {
@@ -2085,6 +2229,12 @@ static const struct agp_bridge_driver intel_g33_driver = {
 	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type	= intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
+#ifdef USE_PCI_DMA_API
+	.agp_map_page		= intel_agp_map_page,
+	.agp_unmap_page		= intel_agp_unmap_page,
+	.agp_map_memory		= intel_agp_map_memory,
+	.agp_unmap_memory	= intel_agp_unmap_memory,
+#endif
 };
 
 static int find_gmch(u16 device)
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index 263d71d..cedacee 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -225,7 +225,7 @@ static int nvidia_insert_memory(struct agp_memory *mem, off_t pg_start, int type
 	}
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
-			mem->pages[i], mask_type),
+			       phys_to_gart(page_to_phys(mem->pages[i])), mask_type),
 			agp_bridge->gatt_table+nvidia_private.pg_offset+j);
 	}
 
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index f4bb43f..1c12921 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -32,7 +32,7 @@
 #define AGP8X_MODE		(1 << AGP8X_MODE_BIT)
 
 static unsigned long
-parisc_agp_mask_memory(struct agp_bridge_data *bridge, unsigned long addr,
+parisc_agp_mask_memory(struct agp_bridge_data *bridge, dma_addr_t addr,
 		       int type);
 
 static struct _parisc_agp_info {
@@ -189,20 +189,12 @@ parisc_agp_remove_memory(struct agp_memory *mem, off_t pg_start, int type)
 }
 
 static unsigned long
-parisc_agp_mask_memory(struct agp_bridge_data *bridge, unsigned long addr,
+parisc_agp_mask_memory(struct agp_bridge_data *bridge, dma_addr_t addr,
 		       int type)
 {
 	return SBA_PDIR_VALID_BIT | addr;
 }
 
-static unsigned long
-parisc_agp_page_mask_memory(struct agp_bridge_data *bridge, struct page *page,
-			    int type)
-{
-	unsigned long addr = phys_to_gart(page_to_phys(page));
-	return SBA_PDIR_VALID_BIT | addr;
-}
-
 static void
 parisc_agp_enable(struct agp_bridge_data *bridge, u32 mode)
 {
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index d3ea2e4..0d47fa8 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -70,10 +70,9 @@ static void sgi_tioca_tlbflush(struct agp_memory *mem)
  * entry.
  */
 static unsigned long
-sgi_tioca_mask_memory(struct agp_bridge_data *bridge,
-		      struct page *page, int type)
+sgi_tioca_mask_memory(struct agp_bridge_data *bridge, dma_addr_t addr,
+		      int type)
 {
-	unsigned long addr = phys_to_gart(page_to_phys(page));
 	return tioca_physpage_to_gart(addr);
 }
 
@@ -190,7 +189,8 @@ static int sgi_tioca_insert_memory(struct agp_memory *mem, off_t pg_start,
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		table[j] =
-		    bridge->driver->mask_memory(bridge, mem->pages[i],
+		    bridge->driver->mask_memory(bridge,
+						phys_to_gart(page_to_phys(mem->pages[i])),
 						mem->type);
 	}
 
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index b964a21..0725995 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -349,7 +349,9 @@ static int serverworks_insert_memory(struct agp_memory *mem,
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = SVRWRKS_GET_GATT(addr);
-		writel(agp_bridge->driver->mask_memory(agp_bridge, mem->pages[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
+		writel(agp_bridge->driver->mask_memory(agp_bridge, 
+				phys_to_gart(page_to_phys(mem->pages[i])), mem->type),
+		       cur_gatt+GET_GATT_OFF(addr));
 	}
 	serverworks_tlbflush(mem);
 	return 0;
diff --git a/include/linux/agp_backend.h b/include/linux/agp_backend.h
index 76fa794..8a294d6 100644
--- a/include/linux/agp_backend.h
+++ b/include/linux/agp_backend.h
@@ -79,9 +79,13 @@ struct agp_memory {
 	u32 physical;
 	bool is_bound;
 	bool is_flushed;
-        bool vmalloc_flag;
+	bool vmalloc_flag;
+	bool sg_vmalloc_flag;
 	/* list of agp_memory mapped to the aperture */
 	struct list_head mapped_list;
+	/* DMA-mapped addresses */
+	struct scatterlist *sg_list;
+	int num_sg;
 };
 
 #define AGP_NORMAL_MEMORY 0

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbXLSFkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbXLSFkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbXLSFkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:40:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:2420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbXLSFkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:40:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,182,1196668800"; 
   d="scan'208";a="448791729"
Date: Wed, 19 Dec 2007 13:30:10 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       "Gross, Mark" <mark.gross@intel.com>
Subject: [agp-mm][PATCH 3/4][AGP] intel_agp: add support for graphics dma remapping on G33
Message-ID: <20071219053010.GD24238@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
	"Gross, Mark" <mark.gross@intel.com>
References: <20071218050809.GA12564@zhen-devel.sh.intel.com> <20071219052030.GA24238@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219052030.GA24238@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.23 i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[agp-mm] [AGP] intel_agp: add support for graphics dma remapping on G33

When graphics dma remapping engine is active, we must fill
gart table with dma address from dmar engine, as now graphics
device access to graphics memory must go through dma remapping
table to get real physical address.

Add support on G33 chipset, which has graphics device specific
dmar engine avaiable.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/Kconfig     |   12 +++-
 drivers/char/agp/intel-agp.c |  134 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 141 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index ccb1fa8..e60c2b0 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -74,8 +74,16 @@ config AGP_INTEL
 	  on Intel 440LX/BX/GX, 815, 820, 830, 840, 845, 850, 860, 875,
 	  E7205 and E7505 chipsets and full support for the 810, 815, 830M,
 	  845G, 852GM, 855GM, 865G and I915 integrated graphics chipsets.
-
-
+	
+config AGP_INTEL_DMAR
+	bool
+	depends on AGP_INTEL && DMAR && !DMAR_GFX_WA
+	default y
+	help
+	  This option will enable graphics address remapping with Intel
+	  DMAR engine aka VT-d if you don't select graphics workaround on
+	  Intel DMAR. The graphics address filled to gart table will be
+	  changed by remapping within graphics DMAR engine for domain.
 
 config AGP_NVIDIA
 	tristate "NVIDIA nForce/nForce2 chipset support"
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index f443682..31a939d 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -9,6 +9,9 @@
 #include <linux/pagemap.h>
 #include <linux/agp_backend.h>
 #include "agp.h"
+#ifdef CONFIG_AGP_INTEL_DMAR
+#include <linux/dmar.h>
+#endif
 
 #define PCI_DEVICE_ID_INTEL_82946GZ_HB      0x2970
 #define PCI_DEVICE_ID_INTEL_82946GZ_IG      0x2972
@@ -123,6 +126,97 @@ static struct _intel_private {
 	struct resource ifp_resource;
 } intel_private;
 
+static int intel_agp_require_remapping(void)
+{
+#ifdef CONFIG_AGP_INTEL_DMAR
+	return intel_iommu_gfx_remapping();
+#else
+	return 0;
+#endif
+}
+
+#ifdef CONFIG_AGP_INTEL_DMAR
+static int intel_agp_map_pages(struct agp_memory *mem, void *virt, dma_addr_t *ret, int is_single)
+{
+	int i;
+	struct scatterlist *sg;
+
+	if (is_single) {
+		*ret = pci_map_single(intel_private.pcidev, virt, PAGE_SIZE,
+				PCI_DMA_BIDIRECTIONAL);
+		if (pci_dma_mapping_error(*ret))
+			return -EINVAL;
+		return 0;
+	}
+
+	DBG("try mapping %lu pages\n", (unsigned long)mem->page_count);
+
+	if ((mem->page_count * sizeof(*mem->sg_list)) < 2*PAGE_SIZE)
+	    mem->sg_list = kcalloc(mem->page_count, sizeof(*mem->sg_list), GFP_KERNEL);
+
+	if (mem->sg_list == NULL) {
+	    mem->sg_list = vmalloc(mem->page_count * sizeof(*mem->sg_list));
+	    mem->sg_vmalloc_flag = 1;
+	}
+
+	if (!mem->sg_list) {
+	    mem->sg_vmalloc_flag = 0;
+	    return -ENOMEM;
+	}
+	sg_init_table(mem->sg_list, mem->page_count);
+
+	sg = mem->sg_list;
+	for (i = 0 ; i < mem->page_count; i++, sg = sg_next(sg))
+		sg_set_buf(sg, gart_to_virt(mem->memory[i]), PAGE_SIZE);
+
+	mem->num_sg = pci_map_sg(intel_private.pcidev, mem->sg_list,
+					mem->page_count, PCI_DMA_BIDIRECTIONAL);
+	if (mem->num_sg == 0) {
+		if (mem->sg_vmalloc_flag)
+			vfree(mem->sg_list);
+		else
+			kfree(mem->sg_list);
+		mem->sg_list = NULL;
+		mem->sg_vmalloc_flag = 0;
+		return -ENOMEM;
+	}
+	mem->is_mapped = TRUE;
+	return 0;
+}
+
+static void intel_agp_unmap_pages(struct agp_memory *mem, dma_addr_t addr, int is_single)
+{
+	if (is_single) {
+		pci_unmap_single(intel_private.pcidev, addr, PAGE_SIZE,
+				PCI_DMA_BIDIRECTIONAL);
+		return;
+	}
+	DBG("try unmapping %lu pages\n", (unsigned long)mem->page_count);
+
+	if (!mem->is_mapped)
+		return;
+
+	if (mem->num_sg)
+		pci_unmap_sg(intel_private.pcidev, mem->sg_list, mem->page_count,
+				PCI_DMA_BIDIRECTIONAL);
+	if (mem->sg_vmalloc_flag)
+		vfree(mem->sg_list);
+	else
+		kfree(mem->sg_list);
+	mem->sg_vmalloc_flag = 0;
+	mem->sg_list = NULL;
+	mem->num_sg = 0;
+}
+#else
+static int intel_agp_map_pages(struct agp_memory *mem, void *virt, dma_addr_t *ret, int is_single)
+{
+    return 0;
+}
+static void intel_agp_unmap_pages(struct agp_memory *mem, dma_addr_t addr, int is_single)
+{
+}
+#endif
+
 static int intel_i810_fetch_size(void)
 {
 	u32 smram_miscc;
@@ -991,9 +1085,40 @@ static int intel_i915_insert_entries(struct agp_memory *mem,off_t pg_start,
 	if (!mem->is_flushed)
 		global_cache_flush();
 
-	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
-		writel(agp_bridge->driver->mask_memory(agp_bridge,
-			mem->memory[i], mask_type), intel_private.gtt+j);
+	/* map mem if current graphics dmar engine is active
+	 * and workaround is not applied. */
+	if (mem->is_mapped) {
+		struct scatterlist *sg;
+
+		j = pg_start;
+		if (mem->num_sg == mem->page_count) {
+			for_each_sg(mem->sg_list, sg, mem->page_count, i) {
+				writel(agp_bridge->driver->mask_memory(agp_bridge,
+							sg_dma_address(sg),
+							mask_type),
+						intel_private.gtt+j);
+				j++;
+			}
+		} else {
+			/* sg may merge pages, but we have to seperate
+			 * per-page addr for GTT */
+			unsigned int len, m;
+			for_each_sg(mem->sg_list, sg, mem->num_sg, i) {
+				len = sg_dma_len(sg) / PAGE_SIZE;
+				for (m = 0; m < len; m++) {
+					writel(agp_bridge->driver->mask_memory(agp_bridge,
+								sg_dma_address(sg) + m * PAGE_SIZE, mask_type),
+							intel_private.gtt+j);
+					j++;
+				}
+			}
+		}
+	} else {
+		for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
+			writel(agp_bridge->driver->mask_memory(agp_bridge,
+						mem->memory[i], mask_type),
+					intel_private.gtt+j);
+		}
 	}
 
 	readl(intel_private.gtt+j-1);
@@ -1947,6 +2072,9 @@ static const struct agp_bridge_driver intel_g33_driver = {
 	.agp_destroy_page       = agp_generic_destroy_page,
 	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
+	.agp_require_remapping  = intel_agp_require_remapping,
+	.agp_map_page		= intel_agp_map_pages,
+	.agp_unmap_page		= intel_agp_unmap_pages,
 };
 
 static int find_gmch(u16 device)
-- 
1.5.3.4


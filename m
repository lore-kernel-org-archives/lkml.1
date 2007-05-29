Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbXE2GU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbXE2GU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXE2GUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:20:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:63010 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbXE2GUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:20:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,587,1170662400"; 
   d="scan'208";a="250607309"
Date: Tue, 29 May 2007 14:20:05 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>
Subject: [PATCH 1/2] [AGPGART] intel_agp: cleanup intel private data
Message-ID: <20070529062005.GA5097@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[AGPGART] intel_agp: cleanup intel private data

A single private gart data is used by all drivers, this
makes it clean. Eric Anholt wrote the original patch.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |  193 ++++++++++++++++++++----------------------
 1 files changed, 90 insertions(+), 103 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 9c69f2e..151d444 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -86,11 +86,18 @@ static struct gatt_mask intel_i810_masks[] =
 	 .type = INTEL_AGP_CACHED_MEMORY}
 };
 
-static struct _intel_i810_private {
-	struct pci_dev *i810_dev;	/* device one */
+static struct _intel_private {
+	struct pci_dev *pcidev;	/* device one */
 	volatile u8 __iomem *registers;
+	volatile u32 __iomem *gtt;		/* I915G */
 	int num_dcache_entries;
-} intel_i810_private;
+	/* gtt_entries is the number of gtt entries that are already mapped
+	 * to stolen memory.  Stolen memory is larger than the memory mapped
+	 * through gtt_entries, as it includes some reserved space for the BIOS
+	 * popup and for the GTT.
+	 */
+	int gtt_entries;			/* i830+ */
+} intel_private;
 
 static int intel_i810_fetch_size(void)
 {
@@ -127,32 +134,32 @@ static int intel_i810_configure(void)
 
 	current_size = A_SIZE_FIX(agp_bridge->current_size);
 
-	if (!intel_i810_private.registers) {
-		pci_read_config_dword(intel_i810_private.i810_dev, I810_MMADDR, &temp);
+	if (!intel_private.registers) {
+		pci_read_config_dword(intel_private.pcidev, I810_MMADDR, &temp);
 		temp &= 0xfff80000;
 
-		intel_i810_private.registers = ioremap(temp, 128 * 4096);
-		if (!intel_i810_private.registers) {
+		intel_private.registers = ioremap(temp, 128 * 4096);
+		if (!intel_private.registers) {
 			printk(KERN_ERR PFX "Unable to remap memory.\n");
 			return -ENOMEM;
 		}
 	}
 
-	if ((readl(intel_i810_private.registers+I810_DRAM_CTL)
+	if ((readl(intel_private.registers+I810_DRAM_CTL)
 		& I810_DRAM_ROW_0) == I810_DRAM_ROW_0_SDRAM) {
 		/* This will need to be dynamically assigned */
 		printk(KERN_INFO PFX "detected 4MB dedicated video ram.\n");
-		intel_i810_private.num_dcache_entries = 1024;
+		intel_private.num_dcache_entries = 1024;
 	}
-	pci_read_config_dword(intel_i810_private.i810_dev, I810_GMADDR, &temp);
+	pci_read_config_dword(intel_private.pcidev, I810_GMADDR, &temp);
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
-	writel(agp_bridge->gatt_bus_addr | I810_PGETBL_ENABLED, intel_i810_private.registers+I810_PGETBL_CTL);
-	readl(intel_i810_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
+	writel(agp_bridge->gatt_bus_addr | I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
+	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = 0; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_i810_private.registers+I810_PTE_BASE+(i*4));
-			readl(intel_i810_private.registers+I810_PTE_BASE+(i*4));	/* PCI posting. */
+			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
+			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI posting. */
 		}
 	}
 	global_cache_flush();
@@ -161,9 +168,9 @@ static int intel_i810_configure(void)
 
 static void intel_i810_cleanup(void)
 {
-	writel(0, intel_i810_private.registers+I810_PGETBL_CTL);
-	readl(intel_i810_private.registers);	/* PCI Posting. */
-	iounmap(intel_i810_private.registers);
+	writel(0, intel_private.registers+I810_PGETBL_CTL);
+	readl(intel_private.registers);	/* PCI Posting. */
+	iounmap(intel_private.registers);
 }
 
 static void intel_i810_tlbflush(struct agp_memory *mem)
@@ -261,9 +268,9 @@ static int intel_i810_insert_entries(struct agp_memory *mem, off_t pg_start,
 			global_cache_flush();
 		for (i = pg_start; i < (pg_start + mem->page_count); i++) {
 			writel((i*4096)|I810_PTE_LOCAL|I810_PTE_VALID,
-			       intel_i810_private.registers+I810_PTE_BASE+(i*4));
+			       intel_private.registers+I810_PTE_BASE+(i*4));
 		}
-		readl(intel_i810_private.registers+I810_PTE_BASE+((i-1)*4));
+		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));
 		break;
 	case AGP_PHYS_MEMORY:
 	case AGP_NORMAL_MEMORY:
@@ -273,9 +280,9 @@ static int intel_i810_insert_entries(struct agp_memory *mem, off_t pg_start,
 			writel(agp_bridge->driver->mask_memory(agp_bridge,
 							       mem->memory[i],
 							       mask_type),
-			       intel_i810_private.registers+I810_PTE_BASE+(j*4));
+			       intel_private.registers+I810_PTE_BASE+(j*4));
 		}
-		readl(intel_i810_private.registers+I810_PTE_BASE+((j-1)*4));
+		readl(intel_private.registers+I810_PTE_BASE+((j-1)*4));
 		break;
 	default:
 		goto out_err;
@@ -298,9 +305,9 @@ static int intel_i810_remove_entries(struct agp_memory *mem, off_t pg_start,
 		return 0;
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-		writel(agp_bridge->scratch_page, intel_i810_private.registers+I810_PTE_BASE+(i*4));
+		writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
 	}
-	readl(intel_i810_private.registers+I810_PTE_BASE+((i-1)*4));
+	readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));
 
 	agp_bridge->driver->tlb_flush(mem);
 	return 0;
@@ -354,7 +361,7 @@ static struct agp_memory *intel_i810_alloc_by_type(size_t pg_count, int type)
 	struct agp_memory *new;
 
 	if (type == AGP_DCACHE_MEMORY) {
-		if (pg_count != intel_i810_private.num_dcache_entries)
+		if (pg_count != intel_private.num_dcache_entries)
 			return NULL;
 
 		new = agp_create_memory(1);
@@ -404,18 +411,6 @@ static struct aper_size_info_fixed intel_i830_sizes[] =
 	{512, 131072, 7},
 };
 
-static struct _intel_i830_private {
-	struct pci_dev *i830_dev;		/* device one */
-	volatile u8 __iomem *registers;
-	volatile u32 __iomem *gtt;		/* I915G */
-	/* gtt_entries is the number of gtt entries that are already mapped
-	 * to stolen memory.  Stolen memory is larger than the memory mapped
-	 * through gtt_entries, as it includes some reserved space for the BIOS
-	 * popup and for the GTT.
-	 */
-	int gtt_entries;
-} intel_i830_private;
-
 static void intel_i830_init_gtt_entries(void)
 {
 	u16 gmch_ctrl;
@@ -429,7 +424,7 @@ static void intel_i830_init_gtt_entries(void)
 
 	if (IS_I965) {
 		u32 pgetbl_ctl;
-		pgetbl_ctl = readl(intel_i830_private.registers+I810_PGETBL_CTL);
+		pgetbl_ctl = readl(intel_private.registers+I810_PGETBL_CTL);
 
 		/* The 965 has a field telling us the size of the GTT,
 		 * which may be larger than what is necessary to map the
@@ -471,7 +466,7 @@ static void intel_i830_init_gtt_entries(void)
 			gtt_entries = MB(8) - KB(size);
 			break;
 		case I830_GMCH_GMS_LOCAL:
-			rdct = readb(intel_i830_private.registers+I830_RDRAM_CHANNEL_TYPE);
+			rdct = readb(intel_private.registers+I830_RDRAM_CHANNEL_TYPE);
 			gtt_entries = (I830_RDRAM_ND(rdct) + 1) *
 					MB(ddt[I830_RDRAM_DDT(rdct)]);
 			local = 1;
@@ -529,7 +524,7 @@ static void intel_i830_init_gtt_entries(void)
 		       "No pre-allocated video memory detected.\n");
 	gtt_entries /= KB(4);
 
-	intel_i830_private.gtt_entries = gtt_entries;
+	intel_private.gtt_entries = gtt_entries;
 }
 
 /* The intel i830 automatically initializes the agp aperture during POST.
@@ -547,14 +542,14 @@ static int intel_i830_create_gatt_table(struct agp_bridge_data *bridge)
 	num_entries = size->num_entries;
 	agp_bridge->gatt_table_real = NULL;
 
-	pci_read_config_dword(intel_i830_private.i830_dev,I810_MMADDR,&temp);
+	pci_read_config_dword(intel_private.pcidev,I810_MMADDR,&temp);
 	temp &= 0xfff80000;
 
-	intel_i830_private.registers = ioremap(temp,128 * 4096);
-	if (!intel_i830_private.registers)
+	intel_private.registers = ioremap(temp,128 * 4096);
+	if (!intel_private.registers)
 		return -ENOMEM;
 
-	temp = readl(intel_i830_private.registers+I810_PGETBL_CTL) & 0xfffff000;
+	temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
 	global_cache_flush();	/* FIXME: ?? */
 
 	/* we have to call this as early as possible after the MMIO base address is known */
@@ -614,20 +609,20 @@ static int intel_i830_configure(void)
 
 	current_size = A_SIZE_FIX(agp_bridge->current_size);
 
-	pci_read_config_dword(intel_i830_private.i830_dev,I810_GMADDR,&temp);
+	pci_read_config_dword(intel_private.pcidev,I810_GMADDR,&temp);
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 
 	pci_read_config_word(agp_bridge->dev,I830_GMCH_CTRL,&gmch_ctrl);
 	gmch_ctrl |= I830_GMCH_ENABLED;
 	pci_write_config_word(agp_bridge->dev,I830_GMCH_CTRL,gmch_ctrl);
 
-	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_i830_private.registers+I810_PGETBL_CTL);
-	readl(intel_i830_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
+	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
+	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
 	if (agp_bridge->driver->needs_scratch_page) {
-		for (i = intel_i830_private.gtt_entries; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_i830_private.registers+I810_PTE_BASE+(i*4));
-			readl(intel_i830_private.registers+I810_PTE_BASE+(i*4));	/* PCI Posting. */
+		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
+			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
+			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI Posting. */
 		}
 	}
 
@@ -637,7 +632,7 @@ static int intel_i830_configure(void)
 
 static void intel_i830_cleanup(void)
 {
-	iounmap(intel_i830_private.registers);
+	iounmap(intel_private.registers);
 }
 
 static int intel_i830_insert_entries(struct agp_memory *mem,off_t pg_start, int type)
@@ -653,9 +648,9 @@ static int intel_i830_insert_entries(struct agp_memory *mem,off_t pg_start, int
 	temp = agp_bridge->current_size;
 	num_entries = A_SIZE_FIX(temp)->num_entries;
 
-	if (pg_start < intel_i830_private.gtt_entries) {
-		printk (KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_i830_private.gtt_entries == 0x%.8x\n",
-				pg_start,intel_i830_private.gtt_entries);
+	if (pg_start < intel_private.gtt_entries) {
+		printk (KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_private.gtt_entries == 0x%.8x\n",
+				pg_start,intel_private.gtt_entries);
 
 		printk (KERN_INFO PFX "Trying to insert into local/stolen memory\n");
 		goto out_err;
@@ -683,9 +678,9 @@ static int intel_i830_insert_entries(struct agp_memory *mem,off_t pg_start, int
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
 						       mem->memory[i], mask_type),
-		       intel_i830_private.registers+I810_PTE_BASE+(j*4));
+		       intel_private.registers+I810_PTE_BASE+(j*4));
 	}
-	readl(intel_i830_private.registers+I810_PTE_BASE+((j-1)*4));
+	readl(intel_private.registers+I810_PTE_BASE+((j-1)*4));
 	agp_bridge->driver->tlb_flush(mem);
 
 out:
@@ -703,15 +698,15 @@ static int intel_i830_remove_entries(struct agp_memory *mem,off_t pg_start,
 	if (mem->page_count == 0)
 		return 0;
 
-	if (pg_start < intel_i830_private.gtt_entries) {
+	if (pg_start < intel_private.gtt_entries) {
 		printk (KERN_INFO PFX "Trying to disable local/stolen memory\n");
 		return -EINVAL;
 	}
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-		writel(agp_bridge->scratch_page, intel_i830_private.registers+I810_PTE_BASE+(i*4));
+		writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
 	}
-	readl(intel_i830_private.registers+I810_PTE_BASE+((i-1)*4));
+	readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));
 
 	agp_bridge->driver->tlb_flush(mem);
 	return 0;
@@ -734,7 +729,7 @@ static int intel_i915_configure(void)
 
 	current_size = A_SIZE_FIX(agp_bridge->current_size);
 
-	pci_read_config_dword(intel_i830_private.i830_dev, I915_GMADDR, &temp);
+	pci_read_config_dword(intel_private.pcidev, I915_GMADDR, &temp);
 
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 
@@ -742,13 +737,13 @@ static int intel_i915_configure(void)
 	gmch_ctrl |= I830_GMCH_ENABLED;
 	pci_write_config_word(agp_bridge->dev,I830_GMCH_CTRL,gmch_ctrl);
 
-	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_i830_private.registers+I810_PGETBL_CTL);
-	readl(intel_i830_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
+	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
+	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
 	if (agp_bridge->driver->needs_scratch_page) {
-		for (i = intel_i830_private.gtt_entries; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_i830_private.gtt+i);
-			readl(intel_i830_private.gtt+i);	/* PCI Posting. */
+		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
+			writel(agp_bridge->scratch_page, intel_private.gtt+i);
+			readl(intel_private.gtt+i);	/* PCI Posting. */
 		}
 	}
 
@@ -758,8 +753,8 @@ static int intel_i915_configure(void)
 
 static void intel_i915_cleanup(void)
 {
-	iounmap(intel_i830_private.gtt);
-	iounmap(intel_i830_private.registers);
+	iounmap(intel_private.gtt);
+	iounmap(intel_private.registers);
 }
 
 static int intel_i915_insert_entries(struct agp_memory *mem,off_t pg_start,
@@ -776,9 +771,9 @@ static int intel_i915_insert_entries(struct agp_memory *mem,off_t pg_start,
 	temp = agp_bridge->current_size;
 	num_entries = A_SIZE_FIX(temp)->num_entries;
 
-	if (pg_start < intel_i830_private.gtt_entries) {
-		printk (KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_i830_private.gtt_entries == 0x%.8x\n",
-				pg_start,intel_i830_private.gtt_entries);
+	if (pg_start < intel_private.gtt_entries) {
+		printk (KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_private.gtt_entries == 0x%.8x\n",
+				pg_start,intel_private.gtt_entries);
 
 		printk (KERN_INFO PFX "Trying to insert into local/stolen memory\n");
 		goto out_err;
@@ -805,10 +800,10 @@ static int intel_i915_insert_entries(struct agp_memory *mem,off_t pg_start,
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
-			mem->memory[i], mask_type), intel_i830_private.gtt+j);
+			mem->memory[i], mask_type), intel_private.gtt+j);
 	}
 
-	readl(intel_i830_private.gtt+j-1);
+	readl(intel_private.gtt+j-1);
 	agp_bridge->driver->tlb_flush(mem);
 
  out:
@@ -826,15 +821,15 @@ static int intel_i915_remove_entries(struct agp_memory *mem,off_t pg_start,
 	if (mem->page_count == 0)
 		return 0;
 
-	if (pg_start < intel_i830_private.gtt_entries) {
+	if (pg_start < intel_private.gtt_entries) {
 		printk (KERN_INFO PFX "Trying to disable local/stolen memory\n");
 		return -EINVAL;
 	}
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-		writel(agp_bridge->scratch_page, intel_i830_private.gtt+i);
+		writel(agp_bridge->scratch_page, intel_private.gtt+i);
 	}
-	readl(intel_i830_private.gtt+i-1);
+	readl(intel_private.gtt+i-1);
 
 	agp_bridge->driver->tlb_flush(mem);
 	return 0;
@@ -850,7 +845,7 @@ static int intel_i9xx_fetch_size(void)
 	int aper_size; /* size in megabytes */
 	int i;
 
-	aper_size = pci_resource_len(intel_i830_private.i830_dev, 2) / MB(1);
+	aper_size = pci_resource_len(intel_private.pcidev, 2) / MB(1);
 
 	for (i = 0; i < num_sizes; i++) {
 		if (aper_size == intel_i830_sizes[i].size) {
@@ -878,20 +873,20 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
 	num_entries = size->num_entries;
 	agp_bridge->gatt_table_real = NULL;
 
-	pci_read_config_dword(intel_i830_private.i830_dev, I915_MMADDR, &temp);
-	pci_read_config_dword(intel_i830_private.i830_dev, I915_PTEADDR,&temp2);
+	pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
+	pci_read_config_dword(intel_private.pcidev, I915_PTEADDR,&temp2);
 
-	intel_i830_private.gtt = ioremap(temp2, 256 * 1024);
-	if (!intel_i830_private.gtt)
+	intel_private.gtt = ioremap(temp2, 256 * 1024);
+	if (!intel_private.gtt)
 		return -ENOMEM;
 
 	temp &= 0xfff80000;
 
-	intel_i830_private.registers = ioremap(temp,128 * 4096);
-	if (!intel_i830_private.registers)
+	intel_private.registers = ioremap(temp,128 * 4096);
+	if (!intel_private.registers)
 		return -ENOMEM;
 
-	temp = readl(intel_i830_private.registers+I810_PGETBL_CTL) & 0xfffff000;
+	temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
 	global_cache_flush();	/* FIXME: ? */
 
 	/* we have to call this as early as possible after the MMIO base address is known */
@@ -938,20 +933,20 @@ static int intel_i965_create_gatt_table(struct agp_bridge_data *bridge)
        num_entries = size->num_entries;
        agp_bridge->gatt_table_real = NULL;
 
-       pci_read_config_dword(intel_i830_private.i830_dev, I915_MMADDR, &temp);
+       pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
 
        temp &= 0xfff00000;
-       intel_i830_private.gtt = ioremap((temp + (512 * 1024)) , 512 * 1024);
+       intel_private.gtt = ioremap((temp + (512 * 1024)) , 512 * 1024);
 
-       if (!intel_i830_private.gtt)
+       if (!intel_private.gtt)
                return -ENOMEM;
 
 
-       intel_i830_private.registers = ioremap(temp,128 * 4096);
-       if (!intel_i830_private.registers)
+       intel_private.registers = ioremap(temp,128 * 4096);
+       if (!intel_private.registers)
                return -ENOMEM;
 
-       temp = readl(intel_i830_private.registers+I810_PGETBL_CTL) & 0xfffff000;
+       temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
        global_cache_flush();   /* FIXME: ? */
 
        /* we have to call this as early as possible after the MMIO base address is known */
@@ -1729,7 +1724,7 @@ static int find_i810(u16 device)
 	i810_dev = pci_get_device(PCI_VENDOR_ID_INTEL, device, NULL);
 	if (!i810_dev)
 		return 0;
-	intel_i810_private.i810_dev = i810_dev;
+	intel_private.pcidev = i810_dev;
 	return 1;
 }
 
@@ -1746,7 +1741,7 @@ static int find_i830(u16 device)
 	if (!i830_dev)
 		return 0;
 
-	intel_i830_private.i830_dev = i830_dev;
+	intel_private.pcidev = i830_dev;
 	return 1;
 }
 
@@ -1946,11 +1941,7 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 
 	bridge->dev = pdev;
 	bridge->capndx = cap_ptr;
-
-	if (bridge->driver == &intel_810_driver)
-		bridge->dev_private_data = &intel_i810_private;
-	else if (bridge->driver == &intel_830_driver)
-		bridge->dev_private_data = &intel_i830_private;
+	bridge->dev_private_data = &intel_private;
 
 	printk(KERN_INFO PFX "Detected an Intel %s Chipset.\n", name);
 
@@ -2002,10 +1993,8 @@ static void __devexit agp_intel_remove(struct pci_dev *pdev)
 
 	agp_remove_bridge(bridge);
 
-	if (intel_i810_private.i810_dev)
-		pci_dev_put(intel_i810_private.i810_dev);
-	if (intel_i830_private.i830_dev)
-		pci_dev_put(intel_i830_private.i830_dev);
+	if (intel_private.pcidev)
+		pci_dev_put(intel_private.pcidev);
 
 	agp_put_bridge(bridge);
 }
@@ -2021,10 +2010,8 @@ static int agp_intel_resume(struct pci_dev *pdev)
 	 * as host bridge (00:00) resumes before graphics device (02:00),
 	 * then our access to its pci space can work right.
 	 */
-	if (intel_i810_private.i810_dev)
-		pci_restore_state(intel_i810_private.i810_dev);
-	if (intel_i830_private.i830_dev)
-		pci_restore_state(intel_i830_private.i830_dev);
+	if (intel_private.pcidev)
+		pci_restore_state(intel_private.pcidev);
 
 	if (bridge->driver == &intel_generic_driver)
 		intel_configure();
-- 
1.4.4.4

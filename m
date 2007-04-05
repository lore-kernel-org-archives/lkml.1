Return-Path: <linux-kernel-owner+w=401wt.eu-S1767109AbXDEPkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767109AbXDEPkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767104AbXDEPkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:40:53 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:61012 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767109AbXDEPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:40:51 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 11:39:59 -0400
From: Tony Lindgren <tony@atomide.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Imre Deak <imre.deak@solidboot.com>
Subject: Re: [PATCH 68/90] ARM: OMAP: FB sync with N800 tree (support for dynamic SRAM allocations)
Message-ID: <20070405153956.GP24297@atomide.com>
References: <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <11757101533672-git-send-email-tony@atomide.com> <20070404135254.9233a2db.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mZBmBd1ZkdwT1ny"
Content-Disposition: inline
In-Reply-To: <20070404135254.9233a2db.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--5mZBmBd1ZkdwT1ny
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Randy Dunlap <randy.dunlap@oracle.com> [070404 16:52]:
> On Wed,  4 Apr 2007 14:05:47 -0400 Tony Lindgren wrote:
> 
> Referring to multiple places in this patch, please use the preferred
> kernel "long comment" style as documented in
> Documentation/CodingStyle, Ch. 8, Commenting:
> 
> The preferred style for long (multi-line) comments is:
> 
> 	/*
> 	 * This is the preferred style for multi-line
> 	 * comments in the Linux kernel source code.
> 	 * Please use it consistently.
> 	 *
> 	 * Description:  A column of asterisks on the left side,
> 	 * with beginning and ending almost-blank lines.
> 	 */

Following is an updated patch.

Tony

--5mZBmBd1ZkdwT1ny
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0068-ARM-OMAP-FB-sync-with-N800-tree-support-for-dynamic-SRAM-allocations.txt"

>From 0d3fe2ccf1090670ee52f39b28d3f615dcd0f891 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@solidboot.com>
Date: Tue, 6 Mar 2007 03:16:36 -0800
Subject: [PATCH 68/90] ARM: OMAP: FB sync with N800 tree (support for dynamic SRAM allocations)

- in addition to fixed FB regions - as passed by the bootloader -
  allow dynamic allocations
- do some more checking against overlapping / reserved regions
- move the FB specific parts out from sram.c to fb.c

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/io.c         |    4 +-
 arch/arm/mach-omap2/io.c         |    3 +-
 arch/arm/plat-omap/fb.c          |  271 +++++++++++++++++++++++++++++++++----
 arch/arm/plat-omap/sram.c        |   60 ++-------
 include/asm-arm/arch-omap/sram.h |    3 -
 5 files changed, 256 insertions(+), 85 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/io.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/io.c	2007-04-05 11:26:20.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/io.c	2007-04-05 11:32:44.000000000 -0400
@@ -17,11 +17,11 @@
 #include <asm/io.h>
 #include <asm/arch/mux.h>
 #include <asm/arch/tc.h>
-#include <asm/arch/omapfb.h>
 
 extern int omap1_clk_init(void);
 extern void omap_check_revision(void);
 extern void omap_sram_init(void);
+extern void omapfb_reserve_sdram(void);
 
 /*
  * The machine specific code may provide the extra mapping besides the
@@ -121,7 +121,7 @@ void __init omap1_map_common_io(void)
 #endif
 
 	omap_sram_init();
-	omapfb_reserve_mem();
+	omapfb_reserve_sdram();
 }
 
 /*
Index: linux-2.6/arch/arm/mach-omap2/io.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/io.c	2007-04-05 11:32:44.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/io.c	2007-04-05 11:32:44.000000000 -0400
@@ -29,6 +29,7 @@ extern int omap2_clk_init(void);
 extern void omap2_check_revision(void);
 extern void omap2_init_memory(void);
 extern void gpmc_init(void);
+extern void omapfb_reserve_sdram(void);
 
 /*
  * The machine specific code may provide the extra mapping besides the
@@ -94,7 +95,7 @@ void __init omap2_map_common_io(void)
 
 	omap2_check_revision();
 	omap_sram_init();
-	omapfb_reserve_mem();
+	omapfb_reserve_sdram();
 }
 
 void __init omap2_init_common_hw(void)
Index: linux-2.6/arch/arm/plat-omap/fb.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/fb.c	2007-04-05 11:32:44.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/fb.c	2007-04-05 11:38:16.000000000 -0400
@@ -39,6 +39,8 @@
 #if defined(CONFIG_FB_OMAP) || defined(CONFIG_FB_OMAP_MODULE)
 
 static struct omapfb_platform_data omapfb_config;
+static int config_invalid;
+static int configured_regions;
 
 static u64 omap_fb_dma_mask = ~(u32)0;
 
@@ -53,46 +55,246 @@ static struct platform_device omap_fb_de
 	.num_resources = 0,
 };
 
-/* called from map_io */
-void omapfb_reserve_mem(void)
+static inline int ranges_overlap(unsigned long start1, unsigned long size1,
+				 unsigned long start2, unsigned long size2)
 {
-	const struct omap_fbmem_config *fbmem_conf;
-	unsigned long total_size;
+	return (start1 >= start2 && start1 < start2 + size2) ||
+	       (start2 >= start1 && start2 < start1 + size1);
+}
+
+static inline int range_included(unsigned long start1, unsigned long size1,
+				 unsigned long start2, unsigned long size2)
+{
+	return start1 >= start2 && start1 + size1 <= start2 + size2;
+}
+
+
+/* Check if there is an overlapping region. */
+static int fbmem_region_reserved(unsigned long start, size_t size)
+{
+	struct omapfb_mem_region *rg;
 	int i;
 
-	if (!omap_fb_sram_valid) {
-		/* FBMEM SRAM configuration was already found to be invalid.
-		 * Ignore the whole configuration block. */
-		omapfb_config.mem_desc.region_cnt = 0;
-		return;
+	rg = &omapfb_config.mem_desc.region[0];
+	for (i = 0; i < OMAPFB_PLANE_NUM; i++, rg++) {
+		if (!rg->paddr)
+			/* Empty slot. */
+			continue;
+		if (ranges_overlap(start, size, rg->paddr, rg->size))
+			return 1;
 	}
+	return 0;
+}
 
-	i = 0;
-	total_size = 0;
-	while ((fbmem_conf = omap_get_nr_config(OMAP_TAG_FBMEM,
-				struct omap_fbmem_config, i)) != NULL) {
-		unsigned long start;
-		unsigned long size;
+/*
+ * Get the region_idx`th region from board config/ATAG and convert it to
+ * our internal format.
+ */
+static int get_fbmem_region(int region_idx, struct omapfb_mem_region *rg)
+{
+	const struct omap_fbmem_config	*conf;
+	u32				paddr;
 
-		if (i == OMAPFB_PLANE_NUM) {
-			printk(KERN_ERR "ignoring extra plane info\n");
+	conf = omap_get_nr_config(OMAP_TAG_FBMEM,
+				  struct omap_fbmem_config, region_idx);
+	if (conf == NULL)
+		return -ENOENT;
+
+	paddr = conf->start;
+	/*
+	 * Low bits encode the page allocation mode, if high bits
+	 * are zero. Otherwise we need a page aligned fixed
+	 * address.
+	 */
+	memset(rg, 0, sizeof(*rg));
+	rg->type = paddr & ~PAGE_MASK;
+	rg->paddr = paddr & PAGE_MASK;
+	rg->size = PAGE_ALIGN(conf->size);
+	return 0;
+}
+
+static int set_fbmem_region_type(struct omapfb_mem_region *rg, int mem_type,
+				  unsigned long mem_start,
+				  unsigned long mem_size)
+{
+	/*
+	 * Check if the configuration specifies the type explicitly.
+	 * type = 0 && paddr = 0, a default don't care case maps to
+	 * the SDRAM type.
+	 */
+	if (rg->type || (!rg->type && !rg->paddr))
+		return 0;
+	if (ranges_overlap(rg->paddr, rg->size, mem_start, mem_size)) {
+		rg->type = mem_type;
+		return 0;
+	}
+	/* Can't determine it. */
+	return -1;
+}
+
+static int check_fbmem_region(int region_idx, struct omapfb_mem_region *rg,
+			      unsigned long start_avail, unsigned size_avail)
+{
+	unsigned long	paddr = rg->paddr;
+	size_t		size = rg->size;
+
+	if (rg->type > OMAPFB_MEMTYPE_MAX) {
+		printk(KERN_ERR
+			"Invalid start address for FB region %d\n", region_idx);
+		return -EINVAL;
+	}
+
+	if (!rg->size) {
+		printk(KERN_ERR "Zero size for FB region %d\n", region_idx);
+		return -EINVAL;
+	}
+
+	if (!paddr)
+		/* Allocate this dynamically, leave paddr 0 for now. */
+		return 0;
+
+	/*
+	 * Fixed region for the given RAM range. Check if it's already
+	 * reserved by the FB code or someone else.
+	 */
+	if (fbmem_region_reserved(paddr, size) ||
+	    !range_included(paddr, size, start_avail, size_avail)) {
+		printk(KERN_ERR "Trying to use reserved memory "
+			"for FB region %d\n", region_idx);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Called from map_io. We need to call to this early enough so that we
+ * can reserve the fixed SDRAM regions before VM could get hold of them.
+ */
+void omapfb_reserve_sdram(void)
+{
+	struct bootmem_data	*bdata;
+	unsigned long		sdram_start, sdram_size;
+	unsigned long		reserved;
+	int			i;
+
+	if (config_invalid)
+		return;
+
+	bdata = NODE_DATA(0)->bdata;
+	sdram_start = bdata->node_boot_start;
+	sdram_size = (bdata->node_low_pfn << PAGE_SHIFT) - sdram_start;
+	reserved = 0;
+	for (i = 0; ; i++) {
+		struct omapfb_mem_region	rg;
+
+		if (get_fbmem_region(i, &rg) < 0)
 			break;
+		if (i == OMAPFB_PLANE_NUM) {
+			printk(KERN_ERR
+				"Extraneous FB mem configuration entries\n");
+			config_invalid = 1;
+			return;
 		}
-		start = fbmem_conf->start;
-		size  = fbmem_conf->size;
-		omapfb_config.mem_desc.region[i].paddr = start;
-		omapfb_config.mem_desc.region[i].size = size;
-		if (omap_fb_sram_plane != i && start) {
-			reserve_bootmem(start, size);
-			total_size += size;
+		/* Check if it's our memory type. */
+		if (set_fbmem_region_type(&rg, OMAPFB_MEMTYPE_SDRAM,
+				          sdram_start, sdram_size) < 0 ||
+		    (rg.type != OMAPFB_MEMTYPE_SDRAM))
+			continue;
+		BUG_ON(omapfb_config.mem_desc.region[i].size);
+		if (check_fbmem_region(i, &rg, sdram_start, sdram_size) < 0) {
+			config_invalid = 1;
+			return;
 		}
-		i++;
+		if (rg.paddr)
+			reserve_bootmem(rg.paddr, rg.size);
+		reserved += rg.size;
+		omapfb_config.mem_desc.region[i] = rg;
+		configured_regions++;
 	}
 	omapfb_config.mem_desc.region_cnt = i;
-	if (total_size)
+	if (reserved)
 		pr_info("Reserving %lu bytes SDRAM for frame buffer\n",
-			 total_size);
+			 reserved);
+}
+
+/*
+ * Called at sram init time, before anything is pushed to the SRAM stack.
+ * Because of the stack scheme, we will allocate everything from the
+ * start of the lowest address region to the end of SRAM. This will also
+ * include padding for page alignment and possible holes between regions.
+ *
+ * As opposed to the SDRAM case, we'll also do any dynamic allocations at
+ * this point, since the driver built as a module would have problem with
+ * freeing / reallocating the regions.
+ */
+unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
+				  unsigned long sram_vstart,
+				  unsigned long sram_size,
+				  unsigned long pstart_avail,
+				  unsigned long size_avail)
+{
+	struct omapfb_mem_region	rg;
+	unsigned long			pend_avail;
+	unsigned long			reserved;
+	int				i;
+
+	if (config_invalid)
+		return 0;
+
+	reserved = 0;
+	pend_avail = pstart_avail + size_avail;
+	for (i = 0; ; i++) {
+		if (get_fbmem_region(i, &rg) < 0)
+			break;
+		if (i == OMAPFB_PLANE_NUM) {
+			printk(KERN_ERR
+				"Extraneous FB mem configuration entries\n");
+			config_invalid = 1;
+			return 0;
+		}
+
+		/* Check if it's our memory type. */
+		if (set_fbmem_region_type(&rg, OMAPFB_MEMTYPE_SRAM,
+				          sram_pstart, sram_size) < 0 ||
+		    (rg.type != OMAPFB_MEMTYPE_SRAM))
+			continue;
+		BUG_ON(omapfb_config.mem_desc.region[i].size);
+
+		if (check_fbmem_region(i, &rg, pstart_avail, size_avail) < 0) {
+			config_invalid = 1;
+			return 0;
+		}
 
+		if (!rg.paddr) {
+			/* Dynamic allocation */
+			if ((size_avail & PAGE_MASK) < rg.size) {
+				printk("Not enough SRAM for FB region %d\n",
+					i);
+				config_invalid = 1;
+				return 0;
+			}
+			size_avail = (size_avail - rg.size) & PAGE_MASK;
+			rg.paddr = pstart_avail + size_avail;
+		}
+		/* Reserve everything above the start of the region. */
+		if (pend_avail - rg.paddr > reserved)
+			reserved = pend_avail - rg.paddr;
+		size_avail = pend_avail - reserved - pstart_avail;
+
+		/*
+		 * We have a kernel mapping for this already, so the
+		 * driver won't have to make one.
+		 */
+		rg.vaddr = (void *)(sram_vstart + rg.paddr - sram_pstart);
+		omapfb_config.mem_desc.region[i] = rg;
+		configured_regions++;
+	}
+	omapfb_config.mem_desc.region_cnt = i;
+	if (reserved)
+		pr_info("Reserving %lu bytes SRAM for frame buffer\n",
+			 reserved);
+	return reserved;
 }
 
 void omapfb_set_ctrl_platform_data(void *data)
@@ -104,10 +306,19 @@ static inline int omap_init_fb(void)
 {
 	const struct omap_lcd_config *conf;
 
+	if (config_invalid)
+		return 0;
+	if (configured_regions != omapfb_config.mem_desc.region_cnt) {
+		printk(KERN_ERR "Invalid FB mem configuration entries\n");
+		return 0;
+	}
 	conf = omap_get_config(OMAP_TAG_LCD, struct omap_lcd_config);
-	if (conf == NULL)
+	if (conf == NULL) {
+		if (configured_regions)
+			/* FB mem config, but no LCD config? */
+			printk(KERN_ERR "Missing LCD configuration\n");
 		return 0;
-
+	}
 	omapfb_config.lcd = *conf;
 
 	return platform_device_register(&omap_fb_device);
@@ -117,7 +328,13 @@ arch_initcall(omap_init_fb);
 
 #else
 
-void omapfb_reserve_mem(void) {}
+void omapfb_reserve_sdram(void) {}
+unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
+				  unsigned long sram_vstart,
+				  unsigned long sram_size,
+				  unsigned long start_avail,
+				  unsigned long size_avail) {}
+
 
 #endif
 
Index: linux-2.6/arch/arm/plat-omap/sram.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/sram.c	2007-04-05 11:32:44.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/sram.c	2007-04-05 11:35:01.000000000 -0400
@@ -51,10 +51,14 @@ static unsigned long omap_sram_base;
 static unsigned long omap_sram_size;
 static unsigned long omap_sram_ceil;
 
-int	omap_fb_sram_plane = -1;
-int	omap_fb_sram_valid;
+extern unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
+					 unsigned long sram_vstart,
+					 unsigned long sram_size,
+					 unsigned long pstart_avail,
+					 unsigned long size_avail);
 
-/* Depending on the target RAMFS firewall setup, the public usable amount of
+/*
+ * Depending on the target RAMFS firewall setup, the public usable amount of
  * SRAM varies.  The default accessable size for all device types is 2k. A GP
  * device allows ARM11 but not other initators for full size. This
  * functionality seems ok until some nice security API happens.
@@ -78,45 +82,6 @@ static int is_sram_locked(void)
 		return 1; /* assume locked with no PPA or security driver */
 }
 
-static int get_fb_sram_conf(unsigned long start_avail, unsigned size_avail,
-			      unsigned long *start, int *plane_idx)
-{
-	const struct omap_fbmem_config *fbmem_conf;
-	unsigned long size = 0;
-	int i;
-
-	i = 0;
-	*start = 0;
-	*plane_idx = -1;
-	while ((fbmem_conf = omap_get_nr_config(OMAP_TAG_FBMEM,
-				struct omap_fbmem_config, i)) != NULL) {
-		u32 paddr, end;
-
-		paddr = fbmem_conf->start;
-		end = fbmem_conf->start + fbmem_conf->size;
-		if (paddr > omap_sram_start &&
-		    paddr < omap_sram_start + omap_sram_size) {
-			if (*plane_idx != -1 || paddr < start_avail ||
-			    paddr == end ||
-			    end > start_avail + size_avail) {
-				printk(KERN_ERR "invalid FB SRAM configuration");
-				*start = 0;
-				return -1;
-			}
-			*plane_idx = i;
-			*start = fbmem_conf->start;
-			size = fbmem_conf->size;
-		}
-		i++;
-	}
-
-	if (*plane_idx >= 0)
-		pr_info("Reserving %lu bytes SRAM frame buffer "
-			"for plane %d\n", size, *plane_idx);
-
-	return 0;
-}
-
 /*
  * The amount of SRAM depends on the core type.
  * Note that we cannot try to test for SRAM here because writes
@@ -125,7 +90,7 @@ static int get_fb_sram_conf(unsigned lon
  */
 void __init omap_detect_sram(void)
 {
-	unsigned long fb_sram_start;
+	unsigned long reserved;
 
 	if (cpu_is_omap24xx()) {
 		if (is_sram_locked()) {
@@ -158,13 +123,11 @@ void __init omap_detect_sram(void)
 			omap_sram_size = 0x4000;
 		}
 	}
-	if (get_fb_sram_conf(omap_sram_start + SRAM_BOOTLOADER_SZ,
-			    omap_sram_size - SRAM_BOOTLOADER_SZ,
-			    &fb_sram_start, &omap_fb_sram_plane) == 0)
-		omap_fb_sram_valid = 1;
-	if (omap_fb_sram_valid && omap_fb_sram_plane >= 0)
-		omap_sram_size -= omap_sram_start + omap_sram_size -
-				  fb_sram_start;
+	reserved = omapfb_reserve_sram(omap_sram_start, omap_sram_base,
+				       omap_sram_size,
+				       omap_sram_start + SRAM_BOOTLOADER_SZ,
+				       omap_sram_size - SRAM_BOOTLOADER_SZ);
+	omap_sram_size -= reserved;
 	omap_sram_ceil = omap_sram_base + omap_sram_size;
 }
 
Index: linux-2.6/include/asm-arm/arch-omap/sram.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/sram.h	2007-04-05 11:32:44.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/sram.h	2007-04-05 11:32:44.000000000 -0400
@@ -20,9 +20,6 @@ extern void omap2_sram_reprogram_sdrc(u3
 				      u32 mem_type);
 extern u32 omap2_set_prcm(u32 dpll_ctrl_val, u32 sdrc_rfr_val, int bypass);
 
-extern int omap_fb_sram_plane;
-extern int omap_fb_sram_valid;
-
 /* Do not use these */
 extern void sram_reprogram_clock(u32 ckctl, u32 dpllctl);
 extern unsigned long sram_reprogram_clock_sz;

--5mZBmBd1ZkdwT1ny--

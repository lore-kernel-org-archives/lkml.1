Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYCLVoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYCLVoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYCLVnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:43:52 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:64723 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbYCLVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:43:50 -0400
From: York Sun <yorksun@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       York Sun <yorksun@freescale.com>
Subject: [PATCH 2/2] Add DIU platform code for MPC8610HPCD
Date: Wed, 12 Mar 2008 16:43:43 -0500
Message-Id: <12053582232536-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12053582231281-git-send-email-yorksun@freescale.com>
References: <12053582234100-git-send-email-yorksun@freescale.com>
 <12053582231281-git-send-email-yorksun@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform code to support Freescale DIU. The platform code includes
framebuffer memory allocation, pixel format, monitor port, etc.

Signed-off-by: York Sun <yorksun@freescale.com>
---

This patch is targeting 2.6.26.

 arch/powerpc/platforms/86xx/mpc8610_hpcd.c |  266 +++++++++++++++++++++++++++-
 1 files changed, 264 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index 0b07485..3ac8d2a 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -3,6 +3,7 @@
  *
  * Initial author: Xianghua Xiao <x.xiao@freescale.com>
  * Recode: Jason Jin <jason.jin@freescale.com>
+ *         York Sun <yorksun@freescale.com>
  *
  * Rewrite the interrupt routing. remove the 8259PIC support,
  * All the integrated device in ULI use sideband interrupt.
@@ -38,6 +39,17 @@
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
 
+#include <linux/bootmem.h>
+#include <asm/rheap.h>
+
+#undef DEBUG
+#ifdef DEBUG
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__, ## args)
+#else
+#define DPRINTK(fmt, args...)
+#endif
+static unsigned char *pixis_bdcfg0, *pixis_arch;
+
 static struct of_device_id __initdata mpc8610_ids[] = {
 	{ .compatible = "fsl,mpc8610-immr", },
 	{}
@@ -161,12 +173,251 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL, 0x5229, quirk_uli5229);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5288, final_uli5288);
 #endif /* CONFIG_PCI */
 
+static u32 get_busfreq(void)
+{
+	struct device_node *node;
+
+	u32 fs_busfreq = 0;
+	node = of_find_node_by_type(NULL, "cpu");
+	if (node) {
+		unsigned int size;
+		const unsigned int *prop =
+			of_get_property(node, "bus-frequency", &size);
+		if (prop)
+			fs_busfreq = *prop;
+		of_node_put(node);
+	};
+	return fs_busfreq;
+}
+
+#ifdef CONFIG_FB_FSL_DIU
+
+static rh_block_t diu_rh_block[16];
+static rh_info_t diu_rh_info;
+static unsigned long diu_size = 1280 * 1024 * 4; /* One 1280x1024 buffer */
+static void *diu_mem;
+
+unsigned int platform_get_pixel_format
+	(unsigned int bits_per_pixel, int monitor_port)
+{
+	static const unsigned long pixelformat[][3] = {
+		{0x88882317, 0x88083218, 0x65052119},
+		{0x88883316, 0x88082219, 0x65053118},
+	};
+	unsigned int pix_fmt, arch_monitor;
+
+	arch_monitor = ((*pixis_arch == 0x01) && (monitor_port == 0))? 0 : 1;
+		/* DVI port for board version 0x01 */
+
+	if (bits_per_pixel == 32)
+		pix_fmt = pixelformat[arch_monitor][0];
+	else if (bits_per_pixel == 24)
+		pix_fmt = pixelformat[arch_monitor][1];
+	else if (bits_per_pixel == 16)
+		pix_fmt = pixelformat[arch_monitor][2];
+	else
+		pix_fmt = pixelformat[1][0];
+
+	return pix_fmt;
+}
+EXPORT_SYMBOL(platform_get_pixel_format);
+
+void platform_set_gamma_table(int monitor_port, char *gamma_table_base)
+{
+	int i;
+	if (monitor_port == 2) {		/* dual link LVDS */
+		for (i = 0; i < 256*3; i++)
+			gamma_table_base[i] = (gamma_table_base[i] << 2) |
+					 ((gamma_table_base[i] >> 6) & 0x03);
+	}
+}
+EXPORT_SYMBOL(platform_set_gamma_table);
+
+void platform_set_monitor_port(int monitor_port)
+{
+	static const u8 bdcfg[] = {0xBD, 0xB5, 0xA5};
+	if (monitor_port < 3)
+		*pixis_bdcfg0 = bdcfg[monitor_port];
+}
+EXPORT_SYMBOL(platform_set_monitor_port);
+
+void platform_set_pixel_clock(unsigned int pixclock)
+{
+	u32 __iomem *clkdvdr;
+	u32 temp;
+	/* variables for pixel clock calcs */
+	ulong  bestval, bestfreq, speed_ccb, minpixclock, maxpixclock;
+	ulong pixval;
+	long err;
+	int i;
+
+	clkdvdr = ioremap(get_immrbase() + 0xe0800, sizeof(u32));
+
+	/* Pixel Clock configuration */
+	DPRINTK("DIU: Bus Frequency = %d\n", get_busfreq());
+	speed_ccb = get_busfreq();
+
+	/* Calculate the pixel clock with the smallest error */
+	/* calculate the following in steps to avoid overflow */
+	DPRINTK("DIU pixclock in ps - %d\n", pixclock);
+	temp = 1000000000/pixclock;
+	temp *= 1000;
+	pixclock = temp;
+	DPRINTK("DIU pixclock freq - %lu\n", pixclock);
+
+	temp = pixclock * 5 / 100;
+	DPRINTK("deviation = %d\n", temp);
+	minpixclock = pixclock - temp;
+	maxpixclock = pixclock + temp;
+	DPRINTK("DIU minpixclock - %lu\n", minpixclock);
+	DPRINTK("DIU maxpixclock - %lu\n", maxpixclock);
+	pixval = speed_ccb/pixclock;
+	DPRINTK("DIU pixval = %lu\n", pixval);
+
+	err = 100000000;
+	bestval = pixval;
+	DPRINTK("DIU bestval = %lu\n", bestval);
+
+	bestfreq = 0;
+	for (i = -1; i <= 1; i++) {
+		temp = speed_ccb / ((pixval+i) + 1);
+		DPRINTK("DIU test pixval i= %d, pixval=%lu, temp freq. = %u\n",
+							i, pixval, temp);
+		if ((temp < minpixclock) || (temp > maxpixclock))
+			DPRINTK("DIU exceeds monitor range (%lu to %lu)\n",
+				minpixclock, maxpixclock);
+		else if (abs(temp - pixclock) < err) {
+		  DPRINTK("Entered the else if block %d\n", i);
+			err = abs(temp - pixclock);
+			bestval = pixval+i;
+			bestfreq = temp;
+		}
+	}
+
+	DPRINTK("DIU chose = %lx\n", bestval);
+	DPRINTK("DIU error = %ld\n NomPixClk ", err);
+	DPRINTK("DIU: Best Freq = %lx\n", bestfreq);
+	/* Modify PXCLK in GUTS CLKDVDR */
+	DPRINTK("DIU: Current value of CLKDVDR = 0x%08x\n", (*clkdvdr));
+	temp = (*clkdvdr) & 0x2000FFFF;
+	*clkdvdr = temp;		/* turn off clock */
+	*clkdvdr = temp | 0x80000000 | (((bestval) & 0x1F) << 16);
+	DPRINTK("DIU: Modified value of CLKDVDR = 0x%08x\n", (*clkdvdr));
+}
+EXPORT_SYMBOL(platform_set_pixel_clock);
+
+ssize_t platform_show_monitor_port(int monitor_port, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE,
+			"%c0 - DVI\n"
+			"%c1 - Single link LVDS\n"
+			"%c2 - Dual link LVDS\n",
+			monitor_port == 0 ? '*' : ' ',
+			monitor_port == 1 ? '*' : ' ',
+			monitor_port == 2 ? '*' : ' ');
+}
+EXPORT_SYMBOL(platform_show_monitor_port);
+
+int platform_set_sysfs_monitor_port(int val)
+{
+	return val < 3 ? val : 0;
+}
+EXPORT_SYMBOL(platform_set_monitor_port);
+
+static void __init preallocate_diu_videomemory(void)
+{
+	DPRINTK("diu_size=%lu\n", diu_size);
+
+	diu_mem = __alloc_bootmem(diu_size, 8, 0);
+	if (!diu_mem) {
+		printk(KERN_ERR "fsl-diu: cannot allocate %lu bytes\n",
+			diu_size);
+		return;
+	}
+
+	printk(KERN_INFO "%s: diu_mem=%p\n", __func__, diu_mem);
+
+	rh_init(&diu_rh_info, 4096, ARRAY_SIZE(diu_rh_block), diu_rh_block);
+	rh_attach_region(&diu_rh_info, diu_mem, diu_size);
+}
+
+/*	To allocate memory for framebuffer. First try dma_alloc_coherent. If it
+ *	fails, try rh_alloc. The reason is dma_alloc_coherent cannot allocate
+ *	very large memory (more than 4MB). We don't want to allocate all memory
+ *	in rheap since small memory allocation/deallocation will fragment the
+ *	rheap and make the furture large allocation fail.
+ */
+
+void *fsl_diu_alloc(unsigned long size, unsigned long *phys)
+{
+	 void *virt;
+
+	 DPRINTK("size=%lu\n", size);
+
+	 virt = dma_alloc_coherent(0, size, phys, GFP_DMA | GFP_KERNEL);
+
+	 if (virt) {
+		DPRINTK("dma virt=%p phys=%lx\n", virt, *phys);
+		return virt;
+	 }
+
+	 if (!diu_mem) {
+		printk(KERN_INFO "%s: no diu_mem\n", __func__);
+		return NULL;
+	 }
+
+	 virt = rh_alloc(&diu_rh_info, size, "DIU");
+	 if (virt)
+		*phys = virt_to_bus(virt);
+
+	 DPRINTK("rh virt=%p phys=%x\n", virt, *phys);
+
+	 return virt;
+}
+EXPORT_SYMBOL(fsl_diu_alloc);
+
+void fsl_diu_free(void *p, unsigned long size)
+{
+	DPRINTK("p=%p size=%lu\n", p, size);
+
+	if (!p)
+		return;
+
+	if ((p >= diu_mem) && (p < (diu_mem + diu_size))) {
+		DPRINTK("rh\n");
+		rh_free(&diu_rh_info, p);
+	} else {
+		DPRINTK("dma\n");
+		dma_free_coherent(0, size, p, 0);
+	}
+}
+EXPORT_SYMBOL(fsl_diu_free);
+
+static int __init early_parse_diufb(char *p)
+{
+	if (!p)
+		return 1;
+
+	diu_size = _ALIGN_UP(memparse(p, &p), 8);
+
+	printk(KERN_INFO "%s: diu_size=%lu\n", __func__, diu_size);
+
+	return 0;
+}
+early_param("diufb", early_parse_diufb);
+
+#else
+
+#define preallocate_diu_videomemory() do { } while (0)
+
+#endif
+
 static void __init
 mpc86xx_hpcd_setup_arch(void)
 {
-#ifdef CONFIG_PCI
+	struct resource r;
 	struct device_node *np;
-#endif
+
 	if (ppc_md.progress)
 		ppc_md.progress("mpc86xx_hpcd_setup_arch()", 0);
 
@@ -183,6 +434,17 @@ mpc86xx_hpcd_setup_arch(void)
 		}
         }
 #endif
+	preallocate_diu_videomemory();
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,fpga-pixis");
+	if (np) {
+		of_address_to_resource(np, 0, &r);
+		of_node_put(np);
+		pixis_bdcfg0 = ioremap(r.start + 0x00000008, sizeof(u8));
+		pixis_arch = ioremap(r.start + 0x00000001, sizeof(u8));
+	} else
+		printk(KERN_ERR "Err: "
+				"can't find device node 'fsl,fpga-pixis'\n");
 
 	printk("MPC86xx HPCD board from Freescale Semiconductor\n");
 }
-- 
1.5.2.2


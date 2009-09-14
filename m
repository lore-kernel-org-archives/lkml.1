Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbZINK1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbZINK1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZINK1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:27:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:35474 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753578AbZINK1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:27:05 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18gmelIIXggPXemKHbJdoHXq5pzLxKBiLOreE22k5
	nU4YJrUsO1fQny
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net,
       Harald Welte <laforge@gnumonks.org>,
       Harald Welte <HaraldWelte@viatech.com>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/4] viafb: make viafb a first-class citizen using pci_driver
Date: Mon, 14 Sep 2009 10:30:05 +0000
Message-Id: <1252924206-3721-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1252924206-3721-2-git-send-email-FlorianSchandinat@gmx.de>
References: <1252924206-3721-1-git-send-email-FlorianSchandinat@gmx.de>
 <1252924206-3721-2-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@gnumonks.org>

[FB] viafb: make viafb a first-class citizen using pci_driver

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c       |  115 +++--------------------------------------
 drivers/video/via/hw.h       |    5 +-
 drivers/video/via/viafbdev.c |   52 ++++++++++++++++---
 3 files changed, 56 insertions(+), 116 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 95faf8b..3e083ff 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -21,22 +21,6 @@
 
 #include "global.h"
 
-static const struct pci_device_id_info pciidlist[] = {
-	{PCI_VIA_VENDOR_ID, UNICHROME_CLE266_DID, UNICHROME_CLE266},
-	{PCI_VIA_VENDOR_ID, UNICHROME_PM800_DID, UNICHROME_PM800},
-	{PCI_VIA_VENDOR_ID, UNICHROME_K400_DID, UNICHROME_K400},
-	{PCI_VIA_VENDOR_ID, UNICHROME_K800_DID, UNICHROME_K800},
-	{PCI_VIA_VENDOR_ID, UNICHROME_CN700_DID, UNICHROME_CN700},
-	{PCI_VIA_VENDOR_ID, UNICHROME_P4M890_DID, UNICHROME_P4M890},
-	{PCI_VIA_VENDOR_ID, UNICHROME_K8M890_DID, UNICHROME_K8M890},
-	{PCI_VIA_VENDOR_ID, UNICHROME_CX700_DID, UNICHROME_CX700},
-	{PCI_VIA_VENDOR_ID, UNICHROME_P4M900_DID, UNICHROME_P4M900},
-	{PCI_VIA_VENDOR_ID, UNICHROME_CN750_DID, UNICHROME_CN750},
-	{PCI_VIA_VENDOR_ID, UNICHROME_VX800_DID, UNICHROME_VX800},
-	{PCI_VIA_VENDOR_ID, UNICHROME_VX855_DID, UNICHROME_VX855},
-	{0, 0, 0}
-};
-
 static struct pll_map pll_value[] = {
 	{CLK_25_175M, CLE266_PLL_25_175M, K800_PLL_25_175M,
 	 CX700_25_175M, VX855_25_175M},
@@ -542,7 +526,8 @@ static void set_dvi_output_path(int set_iga, int output_interface);
 static void set_lcd_output_path(int set_iga, int output_interface);
 static int search_mode_setting(int ModeInfoIndex);
 static void load_fix_bit_crtc_reg(void);
-static void init_gfx_chip_info(void);
+static void init_gfx_chip_info(struct pci_dev *pdev,
+				const struct pci_device_id *pdi);
 static void init_tmds_chip_info(void);
 static void init_lvds_chip_info(void);
 static void device_screen_off(void);
@@ -552,7 +537,6 @@ static void device_off(void);
 static void device_on(void);
 static void enable_second_display_channel(void);
 static void disable_second_display_channel(void);
-static int get_fb_size_from_pci(void);
 
 void viafb_write_reg(u8 index, u16 io_port, u8 data)
 {
@@ -1937,9 +1921,10 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 
 }
 
-void viafb_init_chip_info(void)
+void viafb_init_chip_info(struct pci_dev *pdev,
+			  const struct pci_device_id *pdi)
 {
-	init_gfx_chip_info();
+	init_gfx_chip_info(pdev, pdi);
 	init_tmds_chip_info();
 	init_lvds_chip_info();
 
@@ -2012,24 +1997,12 @@ void viafb_update_device_setting(int hres, int vres,
 	}
 }
 
-static void init_gfx_chip_info(void)
+static void init_gfx_chip_info(struct pci_dev *pdev,
+			       const struct pci_device_id *pdi)
 {
-	struct pci_dev *pdev = NULL;
-	u32 i;
 	u8 tmp;
 
-	/* Indentify GFX Chip Name */
-	for (i = 0; pciidlist[i].vendor != 0; i++) {
-		pdev = pci_get_device(pciidlist[i].vendor,
-			pciidlist[i].device, 0);
-		if (pdev)
-			break;
-	}
-
-	if (!pciidlist[i].vendor)
-		return ;
-
-	viaparinfo->chip_info->gfx_chip_name = pciidlist[i].chip_index;
+	viaparinfo->chip_info->gfx_chip_name = pdi->driver_data;
 
 	/* Check revision of CLE266 Chip */
 	if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266) {
@@ -2060,8 +2033,6 @@ static void init_gfx_chip_info(void)
 				CX700_REVISION_700;
 		}
 	}
-
-	pci_dev_put(pdev);
 }
 
 static void init_tmds_chip_info(void)
@@ -2554,37 +2525,6 @@ void viafb_crt_enable(void)
 	viafb_write_reg_mask(CR36, VIACR, 0x0, BIT5 + BIT4);
 }
 
-void viafb_get_mmio_info(unsigned long *mmio_base, u32 *mmio_len)
-{
-	struct pci_dev *pdev = NULL;
-	u32 vendor, device;
-	u32 i;
-
-	for (i = 0; pciidlist[i].vendor != 0; i++)
-		if (viaparinfo->chip_info->gfx_chip_name ==
-			pciidlist[i].chip_index)
-			break;
-
-	if (!pciidlist[i].vendor)
-		return ;
-
-	vendor = pciidlist[i].vendor;
-	device = pciidlist[i].device;
-
-	pdev = pci_get_device(vendor, device, NULL);
-
-	if (!pdev) {
-		*mmio_base = 0;
-		*mmio_len = 0;
-		return ;
-	}
-
-	*mmio_base = pci_resource_start(pdev, 1);
-	*mmio_len = pci_resource_len(pdev, 1);
-
-	pci_dev_put(pdev);
-}
-
 static void enable_second_display_channel(void)
 {
 	/* to enable second display channel. */
@@ -2601,44 +2541,7 @@ static void disable_second_display_channel(void)
 	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
 }
 
-void viafb_get_fb_info(unsigned int *fb_base, unsigned int *fb_len)
-{
-	struct pci_dev *pdev = NULL;
-	u32 vendor, device;
-	u32 i;
-
-	for (i = 0; pciidlist[i].vendor != 0; i++)
-		if (viaparinfo->chip_info->gfx_chip_name ==
-			pciidlist[i].chip_index)
-			break;
-
-	if (!pciidlist[i].vendor)
-		return ;
-
-	vendor = pciidlist[i].vendor;
-	device = pciidlist[i].device;
-
-	pdev = pci_get_device(vendor, device, NULL);
-
-	if (!pdev) {
-		*fb_base = viafb_read_reg(VIASR, SR30) << 24;
-		*fb_len = viafb_get_memsize();
-		DEBUG_MSG(KERN_INFO "Get FB info from SR30!\n");
-		DEBUG_MSG(KERN_INFO "fb_base = %08x\n", *fb_base);
-		DEBUG_MSG(KERN_INFO "fb_len = %08x\n", *fb_len);
-		return ;
-	}
-
-	*fb_base = (unsigned int)pci_resource_start(pdev, 0);
-	*fb_len = get_fb_size_from_pci();
-	DEBUG_MSG(KERN_INFO "Get FB info from PCI system!\n");
-	DEBUG_MSG(KERN_INFO "fb_base = %08x\n", *fb_base);
-	DEBUG_MSG(KERN_INFO "fb_len = %08x\n", *fb_len);
-
-	pci_dev_put(pdev);
-}
-
-static int get_fb_size_from_pci(void)
+int viafb_get_fb_size_from_pci(void)
 {
 	unsigned long configid, deviceid, FBSize = 0;
 	int VideoMemSize;
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 4e54b2f..b874d95 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -901,14 +901,15 @@ void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 int viafb_setmode(int vmode_index, int hor_res, int ver_res,
 	    int video_bpp, int vmode_index1, int hor_res1,
 	    int ver_res1, int video_bpp1);
-void viafb_init_chip_info(void);
+void viafb_init_chip_info(struct pci_dev *pdev,
+			  const struct pci_device_id *pdi);
 void viafb_init_dac(int set_iga);
 int viafb_get_pixclock(int hres, int vres, int vmode_refresh);
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
 void viafb_update_device_setting(int hres, int vres, int bpp,
 			   int vmode_refresh, int flag);
-void viafb_get_mmio_info(unsigned long *mmio_base, u32 *mmio_len);
 
+int viafb_get_fb_size_from_pci(void);
 void viafb_set_iga_path(void);
 void viafb_set_primary_address(u32 addr);
 void viafb_set_secondary_address(u32 addr);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 28616be..463d92a 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1801,7 +1801,8 @@ out_default:
 	*yres = 480;
 }
 
-static int __devinit via_pci_probe(void)
+static int __devinit via_pci_probe(struct pci_dev *pdev,
+				   const struct pci_device_id *ent)
 {
 	u32 default_xres, default_yres;
 	int vmode_index;
@@ -1844,8 +1845,9 @@ static int __devinit via_pci_probe(void)
 	/* Set up I2C bus stuff */
 	viafb_create_i2c_bus(viaparinfo);
 
-	viafb_init_chip_info();
-	viafb_get_fb_info(&viaparinfo->fbmem, &viaparinfo->memsize);
+	viafb_init_chip_info(pdev, ent);
+	viaparinfo->fbmem = pci_resource_start(pdev, 0);
+	viaparinfo->memsize = viafb_get_fb_size_from_pci();
 	viaparinfo->fbmem_free = viaparinfo->memsize;
 	viaparinfo->fbmem_used = 0;
 	viafbinfo->screen_base = ioremap_nocache(viaparinfo->fbmem,
@@ -1855,8 +1857,8 @@ static int __devinit via_pci_probe(void)
 		return -ENOMEM;
 	}
 
-	viafb_get_mmio_info(&viafbinfo->fix.mmio_start,
-		&viafbinfo->fix.mmio_len);
+	viafbinfo->fix.mmio_start = pci_resource_start(pdev, 1);
+	viafbinfo->fix.mmio_len = pci_resource_len(pdev, 1);
 	viafbinfo->node = 0;
 	viafbinfo->fbops = &viafb_ops;
 	viafbinfo->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
@@ -2024,7 +2026,7 @@ static int __devinit via_pci_probe(void)
 	return 0;
 }
 
-static void __devexit via_pci_remove(void)
+static void __devexit via_pci_remove(struct pci_dev *pdev)
 {
 	DEBUG_MSG(KERN_INFO "via_pci_remove!\n");
 	fb_dealloc_cmap(&viafbinfo->cmap);
@@ -2116,6 +2118,40 @@ static int __init viafb_setup(char *options)
 }
 #endif
 
+static struct pci_device_id viafb_pci_table[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CLE266_DID),
+	  .driver_data = UNICHROME_CLE266 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_PM800_DID),
+	  .driver_data = UNICHROME_PM800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K400_DID),
+	  .driver_data = UNICHROME_K400 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K800_DID),
+	  .driver_data = UNICHROME_K800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M890_DID),
+	  .driver_data = UNICHROME_CN700 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K8M890_DID),
+	  .driver_data = UNICHROME_K8M890 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CX700_DID),
+	  .driver_data = UNICHROME_CX700 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M900_DID),
+	  .driver_data = UNICHROME_P4M900 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CN750_DID),
+	  .driver_data = UNICHROME_CN750 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX800_DID),
+	  .driver_data = UNICHROME_VX800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX855_DID),
+	  .driver_data = UNICHROME_VX855 },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, viafb_pci_table);
+
+static struct pci_driver viafb_driver = {
+	.name		= "viafb",
+	.id_table	= viafb_pci_table,
+	.probe		= via_pci_probe,
+	.remove		= __devexit_p(via_pci_remove),
+};
+
 static int __init viafb_init(void)
 {
 #ifndef MODULE
@@ -2127,13 +2163,13 @@ static int __init viafb_init(void)
 	printk(KERN_INFO
        "VIA Graphics Intergration Chipset framebuffer %d.%d initializing\n",
 	       VERSION_MAJOR, VERSION_MINOR);
-	return via_pci_probe();
+	return pci_register_driver(&viafb_driver);
 }
 
 static void __exit viafb_exit(void)
 {
 	DEBUG_MSG(KERN_INFO "viafb_exit!\n");
-	via_pci_remove();
+	pci_unregister_driver(&viafb_driver);
 }
 
 static struct fb_ops viafb_ops = {
-- 
1.6.3.2


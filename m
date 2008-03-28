Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYC1QXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYC1QXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYC1QWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:22:25 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27962 "EHLO
	outbound7-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419AbYC1QWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:22:23 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: linuxppc-dev@xilinx.com, benh@kernel.crashing.org,
       jwboyer@linux.vnet.ibm.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, git-dev@xilinx.com,
       linux-kernel@vger.kernel.org
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 4/5] [POWERPC] Xilinx: Framebuffer: Use dcr infrastructure.
Date: Fri, 28 Mar 2008 09:20:36 -0700
X-Mailer: git-send-email 1.5.3.4-dirty
In-Reply-To: <1206721237-17982-3-git-send-email-stephen.neuendorffer@xilinx.com>
References: <1206401313-1625-1-git-send-email-stephen.neuendorffer@xilinx.com>
 <1206721237-17982-1-git-send-email-stephen.neuendorffer@xilinx.com>
 <1206721237-17982-2-git-send-email-stephen.neuendorffer@xilinx.com>
 <1206721237-17982-3-git-send-email-stephen.neuendorffer@xilinx.com>
Message-Id: <20080328162218.4F51DD60004@mail123-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device contains a dcr interface.  Previously, the dcr interface
was assumed to be used in mmio mode, and the register space of the dcr
interface was precomputed and stuffed in the device tree.  This patch
makes use of the new dcr infrastructure to represent the dcr interface
as any other dcr interface in the device tree.  This enables the dcr
interface to be connected directly to a native dcr interface in a
clean way.

In particular, the device tree expected looks like:

			dcr_v29_0: dcr@0 {
				#address-cells = <1>;
				#size-cells = <1>;
				compatible = "xlnx,dcr-v29-1.00.a";
				VGA_FrameBuffer: tft@80 {
					compatible = "xlnx,plb-tft-cntlr-ref-1.00.a";
					dcr-parent = <&opb2dcr_bridge_0>;
					dcr-reg = < 80 2 >;
					xlnx,default-tft-base-addr = <7f>;
					xlnx,dps-init = <1>;
					xlnx,on-init = <1>;
					xlnx,pixclk-is-busclk-divby4 = <1>;
				} ;
			} ;

			opb2dcr_bridge_0: opb2dcr-bridge@40700000 {
				compatible = "xlnx,opb2dcr-bridge-1.00.b";
				dcr-access-method = "mmio";
				dcr-controller ;
				dcr-mmio-range = < 40700000 1000 >;
				dcr-mmio-stride = <4>;
				reg = < 40700000 1000 >;
				xlnx,family = "virtex2p";
			} ;

Note that this patch now requires PPC_DCR_MMIO to be set in order to
advertise the framebuffer as a platform device (i.e. ARCH=ppc).

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
---
 drivers/video/xilinxfb.c |   86 ++++++++++++++++++++++++++--------------------
 1 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 7b3a842..171cc09 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -38,6 +38,7 @@
 #endif
 #include <asm/io.h>
 #include <linux/xilinxfb.h>
+#include <asm/dcr.h>
 
 #define DRIVER_NAME		"xilinxfb"
 #define DRIVER_DESCRIPTION	"Xilinx TFT LCD frame buffer driver"
@@ -112,8 +113,9 @@ struct xilinxfb_drvdata {
 
 	struct fb_info	info;		/* FB driver info record */
 
-	u32		regs_phys;	/* phys. address of the control registers */
-	u32 __iomem	*regs;		/* virt. address of the control registers */
+	dcr_host_t      dcr_host;
+	unsigned int    dcr_start;
+	unsigned int    dcr_len;
 
 	void		*fb_virt;	/* virt. address of the frame buffer */
 	dma_addr_t	fb_phys;	/* phys. address of the frame buffer */
@@ -136,7 +138,7 @@ struct xilinxfb_drvdata {
  * when it's needed.
  */
 #define xilinx_fb_out_be32(driverdata, offset, val) \
-	out_be32(driverdata->regs + offset, val)
+	dcr_write(driverdata->dcr_host, offset, val)
 
 static int
 xilinx_fb_setcolreg(unsigned regno, unsigned red, unsigned green, unsigned blue,
@@ -204,7 +206,8 @@ static struct fb_ops xilinxfb_ops =
  * Bus independent setup/teardown
  */
 
-static int xilinxfb_assign(struct device *dev, unsigned long physaddr,
+static int xilinxfb_assign(struct device *dev, dcr_host_t dcr_host,
+			   unsigned int dcr_start, unsigned int dcr_len,
 			   struct xilinxfb_platform_data *pdata)
 {
 	struct xilinxfb_drvdata *drvdata;
@@ -219,21 +222,9 @@ static int xilinxfb_assign(struct device *dev, unsigned long physaddr,
 	}
 	dev_set_drvdata(dev, drvdata);
 
-	/* Map the control registers in */
-	if (!request_mem_region(physaddr, 8, DRIVER_NAME)) {
-		dev_err(dev, "Couldn't lock memory region at 0x%08lX\n",
-			physaddr);
-		rc = -ENODEV;
-		goto err_region;
-	}
-	drvdata->regs_phys = physaddr;
-	drvdata->regs = ioremap(physaddr, 8);
-	if (!drvdata->regs) {
-		dev_err(dev, "Couldn't lock memory region at 0x%08lX\n",
-			physaddr);
-		rc = -ENODEV;
-		goto err_map;
-	}
+	drvdata->dcr_start = dcr_start;
+	drvdata->dcr_len = dcr_len;
+	drvdata->dcr_host = dcr_host;
 
 	/* Allocate the framebuffer memory */
 	if (pdata->fb_phys) {
@@ -248,7 +239,7 @@ static int xilinxfb_assign(struct device *dev, unsigned long physaddr,
 	if (!drvdata->fb_virt) {
 		dev_err(dev, "Could not allocate frame buffer memory\n");
 		rc = -ENOMEM;
-		goto err_fbmem;
+		goto err_region;
 	}
 
 	/* Clear (turn to black) the framebuffer */
@@ -298,7 +289,6 @@ static int xilinxfb_assign(struct device *dev, unsigned long physaddr,
 	}
 
 	/* Put a banner in the log (for DEBUG) */
-	dev_dbg(dev, "regs: phys=%lx, virt=%p\n", physaddr, drvdata->regs);
 	dev_dbg(dev, "fb: phys=%p, virt=%p, size=%x\n",
 		(void*)drvdata->fb_phys, drvdata->fb_virt, fbsize);
 
@@ -314,12 +304,6 @@ err_cmap:
 	/* Turn off the display */
 	xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
 
-err_fbmem:
-	iounmap(drvdata->regs);
-
-err_map:
-	release_mem_region(physaddr, 8);
-
 err_region:
 	kfree(drvdata);
 	dev_set_drvdata(dev, NULL);
@@ -345,9 +329,8 @@ static int xilinxfb_release(struct device *dev)
 
 	/* Turn off the display */
 	xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
-	iounmap(drvdata->regs);
 
-	release_mem_region(drvdata->regs_phys, 8);
+	dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
 
 	kfree(drvdata);
 	dev_set_drvdata(dev, NULL);
@@ -355,6 +338,7 @@ static int xilinxfb_release(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PPC_DCR_MMIO
 /* ---------------------------------------------------------------------
  * Platform bus binding
  */
@@ -364,6 +348,9 @@ xilinxfb_platform_probe(struct platform_device *pdev)
 {
 	struct xilinxfb_platform_data *pdata;
 	struct resource *res;
+	dcr_host_t dcr_host;
+	int dcr_start = 0;
+	int dcr_len = 2;
 
 	/* Find the registers address */
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -386,7 +373,12 @@ xilinxfb_platform_probe(struct platform_device *pdev)
 			pdata->yvirt = xilinx_fb_default_pdata.yvirt;
 	}
 
-	return xilinxfb_assign(&pdev->dev, res->start, pdata);
+	dcr_host = dcr_map_mmio_literal(res->start, 4, dcr_start, dcr_len);
+	if (!DCR_MAP_OK(dcr_host)) {
+		dev_err(&pdev->dev, "invalid address\n");
+		return -ENODEV;
+	}
+	return xilinxfb_assign(&pdev->dev, dcr_host, dcr_start, dcr_len, pdata);
 }
 
 static int
@@ -405,6 +397,23 @@ static struct platform_driver xilinxfb_platform_driver = {
 	},
 };
 
+/* Registration helpers to keep the number of #ifdefs to a minimum */
+static inline int __init xilinxfb_platform_register(void)
+{
+	pr_debug("xilinxfb: calling of_register_platform_driver()\n");
+	return platform_driver_register(&xilinxfb_platform_driver);
+}
+
+static inline void __exit xilinxfb_platform_unregister(void)
+{
+	platform_driver_unregister(&xilinxfb_platform_driver);
+}
+#else /* CONFIG_PPC_DCR_MMIO */
+/* CONFIG_OF not enabled; do nothing helpers */
+static inline int __init xilinxfb_platform_register(void) { return 0; }
+static inline void __exit xilinxfb_platform_unregister(void) { }
+#endif /* CONFIG_PPC_DCR_MMIO */
+
 /* ---------------------------------------------------------------------
  * OF bus binding
  */
@@ -413,20 +422,23 @@ static struct platform_driver xilinxfb_platform_driver = {
 static int __devinit
 xilinxfb_of_probe(struct of_device *op, const struct of_device_id *match)
 {
-	struct resource res;
 	const u32 *prop;
 	struct xilinxfb_platform_data pdata;
 	int size, rc;
+	int start, len;
+	dcr_host_t dcr_host;
 
 	/* Copy with the default pdata (not a ptr reference!) */
 	pdata = xilinx_fb_default_pdata;
 
 	dev_dbg(&op->dev, "xilinxfb_of_probe(%p, %p)\n", op, match);
 
-	rc = of_address_to_resource(op->node, 0, &res);
-	if (rc) {
+	start = dcr_resource_start(op->node, 0);
+	len = dcr_resource_len(op->node, 0);
+	dcr_host = dcr_map(op->node, start, len);
+	if (!DCR_MAP_OK(dcr_host)) {
 		dev_err(&op->dev, "invalid address\n");
-		return rc;
+		return -ENODEV;
 	}
 
 	prop = of_get_property(op->node, "phys-size", &size);
@@ -450,7 +462,7 @@ xilinxfb_of_probe(struct of_device *op, const struct of_device_id *match)
 	if (of_find_property(op->node, "rotate-display", NULL))
 		pdata.rotate_screen = 1;
 
-	return xilinxfb_assign(&op->dev, res.start, &pdata);
+	return xilinxfb_assign(&op->dev, dcr_host, start, len, &pdata);
 }
 
 static int __devexit xilinxfb_of_remove(struct of_device *op)
@@ -505,7 +517,7 @@ xilinxfb_init(void)
 	if (rc)
 		return rc;
 
-	rc = platform_driver_register(&xilinxfb_platform_driver);
+	rc = xilinxfb_platform_register();
 	if (rc)
 		xilinxfb_of_unregister();
 
@@ -515,7 +527,7 @@ xilinxfb_init(void)
 static void __exit
 xilinxfb_cleanup(void)
 {
-	platform_driver_unregister(&xilinxfb_platform_driver);
+	xilinxfb_platform_unregister();
 	xilinxfb_of_unregister();
 }
 
-- 
1.5.3.4-dirty



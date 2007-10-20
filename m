Return-Path: <linux-kernel-owner+w=401wt.eu-S936096AbXJTCwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936096AbXJTCwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbXJTCwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:52:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:27893 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbXJTCwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:52:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,302,1188802800"; 
   d="scan'208";a="301961567"
From: Jesse Barnes <jesse.barnes@intel.com>
To: dri-devel@lists.sourceforge.net
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Date: Fri, 19 Oct 2007 19:51:45 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200710181401.50470.jbarnes@virtuousgeek.org>
In-Reply-To: <200710181401.50470.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191951.45659.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 18, 2007 2:01 pm Jesse Barnes wrote:
> We seem to see a lot of bug reports along the lines of, "my machine
> resumes but I can't see X" or, "I can see X but only with a bright
> flashlight", etc.  These sorts of problems are due to the fact that
> the X server isn't designed to do full state save/restore, and none
> of the available kernel drivers do it on its behalf.
>
> Since intelfb and the rest of the Intel drivers are fairly
> incompatible, this patch makes the DRM bind to the PCI device so it
> can register real suspend/resume handlers.  Those handlers take care
> of saving and restoring enough state for X to come back reliably on
> at least one of my problematic test machines, but text mode still has
> trouble (still debugging VGA state save/restore, including trying to
> save/restore actual VRAM contents for possible hibernate support).
>
> How does this approach look?  Is a new DRM driver flag a good thing
> for similar situations with other drivers?  Thoughts?

Here's an updated one that actually works fully on my 965 based test
platform.  It should also work on other 9xx platforms, but note that it
lacks TV out and SDVO state save/restore, so I don't expect those to
work.  I also haven't tested on 8xx platforms, but a similar approach
should work, so I'd welcome additions to support those chipsets.

Dave can you take a look at the new flag and also see what you think
about supporting suspend/resume in the event X hasn't started yet?
There's some #if 0'd code to support that case, but I haven't tested
it.

Thanks,
Jesse

diff --git a/linux-core/Kconfig b/linux-core/Kconfig
index 2d02c76..5e73fc7 100644
--- a/linux-core/Kconfig
+++ b/linux-core/Kconfig
@@ -50,7 +50,7 @@ config DRM_I810
 
 choice
 	prompt "Intel 830M, 845G, 852GM, 855GM, 865G"
-	depends on DRM && AGP && AGP_INTEL
+	depends on DRM && AGP && AGP_INTEL && !FB_INTEL
 	optional
 
 config DRM_I915
@@ -60,6 +60,9 @@ config DRM_I915
 	  852GM, 855GM, 865G, 915G, 915GM, 945G, 945GM and 965G integrated 
 	  graphics.  If M is selected, the module will be called i915.  
 	  AGP support is required for this driver to work.
+
+	  Note that this driver is incompatible with the Intel framebuffer
+	  driver.
 	
 endchoice
 
diff --git a/linux-core/drmP.h b/linux-core/drmP.h
index f8ca3f4..36ce266 100644
--- a/linux-core/drmP.h
+++ b/linux-core/drmP.h
@@ -106,6 +106,7 @@ struct drm_file;
 #define DRIVER_DMA_QUEUE   0x200
 #define DRIVER_FB_DMA      0x400
 #define DRIVER_IRQ_VBL2    0x800
+#define DRIVER_BIND_PCI    0x1000
 
 
 /*@}*/
diff --git a/linux-core/drm_drv.c b/linux-core/drm_drv.c
index a09fa96..4d11707 100644
--- a/linux-core/drm_drv.c
+++ b/linux-core/drm_drv.c
@@ -340,9 +340,10 @@ int drm_init(struct drm_driver *driver,
 		}
 	}
 
-	if (!drm_fb_loaded)
+	if (!drm_fb_loaded || (driver->driver_features & DRIVER_BIND_PCI)) {
+		printk(KERN_ERR "DRM binding to PCI device\n");
 		return pci_register_driver(&driver->pci_driver);
-	else {
+	} else {
 		for (i = 0; pciidlist[i].vendor != 0; i++) {
 			pid = &pciidlist[i];
 
diff --git a/linux-core/i915_drv.c b/linux-core/i915_drv.c
index e337e1d..809ef0d 100644
--- a/linux-core/i915_drv.c
+++ b/linux-core/i915_drv.c
@@ -69,6 +69,501 @@ static struct drm_bo_driver i915_bo_driver = {
 };
 #endif
 
+enum pipe {
+    PIPE_A = 0,
+    PIPE_B,
+};
+
+static bool i915_pipe_enabled(struct drm_device *dev, enum pipe pipe)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	if (pipe == PIPE_A)
+		return (I915_READ(DPLL_A) & DPLL_VCO_ENABLE);
+	else
+		return (I915_READ(DPLL_B) & DPLL_VCO_ENABLE);
+}
+
+static void i915_save_palette(struct drm_device *dev, enum pipe pipe)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long reg = pipe == PIPE_A ? PALETTE_A : PALETTE_B;
+	u32 *array;
+	int i;
+
+	if (!i915_pipe_enabled(dev, pipe))
+		return;
+
+	if (pipe == PIPE_A)
+		array = dev_priv->savePaletteA;
+	else
+		array = dev_priv->savePaletteB;
+
+	for(i = 0; i < 256; i++)
+		array[i] = I915_READ(reg + (i << 2));
+}
+
+static void i915_restore_palette(struct drm_device *dev, enum pipe pipe)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long reg = pipe == PIPE_A ? PALETTE_A : PALETTE_B;
+	u32 *array;
+	int i;
+
+	if (!i915_pipe_enabled(dev, pipe))
+		return;
+
+	if (pipe == PIPE_A)
+		array = dev_priv->savePaletteA;
+	else
+		array = dev_priv->savePaletteB;
+
+	for(i = 0; i < 256; i++)
+		I915_WRITE(reg + (i << 2), array[i]);
+}
+
+static u8 i915_read_indexed(u16 index_port, u16 data_port, u8 reg)
+{
+	outb(reg, index_port);
+	return inb(data_port);
+}
+
+static u8 i915_read_ar(u16 st01, u8 reg, u16 palette_enable)
+{
+	inb(st01);
+	outb(palette_enable | reg, VGA_AR_INDEX);
+	return inb(VGA_AR_DATA_READ);
+}
+
+static void i915_write_ar(u8 st01, u8 reg, u8 val, u16 palette_enable)
+{
+	inb(st01);
+	outb(palette_enable | reg, VGA_AR_INDEX);
+	outb(val, VGA_AR_DATA_WRITE);
+}
+
+static void i915_write_indexed(u16 index_port, u16 data_port, u8 reg, u8 val)
+{
+	outb(reg, index_port);
+	outb(val, data_port);
+}
+
+static void i915_save_vga(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int i;
+	u16 cr_index, cr_data, st01;
+
+	/* VGA color palette registers */
+	dev_priv->saveDACMASK = inb(VGA_DACMASK);
+	/* DACCRX automatically increments during read */
+	outb(0, VGA_DACRX);
+	/* Read 3 bytes of color data from each index */
+	for (i = 0; i < 256 * 3; i++)
+		dev_priv->saveDACDATA[i] = inb(VGA_DACDATA);
+
+	/* MSR bits */
+	dev_priv->saveMSR = inb(VGA_MSR_READ);
+	if (dev_priv->saveMSR & VGA_MSR_CGA_MODE) {
+		cr_index = VGA_CR_INDEX_CGA;
+		cr_data = VGA_CR_DATA_CGA;
+		st01 = VGA_ST01_CGA;
+	} else {
+		cr_index = VGA_CR_INDEX_MDA;
+		cr_data = VGA_CR_DATA_MDA;
+		st01 = VGA_ST01_MDA;
+	}
+
+	/* CRT controller regs */
+	i915_write_indexed(cr_index, cr_data, 0x11,
+			   i915_read_indexed(cr_index, cr_data, 0x11) &
+			   (~0x80));
+	for (i = 0; i < 0x24; i++)
+		dev_priv->saveCR[i] =
+			i915_read_indexed(cr_index, cr_data, i);
+	/* Make sure we don't turn off CR group 0 writes */
+	dev_priv->saveCR[0x11] &= ~0x80;
+
+	/* Attribute controller registers */
+	inb(st01);
+	dev_priv->saveAR_INDEX = inb(VGA_AR_INDEX);
+	for (i = 0; i < 20; i++)
+		dev_priv->saveAR[i] = i915_read_ar(st01, i, 0);
+	inb(st01);
+	outb(dev_priv->saveAR_INDEX, VGA_AR_INDEX);
+
+	/* Graphics controller registers */
+	for (i = 0; i < 9; i++)
+		dev_priv->saveGR[i] =
+			i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, i);
+
+	dev_priv->saveGR[0x10] =
+		i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x10);
+	dev_priv->saveGR[0x11] =
+		i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x11);
+	dev_priv->saveGR[0x18] =
+		i915_read_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x18);
+
+	/* Sequencer registers */
+	for (i = 0; i < 8; i++)
+		dev_priv->saveSR[i] =
+			i915_read_indexed(VGA_SR_INDEX, VGA_SR_DATA, i);
+}
+
+static void i915_restore_vga(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int i;
+	u16 cr_index, cr_data, st01;
+
+	/* MSR bits */
+	outb(dev_priv->saveMSR, VGA_MSR_WRITE);
+	if (dev_priv->saveMSR & VGA_MSR_CGA_MODE) {
+		cr_index = VGA_CR_INDEX_CGA;
+		cr_data = VGA_CR_DATA_CGA;
+		st01 = VGA_ST01_CGA;
+	} else {
+		cr_index = VGA_CR_INDEX_MDA;
+		cr_data = VGA_CR_DATA_MDA;
+		st01 = VGA_ST01_MDA;
+	}
+
+	/* Sequencer registers, don't write SR07 */
+	for (i = 0; i < 7; i++)
+		i915_write_indexed(VGA_SR_INDEX, VGA_SR_DATA, i,
+				   dev_priv->saveSR[i]);
+
+	/* CRT controller regs */
+	/* Enable CR group 0 writes */
+	i915_write_indexed(cr_index, cr_data, 0x11, dev_priv->saveCR[0x11]);
+	for (i = 0; i < 0x24; i++) {
+		printk(KERN_ERR "restoring CR[%d]: %02x\n", i,
+		       dev_priv->saveCR[i]);
+		i915_write_indexed(cr_index, cr_data, i, dev_priv->saveCR[i]);
+	}
+
+	/* Graphics controller regs */
+	for (i = 0; i < 9; i++)
+		i915_write_indexed(VGA_GR_INDEX, VGA_GR_DATA, i,
+				   dev_priv->saveGR[i]);
+
+	i915_write_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x10,
+			   dev_priv->saveGR[0x10]);
+	i915_write_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x11,
+			   dev_priv->saveGR[0x11]);
+	i915_write_indexed(VGA_GR_INDEX, VGA_GR_DATA, 0x18,
+			   dev_priv->saveGR[0x18]);
+
+	/* Attribute controller registers */
+	for (i = 0; i < 20; i++)
+		i915_write_ar(st01, i, dev_priv->saveAR[i], 0);
+	inb(st01); /* switch back to index mode */
+	outb(dev_priv->saveAR_INDEX | 0x20, VGA_AR_INDEX);
+
+	/* VGA color palette registers */
+	outb(dev_priv->saveDACMASK, VGA_DACMASK);
+	/* DACCRX automatically increments during read */
+	outb(0, VGA_DACWX);
+	/* Read 3 bytes of color data from each index */
+	for (i = 0; i < 256 * 3; i++)
+		outb(dev_priv->saveDACDATA[i], VGA_DACDATA);
+
+}
+
+static drm_local_map_t *old_mmio_map;
+
+static int i915_map_regs(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long base, size;
+	int ret = 0, mmio_bar = IS_I9XX(dev) ? 0 : 1;
+
+	base = drm_get_resource_start(dev, mmio_bar);
+	size = drm_get_resource_len(dev, mmio_bar);
+
+	old_mmio_map = dev_priv->mmio_map;
+
+	ret = drm_addmap(dev, base, size, _DRM_REGISTERS, _DRM_KERNEL,
+			 &dev_priv->mmio_map);
+
+	if (ret)
+		dev_priv->mmio_map = old_mmio_map;
+
+	return ret;
+}
+
+static void i915_unmap_regs(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	drm_rmmap(dev, dev_priv->mmio_map);
+	dev_priv->mmio_map = old_mmio_map;
+}
+
+static int i915_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int i;
+
+	if (!dev || !dev_priv) {
+		printk(KERN_ERR "DRM not initialized, aborting suspend.\n");
+		return -ENODEV;
+	}
+#if 0
+	if (i915_map_regs(pdev)) {
+		printk(KERN_ERR "failed to map i915 regs, aborting suspend.\n");
+		return -EIO;
+	}
+#endif
+	pci_save_state(pdev);
+	pci_read_config_byte(pdev, LBB, &dev_priv->saveLBB);
+
+	/* Pipe & plane A info */
+	dev_priv->savePIPEACONF = I915_READ(PIPEACONF);
+	dev_priv->savePIPEASRC = I915_READ(PIPEASRC);
+	dev_priv->saveFPA0 = I915_READ(FPA0);
+	dev_priv->saveFPA1 = I915_READ(FPA1);
+	dev_priv->saveDPLL_A = I915_READ(DPLL_A);
+	if (IS_I965G(dev))
+		dev_priv->saveDPLL_A_MD = I915_READ(DPLL_A_MD);
+	dev_priv->saveHTOTAL_A = I915_READ(HTOTAL_A);
+	dev_priv->saveHBLANK_A = I915_READ(HBLANK_A);
+	dev_priv->saveHSYNC_A = I915_READ(HSYNC_A);
+	dev_priv->saveVTOTAL_A = I915_READ(VTOTAL_A);
+	dev_priv->saveVBLANK_A = I915_READ(VBLANK_A);
+	dev_priv->saveVSYNC_A = I915_READ(VSYNC_A);
+	dev_priv->saveBCLRPAT_A = I915_READ(BCLRPAT_A);
+
+	dev_priv->saveDSPACNTR = I915_READ(DSPACNTR);
+	dev_priv->saveDSPASTRIDE = I915_READ(DSPASTRIDE);
+	dev_priv->saveDSPASIZE = I915_READ(DSPASIZE);
+	dev_priv->saveDSPAPOS = I915_READ(DSPAPOS);
+	dev_priv->saveDSPABASE = I915_READ(DSPABASE);
+	if (IS_I965G(dev)) {
+		dev_priv->saveDSPASURF = I915_READ(DSPASURF);
+		dev_priv->saveDSPATILEOFF = I915_READ(DSPATILEOFF);
+	}
+	i915_save_palette(dev, PIPE_A);
+
+	/* Pipe & plane B info */
+	dev_priv->savePIPEBCONF = I915_READ(PIPEBCONF);
+	dev_priv->savePIPEBSRC = I915_READ(PIPEBSRC);
+	dev_priv->saveFPB0 = I915_READ(FPB0);
+	dev_priv->saveFPB1 = I915_READ(FPB1);
+	dev_priv->saveDPLL_B = I915_READ(DPLL_B);
+	if (IS_I965G(dev))
+		dev_priv->saveDPLL_B_MD = I915_READ(DPLL_B_MD);
+	dev_priv->saveHTOTAL_B = I915_READ(HTOTAL_B);
+	dev_priv->saveHBLANK_B = I915_READ(HBLANK_B);
+	dev_priv->saveHSYNC_B = I915_READ(HSYNC_B);
+	dev_priv->saveVTOTAL_B = I915_READ(VTOTAL_B);
+	dev_priv->saveVBLANK_B = I915_READ(VBLANK_B);
+	dev_priv->saveVSYNC_B = I915_READ(VSYNC_B);
+	dev_priv->saveBCLRPAT_A = I915_READ(BCLRPAT_A);
+
+	dev_priv->saveDSPBCNTR = I915_READ(DSPBCNTR);
+	dev_priv->saveDSPBSTRIDE = I915_READ(DSPBSTRIDE);
+	dev_priv->saveDSPBSIZE = I915_READ(DSPBSIZE);
+	dev_priv->saveDSPBPOS = I915_READ(DSPBPOS);
+	dev_priv->saveDSPBBASE = I915_READ(DSPBBASE);
+	if (IS_I965GM(dev)) {
+		dev_priv->saveDSPBSURF = I915_READ(DSPBSURF);
+		dev_priv->saveDSPBTILEOFF = I915_READ(DSPBTILEOFF);
+	}
+	i915_save_palette(dev, PIPE_B);
+
+	/* CRT state */
+	dev_priv->saveADPA = I915_READ(ADPA);
+
+	/* LVDS state */
+	dev_priv->savePP_CONTROL = I915_READ(PP_CONTROL);
+	dev_priv->savePFIT_PGM_RATIOS = I915_READ(PFIT_PGM_RATIOS);
+	dev_priv->saveBLC_PWM_CTL = I915_READ(BLC_PWM_CTL);
+	if (IS_I965G(dev))
+		dev_priv->saveBLC_PWM_CTL2 = I915_READ(BLC_PWM_CTL2);
+	if (IS_MOBILE(dev) && !IS_I830(dev))
+		dev_priv->saveLVDS = I915_READ(LVDS);
+	if (!IS_I830(dev) && !IS_845G(dev))
+		dev_priv->savePFIT_CONTROL = I915_READ(PFIT_CONTROL);
+	dev_priv->saveLVDSPP_ON = I915_READ(LVDSPP_ON);
+	dev_priv->saveLVDSPP_OFF = I915_READ(LVDSPP_OFF);
+	dev_priv->savePP_CYCLE = I915_READ(PP_CYCLE);
+
+	/* FIXME: save TV & SDVO state */
+
+	/* FBC state */
+	dev_priv->saveFBC_CFB_BASE = I915_READ(FBC_CFB_BASE);
+	dev_priv->saveFBC_LL_BASE = I915_READ(FBC_LL_BASE);
+	dev_priv->saveFBC_CONTROL2 = I915_READ(FBC_CONTROL2);
+	dev_priv->saveFBC_CONTROL = I915_READ(FBC_CONTROL);
+
+	/* VGA state */
+	dev_priv->saveVCLK_DIVISOR_VGA0 = I915_READ(VCLK_DIVISOR_VGA0);
+	dev_priv->saveVCLK_DIVISOR_VGA1 = I915_READ(VCLK_DIVISOR_VGA1);
+	dev_priv->saveVCLK_POST_DIV = I915_READ(VCLK_POST_DIV);
+	dev_priv->saveVGACNTRL = I915_READ(VGACNTRL);
+
+	/* Scratch space */
+	for (i = 0; i < 16; i++) {
+		dev_priv->saveSWF0[i] = I915_READ(SWF0 + (i << 2));
+		dev_priv->saveSWF1[i] = I915_READ(SWF10 + (i << 2));
+	}
+	for (i = 0; i < 3; i++)
+		dev_priv->saveSWF2[i] = I915_READ(SWF30 + (i << 2));
+
+	i915_save_vga(dev);
+
+	/* Shut down the device */
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
+}
+
+static int i915_resume(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int i;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	if (pci_enable_device(pdev))
+		return -1;
+
+	pci_write_config_byte(pdev, LBB, dev_priv->saveLBB);
+
+	/* Pipe & plane A info */
+	/* Prime the clock */
+	if (dev_priv->saveDPLL_A & DPLL_VCO_ENABLE) {
+		I915_WRITE(DPLL_A, dev_priv->saveDPLL_A &
+			   ~DPLL_VCO_ENABLE);
+		udelay(150);
+	}
+	I915_WRITE(FPA0, dev_priv->saveFPA0);
+	I915_WRITE(FPA1, dev_priv->saveFPA1);
+	/* Actually enable it */
+	I915_WRITE(DPLL_A, dev_priv->saveDPLL_A);
+	udelay(150);
+	if (IS_I965G(dev))
+		I915_WRITE(DPLL_A_MD, dev_priv->saveDPLL_A_MD);
+	udelay(150);
+
+	/* Restore mode */
+	I915_WRITE(HTOTAL_A, dev_priv->saveHTOTAL_A);
+	I915_WRITE(HBLANK_A, dev_priv->saveHBLANK_A);
+	I915_WRITE(HSYNC_A, dev_priv->saveHSYNC_A);
+	I915_WRITE(VTOTAL_A, dev_priv->saveVTOTAL_A);
+	I915_WRITE(VBLANK_A, dev_priv->saveVBLANK_A);
+	I915_WRITE(VSYNC_A, dev_priv->saveVSYNC_A);
+	I915_WRITE(BCLRPAT_A, dev_priv->saveBCLRPAT_A);
+   
+	/* Restore plane info */
+	I915_WRITE(DSPASIZE, dev_priv->saveDSPASIZE);
+	I915_WRITE(DSPAPOS, dev_priv->saveDSPAPOS);
+	I915_WRITE(PIPEASRC, dev_priv->savePIPEASRC);
+	I915_WRITE(DSPABASE, dev_priv->saveDSPABASE);
+	I915_WRITE(DSPASTRIDE, dev_priv->saveDSPASTRIDE);
+	if (IS_I965G(dev)) {
+		I915_WRITE(DSPASURF, dev_priv->saveDSPASURF);
+		I915_WRITE(DSPATILEOFF, dev_priv->saveDSPATILEOFF);
+	}
+	I915_WRITE(PIPEACONF, dev_priv->savePIPEACONF);
+	i915_restore_palette(dev, PIPE_A);
+	/* Enable the plane */
+	I915_WRITE(DSPACNTR, dev_priv->saveDSPACNTR);
+	I915_WRITE(DSPABASE, I915_READ(DSPABASE));
+
+	/* Pipe & plane B info */
+	if (dev_priv->saveDPLL_B & DPLL_VCO_ENABLE) {
+		I915_WRITE(DPLL_B, dev_priv->saveDPLL_B &
+			   ~DPLL_VCO_ENABLE);
+		udelay(150);
+	}
+	I915_WRITE(FPB0, dev_priv->saveFPB0);
+	I915_WRITE(FPB1, dev_priv->saveFPB1);
+	/* Actually enable it */
+	I915_WRITE(DPLL_B, dev_priv->saveDPLL_B);
+	udelay(150);
+	if (IS_I965G(dev))
+		I915_WRITE(DPLL_B_MD, dev_priv->saveDPLL_B_MD);
+	udelay(150);
+   
+	/* Restore mode */
+	I915_WRITE(HTOTAL_B, dev_priv->saveHTOTAL_B);
+	I915_WRITE(HBLANK_B, dev_priv->saveHBLANK_B);
+	I915_WRITE(HSYNC_B, dev_priv->saveHSYNC_B);
+	I915_WRITE(VTOTAL_B, dev_priv->saveVTOTAL_B);
+	I915_WRITE(VBLANK_B, dev_priv->saveVBLANK_B);
+	I915_WRITE(VSYNC_B, dev_priv->saveVSYNC_B);
+	I915_WRITE(BCLRPAT_B, dev_priv->saveBCLRPAT_B);
+
+	/* Restore plane info */
+	I915_WRITE(DSPBSIZE, dev_priv->saveDSPBSIZE);
+	I915_WRITE(DSPBPOS, dev_priv->saveDSPBPOS);
+	I915_WRITE(PIPEBSRC, dev_priv->savePIPEBSRC);
+	I915_WRITE(DSPBBASE, dev_priv->saveDSPBBASE);
+	I915_WRITE(DSPBSTRIDE, dev_priv->saveDSPBSTRIDE);
+	if (IS_I965G(dev)) {
+		I915_WRITE(DSPBSURF, dev_priv->saveDSPBSURF);
+		I915_WRITE(DSPBTILEOFF, dev_priv->saveDSPBTILEOFF);
+	}
+	I915_WRITE(PIPEBCONF, dev_priv->savePIPEBCONF);
+	i915_restore_palette(dev, PIPE_A);
+	/* Enable the plane */
+	I915_WRITE(DSPBCNTR, dev_priv->saveDSPBCNTR);
+	I915_WRITE(DSPBBASE, I915_READ(DSPBBASE));
+
+	/* CRT state */
+	I915_WRITE(ADPA, dev_priv->saveADPA);
+
+	/* LVDS state */
+	if (IS_I965G(dev))
+		I915_WRITE(BLC_PWM_CTL2, dev_priv->saveBLC_PWM_CTL2);
+	if (IS_MOBILE(dev) && !IS_I830(dev))
+		I915_WRITE(LVDS, dev_priv->saveLVDS);
+	if (!IS_I830(dev) && !IS_845G(dev))
+		I915_WRITE(PFIT_CONTROL, dev_priv->savePFIT_CONTROL);
+
+	I915_WRITE(PFIT_PGM_RATIOS, dev_priv->savePFIT_PGM_RATIOS);
+	I915_WRITE(BLC_PWM_CTL, dev_priv->saveBLC_PWM_CTL);
+	I915_WRITE(LVDSPP_ON, dev_priv->saveLVDSPP_ON);
+	I915_WRITE(LVDSPP_OFF, dev_priv->saveLVDSPP_OFF);
+	I915_WRITE(PP_CYCLE, dev_priv->savePP_CYCLE);
+	I915_WRITE(PP_CONTROL, dev_priv->savePP_CONTROL);
+
+	/* FIXME: restore TV & SDVO state */
+
+	/* FBC info */
+	I915_WRITE(FBC_CFB_BASE, dev_priv->saveFBC_CFB_BASE);
+	I915_WRITE(FBC_LL_BASE, dev_priv->saveFBC_LL_BASE);
+	I915_WRITE(FBC_CONTROL2, dev_priv->saveFBC_CONTROL2);
+	I915_WRITE(FBC_CONTROL, dev_priv->saveFBC_CONTROL);
+
+	/* VGA state */
+	I915_WRITE(VGACNTRL, dev_priv->saveVGACNTRL);
+	I915_WRITE(VCLK_DIVISOR_VGA0, dev_priv->saveVCLK_DIVISOR_VGA0);
+	I915_WRITE(VCLK_DIVISOR_VGA1, dev_priv->saveVCLK_DIVISOR_VGA1);
+	I915_WRITE(VCLK_POST_DIV, dev_priv->saveVCLK_POST_DIV);
+	udelay(150);
+
+	for (i = 0; i < 16; i++) {
+		I915_WRITE(SWF0 + (i << 2), dev_priv->saveSWF0[i]);
+		I915_WRITE(SWF10 + (i << 2), dev_priv->saveSWF1[i+7]);
+	}
+	for (i = 0; i < 3; i++)
+		I915_WRITE(SWF30 + (i << 2), dev_priv->saveSWF2[i]);
+
+	i915_restore_vga(dev);
+
+	//i915_unmap_regs(pdev);
+
+	return 0;
+}
+
 static int probe(struct pci_dev *pdev, const struct pci_device_id *ent);
 static struct drm_driver driver = {
 	/* don't use mtrr's here, the Xserver or user space app should
@@ -77,7 +572,7 @@ static struct drm_driver driver = {
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_REQUIRE_AGP | /* DRIVER_USE_MTRR | */
 	    DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | DRIVER_IRQ_VBL |
-	    DRIVER_IRQ_VBL2,
+	    DRIVER_IRQ_VBL2 | DRIVER_BIND_PCI,
 	.load = i915_driver_load,
 	.firstopen = i915_driver_firstopen,
 	.lastclose = i915_driver_lastclose,
@@ -110,6 +605,8 @@ static struct drm_driver driver = {
 		.id_table = pciidlist,
 		.probe = probe,
 		.remove = __devexit_p(drm_cleanup_pci),
+		.suspend = i915_suspend,
+		.resume = i915_resume,
 		},
 #ifdef I915_HAVE_FENCE
 	.fence_driver = &i915_fence_driver,
diff --git a/shared-core/i915_dma.c b/shared-core/i915_dma.c
index 7209a8d..b8370be 100644
--- a/shared-core/i915_dma.c
+++ b/shared-core/i915_dma.c
@@ -31,17 +31,6 @@
 #include "i915_drm.h"
 #include "i915_drv.h"
 
-#define IS_I965G(dev)  (dev->pci_device == 0x2972 || \
-			dev->pci_device == 0x2982 || \
-			dev->pci_device == 0x2992 || \
-			dev->pci_device == 0x29A2 || \
-			dev->pci_device == 0x2A02 || \
-			dev->pci_device == 0x2A12)
-
-#define IS_G33(dev)    (dev->pci_device == 0x29C2 || \
-		   	dev->pci_device == 0x29B2 || \
-			dev->pci_device == 0x29D2) 
-
 /* Really want an OS-independent resettable timer.  Would like to have
  * this loop run for (eg) 3 sec, but have the timer reset every time
  * the head pointer changes, so that EBUSY only happens if the ring
diff --git a/shared-core/i915_drv.h b/shared-core/i915_drv.h
index e8f1879..9038c29 100644
--- a/shared-core/i915_drv.h
+++ b/shared-core/i915_drv.h
@@ -145,6 +145,88 @@ typedef struct drm_i915_private {
 	drm_i915_vbl_swap_t vbl_swaps;
 	unsigned int swaps_pending;
 
+ 	/* Register state */
+	u8 saveLBB;
+ 	u32 saveDSPACNTR;
+ 	u32 saveDSPBCNTR;
+ 	u32 savePIPEACONF;
+ 	u32 savePIPEBCONF;
+ 	u32 savePIPEASRC;
+ 	u32 savePIPEBSRC;
+ 	u32 saveFPA0;
+ 	u32 saveFPA1;
+ 	u32 saveDPLL_A;
+ 	u32 saveDPLL_A_MD;
+ 	u32 saveHTOTAL_A;
+ 	u32 saveHBLANK_A;
+ 	u32 saveHSYNC_A;
+ 	u32 saveVTOTAL_A;
+ 	u32 saveVBLANK_A;
+ 	u32 saveVSYNC_A;
+	u32 saveBCLRPAT_A;
+ 	u32 saveDSPASTRIDE;
+ 	u32 saveDSPASIZE;
+ 	u32 saveDSPAPOS;
+ 	u32 saveDSPABASE;
+ 	u32 saveDSPASURF;
+	u32 saveDSPATILEOFF;
+	u32 savePFIT_PGM_RATIOS;
+	u32 saveBLC_PWM_CTL;
+	u32 saveBLC_PWM_CTL2;
+ 	u32 saveFPB0;
+ 	u32 saveFPB1;
+ 	u32 saveDPLL_B;
+ 	u32 saveDPLL_B_MD;
+ 	u32 saveHTOTAL_B;
+ 	u32 saveHBLANK_B;
+ 	u32 saveHSYNC_B;
+ 	u32 saveVTOTAL_B;
+ 	u32 saveVBLANK_B;
+ 	u32 saveVSYNC_B;
+	u32 saveBCLRPAT_B;
+ 	u32 saveDSPBSTRIDE;
+ 	u32 saveDSPBSIZE;
+ 	u32 saveDSPBPOS;
+ 	u32 saveDSPBBASE;
+ 	u32 saveDSPBSURF;
+	u32 saveDSPBTILEOFF;
+ 	u32 saveVCLK_DIVISOR_VGA0;
+ 	u32 saveVCLK_DIVISOR_VGA1;
+ 	u32 saveVCLK_POST_DIV;
+ 	u32 saveVGACNTRL;
+ 	u32 saveADPA;
+ 	u32 saveLVDS;
+	u32 saveLVDSPP_ON;
+	u32 saveLVDSPP_OFF;
+ 	u32 saveDVOA;
+ 	u32 saveDVOB;
+ 	u32 saveDVOC;
+ 	u32 savePP_ON;
+ 	u32 savePP_OFF;
+ 	u32 savePP_CONTROL;
+ 	u32 savePP_CYCLE;
+ 	u32 savePFIT_CONTROL;
+ 	u32 savePaletteA[256];
+ 	u32 savePaletteB[256];
+	u32 saveFBC_CFB_BASE;
+	u32 saveFBC_LL_BASE;
+	u32 saveFBC_CONTROL;
+	u32 saveFBC_CONTROL2;
+ 	u32 saveSWF0[16];
+ 	u32 saveSWF1[16];
+ 	u32 saveSWF2[3];
+	u8 saveMSR;
+	u8 saveSR[8];
+	u8 saveGR[24];
+	u8 saveAR_INDEX;
+	u8 saveAR[20];
+	u8 saveDACMASK;
+	u8 saveDACDATA[256*3]; /* 256 3-byte colors */
+	u8 saveCR[36];
+	u8 savePLANE0[64*1024];
+	u8 savePLANE1[64*1024];
+	u8 savePLANE2[64*1024];
+	u8 savePLANE3[64*1024];
 } drm_i915_private_t;
 
 enum intel_chip_family {
@@ -272,6 +354,50 @@ extern int i915_move(struct drm_buffer_object *bo, int evict,
 
 extern int i915_wait_ring(struct drm_device * dev, int n, const char *caller);
 
+/* Extended config space */
+#define LBB 0xf4
+
+/* VGA stuff */
+
+#define VGA_ST01_MDA 0x3ba
+#define VGA_ST01_CGA 0x3da
+
+#define VGA_MSR_WRITE 0x3c2
+#define VGA_MSR_READ 0x3cc
+#define   VGA_MSR_MEM_EN (1<<1)
+#define   VGA_MSR_CGA_MODE (1<<0)
+
+#define VGA_SR_INDEX 0x3c4
+#define VGA_SR_DATA 0x3c5
+
+#define VGA_AR_INDEX 0x3c0
+#define   VGA_AR_VID_EN (1<<5)
+#define VGA_AR_DATA_WRITE 0x3c0
+#define VGA_AR_DATA_READ 0x3c1
+
+#define VGA_GR_INDEX 0x3ce
+#define VGA_GR_DATA 0x3cf
+/* GR05 */
+#define   VGA_GR_MEM_READ_MODE_SHIFT 3
+#define     VGA_GR_MEM_READ_MODE_PLANE 1
+/* GR06 */
+#define   VGA_GR_MEM_MODE_MASK 0xc
+#define   VGA_GR_MEM_MODE_SHIFT 2
+#define   VGA_GR_MEM_A0000_AFFFF 0
+#define   VGA_GR_MEM_A0000_BFFFF 1
+#define   VGA_GR_MEM_B0000_B7FFF 2
+#define   VGA_GR_MEM_B0000_BFFFF 3
+
+#define VGA_DACMASK 0x3c6
+#define VGA_DACRX 0x3c7
+#define VGA_DACWX 0x3c8
+#define VGA_DACDATA 0x3c9
+
+#define VGA_CR_INDEX_MDA 0x3b4
+#define VGA_CR_DATA_MDA 0x3b5
+#define VGA_CR_INDEX_CGA 0x3d4
+#define VGA_CR_DATA_CGA 0x3d5
+
 #define GFX_OP_USER_INTERRUPT 		((0<<29)|(2<<23))
 #define GFX_OP_BREAKPOINT_INTERRUPT	((0<<29)|(1<<23))
 #define CMD_REPORT_HEAD			(7<<23)
@@ -294,6 +420,37 @@ extern int i915_wait_ring(struct drm_device * dev, int n, const char *caller);
 #define BB1_UNPROTECTED       (0<<0)
 #define BB2_END_ADDR_MASK     (~0x7)
 
+/* Framebuffer compression */
+#define FBC_CFB_BASE		0x03200 /* 4k page aligned */
+#define FBC_LL_BASE		0x03204 /* 4k page aligned */
+#define FBC_CONTROL		0x03208
+#define   FBC_CTL_EN		(1<<31)
+#define   FBC_CTL_PERIODIC	(1<<30)
+#define   FBC_CTL_INTERVAL_SHIFT (16)
+#define   FBC_CTL_UNCOMPRESSIBLE (1<<14)
+#define   FBC_CTL_STRIDE_SHIFT	(5)
+#define   FBC_CTL_FENCENO	(1<<0)
+#define FBC_COMMAND		0x0320c
+#define   FBC_CMD_COMPRESS	(1<<0)
+#define FBC_STATUS		0x03210
+#define   FBC_STAT_COMPRESSING	(1<<31)
+#define   FBC_STAT_COMPRESSED	(1<<30)
+#define   FBC_STAT_MODIFIED	(1<<29)
+#define   FBC_STAT_CURRENT_LINE	(1<<0)
+#define FBC_CONTROL2		0x03214
+#define   FBC_CTL_FENCE_DBL	(0<<4)
+#define   FBC_CTL_IDLE_IMM	(0<<2)
+#define   FBC_CTL_IDLE_FULL	(1<<2)
+#define   FBC_CTL_IDLE_LINE	(2<<2)
+#define   FBC_CTL_IDLE_DEBUG	(3<<2)
+#define   FBC_CTL_CPU_FENCE	(1<<1)
+#define   FBC_CTL_PLANEA	(0<<0)
+#define   FBC_CTL_PLANEB	(1<<0)
+#define FBC_FENCE_OFF		0x0321b
+
+#define FBC_LL_SIZE		(1536)
+#define FBC_LL_PAD		(32)
+
 /* Interrupt bits:
  */
 #define USER_INT_FLAG    (1<<1)
@@ -515,4 +672,509 @@ extern int i915_wait_ring(struct drm_device * dev, int n, const char *caller);
 
 #define READ_BREADCRUMB(dev_priv)  (((volatile u32*)(dev_priv->hw_status_page))[5])
 #define READ_HWSP(dev_priv, reg)  (((volatile u32*)(dev_priv->hw_status_page))[reg])
+
+#define BLC_PWM_CTL		0x61254
+#define BACKLIGHT_MODULATION_FREQ_SHIFT		(17)
+
+#define BLC_PWM_CTL2		0x61250
+/**
+ * This is the most significant 15 bits of the number of backlight cycles in a
+ * complete cycle of the modulated backlight control.
+ *
+ * The actual value is this field multiplied by two.
+ */
+#define BACKLIGHT_MODULATION_FREQ_MASK		(0x7fff << 17)
+#define BLM_LEGACY_MODE				(1 << 16)
+/**
+ * This is the number of cycles out of the backlight modulation cycle for which
+ * the backlight is on.
+ *
+ * This field must be no greater than the number of cycles in the complete
+ * backlight modulation cycle.
+ */
+#define BACKLIGHT_DUTY_CYCLE_SHIFT		(0)
+#define BACKLIGHT_DUTY_CYCLE_MASK		(0xffff)
+
+#define I915_GCFGC			0xf0
+#define I915_LOW_FREQUENCY_ENABLE		(1 << 7)
+#define I915_DISPLAY_CLOCK_190_200_MHZ		(0 << 4)
+#define I915_DISPLAY_CLOCK_333_MHZ		(4 << 4)
+#define I915_DISPLAY_CLOCK_MASK			(7 << 4)
+
+#define I855_HPLLCC			0xc0
+#define I855_CLOCK_CONTROL_MASK			(3 << 0)
+#define I855_CLOCK_133_200			(0 << 0)
+#define I855_CLOCK_100_200			(1 << 0)
+#define I855_CLOCK_100_133			(2 << 0)
+#define I855_CLOCK_166_250			(3 << 0)
+
+/* p317, 319
+ */
+#define VCLK2_VCO_M        0x6008 /* treat as 16 bit? (includes msbs) */
+#define VCLK2_VCO_N        0x600a
+#define VCLK2_VCO_DIV_SEL  0x6012
+
+#define VCLK_DIVISOR_VGA0   0x6000
+#define VCLK_DIVISOR_VGA1   0x6004
+#define VCLK_POST_DIV	    0x6010
+/** Selects a post divisor of 4 instead of 2. */
+# define VGA1_PD_P2_DIV_4	(1 << 15)
+/** Overrides the p2 post divisor field */
+# define VGA1_PD_P1_DIV_2	(1 << 13)
+# define VGA1_PD_P1_SHIFT	8
+/** P1 value is 2 greater than this field */
+# define VGA1_PD_P1_MASK	(0x1f << 8)
+/** Selects a post divisor of 4 instead of 2. */
+# define VGA0_PD_P2_DIV_4	(1 << 7)
+/** Overrides the p2 post divisor field */
+# define VGA0_PD_P1_DIV_2	(1 << 5)
+# define VGA0_PD_P1_SHIFT	0
+/** P1 value is 2 greater than this field */
+# define VGA0_PD_P1_MASK	(0x1f << 0)
+
+/* I830 CRTC registers */
+#define HTOTAL_A	0x60000
+#define HBLANK_A	0x60004
+#define HSYNC_A 	0x60008
+#define VTOTAL_A	0x6000c
+#define VBLANK_A	0x60010
+#define VSYNC_A 	0x60014
+#define PIPEASRC	0x6001c
+#define BCLRPAT_A	0x60020
+#define VSYNCSHIFT_A	0x60028
+
+#define HTOTAL_B	0x61000
+#define HBLANK_B	0x61004
+#define HSYNC_B 	0x61008
+#define VTOTAL_B	0x6100c
+#define VBLANK_B	0x61010
+#define VSYNC_B 	0x61014
+#define PIPEBSRC	0x6101c
+#define BCLRPAT_B	0x61020
+#define VSYNCSHIFT_B	0x61028
+
+#define PP_STATUS	0x61200
+# define PP_ON					(1 << 31)
+/**
+ * Indicates that all dependencies of the panel are on:
+ *
+ * - PLL enabled
+ * - pipe enabled
+ * - LVDS/DVOB/DVOC on
+ */
+# define PP_READY				(1 << 30)
+# define PP_SEQUENCE_NONE			(0 << 28)
+# define PP_SEQUENCE_ON				(1 << 28)
+# define PP_SEQUENCE_OFF			(2 << 28)
+# define PP_SEQUENCE_MASK			0x30000000
+#define PP_CONTROL	0x61204
+# define POWER_TARGET_ON			(1 << 0)
+
+#define LVDSPP_ON       0x61208
+#define LVDSPP_OFF      0x6120c
+#define PP_CYCLE        0x61210
+
+#define PFIT_CONTROL	0x61230
+# define PFIT_ENABLE				(1 << 31)
+# define PFIT_PIPE_MASK				(3 << 29)
+# define PFIT_PIPE_SHIFT			29
+# define VERT_INTERP_DISABLE			(0 << 10)
+# define VERT_INTERP_BILINEAR			(1 << 10)
+# define VERT_INTERP_MASK			(3 << 10)
+# define VERT_AUTO_SCALE			(1 << 9)
+# define HORIZ_INTERP_DISABLE			(0 << 6)
+# define HORIZ_INTERP_BILINEAR			(1 << 6)
+# define HORIZ_INTERP_MASK			(3 << 6)
+# define HORIZ_AUTO_SCALE			(1 << 5)
+# define PANEL_8TO6_DITHER_ENABLE		(1 << 3)
+
+#define PFIT_PGM_RATIOS	0x61234
+# define PFIT_VERT_SCALE_MASK			0xfff00000
+# define PFIT_HORIZ_SCALE_MASK			0x0000fff0
+
+#define PFIT_AUTO_RATIOS	0x61238
+
+
+#define DPLL_A		0x06014
+#define DPLL_B		0x06018
+# define DPLL_VCO_ENABLE			(1 << 31)
+# define DPLL_DVO_HIGH_SPEED			(1 << 30)
+# define DPLL_SYNCLOCK_ENABLE			(1 << 29)
+# define DPLL_VGA_MODE_DIS			(1 << 28)
+# define DPLLB_MODE_DAC_SERIAL			(1 << 26) /* i915 */
+# define DPLLB_MODE_LVDS			(2 << 26) /* i915 */
+# define DPLL_MODE_MASK				(3 << 26)
+# define DPLL_DAC_SERIAL_P2_CLOCK_DIV_10	(0 << 24) /* i915 */
+# define DPLL_DAC_SERIAL_P2_CLOCK_DIV_5		(1 << 24) /* i915 */
+# define DPLLB_LVDS_P2_CLOCK_DIV_14		(0 << 24) /* i915 */
+# define DPLLB_LVDS_P2_CLOCK_DIV_7		(1 << 24) /* i915 */
+# define DPLL_P2_CLOCK_DIV_MASK			0x03000000 /* i915 */
+# define DPLL_FPA01_P1_POST_DIV_MASK		0x00ff0000 /* i915 */
+/**
+ *  The i830 generation, in DAC/serial mode, defines p1 as two plus this
+ * bitfield, or just 2 if PLL_P1_DIVIDE_BY_TWO is set.
+ */
+# define DPLL_FPA01_P1_POST_DIV_MASK_I830	0x001f0000
+/**
+ * The i830 generation, in LVDS mode, defines P1 as the bit number set within
+ * this field (only one bit may be set).
+ */
+# define DPLL_FPA01_P1_POST_DIV_MASK_I830_LVDS	0x003f0000
+# define DPLL_FPA01_P1_POST_DIV_SHIFT		16
+# define PLL_P2_DIVIDE_BY_4			(1 << 23) /* i830, required in DVO non-gang */
+# define PLL_P1_DIVIDE_BY_TWO			(1 << 21) /* i830 */
+# define PLL_REF_INPUT_DREFCLK			(0 << 13)
+# define PLL_REF_INPUT_TVCLKINA			(1 << 13) /* i830 */
+# define PLL_REF_INPUT_TVCLKINBC		(2 << 13) /* SDVO TVCLKIN */
+# define PLLB_REF_INPUT_SPREADSPECTRUMIN	(3 << 13)
+# define PLL_REF_INPUT_MASK			(3 << 13)
+# define PLL_LOAD_PULSE_PHASE_SHIFT		9
+/*
+ * Parallel to Serial Load Pulse phase selection.
+ * Selects the phase for the 10X DPLL clock for the PCIe
+ * digital display port. The range is 4 to 13; 10 or more
+ * is just a flip delay. The default is 6
+ */
+# define PLL_LOAD_PULSE_PHASE_MASK		(0xf << PLL_LOAD_PULSE_PHASE_SHIFT)
+# define DISPLAY_RATE_SELECT_FPA1		(1 << 8)
+
+/**
+ * SDVO multiplier for 945G/GM. Not used on 965.
+ *
+ * \sa DPLL_MD_UDI_MULTIPLIER_MASK
+ */
+# define SDVO_MULTIPLIER_MASK			0x000000ff
+# define SDVO_MULTIPLIER_SHIFT_HIRES		4
+# define SDVO_MULTIPLIER_SHIFT_VGA		0
+
+/** @defgroup DPLL_MD
+ * @{
+ */
+/** Pipe A SDVO/UDI clock multiplier/divider register for G965. */
+#define DPLL_A_MD		0x0601c
+/** Pipe B SDVO/UDI clock multiplier/divider register for G965. */
+#define DPLL_B_MD		0x06020
+/**
+ * UDI pixel divider, controlling how many pixels are stuffed into a packet.
+ *
+ * Value is pixels minus 1.  Must be set to 1 pixel for SDVO.
+ */
+# define DPLL_MD_UDI_DIVIDER_MASK		0x3f000000
+# define DPLL_MD_UDI_DIVIDER_SHIFT		24
+/** UDI pixel divider for VGA, same as DPLL_MD_UDI_DIVIDER_MASK. */
+# define DPLL_MD_VGA_UDI_DIVIDER_MASK		0x003f0000
+# define DPLL_MD_VGA_UDI_DIVIDER_SHIFT		16
+/**
+ * SDVO/UDI pixel multiplier.
+ *
+ * SDVO requires that the bus clock rate be between 1 and 2 Ghz, and the bus
+ * clock rate is 10 times the DPLL clock.  At low resolution/refresh rate
+ * modes, the bus rate would be below the limits, so SDVO allows for stuffing
+ * dummy bytes in the datastream at an increased clock rate, with both sides of
+ * the link knowing how many bytes are fill.
+ *
+ * So, for a mode with a dotclock of 65Mhz, we would want to double the clock
+ * rate to 130Mhz to get a bus rate of 1.30Ghz.  The DPLL clock rate would be
+ * set to 130Mhz, and the SDVO multiplier set to 2x in this register and
+ * through an SDVO command.
+ *
+ * This register field has values of multiplication factor minus 1, with
+ * a maximum multiplier of 5 for SDVO.
+ */
+# define DPLL_MD_UDI_MULTIPLIER_MASK		0x00003f00
+# define DPLL_MD_UDI_MULTIPLIER_SHIFT		8
+/** SDVO/UDI pixel multiplier for VGA, same as DPLL_MD_UDI_MULTIPLIER_MASK. 
+ * This best be set to the default value (3) or the CRT won't work. No,
+ * I don't entirely understand what this does...
+ */
+# define DPLL_MD_VGA_UDI_MULTIPLIER_MASK	0x0000003f
+# define DPLL_MD_VGA_UDI_MULTIPLIER_SHIFT	0
+/** @} */
+
+#define DPLL_TEST		0x606c
+# define DPLLB_TEST_SDVO_DIV_1			(0 << 22)
+# define DPLLB_TEST_SDVO_DIV_2			(1 << 22)
+# define DPLLB_TEST_SDVO_DIV_4			(2 << 22)
+# define DPLLB_TEST_SDVO_DIV_MASK		(3 << 22)
+# define DPLLB_TEST_N_BYPASS			(1 << 19)
+# define DPLLB_TEST_M_BYPASS			(1 << 18)
+# define DPLLB_INPUT_BUFFER_ENABLE		(1 << 16)
+# define DPLLA_TEST_N_BYPASS			(1 << 3)
+# define DPLLA_TEST_M_BYPASS			(1 << 2)
+# define DPLLA_INPUT_BUFFER_ENABLE		(1 << 0)
+
+#define ADPA			0x61100
+#define ADPA_DAC_ENABLE 	(1<<31)
+#define ADPA_DAC_DISABLE	0
+#define ADPA_PIPE_SELECT_MASK	(1<<30)
+#define ADPA_PIPE_A_SELECT	0
+#define ADPA_PIPE_B_SELECT	(1<<30)
+#define ADPA_USE_VGA_HVPOLARITY (1<<15)
+#define ADPA_SETS_HVPOLARITY	0
+#define ADPA_VSYNC_CNTL_DISABLE (1<<11)
+#define ADPA_VSYNC_CNTL_ENABLE	0
+#define ADPA_HSYNC_CNTL_DISABLE (1<<10)
+#define ADPA_HSYNC_CNTL_ENABLE	0
+#define ADPA_VSYNC_ACTIVE_HIGH	(1<<4)
+#define ADPA_VSYNC_ACTIVE_LOW	0
+#define ADPA_HSYNC_ACTIVE_HIGH	(1<<3)
+#define ADPA_HSYNC_ACTIVE_LOW	0
+
+#define FPA0		0x06040
+#define FPA1		0x06044
+#define FPB0		0x06048
+#define FPB1		0x0604c
+# define FP_N_DIV_MASK				0x003f0000
+# define FP_N_DIV_SHIFT				16
+# define FP_M1_DIV_MASK				0x00003f00
+# define FP_M1_DIV_SHIFT			8
+# define FP_M2_DIV_MASK				0x0000003f
+# define FP_M2_DIV_SHIFT			0
+
+
+#define PORT_HOTPLUG_EN		0x61110
+# define SDVOB_HOTPLUG_INT_EN			(1 << 26)
+# define SDVOC_HOTPLUG_INT_EN			(1 << 25)
+# define TV_HOTPLUG_INT_EN			(1 << 18)
+# define CRT_HOTPLUG_INT_EN			(1 << 9)
+# define CRT_HOTPLUG_FORCE_DETECT		(1 << 3)
+
+#define PORT_HOTPLUG_STAT	0x61114
+# define CRT_HOTPLUG_INT_STATUS			(1 << 11)
+# define TV_HOTPLUG_INT_STATUS			(1 << 10)
+# define CRT_HOTPLUG_MONITOR_MASK		(3 << 8)
+# define CRT_HOTPLUG_MONITOR_COLOR		(3 << 8)
+# define CRT_HOTPLUG_MONITOR_MONO		(2 << 8)
+# define CRT_HOTPLUG_MONITOR_NONE		(0 << 8)
+# define SDVOC_HOTPLUG_INT_STATUS		(1 << 7)
+# define SDVOB_HOTPLUG_INT_STATUS		(1 << 6)
+
+#define SDVOB			0x61140
+#define SDVOC			0x61160
+#define SDVO_ENABLE				(1 << 31)
+#define SDVO_PIPE_B_SELECT			(1 << 30)
+#define SDVO_STALL_SELECT			(1 << 29)
+#define SDVO_INTERRUPT_ENABLE			(1 << 26)
+/**
+ * 915G/GM SDVO pixel multiplier.
+ *
+ * Programmed value is multiplier - 1, up to 5x.
+ *
+ * \sa DPLL_MD_UDI_MULTIPLIER_MASK
+ */
+#define SDVO_PORT_MULTIPLY_MASK			(7 << 23)
+#define SDVO_PORT_MULTIPLY_SHIFT		23
+#define SDVO_PHASE_SELECT_MASK			(15 << 19)
+#define SDVO_PHASE_SELECT_DEFAULT		(6 << 19)
+#define SDVO_CLOCK_OUTPUT_INVERT		(1 << 18)
+#define SDVOC_GANG_MODE				(1 << 16)
+#define SDVO_BORDER_ENABLE			(1 << 7)
+#define SDVOB_PCIE_CONCURRENCY			(1 << 3)
+#define SDVO_DETECTED				(1 << 2)
+/* Bits to be preserved when writing */
+#define SDVOB_PRESERVE_MASK			((1 << 17) | (1 << 16) | (1 << 14))
+#define SDVOC_PRESERVE_MASK			(1 << 17)
+
+/** @defgroup LVDS
+ * @{
+ */
+/**
+ * This register controls the LVDS output enable, pipe selection, and data
+ * format selection.
+ *
+ * All of the clock/data pairs are force powered down by power sequencing.
+ */
+#define LVDS			0x61180
+/**
+ * Enables the LVDS port.  This bit must be set before DPLLs are enabled, as
+ * the DPLL semantics change when the LVDS is assigned to that pipe.
+ */
+# define LVDS_PORT_EN			(1 << 31)
+/** Selects pipe B for LVDS data.  Must be set on pre-965. */
+# define LVDS_PIPEB_SELECT		(1 << 30)
+
+/**
+ * Enables the A0-A2 data pairs and CLKA, containing 18 bits of color data per
+ * pixel.
+ */
+# define LVDS_A0A2_CLKA_POWER_MASK	(3 << 8)
+# define LVDS_A0A2_CLKA_POWER_DOWN	(0 << 8)
+# define LVDS_A0A2_CLKA_POWER_UP	(3 << 8)
+/**
+ * Controls the A3 data pair, which contains the additional LSBs for 24 bit
+ * mode.  Only enabled if LVDS_A0A2_CLKA_POWER_UP also indicates it should be
+ * on.
+ */
+# define LVDS_A3_POWER_MASK		(3 << 6)
+# define LVDS_A3_POWER_DOWN		(0 << 6)
+# define LVDS_A3_POWER_UP		(3 << 6)
+/**
+ * Controls the CLKB pair.  This should only be set when LVDS_B0B3_POWER_UP
+ * is set.
+ */
+# define LVDS_CLKB_POWER_MASK		(3 << 4)
+# define LVDS_CLKB_POWER_DOWN		(0 << 4)
+# define LVDS_CLKB_POWER_UP		(3 << 4)
+
+/**
+ * Controls the B0-B3 data pairs.  This must be set to match the DPLL p2
+ * setting for whether we are in dual-channel mode.  The B3 pair will
+ * additionally only be powered up when LVDS_A3_POWER_UP is set.
+ */
+# define LVDS_B0B3_POWER_MASK		(3 << 2)
+# define LVDS_B0B3_POWER_DOWN		(0 << 2)
+# define LVDS_B0B3_POWER_UP		(3 << 2)
+
+#define PIPEACONF 0x70008
+#define PIPEACONF_ENABLE	(1<<31)
+#define PIPEACONF_DISABLE	0
+#define PIPEACONF_DOUBLE_WIDE	(1<<30)
+#define I965_PIPECONF_ACTIVE	(1<<30)
+#define PIPEACONF_SINGLE_WIDE	0
+#define PIPEACONF_PIPE_UNLOCKED 0
+#define PIPEACONF_PIPE_LOCKED	(1<<25)
+#define PIPEACONF_PALETTE	0
+#define PIPEACONF_GAMMA 	(1<<24)
+#define PIPECONF_FORCE_BORDER	(1<<25)
+#define PIPECONF_PROGRESSIVE	(0 << 21)
+#define PIPECONF_INTERLACE_W_FIELD_INDICATION	(6 << 21)
+#define PIPECONF_INTERLACE_FIELD_0_ONLY		(7 << 21)
+
+#define PIPEBCONF 0x71008
+#define PIPEBCONF_ENABLE	(1<<31)
+#define PIPEBCONF_DISABLE	0
+#define PIPEBCONF_DOUBLE_WIDE	(1<<30)
+#define PIPEBCONF_DISABLE	0
+#define PIPEBCONF_GAMMA 	(1<<24)
+#define PIPEBCONF_PALETTE	0
+
+#define PIPEBGCMAXRED		0x71010
+#define PIPEBGCMAXGREEN		0x71014
+#define PIPEBGCMAXBLUE		0x71018
+#define PIPEBSTAT		0x71024
+#define PIPEBFRAMEHIGH		0x71040
+#define PIPEBFRAMEPIXEL		0x71044
+
+#define DSPACNTR		0x70180
+#define DSPBCNTR		0x71180
+#define DISPLAY_PLANE_ENABLE 			(1<<31)
+#define DISPLAY_PLANE_DISABLE			0
+#define DISPPLANE_GAMMA_ENABLE			(1<<30)
+#define DISPPLANE_GAMMA_DISABLE			0
+#define DISPPLANE_PIXFORMAT_MASK		(0xf<<26)
+#define DISPPLANE_8BPP				(0x2<<26)
+#define DISPPLANE_15_16BPP			(0x4<<26)
+#define DISPPLANE_16BPP				(0x5<<26)
+#define DISPPLANE_32BPP_NO_ALPHA 		(0x6<<26)
+#define DISPPLANE_32BPP				(0x7<<26)
+#define DISPPLANE_STEREO_ENABLE			(1<<25)
+#define DISPPLANE_STEREO_DISABLE		0
+#define DISPPLANE_SEL_PIPE_MASK			(1<<24)
+#define DISPPLANE_SEL_PIPE_A			0
+#define DISPPLANE_SEL_PIPE_B			(1<<24)
+#define DISPPLANE_SRC_KEY_ENABLE		(1<<22)
+#define DISPPLANE_SRC_KEY_DISABLE		0
+#define DISPPLANE_LINE_DOUBLE			(1<<20)
+#define DISPPLANE_NO_LINE_DOUBLE		0
+#define DISPPLANE_STEREO_POLARITY_FIRST		0
+#define DISPPLANE_STEREO_POLARITY_SECOND	(1<<18)
+/* plane B only */
+#define DISPPLANE_ALPHA_TRANS_ENABLE		(1<<15)
+#define DISPPLANE_ALPHA_TRANS_DISABLE		0
+#define DISPPLANE_SPRITE_ABOVE_DISPLAYA		0
+#define DISPPLANE_SPRITE_ABOVE_OVERLAY		(1)
+
+#define DSPABASE		0x70184
+#define DSPASTRIDE		0x70188
+
+#define DSPBBASE		0x71184
+#define DSPBADDR		DSPBBASE
+#define DSPBSTRIDE		0x71188
+
+#define DSPAKEYVAL		0x70194
+#define DSPAKEYMASK		0x70198
+
+#define DSPAPOS			0x7018C /* reserved */
+#define DSPASIZE		0x70190
+#define DSPBPOS			0x7118C
+#define DSPBSIZE		0x71190
+
+#define DSPASURF		0x7019C
+#define DSPATILEOFF		0x701A4
+
+#define DSPBSURF		0x7119C
+#define DSPBTILEOFF		0x711A4
+
+#define VGACNTRL		0x71400
+# define VGA_DISP_DISABLE			(1 << 31)
+# define VGA_2X_MODE				(1 << 30)
+# define VGA_PIPE_B_SELECT			(1 << 29)
+
+/*
+ * Some BIOS scratch area registers.  The 845 (and 830?) store the amount
+ * of video memory available to the BIOS in SWF1.
+ */
+
+#define SWF0			0x71410
+
+/*
+ * 855 scratch registers.
+ */
+#define SWF10			0x70410
+
+#define SWF30			0x72414
+
+/*
+ * Overlay registers.  These are overlay registers accessed via MMIO.
+ * Those loaded via the overlay register page are defined in i830_video.c.
+ */
+#define OVADD			0x30000
+
+#define DOVSTA			0x30008
+#define OC_BUF			(0x3<<20)
+
+#define OGAMC5			0x30010
+#define OGAMC4			0x30014
+#define OGAMC3			0x30018
+#define OGAMC2			0x3001c
+#define OGAMC1			0x30020
+#define OGAMC0			0x30024
+/*
+ * Palette registers
+ */
+#define PALETTE_A		0x0a000
+#define PALETTE_B		0x0a800
+
+#define IS_I830(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82830_CGC)
+#define IS_845G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82845G_IG)
+#define IS_I85X(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82855GM_IG)
+#define IS_I855(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82855GM_IG)
+#define IS_I865G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82865_IG)
+
+#define IS_I915G(dev) (dev->pci_device == PCI_DEVICE_ID_INTEL_82915G_IG)/* || dev->pci_device == PCI_DEVICE_ID_INTELPCI_CHIP_E7221_G)*/
+#define IS_I915GM(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82915GM_IG)
+#define IS_I945G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82945G_IG)
+#define IS_I945GM(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82945GM_IG)
+
+#define IS_I965G(dev) ((dev)->pci_device == 0x2972 || \
+		       (dev)->pci_device == 0x2982 || \
+		       (dev)->pci_device == 0x2992 || \
+		       (dev)->pci_device == 0x29A2 || \
+		       (dev)->pci_device == 0x2A02 || \
+		       (dev)->pci_device == 0x2A12)
+
+#define IS_I965GM(dev) ((dev)->pci_device == 0x2A02)
+
+#define IS_G33(dev)    ((dev)->pci_device == 0x29C2 ||	\
+		   	(dev)->pci_device == 0x29B2 ||	\
+			(dev)->pci_device == 0x29D2)
+
+#define IS_I9XX(dev) (IS_I915G(dev) || IS_I915GM(dev) || IS_I945G(dev) || \
+		      IS_I945GM(dev) || IS_I965G(dev))
+
+#define IS_MOBILE(dev) (IS_I830(dev) || IS_I85X(dev) || IS_I915GM(dev) || \
+			IS_I945GM(dev) || IS_I965GM(dev))
+
+#define PRIMARY_RINGBUFFER_SIZE         (128*1024)
+
 #endif

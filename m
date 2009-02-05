Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbZBEBIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbZBEBIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZBEBHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:07:11 -0500
Received: from ozlabs.org ([203.10.76.45]:48045 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbZBEBHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:07:09 -0500
To: fbdev list <linux-fbdev-devel@lists.sourceforge.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 05 Feb 2009 12:06:52 +1100
Subject: [PATCH 3/3] radeonfb: Fix resume from D3Cold on some platforms
Message-Id: <20090205010708.7FC8FDDEED@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For historical reason, this driver used its own saving/restoring
of the PCI config space, and used the state of it on resume as
an indication as to whether it needed to re-POST the chip or not.

This methods breaks with the later core changes since the core will
have restored things for us.

This patch fixes it by removing that custom code, using standard
core methods to save/restore state, and testing for the need to
re-POST by comparing the content of a few key PLL registers.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This needs testing on the older latpops model that do D2 state !

I have one of these at home, so I'll let you know tonight or tomorrow
whether that's ok. Might be worth getting it tested on some of the
thinkpad models that are using that code too.

 drivers/video/aty/radeon_pm.c |   85 +++++++++---------------------------------
 drivers/video/aty/radeonfb.h  |    2 
 2 files changed, 20 insertions(+), 67 deletions(-)

--- linux-work.orig/drivers/video/aty/radeon_pm.c	2009-02-04 13:35:46.000000000 +1100
+++ linux-work/drivers/video/aty/radeon_pm.c	2009-02-04 13:36:58.000000000 +1100
@@ -2509,9 +2509,7 @@ static void radeon_reinitialize_QW(struc
 
 static void radeon_set_suspend(struct radeonfb_info *rinfo, int suspend)
 {
-	u16 pwr_cmd;
 	u32 tmp;
-	int i;
 
 	if (!rinfo->pm_reg)
 		return;
@@ -2557,32 +2555,14 @@ static void radeon_set_suspend(struct ra
 			}
 		}
 
-		for (i = 0; i < 64; ++i)
-			pci_read_config_dword(rinfo->pdev, i * 4,
-					      &rinfo->cfg_save[i]);
-
 		/* Switch PCI power management to D2. */
 		pci_disable_device(rinfo->pdev);
-		for (;;) {
-			pci_read_config_word(
-				rinfo->pdev, rinfo->pm_reg+PCI_PM_CTRL,
-				&pwr_cmd);
-			if (pwr_cmd & 2)
-				break;			
-			pci_write_config_word(
-				rinfo->pdev, rinfo->pm_reg+PCI_PM_CTRL,
-				(pwr_cmd & ~PCI_PM_CTRL_STATE_MASK) | 2);
-			mdelay(500);
-		}
+		pci_save_state(rinfo->pdev);
+		pci_set_power_state(rinfo->pdev, PCI_D2);
 	} else {
 		printk(KERN_DEBUG "radeonfb (%s): switching to D0 state...\n",
 		       pci_name(rinfo->pdev));
 
-		/* Switch back PCI powermanagment to D0 */
-		mdelay(200);
-		pci_write_config_word(rinfo->pdev, rinfo->pm_reg+PCI_PM_CTRL, 0);
-		mdelay(500);
-
 		if (rinfo->family <= CHIP_FAMILY_RV250) {
 			/* Reset the SDRAM controller  */
 			radeon_pm_full_reset_sdram(rinfo);
@@ -2598,37 +2578,10 @@ static void radeon_set_suspend(struct ra
 	}
 }
 
-static int radeon_restore_pci_cfg(struct radeonfb_info *rinfo)
-{
-	int i;
-	static u32 radeon_cfg_after_resume[64];
-
-	for (i = 0; i < 64; ++i)
-		pci_read_config_dword(rinfo->pdev, i * 4,
-				      &radeon_cfg_after_resume[i]);
-
-	if (radeon_cfg_after_resume[PCI_BASE_ADDRESS_0/4]
-	    == rinfo->cfg_save[PCI_BASE_ADDRESS_0/4])
-		return 0;	/* assume everything is ok */
-
-	for (i = PCI_BASE_ADDRESS_0/4; i < 64; ++i) {
-		if (radeon_cfg_after_resume[i] != rinfo->cfg_save[i])
-			pci_write_config_dword(rinfo->pdev, i * 4,
-					       rinfo->cfg_save[i]);
-	}
-	pci_write_config_word(rinfo->pdev, PCI_CACHE_LINE_SIZE,
-			      rinfo->cfg_save[PCI_CACHE_LINE_SIZE/4]);
-	pci_write_config_word(rinfo->pdev, PCI_COMMAND,
-			      rinfo->cfg_save[PCI_COMMAND/4]);
-	return 1;
-}
-
-
 int radeonfb_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
         struct fb_info *info = pci_get_drvdata(pdev);
         struct radeonfb_info *rinfo = info->par;
-	int i;
 
 	if (mesg.event == pdev->dev.power.power_state.event)
 		return 0;
@@ -2674,6 +2627,11 @@ int radeonfb_pci_suspend(struct pci_dev 
 	pmac_suspend_agp_for_card(pdev);
 #endif /* CONFIG_PPC_PMAC */
 
+	/* It's unclear whether or when the generic code will do that, so let's
+	 * do it ourselves. We save state before we do any power management
+	 */
+	pci_save_state(pdev);
+
 	/* If we support wakeup from poweroff, we save all regs we can including cfg
 	 * space
 	 */
@@ -2698,9 +2656,6 @@ int radeonfb_pci_suspend(struct pci_dev 
 			mdelay(20);
 			OUTREG(LVDS_GEN_CNTL, INREG(LVDS_GEN_CNTL) & ~(LVDS_DIGON));
 		}
-		// FIXME: Use PCI layer
-		for (i = 0; i < 64; ++i)
-			pci_read_config_dword(pdev, i * 4, &rinfo->cfg_save[i]);
 		pci_disable_device(pdev);
 	}
 	/* If we support D2, we go to it (should be fixed later with a flag forcing
@@ -2717,6 +2672,13 @@ int radeonfb_pci_suspend(struct pci_dev 
 	return 0;
 }
 
+static int radeon_check_power_loss(struct radeonfb_info *rinfo)
+{
+	return rinfo->save_regs[4] != INPLL(CLK_PIN_CNTL) ||
+	       rinfo->save_regs[2] != INPLL(MCLK_CNTL) ||
+	       rinfo->save_regs[3] != INPLL(SCLK_CNTL);
+}
+
 int radeonfb_pci_resume(struct pci_dev *pdev)
 {
         struct fb_info *info = pci_get_drvdata(pdev);
@@ -2735,20 +2697,13 @@ int radeonfb_pci_resume(struct pci_dev *
 	printk(KERN_DEBUG "radeonfb (%s): resuming from state: %d...\n",
 	       pci_name(pdev), pdev->dev.power.power_state.event);
 
-
-	if (pci_enable_device(pdev)) {
-		rc = -ENODEV;
-		printk(KERN_ERR "radeonfb (%s): can't enable PCI device !\n",
-		       pci_name(pdev));
-		goto bail;
-	}
-	pci_set_master(pdev);
-
+	/* PCI state will have been restored by the core, so
+	 * we should be in D0 now with our config space fully
+	 * restored
+	 */
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		/* Wakeup chip. Check from config space if we were powered off
-		 * (todo: additionally, check CLK_PIN_CNTL too)
-		 */
-		if ((rinfo->pm_mode & radeon_pm_off) && radeon_restore_pci_cfg(rinfo)) {
+		/* Wakeup chip */
+		if ((rinfo->pm_mode & radeon_pm_off) && radeon_check_power_loss(rinfo)) {
 			if (rinfo->reinit_func != NULL)
 				rinfo->reinit_func(rinfo);
 			else {
Index: linux-work/drivers/video/aty/radeonfb.h
===================================================================
--- linux-work.orig/drivers/video/aty/radeonfb.h	2009-02-04 13:35:46.000000000 +1100
+++ linux-work/drivers/video/aty/radeonfb.h	2009-02-04 13:36:06.000000000 +1100
@@ -361,8 +361,6 @@ struct radeonfb_info {
 #ifdef CONFIG_FB_RADEON_I2C
 	struct radeon_i2c_chan 	i2c[4];
 #endif
-
-	u32			cfg_save[64];
 };
 
 

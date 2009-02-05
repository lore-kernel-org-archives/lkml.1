Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZBEBHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZBEBHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbZBEBHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:07:10 -0500
Received: from ozlabs.org ([203.10.76.45]:48040 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbZBEBHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:07:08 -0500
To: fbdev list <linux-fbdev-devel@lists.sourceforge.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 05 Feb 2009 12:06:51 +1100
Subject: [PATCH 2/3] aty128fb: Properly save PCI state before changing PCI PM level
Message-Id: <20090205010707.A2EC8DDEEA@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes aty128fb to properly save the PCI config space -before- it
potentially switches the PM state of the chip. This avoids a
warning with the new PM core and is the right thing to do anyway.

I also replaced the hand-coded switch to D2 with a call to the
genericc pci_set_power_state() and removed the code that switches it
back to D0 since the generic code is doing that for us nowadays.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/video/aty/aty128fb.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- linux-work.orig/drivers/video/aty/aty128fb.c	2009-02-04 13:19:54.000000000 +1100
+++ linux-work/drivers/video/aty/aty128fb.c	2009-02-04 13:28:12.000000000 +1100
@@ -2374,6 +2374,8 @@ static void aty128_set_suspend(struct at
 	/* Set the chip into the appropriate suspend mode (we use D2,
 	 * D3 would require a complete re-initialisation of the chip,
 	 * including PCI config registers, clocks, AGP configuration, ...)
+	 *
+	 * For resume, the core will have already brought us back to D0
 	 */
 	if (suspend) {
 		/* Make sure CRTC2 is reset. Remove that the day we decide to
@@ -2391,17 +2393,9 @@ static void aty128_set_suspend(struct at
 		aty_st_le32(BUS_CNTL1, 0x00000010);
 		aty_st_le32(MEM_POWER_MISC, 0x0c830000);
 		mdelay(100);
-		pci_read_config_word(pdev, par->pm_reg+PCI_PM_CTRL, &pwr_command);
+
 		/* Switch PCI power management to D2 */
-		pci_write_config_word(pdev, par->pm_reg+PCI_PM_CTRL,
-			(pwr_command & ~PCI_PM_CTRL_STATE_MASK) | 2);
-		pci_read_config_word(pdev, par->pm_reg+PCI_PM_CTRL, &pwr_command);
-	} else {
-		/* Switch back PCI power management to D0 */
-		mdelay(100);
-		pci_write_config_word(pdev, par->pm_reg+PCI_PM_CTRL, 0);
-		pci_read_config_word(pdev, par->pm_reg+PCI_PM_CTRL, &pwr_command);
-		mdelay(100);
+		pci_set_power_state(pdev, PCI_D2);
 	}
 }
 
@@ -2410,6 +2404,12 @@ static int aty128_pci_suspend(struct pci
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct aty128fb_par *par = info->par;
 
+	/* Because we may change PCI D state ourselves, we need to
+	 * first save the config space content so the core can
+	 * restore it properly on resume.
+	 */
+	pci_save_state(pdev);
+
 	/* We don't do anything but D2, for now we return 0, but
 	 * we may want to change that. How do we know if the BIOS
 	 * can properly take care of D3 ? Also, with swsusp, we
@@ -2476,6 +2476,11 @@ static int aty128_do_resume(struct pci_d
 	if (pdev->dev.power.power_state.event == PM_EVENT_ON)
 		return 0;
 
+	/* PCI state will have been restored by the core, so
+	 * we should be in D0 now with our config space fully
+	 * restored
+	 */
+
 	/* Wakeup chip */
 	aty128_set_suspend(par, 0);
 	par->asleep = 0;

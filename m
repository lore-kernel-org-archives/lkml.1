Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbZBEBHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbZBEBHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZBEBHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:07:08 -0500
Received: from ozlabs.org ([203.10.76.45]:48036 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbZBEBHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:07:07 -0500
To: fbdev list <linux-fbdev-devel@lists.sourceforge.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 05 Feb 2009 12:06:50 +1100
Subject: [PATCH 1/3] atyfb: Properly save PCI state before changing PCI PM level
Message-Id: <20090205010706.888F4DDEE2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes atyfb to properly save the PCI config space -before- it
potentially switches the PM state of the chip. This avoids a
warning with the new PM core and is the right thing to do anyway.

I also slightly cleaned up the code that checks whether we are
running on a PowerMac to do a runtime check instead of a compile
check only, and replaced a deprecated number with the proper
symbolic constant.

Finally, I removed the useless switch to D0 from resume since
the core does it for us.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/video/aty/atyfb_base.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- linux-work.orig/drivers/video/aty/atyfb_base.c	2009-02-04 13:10:22.000000000 +1100
+++ linux-work/drivers/video/aty/atyfb_base.c	2009-02-04 13:13:11.000000000 +1100
@@ -1978,7 +1978,7 @@ static int aty_power_mgmt(int sleep, str
 
 	return timeout ? 0 : -EIO;
 }
-#endif
+#endif /* CONFIG_PPC_PMAC */
 
 static int atyfb_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
@@ -2002,9 +2002,15 @@ static int atyfb_pci_suspend(struct pci_
 	par->asleep = 1;
 	par->lock_blank = 1;
 
+	/* Because we may change PCI D state ourselves, we need to
+	 * first save the config space content so the core can
+	 * restore it properly on resume.
+	 */
+	pci_save_state(pdev);
+
 #ifdef CONFIG_PPC_PMAC
 	/* Set chip to "suspend" mode */
-	if (aty_power_mgmt(1, par)) {
+	if (machine_is(powermac) && aty_power_mgmt(1, par)) {
 		par->asleep = 0;
 		par->lock_blank = 0;
 		atyfb_blank(FB_BLANK_UNBLANK, info);
@@ -2047,11 +2053,15 @@ static int atyfb_pci_resume(struct pci_d
 
 	acquire_console_sem();
 
+	/* PCI state will have been restored by the core, so
+	 * we should be in D0 now with our config space fully
+	 * restored
+	 */
+
 #ifdef CONFIG_PPC_PMAC
-	if (pdev->dev.power.power_state.event == 2)
+	if (machine_is(powermac) &&
+	    pdev->dev.power.power_state.event == PM_EVENT_SUSPEND)
 		aty_power_mgmt(0, par);
-#else
-	pci_set_power_state(pdev, PCI_D0);
 #endif
 
 	aty_resume_chip(info);

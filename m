Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbXA2Teg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbXA2Teg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXA2Teg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:34:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52694 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXA2Teg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:34:36 -0500
Date: Mon, 29 Jan 2007 11:31:59 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070129113159.7ad22e4c@freekitty>
In-Reply-To: <1169931333.17469.125.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<1169931333.17469.125.camel@localhost.localdomain>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does this fix it?
---
 drivers/net/sky2.c |   43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

--- sky2-2.6.orig/drivers/net/sky2.c	2007-01-29 10:05:12.000000000 -0800
+++ sky2-2.6/drivers/net/sky2.c	2007-01-29 10:29:56.000000000 -0800
@@ -3675,6 +3675,12 @@
 	sky2_write32(hw, B0_IMSK, 0);
 	sky2_power_aux(hw);
 
+	/* Turn off IRQ to avoid power management bug (see resume) */
+	if (hw->msi) {
+		free_irq(pdev->irq, hw);
+		pci_disable_msi(pdev);
+	}
+
 	pci_save_state(pdev);
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), wol);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
@@ -3700,6 +3706,18 @@
 
 	sky2_write32(hw, B0_IMSK, Y2_IS_BASE);
 
+	/* Can't re-enable MSI because kernel resume ordering is broken
+	 * and calls device resume before ACPI (BIOS) is called.
+	 * BIOS then resets device to INTx!
+	 */
+	if (hw->msi) {
+		err = request_irq(pdev->irq, sky2_intr, IRQF_SHARED,
+				  hw->dev[0]->name, hw);
+		if (err)
+			goto out;
+		hw->msi = 0;
+	}
+
 	for (i = 0; i < hw->ports; i++) {
 		struct net_device *dev = hw->dev[i];
 		if (netif_running(dev)) {
@@ -3721,29 +3739,6 @@
 	pci_disable_device(pdev);
 	return err;
 }
-
-/* BIOS resume runs after device (it's a bug in PM)
- * as a temporary workaround on suspend/resume leave MSI disabled
- */
-static int sky2_suspend_late(struct pci_dev *pdev, pm_message_t state)
-{
-	struct sky2_hw *hw = pci_get_drvdata(pdev);
-
-	free_irq(pdev->irq, hw);
-	if (hw->msi) {
-		pci_disable_msi(pdev);
-		hw->msi = 0;
-	}
-	return 0;
-}
-
-static int sky2_resume_early(struct pci_dev *pdev)
-{
-	struct sky2_hw *hw = pci_get_drvdata(pdev);
-	struct net_device *dev = hw->dev[0];
-
-	return request_irq(pdev->irq, sky2_intr, IRQF_SHARED, dev->name, hw);
-}
 #endif
 
 static void sky2_shutdown(struct pci_dev *pdev)
@@ -3783,8 +3778,6 @@
 #ifdef CONFIG_PM
 	.suspend = sky2_suspend,
 	.resume = sky2_resume,
-	.suspend_late = sky2_suspend_late,
-	.resume_early = sky2_resume_early,
 #endif
 	.shutdown = sky2_shutdown,
 };

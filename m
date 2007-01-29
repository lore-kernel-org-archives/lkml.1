Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbXA2Vle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbXA2Vle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXA2Vle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:41:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58156 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXA2Vld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:41:33 -0500
Date: Mon, 29 Jan 2007 13:38:49 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070129133849.1b523226@freekitty>
In-Reply-To: <1170101430.29240.34.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<1169931333.17469.125.camel@localhost.localdomain>
	<20070129113159.7ad22e4c@freekitty>
	<1170101430.29240.34.camel@localhost.localdomain>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 21:10:30 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 2007-01-29 at 11:31 -0800, Stephen Hemminger wrote:
> > Does this fix it?
> 
> Don't know.

Sorry it was against the last patch I sent to Jeff for netdev.
Here is against 2.6.20-rc6

---
 drivers/net/sky2.c |   43 ++++++++++++++++++-------------------------
 1 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index a2e804d..d85de63 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -3598,6 +3598,12 @@ static int sky2_suspend(struct pci_dev *
 		}
 	}
 
+	/* Turn off IRQ to avoid power management bug (see resume) */
+	if (hw->msi) {
+		free_irq(pdev->irq, hw);
+		pci_disable_msi(pdev);
+	}
+
 	sky2_write32(hw, B0_IMSK, 0);
 	pci_save_state(pdev);
 	sky2_set_power_state(hw, pstate);
@@ -3619,6 +3625,18 @@ static int sky2_resume(struct pci_dev *p
 
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
@@ -3639,29 +3657,6 @@ static int sky2_resume(struct pci_dev *p
 out:
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
 
 static struct pci_driver sky2_driver = {
@@ -3672,8 +3667,6 @@ static struct pci_driver sky2_driver = {
 #ifdef CONFIG_PM
 	.suspend = sky2_suspend,
 	.resume = sky2_resume,
-	.suspend_late = sky2_suspend_late,
-	.resume_early = sky2_resume_early,
 #endif
 };
 
-- 
1.4.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbXA2XmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbXA2XmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXA2XmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:42:14 -0500
Received: from www.osadl.org ([213.239.205.134]:34999 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964928AbXA2XmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:42:13 -0500
Subject: [PATCH] sky2: fix MSI related resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 00:42:55 +0100
Message-Id: <1170114175.29240.86.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commmit 44ade178249fe53d055fd92113eaa271e06acddd breaks sane
MSI/ACPI/BIOS combinations. It's impossible to keep broken and sane
MSI/ACPI/BIOSes happy at the same time.

Revert the patch and disable MSI for sky2 when CONFIG_PM is enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index a2e804d..420fef7 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -91,7 +91,11 @@ static int copybreak __read_mostly = 128;
 module_param(copybreak, int, 0);
 MODULE_PARM_DESC(copybreak, "Receive copy threshold");
 
+#ifdef CONFIG_PM
+static int disable_msi = 1;
+#else
 static int disable_msi = 0;
+#endif
 module_param(disable_msi, int, 0);
 MODULE_PARM_DESC(disable_msi, "Disable Message Signaled Interrupt (MSI)");
 
@@ -3601,6 +3605,7 @@ static int sky2_suspend(struct pci_dev *pdev, pm_message_t state)
 	sky2_write32(hw, B0_IMSK, 0);
 	pci_save_state(pdev);
 	sky2_set_power_state(hw, pstate);
+
 	return 0;
 }
 
@@ -3640,28 +3645,6 @@ out:
 	return err;
 }
 
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
@@ -3672,8 +3655,6 @@ static struct pci_driver sky2_driver = {
 #ifdef CONFIG_PM
 	.suspend = sky2_suspend,
 	.resume = sky2_resume,
-	.suspend_late = sky2_suspend_late,
-	.resume_early = sky2_resume_early,
 #endif
 };
 



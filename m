Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZAMLdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZAMLdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZAMLdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:33:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZAMLc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:32:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Date: Tue, 13 Jan 2009 12:32:17 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Daniel Drake" <dsd@gentoo.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>, Alan Stern <stern@rowland.harvard.edu>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <b6a2187b0901122028w3f85fc9aj41d7c8ac44adb2ed@mail.gmail.com> <b6a2187b0901122147o45890cd4lfb6ba7b2908e6ae7@mail.gmail.com>
In-Reply-To: <b6a2187b0901122147o45890cd4lfb6ba7b2908e6ae7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131232.17941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Jeff Chua wrote:
> On Sun, Jan 11, 2009 at 7:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12422
> > Subject         : 2.6.28-git can't resume from str
> > Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> > Date            : 2009-01-10 1:39 (2 days old)
> > References      : http://marc.info/?l=linux-kernel&m=123155157909282&w=4
> 
> Fixed by reverting a0d4922da2e4ccb0973095d8d29f36f6b1b5f703.
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d has already been reverted in
> the Linus's latest git tree.

Can you please check if the issue goes away when you apply the appended patch
instead of reverting commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 ?

Rafael

---
 drivers/usb/core/hcd-pci.c  |  116 ++++++++++----------------------------------
 drivers/usb/core/hcd.h      |    1 
 drivers/usb/host/ehci-pci.c |    1 
 drivers/usb/host/ohci-pci.c |    1 
 drivers/usb/host/uhci-hcd.c |    1 
 5 files changed, 27 insertions(+), 93 deletions(-)

Index: linux-2.6/drivers/usb/core/hcd-pci.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hcd-pci.c
+++ linux-2.6/drivers/usb/core/hcd-pci.c
@@ -201,6 +201,7 @@ int usb_hcd_pci_suspend(struct pci_dev *
 	struct usb_hcd		*hcd = pci_get_drvdata(dev);
 	int			retval = 0;
 	int			wake, w;
+	int			has_pci_pm;
 
 	/* Root hub suspend should have stopped all downstream traffic,
 	 * and all bus master traffic.  And done so for both the interface
@@ -230,6 +231,15 @@ int usb_hcd_pci_suspend(struct pci_dev *
 
 	synchronize_irq(dev->irq);
 
+	/* Downstream ports from this root hub should already be quiesced, so
+	 * there will be no DMA activity.  Now we can shut down the upstream
+	 * link (except maybe for PME# resume signaling) and enter some PCI
+	 * low power state, if the hardware allows.
+	 */
+	pci_disable_device(dev);
+
+	pci_save_state(dev);
+
 	/* Don't fail on error to enable wakeup.  We rely on pci code
 	 * to reject requests the hardware can't implement, rather
 	 * than coding the same thing.
@@ -241,35 +251,6 @@ int usb_hcd_pci_suspend(struct pci_dev *
 		wake = w;
 	dev_dbg(&dev->dev, "wakeup: %d\n", wake);
 
-	/* Downstream ports from this root hub should already be quiesced, so
-	 * there will be no DMA activity.  Now we can shut down the upstream
-	 * link (except maybe for PME# resume signaling) and enter some PCI
-	 * low power state, if the hardware allows.
-	 */
-	pci_disable_device(dev);
- done:
-	return retval;
-}
-EXPORT_SYMBOL_GPL(usb_hcd_pci_suspend);
-
-/**
- * usb_hcd_pci_suspend_late - suspend a PCI-based HCD after IRQs are disabled
- * @dev: USB Host Controller being suspended
- * @message: Power Management message describing this state transition
- *
- * Store this function in the HCD's struct pci_driver as .suspend_late.
- */
-int usb_hcd_pci_suspend_late(struct pci_dev *dev, pm_message_t message)
-{
-	int			retval = 0;
-	int			has_pci_pm;
-
-	/* We might already be suspended (runtime PM -- not yet written) */
-	if (dev->current_state != PCI_D0)
-		goto done;
-
-	pci_save_state(dev);
-
 	/* Don't change state if we don't need to */
 	if (message.event == PM_EVENT_FREEZE ||
 			message.event == PM_EVENT_PRETHAW) {
@@ -315,7 +296,7 @@ int usb_hcd_pci_suspend_late(struct pci_
  done:
 	return retval;
 }
-EXPORT_SYMBOL_GPL(usb_hcd_pci_suspend_late);
+EXPORT_SYMBOL_GPL(usb_hcd_pci_suspend);
 
 /**
  * usb_hcd_pci_resume_early - resume a PCI-based HCD before IRQs are enabled
@@ -325,65 +306,8 @@ EXPORT_SYMBOL_GPL(usb_hcd_pci_suspend_la
  */
 int usb_hcd_pci_resume_early(struct pci_dev *dev)
 {
-	int		retval = 0;
-	pci_power_t	state = dev->current_state;
-
-#ifdef CONFIG_PPC_PMAC
-	/* Reenable ASIC clocks for USB */
-	if (machine_is(powermac)) {
-		struct device_node *of_node;
-
-		of_node = pci_device_to_OF_node(dev);
-		if (of_node)
-			pmac_call_feature(PMAC_FTR_USB_ENABLE,
-						of_node, 0, 1);
-	}
-#endif
-
-	/* NOTE:  chip docs cover clean "real suspend" cases (what Linux
-	 * calls "standby", "suspend to RAM", and so on).  There are also
-	 * dirty cases when swsusp fakes a suspend in "shutdown" mode.
-	 */
-	if (state != PCI_D0) {
-#ifdef	DEBUG
-		int	pci_pm;
-		u16	pmcr;
-
-		pci_pm = pci_find_capability(dev, PCI_CAP_ID_PM);
-		pci_read_config_word(dev, pci_pm + PCI_PM_CTRL, &pmcr);
-		pmcr &= PCI_PM_CTRL_STATE_MASK;
-		if (pmcr) {
-			/* Clean case:  power to USB and to HC registers was
-			 * maintained; remote wakeup is easy.
-			 */
-			dev_dbg(&dev->dev, "resume from PCI D%d\n", pmcr);
-		} else {
-			/* Clean:  HC lost Vcc power, D0 uninitialized
-			 *   + Vaux may have preserved port and transceiver
-			 *     state ... for remote wakeup from D3cold
-			 *   + or not; HCD must reinit + re-enumerate
-			 *
-			 * Dirty: D0 semi-initialized cases with swsusp
-			 *   + after BIOS init
-			 *   + after Linux init (HCD statically linked)
-			 */
-			dev_dbg(&dev->dev, "resume from previous PCI D%d\n",
-					state);
-		}
-#endif
-
-		retval = pci_set_power_state(dev, PCI_D0);
-	} else {
-		/* Same basic cases: clean (powered/not), dirty */
-		dev_dbg(&dev->dev, "PCI legacy resume\n");
-	}
-
-	if (retval < 0)
-		dev_err(&dev->dev, "can't resume: %d\n", retval);
-	else
-		pci_restore_state(dev);
-
-	return retval;
+	pci_restore_state(dev);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(usb_hcd_pci_resume_early);
 
@@ -398,6 +322,18 @@ int usb_hcd_pci_resume(struct pci_dev *d
 	struct usb_hcd		*hcd;
 	int			retval;
 
+#ifdef CONFIG_PPC_PMAC
+	/* Reenable ASIC clocks for USB */
+	if (machine_is(powermac)) {
+		struct device_node *of_node;
+
+		of_node = pci_device_to_OF_node(dev);
+		if (of_node)
+			pmac_call_feature(PMAC_FTR_USB_ENABLE,
+						of_node, 0, 1);
+	}
+#endif
+
 	hcd = pci_get_drvdata(dev);
 	if (hcd->state != HC_STATE_SUSPENDED) {
 		dev_dbg(hcd->self.controller,
@@ -405,6 +341,8 @@ int usb_hcd_pci_resume(struct pci_dev *d
 		return 0;
 	}
 
+	pci_enable_wake(dev, PCI_D0, false);
+
 	retval = pci_enable_device(dev);
 	if (retval < 0) {
 		dev_err(&dev->dev, "can't re-enable after resume, %d!\n",
Index: linux-2.6/drivers/usb/core/hcd.h
===================================================================
--- linux-2.6.orig/drivers/usb/core/hcd.h
+++ linux-2.6/drivers/usb/core/hcd.h
@@ -257,7 +257,6 @@ extern void usb_hcd_pci_remove(struct pc
 
 #ifdef CONFIG_PM
 extern int usb_hcd_pci_suspend(struct pci_dev *dev, pm_message_t msg);
-extern int usb_hcd_pci_suspend_late(struct pci_dev *dev, pm_message_t msg);
 extern int usb_hcd_pci_resume_early(struct pci_dev *dev);
 extern int usb_hcd_pci_resume(struct pci_dev *dev);
 #endif /* CONFIG_PM */
Index: linux-2.6/drivers/usb/host/ehci-pci.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci-pci.c
+++ linux-2.6/drivers/usb/host/ehci-pci.c
@@ -432,7 +432,6 @@ static struct pci_driver ehci_pci_driver
 
 #ifdef	CONFIG_PM
 	.suspend =	usb_hcd_pci_suspend,
-	.suspend_late =	usb_hcd_pci_suspend_late,
 	.resume_early =	usb_hcd_pci_resume_early,
 	.resume =	usb_hcd_pci_resume,
 #endif
Index: linux-2.6/drivers/usb/host/ohci-pci.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-pci.c
+++ linux-2.6/drivers/usb/host/ohci-pci.c
@@ -487,7 +487,6 @@ static struct pci_driver ohci_pci_driver
 
 #ifdef	CONFIG_PM
 	.suspend =	usb_hcd_pci_suspend,
-	.suspend_late =	usb_hcd_pci_suspend_late,
 	.resume_early =	usb_hcd_pci_resume_early,
 	.resume =	usb_hcd_pci_resume,
 #endif
Index: linux-2.6/drivers/usb/host/uhci-hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/uhci-hcd.c
+++ linux-2.6/drivers/usb/host/uhci-hcd.c
@@ -942,7 +942,6 @@ static struct pci_driver uhci_pci_driver
 
 #ifdef	CONFIG_PM
 	.suspend =	usb_hcd_pci_suspend,
-	.suspend_late =	usb_hcd_pci_suspend_late,
 	.resume_early =	usb_hcd_pci_resume_early,
 	.resume =	usb_hcd_pci_resume,
 #endif	/* PM */


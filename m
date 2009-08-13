Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbZHMAfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbZHMAfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 20:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZHMAfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 20:35:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35716 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZHMAfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 20:35:46 -0400
Date: Thu, 13 Aug 2009 01:35:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [RFC] usb: Add support for runtime power management of the hcd
Message-ID: <20090813003544.GB2532@srcf.ucam.org>
References: <200908081625.57333.rjw@sisk.pl> <200908092313.05541.rjw@sisk.pl> <20090813002925.GA2532@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813002925.GA2532@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI runtime power management code means that we can implement support
for powering down PCI host controllers. This patchset adds core support code
along with a new hcd flag (HCD_RUNTIME_PM) that allows hosts to opt in if
they support this functionality. Successfully tested with Intel EHCI and
UHCI, though the UHCI code may need to pay more attention to vendor-specific
features.

The power savings from this are measurable but not huge - it still seems 
like a decent optimisation. The main problem is that BIOS bugs on some 
Dell laptops will kill USB if this is used, so we either default to off 
or add some quirks to handle that case (I have some ideas in that 
respect).

---
 drivers/usb/core/hcd-pci.c  |   13 +++++++++++++
 drivers/usb/core/hcd.c      |    9 +++++++++
 drivers/usb/core/hcd.h      |    1 +
 drivers/usb/host/ehci-pci.c |    2 +-
 drivers/usb/host/uhci-hcd.c |    2 +-
 5 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 91f2885..e86324b 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -363,6 +363,18 @@ static int hcd_pci_restore(struct device *dev)
 	return resume_common(dev, true);
 }
 
+static int hcd_pci_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct usb_hcd *hcd = pci_get_drvdata(pci_dev);
+	struct usb_device *rhdev = hcd->self.root_hub;
+
+	if (!(hcd->driver->flags & HCD_RUNTIME_PM))
+		return -EINVAL;
+
+	return 0;
+}
+
 struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.suspend	= hcd_pci_suspend,
 	.suspend_noirq	= hcd_pci_suspend_noirq,
@@ -376,6 +388,7 @@ struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.poweroff_noirq	= hcd_pci_suspend_noirq,
 	.restore_noirq	= hcd_pci_resume_noirq,
 	.restore	= hcd_pci_restore,
+	.runtime_suspend = hcd_pci_runtime_suspend,
 };
 EXPORT_SYMBOL_GPL(usb_hcd_pci_pm_ops);
 
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 95ccfa0..a8f8784 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -38,6 +38,7 @@
 #include <asm/unaligned.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/usb.h>
 
@@ -1747,6 +1748,7 @@ int hcd_bus_suspend(struct usb_device *rhdev, pm_message_t msg)
 	if (status == 0) {
 		usb_set_device_state(rhdev, USB_STATE_SUSPENDED);
 		hcd->state = HC_STATE_SUSPENDED;
+		pm_runtime_put(hcd->self.controller);
 	} else {
 		hcd->state = old_state;
 		dev_dbg(&rhdev->dev, "bus %s fail, err %d\n",
@@ -1768,6 +1770,7 @@ int hcd_bus_resume(struct usb_device *rhdev, pm_message_t msg)
 	if (hcd->state == HC_STATE_RUNNING)
 		return 0;
 
+	pm_runtime_get_sync(hcd->self.controller);
 	hcd->state = HC_STATE_RESUMING;
 	status = hcd->driver->bus_resume(hcd);
 	if (status == 0) {
@@ -1781,6 +1784,7 @@ int hcd_bus_resume(struct usb_device *rhdev, pm_message_t msg)
 		hcd->state = old_state;
 		dev_dbg(&rhdev->dev, "bus %s fail, err %d\n",
 				"resume", status);
+		pm_runtime_put(hcd->self.controller);
 		if (status != -ESHUTDOWN)
 			usb_hc_died(hcd);
 	}
@@ -1968,6 +1972,9 @@ struct usb_hcd *usb_create_hcd (const struct hc_driver *driver,
 	INIT_WORK(&hcd->wakeup_work, hcd_resume_work);
 #endif
 
+	pm_runtime_enable(dev);
+	pm_runtime_get(dev);
+
 	hcd->driver = driver;
 	hcd->product_desc = (driver->product_desc) ? driver->product_desc :
 			"USB Host Controller";
@@ -1979,6 +1986,8 @@ static void hcd_release (struct kref *kref)
 {
 	struct usb_hcd *hcd = container_of (kref, struct usb_hcd, kref);
 
+	pm_runtime_put_sync(hcd->self.controller);
+
 	kfree(hcd);
 }
 
diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index ec5c67e..4dc12a8 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -171,6 +171,7 @@ struct hc_driver {
 	int	flags;
 #define	HCD_MEMORY	0x0001		/* HC regs use memory (else I/O) */
 #define	HCD_LOCAL_MEM	0x0002		/* HC needs local memory */
+#define	HCD_RUNTIME_PM	0x0004		/* HC supports handling runtime PM */
 #define	HCD_USB11	0x0010		/* USB 1.1 */
 #define	HCD_USB2	0x0020		/* USB 2.0 */
 #define	HCD_USB3	0x0040		/* USB 3.0 */
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index c2f1b7d..9583621 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -368,7 +368,7 @@ static const struct hc_driver ehci_pci_hc_driver = {
 	 * generic hardware linkage
 	 */
 	.irq =			ehci_irq,
-	.flags =		HCD_MEMORY | HCD_USB2,
+	.flags =		HCD_MEMORY | HCD_USB2 | HCD_RUNTIME_PM,
 
 	/*
 	 * basic lifecycle operations
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 274751b..36a3a4a 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -900,7 +900,7 @@ static const struct hc_driver uhci_driver = {
 
 	/* Generic hardware linkage */
 	.irq =			uhci_irq,
-	.flags =		HCD_USB11,
+	.flags =		HCD_USB11 | HCD_RUNTIME_PM,
 
 	/* Basic lifecycle operations */
 	.reset =		uhci_init,

-- 
Matthew Garrett | mjg59@srcf.ucam.org

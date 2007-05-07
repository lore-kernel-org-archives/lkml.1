Return-Path: <linux-kernel-owner+w=401wt.eu-S934453AbXEGQxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453AbXEGQxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934447AbXEGQxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:53:15 -0400
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:33380 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934416AbXEGQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:53:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=ll0Y4OjeSkdA3CV4qJv3yG0ZiXsOx7StJUhuiXl8NW57NijCFaf5QBhwrmgFGtnibEFw70X6B9Mqc2E7Wx36V0NqSCGamzqyEye0/YEuwPsD5uFVc1Um4JlyvEjRxKCpJKlU8zhb1cxRu2ZJsA85yVm+hqcUHm40Df0Jr+63UXQ=  ;
X-YMail-OSG: Y9kUw0EVM1lQKnfTdHAHD7oMrYyl6m6mg.1_4NqJoFIKdeko6d6uNN.fUzx0Ler0xwSVjXLLcQ--
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@suse.de>
Subject: [patch 2.6.21-git] remove useless pci driver method
Date: Mon, 7 May 2007 09:29:04 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705070929.04447.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove pointless and never-called enable_wake() hook from pci_driver and
from documentation.  Evidently this was introduced in the 2.4.6 kernel,
but there's no evidence it was ever called; and it was rarely implemented.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

---
 Documentation/pci.txt                         |    3 --
 Documentation/power/pci.txt                   |   37 --------------------------
 drivers/net/typhoon.c                         |    7 ----
 drivers/net/wireless/hostap/hostap_pci.c      |    2 -
 drivers/net/wireless/hostap/hostap_plx.c      |    3 --
 drivers/net/wireless/prism54/islpci_hotplug.c |    1 
 drivers/scsi/nsp32.c                          |   10 -------
 include/linux/pci.h                           |    1 
 8 files changed, 64 deletions(-)

--- g26.orig/include/linux/pci.h	2007-05-06 08:28:03.000000000 -0700
+++ g26/include/linux/pci.h	2007-05-06 09:42:55.000000000 -0700
@@ -370,7 +370,6 @@ struct pci_driver {
 	int  (*suspend_late) (struct pci_dev *dev, pm_message_t state);
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
-	int  (*enable_wake) (struct pci_dev *dev, pci_power_t state, int enable);   /* Enable wake event */
 	void (*shutdown) (struct pci_dev *dev);
 
 	struct pci_error_handlers *err_handler;
--- g26.orig/Documentation/pci.txt	2007-05-06 08:27:40.000000000 -0700
+++ g26/Documentation/pci.txt	2007-05-06 09:42:55.000000000 -0700
@@ -113,9 +113,6 @@ initialization with a pointer to a struc
 		(Please see Documentation/power/pci.txt for descriptions
 		of PCI Power Management and the related functions.)
 
-	enable_wake	Enable device to generate wake events from a low power
-			state.
-
 	shutdown	Hook into reboot_notifier_list (kernel/sys.c).
 			Intended to stop any idling DMA operations.
 			Useful for enabling wake-on-lan (NIC) or changing
--- g26.orig/Documentation/power/pci.txt	2007-05-06 08:27:40.000000000 -0700
+++ g26/Documentation/power/pci.txt	2007-05-06 09:42:55.000000000 -0700
@@ -164,7 +164,6 @@ struct pci_driver:
 
         int  (*suspend) (struct pci_dev *dev, pm_message_t state);
         int  (*resume) (struct pci_dev *dev);
-        int  (*enable_wake) (struct pci_dev *dev, pci_power_t state, int enable);
 
 
 suspend
@@ -251,42 +250,6 @@ The driver should update the current_sta
 this function, except for PM-capable devices when pci_set_power_state is used.
 
 
-enable_wake
------------
-
-Usage:
-
-if (dev->driver && dev->driver->enable_wake)
-	dev->driver->enable_wake(dev,state,enable);
-
-This callback is generally only relevant for devices that support the PCI PM
-spec and have the ability to generate a PME# (Power Management Event Signal)
-to wake the system up. (However, it is possible that a device may support 
-some non-standard way of generating a wake event on sleep.)
-
-Bits 15:11 of the PMC (Power Mgmt Capabilities) Register in a device's
-PM Capabilities describe what power states the device supports generating a 
-wake event from:
-
-+------------------+
-|  Bit  |  State   |
-+------------------+
-|  11   |   D0     |
-|  12   |   D1     |
-|  13   |   D2     |
-|  14   |   D3hot  |
-|  15   |   D3cold |
-+------------------+
-
-A device can use this to enable wake events:
-
-	 pci_enable_wake(dev,state,enable);
-
-Note that to enable PME# from D3cold, a value of 4 should be passed to 
-pci_enable_wake (since it uses an index into a bitmask). If a driver gets
-a request to enable wake events from D3, two calls should be made to 
-pci_enable_wake (one for both D3hot and D3cold).
-
 
 A reference implementation
 -------------------------
--- g26.orig/drivers/net/typhoon.c	2007-05-06 02:56:38.000000000 -0700
+++ g26/drivers/net/typhoon.c	2007-05-06 09:42:55.000000000 -0700
@@ -2276,12 +2276,6 @@ need_resume:
 	typhoon_resume(pdev);
 	return -EBUSY;
 }
-
-static int
-typhoon_enable_wake(struct pci_dev *pdev, pci_power_t state, int enable)
-{
-	return pci_enable_wake(pdev, state, enable);
-}
 #endif
 
 static int __devinit
@@ -2645,7 +2639,6 @@ static struct pci_driver typhoon_driver 
 #ifdef CONFIG_PM
 	.suspend	= typhoon_suspend,
 	.resume		= typhoon_resume,
-	.enable_wake	= typhoon_enable_wake,
 #endif
 };
 
--- g26.orig/drivers/net/wireless/hostap/hostap_pci.c	2007-05-06 02:56:38.000000000 -0700
+++ g26/drivers/net/wireless/hostap/hostap_pci.c	2007-05-06 09:43:45.000000000 -0700
@@ -455,8 +455,6 @@ static struct pci_driver prism2_pci_drv_
 	.suspend	= prism2_pci_suspend,
 	.resume		= prism2_pci_resume,
 #endif /* CONFIG_PM */
-	/* Linux 2.4.6 added save_state and enable_wake that are not used here
-	 */
 };
 
 
--- g26.orig/drivers/net/wireless/hostap/hostap_plx.c	2007-05-06 02:56:38.000000000 -0700
+++ g26/drivers/net/wireless/hostap/hostap_plx.c	2007-05-06 09:43:50.000000000 -0700
@@ -615,9 +615,6 @@ static struct pci_driver prism2_plx_drv_
 	.id_table	= prism2_plx_id_table,
 	.probe		= prism2_plx_probe,
 	.remove		= prism2_plx_remove,
-	.suspend	= NULL,
-	.resume		= NULL,
-	.enable_wake	= NULL
 };
 
 
--- g26.orig/drivers/net/wireless/prism54/islpci_hotplug.c	2007-05-06 02:56:38.000000000 -0700
+++ g26/drivers/net/wireless/prism54/islpci_hotplug.c	2007-05-06 09:42:55.000000000 -0700
@@ -87,7 +87,6 @@ static struct pci_driver prism54_driver 
 	.remove = prism54_remove,
 	.suspend = prism54_suspend,
 	.resume = prism54_resume,
-	/* .enable_wake ; we don't support this yet */
 };
 
 /******************************************************************************
--- g26.orig/drivers/scsi/nsp32.c	2007-05-06 02:56:39.000000000 -0700
+++ g26/drivers/scsi/nsp32.c	2007-05-06 09:42:55.000000000 -0700
@@ -3487,15 +3487,6 @@ static int nsp32_resume(struct pci_dev *
 	return 0;
 }
 
-/* Enable wake event */
-static int nsp32_enable_wake(struct pci_dev *pdev, pci_power_t state, int enable)
-{
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-
-	nsp32_msg(KERN_INFO, "pci-enable_wake: stub, pdev=0x%p, enable=%d, slot=%s, host=0x%p", pdev, enable, pci_name(pdev), host);
-
-	return 0;
-}
 #endif
 
 /************************************************************************
@@ -3571,7 +3562,6 @@ static struct pci_driver nsp32_driver = 
 #ifdef CONFIG_PM
 	.suspend	= nsp32_suspend, 
 	.resume		= nsp32_resume, 
-	.enable_wake    = nsp32_enable_wake,
 #endif
 };
 

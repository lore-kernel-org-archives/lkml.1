Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbXA2PDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbXA2PDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXA2PDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:03:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:38805 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbXA2PDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:03:11 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Nick Piggin <nickpiggin@yahoo.com.au>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: via irq quirk breakage
Date: Mon, 29 Jan 2007 16:00:32 +0100
User-Agent: KMail/1.9.1
Cc: Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
References: <45B6A94A.3010006@yahoo.com.au>
In-Reply-To: <45B6A94A.3010006@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701291600.32580.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ni Nick, Alan,

Le Mercredi 24 Janvier 2007 01:33, Nick Piggin a écrit :
> Recently updated an old box to a new kernel, and the USB mouse stops
> working. Well it sort of works, but stutters and is very unresponsive. This
> happens now and again when the IRQ routing for my board gets broken.
>
> Attached a dmesg from a bad 2.6.20-rc5, and a quick hack that gets
> everything working again, and a diff between good and bad dmesg, and lspci.

Your hack seems quite broken to me, I suspect it works somewhat by
accident and would probably do bad things on other machines.

> I can test patches or send any other info needed.

The same bug was reported to me by someone else, and my investigation
led me to the conclusion that pci_find_present() doesn't work yet at
the moment the quirks are run. Am I right? Which makes me wonder if
this VIA quirks update was ever tested. Alan?

Here is the patch I have come up with. It might not qualify as elegant,
but at least it appears to solve the issue. Nick, can you please give it
a try and confirm it works for you as well?

Note: I'm not sure if the quirk will survive suspend/resume or not, testers
and comments are welcome.

I expect lots of complaints from users if we release 2.6.20 with the VIA
quirks broken.

* * * * *

Fix VIA quirks that were recently broken by Alan Cox in the upstream
kernel (commit 1597cacbe39802d86656d1f2e6329895bd2ef531).

My understanding is that pci_find_present() doesn't work yet at the
time the quirks are run. So I used a two-step quirk as is done for
some other quirks already. First we detect the VIA south bridges
and set the right low and high device limits, then we are ready to
actually run the quirks on the affected devices.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/pci/quirks.c |   78 ++++++++++++++++++++++++++------------------------
 1 files changed, 42 insertions(+), 36 deletions(-)

--- linux-2.6.20-rc6.orig/drivers/pci/quirks.c	2007-01-26 09:08:14.000000000 +0100
+++ linux-2.6.20-rc6/drivers/pci/quirks.c	2007-01-29 15:33:30.000000000 +0100
@@ -654,19 +654,40 @@
  *	VIA bridges which have VLink
  */
 
-static const struct pci_device_id via_vlink_fixup_tbl[] = {
-	/* Internal devices need IRQ line routing, pre VLink */
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C686), 0 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8231), 17 },
-	/* Devices with VLink */
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8233_0), 17},
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8233A), 17 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8233C_0), 17 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8235), 16 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8237), 15 },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8237A), 15 },
-	{ 0, },
-};
+static int via_vlink_dev_lo = -1, via_vlink_dev_hi = 18;
+
+static void quirk_via_bridge(struct pci_dev *dev)
+{
+	/* See what bridge we have and find the device ranges */
+	switch (dev->device) {
+	case PCI_DEVICE_ID_VIA_82C686:
+		/* 82C686 is special */
+		via_vlink_dev_lo = 0;
+		via_vlink_dev_hi = 0;
+		break;
+	case PCI_DEVICE_ID_VIA_8237:
+	case PCI_DEVICE_ID_VIA_8237A:
+		via_vlink_dev_lo = 15;
+		break;
+	case PCI_DEVICE_ID_VIA_8235:
+		via_vlink_dev_lo = 16;
+		break;
+	case PCI_DEVICE_ID_VIA_8231:
+	case PCI_DEVICE_ID_VIA_8233_0:
+	case PCI_DEVICE_ID_VIA_8233A:
+	case PCI_DEVICE_ID_VIA_8233C_0:
+		via_vlink_dev_lo = 17;
+		break;
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8231,		quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233_0,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233A,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233C_0,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8235,		quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237,		quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237A,	quirk_via_bridge);
 
 /**
  *	quirk_via_vlink		-	VIA VLink IRQ number update
@@ -675,35 +696,20 @@
  *	If the device we are dealing with is on a PIC IRQ we need to
  *	ensure that the IRQ line register which usually is not relevant
  *	for PCI cards, is actually written so that interrupts get sent
- *	to the right place
+ *	to the right place.
+ *	We only do this on systems where a VIA south bridge was detected,
+ *	and only for VIA devices on the motherboard (see quirk_via_bridge
+ *	above).
  */
 
 static void quirk_via_vlink(struct pci_dev *dev)
 {
-	const struct pci_device_id *via_vlink_fixup;
-	static int dev_lo = -1, dev_hi = 18;
 	u8 irq, new_irq;
 
-	/* Check if we have VLink and cache the result */
-
-	/* Checked already - no */
-	if (dev_lo == -2)
+	/* Check if we have VLink at all */
+	if (via_vlink_dev_lo == -1)
 		return;
 
-	/* Not checked - see what bridge we have and find the device
-	   ranges */
-
-	if (dev_lo == -1) {
-		via_vlink_fixup = pci_find_present(via_vlink_fixup_tbl);
-		if (via_vlink_fixup == NULL) {
-			dev_lo = -2;
-			return;
-		}
-		dev_lo = via_vlink_fixup->driver_data;
-		/* 82C686 is special - 0/0 */
-		if (dev_lo == 0)
-			dev_hi = 0;
-	}
 	new_irq = dev->irq;
 
 	/* Don't quirk interrupts outside the legacy IRQ range */
@@ -711,8 +717,8 @@
 		return;
 
 	/* Internal device ? */
-	if (dev->bus->number != 0 || PCI_SLOT(dev->devfn) > dev_hi ||
-		PCI_SLOT(dev->devfn) < dev_lo)
+	if (dev->bus->number != 0 || PCI_SLOT(dev->devfn) > via_vlink_dev_hi ||
+	    PCI_SLOT(dev->devfn) < via_vlink_dev_lo)
 		return;
 
 	/* This is an internal VLink device on a PIC interrupt. The BIOS


-- 
Jean Delvare
Suse L3

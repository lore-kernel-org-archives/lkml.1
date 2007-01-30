Return-Path: <linux-kernel-owner+w=401wt.eu-S965290AbXA3M0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290AbXA3M0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965295AbXA3M0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:26:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:55761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965290AbXA3M0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:26:20 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Sergey Vlasov <vsu@altlinux.ru>
Subject: [PATCH] VIA IRQ quirk breakage fix
Date: Tue, 30 Jan 2007 13:25:58 +0100
User-Agent: KMail/1.9.1
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
References: <45B6A94A.3010006@yahoo.com.au> <200701300854.06083.jdelvare@suse.de> <20070130144701.e793c222.vsu@altlinux.ru>
In-Reply-To: <20070130144701.e793c222.vsu@altlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701301325.58843.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,

Le Mardi 30 Janvier 2007 12:47, Sergey Vlasov a écrit :
> On Tue, 30 Jan 2007 08:54:05 +0100 Jean Delvare wrote:
> > You have an old VT82C686 south bridge, which was tagged as "special" by
> > Alan. For this chip, Alan's code only allows devices 00:00.x to be
> > quirked. As my code was merely a reimplementation of Alan's idea, it does
> > the same. Your USB controllers are at 00:07.x, so I'm not surprised they
> > weren't quirked.
> >
> > Alan, why were dev_lo and dev_hi both set to 0 for the VT82C868 in your
> > implementation? Is it a typo, or...?
> >
> > Nick, I guess the following patch would work better for you? I've listed
> > devices 00:07.x as quirkable for the VT82C686.
>
> The VT82C686 is very different from other devices, because it is
> a PCI chip, and its device number is determined by IDSEL wiring.
> Google shows that several different assignments are in use:
>
> 00:01.0:
> http://ozlabs.org/pipermail/linuxppc-embedded/2005-January/016642.html
> (but that's PPC)
>
> 00:04.0: http://www.cs.helsinki.fi/linux/linux-kernel/2001-36/0083.html
> 00:05.0: http://lkml.org/lkml/2003/12/11/78
> 00:07.0: this example and lots of other links
> 00:14.0: http://forum.freespire.org/showthread.php?t=2998

Ah, OK. Thanks for the exhaustive search and explanation. This explains
why Alan and Nick disagreed on the device number.

> > +static void quirk_via_bridge(struct pci_dev *dev)
> > +{
> > +	/* See what bridge we have and find the device ranges */
> > +	switch (dev->device) {
> > +	case PCI_DEVICE_ID_VIA_82C686:
> > +		/* 82C686 is special */
> > +		via_vlink_dev_lo = 7;
> > +		via_vlink_dev_hi = 7;
>
> So this should probably be:
>
> 		/*
> 		 * 82C686 attaches to PCI and can have any device number, but
> 		 * all its subdevices are functions of that single device.
> 		 */
> 		via_vlink_dev_lo = via_vlink_dev_hi = PCI_SLOT(dev->devfn);

Yes, this sounds like the right thing to do. So here comes the third
(and hopefully last) iteration of the patch:


Fix VIA quirks that were recently broken by Alan Cox in the upstream
kernel (commit 1597cacbe39802d86656d1f2e6329895bd2ef531).

My understanding is that pci_find_present() doesn't work yet at the
time the quirks are run. So I used a two-step quirk as is done for
some other quirks already. First we detect the VIA south bridges
and set the right low and high device limits, then we are ready to
actually run the quirks on the affected devices.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Alan Cox <alan@redhat.com>
---
 drivers/pci/quirks.c |   80 +++++++++++++++++++++++++++-----------------------
 1 files changed, 44 insertions(+), 36 deletions(-)

--- linux-2.6.20-rc6.orig/drivers/pci/quirks.c	2007-01-30 13:02:10.000000000 +0100
+++ linux-2.6.20-rc6/drivers/pci/quirks.c	2007-01-30 13:11:15.000000000 +0100
@@ -654,19 +654,42 @@
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
+		/* The VT82C686 is special, it attaches to PCI and can have
+		   any device number. All its subdevices are functions of
+		   that single device. */
+		via_vlink_dev_lo = PCI_SLOT(dev->devfn);
+		via_vlink_dev_hi = PCI_SLOT(dev->devfn);
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
@@ -675,35 +698,20 @@
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
@@ -711,8 +719,8 @@
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

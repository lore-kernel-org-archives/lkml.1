Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbXGaIcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbXGaIcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXGaIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:32:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXGaIcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:32:15 -0400
Message-ID: <46AEF347.9030007@netcom.eu>
Date: Tue, 31 Jul 2007 10:31:03 +0200
From: David Engraf <david.engraf@netcom.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, david.engraf@netcom.eu
Subject: [PATCH] USB BIOS early handoff only when the we the driver is configured
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18FgYzthcLMtSCorDBeBwW0LVfn2LMF8llidOB
 o4NZvS0XV4z06z//auM2UwvH8yAJvdBSgQFkI6As1/JaRUjURz
 4dMLSgJQuvslgTNYIJkAw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_USB_UHCI_HCD, CONFIG_USB_OHCI_HCD or CONFIG_USB_EHCI_HCD is
not configured we don't need to call the quirk_usb_handoff_xxxx function
in driver/usb/host/pci_quiks.c.

I think the kernel shouldn't take the control over the usb controller
when we don't have the driver for it,
so with this patch the kernel takes the control only when the driver is
configured.


linux-2.6.22.1

diff -puN drivers/usb/host/pci-quirks_orig.c drivers/usb/host/pci-quirks.c
--- drivers/usb/host/pci-quirks_orig.c    2007-07-10 20:56:30.000000000
+0200
+++ drivers/usb/host/pci-quirks.c    2007-07-31 09:55:28.000000000 +0200
@@ -142,6 +142,7 @@ static inline int io_type_enabled(struct
 #define pio_enabled(dev) io_type_enabled(dev, PCI_COMMAND_IO)
 #define mmio_enabled(dev) io_type_enabled(dev, PCI_COMMAND_MEMORY)
 
+#ifdef CONFIG_USB_UHCI_HCD
 static void __devinit quirk_usb_handoff_uhci(struct pci_dev *pdev)
 {
     unsigned long base = 0;
@@ -159,12 +160,14 @@ static void __devinit quirk_usb_handoff_
     if (base)
         uhci_check_and_reset_hc(pdev, base);
 }
+#endif
 
 static int __devinit mmio_resource_enabled(struct pci_dev *pdev, int idx)
 {
     return pci_resource_start(pdev, idx) && mmio_enabled(pdev);
 }
 
+#ifdef CONFIG_USB_OHCI_HCD
 static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
     void __iomem *base;
@@ -209,7 +212,9 @@ static void __devinit quirk_usb_handoff_
 
     iounmap(base);
 }
+#endif
 
+#ifdef CONFIG_USB_EHCI_HCD
 static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
 {
     int wait_time, delta;
@@ -346,16 +351,24 @@ static void __devinit quirk_usb_disable_
 
     return;
 }
-
+#endif
 
 
 static void __devinit quirk_usb_early_handoff(struct pci_dev *pdev)
 {
+#ifdef CONFIG_USB_UHCI_HCD
     if (pdev->class == PCI_CLASS_SERIAL_USB_UHCI)
         quirk_usb_handoff_uhci(pdev);
-    else if (pdev->class == PCI_CLASS_SERIAL_USB_OHCI)
+#endif
+
+#ifdef CONFIG_USB_OHCI_HCD
+    if (pdev->class == PCI_CLASS_SERIAL_USB_OHCI)
         quirk_usb_handoff_ohci(pdev);
-    else if (pdev->class == PCI_CLASS_SERIAL_USB_EHCI)
+#endif
+
+#ifdef CONFIG_USB_EHCI_HCD
+    if (pdev->class == PCI_CLASS_SERIAL_USB_EHCI)
         quirk_usb_disable_ehci(pdev);
+#endif
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_usb_early_handoff);


Thanks

David Engraf

 

 
Netcom Sicherheitstechnik GmbH
Rheinallee 189
55120 Mainz
Tel: 	+49 6131 6305 0
Fax: 	+49 6131 6305 40
Email: 	david.engraf@netcom.eu

 
Sitz der Gesellschaft: Mainz
Registergericht: Amtsgericht Mainz, 14HRB3411
Geschäftsführer: Peter Otto


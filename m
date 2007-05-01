Return-Path: <linux-kernel-owner+w=401wt.eu-S1031627AbXEAJkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031627AbXEAJkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031630AbXEAJkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:40:32 -0400
Received: from mbox1.netikka.net ([213.250.81.202]:41811 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031627AbXEAJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:40:30 -0400
Message-ID: <46370B06.4030600@mandriva.org>
Date: Tue, 01 May 2007 12:40:22 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [patch] Add support for picopower irq router
Content-Type: multipart/mixed;
 boundary="------------070004010808050101050004"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070004010808050101050004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------070004010808050101050004
Content-Type: text/plain;
 name="picopower-irq-router.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="picopower-irq-router.patch"


This patch adds support for PicoPower PT86C523 IRQ router to be used 
with the in-kernel yenta driver for CardBus.
With this patch cardbus works on e.g. Dell Latitude XPi P150CD. 

Initial patch for kernel 2.4 series by Sune Mølgaard
http://molgaard.org/code/linux-2.4.31-picopower.patch

Ported to 2.6.20 by Chmouel Boudjnah (http://www.chmouel.com)

Tested and confirmed that it works by Austin Acton.

Cleaned up a little for inclusion in a 2.6.21-rc7 & 2.6.21.1 based kernel.

Signed-Off-By: Thomas Backlund <tmb@mandriva.org>

 arch/i386/pci/irq.c     |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    3 +++
 2 files changed, 41 insertions(+)

diff -Nurp 2.6.21-rc7/arch/i386/pci/irq.c 2.6.21-rc7.picopower/arch/i386/pci/irq.c
--- 2.6.21-rc7/arch/i386/pci/irq.c	2007-02-04 20:44:54.000000000 +0200
+++ 2.6.21-rc7.picopower/arch/i386/pci/irq.c	2007-04-24 15:26:21.000000000 +0300
@@ -491,6 +491,24 @@ static int pirq_amd756_set(struct pci_de
 	return 1;
 }
 
+/*
+ * PicoPower PT86C523
+ */
+static int pirq_pico_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
+{
+	outb(0x10+((pirq-1)>>1), 0x24);
+	return ((pirq-1)&1) ? (inb(0x26)>>4) : (inb(0x26)&0xf);
+}
+
+static int pirq_pico_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+{
+	outb(0x10+((pirq-1)>>1), 0x24);
+	unsigned int x;
+	x = inb(0x26);
+	x = ((pirq-1)&1) ? ((x&0x0f)|(irq<<4)) : ((x&0xf0)|(irq));
+	outb(x,0x26);
+}
+
 #ifdef CONFIG_PCI_BIOS
 
 static int pirq_bios_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
@@ -719,6 +737,25 @@ static __init int amd_router_probe(struc
 	return 1;
 }
 		
+static __init int pico_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+{
+	switch(device)
+	{
+	        case PCI_DEVICE_ID_PICOPOWER_PT86C523:
+			r->name = "PicoPower PT86C523";
+			r->get = pirq_pico_get;
+			r->set = pirq_pico_set;
+			return 1;
+
+		case PCI_DEVICE_ID_PICOPOWER_PT86C523BBP:
+			r->name = "PicoPower PT86C523 rev. BB+";
+			r->get = pirq_pico_get;
+			r->set = pirq_pico_set;
+			return 1;
+	}
+	return 0;
+}
+
 static __initdata struct irq_router_handler pirq_routers[] = {
 	{ PCI_VENDOR_ID_INTEL, intel_router_probe },
 	{ PCI_VENDOR_ID_AL, ali_router_probe },
@@ -730,6 +767,7 @@ static __initdata struct irq_router_hand
 	{ PCI_VENDOR_ID_VLSI, vlsi_router_probe },
 	{ PCI_VENDOR_ID_SERVERWORKS, serverworks_router_probe },
 	{ PCI_VENDOR_ID_AMD, amd_router_probe },
+	{ PCI_VENDOR_ID_PICOPOWER, pico_router_probe },
 	/* Someone with docs needs to add the ATI Radeon IGP */
 	{ 0, NULL }
 };
diff -Nurp 2.6.21-rc7/include/linux/pci_ids.h 2.6.21-rc7.picopower/include/linux/pci_ids.h
--- 2.6.21-rc7/include/linux/pci_ids.h	2007-04-24 14:37:59.000000000 +0300
+++ 2.6.21-rc7.picopower/include/linux/pci_ids.h	2007-04-24 15:26:21.000000000 +0300
@@ -819,6 +819,9 @@
 #define PCI_DEVICE_ID_UMC_UM8886BF	0x673a
 #define PCI_DEVICE_ID_UMC_UM8886A	0x886a
 
+#define PCI_VENDOR_ID_PICOPOWER		0x1066
+#define PCI_DEVICE_ID_PICOPOWER_PT86C523	0x0002
+#define PCI_DEVICE_ID_PICOPOWER_PT86C523BBP	0x8002
 
 #define PCI_VENDOR_ID_MYLEX		0x1069
 #define PCI_DEVICE_ID_MYLEX_DAC960_P	0x0001

--------------070004010808050101050004--

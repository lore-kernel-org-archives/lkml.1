Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbXLJEcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbXLJEcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXLJEcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:32:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:47000 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXLJEcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:32:02 -0500
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071209222335.70e52be3@the-village.bc.nu>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	 <1196899818.7033.11.camel@pasglop>
	 <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	 <1196917447.7033.17.camel@pasglop>
	 <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	 <1196922262.7033.33.camel@pasglop> <20071209021231.GA13729@linux-mips.org>
	 <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop>
	 <20071209133812.2d305a02@the-village.bc.nu>
	 <1197230609.6563.6.camel@pasglop>
	 <20071209222335.70e52be3@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 15:29:22 +1100
Message-Id: <1197260962.6563.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc: Fix IDE legacy vs. native fixups

PowerMac and CHRP/BriQ platforms have quirks to switch some IDE
controllers from legacy mode to fully native mode. Those quirks
however will not work properly anymore due to a change to the
generic code to better handle legacy IDE resources.

This fixes it by moving those quirk to "early" quirks (so they
run before resources are probed for the devices) and clearing
all BARs after the conversion to force a reallocation of sane
values.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

To be totally correct, we still need to also revert
commit fd6e732186ab522c812ab19c2c5e5befb8ec8115 which
is bogus.

Linus, can you still apply this to 2.6.24 ? I would also like the
above (fd6e...) reverted as so far, nobody have come up with a demonstration
that it's not bogus.

Index: linux-work/arch/powerpc/platforms/chrp/pci.c
===================================================================
--- linux-work.orig/arch/powerpc/platforms/chrp/pci.c	2007-12-10 15:23:21.000000000 +1100
+++ linux-work/arch/powerpc/platforms/chrp/pci.c	2007-12-10 15:23:29.000000000 +1100
@@ -317,8 +317,12 @@ chrp_find_bridges(void)
 /* SL82C105 IDE Control/Status Register */
 #define SL82C105_IDECSR                0x40
 
-/* Fixup for Winbond ATA quirk, required for briq */
-void chrp_pci_fixup_winbond_ata(struct pci_dev *sl82c105)
+/* Fixup for Winbond ATA quirk, required for briq mostly because the
+ * 8259 is configured for level sensitive IRQ 14 and so wants the
+ * ATA controller to be set to fully native mode or bad things
+ * will happen.
+ */
+static void __devinit chrp_pci_fixup_winbond_ata(struct pci_dev *sl82c105)
 {
 	u8 progif;
 
@@ -334,10 +338,15 @@ void chrp_pci_fixup_winbond_ata(struct p
 		sl82c105->class |= 0x05;
 		/* Disable SL82C105 second port */
 		pci_write_config_word(sl82c105, SL82C105_IDECSR, 0x0003);
+		/* Clear IO BARs, they will be reassigned */
+		pci_write_config_dword(sl82c105, PCI_BASE_ADDRESS_0, 0);
+		pci_write_config_dword(sl82c105, PCI_BASE_ADDRESS_1, 0);
+		pci_write_config_dword(sl82c105, PCI_BASE_ADDRESS_2, 0);
+		pci_write_config_dword(sl82c105, PCI_BASE_ADDRESS_3, 0);
 	}
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_WINBOND, PCI_DEVICE_ID_WINBOND_82C105,
-		chrp_pci_fixup_winbond_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_WINBOND, PCI_DEVICE_ID_WINBOND_82C105,
+			chrp_pci_fixup_winbond_ata);
 
 /* Pegasos2 firmware version 20040810 configures the built-in IDE controller
  * in legacy mode, but sets the PCI registers to PCI native mode.
@@ -345,7 +354,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_WI
  * mode as well. The same fixup must be done to the class-code property in
  * the IDE node /pci@80000000/ide@C,1
  */
-static void chrp_pci_fixup_vt8231_ata(struct pci_dev *viaide)
+static void __devinit chrp_pci_fixup_vt8231_ata(struct pci_dev *viaide)
 {
 	u8 progif;
 	struct pci_dev *viaisa;
@@ -366,4 +375,4 @@ static void chrp_pci_fixup_vt8231_ata(st
 
 	pci_dev_put(viaisa);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, chrp_pci_fixup_vt8231_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, chrp_pci_fixup_vt8231_ata);
Index: linux-work/arch/powerpc/platforms/powermac/pci.c
===================================================================
--- linux-work.orig/arch/powerpc/platforms/powermac/pci.c	2007-12-10 15:23:21.000000000 +1100
+++ linux-work/arch/powerpc/platforms/powermac/pci.c	2007-12-10 15:23:29.000000000 +1100
@@ -1243,15 +1243,22 @@ void pmac_pci_fixup_pciata(struct pci_de
  good:
 	pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 	if ((progif & 5) != 5) {
-		printk(KERN_INFO "Forcing PCI IDE into native mode: %s\n",
+		printk(KERN_INFO "PCI: %s Forcing PCI IDE into native mode\n",
 		       pci_name(dev));
 		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
 		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 		    (progif & 5) != 5)
 			printk(KERN_ERR "Rewrite of PROGIF failed !\n");
+		else {
+			/* Clear IO BARs, they will be reassigned */
+			pci_write_config_dword(dev, PCI_BASE_ADDRESS_0, 0);
+			pci_write_config_dword(dev, PCI_BASE_ADDRESS_1, 0);
+			pci_write_config_dword(dev, PCI_BASE_ADDRESS_2, 0);
+			pci_write_config_dword(dev, PCI_BASE_ADDRESS_3, 0);
+		}
 	}
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pmac_pci_fixup_pciata);
+DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, pmac_pci_fixup_pciata);
 #endif
 
 /*



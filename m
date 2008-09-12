Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYILLXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYILLXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYILLW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:22:58 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:61831 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752922AbYILLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:22:57 -0400
Subject: PCI: Add ALI M5229 comaptibility mode quirk
Message-Id: <20080912112252.505651015@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-add-ali-ide-pci-quirk.patch
Date: Fri, 12 Sep 2008 12:22:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The libata driver will not work with an M5229 set into native IDE
mode (the old drivers/pci one does) if the M5229 does not provide
it's own IRQ.

The M5229 implementation embedded into the ALI M1543 uses the
M1543's ISA PIC to provide the interrupts and thus does not have
an valid PCI IRQ set. This quirk detects the abscence of IRQ and
sets the M5229 back into compatibility mode to use IRQs 14 and 15
so that libata works correctly.

Note, I belive that the check for an valid interrupt line is
correct, I only have an M5229 in an ALI M1543 to check this
on. It would be useful to confirm that a M5229 with an valid IRQ
does not trigger this quirk.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.27-rc6-cats1/drivers/pci/quirks.c
===================================================================
--- linux-2.6.27-rc6-cats1.orig/drivers/pci/quirks.c	2008-09-11 11:26:35.000000000 +0100
+++ linux-2.6.27-rc6-cats1/drivers/pci/quirks.c	2008-09-12 12:18:05.000000000 +0100
@@ -905,6 +905,34 @@ static void __devinit quirk_svwks_csb5id
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, quirk_svwks_csb5ide);
 
+/* Some systems set the ALI M5229 in the ALI M1543 bridge to native mode,
+ * which cannot be supported by the pata_ali.c driver (the old drivers/ide
+ * makes a compatibility effort to change the IDE interrupts).
+ */
+static void __devinit quirk_ali_ide_compatibility(struct pci_dev *pdev)
+{
+	u8 tmp;
+
+	/* pdev->irq and pdev->pin have yet to be initialised, so check
+	 * by reading from the configuration header to see if we've got
+	 * a valid interrupt line. */
+
+	pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &tmp);
+	if (tmp != 0xff)
+		return;
+
+	pci_read_config_byte(pdev, PCI_CLASS_PROG, &tmp);
+	if (tmp & 0x5) {
+		dev_info(&pdev->dev, "quirk: changing to IDE compatibility mode\n");
+
+		tmp &= ~0x05;
+		pdev->class &= ~0x05;
+		pci_write_config_byte(pdev, PCI_CLASS_PROG, tmp);
+	}
+}
+
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M5229, quirk_ali_ide_compatibility);
+
 /*
  *	Intel 82801CAM ICH3-M datasheet says IDE modes must be the same
  */

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'

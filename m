Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbXIRLzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbXIRLzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 07:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbXIRLyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 07:54:55 -0400
Received: from [212.176.242.38] ([212.176.242.38]:60132 "EHLO
	vaxon.spb.rtsoft.ru" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754915AbXIRLyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:54:54 -0400
X-Greylist: delayed 2170 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 07:54:53 EDT
Date: Tue, 18 Sep 2007 15:17:37 +0400
From: Valentine Barshak <vbarshak@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pci: Fix e100 interrupt quirk
Message-ID: <20070918111737.GA7026@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCI memory space may have a 64-bit offset on some architectures
(for example, PowerPC 440) and the actual PCI memory address
has to fixed up (an offset to PCI mem space shuld be added)
before remapping. So, pci_iomap should be used instead of
reading and remapping PCI BAR directly. This has been tested
on Sequoia PowerPC 440EPx board.

Signed-off-by: Valentine Barshak <vbarshak@ru.mvista.com>
---

--- linux-2.6.orig/drivers/pci/quirks.c	2007-09-04 21:15:43.000000000 +0400
+++ linux-2.6.bld/drivers/pci/quirks.c	2007-09-05 20:46:14.000000000 +0400
@@ -1444,9 +1444,9 @@
 static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
 {
 	u16 command;
-	u32 bar;
 	u8 __iomem *csr;
 	u8 cmd_hi;
+	int rc;
 
 	switch (dev->device) {
 	/* PCI IDs taken from drivers/net/e100.c */
@@ -1476,16 +1476,17 @@
 	 * re-enable them when it's ready.
 	 */
 	pci_read_config_word(dev, PCI_COMMAND, &command);
-	pci_read_config_dword(dev, PCI_BASE_ADDRESS_0, &bar);
 
-	if (!(command & PCI_COMMAND_MEMORY) || !bar)
+	rc = pci_request_region(dev, 0, "e100_quirk");
+
+	if (!(command & PCI_COMMAND_MEMORY) || (rc < 0))
 		return;
 
-	csr = ioremap(bar, 8);
+	csr = pci_iomap(dev, 0, 8);
 	if (!csr) {
 		printk(KERN_WARNING "PCI: Can't map %s e100 registers\n",
 			pci_name(dev));
-		return;
+		goto e100_quirk_exit;
 	}
 
 	cmd_hi = readb(csr + 3);
@@ -1495,7 +1496,9 @@
 		writeb(1, csr + 3);
 	}
 
-	iounmap(csr);
+	pci_iounmap(dev, csr);
+e100_quirk_exit:
+	pci_release_region(dev, 0);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_e100_interrupt);
 

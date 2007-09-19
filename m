Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbXISMiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbXISMiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXISMh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:37:58 -0400
Received: from [212.176.242.38] ([212.176.242.38]:51787 "EHLO
	vaxon.spb.rtsoft.ru" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754226AbXISMh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:37:57 -0400
Date: Wed, 19 Sep 2007 16:36:49 +0400
From: Valentine Barshak <vbarshak@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: jarkao2@o2.pl
Subject: [PATCH] pci: Fix e100 interrupt quirk
Message-ID: <20070919123649.GA3686@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919104342.GB3226@ff.dom.local>
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

diff -ruN linux-2.6.orig/drivers/pci/quirks.c linux-2.6/drivers/pci/quirks.c
--- linux-2.6.orig/drivers/pci/quirks.c	2007-09-18 15:32:48.000000000 +0400
+++ linux-2.6/drivers/pci/quirks.c	2007-09-19 15:57:26.000000000 +0400
@@ -1444,7 +1444,6 @@
 static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
 {
 	u16 command;
-	u32 bar;
 	u8 __iomem *csr;
 	u8 cmd_hi;
 
@@ -1476,16 +1475,18 @@
 	 * re-enable them when it's ready.
 	 */
 	pci_read_config_word(dev, PCI_COMMAND, &command);
-	pci_read_config_dword(dev, PCI_BASE_ADDRESS_0, &bar);
 
-	if (!(command & PCI_COMMAND_MEMORY) || !bar)
+	if (!(command & PCI_COMMAND_MEMORY))
 		return;
 
-	csr = ioremap(bar, 8);
+	if (pci_request_region(dev, 0, "e100_quirk"))
+		return;
+
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
 

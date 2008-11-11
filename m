Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYKKKpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYKKKpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYKKKpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:45:04 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:45544 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbYKKKpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:45:03 -0500
Message-Id: <4919705F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 11 Nov 2008 10:45:35 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-pci@vger.kernel.org>
Cc: <grundler@parisc-linux.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] remove msix_flush_writes()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msix_flush_writes() is being called exclusively after calling msi_set_mask_bit(),
and that function already does follow writel() by readl() in the MSI-X case.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

---
 drivers/pci/msi.c |   25 -------------------------
 1 file changed, 25 deletions(-)

--- linux-2.6.28-rc4/drivers/pci/msi.c	2008-11-11 11:11:20.000000000 +0100
+++ 2.6.28-rc4-pci-msix-flush-writes/drivers/pci/msi.c	2008-11-07 09:11:36.000000000 +0100
@@ -103,29 +103,6 @@ static void msix_set_enable(struct pci_d
 	}
 }
 
-static void msix_flush_writes(unsigned int irq)
-{
-	struct msi_desc *entry;
-
-	entry = get_irq_msi(irq);
-	BUG_ON(!entry || !entry->dev);
-	switch (entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
-		/* nothing to do */
-		break;
-	case PCI_CAP_ID_MSIX:
-	{
-		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
-			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
-		readl(entry->mask_base + offset);
-		break;
-	}
-	default:
-		BUG();
-		break;
-	}
-}
-
 /*
  * PCI 2.3 does not specify mask bits for each MSI interrupt.  Attempting to
  * mask all MSI interrupts by clearing the MSI enable bit does not work
@@ -255,13 +232,11 @@ void write_msi_msg(unsigned int irq, str
 void mask_msi_irq(unsigned int irq)
 {
 	msi_set_mask_bits(irq, 1, 1);
-	msix_flush_writes(irq);
 }
 
 void unmask_msi_irq(unsigned int irq)
 {
 	msi_set_mask_bits(irq, 1, 0);
-	msix_flush_writes(irq);
 }
 
 static int msi_free_irqs(struct pci_dev* dev);




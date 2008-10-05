Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbYJEQOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbYJEQOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbYJEQIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:08:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48468 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756634AbYJEQId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:08:33 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 28/76] Char: cyclades. remove bogus iomap
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:08:33 +0100
Message-ID: <20081005160829.1997.9463.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

readl/writel are not expected to accept iomap return value. Replace
bogus mapping by standard ioremap.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/cyclades.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index fe6d774..5e5b1dc 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4993,12 +4993,14 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
 		card_name = "Cyclom-Y";
 
-		addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
+		addr0 = ioremap_nocache(pci_resource_start(pdev, 0),
+				CyPCI_Yctl);
 		if (addr0 == NULL) {
 			dev_err(&pdev->dev, "can't remap ctl region\n");
 			goto err_reg;
 		}
-		addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
+		addr2 = ioremap_nocache(pci_resource_start(pdev, 2),
+				CyPCI_Ywin);
 		if (addr2 == NULL) {
 			dev_err(&pdev->dev, "can't remap base region\n");
 			goto err_unmap;
@@ -5013,7 +5015,8 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi) {
 		struct RUNTIME_9060 __iomem *ctl_addr;
 
-		ctl_addr = addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
+		ctl_addr = addr0 = ioremap_nocache(pci_resource_start(pdev, 0),
+				CyPCI_Zctl);
 		if (addr0 == NULL) {
 			dev_err(&pdev->dev, "can't remap ctl region\n");
 			goto err_reg;
@@ -5026,8 +5029,8 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 		mailbox = (u32)readl(&ctl_addr->mail_box_0);
 
-		addr2 = pci_iomap(pdev, 2, mailbox == ZE_V1 ?
-				CyPCI_Ze_win : CyPCI_Zwin);
+		addr2 = ioremap_nocache(pci_resource_start(pdev, 2),
+				mailbox == ZE_V1 ? CyPCI_Ze_win : CyPCI_Zwin);
 		if (addr2 == NULL) {
 			dev_err(&pdev->dev, "can't remap base region\n");
 			goto err_unmap;
@@ -5159,9 +5162,9 @@ err_null:
 	cy_card[card_no].base_addr = NULL;
 	free_irq(irq, &cy_card[card_no]);
 err_unmap:
-	pci_iounmap(pdev, addr0);
+	iounmap(addr0);
 	if (addr2)
-		pci_iounmap(pdev, addr2);
+		iounmap(addr2);
 err_reg:
 	pci_release_regions(pdev);
 err_dis:
@@ -5186,9 +5189,9 @@ static void __devexit cy_pci_remove(struct pci_dev *pdev)
 		cy_writew(cinfo->ctl_addr + 0x68,
 				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
 
-	pci_iounmap(pdev, cinfo->base_addr);
+	iounmap(cinfo->base_addr);
 	if (cinfo->ctl_addr)
-		pci_iounmap(pdev, cinfo->ctl_addr);
+		iounmap(cinfo->ctl_addr);
 	if (cinfo->irq
 #ifndef CONFIG_CYZ_INTR
 		&& !IS_CYC_Z(*cinfo)


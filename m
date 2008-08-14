Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYHNQ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYHNQ0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYHNQ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:26:38 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:57731 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYHNQ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:26:37 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/3] Char: cyclades, remove bogus iomap
Date: Thu, 14 Aug 2008 18:25:52 +0200
Message-Id: <1218731154-32692-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readl/writel are not expected to accept iomap return value. Replace
bogus mapping by standard ioremap.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 33737bb..6e480e8 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4976,12 +4976,14 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
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
@@ -4996,7 +4998,8 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi) {
 		struct RUNTIME_9060 __iomem *ctl_addr;
 
-		ctl_addr = addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
+		ctl_addr = addr0 = ioremap_nocache(pci_resource_start(pdev, 0),
+				CyPCI_Zctl);
 		if (addr0 == NULL) {
 			dev_err(&pdev->dev, "can't remap ctl region\n");
 			goto err_reg;
@@ -5009,8 +5012,8 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 		mailbox = (u32)readl(&ctl_addr->mail_box_0);
 
-		addr2 = pci_iomap(pdev, 2, mailbox == ZE_V1 ?
-				CyPCI_Ze_win : CyPCI_Zwin);
+		addr2 = ioremap_nocache(pci_resource_start(pdev, 2),
+				mailbox == ZE_V1 ? CyPCI_Ze_win : CyPCI_Zwin);
 		if (addr2 == NULL) {
 			dev_err(&pdev->dev, "can't remap base region\n");
 			goto err_unmap;
@@ -5142,9 +5145,9 @@ err_null:
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
@@ -5169,9 +5172,9 @@ static void __devexit cy_pci_remove(struct pci_dev *pdev)
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
-- 
1.5.6.5


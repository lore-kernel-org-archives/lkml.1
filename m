Return-Path: <linux-kernel-owner+w=401wt.eu-S1422770AbXDRKDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422770AbXDRKDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422769AbXDRKDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:03:47 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:11724 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422770AbXDRKDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:03:45 -0400
Message-id: <16369722090810445@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 2/11] Char: cyclades, use pci_iomap/unmap
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:03:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, use pci_iomap/unmap

fork remove code for pci -- move it to separate, new, function and don't
care about pci in the former.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2d99f97963f6a60727c1cc8d21d3bdbf4ba48d7f
tree aba7f710a1668c17d56d45ff805ec03adc950c42
parent 1cd1f5e029963fc449c4f84495770611e5c35297
author Jiri Slaby <jirislaby@gmail.com> Thu, 29 Mar 2007 19:43:52 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:47:58 +0200

 drivers/char/cyclades.c |   42 ++++++++++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 26d9ea7..1d5fe9a 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4775,6 +4775,7 @@ static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
 	cy_card[j].pdev = pdev;
+	pci_set_drvdata(pdev, &cy_card[j]);
 
 	/* print message */
 #ifdef CONFIG_CYZ_INTR
@@ -4889,8 +4890,8 @@ static int __init cy_detect_pci(void)
 				continue;
 			}
 #endif
-			cy_pci_addr0 = ioremap(cy_pci_phys0, CyPCI_Yctl);
-			cy_pci_addr2 = ioremap(cy_pci_phys2, CyPCI_Ywin);
+			cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
+			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
 
 #ifdef CY_PCI_DEBUG
 			printk("Cyclom-Y/PCI: relocate winaddr=0x%lx "
@@ -4948,6 +4949,7 @@ static int __init cy_detect_pci(void)
 			cy_card[j].first_line = cy_next_channel;
 			cy_card[j].num_chips = cy_pci_nchan / 4;
 			cy_card[j].pdev = pdev;
+			pci_set_drvdata(pdev, &cy_card[j]);
 
 			/* enable interrupts in the PCI interface */
 			plx_ver = readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
@@ -5006,7 +5008,7 @@ static int __init cy_detect_pci(void)
 				"ctladdr=0x%lx\n",
 				(ulong) cy_pci_phys2, (ulong) cy_pci_phys0);
 #endif
-			cy_pci_addr0 = ioremap(cy_pci_phys0, CyPCI_Zctl);
+			cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
 
 			/* Disable interrupts on the PLX before resetting it */
 			cy_writew(cy_pci_addr0 + 0x68,
@@ -5040,8 +5042,7 @@ static int __init cy_detect_pci(void)
 			}
 
 			if (mailbox == ZE_V1) {
-				cy_pci_addr2 = ioremap(cy_pci_phys2,
-						CyPCI_Ze_win);
+				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ze_win);
 				if (ZeIndex == NR_CARDS) {
 					printk("Cyclades-Ze/PCI found at "
 						"0x%lx but no more cards can "
@@ -5061,7 +5062,7 @@ static int __init cy_detect_pci(void)
 				i--;
 				continue;
 			} else {
-				cy_pci_addr2 = ioremap(cy_pci_phys2,CyPCI_Zwin);
+				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
 			}
 
 #ifdef CY_PCI_DEBUG
@@ -5145,6 +5146,7 @@ static int __init cy_detect_pci(void)
 			cy_card[j].first_line = cy_next_channel;
 			cy_card[j].num_chips = -1;
 			cy_card[j].pdev = pdev;
+			pci_set_drvdata(pdev, &cy_card[j]);
 
 			/* print message */
 #ifdef CONFIG_CYZ_INTR
@@ -5198,6 +5200,26 @@ static int __init cy_detect_pci(void)
 #endif				/* ifdef CONFIG_PCI */
 }				/* cy_detect_pci */
 
+static void __devexit cy_pci_release(struct pci_dev *pdev)
+{
+#ifdef CONFIG_PCI
+	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
+
+	pci_iounmap(pdev, cinfo->base_addr);
+	if (cinfo->ctl_addr)
+		pci_iounmap(pdev, cinfo->ctl_addr);
+	if (cinfo->irq
+#ifndef CONFIG_CYZ_INTR
+		&& cinfo->num_chips != -1 /* not a Z card */
+#endif /* CONFIG_CYZ_INTR */
+		)
+		free_irq(cinfo->irq, cinfo);
+	pci_release_regions(pdev);
+
+	cinfo->base_addr = NULL;
+#endif
+}
+
 /*
  * This routine prints out the appropriate serial driver version number
  * and identifies which options were configured into this driver.
@@ -5546,6 +5568,10 @@ static void __exit cy_cleanup_module(void)
 
 	for (i = 0; i < NR_CARDS; i++) {
 		if (cy_card[i].base_addr) {
+			if (cy_card[i].pdev) {
+				cy_pci_release(cy_card[i].pdev);
+				continue;
+			}
 			iounmap(cy_card[i].base_addr);
 			if (cy_card[i].ctl_addr)
 				iounmap(cy_card[i].ctl_addr);
@@ -5555,10 +5581,6 @@ static void __exit cy_cleanup_module(void)
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(cy_card[i].irq, &cy_card[i]);
-#ifdef CONFIG_PCI
-			if (cy_card[i].pdev)
-				pci_release_regions(cy_card[i].pdev);
-#endif
 		}
 	}
 } /* cy_cleanup_module */

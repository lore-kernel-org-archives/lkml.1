Return-Path: <linux-kernel-owner+w=401wt.eu-S1422774AbXDRKEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422774AbXDRKEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422769AbXDRKEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:04:21 -0400
Received: from av7.karneval.cz ([81.27.192.15]:60207 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422774AbXDRKET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:04:19 -0400
Message-id: <537016251706625678@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 3/11] Char: cyclades, init Ze immediately
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:04:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, init Ze immediately

There will be no other choice after introducing pci probing anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 15bad81f3abe0638e7ccf34fd14cf6c372146742
tree 3dfe3a58322b197e80d09757e4049f1221240a6d
parent 2d99f97963f6a60727c1cc8d21d3bdbf4ba48d7f
author Jiri Slaby <jirislaby@gmail.com> Sun, 01 Apr 2007 22:20:05 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:47:59 +0200

 drivers/char/cyclades.c |   59 ++++++-----------------------------------------
 1 files changed, 8 insertions(+), 51 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 1d5fe9a..43cf832 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4714,12 +4714,14 @@ static void plx_init(void __iomem * addr, __u32 initctl)
 static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
 		unsigned long cy_pci_phys2,
 		struct RUNTIME_9060 __iomem *cy_pci_addr0,
-		void __iomem *cy_pci_addr2, int cy_pci_irq,
-		struct pci_dev *pdev)
+		int cy_pci_irq, struct pci_dev *pdev)
 {
+	void __iomem *cy_pci_addr2;
 	unsigned int j;
 	unsigned short cy_pci_nchan;
 
+	cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ze_win);
+
 	readl(&cy_pci_addr0->mail_box_0);
 #ifdef CY_PCI_DEBUG
 	printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
@@ -4816,11 +4818,6 @@ static int __init cy_detect_pci(void)
 	unsigned short i, j, cy_pci_nchan, plx_ver;
 	unsigned short device_id, dev_index = 0;
 	__u32 mailbox;
-	__u32 ZeIndex = 0;
-	void __iomem *Ze_addr0[NR_CARDS], *Ze_addr2[NR_CARDS];
-	__u32 Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
-	unsigned char Ze_irq[NR_CARDS];
-	struct pci_dev *Ze_pdev[NR_CARDS];
 	int retval;
 
 	for (i = 0; i < NR_CARDS; i++) {
@@ -5042,24 +5039,10 @@ static int __init cy_detect_pci(void)
 			}
 
 			if (mailbox == ZE_V1) {
-				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ze_win);
-				if (ZeIndex == NR_CARDS) {
-					printk("Cyclades-Ze/PCI found at "
-						"0x%lx but no more cards can "
-						"be used.\nChange NR_CARDS in "
-						"cyclades.c and recompile "
-						"kernel.\n",
-						(ulong)cy_pci_phys2);
-				} else {
-					Ze_phys0[ZeIndex] = cy_pci_phys0;
-					Ze_phys2[ZeIndex] = cy_pci_phys2;
-					Ze_addr0[ZeIndex] = cy_pci_addr0;
-					Ze_addr2[ZeIndex] = cy_pci_addr2;
-					Ze_irq[ZeIndex] = cy_pci_irq;
-					Ze_pdev[ZeIndex] = pdev;
-					ZeIndex++;
-				}
-				i--;
+				retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2,
+						cy_pci_addr0, cy_pci_irq, pdev);
+				if (retval < 0)
+					i--;
 				continue;
 			} else {
 				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
@@ -5168,32 +5151,6 @@ static int __init cy_detect_pci(void)
 		}
 	}
 
-	for (; ZeIndex != 0 && i < NR_CARDS; i++) {
-		cy_pci_phys0 = Ze_phys0[0];
-		cy_pci_phys2 = Ze_phys2[0];
-		cy_pci_addr0 = Ze_addr0[0];
-		cy_pci_addr2 = Ze_addr2[0];
-		cy_pci_irq = Ze_irq[0];
-		pdev = Ze_pdev[0];
-		for (j = 0; j < ZeIndex - 1; j++) {
-			Ze_phys0[j] = Ze_phys0[j + 1];
-			Ze_phys2[j] = Ze_phys2[j + 1];
-			Ze_addr0[j] = Ze_addr0[j + 1];
-			Ze_addr2[j] = Ze_addr2[j + 1];
-			Ze_irq[j] = Ze_irq[j + 1];
-			Ze_pdev[j] = Ze_pdev[j + 1];
-		}
-		ZeIndex--;
-		retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2, cy_pci_addr0,
-					cy_pci_addr2, cy_pci_irq, pdev);
-		if (retval < 0)
-			return i;
-	}
-	if (ZeIndex != 0) {
-		printk("Cyclades-Ze/PCI found at 0x%x but no more cards can be "
-			"used.\nChange NR_CARDS in cyclades.c and recompile "
-			"kernel.\n", (unsigned int)Ze_phys2[0]);
-	}
 	return i;
 #else
 	return 0;

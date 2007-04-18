Return-Path: <linux-kernel-owner+w=401wt.eu-S1422762AbXDRKDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422762AbXDRKDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422764AbXDRKDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:03:14 -0400
Received: from av1.karneval.cz ([81.27.192.123]:11681 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422762AbXDRKDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:03:13 -0400
Message-id: <2428225437641930190@karneval.cz>
Subject: [PATCH 1/11] Char: cyclades, create cy_init_Ze
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:03:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, create cy_init_Ze

Move Ze init code into new cy_init_Ze, because we will need it in another
place and it will make the code totally unreadable.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 1cd1f5e029963fc449c4f84495770611e5c35297
tree a81b2b0a68303d8dfe616edc4c12c9030723ca12
parent 6f42cfdf174bdd2c05edf7d192713042bf25339c
author Jiri Slaby <jirislaby@gmail.com> Tue, 27 Mar 2007 11:25:47 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:47:56 +0200

 drivers/char/cyclades.c |  163 ++++++++++++++++++++++++++---------------------
 1 files changed, 90 insertions(+), 73 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index abdc3c7..26d9ea7 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4711,6 +4711,92 @@ static void plx_init(void __iomem * addr, __u32 initctl)
 	cy_writel(addr + initctl, readl(addr + initctl) & ~0x20000000);
 }
 
+static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
+		unsigned long cy_pci_phys2,
+		struct RUNTIME_9060 __iomem *cy_pci_addr0,
+		void __iomem *cy_pci_addr2, int cy_pci_irq,
+		struct pci_dev *pdev)
+{
+	unsigned int j;
+	unsigned short cy_pci_nchan;
+
+	readl(&cy_pci_addr0->mail_box_0);
+#ifdef CY_PCI_DEBUG
+	printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
+		(ulong)cy_pci_addr2, (ulong)cy_pci_addr0);
+	printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not "
+			"loaded\n");
+#endif
+	/* This must be the new Cyclades-Ze/PCI. */
+	cy_pci_nchan = ZE_V1_NPORTS;
+
+	if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
+		printk("Cyclades-Ze/PCI found at 0x%lx but no channels "
+			"are available.\nChange NR_PORTS in cyclades.c "
+			"and recompile kernel.\n",
+			(ulong) cy_pci_phys2);
+		return -EIO;
+	}
+
+	/* fill the next cy_card structure available */
+	for (j = 0; j < NR_CARDS; j++) {
+		if (cy_card[j].base_addr == 0)
+			break;
+	}
+	if (j == NR_CARDS) {	/* no more cy_cards available */
+		printk("Cyclades-Ze/PCI found at 0x%lx but no more "
+			"cards can be used.\nChange NR_CARDS in "
+			"cyclades.c and recompile kernel.\n",
+			(ulong) cy_pci_phys2);
+		return -EIO;
+	}
+#ifdef CONFIG_CYZ_INTR
+	/* allocate IRQ only if board has an IRQ */
+	if ((cy_pci_irq != 0) && (cy_pci_irq != 255)) {
+		if (request_irq(cy_pci_irq, cyz_interrupt,
+				IRQF_SHARED, "Cyclades-Z",
+				&cy_card[j])) {
+			printk("Cyclom-Ze/PCI found at 0x%lx ",
+				(ulong) cy_pci_phys2);
+			printk("but could not allocate IRQ%d.\n",
+				cy_pci_irq);
+			return -EIO;
+		}
+	}
+#endif				/* CONFIG_CYZ_INTR */
+
+	/* set cy_card */
+	cy_card[j].base_phys = cy_pci_phys2;
+	cy_card[j].ctl_phys = cy_pci_phys0;
+	cy_card[j].base_addr = cy_pci_addr2;
+	cy_card[j].ctl_addr = cy_pci_addr0;
+	cy_card[j].irq = (int)cy_pci_irq;
+	cy_card[j].bus_index = 1;
+	cy_card[j].first_line = cy_next_channel;
+	cy_card[j].num_chips = -1;
+	cy_card[j].pdev = pdev;
+
+	/* print message */
+#ifdef CONFIG_CYZ_INTR
+	/* don't report IRQ if board is no IRQ */
+	if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
+		printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
+			j + 1, (ulong) cy_pci_phys2,
+			(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1),
+			(int)cy_pci_irq);
+	else
+#endif				/* CONFIG_CYZ_INTR */
+		printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, ",
+			j + 1, (ulong) cy_pci_phys2,
+			(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1));
+
+	printk("%d channels starting from port %d.\n",
+		cy_pci_nchan, cy_next_channel);
+	cy_next_channel += cy_pci_nchan;
+
+	return 0;
+}
+
 /*
  * ---------------------------------------------------------------------
  * cy_detect_pci() - Test PCI bus presence and Cyclom-Ye/PCI.
@@ -4734,6 +4820,7 @@ static int __init cy_detect_pci(void)
 	__u32 Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
 	unsigned char Ze_irq[NR_CARDS];
 	struct pci_dev *Ze_pdev[NR_CARDS];
+	int retval;
 
 	for (i = 0; i < NR_CARDS; i++) {
 		/* look for a Cyclades card by vendor and device id */
@@ -5095,80 +5182,10 @@ static int __init cy_detect_pci(void)
 			Ze_pdev[j] = Ze_pdev[j + 1];
 		}
 		ZeIndex--;
-		mailbox = (__u32)readl(&((struct RUNTIME_9060 __iomem *)
-						cy_pci_addr0)->mail_box_0);
-#ifdef CY_PCI_DEBUG
-		printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
-			(ulong)cy_pci_addr2, (ulong)cy_pci_addr0);
-		printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not "
-				"loaded\n");
-#endif
-		/* This must be the new Cyclades-Ze/PCI. */
-		cy_pci_nchan = ZE_V1_NPORTS;
-
-		if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-			printk("Cyclades-Ze/PCI found at 0x%lx but no channels "
-				"are available.\nChange NR_PORTS in cyclades.c "
-				"and recompile kernel.\n",
-				(ulong) cy_pci_phys2);
-			return i;
-		}
-
-		/* fill the next cy_card structure available */
-		for (j = 0; j < NR_CARDS; j++) {
-			if (cy_card[j].base_addr == 0)
-				break;
-		}
-		if (j == NR_CARDS) {	/* no more cy_cards available */
-			printk("Cyclades-Ze/PCI found at 0x%lx but no more "
-				"cards can be used.\nChange NR_CARDS in "
-				"cyclades.c and recompile kernel.\n",
-				(ulong) cy_pci_phys2);
+		retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2, cy_pci_addr0,
+					cy_pci_addr2, cy_pci_irq, pdev);
+		if (retval < 0)
 			return i;
-		}
-#ifdef CONFIG_CYZ_INTR
-		/* allocate IRQ only if board has an IRQ */
-		if ((cy_pci_irq != 0) && (cy_pci_irq != 255)) {
-			if (request_irq(cy_pci_irq, cyz_interrupt,
-					IRQF_SHARED, "Cyclades-Z",
-					&cy_card[j])) {
-				printk("Cyclom-Ze/PCI found at 0x%lx ",
-					(ulong) cy_pci_phys2);
-				printk("but could not allocate IRQ%d.\n",
-					cy_pci_irq);
-				return i;
-			}
-		}
-#endif				/* CONFIG_CYZ_INTR */
-
-		/* set cy_card */
-		cy_card[j].base_phys = cy_pci_phys2;
-		cy_card[j].ctl_phys = cy_pci_phys0;
-		cy_card[j].base_addr = cy_pci_addr2;
-		cy_card[j].ctl_addr = cy_pci_addr0;
-		cy_card[j].irq = (int)cy_pci_irq;
-		cy_card[j].bus_index = 1;
-		cy_card[j].first_line = cy_next_channel;
-		cy_card[j].num_chips = -1;
-		cy_card[j].pdev = pdev;
-
-		/* print message */
-#ifdef CONFIG_CYZ_INTR
-		/* don't report IRQ if board is no IRQ */
-		if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
-			printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
-				j + 1, (ulong) cy_pci_phys2,
-				(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1),
-				(int)cy_pci_irq);
-		else
-#endif				/* CONFIG_CYZ_INTR */
-			printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, ",
-				j + 1, (ulong) cy_pci_phys2,
-				(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1));
-
-		printk("%d channels starting from port %d.\n",
-			cy_pci_nchan, cy_next_channel);
-		cy_next_channel += cy_pci_nchan;
 	}
 	if (ZeIndex != 0) {
 		printk("Cyclades-Ze/PCI found at 0x%x but no more cards can be "

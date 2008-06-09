Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbYFIKOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbYFIKOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760290AbYFIKNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:13:42 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:58570 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760274AbYFIKNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:13:41 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: mxser, prints cleanup
Date: Mon,  9 Jun 2008 12:08:30 +0200
Message-Id: <1213006112-25965-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
References: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- use dev_* for printing in pci probe function
- move ISA p[rints directly into isa find function, do not postpone it.
  Remove macros bound to it then.
- prepend some prints by "mxser: " to know what it belongs to

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |   80 +++++++++++++++++++++++---------------------------
 1 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 060fee9..800b609 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -55,11 +55,6 @@
 #define MXSER_PORTS		(MXSER_BOARDS * MXSER_PORTS_PER_BOARD)
 #define MXSER_ISR_PASS_LIMIT	100
 
-#define	MXSER_ERR_IOADDR	-1
-#define	MXSER_ERR_IRQ		-2
-#define	MXSER_ERR_IRQ_CONFLIT	-3
-#define	MXSER_ERR_VECTOR	-4
-
 /*CheckIsMoxaMust return value*/
 #define MOXA_OTHER_UART		0x00
 #define MOXA_MUST_MU150_HWID	0x01
@@ -2490,7 +2485,8 @@ static int __devinit mxser_initbrd(struct mxser_board *brd,
 	unsigned int i;
 	int retval;
 
-	printk(KERN_INFO "max. baud rate = %d bps.\n", brd->ports[0].max_baud);
+	printk(KERN_INFO "mxser: max. baud rate = %d bps\n",
+			brd->ports[0].max_baud);
 
 	for (i = 0; i < brd->info->nports; i++) {
 		info = &brd->ports[i];
@@ -2573,28 +2569,32 @@ static int __init mxser_get_ISA_conf(int cap, struct mxser_board *brd)
 		irq = regs[9] & 0xF000;
 		irq = irq | (irq >> 4);
 		if (irq != (regs[9] & 0xFF00))
-			return MXSER_ERR_IRQ_CONFLIT;
+			goto err_irqconflict;
 	} else if (brd->info->nports == 4) {
 		irq = regs[9] & 0xF000;
 		irq = irq | (irq >> 4);
 		irq = irq | (irq >> 8);
 		if (irq != regs[9])
-			return MXSER_ERR_IRQ_CONFLIT;
+			goto err_irqconflict;
 	} else if (brd->info->nports == 8) {
 		irq = regs[9] & 0xF000;
 		irq = irq | (irq >> 4);
 		irq = irq | (irq >> 8);
 		if ((irq != regs[9]) || (irq != regs[10]))
-			return MXSER_ERR_IRQ_CONFLIT;
+			goto err_irqconflict;
 	}
 
-	if (!irq)
-		return MXSER_ERR_IRQ;
+	if (!irq) {
+		printk(KERN_ERR "mxser: interrupt number unset\n");
+		return -EIO;
+	}
 	brd->irq = ((int)(irq & 0xF000) >> 12);
 	for (i = 0; i < 8; i++)
 		brd->ports[i].ioaddr = (int) regs[i + 1] & 0xFFF8;
-	if ((regs[12] & 0x80) == 0)
-		return MXSER_ERR_VECTOR;
+	if ((regs[12] & 0x80) == 0) {
+		printk(KERN_ERR "mxser: invalid interrupt vector\n");
+		return -EIO;
+	}
 	brd->vector = (int)regs[11];	/* interrupt vector */
 	if (id == 1)
 		brd->vector_mask = 0x00FF;
@@ -2621,13 +2621,26 @@ static int __init mxser_get_ISA_conf(int cap, struct mxser_board *brd)
 	else
 		brd->uart_type = PORT_16450;
 	if (!request_region(brd->ports[0].ioaddr, 8 * brd->info->nports,
-			"mxser(IO)"))
-		return MXSER_ERR_IOADDR;
+			"mxser(IO)")) {
+		printk(KERN_ERR "mxser: can't request ports I/O region: "
+				"0x%.8lx-0x%.8lx\n",
+				brd->ports[0].ioaddr, brd->ports[0].ioaddr +
+				8 * brd->info->nports - 1);
+		return -EIO;
+	}
 	if (!request_region(brd->vector, 1, "mxser(vector)")) {
 		release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
-		return MXSER_ERR_VECTOR;
+		printk(KERN_ERR "mxser: can't request interrupt vector region: "
+				"0x%.8lx-0x%.8lx\n",
+				brd->ports[0].ioaddr, brd->ports[0].ioaddr +
+				8 * brd->info->nports - 1);
+		return -EIO;
 	}
 	return brd->info->nports;
+
+err_irqconflict:
+	printk(KERN_ERR "mxser: invalid interrupt number\n");
+	return -EIO;
 }
 
 static int __devinit mxser_probe(struct pci_dev *pdev,
@@ -2644,20 +2657,20 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
 			break;
 
 	if (i >= MXSER_BOARDS) {
-		printk(KERN_ERR "Too many Smartio/Industio family boards found "
-			"(maximum %d), board not configured\n", MXSER_BOARDS);
+		dev_err(&pdev->dev, "too many boards found (maximum %d), board "
+				"not configured\n", MXSER_BOARDS);
 		goto err;
 	}
 
 	brd = &mxser_boards[i];
 	brd->idx = i * MXSER_PORTS_PER_BOARD;
-	printk(KERN_INFO "Found MOXA %s board (BusNo=%d, DevNo=%d)\n",
+	dev_info(&pdev->dev, "found MOXA %s board (BusNo=%d, DevNo=%d)\n",
 		mxser_cards[ent->driver_data].name,
 		pdev->bus->number, PCI_SLOT(pdev->devfn));
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
-		printk(KERN_ERR "Moxa SmartI/O PCI enable fail !\n");
+		dev_err(&pdev->dev, "PCI enable failed\n");
 		goto err;
 	}
 
@@ -2807,33 +2820,14 @@ static int __init mxser_module_init(void)
 
 			brd = &mxser_boards[m];
 			retval = mxser_get_ISA_conf(cap, brd);
-
-			if (retval != 0)
-				printk(KERN_INFO "Found MOXA %s board "
-					"(CAP=0x%x)\n",
-					brd->info->name, ioaddr[b]);
-
 			if (retval <= 0) {
-				if (retval == MXSER_ERR_IRQ)
-					printk(KERN_ERR "Invalid interrupt "
-						"number, board not "
-						"configured\n");
-				else if (retval == MXSER_ERR_IRQ_CONFLIT)
-					printk(KERN_ERR "Invalid interrupt "
-						"number, board not "
-						"configured\n");
-				else if (retval == MXSER_ERR_VECTOR)
-					printk(KERN_ERR "Invalid interrupt "
-						"vector, board not "
-						"configured\n");
-				else if (retval == MXSER_ERR_IOADDR)
-					printk(KERN_ERR "Invalid I/O address, "
-						"board not configured\n");
-
 				brd->info = NULL;
 				continue;
 			}
 
+			printk(KERN_INFO "mxser: found MOXA %s board "
+				"(CAP=0x%x)\n",	brd->info->name, ioaddr[b]);
+
 			/* mxser_initbrd will hook ISR. */
 			if (mxser_initbrd(brd, NULL) < 0) {
 				brd->info = NULL;
@@ -2850,7 +2844,7 @@ static int __init mxser_module_init(void)
 
 	retval = pci_register_driver(&mxser_driver);
 	if (retval) {
-		printk(KERN_ERR "Can't register pci driver\n");
+		printk(KERN_ERR "mxser: can't register pci driver\n");
 		if (!m) {
 			retval = -ENODEV;
 			goto err_unr;
-- 
1.5.4.5


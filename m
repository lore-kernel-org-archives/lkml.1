Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbYKFUP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbYKFUP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYKFUPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:15:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54868 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYKFUPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:15:19 -0500
Date: Thu, 6 Nov 2008 20:15:01 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Lee Howard <lee.howard@mainpine.com>
Cc: "'Peter Alfredsen'" <loki_val@gentoo.org>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3
Message-ID: <20081106201501.GB28514@flint.arm.linux.org.uk>
References: <20081106174341.GA8155@xolotl.n0ano.com> <200811061952.37490.loki_val@gentoo.org> <20081106191250.GA28514@flint.arm.linux.org.uk> <AA46BE34D4E74CB69F948F36984126A9@callisto>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AA46BE34D4E74CB69F948F36984126A9@callisto>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 11:39:44AM -0800, Lee Howard wrote:
> The "hack" originates from code done by Oxford Semiconductor.  I would be
> happy to have it done with the quirk system, and I am willing to write a
> patch to that effect.  My guess, however, would be that I'll still not do it
> in your favorite way, and so I'm asking if you would like me to write the
> code change or will you (or someone else here familiar with the favorite
> ways) do it?

There's plenty of examples in there, eg, pci_timedia_init, pci_netmos_init,
and pci_ite887x_init all have a variable number of ports.  Here's a patch
which converts it:

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 5450a0e..057b532 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -737,6 +737,38 @@ static void __devexit pci_ite887x_exit(struct pci_dev *dev)
 	release_region(ioport, ITE_887x_IOSIZE);
 }
 
+/*
+ * Oxford Semiconductor Inc.
+ * Check that device is part of the Tornado range of devices, then determine
+ * the number of ports available on the device.
+ */
+static int pci_oxsemi_tornado_init(struct pci_dev *dev)
+{
+	u8 __iomem *p;
+	unsigned long deviceID;
+	unsigned int  number_uarts = 0;
+
+	/* OxSemi Tornado devices are all 0xCxxx */
+	if (dev->vendor == PCI_VENDOR_ID_OXSEMI &&
+	    (dev->device & 0xF000) != 0xC000)
+		return 0;
+
+	p = pci_iomap(dev, 0, 5);
+	if (p == NULL)
+		return -ENOMEM;
+
+	deviceID = ioread32(p);
+	/* Tornado device */
+	if (deviceID == 0x07000200) {
+		number_uarts = ioread8(p + 4);
+		printk(KERN_DEBUG
+			"%d ports detected on Oxford PCI Express device\n",
+								number_uarts);
+	}
+	pci_iounmap(dev, p);
+	return number_uarts;
+}
+
 static int
 pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
 		  struct uart_port *port, int idx)
@@ -1018,6 +1050,25 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.setup		= pci_default_setup,
 	},
 	/*
+	 * For Oxford Semiconductor and Mainpine
+	 */
+	{
+		.vendor		= PCI_VENDOR_ID_OXSEMI,
+		.device		= PCI_ANY_ID,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_default_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_MAINPINE,
+		.device		= PCI_ANY_ID,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_oxsemi_tornado_init,
+		.setup		= pci_default_setup,
+	},
+	/*
 	 * Default "match everything" terminator entry
 	 */
 	{
@@ -1854,39 +1905,6 @@ serial_pci_matches(struct pciserial_board *board,
 	    board->first_offset == guessed->first_offset;
 }
 
-/*
- * Oxford Semiconductor Inc.
- * Check that device is part of the Tornado range of devices, then determine
- * the number of ports available on the device.
- */
-static int pci_oxsemi_tornado_init(struct pci_dev *dev, struct pciserial_board *board)
-{
-	u8 __iomem *p;
-	unsigned long deviceID;
-	unsigned int  number_uarts;
-
-	/* OxSemi Tornado devices are all 0xCxxx */
-	if (dev->vendor == PCI_VENDOR_ID_OXSEMI &&
-	    (dev->device & 0xF000) != 0xC000)
-		return 0;
-
-	p = pci_iomap(dev, 0, 5);
-	if (p == NULL)
-		return -ENOMEM;
-
-	deviceID = ioread32(p);
-	/* Tornado device */
-	if (deviceID == 0x07000200) {
-		number_uarts = ioread8(p + 4);
-		board->num_ports = number_uarts;
-		printk(KERN_DEBUG
-			"%d ports detected on Oxford PCI Express device\n",
-								number_uarts);
-	}
-	pci_iounmap(dev, p);
-	return 0;
-}
-
 struct serial_private *
 pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board)
 {
@@ -1895,13 +1913,6 @@ pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board)
 	struct pci_serial_quirk *quirk;
 	int rc, nr_ports, i;
 
-	/*
-	 * Find number of ports on board
-	 */
-	if (dev->vendor == PCI_VENDOR_ID_OXSEMI ||
-	    dev->vendor == PCI_VENDOR_ID_MAINPINE)
-		pci_oxsemi_tornado_init(dev, board);
-
 	nr_ports = board->num_ports;
 
 	/*

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

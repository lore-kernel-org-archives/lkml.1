Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYKGGHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYKGGHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYKGGG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:06:59 -0500
Received: from mail.mainpine.com ([216.235.106.114]:37568 "EHLO
	mail.mainpine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYKGGG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:06:58 -0500
Reply-To: <lee.howard@mainpine.com>
From: "Lee Howard" <lee.howard@mainpine.com>
To: "'Russell King'" <rmk+lkml@arm.linux.org.uk>
Cc: "'Peter Alfredsen'" <loki_val@gentoo.org>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>
References: <20081106174341.GA8155@xolotl.n0ano.com> <200811061952.37490.loki_val@gentoo.org> <20081106191250.GA28514@flint.arm.linux.org.uk> <AA46BE34D4E74CB69F948F36984126A9@callisto> <20081106201501.GB28514@flint.arm.linux.org.uk>
Subject: RE: Is the PCI serial driver code GPL v2 or v3
Date: Thu, 6 Nov 2008 22:06:51 -0800
Organization: Mainpine
Message-ID: <C343CF1D29E44E63AB4E2A5BE7511916@callisto>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AclATGYDf5Vebb0TRCS2U8VSXSXgRQAUo5qw
In-Reply-To: <20081106201501.GB28514@flint.arm.linux.org.uk>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This works for me.  Do I need to do anything else to see this committed?

Thank you,

Lee.


Lee Howard
Mainpine, Inc. Software Development Lead
Tel: +1 866 363 6680 ext 805 | Fax: +1 360 462 8160
lee.howard@mainpine.com | www.mainpine.com

-----Original Message-----
From: Russell King [mailto:rmk@arm.linux.org.uk] On Behalf Of Russell King
Sent: Thursday, November 06, 2008 12:15 PM
To: Lee Howard
Cc: 'Peter Alfredsen'; 'Alan Cox'; linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3

On Thu, Nov 06, 2008 at 11:39:44AM -0800, Lee Howard wrote:
> The "hack" originates from code done by Oxford Semiconductor.  I would 
> be happy to have it done with the quirk system, and I am willing to 
> write a patch to that effect.  My guess, however, would be that I'll 
> still not do it in your favorite way, and so I'm asking if you would 
> like me to write the code change or will you (or someone else here 
> familiar with the favorite
> ways) do it?

There's plenty of examples in there, eg, pci_timedia_init, pci_netmos_init,
and pci_ite887x_init all have a variable number of ports.  Here's a patch
which converts it:

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c index
5450a0e..057b532 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -737,6 +737,38 @@ static void __devexit pci_ite887x_exit(struct pci_dev
*dev)
 	release_region(ioport, ITE_887x_IOSIZE);  }
 
+/*
+ * Oxford Semiconductor Inc.
+ * Check that device is part of the Tornado range of devices, then 
+determine
+ * the number of ports available on the device.
+ */
+static int pci_oxsemi_tornado_init(struct pci_dev *dev) {
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
+
number_uarts);
+	}
+	pci_iounmap(dev, p);
+	return number_uarts;
+}
+
 static int
 pci_default_setup(struct serial_private *priv, struct pciserial_board
*board,
 		  struct uart_port *port, int idx)
@@ -1018,6 +1050,25 @@ static struct pci_serial_quirk pci_serial_quirks[]
__refdata = {
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
 	    board->first_offset == guessed->first_offset;  }
 
-/*
- * Oxford Semiconductor Inc.
- * Check that device is part of the Tornado range of devices, then
determine
- * the number of ports available on the device.
- */
-static int pci_oxsemi_tornado_init(struct pci_dev *dev, struct
pciserial_board *board) -{
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
-
number_uarts);
-	}
-	pci_iounmap(dev, p);
-	return 0;
-}
-
 struct serial_private *
 pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board)  {
@@ -1895,13 +1913,6 @@ pciserial_init_ports(struct pci_dev *dev, struct
pciserial_board *board)
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


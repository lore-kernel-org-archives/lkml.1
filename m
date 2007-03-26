Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbXCZOYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbXCZOYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 10:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXCZOYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 10:24:46 -0400
Received: from truxi.wincor-nixdorf.com ([217.115.67.78]:60090 "EHLO
	truxi.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbXCZOYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 10:24:44 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2007 10:24:44 EDT
Date: Mon, 26 Mar 2007 16:17:02 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
To: rmk+serial@arm.linux.org.uk, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for ITE887x serial chipsets
Message-ID: <20070326141702.GA28306@deexvs01.wincor-nixdorf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the Super I/O 887x-chipsets of ITE, are currently not completely
supported. Only parport_pc has the ability to activate the (optional)
parallel port. This patch adds support for the serial ports.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>

--- linux-2.6.20.3/drivers/serial/8250_pci.c.orig	2007-03-13 19:27:08.000000000 +0100
+++ linux-2.6.20.3/drivers/serial/8250_pci.c	2007-03-26 15:42:17.000000000 +0200
@@ -581,6 +581,174 @@ static int pci_netmos_init(struct pci_de
 	return num_serial;
 }
 
+/*
+ * ITE support by Niels de Vos <niels.devos@wincor-nixdorf.com>
+ */
+
+static int __devinit pci_ite887x_init(struct pci_dev *dev)
+{
+	/* inta_addr are the configuration addresses of the ITE */
+	short inta_addr[] = { 0x2a0, 0x2c0, 0x220, 0x240, 0x1E0, 0x200,
+								0x280, 0 };
+	int ret, i, type;
+	struct resource *iobase;
+
+	/* search for the base-ioport */
+	i = 0;
+	while (inta_addr[i] && dev->dev.driver_data != NULL) {
+		dev->dev.driver_data = request_region(inta_addr[i], 32,
+								"ite887x");
+		if (dev->dev.driver_data != NULL) {
+			/* write POSIO0R - speed | size | ioport */
+			pci_write_config_dword(dev, 0x60,
+						0xe5000000 | inta_addr[i]);
+			/* write INTCBAR - ioport */
+			pci_write_config_dword(dev, 0x78, inta_addr[i]);
+			ret = inb(inta_addr[i]);
+			if (ret != 0xff) {
+				/* ioport connected */
+				break;
+			}
+			release_resource(dev->dev.driver_data);
+			dev->dev.driver_data = NULL;
+		}
+		i++;
+	}
+
+	if (! inta_addr[i]) {
+		printk(KERN_ERR "ite887x: could not find iobase\n");
+		return -ENODEV;
+	}
+
+	iobase = dev->dev.driver_data;
+
+	/* start of undocumented type checking (see parport_pc.c) */
+	type = inb(iobase->start + 0x18);
+	type &= 0x0f;
+
+	switch (type) {
+	case 0x2:
+		printk(KERN_DEBUG "8250_pci: ITE8871 found (1P)\n");
+		break;
+	case 0xa:
+		printk(KERN_DEBUG "8250_pci: ITE8875 found (1P)\n");
+		break;
+	case 0xe:
+		printk(KERN_INFO "8250_pci: ITE8872 found (2S1P)\n");
+		return 2;
+	case 0x6:
+		printk(KERN_INFO "8250_pci: ITE8873 found (1S)\n");
+		return 1;
+	case 0x8:
+		printk(KERN_INFO "8250_pci: ITE8874 found (2S)\n");
+		return 2;
+	default:
+		moan_device("unknown ITE887x", dev);
+	}
+
+	/* the device has no UARTs if we get here */
+	release_resource(iobase);
+	dev->dev.driver_data = NULL;
+	return -ENODEV;
+}
+
+/*
+ * activate the UART in the MISCR
+ */
+static int
+pci_ite887x_setup(struct serial_private *priv, struct pciserial_board *board,
+		  struct uart_port *port, int idx)
+{
+	int ret;
+	struct pci_dev *dev = priv->dev;
+	u32 miscr, uartbar, ioport;
+	/* iobase is the private driver_data */
+	struct resource *iobase;
+	/* registers */
+	unsigned short MISCR = 0x9c, UARTBAR = 0x7c;
+	unsigned short PS1BAR = 0x14, POSIO1 = 0x64;
+
+	/* enable IO_Space bit */
+	u32 POSIO_ENABLE = 1 << 31;
+	/* Decoding speed (1 = slow, 2 = medium, 3 = fast) */
+	u32 POSIO_SPEED = 3 << 29;	
+
+	iobase = (struct resource*) dev->dev.driver_data;
+	if (iobase == NULL) {
+		printk(KERN_ERR "ite887x: iobase is not available\n");
+		return -ENODEV;
+	}
+
+	/* read the I/O port from the device */
+	ret = pci_read_config_dword(dev, PS1BAR + (0x4 * idx), &ioport);
+	if (ret) {
+		printk(KERN_ERR "ite887x: read error PS%dBAR\n", idx + 1);
+		ret = -ENODEV;
+		goto release_inta;
+	}
+
+	ioport &= 0x0000FF00;	/* the actual I/O space base address */
+	ret = pci_write_config_dword(dev, POSIO1 + (0x4 * idx),
+				POSIO_ENABLE | POSIO_SPEED | ioport);
+	if (ret) {
+		printk(KERN_ERR "ite887x: write error PSIO%d+\n", idx + 1);
+		ret = -ENODEV;
+		goto release_inta;
+	}
+
+	/* write the ioport to the UARTBAR */
+	ret = pci_read_config_dword(dev, UARTBAR, &uartbar);
+	if (ret) {
+		printk(KERN_ERR "ite887x: read error UARTBAR\n");
+		ret = -ENODEV;
+		goto release_inta;
+	}
+	uartbar &= ~(15 << (4 * idx));		/* clear half the reg */
+	uartbar |= ioport << (16 * idx);	/* set the ioport */
+	ret = pci_write_config_dword(dev, UARTBAR, uartbar);
+	if (ret) {
+		printk(KERN_ERR "ite887x: write error UARTBAR\n");
+		ret = -ENODEV;
+		goto release_inta;
+	}
+
+	/* get current config */
+	ret = pci_read_config_dword(dev, MISCR, &miscr);
+	if (ret) {
+		printk(KERN_ERR "ite887x: read error MISCR\n");
+		ret = -ENODEV;
+		goto release_inta;
+	}
+
+	/* disable interrupts (UARTx_Routing[3:0]) */
+	miscr &= ~(0xf << (12 - 4 * idx));
+	/* activate the UART (UARTx_En) */
+	miscr |= 1 << (23 - idx);
+
+	/* write new config with activated UART */
+	ret = pci_write_config_dword(dev, MISCR, miscr);
+	if (ret) {
+		printk(KERN_ERR "ite887x: write error MISCR\n");
+		ret = -ENODEV;
+		goto release_inta;
+	}
+
+	/* idx + 1: using POSIO1 and up */
+	return setup_port(priv, port, idx + 1, board->first_offset, 0);
+
+release_inta:
+	/* release region again if we get here */
+	release_resource(iobase);
+	dev->dev.driver_data = NULL;
+	return ret;
+}
+
+static void __devexit pci_ite887x_exit(struct pci_dev *dev)
+{
+	/* free the private driver data */
+	release_resource(((struct resource*) dev->dev.driver_data));
+}
+
 static int
 pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
 		  struct uart_port *port, int idx)
@@ -654,6 +822,18 @@ static struct pci_serial_quirk pci_seria
 		.setup		= pci_default_setup,
 	},
 	/*
+	 * ITE
+	 */
+	{
+		.vendor		= PCI_VENDOR_ID_ITE,
+		.device		= PCI_DEVICE_ID_ITE_8872,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ite887x_init,
+		.setup		= pci_ite887x_setup,
+		.exit		= __devexit_p(pci_ite887x_exit),
+	},
+	/*
 	 * Panacom
 	 */
 	{
@@ -968,6 +1148,7 @@ enum pci_board_num_t {
 	pbn_plx_romulus,
 	pbn_oxsemi,
 	pbn_intel_i960,
+	pbn_ite_887x,
 	pbn_sgi_ioc3,
 	pbn_nec_nile4,
 	pbn_computone_4,
@@ -1430,6 +1611,15 @@ static struct pciserial_board pci_boards
 	},
 
 	/*
+	 * ITE
+	 */
+	[pbn_ite_887x] = {
+                .flags          = FL_BASE0 | FL_BASE_BARS,
+                .base_baud      = 115200,
+                .uart_offset    = 8,
+        },
+
+	/*
 	 * NEC Vrc-5074 (Nile 4) builtin UART.
 	 */
 	[pbn_nec_nile4] = {
@@ -2370,6 +2560,13 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_TOPIC, PCI_DEVICE_ID_TOPIC_TP560,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_1_115200 },
+	/*
+	 * ITE
+	 */
+	{	PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8872,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_ite_887x },	
 
 	/*
 	 * IntaShield IS-200


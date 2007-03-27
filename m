Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbXC0ODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbXC0ODy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXC0ODy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:03:54 -0400
Received: from trixi.wincor-nixdorf.com ([217.115.67.77]:36598 "EHLO
	trixi.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbXC0ODw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:03:52 -0400
Date: Tue, 27 Mar 2007 16:03:03 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
To: Russell King <rmk+serial@arm.linux.org.uk>, Andrey Panin <pazke@donpac.ru>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for ITE887x serial chipsets
Message-ID: <20070327140303.GA11233@deexvs01.wincor-nixdorf.com>
References: <20070326141702.GA28306@deexvs01.wincor-nixdorf.com> <20070326201705.GA14403@pazke.donpac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326201705.GA14403@pazke.donpac.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Super I/O 887x-chipsets of ITE, are currently not completely
supported. This patch adds support for the serial ports of several
ITE 887x chips.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>

---
Thanks Russell and Andrey for your comments. I've taken your suggestions
into account and reworked the patch. All release_resource()'s are replaced
by release_region() to free up the I/O ports. 

> > +	/* inta_addr are the configuration addresses of the ITE */
> > +	short inta_addr[] = { 0x2a0, 0x2c0, 0x220, 0x240, 0x1E0, 0x200,
> > +								0x280, 0 };
> 
> static const, please.

Done.

> > +	if (! inta_addr[i]) {
> 	     ^
> Please remove space after !

Ofcourse.

> > +	/* start of undocumented type checking (see parport_pc.c) */
> > +	type = inb(iobase->start + 0x18);
> > +	type &= 0x0f;
> 
> Why not:
> type = inb(iobase->start + 0x18) & 0x0f;

Yes, no need to know type before & 0xf.

> > +	switch (type) {
> > +	case 0x2:
> > +		printk(KERN_DEBUG "8250_pci: ITE8871 found (1P)\n");
> > +		break;
> > +	case 0xa:
> > +		printk(KERN_DEBUG "8250_pci: ITE8875 found (1P)\n");
> > +		break;
> > +	case 0xe:
> > +		printk(KERN_INFO "8250_pci: ITE8872 found (2S1P)\n");
> > +		return 2;
> > +	case 0x6:
> > +		printk(KERN_INFO "8250_pci: ITE8873 found (1S)\n");
> > +		return 1;
> > +	case 0x8:
> > +		printk(KERN_INFO "8250_pci: ITE8874 found (2S)\n");
> > +		return 2;
> > +	default:
> > +		moan_device("unknown ITE887x", dev);
> > +	}
> 
> These printk's are not needed IMHO.

You're correct. These come directly from parport_pc. Now removed.

> > +	iobase = (struct resource*) dev->dev.driver_data;
> > +	if (iobase == NULL) {
> > +		printk(KERN_ERR "ite887x: iobase is not available\n");
> > +		return -ENODEV;
> > +	}
> 
> Is this check really needed ? I can't see how you can enter this function
> with dev->dev.driver_data == NULL.

No need, and not anymore either. Rewrote the .init so that .setup is not
needed anymore. Russell suggested this solution to keep it cleaner.


> > +	/* read the I/O port from the device */
> > +	ret = pci_read_config_dword(dev, PS1BAR + (0x4 * idx), &ioport);
> > +	if (ret) {
> 
> Checking return value of pci_read_config_XXX/pci_write_config_XXX is (almost ?)
> useless and only complicates things.

Okay, lot's of other drivers also don't check this. Removed.

> >  	/*
> > +	 * ITE
> > +	 */
> > +	[pbn_ite_887x] = {
> > +                .flags          = FL_BASE0 | FL_BASE_BARS,
> > +                .base_baud      = 115200,
> > +                .uart_offset    = 8,
> > +        },
> 
> IMHO this is not needed. You can use pbn_b0_bt_2_115200 or pbn_b0_bt_1_115200,
> since quirks will be used anyway.

I've added pbn_b1_bt_1_115200 now, Russells remark.


--- linux-2.6.20.3/drivers/serial/8250_pci.c.orig	2007-03-13 19:27:08.000000000 +0100
+++ linux-2.6.20.3/drivers/serial/8250_pci.c	2007-03-27 14:59:47.000000000 +0200
@@ -581,6 +581,137 @@ static int pci_netmos_init(struct pci_de
 	return num_serial;
 }
 
+/*
+ * ITE support by Niels de Vos <niels.devos@wincor-nixdorf.com>
+ *
+ * These chips are available with optionally one parallel port and up to
+ * two serial ports. Unfortunately they all have the same product id.
+ *
+ * Basic configuration is done over a region of 32 I/O ports. The base
+ * ioport is called INTA or INTC, depending on docs/other drivers.
+ *
+ * The region of the 32 I/O ports is configured in POSIO0R...
+ */
+
+/* registers */
+#define ITE_887x_MISCR		0x9c
+#define ITE_887x_INTCBAR	0x78
+#define ITE_887x_UARTBAR	0x7c
+#define ITE_887x_PS0BAR		0x10
+#define ITE_887x_POSIO0		0x60
+
+/* I/O space size */
+#define ITE_887x_IOSIZE		32
+/* I/O space size (bits 26-24; 32 bytes = 101b) */
+#define ITE_887x_POSIO_IOSIZE	(5 << 24)
+/* Decoding speed (1 = slow, 2 = medium, 3 = fast) */
+#define ITE_887x_POSIO_SPEED	(3 << 29)	
+/* enable IO_Space bit */
+#define ITE_887x_POSIO_ENABLE	(1 << 31)	
+
+static int __devinit pci_ite887x_init(struct pci_dev *dev)
+{
+	/* inta_addr are the configuration addresses of the ITE */
+	static const short inta_addr[] = { 0x2a0, 0x2c0, 0x220, 0x240, 0x1e0,
+							0x200, 0x280, 0 };
+	int ret, i, type;
+	struct resource *iobase = NULL;
+	u32 miscr, uartbar, ioport;
+
+	/* search for the base-ioport */
+	i = 0;
+	while (inta_addr[i] && iobase == NULL) {
+		iobase = request_region(inta_addr[i], ITE_887x_IOSIZE,
+								"ite887x");
+		if (iobase != NULL) {
+			/* write POSIO0R - speed | size | ioport */
+			pci_write_config_dword(dev, ITE_887x_POSIO0,
+				ITE_887x_POSIO_ENABLE | ITE_887x_POSIO_SPEED |
+				ITE_887x_POSIO_IOSIZE | inta_addr[i]);
+			/* write INTCBAR - ioport */
+			pci_write_config_dword(dev, ITE_887x_INTCBAR,
+								inta_addr[i]);
+			ret = inb(inta_addr[i]);
+			if (ret != 0xff) {
+				/* ioport connected */
+				break;
+			}
+			release_region(iobase->start, ITE_887x_IOSIZE);
+			iobase = NULL;
+		}
+		i++;
+	}
+
+	if (!inta_addr[i]) {
+		printk(KERN_ERR "ite887x: could not find iobase\n");
+		return -ENODEV;
+	}
+
+	/* start of undocumented type checking (see parport_pc.c) */
+	type = inb(iobase->start + 0x18) & 0x0f;
+
+	switch (type) {
+	case 0x2:	/* ITE8871 (1P) */
+	case 0xa:	/* ITE8875 (1P) */
+		ret = 0;
+		break;
+	case 0xe:	/* ITE8872 (2S1P) */
+		ret = 2;
+		break;
+	case 0x6:	/* ITE8873 (1S) */
+		ret = 1;
+		break;
+	case 0x8:	/* ITE8874 (2S) */
+		ret = 2;
+		break;
+	default:
+		moan_device("Unknown ITE887x", dev);
+		ret = -ENODEV;
+	}
+
+	/* configure all serial ports */
+	for (i = 0; i < ret; i++) {
+		/* read the I/O port from the device */
+		pci_read_config_dword(dev, ITE_887x_PS0BAR + (0x4 * (i + 1)),
+								&ioport);
+		ioport &= 0x0000FF00;	/* the actual base address */
+		pci_write_config_dword(dev, ITE_887x_POSIO0 + (0x4 * (i + 1)),
+			ITE_887x_POSIO_ENABLE | ITE_887x_POSIO_SPEED | ioport);
+
+		/* write the ioport to the UARTBAR */
+		pci_read_config_dword(dev, ITE_887x_UARTBAR, &uartbar);
+		uartbar &= ~(15 << (4 * i));	/* clear half the reg */
+		uartbar |= ioport << (16 * i);	/* set the ioport */
+		pci_write_config_dword(dev, ITE_887x_UARTBAR, uartbar);
+
+		/* get current config */
+		pci_read_config_dword(dev, ITE_887x_MISCR, &miscr);
+		/* disable interrupts (UARTx_Routing[3:0]) */
+		miscr &= ~(0xf << (12 - 4 * i));
+		/* activate the UART (UARTx_En) */
+		miscr |= 1 << (23 - i);
+		/* write new config with activated UART */
+		pci_write_config_dword(dev, ITE_887x_MISCR, miscr);
+	}
+
+	if (ret > 0) {
+		dev->dev.driver_data = iobase;
+	} else {
+		/* the device has no UARTs if we get here */
+		release_region(iobase->start, ITE_887x_IOSIZE);
+	}
+
+	return ret;
+}
+
+static void __devexit pci_ite887x_exit(struct pci_dev *dev)
+{
+	struct resource *iobase = (struct resource*) dev->dev.driver_data;
+	/* free the private driver data */
+	release_region(iobase->start, ITE_887x_IOSIZE);
+	dev->dev.driver_data = NULL;
+}
+
 static int
 pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
 		  struct uart_port *port, int idx)
@@ -654,6 +785,18 @@ static struct pci_serial_quirk pci_seria
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
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ite887x_exit),
+	},
+	/*
 	 * Panacom
 	 */
 	{
@@ -927,6 +1070,7 @@ enum pci_board_num_t {
 
 	pbn_b1_2_1250000,
 
+	pbn_b1_bt_1_115200,
 	pbn_b1_bt_2_921600,
 
 	pbn_b1_1_1382400,
@@ -1205,6 +1349,13 @@ static struct pciserial_board pci_boards
 		.uart_offset	= 8,
 	},
 
+	[pbn_b1_bt_1_115200] = {
+		.flags		= FL_BASE1|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
+
 	[pbn_b1_bt_2_921600] = {
 		.flags		= FL_BASE1|FL_BASE_BARS,
 		.num_ports	= 2,
@@ -2370,6 +2521,13 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_TOPIC, PCI_DEVICE_ID_TOPIC_TP560,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_1_115200 },
+	/*
+	 * ITE
+	 */
+	{	PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8872,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b1_bt_1_115200 },	
 
 	/*
 	 * IntaShield IS-200


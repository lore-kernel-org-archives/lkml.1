Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbXCZVOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbXCZVOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbXCZVOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:14:51 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2066 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbXCZVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:14:50 -0400
Date: Mon, 26 Mar 2007 22:14:41 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for ITE887x serial chipsets
Message-ID: <20070326211441.GA12690@flint.arm.linux.org.uk>
Mail-Followup-To: Niels de Vos <niels.devos@wincor-nixdorf.com>,
	linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070326141702.GA28306@deexvs01.wincor-nixdorf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326141702.GA28306@deexvs01.wincor-nixdorf.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 04:17:02PM +0200, Niels de Vos wrote:
> +/*
> + * ITE support by Niels de Vos <niels.devos@wincor-nixdorf.com>
> + */
> +
> +static int __devinit pci_ite887x_init(struct pci_dev *dev)
> +{
> +	/* inta_addr are the configuration addresses of the ITE */
> +	short inta_addr[] = { 0x2a0, 0x2c0, 0x220, 0x240, 0x1E0, 0x200,
> +								0x280, 0 };
> +	int ret, i, type;
> +	struct resource *iobase;
> +
> +	/* search for the base-ioport */
> +	i = 0;
> +	while (inta_addr[i] && dev->dev.driver_data != NULL) {
> +		dev->dev.driver_data = request_region(inta_addr[i], 32,
> +								"ite887x");
> +		if (dev->dev.driver_data != NULL) {
> +			/* write POSIO0R - speed | size | ioport */
> +			pci_write_config_dword(dev, 0x60,
> +						0xe5000000 | inta_addr[i]);
> +			/* write INTCBAR - ioport */
> +			pci_write_config_dword(dev, 0x78, inta_addr[i]);
> +			ret = inb(inta_addr[i]);
> +			if (ret != 0xff) {
> +				/* ioport connected */
> +				break;
> +			}
> +			release_resource(dev->dev.driver_data);
> +			dev->dev.driver_data = NULL;

This doesn't free the memory allocated by request_region.  Always
pair release_region() with request_region().  Ditto for all of your
other uses of "release_resource()".

Might also be cleaner to avoid touching dev->dev.driver_data at all
until you've identified a working resource.

> +		}
> +		i++;
> +	}
> +
> +	if (! inta_addr[i]) {
> +		printk(KERN_ERR "ite887x: could not find iobase\n");
> +		return -ENODEV;
> +	}
> +
> +	iobase = dev->dev.driver_data;
> +
> +	/* start of undocumented type checking (see parport_pc.c) */
> +	type = inb(iobase->start + 0x18);
> +	type &= 0x0f;
> +
> +	switch (type) {
> +	case 0x2:
> +		printk(KERN_DEBUG "8250_pci: ITE8871 found (1P)\n");
> +		break;
> +	case 0xa:
> +		printk(KERN_DEBUG "8250_pci: ITE8875 found (1P)\n");
> +		break;
> +	case 0xe:
> +		printk(KERN_INFO "8250_pci: ITE8872 found (2S1P)\n");
> +		return 2;
> +	case 0x6:
> +		printk(KERN_INFO "8250_pci: ITE8873 found (1S)\n");
> +		return 1;
> +	case 0x8:
> +		printk(KERN_INFO "8250_pci: ITE8874 found (2S)\n");
> +		return 2;
> +	default:
> +		moan_device("unknown ITE887x", dev);
> +	}
> +
> +	/* the device has no UARTs if we get here */
> +	release_resource(iobase);
> +	dev->dev.driver_data = NULL;
> +	return -ENODEV;
> +}
> +
> +/*
> + * activate the UART in the MISCR
> + */
> +static int
> +pci_ite887x_setup(struct serial_private *priv, struct pciserial_board *board,
> +		  struct uart_port *port, int idx)
> +{
> +	int ret;
> +	struct pci_dev *dev = priv->dev;
> +	u32 miscr, uartbar, ioport;
> +	/* iobase is the private driver_data */
> +	struct resource *iobase;
> +	/* registers */
> +	unsigned short MISCR = 0x9c, UARTBAR = 0x7c;
> +	unsigned short PS1BAR = 0x14, POSIO1 = 0x64;
> +
> +	/* enable IO_Space bit */
> +	u32 POSIO_ENABLE = 1 << 31;
> +	/* Decoding speed (1 = slow, 2 = medium, 3 = fast) */
> +	u32 POSIO_SPEED = 3 << 29;	

#define all of these?  They're constants.

> +
> +	iobase = (struct resource*) dev->dev.driver_data;
> +	if (iobase == NULL) {
> +		printk(KERN_ERR "ite887x: iobase is not available\n");
> +		return -ENODEV;
> +	}
> +
> +	/* read the I/O port from the device */
> +	ret = pci_read_config_dword(dev, PS1BAR + (0x4 * idx), &ioport);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: read error PS%dBAR\n", idx + 1);
> +		ret = -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	ioport &= 0x0000FF00;	/* the actual I/O space base address */
> +	ret = pci_write_config_dword(dev, POSIO1 + (0x4 * idx),
> +				POSIO_ENABLE | POSIO_SPEED | ioport);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: write error PSIO%d+\n", idx + 1);
> +		ret = -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	/* write the ioport to the UARTBAR */
> +	ret = pci_read_config_dword(dev, UARTBAR, &uartbar);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: read error UARTBAR\n");
> +		ret = -ENODEV;
> +		goto release_inta;
> +	}
> +	uartbar &= ~(15 << (4 * idx));		/* clear half the reg */
> +	uartbar |= ioport << (16 * idx);	/* set the ioport */
> +	ret = pci_write_config_dword(dev, UARTBAR, uartbar);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: write error UARTBAR\n");
> +		ret = -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	/* get current config */
> +	ret = pci_read_config_dword(dev, MISCR, &miscr);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: read error MISCR\n");
> +		ret = -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	/* disable interrupts (UARTx_Routing[3:0]) */
> +	miscr &= ~(0xf << (12 - 4 * idx));
> +	/* activate the UART (UARTx_En) */
> +	miscr |= 1 << (23 - idx);
> +
> +	/* write new config with activated UART */
> +	ret = pci_write_config_dword(dev, MISCR, miscr);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: write error MISCR\n");
> +		ret = -ENODEV;
> +		goto release_inta;
> +	}

I think all of the above can be done in the init function, which'll be
a _lot_ clearer.  That also means...

> +
> +	/* idx + 1: using POSIO1 and up */
> +	return setup_port(priv, port, idx + 1, board->first_offset, 0);

that you can (usefully) add pbn_b1_bt_1_115200 and completely avoid
this hack.

> @@ -968,6 +1148,7 @@ enum pci_board_num_t {
>  	pbn_plx_romulus,
>  	pbn_oxsemi,
>  	pbn_intel_i960,
> +	pbn_ite_887x,

Always avoid chipset specific definitions if there's another way to
work around them (as suggested above).

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

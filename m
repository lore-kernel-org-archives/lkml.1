Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXCZURO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXCZURO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXCZURO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:17:14 -0400
Received: from chert.donpac.ru ([80.254.111.36]:59693 "EHLO chert.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbXCZURN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:17:13 -0400
Date: Tue, 27 Mar 2007 00:17:05 +0400
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: rmk+serial@arm.linux.org.uk, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for ITE887x serial chipsets
Message-ID: <20070326201705.GA14403@pazke.donpac.ru>
Mail-Followup-To: Niels de Vos <niels.devos@wincor-nixdorf.com>,
	rmk+serial@arm.linux.org.uk, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20070326141702.GA28306@deexvs01.wincor-nixdorf.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20070326141702.GA28306@deexvs01.wincor-nixdorf.com>
X-Uname: Linux 2.6.18-1-amd64 x86_64
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andrey Panin <pazke@donpac.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 085, 03 26, 2007 at 04:17:02PM +0200, Niels de Vos wrote:
> Hi,
>=20
> the Super I/O 887x-chipsets of ITE, are currently not completely
> supported. Only parport_pc has the ability to activate the (optional)
> parallel port. This patch adds support for the serial ports.
>=20
> Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
>=20
> --- linux-2.6.20.3/drivers/serial/8250_pci.c.orig	2007-03-13 19:27:08.000=
000000 +0100
> +++ linux-2.6.20.3/drivers/serial/8250_pci.c	2007-03-26 15:42:17.00000000=
0 +0200
> @@ -581,6 +581,174 @@ static int pci_netmos_init(struct pci_de
>  	return num_serial;
>  }
> =20
> +/*
> + * ITE support by Niels de Vos <niels.devos@wincor-nixdorf.com>
> + */

I think we need a comment here describing how ugly these chips are :)

> +
> +static int __devinit pci_ite887x_init(struct pci_dev *dev)
> +{
> +	/* inta_addr are the configuration addresses of the ITE */
> +	short inta_addr[] =3D { 0x2a0, 0x2c0, 0x220, 0x240, 0x1E0, 0x200,
> +								0x280, 0 };

static const, please.

> +	int ret, i, type;
> +	struct resource *iobase;
> +
> +	/* search for the base-ioport */
> +	i =3D 0;
> +	while (inta_addr[i] && dev->dev.driver_data !=3D NULL) {
> +		dev->dev.driver_data =3D request_region(inta_addr[i], 32,
> +								"ite887x");
> +		if (dev->dev.driver_data !=3D NULL) {
> +			/* write POSIO0R - speed | size | ioport */
> +			pci_write_config_dword(dev, 0x60,
> +						0xe5000000 | inta_addr[i]);
> +			/* write INTCBAR - ioport */
> +			pci_write_config_dword(dev, 0x78, inta_addr[i]);
> +			ret =3D inb(inta_addr[i]);
> +			if (ret !=3D 0xff) {
> +				/* ioport connected */
> +				break;
> +			}
> +			release_resource(dev->dev.driver_data);
> +			dev->dev.driver_data =3D NULL;
> +		}
> +		i++;
> +	}
> +
> +	if (! inta_addr[i]) {
	     ^
Please remove space after !

> +		printk(KERN_ERR "ite887x: could not find iobase\n");
> +		return -ENODEV;
> +	}
> +
> +	iobase =3D dev->dev.driver_data;
> +
> +	/* start of undocumented type checking (see parport_pc.c) */
> +	type =3D inb(iobase->start + 0x18);
> +	type &=3D 0x0f;

Why not:
type =3D inb(iobase->start + 0x18) & 0x0f;

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

These printk's are not needed IMHO.

> +
> +	/* the device has no UARTs if we get here */
> +	release_resource(iobase);
> +	dev->dev.driver_data =3D NULL;
> +	return -ENODEV;
> +}
> +
> +/*
> + * activate the UART in the MISCR
> + */
> +static int
> +pci_ite887x_setup(struct serial_private *priv, struct pciserial_board *b=
oard,
> +		  struct uart_port *port, int idx)
> +{
> +	int ret;
> +	struct pci_dev *dev =3D priv->dev;
> +	u32 miscr, uartbar, ioport;
> +	/* iobase is the private driver_data */
> +	struct resource *iobase;
> +	/* registers */
> +	unsigned short MISCR =3D 0x9c, UARTBAR =3D 0x7c;
> +	unsigned short PS1BAR =3D 0x14, POSIO1 =3D 0x64;
> +
> +	/* enable IO_Space bit */
> +	u32 POSIO_ENABLE =3D 1 << 31;
> +	/* Decoding speed (1 =3D slow, 2 =3D medium, 3 =3D fast) */
> +	u32 POSIO_SPEED =3D 3 << 29;=09
> +
> +	iobase =3D (struct resource*) dev->dev.driver_data;
> +	if (iobase =3D=3D NULL) {
> +		printk(KERN_ERR "ite887x: iobase is not available\n");
> +		return -ENODEV;
> +	}

Is this check really needed ? I can't see how you can enter this function
with dev->dev.driver_data =3D=3D NULL.

> +
> +	/* read the I/O port from the device */
> +	ret =3D pci_read_config_dword(dev, PS1BAR + (0x4 * idx), &ioport);
> +	if (ret) {

Checking return value of pci_read_config_XXX/pci_write_config_XXX is (almos=
t ?)
useless and only complicates things.

> +		printk(KERN_ERR "ite887x: read error PS%dBAR\n", idx + 1);
> +		ret =3D -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	ioport &=3D 0x0000FF00;	/* the actual I/O space base address */
> +	ret =3D pci_write_config_dword(dev, POSIO1 + (0x4 * idx),
> +				POSIO_ENABLE | POSIO_SPEED | ioport);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: write error PSIO%d+\n", idx + 1);
> +		ret =3D -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	/* write the ioport to the UARTBAR */
> +	ret =3D pci_read_config_dword(dev, UARTBAR, &uartbar);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: read error UARTBAR\n");
> +		ret =3D -ENODEV;
> +		goto release_inta;
> +	}
> +	uartbar &=3D ~(15 << (4 * idx));		/* clear half the reg */
> +	uartbar |=3D ioport << (16 * idx);	/* set the ioport */
> +	ret =3D pci_write_config_dword(dev, UARTBAR, uartbar);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: write error UARTBAR\n");
> +		ret =3D -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	/* get current config */
> +	ret =3D pci_read_config_dword(dev, MISCR, &miscr);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: read error MISCR\n");
> +		ret =3D -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	/* disable interrupts (UARTx_Routing[3:0]) */
> +	miscr &=3D ~(0xf << (12 - 4 * idx));
> +	/* activate the UART (UARTx_En) */
> +	miscr |=3D 1 << (23 - idx);
> +
> +	/* write new config with activated UART */
> +	ret =3D pci_write_config_dword(dev, MISCR, miscr);
> +	if (ret) {
> +		printk(KERN_ERR "ite887x: write error MISCR\n");
> +		ret =3D -ENODEV;
> +		goto release_inta;
> +	}
> +
> +	/* idx + 1: using POSIO1 and up */
> +	return setup_port(priv, port, idx + 1, board->first_offset, 0);
> +
> +release_inta:
> +	/* release region again if we get here */
> +	release_resource(iobase);
> +	dev->dev.driver_data =3D NULL;
> +	return ret;
> +}
> +
> +static void __devexit pci_ite887x_exit(struct pci_dev *dev)
> +{
> +	/* free the private driver data */
> +	release_resource(((struct resource*) dev->dev.driver_data));
> +}
> +
>  static int
>  pci_default_setup(struct serial_private *priv, struct pciserial_board *b=
oard,
>  		  struct uart_port *port, int idx)
> @@ -654,6 +822,18 @@ static struct pci_serial_quirk pci_seria
>  		.setup		=3D pci_default_setup,
>  	},
>  	/*
> +	 * ITE
> +	 */
> +	{
> +		.vendor		=3D PCI_VENDOR_ID_ITE,
> +		.device		=3D PCI_DEVICE_ID_ITE_8872,
> +		.subvendor	=3D PCI_ANY_ID,
> +		.subdevice	=3D PCI_ANY_ID,
> +		.init		=3D pci_ite887x_init,
> +		.setup		=3D pci_ite887x_setup,
> +		.exit		=3D __devexit_p(pci_ite887x_exit),
> +	},
> +	/*
>  	 * Panacom
>  	 */
>  	{
> @@ -968,6 +1148,7 @@ enum pci_board_num_t {
>  	pbn_plx_romulus,
>  	pbn_oxsemi,
>  	pbn_intel_i960,
> +	pbn_ite_887x,
>  	pbn_sgi_ioc3,
>  	pbn_nec_nile4,
>  	pbn_computone_4,
> @@ -1430,6 +1611,15 @@ static struct pciserial_board pci_boards
>  	},
> =20
>  	/*
> +	 * ITE
> +	 */
> +	[pbn_ite_887x] =3D {
> +                .flags          =3D FL_BASE0 | FL_BASE_BARS,
> +                .base_baud      =3D 115200,
> +                .uart_offset    =3D 8,
> +        },

IMHO this is not needed. You can use pbn_b0_bt_2_115200 or pbn_b0_bt_1_1152=
00,
since quirks will be used anyway.

> +
> +	/*
>  	 * NEC Vrc-5074 (Nile 4) builtin UART.
>  	 */
>  	[pbn_nec_nile4] =3D {
> @@ -2370,6 +2560,13 @@ static struct pci_device_id serial_pci_t
>  	{	PCI_VENDOR_ID_TOPIC, PCI_DEVICE_ID_TOPIC_TP560,
>  		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
>  		pbn_b0_1_115200 },
> +	/*
> +	 * ITE
> +	 */
> +	{	PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8872,
> +		PCI_ANY_ID, PCI_ANY_ID,
> +		0, 0,
> +		pbn_ite_887x },=09
> =20
>  	/*
>  	 * IntaShield IS-200
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGCCpBIWZCBzwS8mkRAmpRAJ9On7u6KsddOcPS1SQPaHQX7hin4gCgmGEt
tE17bgFhh7r9GlybAG9a9qk=
=5oLQ
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--

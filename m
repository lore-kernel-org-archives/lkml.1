Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbXFEDJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbXFEDJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 23:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbXFEDJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 23:09:04 -0400
Received: from mx5.mail.ru ([194.67.23.25]:13249 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182AbXFEDJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 23:09:01 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Tue, 5 Jun 2007 07:08:52 +0400
User-Agent: KMail/1.9.7
Cc: samuel@sortiz.org, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       Linus Walleij <linus.walleij@ericsson.com>
References: <200706031200.07514.arvidjaar@mail.ru> <200706031216.06172.arvidjaar@mail.ru> <200706041034.06353.bjorn.helgaas@hp.com>
In-Reply-To: <200706041034.06353.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1374276.5piuUXzdXO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706050708.57358.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1374276.5piuUXzdXO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 04 June 2007, Bjorn Helgaas wrote:
> On Sunday 03 June 2007 02:16:05 am Andrey Borzenkov wrote:
> > On Sunday 03 June 2007, Andrey Borzenkov wrote:
> > > Under 2.6.22-rc I lost irda0 interface - smsc claims no device presen=
t.
> > > Nothing was changed in setup except kernel version.
> > >
> > > 2.6.21:
> > >
> > > Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA
> > > chip, pre-configuring device.
> > > Activated ALi 1533 ISA bridge port 0x02e8.
> > > Activated ALi 1533 ISA bridge port 0x02f8.
> > > found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e): LPC47N2=
27
> > > smsc_superio_flat(): IrDA not enabled
>
> The "IrDA not enabled" makes me think that even in the working case,
> the BIOS left the IR port disabled.  Are there any BIOS setup switches
> that affect this port?
>

No (at least in BIOS setup screens). The closest is COM port setting=20
(IRQ/DMA). This looks funny as I do not have COM interface anyway but may b=
e=20
docking station has.

> > > smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7, mode:
> > > 0x02 SMsC IrDA Controller found
> > >  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=3D7
>
> It seems strange that both FIR and SIR would use legacy COM ports
> (0x2f8 =3D=3D COM2, 0x2e8 =3D=3D COM4).  My HP nw8240 has SIR at 0x3e8 (C=
OM3)
> and FIR at 0x100.
>

Well, this is how code was written. There was no autodetection anyway, it u=
sed=20
hardcoded builtin (unless overridden).

> Do you know if both the FIR and SIR interfaces work?  I'm wondering if
> your irda0 only uses SIR at 0x2e8, and FIR has always been broken.
>

How can I check it?=20

> > > No transceiver found. Defaulting to Fast pin select
> > > IrDA: Registered device irda0
> > >
> > >
> > > 2.6.22-rc3:
> > > Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA
> > > chip, pre-configuring device.
> > > Activated ALi 1533 ISA bridge port 0x02e8.
> > > Activated ALi 1533 ISA bridge port 0x02f8.
> > > pnp: Device 00:0a activated.
> > > smsc_ircc_present(), addr 0x02e8 - no device found!
> > > pnp: Device 00:0a disabled.
> >
> > {pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
> > state =3D active
> > io 0x100-0x107
> > io 0x2e8-0x2ef
> > irq 5
> > dma 1
>
> The PNP probe I added expects SIR at the first range and FIR at the
> second.  I would think the 0x2e8 range would be SIR, since it's compatible
> with a COM port.  Is it possible the BIOS just reports these in the
> opposite order, with FIR first and SIR second?  Can you try the patch
> below?
>

It does not work unfortunately:

Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip,=20
pre-configuring device.
Activated ALi 1533 ISA bridge port 0x02e8.
Activated ALi 1533 ISA bridge port 0x02f8.
pnp: Device 00:0a activated.
smsc_ircc_pnp_probe(): fir 0x100 sir 0x2e8 dma 1 irq 5
High: 0x11, Chip 0x0
smsc_ircc_present(), addr 0x0100 - no device found!
pnp: Device 00:0a disabled.


> Index: linux-2.6/drivers/net/irda/smsc-ircc2.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/net/irda/smsc-ircc2.c	2007-06-04
> 10:21:46.000000000 -0600 +++
> linux-2.6/drivers/net/irda/smsc-ircc2.c	2007-06-04 10:21:57.000000000 -06=
00
> @@ -386,8 +386,8 @@
>  	      pnp_dma_valid(dev, 0) && pnp_irq_valid(dev, 0)))
>  		return -EINVAL;
>
> -	sirbase =3D pnp_port_start(dev, 0);
> -	firbase =3D pnp_port_start(dev, 1);
> +	firbase =3D pnp_port_start(dev, 0);
> +	sirbase =3D pnp_port_start(dev, 1);
>  	dma =3D pnp_dma(dev, 0);
>  	irq =3D pnp_irq(dev, 0);



--nextPart1374276.5piuUXzdXO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGZNPFR6LMutpd94wRAq6BAJoDNMOkRwGDSYlvdBooeGmZOkE+pQCeKQ3m
o40sTL8oPSGiDStrZFd2ACg=
=0i52
-----END PGP SIGNATURE-----

--nextPart1374276.5piuUXzdXO--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763099AbXFEDKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763099AbXFEDKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 23:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759519AbXFEDKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 23:10:46 -0400
Received: from mx6.mail.ru ([194.67.23.26]:18688 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182AbXFEDKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 23:10:45 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Samuel Ortiz <samuel@sortiz.org>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Tue, 5 Jun 2007 07:10:40 +0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       bjorn.helgaas@hp.com, Linus Walleij <linus.walleij@ericsson.com>
References: <200706031200.07514.arvidjaar@mail.ru> <200706040634.01622.arvidjaar@mail.ru> <20070604204418.GA4214@sortiz.org>
In-Reply-To: <20070604204418.GA4214@sortiz.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3112121.CKsooJfkgi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706050710.41754.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3112121.CKsooJfkgi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 05 June 2007, Samuel Ortiz wrote:
> (Adding Linus Walleij, who wrote part of the smsc driver, to Cc:)
>
> On Mon, Jun 04, 2007 at 06:33:56AM +0400, Andrey Borzenkov wrote:
> > On Monday 04 June 2007, Samuel Ortiz wrote:
> > > It seems that PnP tells us that the FIR port is at 0x2e8 while we're
> > > expecting it at 0x2f8.
> > > Could you apply this patch and then send me a dmesg dump of the
> > > smsc-ircc initialisation ?
> >
> > here is dmesg:
> >
> > Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip,
> > pre-configuring device.
> > Activated ALi 1533 ISA bridge port 0x02e8.
> > Activated ALi 1533 ISA bridge port 0x02f8.
> > pnp: Device 00:0a activated.
> > smsc_ircc_pnp_probe(): fir 0x2e8 sir 0x100 dma 1 irq 5
>
> Ok, FIR and SIR are definitey mixed up. So, now could you please try
> Bjorn's patch ?

does not work.

> I wonder if the curent code (without PnP) enables 0x2f8 as=20
> the SIR port through the preconfiguration code...
>
> Cheers,
> Samuel.
>
> > High: 0xef, Chip 0x1
> > smsc_ircc_present(), addr 0x02e8 - no device found!
> > pnp: Device 00:0a disabled.
> >
> > And here is what PnP tells us:
> > {pts/1}% cat /sys/bus/pnp/devices/00:0a/options
> > port 0x100-0x130, align 0xf, size 0x8, 16-bit address decoding
> > irq 3,4,5,6,7,10,11 High-Edge
> > dma 1,2,3 16-bit compatible
> > Dependent: 01 - Priority acceptable
> >    port 0x3f8-0x3f8, align 0x0, size 0x8, 16-bit address decoding
> > Dependent: 02 - Priority acceptable
> >    port 0x2e8-0x2e8, align 0x0, size 0x8, 16-bit address decoding
> > Dependent: 03 - Priority acceptable
> >    port 0x2f8-0x2f8, align 0x0, size 0x8, 16-bit address decoding
> > Dependent: 04 - Priority acceptable
> >    port 0x3e8-0x3e8, align 0x0, size 0x8, 16-bit address decoding
> > {pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
> > state =3D disabled
> > {pts/1}% sudo sh -c 'echo activate >
> > /sys/bus/pnp/devices/00:0a/resources' {pts/1}% cat
> > /sys/bus/pnp/devices/00:0a/resources
> > state =3D active
> > io 0x100-0x107
> > io 0x2e8-0x2ef
> > irq 5
> > dma 1
> >
> > -andrey
> >
> > > Cheers,
> > > Samuel.
> > >
> > >
> > > diff --git a/drivers/net/irda/smsc-ircc2.c
> > > b/drivers/net/irda/smsc-ircc2.c index 9043bf4..d1d46a6 100644
> > > --- a/drivers/net/irda/smsc-ircc2.c
> > > +++ b/drivers/net/irda/smsc-ircc2.c
> > > @@ -391,6 +391,9 @@ static int __init smsc_ircc_pnp_probe(struct
> > > pnp_dev *dev, dma =3D pnp_dma(dev, 0);
> > >  	irq =3D pnp_irq(dev, 0);
> > >
> > > +	printk("%s(): fir 0x%x sir 0x%x dma %d irq %d\n",
> > > +	       __FUNCTION__, firbase, sirbase, dma, irq);
> > > +
> > >  	if (smsc_ircc_open(firbase, sirbase, dma, irq))
> > >  		return -ENODEV;
> > >
> > > @@ -655,6 +658,7 @@ static int smsc_ircc_present(unsigned int fir_bas=
e,
> > > unsigned int sir_base) irq     =3D (config & IRCC_INTERFACE_IRQ_MASK)=
 >>
> > > 4;
> > >
> > >  	if (high !=3D 0x10 || low !=3D 0xb8 || (chip !=3D 0xf1 && chip !=3D=
 0xf2)) {
> > > +		printk("High: 0x%x, Chip 0x%x\n", high, chip);
> > >  		IRDA_WARNING("%s(), addr 0x%04x - no device found!\n",
> > >  			     __FUNCTION__, fir_base);
> > >  		goto out3;



--nextPart3112121.CKsooJfkgi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGZNQxR6LMutpd94wRAnwZAKDLFt927dIu8xhhEgAL0rzOJwkEdQCeM4km
c9RYvsjqFvgdP/6vaDfChNo=
=uw1A
-----END PGP SIGNATURE-----

--nextPart3112121.CKsooJfkgi--

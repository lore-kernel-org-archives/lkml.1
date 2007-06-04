Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbXFDCeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbXFDCeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 22:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXFDCeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 22:34:07 -0400
Received: from mx3.mail.ru ([194.67.23.149]:7287 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbXFDCeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 22:34:06 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Samuel Ortiz <samuel@sortiz.org>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Mon, 4 Jun 2007 06:33:56 +0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       bjorn.helgaas@hp.com
References: <200706031200.07514.arvidjaar@mail.ru> <200706031216.06172.arvidjaar@mail.ru> <20070603231050.GA3829@sortiz.org>
In-Reply-To: <20070603231050.GA3829@sortiz.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1518197.prAvTFFB64";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706040634.01622.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1518197.prAvTFFB64
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 04 June 2007, Samuel Ortiz wrote:
> Hi Andrey,
>
> On Sun, Jun 03, 2007 at 12:16:05PM +0400, Andrey Borzenkov wrote:
> > Adding "nopnp" parameters finds device just fine so it is apparently
> > result of this commit:
> >
> > commit d0d4f69bb65a8c1c1430c577a583632709b874c6
> > Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Date:   Tue May 8 00:36:05 2007 -0700
> >
> >     smsc-ircc2: add PNP support
> >
> > What information is needed to debug it further?
>
> It seems that PnP tells us that the FIR port is at 0x2e8 while we're
> expecting it at 0x2f8.
> Could you apply this patch and then send me a dmesg dump of the
> smsc-ircc initialisation ?
>

here is dmesg:

Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip,=20
pre-configuring device.
Activated ALi 1533 ISA bridge port 0x02e8.
Activated ALi 1533 ISA bridge port 0x02f8.
pnp: Device 00:0a activated.
smsc_ircc_pnp_probe(): fir 0x2e8 sir 0x100 dma 1 irq 5
High: 0xef, Chip 0x1
smsc_ircc_present(), addr 0x02e8 - no device found!
pnp: Device 00:0a disabled.

And here is what PnP tells us:
{pts/1}% cat /sys/bus/pnp/devices/00:0a/options
port 0x100-0x130, align 0xf, size 0x8, 16-bit address decoding
irq 3,4,5,6,7,10,11 High-Edge
dma 1,2,3 16-bit compatible
Dependent: 01 - Priority acceptable
   port 0x3f8-0x3f8, align 0x0, size 0x8, 16-bit address decoding
Dependent: 02 - Priority acceptable
   port 0x2e8-0x2e8, align 0x0, size 0x8, 16-bit address decoding
Dependent: 03 - Priority acceptable
   port 0x2f8-0x2f8, align 0x0, size 0x8, 16-bit address decoding
Dependent: 04 - Priority acceptable
   port 0x3e8-0x3e8, align 0x0, size 0x8, 16-bit address decoding
{pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
state =3D disabled
{pts/1}% sudo sh -c 'echo activate > /sys/bus/pnp/devices/00:0a/resources'
{pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
state =3D active
io 0x100-0x107
io 0x2e8-0x2ef
irq 5
dma 1

=2Dandrey

> Cheers,
> Samuel.
>
>
> diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
> index 9043bf4..d1d46a6 100644
> --- a/drivers/net/irda/smsc-ircc2.c
> +++ b/drivers/net/irda/smsc-ircc2.c
> @@ -391,6 +391,9 @@ static int __init smsc_ircc_pnp_probe(struct pnp_dev
> *dev, dma =3D pnp_dma(dev, 0);
>  	irq =3D pnp_irq(dev, 0);
>
> +	printk("%s(): fir 0x%x sir 0x%x dma %d irq %d\n",
> +	       __FUNCTION__, firbase, sirbase, dma, irq);
> +
>  	if (smsc_ircc_open(firbase, sirbase, dma, irq))
>  		return -ENODEV;
>
> @@ -655,6 +658,7 @@ static int smsc_ircc_present(unsigned int fir_base,
> unsigned int sir_base) irq     =3D (config & IRCC_INTERFACE_IRQ_MASK) >> =
4;
>
>  	if (high !=3D 0x10 || low !=3D 0xb8 || (chip !=3D 0xf1 && chip !=3D 0xf=
2)) {
> +		printk("High: 0x%x, Chip 0x%x\n", high, chip);
>  		IRDA_WARNING("%s(), addr 0x%04x - no device found!\n",
>  			     __FUNCTION__, fir_base);
>  		goto out3;



--nextPart1518197.prAvTFFB64
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGY3oVR6LMutpd94wRAuX+AJ9ouf3YACEVwoYzZvciMsF0hjIysACggYHp
cKiX7ETcQKJAYrqcuXK5WTg=
=fNkf
-----END PGP SIGNATURE-----

--nextPart1518197.prAvTFFB64--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXFJGrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXFJGrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 02:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXFJGrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 02:47:17 -0400
Received: from mx27.mail.ru ([194.67.23.64]:6366 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbXFJGrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 02:47:16 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Samuel Ortiz <samuel@sortiz.org>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sun, 10 Jun 2007 10:47:07 +0400
User-Agent: KMail/1.9.7
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Linus Walleij \(LD/EAB\)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706070952.36823.bjorn.helgaas@hp.com> <20070607204759.GA6809@sortiz.org>
In-Reply-To: <20070607204759.GA6809@sortiz.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1735406.raqfVjFQIp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706101047.12118.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1735406.raqfVjFQIp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 08 June 2007, Samuel Ortiz wrote:
> Hi Bjorn,
>
> On 6/7/2007, "Bjorn Helgaas" <bjorn.helgaas@hp.com> wrote:
> >On Wednesday 06 June 2007 02:45:01 pm Andrey Borzenkov wrote:
> >> On Wednesday 06 June 2007, Bjorn Helgaas wrote:
> >> > On Tuesday 05 June 2007 09:29:11 pm Andrey Borzenkov wrote:
> >> > > On Wednesday 06 June 2007, Bjorn Helgaas wrote:
> >> > > > Something's wrong with this strategy.  The BIOS is telling us th=
at
> >> > > > an SMCf010 device is present, active, and responds at io ports
> >> > > > 0x100-0x107 and 0x2e8-0x2ef.  The fact that it happens to be on
> >> > > > the other side of an ISA or LPC bridge should be immaterial to t=
he
> >> > > > OS driver.
> >> > >
> >> > > I thought this as well.
> >> >
> >> > If this is really true, it also means we shouldn't twiddle with the
> >> > bridge.  If the BIOS left us a working setup, the preconfiguration
> >> > is certainly going to change it to something incompatible with the
> >> > PNP info.
> >> >
> >> > What if we try the following patch, which keeps the FIR/SIR swap and
> >> > just removes the preconfiguration?
> >>
> >> I already tried different patch but with similar effect (switch off
> >> preconfiguration) - it does not work. I am beginning to doubt whether
> >> drier works on my system at all (i.e. before PnP change); have to find
> >> time to test.
> >
> >OK.  My patch wasn't the right approach anyway.  Attached is what I
> >think we should do instead -- do the preconfig if we're not using PNP.
>
> Thats sounds good, yes.
> Maybe we should also run the legacy probe when the PnP one fails. I
> don't know how the preconfiguration stuff will behave with the device
> being PnP enabled, but with your patch Andrey will still need to
> modprobe smsc-ircc with smsc_nopnp.
>

One thing that makes me uneasy - ideally we have to do it *after* PnP probe=
=20
fails. Currently we lie to PnP layer that we successfully probed for device=
=20
while in effect we did not (at least, not where PnP told us to).

> So, here is the patch I propose (I had to move smsc_ircc_legacy_probe()
> a bit earlier in the code to avoid forward declaration, but it's
> basically your patch plus a call to smsc_ircc_legacy_probe() from the
> pnp_probe() routine):
>

Yes this patch works:

[58674.337465] pnp: Device 00:0a activated.
[58674.337465] smsc_ircc_present(), addr 0x02e8 - no device found!
[58674.337465] PnP probe failed
[58674.340799] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[58674.340799] Activated ALi 1533 ISA bridge port 0x02e8.
[58674.340799] Activated ALi 1533 ISA bridge port 0x02f8.
[58674.340799] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[58674.340799] smsc_superio_flat(): IrDA not enabled
[58674.340799] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x02
[58674.340799] SMsC IrDA Controller found
[58674.340799]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[58674.340799] No transceiver found. Defaulting to Fast pin select


But I noticed something very strange.

{pts/1}% lspnp -vv 00:0a
00:0a SMCf010 SMC Fast Infrared Port
    state =3D active
    allocated resources:
        io 0x100-0x107
        io 0x2e8-0x2ef
        irq 5
        dma 1
    possible resources:
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

but

{pts/1}% cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0100-013f : pcmcia_socket0
^^^^^^^^^^^^^^^^^^^^^^^^^^ hell, what's it?

and really

{pts/1}% sudo=20
cat /sys/class/pcmcia_socket/pcmcia_socket0/available_resources_io
0x00000100 - 0x000003af
0x000003e0 - 0x000004ff
0x00000820 - 0x000008ff
0x00000a00 - 0x00000aff
0x00000c00 - 0x00000cf7

Does it mean we did not inform PnP layer when PCMCIA is configured? Should =
we=20
do it? I Cc to PCMCIA maintainer as well :) Configuration I have

{pts/1}% pccardctl status
Socket 0:
  3.3V 16-bit PC Card
  Subdevice 0 (function 0) bound to driver "wlags49"
Socket 1:
  no card
Socket 2:
  no card
{pts/1}% pccardctl info
PRODID_1=3D"TOSHIBA"
PRODID_2=3D"Wireless LAN Card"
PRODID_3=3D"Version 01.01"
PRODID_4=3D""
MANFID=3D0156,0002
=46UNCID=3D6
PRODID_1=3D""
PRODID_2=3D""
PRODID_3=3D""
PRODID_4=3D""
MANFID=3D0000,0000
=46UNCID=3D255
PRODID_1=3D""
PRODID_2=3D""
PRODID_3=3D""
PRODID_4=3D""
MANFID=3D0000,0000
=46UNCID=3D255

>
> diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
> index 9043bf4..1d7ab3f 100644
> --- a/drivers/net/irda/smsc-ircc2.c
> +++ b/drivers/net/irda/smsc-ircc2.c
> @@ -366,6 +366,44 @@ static inline void register_bank(int iobase, int ban=
k)
>                 iobase + IRCC_MASTER);
>  }
>
> +
> +static int __init smsc_ircc_legacy_probe(void)
> +{
> +	int ret =3D 0;
> +
> +#ifdef CONFIG_PCI
> +	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir,
> +					      ircc_dma, ircc_irq) < 0) {
> +		/* Ignore errors from preconfiguration */
> +		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
> +	}
> +#endif
> +
> +	if (ircc_fir > 0 && ircc_sir > 0) {
> +		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
> +		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
> +
> +		if (smsc_ircc_open(ircc_fir, ircc_sir, ircc_dma, ircc_irq))
> +			ret =3D -ENODEV;
> +	} else {
> +		ret =3D -ENODEV;
> +
> +		/* try user provided configuration register base address */
> +		if (ircc_cfg > 0) {
> +			IRDA_MESSAGE(" Overriding configuration address "
> +				     "0x%04x\n", ircc_cfg);
> +			if (!smsc_superio_fdc(ircc_cfg))
> +				ret =3D 0;
> +			if (!smsc_superio_lpc(ircc_cfg))
> +				ret =3D 0;
> +		}
> +
> +		if (smsc_ircc_look_for_chips() > 0)
> +			ret =3D 0;
> +	}
> +	return ret;
> +}
> +
>  /* PNP hotplug support */
>  static const struct pnp_device_id smsc_ircc_pnp_table[] =3D {
>  	{ .id =3D "SMCf010", .driver_data =3D 0 },
> @@ -391,9 +429,14 @@ static int __init smsc_ircc_pnp_probe(struct pnp_dev
> *dev, dma =3D pnp_dma(dev, 0);
>  	irq =3D pnp_irq(dev, 0);
>
> -	if (smsc_ircc_open(firbase, sirbase, dma, irq))
> -		return -ENODEV;
> -
> +	if (smsc_ircc_open(firbase, sirbase, dma, irq)) {
> +		IRDA_ERROR("PnP probe failed\n");
> +		if (smsc_ircc_legacy_probe()) {
> +			IRDA_ERROR("Legacy probe failed\n");
> +			return -ENODEV;
> +		}
> +	}
> +
>  	return 0;
>  }
>
> @@ -412,35 +455,6 @@ static struct pnp_driver smsc_ircc_pnp_driver =3D {
>   *
> =20
> *************************************************************************=
**
>****/
>
> -static int __init smsc_ircc_legacy_probe(void)
> -{
> -	int ret =3D 0;
> -
> -	if (ircc_fir > 0 && ircc_sir > 0) {
> -		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
> -		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
> -
> -		if (smsc_ircc_open(ircc_fir, ircc_sir, ircc_dma, ircc_irq))
> -			ret =3D -ENODEV;
> -	} else {
> -		ret =3D -ENODEV;
> -
> -		/* try user provided configuration register base address */
> -		if (ircc_cfg > 0) {
> -			IRDA_MESSAGE(" Overriding configuration address "
> -				     "0x%04x\n", ircc_cfg);
> -			if (!smsc_superio_fdc(ircc_cfg))
> -				ret =3D 0;
> -			if (!smsc_superio_lpc(ircc_cfg))
> -				ret =3D 0;
> -		}
> -
> -		if (smsc_ircc_look_for_chips() > 0)
> -			ret =3D 0;
> -	}
> -	return ret;
> -}
> -
>  /*
>   * Function smsc_ircc_init ()
>   *
> @@ -459,13 +473,6 @@ static int __init smsc_ircc_init(void)
>  		return ret;
>  	}
>
> -#ifdef CONFIG_PCI
> -	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir,
> ircc_dma, ircc_irq) < 0) { -		/* Ignore errors from preconfiguration */
> -		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
> -	}
> -#endif
> -
>  	dev_count =3D 0;
>
>  	if (smsc_nopnp || !pnp_platform_devices ||



--nextPart1735406.raqfVjFQIp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGa55sR6LMutpd94wRApbgAKCqIvByNtvml6qmAi1EezZW6xKGqwCggMt1
QIGaeb5Jqu4cQqIGAF/QXmo=
=ikK2
-----END PGP SIGNATURE-----

--nextPart1735406.raqfVjFQIp--

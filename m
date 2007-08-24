Return-Path: <linux-kernel-owner+w=401wt.eu-S1765451AbXHXRmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765451AbXHXRmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760092AbXHXRmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:42:43 -0400
Received: from mx34.mail.ru ([194.67.23.200]:23179 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759133AbXHXRml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:42:41 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [2.6.23-rc3 possible regression] 8250 claims nonexisting device blocking IO port
Date: Fri, 24 Aug 2007 21:42:36 +0400
User-Agent: KMail/1.9.7
Cc: linux-serial@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708181107.56087.arvidjaar@mail.ru> <200708212228.50877.arvidjaar@mail.ru> <200708211334.58157.bjorn.helgaas@hp.com>
In-Reply-To: <200708211334.58157.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1931524.MNiLa1mESb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708242142.37001.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1931524.MNiLa1mESb
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 21 August 2007, Bjorn Helgaas wrote:
> On Tuesday 21 August 2007 12:28:49 pm Andrey Borzenkov wrote:
> > On Monday 20 August 2007, Bjorn Helgaas wrote:
> > > On Monday 20 August 2007 10:28:22 am Andrey Borzenkov wrote:
> > > > This worked in 2.6.22 with the same quirks. I will test without lat=
er
> > > > but I fail to see how they are related.
> > >
> > > OK, let me know what happens.  The way it's related is that the quirk
> > > fiddles with the IRDA device, and it probably changes the SIR config
> > > so that it starts responding at the ttyS3 address.
> >
> > You are probably right. Disabling quirk makes it work again (with pnp o=
ff
> > in smsc-ircc2 of course).
>
> I think pnp is off in smsc-ircc2 by default, right?
>
> > Hmm ... is there any reason why this quirk is in PnP core in the first
> > place? Would not it be more logical to have it in (PnP) part of
> > smsc-ircc2? This way it could share code with legacy detection; and it
> > even may have chance to work - assuming BIOS is aware that 0x100 is
> > claimed by PCMCIA it could allocate different port when we try to
> > activate device after that ... should I give it a try?
>
> I agree it would make sense to put the quirk in smsc-ircc2, since
> we only need it if we want to use the smsc-ircc2 driver.  But I don't
> think we have a mechanism for calling quirks at module load-time, so
> it has to be part of the static kernel.  And we don't have anything
> like DECLARE_PCI_FIXUP_SECTION, so it really has to be in quirks.c for
> now.
>
> How does the following patch look?
>

I am fine with any patch that works. Of course, it would be better to fix 8=
250=20
to respect PnP (it does load 8250_pnp in the first place).

Thank you

>
>
> PNP: remove SMCf010 quirk
>
> If the quirk enables the SIR part of the SMCf010 device, the 8250 driver
> may claim it as a legacy ttyS device, which makes the legacy probe in the
> smsc-ircc2 driver fail.
>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>
> Index: w/drivers/pnp/quirks.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- w.orig/drivers/pnp/quirks.c	2007-08-21 12:34:51.000000000 -0600
> +++ w/drivers/pnp/quirks.c	2007-08-21 12:35:08.000000000 -0600
> @@ -107,108 +107,6 @@
>  		       "pnp: SB audio device quirk - increasing port range\n");
>  }
>
> -static int quirk_smc_fir_enabled(struct pnp_dev *dev)
> -{
> -	unsigned long firbase;
> -	u8 bank, high, low, chip;
> -
> -	if (!pnp_port_valid(dev, 1))
> -		return 0;
> -
> -	firbase =3D pnp_port_start(dev, 1);
> -
> -	/* Select register bank 3 */
> -	bank =3D inb(firbase + 7);
> -	bank &=3D 0xf0;
> -	bank |=3D 3;
> -	outb(bank, firbase + 7);
> -
> -	high =3D inb(firbase + 0);
> -	low =3D inb(firbase + 1);
> -	chip =3D inb(firbase + 2);
> -
> -	/* This corresponds to the check in smsc_ircc_present() */
> -	if (high =3D=3D 0x10 && low =3D=3D 0xb8 && (chip =3D=3D 0xf1 || chip =
=3D=3D 0xf2))
> -		return 1;
> -
> -	return 0;
> -}
> -
> -static void quirk_smc_enable(struct pnp_dev *dev)
> -{
> -	struct resource fir, sir, irq;
> -
> -	pnp_activate_dev(dev);
> -	if (quirk_smc_fir_enabled(dev))
> -		return;
> -
> -	/*
> -	 * Sometimes the BIOS claims the device is enabled, but it reports
> -	 * the wrong FIR resources or doesn't properly configure ISA or LPC
> -	 * bridges on the way to the device.
> -	 *
> -	 * HP nc6000 and nc8000/nw8000 laptops have known problems like
> -	 * this.  Fortunately, they do fix things up if we auto-configure
> -	 * the device using its _PRS and _SRS methods.
> -	 */
> -	dev_err(&dev->dev, "%s not responding at SIR 0x%lx, FIR 0x%lx; "
> -		"auto-configuring\n", dev->id->id,
> -		(unsigned long)pnp_port_start(dev, 0),
> -		(unsigned long)pnp_port_start(dev, 1));
> -
> -	pnp_disable_dev(dev);
> -	pnp_init_resource_table(&dev->res);
> -	pnp_auto_config_dev(dev);
> -	pnp_activate_dev(dev);
> -	if (quirk_smc_fir_enabled(dev)) {
> -		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
> -			(unsigned long)pnp_port_start(dev, 0),
> -			(unsigned long)pnp_port_start(dev, 1));
> -		return;
> -	}
> -
> -	/*
> -	 * The Toshiba Portege 4000 _CRS reports the FIR region first,
> -	 * followed by the SIR region.  The BIOS will configure the bridge,
> -	 * but only if we call _SRS with SIR first, then FIR.  It also
> -	 * reports the IRQ as active high, when it is really active low.
> -	 */
> -	dev_err(&dev->dev, "not responding at SIR 0x%lx, FIR 0x%lx; "
> -		"swapping SIR/FIR and reconfiguring\n",
> -		(unsigned long)pnp_port_start(dev, 0),
> -		(unsigned long)pnp_port_start(dev, 1));
> -
> -	/*
> -	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
> -	 * these resources any more.
> -	 */
> -	fir =3D dev->res.port_resource[0];
> -	sir =3D dev->res.port_resource[1];
> -	fir.flags &=3D ~IORESOURCE_AUTO;
> -	sir.flags &=3D ~IORESOURCE_AUTO;
> -
> -	irq =3D dev->res.irq_resource[0];
> -	irq.flags &=3D ~IORESOURCE_AUTO;
> -	irq.flags &=3D ~IORESOURCE_BITS;
> -	irq.flags |=3D IORESOURCE_IRQ_LOWEDGE;
> -
> -	pnp_disable_dev(dev);
> -	dev->res.port_resource[0] =3D sir;
> -	dev->res.port_resource[1] =3D fir;
> -	dev->res.irq_resource[0] =3D irq;
> -	pnp_activate_dev(dev);
> -
> -	if (quirk_smc_fir_enabled(dev)) {
> -		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
> -			(unsigned long)pnp_port_start(dev, 0),
> -			(unsigned long)pnp_port_start(dev, 1));
> -		return;
> -	}
> -
> -	dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\" and "
> -		"email bjorn.helgaas@hp.com\n");
> -}
> -
>  /*
>   *  PnP Quirks
>   *  Cards or devices that need some tweaking due to incomplete resource
> info @@ -229,7 +127,6 @@
>  	{"CTL0043", quirk_sb16audio_resources},
>  	{"CTL0044", quirk_sb16audio_resources},
>  	{"CTL0045", quirk_sb16audio_resources},
> -	{"SMCf010", quirk_smc_enable},
>  	{""}
>  };



--nextPart1931524.MNiLa1mESb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGzxiMR6LMutpd94wRAqkQAKCviIdNhBWIV8dfE+7OL8CEUoI86ACgsXp3
KR+jMPn8o59d5pTxFf5YdT4=
=TdAd
-----END PGP SIGNATURE-----

--nextPart1931524.MNiLa1mESb--

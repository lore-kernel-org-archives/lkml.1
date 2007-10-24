Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbXJXFaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbXJXFaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXJXFa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:30:26 -0400
Received: from ozlabs.org ([203.10.76.45]:39616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbXJXFaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:30:24 -0400
Subject: Re: [PATCH 3/4]: [PCI]: Add quirk for devices which disable MSI
	when INTX_DISABLE is set.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, barkalow@iabervon.org,
       linas@austin.ibm.com, chunhao.huang@hotmail.com, gregkh@suse.de,
       htejun@gmail.com, brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
In-Reply-To: <20071023.195310.131105752.davem@davemloft.net>
References: <20071023.195310.131105752.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dAihurO9v4m3IUXAOARf"
Date: Wed, 24 Oct 2007 15:30:21 +1000
Message-Id: <1193203821.8788.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dAihurO9v4m3IUXAOARf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-23 at 19:53 -0700, David Miller wrote:
> A reasonably common problem with some devices is that they will
> disable MSI generation when the INTX_DISABLE bit is set in the
> PCI_COMMAND register.
>=20
> Quirk this explicitly, guarding the pci_intx() calls in msi.c with
> this quirk indication.
>=20
> The first entries for this quirk are for 5714 and 5780 Tigon3 chips,
> and thus we can remove the workaround code from the tg3.c driver.
>=20
> Signed-off-by: David S. Miller <davem@davemloft.net>

> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 87e0161..a8dd18c 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -237,7 +237,8 @@ static void __pci_restore_msi_state(struct pci_dev *d=
ev)
>  	entry =3D get_irq_msi(dev->irq);
>  	pos =3D entry->msi_attrib.pos;
> =20
> -	pci_intx(dev, 0);		/* disable intx */
> +	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
> +		pci_intx(dev, 0); /* disable intx */
>  	msi_set_enable(dev, 0);
>  	write_msi_msg(dev->irq, &entry->msg);
>  	if (entry->msi_attrib.maskbit)
> @@ -260,7 +261,8 @@ static void __pci_restore_msix_state(struct pci_dev *=
dev)
>  		return;
> =20
>  	/* route the table */
> -	pci_intx(dev, 0);		/* disable intx */
> +	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
> +		pci_intx(dev, 0); /* disable intx */
>  	msix_set_enable(dev, 0);
> =20
>  	list_for_each_entry(entry, &dev->msi_list, list) {
> @@ -343,7 +345,8 @@ static int msi_capability_init(struct pci_dev *dev)
>  	}
> =20
>  	/* Set MSI enabled bits	 */
> -	pci_intx(dev, 0);		/* disable intx */
> +	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
> +		pci_intx(dev, 0); /* disable intx */
>  	msi_set_enable(dev, 1);
>  	dev->msi_enabled =3D 1;
> =20
> @@ -433,7 +436,8 @@ static int msix_capability_init(struct pci_dev *dev,
>  		i++;
>  	}
>  	/* Set MSI-X enabled bits */
> -	pci_intx(dev, 0);		/* disable intx */
> +	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
> +		pci_intx(dev, 0); /* disable intx */
>  	msix_set_enable(dev, 1);
>  	dev->msix_enabled =3D 1;
> =20
> @@ -528,7 +532,8 @@ void pci_disable_msi(struct pci_dev* dev)
>  		return;
> =20
>  	msi_set_enable(dev, 0);
> -	pci_intx(dev, 1);		/* enable intx */
> +	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
> +		pci_intx(dev, 1); /* enable intx */
>  	dev->msi_enabled =3D 0;
> =20
>  	BUG_ON(list_empty(&dev->msi_list));
> @@ -640,7 +645,8 @@ void pci_disable_msix(struct pci_dev* dev)
>  		return;
> =20
>  	msix_set_enable(dev, 0);
> -	pci_intx(dev, 1);		/* enable intx */
> +	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
> +		pci_intx(dev, 1); /* enable intx */
>  	dev->msix_enabled =3D 0;
> =20
>  	msix_free_all_irqs(dev);


That looks like 6 hunks doing exactly the same thing? What about
creating a pci_intx_quirked() (or something) that checks the flag and
then does/or does not call pci_intx().

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-dAihurO9v4m3IUXAOARf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHHthtdSjSd0sB4dIRAqAbAJwMiU3PtXhwdWjID2d4cVuAmKL1TgCgpGc5
58LPkL8tnd7Feg1rwjlmGCo=
=iWQQ
-----END PGP SIGNATURE-----

--=-dAihurO9v4m3IUXAOARf--


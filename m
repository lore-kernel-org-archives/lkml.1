Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbZAUCaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbZAUCaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 21:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZAUCaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 21:30:20 -0500
Received: from ozlabs.org ([203.10.76.45]:36949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZAUCaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 21:30:18 -0500
Subject: Re: [PATCH 1/2] PCI/MSI: Introduce pci_msix_table_size()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <200901210118.44162.rjw@sisk.pl>
References: <200901131457.58164.rjw@sisk.pl>
	 <49744142.2060806@jp.fujitsu.com> <200901210116.09211.rjw@sisk.pl>
	 <200901210118.44162.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HFWE7Qsu9O8gvSnQJN/h"
Date: Wed, 21 Jan 2009 13:30:15 +1100
Message-Id: <1232505015.11241.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HFWE7Qsu9O8gvSnQJN/h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-21 at 01:18 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> Introduce new function pci_msix_table_size() returning the size of
> the MSI-X table of given PCI device or 0 if the device doesn't
> support MSI-X.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/msi.c   |   24 +++++++++++++++++++-----
>  include/linux/pci.h |    5 +++++
>  2 files changed, 24 insertions(+), 5 deletions(-)
>=20
> Index: linux-2.6/drivers/pci/msi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/pci/msi.c
> +++ linux-2.6/drivers/pci/msi.c
> @@ -670,6 +670,23 @@ static int msi_free_irqs(struct pci_dev*
>  }
> =20
>  /**
> + * pci_msix_table_size - return the number of device's MSI-X table entri=
es
> + * @dev: pointer to the pci_dev data structure of MSI-X device function
> + */
> +int pci_msix_table_size(struct pci_dev *dev)
> +{
> +	int pos;
> +	u16 control;
> +
> +	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSIX);
> +	if (!pos)
> +		return 0;
> +
> +	pci_read_config_word(dev, msi_control_reg(pos), &control);
> +	return multi_msix_capable(control);
> +}
> +
> +/**
>   * pci_enable_msix - configure device's MSI-X capability structure
>   * @dev: pointer to the pci_dev data structure of MSI-X device function
>   * @entries: pointer to an array of MSI-X entries
> @@ -686,9 +703,8 @@ static int msi_free_irqs(struct pci_dev*
>   **/
>  int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int=
 nvec)
>  {
> -	int status, pos, nr_entries;
> +	int status, nr_entries;
>  	int i, j;
> -	u16 control;
> =20
>  	if (!entries)
>   		return -EINVAL;
> @@ -697,9 +713,7 @@ int pci_enable_msix(struct pci_dev* dev,
>  	if (status)
>  		return status;
> =20
> -	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSIX);
> -	pci_read_config_word(dev, msi_control_reg(pos), &control);
> -	nr_entries =3D multi_msix_capable(control);
> +	nr_entries =3D pci_msix_table_size(dev);
>  	if (nvec > nr_entries)
>  		return -EINVAL;

I see similar code in msix_capability_init(), although it still needs
pos. Did you deliberately not replace that, or just miss it?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-HFWE7Qsu9O8gvSnQJN/h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl2iLcACgkQdSjSd0sB4dI09wCdHvsG5+au4LXQgPn8vGjFCT1o
IlQAoKn8wpG7tRzX3uECzID/joHffcNS
=5pCi
-----END PGP SIGNATURE-----

--=-HFWE7Qsu9O8gvSnQJN/h--


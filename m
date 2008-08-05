Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbYHEKds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbYHEKds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbYHEKdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:33:40 -0400
Received: from ozlabs.org ([203.10.76.45]:39530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472AbYHEKdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:33:39 -0400
Subject: Re: [patch] PCI: check the return value of
	device_create_bin_file() in pci_create_bus()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20080805101605.GA19382@verge.net.au>
References: <20080805101605.GA19382@verge.net.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c9rF5QJXHj1VRx1m/AKn"
Date: Tue, 05 Aug 2008 20:33:36 +1000
Message-Id: <1217932416.7758.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c9rF5QJXHj1VRx1m/AKn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 20:16 +1000, Simon Horman wrote:
> Check the return value of device_create_bin_file in pci_create_bus,
> unwind if neccessary, and propogate any errors to the caller.
>=20
> Signed-off-by: Simon Horman <horms@verge.net.au>

Hi Horms,

Fixing these kinds of warnings is highly useful but thankless work, so I
hate to nit pick ..

> Index: linux-2.6/drivers/pci/probe.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/pci/probe.c	2008-08-05 19:58:43.000000000 +100=
0
> +++ linux-2.6/drivers/pci/probe.c	2008-08-05 19:59:15.000000000 +1000
> @@ -53,26 +53,37 @@ EXPORT_SYMBOL(no_pci_devices);
>   * a per-bus basis.  This routine creates the files and ties them into
>   * their associated read, write and mmap files from pci-sysfs.c
>   */
> -static void pci_create_legacy_files(struct pci_bus *b)
> +static int pci_create_legacy_files(struct pci_bus *b)
>  {
> +	int error;
> +
>  	b->legacy_io =3D kzalloc(sizeof(struct bin_attribute) * 2,
>  			       GFP_ATOMIC);
> -	if (b->legacy_io) {
> -		b->legacy_io->attr.name =3D "legacy_io";
> -		b->legacy_io->size =3D 0xffff;
> -		b->legacy_io->attr.mode =3D S_IRUSR | S_IWUSR;
> -		b->legacy_io->read =3D pci_read_legacy_io;
> -		b->legacy_io->write =3D pci_write_legacy_io;
> -		device_create_bin_file(&b->dev, b->legacy_io);
> -
> -		/* Allocated above after the legacy_io struct */
> -		b->legacy_mem =3D b->legacy_io + 1;
> -		b->legacy_mem->attr.name =3D "legacy_mem";
> -		b->legacy_mem->size =3D 1024*1024;
> -		b->legacy_mem->attr.mode =3D S_IRUSR | S_IWUSR;
> -		b->legacy_mem->mmap =3D pci_mmap_legacy_mem;
> -		device_create_bin_file(&b->dev, b->legacy_mem);
> +	if (!b->legacy_io)
> +		return -ENOMEM;
> +
> +	b->legacy_io->attr.name =3D "legacy_io";
> +	b->legacy_io->size =3D 0xffff;
> +	b->legacy_io->attr.mode =3D S_IRUSR | S_IWUSR;
> +	b->legacy_io->read =3D pci_read_legacy_io;
> +	b->legacy_io->write =3D pci_write_legacy_io;
> +	error =3D device_create_bin_file(&b->dev, b->legacy_io);
> +	if (error)
> +		return error;

Should we kfree(b->legacy_io) here?

> +
> +	/* Allocated above after the legacy_io struct */
> +	b->legacy_mem =3D b->legacy_io + 1;
> +	b->legacy_mem->attr.name =3D "legacy_mem";
> +	b->legacy_mem->size =3D 1024*1024;
> +	b->legacy_mem->attr.mode =3D S_IRUSR | S_IWUSR;
> +	b->legacy_mem->mmap =3D pci_mmap_legacy_mem;
> +	error =3D device_create_bin_file(&b->dev, b->legacy_mem);
> +	if (error) {
> +		device_remove_bin_file(&b->dev, b->legacy_io);
> +		return error;

And here?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-c9rF5QJXHj1VRx1m/AKn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBImCyAdSjSd0sB4dIRAtppAKCzLdnpERMnBEEHD6ovKhTKef5wIwCgpNuF
WuImt8x9y0xe2rw3WJAUUQY=
=1e0B
-----END PGP SIGNATURE-----

--=-c9rF5QJXHj1VRx1m/AKn--


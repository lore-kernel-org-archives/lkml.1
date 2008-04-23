Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYDWXgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYDWXgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYDWXg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:36:28 -0400
Received: from ozlabs.org ([203.10.76.45]:54952 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYDWXg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:36:27 -0400
Subject: Re: [PATCH 2/2 v2] mpic_u3msi: mpic_u3msi: failed allocation
	unnoticed
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <480FB766.1040405@tiscali.nl>
References: <480F6905.3070808@tiscali.nl> <480F8754.7000200@tiscali.nl>
	 <df21920e067e73985f73047e2d8bcbda@kernel.crashing.org>
	 <480FB766.1040405@tiscali.nl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8GpWhTeuSTtojLzOKg5B"
Date: Thu, 24 Apr 2008 09:36:23 +1000
Message-Id: <1208993783.9245.10.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8GpWhTeuSTtojLzOKg5B
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-24 at 00:25 +0200, Roel Kluin wrote:
> Segher Boessenkool wrote:
> >> bitmap_find_free_region(), called by mpic_msi_alloc_hwirqs() may
> >> return -ENOMEM, but hwirq of type irq_hw_number_t which is unsigned.
> >=20
> >>      list_for_each_entry(entry, &pdev->msi_list, list) {
> >>          hwirq =3D mpic_msi_alloc_hwirqs(msi_mpic, 1);
> >> -        if (hwirq < 0) {
> >> +        if (hwirq =3D=3D -ENOMEM) {
>=20
> >=20
> > Please test for _all_ error values, instead.
> >
> > Segher
>=20
> In this case -ENOMEM was _all_ error values, but I get your point.
> ---
> bitmap_find_free_region(), called by mpic_msi_alloc_hwirqs() may return
> signed, but hwirq is unsigned. A failed allocation remains unnoticed.
>=20
> diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_=
u3msi.c
> index 1d5a408..e790f39 100644
> --- a/arch/powerpc/sysdev/mpic_u3msi.c
> +++ b/arch/powerpc/sysdev/mpic_u3msi.c
> @@ -115,14 +115,16 @@ static int u3msi_setup_msi_irqs(struct pci_dev *pde=
v, int nvec, int type)
>  	struct msi_desc *entry;
>  	struct msi_msg msg;
>  	u64 addr;
> +	int ret;
> =20
>  	addr =3D find_ht_magic_addr(pdev);
>  	msg.address_lo =3D addr & 0xFFFFFFFF;
>  	msg.address_hi =3D addr >> 32;
> =20
>  	list_for_each_entry(entry, &pdev->msi_list, list) {
> -		hwirq =3D mpic_msi_alloc_hwirqs(msi_mpic, 1);
> -		if (hwirq < 0) {
> +		ret =3D mpic_msi_alloc_hwirqs(msi_mpic, 1);
> +		hwirq =3D ret;
> +		if (ret < 0) {
>  			pr_debug("u3msi: failed allocating hwirq\n");
>  			return hwirq;
>  		}

I'm not sure I like this.

I think the real bug is that we're using irq_hw_number_t to represent
something which isn't. At the end of the day we have to stash the hwirq
into the MSI message data, which is a u32.

I guess we could imagine a driver that does something magic to allow it
to put something bigger than a u32 in the MSI message, but I doubt it.

So I think =EF=BB=BFmpic_msi_alloc_hwirqs() should return a long, which all=
ows
it to return a full u32 plus the negative error values.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-8GpWhTeuSTtojLzOKg5B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBID8f3dSjSd0sB4dIRAjyQAKCRALbHHHRocgOH5Gk6zGli1vVb6ACgxl0R
zE48ZsRm2bkyrU0O2Sf1Kq8=
=SliZ
-----END PGP SIGNATURE-----

--=-8GpWhTeuSTtojLzOKg5B--


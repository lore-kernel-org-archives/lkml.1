Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYJ2Awm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYJ2Awm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 20:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYJ2Awf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 20:52:35 -0400
Received: from ozlabs.org ([203.10.76.45]:45606 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbYJ2Awe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 20:52:34 -0400
Subject: Re: [UDATED PATCH] Cell OProfile: Incorrect local array size in
	activate spu profiling function
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Carl Love <cel@us.ibm.com>
Cc: Hannsj_uhl <Hannsj_uhl@de.ibm.com>, acjohnso <acjohnso@us.ibm.com>,
       oprofile-list@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       cel@linux.vnet.ibm.com, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1225207079.20229.32.camel@carll-linux-desktop>
References: <1224874049.20229.5.camel@carll-linux-desktop>
	 <1224909595.16090.5.camel@localhost>
	 <1225207079.20229.32.camel@carll-linux-desktop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F37/VKuKNQ7OV13XM6/S"
Date: Wed, 29 Oct 2008 11:51:54 +1100
Message-Id: <1225241514.7799.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F37/VKuKNQ7OV13XM6/S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 08:17 -0700, Carl Love wrote:
> Updated the patch to address comments by Michael Ellerman. =20
> Specifically, changed upper limit in for loop to=20
> ARRAY_SIZE() macro and added a check to make sure the=20
> number of events specified by the user, which is used as
> the max for indexing various arrays, is no bigger then the
> declared size of the arrays.
>=20
> The size of the pm_signal_local array should be equal to the
> number of SPUs being configured in the array.  Currently, the
> array is of size 4 (NR_PHYS_CTRS) but being indexed by a for=20
> loop from 0 to 7 (NUM_SPUS_PER_NODE). =20
>=20
> Signed-off-by: Carl Love <carll@us.ibm.com>
>=20
>=20
> Index: Cell_kernel_10_24_2008/arch/powerpc/oprofile/op_model_cell.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- Cell_kernel_10_24_2008.orig/arch/powerpc/oprofile/op_model_cell.c
> +++ Cell_kernel_10_24_2008/arch/powerpc/oprofile/op_model_cell.c
> @@ -582,6 +582,13 @@ static int cell_reg_setup(struct op_coun
> =20
>  	num_counters =3D num_ctrs;
> =20
> +	if (unlikely(num_ctrs > NR_PHYS_CTRS)) {
> +		printk(KERN_ERR
> +		       "%s: Oprofile, number of specified events " \
> +		       "exceeds number of physical counters\n",
> +		       __func__);
> +		return -EIO;
> +	}

I wouldn't bother with the unlikely, but whatever, looks good.

>  	pm_regs.group_control =3D 0;
>  	pm_regs.debug_bus_control =3D 0;
> =20
> @@ -830,13 +837,13 @@ static int calculate_lfsr(int n)
>  static int pm_rtas_activate_spu_profiling(u32 node)
>  {
>  	int ret, i;
> -	struct pm_signal pm_signal_local[NR_PHYS_CTRS];
> +	struct pm_signal pm_signal_local[NUM_SPUS_PER_NODE];
> =20
>  	/*
>  	 * Set up the rtas call to configure the debug bus to
>  	 * route the SPU PCs.  Setup the pm_signal for each SPU
>  	 */
> -	for (i =3D 0; i < NUM_SPUS_PER_NODE; i++) {
> +	for (i =3D 0; i < ARRAY_SIZE(pm_signal_local); i++) {
>  		pm_signal_local[i].cpu =3D node;
>  		pm_signal_local[i].signal_group =3D 41;
>  		/* spu i on word (i/2) */

Looks good, but ..

You should patch the call to rtas_ibm_cbe_perftools() as well, like:

        ret =3D rtas_ibm_cbe_perftools(SUBFUNC_ACTIVATE,
                                     PASSTHRU_ENABLE, pm_signal_local,
				     sizeof(pm_signal_local));


cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-F37/VKuKNQ7OV13XM6/S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJB7OqdSjSd0sB4dIRArIxAKDEqWlhb3PwdKWlbPg4ZzHbyU/WegCgzHLN
YZmm0k7gqEa20cfbOEt0yec=
=v/vL
-----END PGP SIGNATURE-----

--=-F37/VKuKNQ7OV13XM6/S--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZHMCXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZHMCXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZHMCXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:23:16 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:33519 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZHMCXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:23:15 -0400
Subject: Re: [PATCH] Add kmemleak annotations to lmb.c
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: linuxppc-dev@ozlabs.org
Cc: catalin.marinas@arm.com, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <3437d193a392e9d365f18b3d90c52de95a590086.1249880734.git.michael@ellerman.id.au>
References: <3437d193a392e9d365f18b3d90c52de95a590086.1249880734.git.michael@ellerman.id.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pXuUu6MGIFKYd4VtMCJv"
Date: Thu, 13 Aug 2009 12:23:13 +1000
Message-Id: <1250130193.4850.15.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pXuUu6MGIFKYd4VtMCJv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-10 at 15:05 +1000, Michael Ellerman wrote:
> We don't actually want kmemleak to track the lmb allocations, so we
> pass min_count as 0. However telling kmemleak about lmb allocations
> allows it to scan that memory for pointers to other memory that is
> tracked by kmemleak, ie. slab allocations etc.
>=20
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>  lib/lmb.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/lib/lmb.c b/lib/lmb.c
> index e4a6482..dc10bc5 100644
> --- a/lib/lmb.c
> +++ b/lib/lmb.c
> @@ -352,8 +352,10 @@ u64 __init lmb_alloc_nid(u64 size, u64 align, int ni=
d,
>  		u64 ret =3D lmb_alloc_nid_region(&mem->region[i],
>  					       nid_range,
>  					       size, align, nid);
> -		if (ret !=3D ~(u64)0)
> +		if (ret !=3D ~(u64)0) {
> +			kmemleak_alloc(__va(ret), size, 0, 0);
>  			return ret;
> +		}
>  	}
> =20
>  	return lmb_alloc(size, align);
> @@ -412,6 +414,8 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 =
max_addr)
>  				/* this area isn't reserved, take it */
>  				if (lmb_add_region(&lmb.reserved, base, size) < 0)
>  					return 0;
> +
> +				kmemleak_alloc(__va(base), size, 0, 0);
>  				return base;
>  			}
>  			res_base =3D lmb.reserved.region[j].base;

This needs an include of kmemleak.h for some configs, new patch coming.

cheers

--=-pXuUu6MGIFKYd4VtMCJv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqDeQ0ACgkQdSjSd0sB4dI70ACfeaf+g/Ob47EZ1Ic5STTkndNh
qWAAmwSyreyzdgxO2N4GjGn0/+BSF/kV
=cXJL
-----END PGP SIGNATURE-----

--=-pXuUu6MGIFKYd4VtMCJv--


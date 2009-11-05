Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZKEGir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZKEGir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZKEGiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:38:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39188 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZKEGip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:38:45 -0500
Date: Thu, 5 Nov 2009 17:38:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hollis Blanchard <hollisb@us.ibm.com>, Jan Beulich <JBeulich@novell.com>,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON: make it handle more cases
Message-Id: <20091105173842.c94ba501.sfr@canb.auug.org.au>
In-Reply-To: <200911051658.36265.rusty@rustcorp.com.au>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	<200910201415.34361.rusty@rustcorp.com.au>
	<20091105112020.33f02552.sfr@canb.auug.org.au>
	<200911051658.36265.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Nov_2009_17_38_42_+1100_SZeMKZxOLvyDot_C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Nov_2009_17_38_42_+1100_SZeMKZxOLvyDot_C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Thu, 5 Nov 2009 16:58:36 +1030 Rusty Russell <rusty@rustcorp.com.au> wro=
te:
>
> Huh?  virtio_has_feature does:
>=20
> 	if (__builtin_constant_p(fbit))
> 		BUILD_BUG_ON(fbit >=3D 32);
> 	else
> 		BUG_ON(fbit >=3D 32);

In Linus' tree (and linux-next) it looks like this:

static inline bool virtio_has_feature(const struct virtio_device *vdev,
				      unsigned int fbit)
{
	/* Did you forget to fix assumptions on max features? */
	MAYBE_BUILD_BUG_ON(fbit >=3D 32);

	if (fbit < VIRTIO_TRANSPORT_F_START)
		virtio_check_driver_offered_feature(vdev, fbit);

	return test_bit(fbit, vdev->features);
}

> So, if it's not a constant, gcc should throw away that first branch.  If =
it
> is, it should optimize it away (and no, these are not real bugs AFAICT).

Your version above may well fix the problem.  Alternatively marking it
__always_inline way work as well.

> I did a 4.3.3 allmodconfig with this patch on 64-bit a few days back and =
all
> was fine.  Will try 4.4.0 now.

4.4 is more problematic.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Nov_2009_17_38_42_+1100_SZeMKZxOLvyDot_C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrycvIACgkQjjKRsyhoI8zEUQCguFj9rHXs225EZcpiT0uBdE7x
MjgAniNI+UanGyo+xLtXFeTHIez3L0hb
=AB2V
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Nov_2009_17_38_42_+1100_SZeMKZxOLvyDot_C--

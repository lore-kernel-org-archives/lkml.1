Return-Path: <linux-kernel-owner+w=401wt.eu-S1161470AbXBGWtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161470AbXBGWtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161471AbXBGWtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:49:01 -0500
Received: from ozlabs.org ([203.10.76.45]:52233 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161470AbXBGWtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:49:00 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
	patch
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Maynard Johnson <maynardj@us.ibm.com>
Cc: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org
In-Reply-To: <45C9F317.9010700@us.ibm.com>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com>
	 <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com>
	 <45C9F317.9010700@us.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z1QP1lnSCo7OD6CQhgdp"
Date: Thu, 08 Feb 2007 09:48:57 +1100
Message-Id: <1170888537.7831.14.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z1QP1lnSCo7OD6CQhgdp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-07 at 09:41 -0600, Maynard Johnson wrote:
> Carl Love wrote:
>=20
> >
> >Subject: Add support to OProfile for profiling Cell BE SPUs
> >
> >From: Maynard Johnson <maynardj@us.ibm.com>
> >
> >This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
> >to add in the SPU profiling capabilities.  In addition, a 'cell' subdire=
ctory
> >was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
> >code.
> >
> >Signed-off-by: Carl Love <carll@us.ibm.com>
> >Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
> >
> >Index: linux-2.6.20-rc1/arch/powerpc/configs/cell_defconfig
> > =20
> >
> I've discovered more problems with the kref handling for the cached_info=20
> object that we store in the spu_context.  :-(
>=20
> When the OProfile module initially determines that no cached_info yet=20
> exists for a given spu_context, it creates the cached_info, inits the=20
> cached_info's kref (which increments the refcount) and does a kref_get=20
> (for SPUFS' ref) before passing the cached_info reference off to SUPFS=20
> to store into the spu_context.  When OProfile shuts down or the SPU job=20
> ends, OProfile gives up its ref to the cached_info with kref_put.  Then=20
> when SPUFS destroys the spu_context, it also gives up its ref.  HOWEVER=20
> . . . . If OProfile shuts down while the SPU job is still active _and_=20
> _then_ is restarted while the job is still active, OProfile will find=20
> that the cached_info exists for the given spu_context, so it won't go=20
> through the process of creating it and doing kref_init on the kref. =20
> Under this scenario, OProfile does not own a ref of its own to the=20
> cached_info, and should not be doing a kref_put when done using the=20
> cached_info -- but it does, and so does SPUFS when the spu_context is=20
> destroyed.  The end result (with the code as currently written) is that=20
> an extra kref_put is done when the refcount is already down to zero.  To=20
> fix this, OProfile needs to detect when it finds an existing cached_info=20
> already stored in the spu_context.  Then, instead of creating a new one,=20
> it sets a reminder flag to be used later when it's done using the cached=20
> info to indicate whether or not it needs to call kref_put.

I think all you want to do is when oprofile finds the cached_info
already existing, it does a kref_get(). After all it doesn't have a
reference to it, so before it starts using it it must inc the ref count.

> Unfortunately, there's another problem (one that should have been=20
> obvious to me).  The cached_info's kref "release" function is=20
> destroy_cached_info(), defined in the OProfile module.  If the OProfile=20
> module is unloaded when SPUFS destroys the spu_context and calls=20
> kref_put on the cached_info's kref -- KABOOM!  The destroy_cached_info=20
> function (the second arg to kref_put) is not in memory, so we get a=20
> paging fault.  I see a couple options to solve this:
>     1) Don't store the cached_info in the spu_context.  Basically, go=20
> back to the simplistic model of creating/deleting the cached_info on=20
> every SPU task activation/deactivation.
>     2)  If there's some way to do this, force the OProfile module to=20
> stay loaded until SPUFS has destroyed its last spu_context that holds a=20
> cached_info object.

There is a mechanism for that, you just have each cached_info inc the
module's refcount.

Another option would be to have a mapping, in the oprofile code, from
spu_contexts to cached_infos, ie. a hash table or something.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-z1QP1lnSCo7OD6CQhgdp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFyldYdSjSd0sB4dIRAmTvAJ48o6BZVN1t4p0uZ6R3j5We9AXSFgCfbVI6
XZMBGM6M3TA4DSMQsXAWxQ0=
=nqMr
-----END PGP SIGNATURE-----

--=-z1QP1lnSCo7OD6CQhgdp--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbZC0UM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbZC0UM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761896AbZC0UKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:10:37 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:56111 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676AbZC0UKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:10:35 -0400
Subject: Re: DRM lock ordering fix series
From: Eric Anholt <eric@anholt.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
In-Reply-To: <20090327181018.GC11935@one.firstfloor.org>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <87ocvnmhqx.fsf@basil.nowhere.org>
	 <1238170767.8275.2397.camel@gaiman.anholt.net>
	 <1238171805.8275.2434.camel@gaiman.anholt.net>
	 <20090327181018.GC11935@one.firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Vqeuyg/Vbrht32t/i0uC"
Date: Fri, 27 Mar 2009 13:10:29 -0700
Message-Id: <1238184629.625.44.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Vqeuyg/Vbrht32t/i0uC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 19:10 +0100, Andi Kleen wrote:
> On Fri, Mar 27, 2009 at 09:36:45AM -0700, Eric Anholt wrote:
> > > > You are aware that there is a fast path now (get_user_pages_fast) w=
hich
> > > > is significantly faster? (but has some limitations)
> > >=20
> > > In the code I have, get_user_pages_fast is just a wrapper that calls =
the
> > > get_user_pages in the way that I'm calling it from the DRM.
> >=20
> > Ah, I see: that's a weak stub, and there is a real implementation.  I
> > didn't know we could do weak stubs.
>=20
> The main limitation is that it only works for your current process,
> not another one. For more details you can check the git changelog
> that added it (8174c430e445a93016ef18f717fe570214fa38bf)
>=20
> And yes it's only faster for architectures that support it, that's
> currently x86 and ppc.

OK.  I'm not too excited here -- 10% of 2% of the CPU time doesn't get
me to the 10% loss that the slow path added up to.  Most of the cost is
in k{un,}map_atomic of the returned pages.  If the gup somehow filled in
the user's PTEs, I'd be happy and always use that (since then I'd have
the mapping already in place and just use that).  But I think I can see
why that can't be done.

I suppose I could rework this so that we get_user_pages_fast outside the
lock, then walk doing copy_from_user_inatomic, and fall back to
kmap_atomic of the page list if we fault on the user's address.  It's
still going to be a cost in our hot path, though, so I'd rather not.

I'm working on a set of tests and microbenchmarks for GEM, so other
people will be able to play with this easily soon.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-Vqeuyg/Vbrht32t/i0uC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknNMrMACgkQHUdvYGzw6vcfHgCdE2I9kRsnbsUDubUHjiQ3lERb
3Z8An34TKzxaB3sbOHuEMuhrbQsO7Sjv
=ENwZ
-----END PGP SIGNATURE-----

--=-Vqeuyg/Vbrht32t/i0uC--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbXIMCFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbXIMCFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 22:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXIMCFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 22:05:46 -0400
Received: from ozlabs.org ([203.10.76.45]:33013 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXIMCFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 22:05:45 -0400
Subject: Re: [PATCH 15/15] Add DEFINE_SPUFS_ATTRIBUTE()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200709121047.05471.arnd@arndb.de>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
	 <f5fe712aef37d925902f3f6183f024b916cc89db.1189583010.git.michael@ellerman.id.au>
	 <1189583353.17835.22.camel@concordia.ozlabs.ibm.com>
	 <200709121047.05471.arnd@arndb.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oYh9g2k3bx1l2wvBffuN"
Date: Thu, 13 Sep 2007 12:05:41 +1000
Message-Id: <1189649141.19087.13.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oYh9g2k3bx1l2wvBffuN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-12 at 10:47 +0200, Arnd Bergmann wrote:
> On Wednesday 12 September 2007, Michael Ellerman wrote:
> > On Wed, 2007-09-12 at 17:43 +1000, Michael Ellerman wrote:
> > > This patch adds DEFINE_SPUFS_ATTRIBUTE(), a wraper around
> > > DEFINE_SIMPLE_ATTRIBUTE which does the specified locking for the get
> > > routine for us.
> > >=20
> > > Unfortunately we need two get routines (a locked and unlocked version=
) to
> > > support the coredump code. This patch hides one of those (the locked =
version)
> > > inside the macro foo.
>=20
> >=20
> > jk said:
> > > "Good god man!"
> >=20
> > Yeah, I'm a bit lukewarm on this one. But the diffstat is nice, 50% cod=
e
> > reduction ain't bad :)
>=20
> Have you looked at the change in object code size? I would expect the
> object code to actually become bigger. I also think that it hurts
> readability rather than help it.

Yeah I did, it's smaller actually:

   text    data     bss     dec     hex filename
  44898   17804     120   62822    f566 spufs-before.o
  44886   17804     120   62810    f55a spufs-after.o

> Maybe a better solution is to change the core dump code to not
> require the mutex to be held in the first place. By the time
> we get to call the get functions, it should already be in
> saved state and no longer be able to get scheduled, so we might
> not actually need all the extra tricks with avoiding the
> mutex to be taken again.

Well that'd be nice, but I don't see anywhere that that happens. AFAICT
the acquire we do in the first coredump callback is the first the SPU
contexts know about their PPE process dying. And spufs is still live, so
I think we definitely need to grab the mutex, or we might race with
userspace accessing spufs files.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-oYh9g2k3bx1l2wvBffuN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG6Jr1dSjSd0sB4dIRAmdjAKCI23oMOPJddZy9CBS8dLfeLMmH7QCgnpLf
AGfWajn6wu1RqSSRhoAvRRs=
=W2xN
-----END PGP SIGNATURE-----

--=-oYh9g2k3bx1l2wvBffuN--


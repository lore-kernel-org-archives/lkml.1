Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbYBQLuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbYBQLuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 06:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYBQLuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 06:50:08 -0500
Received: from ozlabs.org ([203.10.76.45]:59928 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbYBQLuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 06:50:06 -0500
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Arjan van de Ven <arjan@infradead.org>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>, linuxppc-dev@ozlabs.org,
       Roel Kluin <12o3l@tiscali.nl>, Willy Tarreau <w@1wt.eu>,
       lkml <linux-kernel@vger.kernel.org>, cbe-oss-dev@ozlabs.org
In-Reply-To: <20080216103927.2a02352b@laptopd505.fenrus.org>
References: <47B70A61.9030306@tiscali.nl>
	 <20080216092552.325e5726@laptopd505.fenrus.org>
	 <20080216173315.GU8953@1wt.eu>
	 <20080216094226.1e8eede1@laptopd505.fenrus.org>
	 <47B72BFE.9060302@am.sony.com>
	 <20080216103927.2a02352b@laptopd505.fenrus.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Bw+OjBsWfZC8CV3ijKEj"
Date: Sun, 17 Feb 2008 22:50:03 +1100
Message-Id: <1203249003.6718.24.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Bw+OjBsWfZC8CV3ijKEj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-02-16 at 10:39 -0800, Arjan van de Ven wrote:
> > >> > you found a great set of bugs..
> > >> > but to be honest... I suspect it's just best to remove unlikely
> > >> > altogether for these cases; unlikely() is almost a
> > >> > go-faster-stripes thing, and if you don't know how to use it you
> > >> > shouldn't be using it... so just removing it for all wrong cases
> > >> > is actually the best thing to do imo.

Hi Arjan,

In general I agree with you that unlikely() is overused, and often in
inappropriate places.

> for mordern (last 10 years) x86 cpus... the cpu branchpredictor is better
> than the coder in general. Same for most other architectures.
>=20
> unlikely() creates bigger code as well.
>=20
> Now... we're talking about your super duper hotpath function here right?
> One where you care about 0.5 cycle speed improvement? (less on modern
> systems ;)

The first patch was to platforms/ps3 code, which runs on the Cell, in
particular the PPE ... which is not an x86 :)

eg:

[michael@schoenaich ~]$ cat branch.c
#include <stdio.h>
int main(void)
{
        int i, j;

        for (i =3D 0, j =3D 0; i < 1000000000; i++)
                if (i % 4 =3D=3D 0)
                        j++;

        printf("j =3D %d\n", j);
        return 0;
}
[michael@schoenaich ~]$ ppu-gcc -Wall -O3 -o branch branch.c
[michael@schoenaich ~]$ time ./branch
real    0m5.172s

[michael@schoenaich ~]$ cat branch.c
..
        for (i =3D 0, j =3D 0; i < 1000000000; i++)
                if (__builtin_expect(i % 4 =3D=3D 0, 0))
                        j++;
..
[michael@schoenaich ~]$ ppu-gcc -Wall -O3 -o branch branch.c
[michael@schoenaich ~]$ time ./branch
real    0m3.762s


Which looks as though unlikely() is helping. Admittedly we don't have a
lot of kernel code that looks like that, but at least unlikely is doing
what we want it to.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-Bw+OjBsWfZC8CV3ijKEj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHuB9rdSjSd0sB4dIRAlc3AKCSqznNR2VGMc0CJgu09lg5TF8oPQCgvPJ9
Y9eLdFTtOKF/JB5EtEzwSGI=
=9rV7
-----END PGP SIGNATURE-----

--=-Bw+OjBsWfZC8CV3ijKEj--


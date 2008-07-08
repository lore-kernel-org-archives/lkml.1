Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYGHQHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYGHQHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYGHQHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:07:11 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYGHQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:07:09 -0400
Subject: Re: [PATCH] CONFIG_KMOD needs to be default y
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <200807082303.26194.rusty@rustcorp.com.au>
References: <1215517771.9610.28.camel@johannes.berg>
	 <20080708124208.GA6704@infradead.org>
	 <200807082303.26194.rusty@rustcorp.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rx8yDPjSCz+FUX3y/6vH"
Date: Tue, 08 Jul 2008 18:06:15 +0200
Message-Id: <1215533175.9610.51.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rx8yDPjSCz+FUX3y/6vH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-08 at 23:03 +1000, Rusty Russell wrote:

> > What about just killing the config option entirely?  It' basically
> > guarding a ~50 lines function + a sysctl variable.  I think having
> > modules but not CONFIG_KMOD is entirely unreasonable.
>=20
> I agree with Christoph here.

Yeah, like I said, I wasn't sure why it's there anyway.

> But as a patch series please: it's spread pretty wide.  eg. first make it=
 a=20
> non-prompting CONFIG option, then remove the users, then finally kill it.

Sure.

> Some existing request_module users might be able to use=20
> try_then_request_module, too...

try_then_request_module seems buggy though. Or at least, doing something
unexpected. Here's the macro, for reference:

#define try_then_request_module(x, mod...) ((x) ?: (request_module(mod), (x=
)))

I think it should be
#define try_then_request_module(x, mod...) \
	((x) ?: ({request_module(mod); (x)}))

the difference being that it returns the result of the second "x" when
the first "x" fails. A potential user would be
net/bridge/netfilter/ebtables.c:

        ret =3D find_inlist_lock_noload(head, name, error, mutex);
        if (!ret) {
                request_module("%s%s", prefix, name);
                ret =3D find_inlist_lock_noload(head, name, error, mutex);
        }

which could then be written as

ret =3D try_then_request_module(
	find_inlist_lock_noload(head, name, error, mutex),
	"%s%s", prefix, name);

Also, in the case of MODULES=3Dn, I think it should just be

static inline void printf_check(char *name, ...) __attribute__((format(prin=
tf, 1, 2))) {};
#define try_then_request_module(x, mod...) \
	({ printf_check(mod); (x) })

so (x) is only evaluated once.

A different variation you could make a case for is to not re-evaluate x
if request_module fails, which would then automatically collapse the
MODULES=3Dn case:

#define try_then_request_module(x, mod...) \
	({ typeof(x) __ret =3D (x); __ret ?: \
		(request_module(mod) ? __r : (x)); })

johannes

--=-rx8yDPjSCz+FUX3y/6vH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc5BzAAoJEKVg1VMiehFY8+oP/29NDYKseyH7ajgzGXdkPw0l
uMcuP8j1vayGwgjf10k7fr7qHRVPR/UJvu5fyGYOv6Zlt6PogeiWvoHum+S/V6cL
A6soZ0htg7Ru/kK2hSpz9/ILd2J3peVVINNPhPFiPaUp7Le1YS5p99qm0W/HvxKn
vpa55XNozVz3JXYx+zbHITH6XE1LDnFuHnup3gLszfKwWUPpCnlKKbvL9MDY058b
awDnntTCeDz5DSYRBdrxLhyF+IW42FR5qKCAB/dgUs1+A/Q5ZIRU+MdU9H9wS2bc
14T45ZMAHRft2XBWlQ6O5TU5OEuX47VKPS7V8YPpvm3FRd7/EZStpFc1x0Sl14d9
PbGdO3d6Nf3djyoGXmYG1c+2GcnZKiUR/+LG9i0S5w1s+sADz4Rt88oi4QjO6EEJ
4tWGqbrO75V8J0hn6XD+bz8NbZiFlMr4cgZJEn71J9utZFi8gO0l85YZRY7x4kkR
aVuqAMZK6yEfeFIgvZF0I2cQ8AYC7+SZvmEhYuymZQodr8LAf7pSdOYVrh+nXvL2
zwedFBqCPcd0/mX7SuMeCSkLb5f6wQ4zjfvyNdWpaFBzhNBqYEf0G2Iqcp4buCHT
4ZIvoIEBHZTn0wIHYAmIgrX+o1lbXR/0DVKpapvUfxToOFZZEjuQk/u/rof7via/
GCZIb6uk38lIqweNSt1R
=wKfA
-----END PGP SIGNATURE-----

--=-rx8yDPjSCz+FUX3y/6vH--


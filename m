Return-Path: <linux-kernel-owner+w=401wt.eu-S1761723AbYDKUyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761723AbYDKUyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbYDKUyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:54:17 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:40372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760017AbYDKUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:54:16 -0400
Subject: Re: Using sparse to catch invalid RCU dereferences?
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-sparse <linux-sparse@vger.kernel.org>
In-Reply-To: <20080410223206.GI8419@linux.vnet.ibm.com>
References: <1207605856.12481.35.camel@johannes.berg>
	 <20080408155259.GA8381@linux.vnet.ibm.com>
	 <1207771787.7442.45.camel@johannes.berg>
	 <20080410223206.GI8419@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oHNW+EEBViP18jY3fdR7"
Date: Fri, 11 Apr 2008 22:54:03 +0200
Message-Id: <1207947243.13354.88.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oHNW+EEBViP18jY3fdR7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-10 at 15:32 -0700, Paul E. McKenney wrote:
> On Wed, Apr 09, 2008 at 10:09:46PM +0200, Johannes Berg wrote:
> >=20
> > > It might be.  There are a number of places where it is legal to acces=
s
> > > RCU-protected pointers directly, and all of these would need to be
> > > changed.  For example, in the example above, one could do:
> > >=20
> > > 	foo =3D NULL;
> >=20
> > Ok, that I understand, but sparse always treats NULL specially anyway.
>=20
> But "int foo =3D 0;" would need the memory barrier -- index 0 of some
> RCU-protected array.

Oh. Hmm, I guess that wouldn't really be possible to find at least not
with sparse right now. Though maybe we can add some sort of annotation
that that special type can't even take zero directly.

> You are right -- I was confused.  The case where you can omit the
> rcu_assign_pointer() would be when building a multiple-element data
> structure that is then published as a unit.  For example:
>=20
> 	p =3D kmalloc(sizeof(*p), GFP_KERNEL);
> 	q =3D kmalloc(sizeof(*p), GFP_KERNEL);
> 	p->next =3D q; /* don't need rcu_assign_pointer() here. */
> 	q->next =3D NULL;  /* or here. */
> 	/* initialize other fields of p and q. */
> 	rcu_assign_pointer(global_pointer, p);
>=20
> The assignment to p->next doesn't have to be rcu_assign_pointer() because
> other CPUs are unable to access the data structure -- only the final
> assignment that publishes the whole group need be rcu_assign_pointer().
> On the other hand, the cost of the extra memory barrier would be
> insignificant in most cases.

Ah. Yeah, but we probably need a "raw" accessor anyway if we're going to
go this route, e.g. for any deref within the update-locked section.

> > I've been playing a bit, see below for my play rcupdate.h and test.c
> > test program.
> >=20
> > Unfortunately, sparse doesn't have the ability to declare
> > "=EF=BB=BF__attribute__((force_bitwise)) typeof(p)" or even
> > "=EF=BB=BF__attribute__((force)) typeof(p)" which makes this force more=
 than
> > necessary and causes it to not catch when incompatible pointers are
> > used. gcc notices that because I only do a cast at all for sparse, but
> > that doesn't help, since e.g. list_for_each_entry_rcu() requires that
> > the correct type is returned. So without sparse supporting the latter
> > notation, we don't stand a chance.
>=20
> "<feff>"???

Hmm?

> > Also, I wouldn't know how to declare that an array or so needs
> > rcu-access to the members.
>=20
> Hmmm...  Can you apply the address-space attribute to the array itself?
> I suppose one could convert the array to a pointer, but yecch!

Not sure if applying that to an array would work, and I wouldn't want to
convert it to pointers either. But I suppose you could declare the array
like this:

static struct foo * __attribute__((bitwise or address_space)) array[7];

which should, as far as I understand, apply the attribute to the array
members instead of the array.

johannes

--=-oHNW+EEBViP18jY3fdR7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR//P6qVg1VMiehFYAQKomg/+LN9vLLI/V7DInn7pjY0liLFMEyvRuezR
dK16VBvG8r0iGVWWl7+UM92EcXWJ5HCOJVXzEUTCj0S1+wMCV8l5b7qMss5FguMX
qPXhVl/PvkD8WHZpRn+OSBsSmuIZ85bFnXr8cPeM8bwMJCp/94Ysk45Rg5dpuL7a
iWM4nh4kUdRBb2LUEorSw/ZuuCPUdvTw/XQHNikymQcN6Kw1fK9UxcTQRnwLV58b
LzmeRfcP+jLJ7kbuJcC7j99IFoT3WVKd6sYTJk5usOafLKK+Iylm8fqlIF17XyYK
OeKjAGgrFj5hr6fWTszcSFfPwX09pWY8GZr76ML0z6QUsF4Ne1nMimfd2GXaayR6
0muoyENiikxnHZ6MWuKEI9kyDPoI6/TGe65vtP3GzIPxeJsitFz1KUl4Xza498VU
0qxCbG5Z+d2YuO8u1LUe2HNCzzcMwFTbNOyh3aacKxJhRkdirLStbPmkPMtXd0Tp
gCF4r+ekHSKnUCWxQL/A12nPOO6mnUHiK4kNaCPmJTh857JabcqdMncsad9cclY1
eStrXSVUiAmKwOQ4TCITBb4ZnCMYJN8Y5RgDKt9Wo2vHkDFeT6oMWA7UZuvrzPaY
PyIM6H32otF3HEncC1EoFDiDcv5fEyI16p9hazydnrwUPaCpsAzR+j5+pfr8Sk6i
x1j+sGnX5Y4=
=RMWK
-----END PGP SIGNATURE-----

--=-oHNW+EEBViP18jY3fdR7--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbXDGXmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbXDGXmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 19:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXDGXmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 19:42:10 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:52348 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbXDGXmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 19:42:09 -0400
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704080113.24171.rjw@sisk.pl>
References: <200704072320.40238.rjw@sisk.pl>
	 <20070407150612.f99aae4a.akpm@linux-foundation.org>
	 <1175985065.10725.20.camel@nigel.suspend2.net>
	 <200704080113.24171.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HocrS9X0IUA2mK9oXeO9"
Date: Sun, 08 Apr 2007 09:42:08 +1000
Message-Id: <1175989328.10725.59.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HocrS9X0IUA2mK9oXeO9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sun, 2007-04-08 at 01:13 +0200, Rafael J. Wysocki wrote:
> On Sunday, 8 April 2007 00:31, Nigel Cunningham wrote:
> > Hi.
> >=20
> > On Sat, 2007-04-07 at 15:06 -0700, Andrew Morton wrote:
> > > On Sat, 7 Apr 2007 23:20:39 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> w=
rote:
> > >=20
> > > > This should allow us to reduce the memory usage, practically always=
, and
> > > > improve performance.
> > >=20
> > > And does it?
>=20
> Yes.  There are theoretical corner cases in which it may be less efficien=
t
> than the current approach, but in the usual situation it is _much_ better=
.
>=20
> > It will. I've been using extents for ages, for the same reasons. I don'=
t
> > put them in an rb_tree because I view it as less than most efficient,
>=20
> Actually, I don't agree with that.  In the normal situation (ie. one exte=
nt is
> needed) there is no difference as far as the memory usage or performance
> are concerned, but if there are more extents, the rbtree should be more
> efficient.

I don't think it's worth having a big discussion over, but let me give
you the details, which you can then feel free to ignore :)

The rb_node struct adds an unsigned long and two struct rb_node *
pointers. My extents use one struct extent * pointer. The difference is
thus 12/24 bytes per extent (32/64 bits) vs 20/40. In the normal
situation, not worth worrying about, but I'm also using these for
recording the sectors we write too, and thinking about swap files and
multiple swap devices. Nearly double the memory use bites more as you
get more extents.

Insertion cost for rb_node includes keeping the tree balanced. For
extents, I start with the location of the last insertion to minimise the
cost, so insertion time is usually virtually zero (inc max of last
extent or append a new one). If for some reason swap was allocated out
of order, I might need to traverse the whole chain from the start.

Normal usage in both cases is simply iterating through the list, so I
guess the cost would be approximately the same.

Deletion could would include rebalancing for the rb_nodes.

Code cost is a gain for you - you're leveraging existing code, I'm
adding a bit more. extent.c is 300 lines including code for serialising
the chains in an image header and iterating through a group of chains
(multiple swap devices support).

rb_nodes seem to be the wrong solution to me because we generally don't
care about searching. We care about minimising memory usage and
maximising the speed of iteration, insertion and deletion. I believe
I've managed to do that with a singly linked, sorted list.

That said, we've agreed that we're normally talking about a small number
of extents, so it's probably not worth the bandwidth I've already
spent :)

Regards,

Nigel

--=-HocrS9X0IUA2mK9oXeO9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGGCxQN0y+n1M3mo0RAhTUAKCCpAbylBleOye5UfMrNCYVuLVeYACeIita
QibSRtXV5z5BPS8x03oxJgE=
=yY0g
-----END PGP SIGNATURE-----

--=-HocrS9X0IUA2mK9oXeO9--


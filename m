Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXD0X5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXD0X5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbXD0X5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:57:31 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:49977 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbXD0X53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:57:29 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704280145.26253.rjw@sisk.pl>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <200704280041.17617.rjw@sisk.pl>
	 <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
	 <200704280145.26253.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-43uaF2Yy/N44f/lxvhmd"
Date: Sat, 28 Apr 2007 09:57:29 +1000
Message-Id: <1177718250.4737.222.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-43uaF2Yy/N44f/lxvhmd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sat, 2007-04-28 at 01:45 +0200, Rafael J. Wysocki wrote:
> On Saturday, 28 April 2007 01:17, Linus Torvalds wrote:
> >=20
> > On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> > >
> > > > And can you name a _single_ advantage of doing so?
> > >=20
> > > Yes.  We have a lot less interdependencies to worry about during the =
whole
> > > operation.
> >=20
> > That's not an advantage. That's why it has *sucked*.
>=20
> Actually, the less things happen while we're creating and saving the imag=
e,
> the less sources of potential problems there are and by freezing the kern=
el
> threads (not all of them), we cause less things to happen at that time.
>=20
> To make you happy, we could stop doing that, but what actual _advantage_
> that would bring?

A couple of other advantages to freezing other processes:

1) It makes predicting how much memory is available for making and
saving snapshot a tractable problem. It therefore makes hibernation
_much_ more reliable.
2) Racing against other processes would also make hibernation slower,
increasing the chances of your battery running out before the save is
complete.
3) It makes finding potential memory leaks in the code possible. It was
ages ago now, but at one stage I could display a table saying exactly
how many pages had been allocated and freed by different sections of the
process and compare the number of free pages at the start and end of the
cycle to ensure there were no memory leaks at all.

> > Trying to freeze kernel threads has _caused_ problems. It has _added_=20
> > these interdependencies. It hasn't removed a single dependency at any=20
> > time, it has just added new problems!
>=20
> What problems are you talking about?
>=20
> > > 1) if the kernel threads are frozen, we know that they don't hold any=
 locks
> > > that could interfere with the freezing of device drivers,
> > > 2) if they are frozen, we know, for example, that they won't call use=
r mode
> > > helpers or do similar things,
> > > 3) if they are frozen, we know that they won't submit I/O to disks an=
d
> > > potentially damage filesystems (suspend2 has much more problems with =
that
> > > than swsusp, but still.  And yes, there have been bug reports related=
 to it,
> > > so it's not just my fantasy).
> >=20
> > NONE of these are valid explanations at all. You're listing totally=20
> > theoretical problems, and ignoring all the _real_ problems that trying =
to=20
> > freeze kernel threads has _caused_.
>=20
> Example, please?

I agree with Rafael. Freezing processes greatly helps in ensuring we
have a consistent image. He's right, too, in asserting that it's even
more important for Suspend2. Freezing processes is essential to being
able to know that those LRU pages won't change and therefore being able
to save them separately and then reuse them for the atomic copy.

> > If you want to control user-mode helpers, you do that - you do not free=
ze=20
> > kernel threads!
> >=20
> > And no, kernel threads do not submit IO to disks on their own. You just=
=20
> > made that up.
>=20
> No, I didn't.  Nigel can confirm, I think.

I have had problems with MD threads generating I/O that I couldn't
account for - after userspace had been frozen, filesystems had been
nicely synced and so on. I have to speak with reservations though,
because I haven't yet gotten to the bottom of where the I/O is coming
from... too many things, too small time slices.

> > Yes, they can be involved in that whole disk submission thing, but in a=
 good
> > way - they can be required in order to make disk writing work!
>=20
> Some of them can be, some other's need not be.  We don't need any fs-rela=
ted
> kernel threads for saving the image, for example.

Yeah, so long as we bmap the storage we want to use beforehand (thinking
of swap files and ordinary files).

> > The problem that suspend has had is that it's done everything totally t=
he=20
> > wrong way around. Do kernel threads do disk IO? Sure, if asked to do so=
.=20
>=20
> They can be asked before we do the snapshot and complete the operation
> afterwards, no?
>=20
> > For example, kernel threads can be involved in md etc, but that's a *go=
od*=20
> > thing.
>=20
> We don't freeze these threads.
>=20
> > The way to shut them up is not to freeze the threads, but to freeze the=
 *disk*.
>=20
> In principle, you're right.  In practice, go and try it.

I have to disagree here. Freezing the disk instead of the threads is
dealing with the symptoms instead of the cause.

Regards,

Nigel

--=-43uaF2Yy/N44f/lxvhmd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMo3pN0y+n1M3mo0RAtewAKDup7uUhanE8625nrifxQ1VlFrGhACfUuLc
QWnW3pWXxsuIHAlI8YCEqJA=
=2LEw
-----END PGP SIGNATURE-----

--=-43uaF2Yy/N44f/lxvhmd--


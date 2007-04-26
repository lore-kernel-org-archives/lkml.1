Return-Path: <linux-kernel-owner+w=401wt.eu-S1031470AbXDZT4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031470AbXDZT4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031475AbXDZT4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:56:30 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:45947 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031467AbXDZT4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:56:21 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tXq93wTBUXfSFoj3BXlo"
Date: Fri, 27 Apr 2007 05:56:18 +1000
Message-Id: <1177617379.4737.29.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tXq93wTBUXfSFoj3BXlo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 09:56 -0700, Linus Torvalds wrote:
>=20
> On Thu, 26 Apr 2007, Nigel Cunningham wrote:
> >=20
> > * Doing things in the right order? (Prepare the image, then do the
> > atomic copy, then save).
>=20
> I'd actually like to discuss this a bit..
>=20
> I'm obviously not a huge fan of the whole user/kernel level split and=20
> interfaces, but I actually do think that there is *one* split that makes=20
> sense:
>=20
>  - generate the (whole) snapshot image entirely inside the kernel
>=20
>  - do nothing else (ie no IO at all), and just export it as a single imag=
e=20
>    to user space (literally just mapping the pages into user space).=20
>    *one* interface. None of the "pretty UI update" crap. Just a single=20
>    system call:
>=20
> 	void *snapshot_system(u32 *size);
>=20
>    which will map in the snapshot, return the mapped address and the size=
=20
>    (and if you want to support snapshots > 4GB, be my guest, but I suspec=
t=20
>    you're actually *better* off just admitting that if you cannot shrink=20
>    the snapshot to less than 32 bits, it's not worth doing)

That inherently limits the image to half of available ram (you need
somewhere to store the snapshot), so you won't get the full image you
express interest in below.

> User space gets a fully running system, with that one process having that=
=20
> one image mapped into its address space. It can then compress/write/do=20
> whatever to that snapshot.

You're describing uswsusp! (At least in so far as I understand it!).

You can't get a fully running system though, because if anything changes
something on disk that was snapshotted (super blocks etc) your snapshot
is invalid and you risk on-disk corruption.

> And btw, the device model changes are a big part of this. Because I don't=
=20
> think it's even remotely debuggable with the full suspend/resume of the=20
> devices being part of generating the image! That freeze/snapshot/unfreeze=
=20
> sequence is likely a lot more debuggable, if only because freeze/unfreeze=
=20
> is actually a no-op for most devices, and snapshotting is trivial too.
>=20
> Once you have that snapshot image in user space you can do anything you=20
> want. And again: you'd hav a fully working system: not any degradation=20
> *at*all*. If you're in X, then X will continue running etc even after the=
=20
> snapshotting, although obviously the snapshotting will have tried to page=
=20
> a lot of stuff out in order to make the snapshot smaller, so you'll likel=
y=20
> be crawling.

Nooooooo! See above about disk corruption.

> > * Mulithreaded I/O (might as well use multiple cores to compress the
> > image, now that we're hotplugging later).
> > * Support for > 1 swap device.
> > * Support for ordinary files.
> > * Full image option.
> > * Modular design?
>=20
> I'd really suggest _just_ the "full image". Nothing else is probably ever=
=20
> worth supporting. Your "snapshot to disk" wouldn't be _quite_ as simple a=
s=20
> "echo disk > /sys/power/state", but it should not necessarily be much=20
> worse than

Please, go apply that logic elsewhere, then cut out (or at least stop
adding) support for users with less common needs in other areas. I fully
acknowledge that most users have only one place to store their image and
it's a swap device. But that doesn't mean one size fits all.

A full image implies that you need to figure out what's not going to
change while you're writing it and save that separately. At the moment,
I'm treating most of the LRU contents as that list. If we're going to
start trying to let every man and his dog run while we're trying to
snapshot the system, that's not going to work anymore - or the logic
will get a lot more complicated.

Sorry. I never thought I'd say this, but I think you're being naive
about how simple the process of snapshotting a system is.

Regards,

Nigel

--=-tXq93wTBUXfSFoj3BXlo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMQPiN0y+n1M3mo0RAuj4AKC0JGvq9bstVwABa/rXEDmf6wssfwCfZL19
0QxTwRP6tlKEsbSfpB9tScM=
=K7MX
-----END PGP SIGNATURE-----

--=-tXq93wTBUXfSFoj3BXlo--


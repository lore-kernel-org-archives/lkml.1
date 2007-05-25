Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbXEYBzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbXEYBzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 21:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbXEYBza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 21:55:30 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:35924 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbXEYBz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 21:55:29 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost>
	 <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
	 <20070524200435.GA9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
	 <20070524220017.GC9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
	 <20070524221743.GD9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
	 <20070524231852.GG9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cvpjae8XYf/vdoIy05OZ"
Date: Fri, 25 May 2007 11:55:22 +1000
Message-Id: <1180058123.3997.91.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cvpjae8XYf/vdoIy05OZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Linus.

On Thu, 2007-05-24 at 17:37 -0700, Linus Torvalds wrote:
>=20
> On Fri, 25 May 2007, Pavel Machek wrote:
> >=20
> > 2) we need to preload firmware during _suspend_. I AM TELLING THAT TO
> > PEOPLE FOR FIVE YEARS NOW.
>=20
> And people aren't listening. Have you thought about _why_?
>=20
> The thing is, it should just work. Even without pre-loading.
>=20
> > Imageine we killed freezer. Also imagine Romano has IDE card his
> > PCMCIA slot. Kaboom, we solved nothing.
>=20
> Don't be silly. We solved it. The firmware has to be loadable from=20
> somewhere else, since otherwise his IDE card wouldn't have been accessibl=
e=20
> in the first place!=20
>=20
> So all your arguments are just bogus crap.

Let me see if I can help. I'll probably fail miserably, but I can only
try :)

First, let me agree with you that for the atomic copy itself, the
freezer is unnecessary. Disabling irqs and so on is enough to ensure the
atomic copy is atomic. I don't think any of us are arguing with you
there.

Where we see the problem is with what happens after the atomic copy is
made. The problem is that the atomic copy includes struct inodes, dnodes
and such like - an in memory representation of the state of mounted
filesystems. Imagine that, post atomic copy, we don't have the freezer.
Processes can then make on-disk changes to these mounted filesystems in
the time before we complete saving the image and powering down. If, at
resume time, we then restore the atomic copy, we have a mismatch between
what the in-memory data structures say and what the on-disk data says.
This leads to corruption.

How to avoid?

Well, there are only two options as far as I can see. We either stop
those changes occurring in the first place, or we make them undoable.

Freezing processes, and/or filesystems would be the first path,
checkpointing the second.

So, as far as I can see, we're stuck with freezing processes at least
until checkpointing is implemented.

I have to admit though, that even if checkpointing was implemented, I'd
like to see freezing processes remain. The image gets written faster if
we don't have to compete for cpu and i/o. It also allows us to do a
fuller image of memory than is otherwise possible (Yes, I know some
people don't care for full images, but others of us have usage patterns
that make the system far more useable if a full image is kept, or simply
prefer to have our machines as if the power had never gone away).
Without processes freezing, I'd have to work a lot harder to find a way
to do that full image. The simplest way would probably be to carry the
freezer code myself. (Yeah, I'm reconciled to the idea of never getting
Suspend2 merged. I'd like it to happen, but won't hold my breath.
Someone needs to break your suspend-to-ram or battery so you see the use
for hibernation :>).

Hope this helps.

Nigel

--=-cvpjae8XYf/vdoIy05OZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVkIKN0y+n1M3mo0RAnNjAKDA5xore805Zo48ySvbC+3XzFdKagCdH3N7
XEiXaLPlwz4+9FX2yKCec28=
=Eb6Q
-----END PGP SIGNATURE-----

--=-cvpjae8XYf/vdoIy05OZ--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbXDZUQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbXDZUQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXDZUQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:16:55 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:51254 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbXDZUQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:16:54 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Pavel Machek <pavel@ucw.cz>,
       Dumitru Ciobarcianu <Dumitru.Ciobarcianu@ines.ro>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>,
       "suspend2-devel@lists.suspend2.net" 
	<suspend2-devel@lists.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <200704262128.31547.rjw@sisk.pl>
References: <qlG9V8pP.1177603830.8836760.penberg@cs.helsinki.fi>
	 <200704262128.31547.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2FmBgk4utDHsV2maOAup"
Date: Fri, 27 Apr 2007 06:16:52 +1000
Message-Id: <1177618612.4737.50.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2FmBgk4utDHsV2maOAup
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 21:28 +0200, Rafael J. Wysocki wrote:
> On Thursday, 26 April 2007 18:10, Pekka Enberg wrote:
> >=20
> > On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > In principle, we could add suspend2 as an alternative (in analogy wit=
h the I/O
> > > schedulers, for example), but I think for this purpose it should be r=
eviewed
> > > properly.
> >=20
> > Yeah, this makes sense.
> >=20
> > On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > There also is a real problem with how it uses the LRU pages.  It _see=
ms_ to
> > > work, but at least to me it seems to be potentially dangerous.
> >=20
> > I am new to suspend2 so can you please explain what exactly is dangerou=
s
> > about it?
>=20
> After freezing tasks, it first saves the contents of the LRU pages, freez=
es
> devices and then uses the LRU pages for storing the suspend image (if mor=
e
> memory is needed, it's allocated, but that's irrelevant here).  Now, we h=
ave no
> warranty that the LRU pages are not updated after we've saved their conte=
nts
> (first potential problem here).
>=20
> After the image has been created, we have to unfreeze devices and save th=
e
> image.  Now, we have no warranty that no one will be writing to the LRU p=
ages
> that we have used to store the image, for whatever reasons known to him, =
so the
> image can potentially get corrupted while it's being saved.
>=20
> In principle, device drivers can do this and there are some kernel thread=
s that
> also can do this (we don't freeze them, because they're needed for the im=
age
> saving).
>=20
> The design is conceptually really really complicated and it makes strong
> assumptions about the behavior of different subsystems.  While these
> assumptions _may_ be satisfied right now, we'd have to ensure the satisfa=
ction
> of them in the future if suspend2 were merged.

That's a good description of the issue, although I think _may_ and
_seems_ are stating things a bit more pessimistically than is
necessary.=20

You see, we need to remember that the pages which are saved separately
are LRU pages. Because userspace is frozen, their contents are going to
be static. The only possibilities for modifying them come from timer
routines, improperly frozen filesystems and device drivers.

We have code to check that the LRU isn't changing, and I've only seen
one report of modifications to about 20 LRU pages. I haven't had the
time yet to chase down the cause, but hope to do so soon.

The general scheme has been working for four or five years - if there
was a fundamental issue, we would have found it by now.

The scheme isn't complicated. The algo for figuring out whether to save
the page in an atomic copy just says: Iterate through all LRU pages. For
each page, ask: Is this used by the thread suspending, or by userui? No?
Save separately. Yes? Save in the atomic copy.... oh, and save
everything else that needs to be saved in the atomic copy.

Regards,

Nigel

--=-2FmBgk4utDHsV2maOAup
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMQi0N0y+n1M3mo0RAsDEAJ9FoaWKSTZENDLd5noUQaydcJu3FgCgi7Bo
S4fFjf8FX4hI0EzAjUro3kU=
=ODkB
-----END PGP SIGNATURE-----

--=-2FmBgk4utDHsV2maOAup--


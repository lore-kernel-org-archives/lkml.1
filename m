Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbXD0KVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbXD0KVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXD0KVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:21:19 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:40421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbXD0KVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:21:17 -0400
Subject: driver power operations (was Re: suspend2 merge)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20070425203150.GD17387@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
	 <20070425200836.GB17387@elf.ucw.cz> <200704252233.25296.rjw@sisk.pl>
	 <20070425203150.GD17387@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k2Frzeg9EeCi0PVHImmO"
Date: Fri, 27 Apr 2007 12:21:19 +0200
Message-Id: <1177669279.7828.55.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k2Frzeg9EeCi0PVHImmO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-04-25 at 22:31 +0200, Pavel Machek wrote:

> > So, the "suspend" and "resume" for the functions being called for that =
are
> > wrong, but then we call them with PMSG_FREEZE. ;-)  Still, we could add
> > .freeze() and .thaw() callbacks for hibernation just fine.  This wouldn=
't even
> > be that difficult ...
>=20
> It would be ugly big patch I'm afraid.

It'd be a lot of code churn, but well worth it. And most of the changes
would be trivial too. You need to start looking beyond "this is ugly in
the short term" and realise that it's much more maintainable in the long
term if driver writers know what they're supposed to do as opposed to
just hacking at it until it mostly works or just doing a full device
down/up cycle including resetting full driver state.

Look at it now:

 * FREEZE       Quiesce operations so that a consistent image can be saved;
 *              but do NOT otherwise enter a low power device state, and do
 *              NOT emit system wakeup events.
 *
 * PRETHAW      Quiesce as if for FREEZE; additionally, prepare for restori=
ng
 *              the system from a snapshot taken after an earlier FREEZE.
 *              Some drivers will need to reset their hardware state instea=
d
 *              of preserving it, to ensure that it's never mistaken for th=
e
 *              state which that earlier snapshot had set up.

Why is prethaw even necessary? As far as I can tell it's only necessary
because resume() can't tell you whether you just want to thaw or need to
reset since it doesn't tell you at what point it's invoked.

Having ->freeze(), ->thaw() and ->restart() (can somebody come up with a
better name?) that are called at the appropriate places (with
freeze/thaw around preparing the image and freeze/restart around
restoring would go a long way of clearing up the confusion in all the
drivers. Of course, it'd have to be documented that freeze/thaw isn't
the only valid combination but that freeze/restart is used too, but
that's not hard to do nor hard to understand.

And, incidentally, it could possibly make both suspend and hibernate
work much faster too. The comments there talk about "minimally power
management aware" drivers which always do the wrong thing for suspend,
in that they always reset everything... Of course, some drivers will
actually need to do that, but if freeze/suspend and thaw/restart/resume
have the same prototypes (probably just int <function>(void)) then
drivers can trivially assign the same there.
And hibernate would benefit since a lot of drivers could do a lot less
work for freeze/thaw.

Or, if we don't want to have five calls and use 40 bytes (on 64-bit)
just for these callback pointers for each device we could just as well
have a single callback ->pm(what) and make "what" indicate which one of
these five things... But then drivers can't make that code depend on the
swsusp configuration which would be doable with five callbacks.

johannes

--=-k2Frzeg9EeCi0PVHImmO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMc6e/ETPhpq3jKURAgZOAKC7VOqf4D8MuNBZzYKVJW5x7i7v4ACff6rU
B7oitsi43NOwkfE+KPeUxDc=
=/5+K
-----END PGP SIGNATURE-----

--=-k2Frzeg9EeCi0PVHImmO--


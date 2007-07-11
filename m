Return-Path: <linux-kernel-owner+w=401wt.eu-S934975AbXGKXcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975AbXGKXcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933305AbXGKXbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:31:46 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:48422 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934935AbXGKXbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:31:45 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation Redesign
Date: Thu, 12 Jul 2007 09:31:43 +1000
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mark Lord <lkml@rtr.ca>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, jeremy@goop.org, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707120034.14201.rjw@sisk.pl> <200707120212.24072.a1426z@gawab.com>
In-Reply-To: <200707120212.24072.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15381560.8zxUnzoBmH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707120931.44456.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart15381560.8zxUnzoBmH
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 12 July 2007 09:12:24 Al Boldi wrote:
> Rafael J. Wysocki wrote:
> > On Thursday, 12 July 2007 00:17, Al Boldi wrote:
> > > Mark Lord wrote:
> > > > Jeremy Maitin-Shepard wrote:
> > > > > I'll certainly admit the kexec idea is vaporware currently,
> > >
> > > Your idea is starting to become a reality with this thread:
> > > "[PATCH 0/2] Kexec jump: The first step to kexec base hibernation"
> > >
> > > > > but it does
> > > > > differ in a significant way from freezer-based approaches, such t=
hat
> > > > > I don't think it should be referred to as just another
> > > > > implementation of a freezer.  Specifically, it doesn't require th=
at
> > > > > the "old kernel" be in a "consistent" state to a greater extent t=
han
> > > > > suspend to ram; it is the case that all of the devices must be
> > > > > quiesced or shut down to some extent, but doing this without races
> > > > > and deadlocks (and without the freezer) is certainly very, very
> > > > > similar to what needs to be done for suspend to ram, which will n=
eed
> > > > > to be solved anyway.  Unlike the existing hibernate approaches,
> > > > > however, it will not be necessary to use any of the driver
> > > > > infrastructure once switched to the "save image" kernel, and thus=
 it
> > > > > will not matter what locks are held, for instance.
> > > >
> > > > I really doubt that kexec(a special kernel) is going to solve anyth=
ing
> > > > here. The new kernel will have to initialize, probe for devices, et=
c.
> > > > Which will take time.
> > > > Which will slow down hibernate to an unacceptable degree.
> > > > Right now, it (TuxOnIce) is *very* fast.
> > > > Adding 10 seconds or so for reprobing/resetting/reiniting devices
> > > > is not going to be useful.
> > > > And modifying all of the drivers to *not* do their usual probe
> > > > sequence sounds rather intrusive and is likely also a non-starter
> > > > here.
> > > >
> > > > Or is it?
> > >
> > > Well, it's definitely less intrusive than readying drivers for the
> > > freezer.
> >
> > There's nothing like this!
>=20
> Are you sure?
>=20
> # grep -i freeze drivers/*/* | wc -l
>=20
> gives:  297
>=20
> Maybe you can clarify?

Rafael's probably just gone to sleep, so let me be so bold as to give an=20
answer.

=46irst, you need to understand that there is a difference between the proc=
ess=20
freezer and driver support for suspending and resuming. The two are=20
completely unrelated. Process freezing happens at the start of a hibernatio=
n=20
cycle. Driver suspend and resume calls happen prior to and after an atomic=
=20
copy or restore. Process freezing stops processes. Driver suspend and resum=
e=20
calls tell drivers to save their state and possibly enter low power modes.=
=20
Process freezing isn't a necessary prerequisite for calling driver=20
suspend/resume routines. (That has been the point to discussions about=20
suspend to ram).

Since this is the case, doing grep -i freeze drivers/*/* is a bogus test. I=
f=20
you want to look for drivers using the freezer, you need to grep for=20
try_to_freeze and PF_NOFREEZE. PF_NOFREEZE says the related kernel thread=20
shouldn't be frozen (11 hits in the source tree I'm looking at). Grepping f=
or=20
try_to_freeze gets 29. By the way, find drivers/ -name '*.[ch]' | xargs gre=
p=20
try_to_freeze (for example) is a better search - it isn't dependant upon th=
e=20
number of subdirectories.

You'll see from the above numbers that the freezer is not nearly as intrusi=
ve=20
as you were thinking (~10% of what you wrote above). It is limited to code=
=20
related to kernel threads, and then to either setting a flag when the threa=
d=20
is started to say "I don't need to be frozen" or to the appropriate point a=
t=20
which to check whether to freeze.

Hope that helps.

Nigel
=2D-=20
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.

--nextPart15381560.8zxUnzoBmH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlWhgN0y+n1M3mo0RAsLXAKC4YQ/p0zUdVhDL+Ihc7FfoW9UDQACgq2G0
oELvxfNKr4xWeD81SQi37zs=
=XWgQ
-----END PGP SIGNATURE-----

--nextPart15381560.8zxUnzoBmH--

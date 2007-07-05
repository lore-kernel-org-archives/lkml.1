Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbXGENgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbXGENgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbXGENgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:36:49 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:50846 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXGENgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:36:48 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 23:36:26 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707052238.27889.nigel@nigel.suspend2.net> <200707051535.46196.rjw@sisk.pl>
In-Reply-To: <200707051535.46196.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2644466.OEt0fIUkEO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707052336.27585.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2644466.OEt0fIUkEO
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 23:35:45 Rafael J. Wysocki wrote:
> On Thursday, 5 July 2007 14:38, Nigel Cunningham wrote:
> > On Thursday 05 July 2007 22:25:06 Rafael J. Wysocki wrote:
> > > On Thursday, 5 July 2007 01:45, Pavel Machek wrote:
> > > > On Tue 2007-07-03 21:32:20, Oliver Neukum wrote:
> > > > > Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > > > > > > And a further question. The freezer is not atomic. What do yo=
u=20
do
> > > > > > > if a task not yet frozen calls sys_sync(), but fuse is alread=
y=20
> > frozen?
> > > > > >=20
> > > > > > What do you do if a task not yet frozen writes to a pipe, on th=
e=20
other
> > > > > > end of which is a task already frozen?
> > > >=20
> > > > There's some difference between uninterruptible and interruptible
> > > > sleep I'd say.
> > > >=20
> > > > > > It doesn't matter.  The only thing that should matter during=20
suspend
> > > > > > (not hibernate) is saving the state of devices to ram, and putt=
ing=20
the
> > > > > > devices to sleep.
> > > > >=20
> > > > > Well, but you did remove sys_sync() from the freezer, which is
> > > > > and must be called in the hibernate path.
> > > >=20
> > > > Not "must". In fact, hibernation should be safe without sys_sync().=
 It
> > > > is just user un-friendly.
> > >=20
> > > In fact, I'd like to remove the sys_sync() from the freezer entirely,=
=20
> > because
> > > it just doesn't belong in there.
> > >=20
> > > The only advantege of having sys_sync() in freeze_processes() is that=
 we
> > > have a chance to write out everything when applications cannot produc=
e=20
more
> > > data to write, but there are filesystems which don't do that anyway (=
eg.=20
> > XFS),
> > > so generally there's no reason to bother.
> >=20
> > Shouldn't XFS - and fuse - be considered to be broken? Sync should sync=
=20
data=20
> > and if XFS isn't doing that, it's wrong.
> >=20
> > In the case of fuse, we should have a mechanism by which fuse processes=
=20
can be=20
> > made to sync if they do have any pending I/O, and by which they can be=
=20
frozen=20
> > later than other userspace processes.
> >=20
> > I'd like to see the sync stay, because it improves reliability and data=
=20
> > integrity in the fail-to-resume case. Calling scripts would probably=20
invoke=20
> > sync themselves if they don't already, but that's racy. As it is at the=
=20
> > moment, we know userspace is stopped, so syncing isn't racy.
>=20
> I'd like to move the sync out of the freezer, but to call it from the
> suspend/hibernation code, so that we do
>=20
> sys_sync();
> error =3D freeze_processes();

Yeah, I understand that. The problem then is that you're racing against=20
userspace. That's not usually a problem, but that doesn't mean it's never a=
=20
problem. Try running the stress suite while testing hibernating and you'll=
=20
see what I mean. If something is submitting lots of I/O when you try to=20
suspend, your sync call will race against that process if it's not yet=20
frozen, and its continued activity will make your sync pointless (there'll =
be=20
more unsynced data when you sys_sync call finishes). Stopping userspace=20
before syncing removes that race.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart2644466.OEt0fIUkEO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjPPbN0y+n1M3mo0RApTTAJ0Yf9+q36OL3z5Dt8aRi7gtaVUqrQCfUyzd
i50Zeiy88gFIXoTYgVP1H0Y=
=ggoO
-----END PGP SIGNATURE-----

--nextPart2644466.OEt0fIUkEO--

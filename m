Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbXGEVtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbXGEVtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbXGEVtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:49:11 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57634 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449AbXGEVtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:49:09 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 07:49:07 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707052336.27585.nigel@nigel.suspend2.net> <200707051559.58479.rjw@sisk.pl>
In-Reply-To: <200707051559.58479.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12080694.Mj0X6XMVVE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707060749.08665.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12080694.Mj0X6XMVVE
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Good morning!

On Thursday 05 July 2007 23:59:57 Rafael J. Wysocki wrote:
> On Thursday, 5 July 2007 15:36, Nigel Cunningham wrote:
> > On Thursday 05 July 2007 23:35:45 Rafael J. Wysocki wrote:
> > > On Thursday, 5 July 2007 14:38, Nigel Cunningham wrote:
> > > > On Thursday 05 July 2007 22:25:06 Rafael J. Wysocki wrote:
> > > > > On Thursday, 5 July 2007 01:45, Pavel Machek wrote:
> > > > > > On Tue 2007-07-03 21:32:20, Oliver Neukum wrote:
> > > > > > > Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > > > > > > > > And a further question. The freezer is not atomic. What d=
o=20
you=20
> > do
> > > > > > > > > if a task not yet frozen calls sys_sync(), but fuse is=20
already=20
> > > > frozen?
> > > > > > > >=20
> > > > > > > > What do you do if a task not yet frozen writes to a pipe, o=
n=20
the=20
> > other
> > > > > > > > end of which is a task already frozen?
> > > > > >=20
> > > > > > There's some difference between uninterruptible and interruptib=
le
> > > > > > sleep I'd say.
> > > > > >=20
> > > > > > > > It doesn't matter.  The only thing that should matter durin=
g=20
> > suspend
> > > > > > > > (not hibernate) is saving the state of devices to ram, and=
=20
putting=20
> > the
> > > > > > > > devices to sleep.
> > > > > > >=20
> > > > > > > Well, but you did remove sys_sync() from the freezer, which is
> > > > > > > and must be called in the hibernate path.
> > > > > >=20
> > > > > > Not "must". In fact, hibernation should be safe without=20
sys_sync(). It
> > > > > > is just user un-friendly.
> > > > >=20
> > > > > In fact, I'd like to remove the sys_sync() from the freezer=20
entirely,=20
> > > > because
> > > > > it just doesn't belong in there.
> > > > >=20
> > > > > The only advantege of having sys_sync() in freeze_processes() is=
=20
that we
> > > > > have a chance to write out everything when applications cannot=20
produce=20
> > more
> > > > > data to write, but there are filesystems which don't do that anyw=
ay=20
(eg.=20
> > > > XFS),
> > > > > so generally there's no reason to bother.
> > > >=20
> > > > Shouldn't XFS - and fuse - be considered to be broken? Sync should=
=20
sync=20
> > data=20
> > > > and if XFS isn't doing that, it's wrong.
> > > >=20
> > > > In the case of fuse, we should have a mechanism by which fuse=20
processes=20
> > can be=20
> > > > made to sync if they do have any pending I/O, and by which they can=
 be=20
> > frozen=20
> > > > later than other userspace processes.
> > > >=20
> > > > I'd like to see the sync stay, because it improves reliability and=
=20
data=20
> > > > integrity in the fail-to-resume case. Calling scripts would probabl=
y=20
> > invoke=20
> > > > sync themselves if they don't already, but that's racy. As it is at=
=20
the=20
> > > > moment, we know userspace is stopped, so syncing isn't racy.
> > >=20
> > > I'd like to move the sync out of the freezer, but to call it from the
> > > suspend/hibernation code, so that we do
> > >=20
> > > sys_sync();
> > > error =3D freeze_processes();
> >=20
> > Yeah, I understand that. The problem then is that you're racing against=
=20
> > userspace. That's not usually a problem, but that doesn't mean it's nev=
er=20
a=20
> > problem. Try running the stress suite while testing hibernating and you=
'll=20
> > see what I mean. If something is submitting lots of I/O when you try to=
=20
> > suspend, your sync call will race against that process if it's not yet=
=20
> > frozen, and its continued activity will make your sync pointless (there=
'll=20
be=20
> > more unsynced data when you sys_sync call finishes). Stopping userspace=
=20
> > before syncing removes that race.
>=20
> Yes, that will make the suspend/hibernation less reliable in case the res=
ume
> fails (some data, written after the sync, may be lost).  However, the syn=
c=20
done
> from within the freezer doesn't guarantee that there are no data lost=20
anyway,
> so we don't lose much by not doing it.
>=20
> Now, there's a question how much data may be lost, potentially, if we do =
the
> sync before the freezer and I don't think that's a lot.

You're missing the point. I'm arguing that a sync from within the freezer=20
should guarantee that there is no data loss. As I said about, XFS should be=
=20
fixed to properly sync its data, and something should be done about fuse=20
filesystems too.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart12080694.Mj0X6XMVVE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjWdUN0y+n1M3mo0RAqKoAJwIGlvxoEHXVsr0JlWPRr1sdP9CpwCg7urc
9Or85XaM+uOSPOMTeeInJWM=
=wYl2
-----END PGP SIGNATURE-----

--nextPart12080694.Mj0X6XMVVE--

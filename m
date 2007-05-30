Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXE3WZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXE3WZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761444AbXE3WZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:25:01 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:42971 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762104AbXE3WZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:25:00 -0400
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <200705302311.40123.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org>
	 <20070530153740.GA4772@ucw.cz> <200705302244.25927.rjw@sisk.pl>
	 <200705302311.40123.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-equ5SOhL06TWzdt4b6FS"
Date: Thu, 31 May 2007 08:24:57 +1000
Message-Id: <1180563897.6777.11.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-equ5SOhL06TWzdt4b6FS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-05-30 at 23:11 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 30 May 2007 22:44, Rafael J. Wysocki wrote:
> > Hi,
> >=20
> > On Wednesday, 30 May 2007 17:37, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > > +Suspend notifiers
> > > > +	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
> > > > +
> > > > +There are some operations that device drivers may want to carry ou=
t in their
> > > > +.suspend() routines, but shouldn't, because they can cause the hib=
ernation or
> > > > +suspend to fail. For example, a driver may want to allocate a subs=
tantial amount
> > > > +of memory (like 50 MB) in .suspend(), but that shouldn't be done a=
fter the
> > > > +swsusp's memory shrinker has run.
> > > > +
> > > > +Also, there may be some operations, that subsystems want to carry =
out before a
> > > > +hibernation/suspend or after a restore/resume, requiring the syste=
m to be fully
> > > > +functional, so the drivers' .suspend() and .resume() routines are =
not suitable
> > > > +for this purpose.  For example, device drivers may want to upload =
firmware to
> > > > +their devices after a restore from a hibernation image, but they c=
annot do it by
> > > > +calling request_firmware() from their .resume() routines (user lan=
d processes
> > > > +are frozen at this point).  The solution may be to load the firmwa=
re into
> > > > +memory before processes are frozen and upload it from there in the=
 .resume()
> > > > +routine.  Of course, a hibernation notifier may be used for this p=
urpose.
> > > > +
> > > > +The subsystems that have such needs can register suspend notifiers=
 that will be
> > > > +called upon the following events by the suspend core:
> > > > +
> > > > +PM_PRE_FREEZE		The system is going to hibernate or suspend, tasks =
will
> > > > +			be frozen immediately
> > >=20
> > > Hmm, looks like bad idea if we are going to remove freezer from
> > > suspend...?
> >=20
> > We need PM_PRE_FREEZE anyway and it's a different question whether or n=
ot
> > it'll be used for suspend (STR) too.
> >=20
> > The timing is not the best one, but so far the freezer is in the suspen=
d code
> > path and I need to take this into account.
> > =20
> > > > +PM_POST_THAW		Tasks have just been thawed after a resume or restor=
e
> > > > +			from a hibernation image
> > > > +
> > > > +PM_HIBERNATION_PREPARE	The system is preparing for hibernation.  T=
asks have
> > > > +			been frozen, memory is going to be freed and devices
> > > > +			are going to be suspended.
> > >=20
> > > Is not PRE_FREEZE enough? We can allocate memory for drivers there,
> > > too...
> >=20
> > Well, there is a reason for not doing this.  Namely, if the memory if f=
reed on
> > PM_POST_HIBERNATION after the image has been created, we can use it for=
 saving
> > the image (and speed up the saving).
> >=20
> > Besides, if the freezer is dropped from the suspend code, the notifiers=
 will be
> > useful to it anyway IMO, and PRE_FREEZE won't make sense in that case.
> >=20
> > I think the rule should be: If you need to do something _before_ tasks =
are
> > frozen, do it in PM_PRE_FREEZE, but if you can do that after the tasks =
have
> > been frozen, do it on PM_HIBERNATION_PREPARE (or PM_SUSPEND_PREPARE in =
the
> > suspend case).
>=20
> OTOH, having considered it for a while, I think that for now I can add ju=
st
> PM_PRE_FREEZE and PM_POST_THAW, as I don't have any user for the other on=
es.
> The other events may be added in the future if need be (along with some u=
sers).
>=20
> I'll post revised patches in a new thread.

I haven't been giving this much attention, so forgive me if I'm about to
ask a silly question... which notifiers would you see the avenrun
saving/restoring using?

Regards,

Nigel

--=-equ5SOhL06TWzdt4b6FS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXfm5N0y+n1M3mo0RAuX3AJ9c97QXZgMSe/ZWn3IbefzIkQs6wwCg5pON
gUN9ZDWlUpthczULibV8I4o=
=x1Cy
-----END PGP SIGNATURE-----

--=-equ5SOhL06TWzdt4b6FS--


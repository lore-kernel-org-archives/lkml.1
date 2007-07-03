Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXGCO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXGCO73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbXGCO7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:59:18 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:40663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbXGCO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:59:14 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.44L0.0707031026260.3720-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0707031026260.3720-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Chr4USvrqKg1IE/8MaUU"
Date: Tue, 03 Jul 2007 16:59:08 +0200
Message-Id: <1183474748.3722.33.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Chr4USvrqKg1IE/8MaUU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-03 at 10:50 -0400, Alan Stern wrote:

> Time for me to jump in.

:)

> USB already implements runtime PM.  If a device is suspended at runtime
> and a task tries to access it, the device is automatically resumed. =20
> No problem there.

Right.

> The problem comes when the system is doing a STR.  Right now the code
> doesn't keep track of the difference between a runtime suspend and a
> system suspend -- once the device is suspended, it's suspended, period. =20
> Consequently, a non-frozen user task trying to do I/O to a suspended
> device during STR will cause that device to resume, thereby forcing the
> system suspend to abort.  Something much like this has actually
> happened and been reported as a bug on LKML (I don't have a URL handy,
> and it was actually a non-frozen kernel thread interfering with
> hibernate rather than a non-frozen user task interfering with STR, but
> the principle is the same).

Yeah, I can see that happen.

> Yes, the code could be changed to keep track of the reason for a device
> suspend.  But that just raises the old problem of what to do when
> there's an I/O request for a suspended device during STR.
>=20
> > I think the core of the discussion isn't appreciated by everybody here
> > yet---we need to solve both run-time and suspend-to-ram-time device
> > suspend, not just one of them.
>=20
> Runtime suspend isn't a problem.  Only STR.

Ah but for all those character devices people were saying are the
problem we haven't even solved runtime suspend as far as I can tell from
the discussion.

> Consider a particularly troublesome case: During STR, a non-frozen task
> writes to /sys/bus/BBB/drivers/DDD/bind.  The sysfs core grabs the
> device semaphore and calls the driver's probe routine.  If the driver
> isn't PM-aware it simply tries to initialize the device and fails
> because the device is already suspended.  That's no good; it isn't
> transparent.
>=20
> So assume the driver is PM-aware.  It tries to resume the device, which
> fails because STR is underway.  Now what can it do?  There's only one=20
> possibility: It must block until the resume call can succeed.  But when=20
> is that?
>=20
> It has to be before the PM core tries to resume the device, because the=20
> core will try to acquire the device semaphore and will block waiting=20
> for the probe call to complete.  But it has to be after the PM core=20
> resumes the device's parent, because obviously the device can't resume=20
> until its parent is awake.
>=20
> As you can see, this is a very difficult problem to solve.

Indeed. Actually, one could argue that it's impossible to solve the
problem as long as we try to call out to userspace during suspend and
need to wait until that's finished, like in the case of sys_sync() and
fuse filesystems, and probably other cases. Maybe we should make *those*
calls return a failure so that the suspend isn't transparent inside the
kernel but is transparent to userspace.

johannes

--=-Chr4USvrqKg1IE/8MaUU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGimQ8/ETPhpq3jKURArFaAKCjlzAbJawvkuD7GEDNlFQMcEu8AgCZAQ00
TKYIh8DMquVMXZEqjSfUOUs=
=5hYc
-----END PGP SIGNATURE-----

--=-Chr4USvrqKg1IE/8MaUU--


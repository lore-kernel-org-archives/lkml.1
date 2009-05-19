Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZESQ2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZESQ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZESQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:28:42 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZESQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:28:41 -0400
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090519160936.GA25720@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <20090519160936.GA25720@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vMG/6bDi5Rwk8KiaIcW5"
Date: Tue, 19 May 2009 18:27:50 +0200
Message-Id: <1242750470.4797.42.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vMG/6bDi5Rwk8KiaIcW5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-19 at 18:09 +0200, Oleg Nesterov wrote:

> > Right. But exactly this happens in the hibernate case --
>=20
> not sure I understand your "exactly this" ;)
>=20
> But your explanation of the deadlock below looks great!

Yeah... I got side-tracked, I had a scenario in mind that actually
needed cpu_add_remove_lock().

> except I don't understand how cpu_add_remove_lock makes the difference...
> And thus I can't understand why cpu_down() (called lockless) have the
> same problems. Please see below.
>=20
> > Anyway, you can have a deadlock like this:
> >
> > CPU 3			CPU 2				CPU 1
> > 							suspend/hibernate
> > 			something:
> > 			rtnl_lock()			device_pm_lock()
> > 							-> mutex_lock(&dpm_list_mtx)
> >
> > 			mutex_lock(&dpm_list_mtx)
> >
> > linkwatch_work
> >  -> rtnl_lock()
> > 							disable_nonboot_cpus()
>=20
> let's suppose disable_nonboot_cpus() does not take cpu_add_remove_lock,
>=20
> > 							-> flush CPU 3 workqueue
>=20
> in this case the deadlock is still here?
>=20
> We can't flush because we hold the lock (dpm_list_mtx) which depends
> on another lock taken by work->func(), the "classical" bug with flush.
>=20
> No?

Yeah, it looks like cpu_add_remove_lock doesn't make a difference...
It's just lockdep reporting a longer chain that also leads to a
deadlock. OTOH just replace dpm_list_mtx with cpu_add_remove_lock and
you have the same scenario... happens too, I guess, somehow.

johannes

--=-vMG/6bDi5Rwk8KiaIcW5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEt4CAAoJEODzc/N7+Qmau+MQALhHXgzYweGx/C3acd/Y7b3Z
eh5jXD8trqZtzOvserRAYF+xKCvx3gZH7DoTZn75zF7LMyH2gtFd5MNGdGg6f+eO
5354jsWha6Fhl6KmWWmKLU1RyBsYSNB6sGyhi/8xm8tBuzGj7D/GcLgqsSRKK88B
R+FO3DMgBU13iRunyiuhOLHFxjwB6dtfqdML9zyHltJOGodLVRkXZunwwsuaQJKn
Ix4QFfjsEZnYt8JTPwiA+r4nB8LPsfO9OEQsO9Ir8Ledemv8qPiyj6WOkfn1I6v0
1hiSaYx/kOk/XT9Im8xGtz5uZ///FsgdC6+vqBHLiOBhsnEzmiE6XXM2epNzSde9
5i1eXUNAFjaaneLXBMV6j+IZo53EN4bI7ioVgvX9yU/j01Sx1ei/kv5VbI6Qh1Xw
wJQKCsc/Zp6KGbVer6sccOdH0mWqY+mOllqjGbf94eyrBedTi1UQO4l7R/CKQedp
RxZkOaVlGhGg3+PtNnqIHwUQirq5zuiegf6kbaDbX56EmVsX7hPdYk/bC0X+5uxj
XtVo+78po/NHUzrcSadQ373w9gJALgZ05f73vkh6GrBMLO30xoREKwk4c70dEiDs
Qw1fn+C7gdwl1d/0T1bLbA3w374ZKko1/FOIg45MjTIZea7aJGJmCU6zthZXGqDj
DnU92aaopZt0bpa9NxtG
=qSai
-----END PGP SIGNATURE-----

--=-vMG/6bDi5Rwk8KiaIcW5--


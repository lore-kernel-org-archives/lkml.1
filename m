Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZEVKqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZEVKqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZEVKqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:46:30 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZEVKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:46:29 -0400
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090519185140.GA32012@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <20090519160936.GA25720@redhat.com>
	 <1242750470.4797.42.camel@johannes.local>
	 <20090519185140.GA32012@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Dx2sJx0fqgpiPJMy9A6c"
Date: Fri, 22 May 2009 12:46:06 +0200
Message-Id: <1242989166.4606.5.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Dx2sJx0fqgpiPJMy9A6c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-19 at 20:51 +0200, Oleg Nesterov wrote:

> > > > Anyway, you can have a deadlock like this:
> > > >
> > > > CPU 3			CPU 2				CPU 1
> > > > 							suspend/hibernate
> > > > 			something:
> > > > 			rtnl_lock()			device_pm_lock()
> > > > 							-> mutex_lock(&dpm_list_mtx)
> > > >
> > > > 			mutex_lock(&dpm_list_mtx)
> > > >
> > > > linkwatch_work
> > > >  -> rtnl_lock()
> > > > 							disable_nonboot_cpus()
> > >
> > > let's suppose disable_nonboot_cpus() does not take cpu_add_remove_loc=
k,
> > >
> > > > 							-> flush CPU 3 workqueue
> > >
> > > in this case the deadlock is still here?
> > >
> > > We can't flush because we hold the lock (dpm_list_mtx) which depends
> > > on another lock taken by work->func(), the "classical" bug with flush=
.
> > >
> > > No?
> >
> > Yeah, it looks like cpu_add_remove_lock doesn't make a difference...
> > It's just lockdep reporting a longer chain that also leads to a
> > deadlock.
>=20
> So. we should not call cpu_down/disable_nonboot_cpus under device_pm_lock=
().
>=20
> At first glance this was changed by
>=20
> 	PM: Change hibernation code ordering
> 	4aecd6718939eb3c4145b248369b65f7483a8a02
>=20
> 	PM: Change suspend code ordering
> 	900af0d973856d6feb6fc088c2d0d3fde57707d3
>=20
> commits. Rafael, could you take a look?

I just arrived at the same conclusion, heh. I can't say I understand
these changes though, the part about calling the platform differently
may make sense, but calling why disable non-boot CPUs at a different
place?

johannes

--=-Dx2sJx0fqgpiPJMy9A6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFoJoAAoJEODzc/N7+QmauSgP+weqcGV8CJSe+EXez1iNUW/z
vDc/ASUlJcYTKZ1Q6aFzyOqjAOQaR/Q0/uK+cCf3m9FAIKqmksc6rESBiyohRRTt
pIublTms1Qu42x+murSM/4GTruMI2iq90VDQZhcHsC/TpGaeEn53PzXr6vOM4lK1
egz483Le/YLI7VvvKNNxATQEUWkK4FJNFQ9NHlYpdBa84H+UIUWxEQCHH4NegCmV
HidKWzvLIww4NACdyFSd8yJmDqCEpKK63ZEOOu7afEWj3DvhyYhB2X9DSB9CgwWh
DqNmuZpMWuUnSmN012bCv7+AI92s1ScqlREdTYIP/0mDxxjot+5pMib8jMSkkgEG
mpWI02VIZ8dC9FktVC2bFr7P9aEkJ1DhNsKSXXlvSBGnuL0Lz55smcNNJorHbQfL
ExEpNMJdv/w5L2oQbMASo/i8MjUzRCyWsAzhbBsu5A8VSt72WdHQoy/5vI5of14l
Gx08S0eVknh6Isp/NLVml2EXHabMO9rS1Q8JLTirV7s73ep0Sv+QGGRmhsSNoTH4
uQwut9eQtmcZ6R1WLEnL1rss+B67LTqhenpoOfjPb3zj97lWAR09lPV5wthipqb4
+eqxsuO4S4k92VXkcTrfyG2YnaLNYm5Ktzrzu5BHWO9jWLjHqUw5708p3fHxhOU9
qHMLFAyNmRmEDAFi0YKy
=WNxE
-----END PGP SIGNATURE-----

--=-Dx2sJx0fqgpiPJMy9A6c--


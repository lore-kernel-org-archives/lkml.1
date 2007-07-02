Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbXGBIhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbXGBIhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 04:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXGBIhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 04:37:33 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:40804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbXGBIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 04:37:31 -0400
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <20070630114658.GA344@tv-sign.ru>
References: <1182969638.4769.56.camel@johannes.berg>
	 <1183048429.4089.1.camel@johannes.berg>
	 <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4>
	 <20070630114658.GA344@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ft9hCOBo7S2XxS437mua"
Date: Mon, 02 Jul 2007 10:37:58 +0200
Message-Id: <1183365478.4089.90.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ft9hCOBo7S2XxS437mua
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-30 at 15:46 +0400, Oleg Nesterov wrote:
> On 06/30, Ingo Molnar wrote:
> >
> > On Thu, 2007-06-28 at 19:33 +0200, Johannes Berg wrote:
> > > No, that's not right either, but Arjan just helped me a bit with how
> > > lockdep works and I think I have the right idea now. Ignore this for
> > > now, I'll send a new patch in a few days.
> >=20
> > ok. But in general, this is a very nice idea!
> >=20
> > i've Cc:-ed Oleg. Oleg, what do you think? I think we should keep all
> > the workqueue APIs specified in a form that makes them lockdep coverabl=
e
> > like Johannes did. This debug mechanism could have helped with the
> > recent DVB lockup that Thomas Sattler reported.
>=20
> I think this idea is great!

:)

> Johannes, could you change wait_on_work() as well? Most users of
> flush_workqueue() should be converted to use it.

Sure. The case I had used flush_workqueue() but I'll look into
wait_on_work() and maybe converting the place where I had this.

> > @@ -342,6 +351,9 @@ static int flush_cpu_workqueue(struct cp
> >         } else {
> >                 struct wq_barrier barr;
> >
> > +               lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_I=
P_);
> > +               lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
> > +
> >                 active =3D 0;
> >                 spin_lock_irq(&cwq->lock);
>=20
> I am not sure why you skip "if (cwq->thread =3D=3D current)" case, it can
> deadlock in the same way.

I wasn't sure what would happen with recursion.

> But, perhaps we should not change flush_cpu_workqueue(). If we detect the
> deadlock, we will have num_online_cpus() reports, yes?

Not sure what you're thinking of here. I initially had it in
flush_workqueue() but then put it into flush_cpu_workqueue(), but I have
to admit that I already forgot why.

> And,
>=20
> >                 if (!list_empty(&cwq->worklist) || cwq->current_work !=
=3D NULL) {
> > @@ -376,6 +388,8 @@ void fastcall flush_workqueue(struct wor
> >         int cpu;
> >
> >         might_sleep();
> > +       lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> > +       lock_release(&wq->lockdep_map, 0, _THIS_IP_);
>=20
> one of the 2 callers was already modified. Perhaps it is better to add
> lock_acquire() into the second caller, cleanup_workqueue_thread(), but
> skip flush_cpu_workqueue() ?

I'll have to look at the code.

The problem I discussed with Arjan is that with this patch all
workqueues are in the same class which is wrong, so I'll have to modify
the workqueue creation API by introducing some macros for the LOCKDEP
case that pass the current code spot as the workqueue class. I'll try to
do that later today.

johannes

--=-Ft9hCOBo7S2XxS437mua
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGiLlm/ETPhpq3jKURAletAJ9mmIL6F7sUIszQTFgnSN0/ZBGKvwCgiB+V
oxit7RMZS8Mf8j32D1JS11w=
=9ZrB
-----END PGP SIGNATURE-----

--=-Ft9hCOBo7S2XxS437mua--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbXGDLwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbXGDLwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXGDLwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:52:32 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbXGDLwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:52:30 -0400
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <20070703173112.GA108@tv-sign.ru>
References: <1182969638.4769.56.camel@johannes.berg>
	 <1183048429.4089.1.camel@johannes.berg>
	 <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4>
	 <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg>
	 <20070703173112.GA108@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Bqc4nt2kh6qXzJ2eKeJg"
Date: Wed, 04 Jul 2007 13:49:32 +0200
Message-Id: <1183549772.3812.10.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Bqc4nt2kh6qXzJ2eKeJg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Oleg,

Thanks for your comments. Shows how little I really understand the
workqueue API :)

On Tue, 2007-07-03 at 21:31 +0400, Oleg Nesterov wrote:

> > I think this could lead to false positives, but then I think we
> > shouldn't care about those. Let me explain. The thing is that with this
> > it can happen that the code using the workqueue somehow obeys an
> > ordering in the work it queues, so as far as I can tell it'd be fine to
> > have two work items A and B where only B takes a lock L1, and then have
> > a wait_on_work(A) under L1, if and only if B was always queued right
> > after A (or something like that).
>=20
> Not sure I understand. Yes, we can have false positives, but I think the
> ordering in the workqueue doesn't matter.
>=20
> If A does NOT take a lock L1, then it is OK to do cancel_work_sync(A)
> under L1, regardless of which other work_structs this workqueue has,
> before or after A.

Ah, cancel_work_sync() waits only for it if A is currently running?

> Now we have a false positive if some time we queue B into that workqueue,
> and this is not good.

Right. I was thinking of the flush_workqueue case where any of A or B
matters.

> We can avoid this problem if we put lockdep_map into work_struct, so
> that wait_on_work() "locks" work->lockdep_map, while flush_workqueue()
> takes wq->lockdep_map.

Yeah, and then we'll take both wq->lockdep_map and the
work_struct->lockdep_map when running that work. That should work, I'll
give it a go later.

> But probably we don't need this right now, at least until we really
> have a lot of false positives while converting from flush_workqueue()
> to cancel_work_sync/cancel_delayed_work_sync.

I didn't really think about those yet, but I think you're right.

> > @@ -257,7 +260,9 @@ static void run_workqueue(struct cpu_wor
> >
> >  		BUG_ON(get_wq_data(work) !=3D cwq);
> >  		work_clear_pending(work);
> > +		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> >  		f(work);
> > +		lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
>                                                    ^^^
> Isn't it better to call lock_release() with nested =3D=3D 1 ?

Not sure, Ingo?

> > +#define create_workqueue(name) \
> > +({								\
> > +	static struct lock_class_key __key;			\
> > +	struct workqueue_struct *__wq;				\
> > +								\
> > +	__wq =3D __create_workqueue((name), 0, 0, &__key);	\
> > +	__wq;							\
> > +})
>=20
> Why do we need __wq ?

No particular reason I think, I copied some other code doing it that
way.

> 	+#define create_workqueue(name) \
> 	({							\
> 		static struct lock_class_key __key;		\
> 		__create_workqueue((name), 0, 0, &__key);	\
> 	})
>=20
> Actually, I'd suggest to rename __create_workqueue() to __create_workqueu=
e_key(),
> and then you need the only change in linux/workqueue.h
>=20
> 	- extern struct workqueue_struct *__create_workqueue(...);
> 	+ extern struct workqueue_struct *__create_workqueue_key(..., key);
> 	+ #define __create_workqueue(...)	\
> 	+	static struct lock_class_key __key;	\
> 	+	__create_workqueue_key(..., key);	\
>=20
> but this is a matter of taste.

Sure, that works. I thought about compiling out the argument completely
for the no-lockdep case, would you prefer that?

> Btw, I think your patch found a real bug in net/mac80211/, cool!

Actually, I found the bug by experiencing it and analysing the stack
traces; then I thought that it should be possible to add lockdep support
for that to avoid regressing :)

johannes

--=-Bqc4nt2kh6qXzJ2eKeJg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGi4lM/ETPhpq3jKURAva/AJ9fXarGWVy/PYvNj7eCOPBA5R4ORwCfeMQ4
Vnv8CO8ej0FMrQXwQ2CXSss=
=OTKc
-----END PGP SIGNATURE-----

--=-Bqc4nt2kh6qXzJ2eKeJg--


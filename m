Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZA0IqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZA0IqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZA0IpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:45:21 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:50177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZA0IpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:45:19 -0500
Subject: Re: [PATCH] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090126230721.GA6556@elte.hu>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wP39TkZEKiKzPAquDn0p"
Date: Tue, 27 Jan 2009 09:45:08 +0100
Message-Id: <1233045908.4012.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wP39TkZEKiKzPAquDn0p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 00:07 +0100, Ingo Molnar wrote:
> * Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> > This modifies the timer code in a way to allow lockdep to detect=20
> > deadlocks resulting from a lock being taken in the timer function as=20
> > well as around the del_timer_sync() call.
> >=20
> > Validated with this module, otherwise bootup was clean.
>=20
> That's a really neat trick ...

Did it with workqueues earlier :)

> Curious: have you hit such a bug recently that motivated you to implement=
=20
> it?

No, I haven't hit a bug, but code inspection made me wonder whether or
not it could trigger. Didn't have a chance to try yet, had no hardware
available for this particular case.

> > +#ifdef CONFIG_LOCKDEP
> > +#define init_timer(timer)						\
> > +	do {								\
> > +		static struct lock_class_key __key;			\
> > +		init_timer_key((timer), #timer, &__key);		\
> > +	} while (0)
> > +#define init_timer_deferrable(timer)					\
> > +	do {								\
>=20
> (Style detail: please put a newline after each macro block to make them=20
> stand apart a bit more.)

Sure.

> >  int del_timer_sync(struct timer_list *timer)
> >  {
> > +#ifdef CONFIG_LOCKDEP
> > +	unsigned long flags;
> > +
> > +	local_irq_save(flags);
> > +	lock_map_acquire(&timer->lockdep_map);
> > +	lock_map_release(&timer->lockdep_map);
> > +	local_irq_restore(flags);
> > +#endif
>=20
> yummie. We have repeat bugs in this area that are rather tricky to find.=20
> This will trigger them in a debuggable way.
>=20
> > @@ -861,10 +881,21 @@ static inline void __run_timers(struct t
> > =20
> >  			set_running_timer(base, timer);
> >  			detach_timer(timer, 1);
> > +
> >  			spin_unlock_irq(&base->lock);
>=20
> Yes, the newline is needed there :-) [seriously]

Hah. I was editing code there in that area and removed it later again,
not realising I left the newline.

> >  				int preempt_count =3D preempt_count();
> > +
> > +				/* Couple the lock chain with the lock chain at
> > +				 * del_timer_sync by acquiring the lock_map around
> > +				 * the fn() call here and in del_timer_sync.
> > +				 */
>=20
> Please use the standard multi-line comment style:
>=20
>   /*
>    * Comment .....
>    * ...... goes here:
>    */

Oops, yes.

johannes

--=-wP39TkZEKiKzPAquDn0p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfsmPAAoJEKVg1VMiehFY5zsP/0az90o2oOD1ChXosqgwByBY
Ciu4EwMdM3MDKr0kk29uVJSkQxXW5mpwcrwhn3jJPNuqreH3BIsg3Gg60L8m/mUF
LVIGvIaEyNv3aY7oukyL4T8VKnEaTaKiZmU80T1OyTsK5w23y253e0B0gesMNFXc
XE+8AY/BpCeghco4w3mhwG45YcJT5LQCnAZ/N9wnfVBZhwLjWYOHJnfNcB81J3in
Dxa6XKQyfsy3ZBO7gOetp7aIS759QKSkE2tukUXk8/DGdfJ3raE6Qq1xKk6hfTQO
q/3kDSEkPYTT5TR6myZMx7A+oM7akBJZAIL9K5M46mKgU9wpZ1tvMzTR+YNUOwAV
Fu15mdpdoLQ2wFYnDXdr41gvVRMeLSkvSSD4TNoB0YQSnKjarAIrVGy1q64lOQC3
IU5poNyciASVyTQ2DTlO30J0+Xy5MKW+8MPNQz2h2qaew+QcfBPP7iJPqwCOzXXC
zUx6JFHEljuSiCmh8ddfizH1HYingw03oIjRLorHjnqjxWFltzdFEDTFBTjO/ejz
nJdbeEdgSDpKHFV1qrrPp9NVK7ozIHpupWUEe5bj9cCpaRuB8hG2NuIXh0lApVNY
pxVTGwSmrXJVJMB+cLlpzKt7foPlbp+hJ1VkGUXZo2Tv2aL+M00gR1nyUEnLPV4y
JrYfgHCv9KlKkecU2iY8
=JEn6
-----END PGP SIGNATURE-----

--=-wP39TkZEKiKzPAquDn0p--


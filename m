Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894Ab0AMLLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab0AMLLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560Ab0AMLLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:11:11 -0500
Received: from ms01.sssup.it ([193.205.80.99]:54550 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755478Ab0AMLLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:11:09 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: fork and terminate task logic
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1262100041.7135.157.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707661.6228.455.camel@Palantir>  <1262100041.7135.157.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KeI/jbzXv7SNv3OOKKQD"
Date: Wed, 13 Jan 2010 12:11:07 +0100
Message-ID: <1263381067.3853.103.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KeI/jbzXv7SNv3OOKKQD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 16:20 +0100, Peter Zijlstra wrote:
> > -       if (!rt_prio(p->prio))
> > +               /*
> > +                * the child will be SCHED_DEADLINE, but with zero band=
width.
> > +                * The parent (or some other task) must call setschedul=
er_ex
> > +                * on it, or it won't ever start.
> > +                */
> > +               init_deadline_task(p);
> > +               p->dl.flags &=3D ~DL_NEW;
> > +               p->dl.flags |=3D DL_THROTTLED;
>=20
> I recently added ->task_fork(), which is called after the class
> assignment.
>=20
Saw that, and it is being of great help! :-P

> > +       } else if (rt_prio(p->prio))
> > +               p->sched_class =3D &rt_sched_class;
> > +       else
> >                 p->sched_class =3D &fair_sched_class;
> > =20
> >  #ifdef CONFIG_SMP
> > @@ -2744,6 +2756,10 @@ static void finish_task_switch(struct rq *rq, st=
ruct task_struct *prev)
> >         if (mm)
> >                 mmdrop(mm);
> >         if (unlikely(prev_state =3D=3D TASK_DEAD)) {
> > +               /* a deadline task is dying: stop the bandwidth timer *=
/
> > +               if (deadline_task(prev))
> > +                       hrtimer_cancel(&prev->dl.dl_timer);
> > +
> >                 /*
> >                  * Remove function-return probe instances associated wi=
th this
> >                  * task and put them back on the free list.=20
>=20
> Shouldn't this be done in the ->dequeue_task() callback?
>
Not sure of this snippet... Actually, it is one of the most disturbing
piece of code of this whole scheduler. :-(

The reason why it is here is that I think it is needed to call
hrtimer_cancel() _without_ holding the rq->lock, is that correct?

It is=20

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-KeI/jbzXv7SNv3OOKKQD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNqkoACgkQk4XaBE3IOsQ2UwCfTGdQQ7ecHa1zxMNZU/Iad8BX
LQoAnAokYD5tSVSAEnIgHtULbUtsm3od
=gXt2
-----END PGP SIGNATURE-----

--=-KeI/jbzXv7SNv3OOKKQD--


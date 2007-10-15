Return-Path: <linux-kernel-owner+w=401wt.eu-S1765043AbXJON56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765043AbXJON56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbXJON5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:57:49 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:63972 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757414AbXJON5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:57:47 -0400
Subject: Re: [RFC][PATCH] sched: SCHED_FIFO watchdog timer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Lennart Poettering <mztabzr@0pointer.de>
In-Reply-To: <b647ffbd0710150626v4273814esce681daa4467f173@mail.gmail.com>
References: <1192222309.5897.3.camel@lappy> <1192315867.5625.6.camel@lappy>
	 <b647ffbd0710150626v4273814esce681daa4467f173@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IljBdyTOnrf8hVvbq1Kx"
Date: Mon, 15 Oct 2007 15:57:42 +0200
Message-Id: <1192456662.27435.74.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IljBdyTOnrf8hVvbq1Kx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-15 at 15:26 +0200, Dmitry Adamushko wrote:
> On 14/10/2007, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > The below patch is an idea proposed by tglx and depends on sched-devel =
+
> > the hrtick patch previously posted.
> >
> > The current watchdog action is to demote the task to SCHED_NORMAL,
> > however it might be wanted to deliver a signal instead (or have more pe=
r
> > task configuration state). Which is why I added Lennart to the CC list
> > as I gathered he would like something like this for PulseAudio.
> >
> > ---
> > Subject: sched: SCHED_FIFO watchdog timer
>=20
> Why only SHCED_FIFO and not SCHED_RR?
> Their (mis)behavior is similar wrt SCHED_NORMAL tasks.

Because SCHED_FIFO is easier, _RR is for later. It was mostly an RFC to
request behavioural wishes from the users.

>=20
> > +#ifdef CONFIG_SCHED_HRT_TICK
> > +static int fifo_watchdog(struct rq *rq, struct task_struct *p, int que=
ued)
> > +{
> > +       if (likely(!queued || p->policy !=3D SCHED_FIFO))
> > +               return 0;
> > +
> > +       /*
> > +        * task has been naughty, turn into SCHED_NORMAL
> > +        */
> > +       printk(KERN_INFO "SCHED_FIFO task %s/%d exceeded his runtime qu=
ota,"
> > +                       " demoting to regular task\n", p->comm, task_pi=
d_nr(p));
> > +       deactivate_task(rq, p, 0);
> > +       __setscheduler(rq, p, SCHED_NORMAL, 0);
> > +       activate_task(rq, p, 0);
> > +       resched_task(p);
>=20
> I guess, put_prev_task() / set_curr_task() should be called (for the
> case of task_running(p)) to make it group-scheduler-friendly (as it's
> done e.g. in sched_setscheduler()).
>=20
> (normilize_task() should probably do the same)

Right, that is where I copied from, I'll pull the functionality into a
single function and make this and the sysrq stuff use it.

Thanks!

--=-IljBdyTOnrf8hVvbq1Kx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHE3HWXA2jU0ANEf4RAjfpAJsH9sGKVlExtsBLc4okr//c2cbY2ACgi2PU
IXdBDzj33vRYwPw/VwEw4H0=
=1Dpe
-----END PGP SIGNATURE-----

--=-IljBdyTOnrf8hVvbq1Kx--


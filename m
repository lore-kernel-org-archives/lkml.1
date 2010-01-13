Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494Ab0AMK1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0AMK1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436Ab0AMK1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:27:39 -0500
Received: from ms01.sssup.it ([193.205.80.99]:48886 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755346Ab0AMK1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:27:36 -0500
Subject: Re: [RFC 12/12][PATCH] SCHED_DEADLINE: modified sched_*_ex API
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
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1262012958.7135.124.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255708086.6228.469.camel@Palantir>  <1262012958.7135.124.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-emk/v7IVF6PE4wX8qu6J"
Date: Wed, 13 Jan 2010 11:27:32 +0100
Message-ID: <1263378452.3853.61.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-emk/v7IVF6PE4wX8qu6J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-28 at 16:09 +0100, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 17:48 +0200, Raistlin wrote:
> > @@ -6807,9 +6811,10 @@ out_unlock:
> >  /**
> >   * sys_sched_getparam - get the DEADLINE task parameters of a thread
> >   * @pid: the pid in question.
> > + * @len: size of data pointed by param_ex.
> >   * @param_ex: structure containing the new parameters (deadline, runti=
me, etc.).
> >   */
> > -SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
> > +SYSCALL_DEFINE3(sched_getparam_ex, pid_t, pid, unsigned, len,
> >                 struct sched_param_ex __user *, param_ex)
> >  {
> >         struct sched_param_ex lp;
> > @@ -6818,6 +6823,8 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
> > =20
> >         if (!param_ex || pid < 0)
> >                 return -EINVAL;
> > +       if (len < sizeof(struct sched_param_ex))
> > +               return -EINVAL;
> > =20
> >         read_lock(&tasklist_lock);
> >         p =3D find_process_by_pid(pid);
>=20
> This allows len > sizeof().
>=20
Yes...

> > @@ -6837,7 +6844,7 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
> >         /*
> >          * This one might sleep, we cannot do it with a spinlock held .=
..
> >          */
> > -       retval =3D copy_to_user(param_ex, &lp, sizeof(*param_ex)) ? -EF=
AULT : 0;
> > +       retval =3D copy_to_user(param_ex, &lp, len) ? -EFAULT : 0;
> > =20
> >         return retval;=20
>=20
> Which would copy more than lp, resulting in a stack leak, right?
>=20
... And yes again! :-)

This has been done bearing in mind that the _kernel_side_ sched_param_ex
--once stabilized-- will never lower its size. I.e., it should always
grow and, if/when it does, it should retain the position of existing
fields, for the sake of backward compatibility.

In that case, I think, the only possible case we have to face is the one
where the "old" userspace program/library uses a version of
sched_param_ex which is smaller than the one in the kernel, and what we
want is the kernel to fill only the fields existing in the userspace
code.

Does all this make sense?

If yes, I guess I just have to flip the inequality in the if() turning
it into "if (len > sizeof())" (, then apologize for the glaring
bug! :-P) and then I'm done, am I?

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-emk/v7IVF6PE4wX8qu6J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNoBQACgkQk4XaBE3IOsQebQCfYRofWzuIGGUkABvBu3W/75ga
r/IAmwfE7Cb7EU2LUksuKNoU8PjXAaaY
=xFRO
-----END PGP SIGNATURE-----

--=-emk/v7IVF6PE4wX8qu6J--


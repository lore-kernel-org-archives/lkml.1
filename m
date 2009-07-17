Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbZGQAc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbZGQAc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933805AbZGQAc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:32:29 -0400
Received: from ms01.sssup.it ([193.205.80.99]:39603 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933734AbZGQAc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:32:27 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ted Baker <baker@cs.fsu.edu>, Dhaval Giani <dhaval.giani@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
In-Reply-To: <1247734722.15471.83.camel@twins>
References: <4A5B61DF.8090101@nortel.com>
	 <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	 <1247589099.7500.191.camel@twins>
	 <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
	 <20090715205503.GA14993@cs.fsu.edu> <4A5E4FDD.7090307@nortel.com>
	 <20090715223400.GF14993@cs.fsu.edu>
	 <8aa016e10907151539t16fb1d7fk3122d77e69ac7de5@mail.gmail.com>
	 <20090715231646.GI14993@cs.fsu.edu>  <1247734722.15471.83.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gCBOqnj7FPo9/Pu1mCZc"
Date: Fri, 17 Jul 2009 02:32:23 +0200
Message-Id: <1247790743.4929.169.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gCBOqnj7FPo9/Pu1mCZc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 10:58 +0200, Peter Zijlstra wrote:
> Right so control-groups (cgroups for short) are a form of
> virtualization. Each controller is specific to a resource. We have
> memory controllers, namespace controllers and also a scheduler
> controller.
>=20
> If you would apply all controllers to the same task groups you get a
> result like chroot on steroids, or jails etc. But you can also use them
> individually to control resources in creative ways.
>=20
> In order to manage RT resources you want:
>=20
>   - a minimum bandwidth guarantee
>   - isolation
>=20
> So ideally you want a CBS server that schedules your RT (FIFO/RR) tasks.
>=20
Or, maybe, an RT fix-priority RT scheduling class (for FIFO/RR tasks)
with some kind of bandwidth limiting fix-priority algorithm for groups,
such as deferrable server (which is basically what you have now) or,
sporadic server.

What do you think about this?

The only thing you need to have this working is adding the capability of
explicitly assigning priorities to groups!
I'm sending some code for this in the next days... It has some (even
serious) issues, or at least some features that would need discussing
about, but it's a start.

Obviously, you can also have EDF in place, maybe as a different
scheduling class than sched-rt, able to accomodate EDF tasks, if wanted,
or again FIFO and RR task sets ("ghosts"), as in Fabio's proposal.

To me, this seems the very best solution both for real-time people
(which will get FP and EDF!) and for other users... And it also makes it
easier to retain POSIX compatibility (if the system is properly
configured) than if we add deadlines to sched-rt groups.

But that's only my very humble opinion. :-D

> Furthermore the whole feature is still marked EXPERIMENTAL, basically
> because I do recognize it for the hack it is -- that said, some people
> might find it useful.
>=20
Hey, it is very useful for me actually!! Without it I would be sleeping
right now... And not here coding and answering mails at this late time
in the night!! :-P

> These groups get assigned a bandwidth through the use of a period and
> runtime group parameter -- the documentation states that using different
> periods is currently broken and would require a deadline server.
>=20
Or a priority, since we are in the fixed priority scheduling class?

> Therefore we can assume all periods are equal, for the rest of this
> description -- and set it to 1s.
>=20
>=20
> So what does it do, its a hierarchical FIFO scheduler, with the prio of
> a group being that of the max prio of its children. If a group runs out
> of quota it will be dequeued. When the period timer comes along and
> refreshes the quota it will be requeued.
>=20
>       R
>      / \
>     A   B
>    / \  |\
>   1   4 C 3
>         |
>         2
>=20
> groups in letters, tasks in digits.
>
> [...]
>
WoW!! Very nice, thorough and clear explanation... Consider adding it to
Documentation/! :-D

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-gCBOqnj7FPo9/Pu1mCZc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpfxpAACgkQk4XaBE3IOsSUNQCeKjz7n0RU/CnqV19DCV8jJBd5
faYAn0JfGMPRP6x8QS20QaZvgxou1LL/
=GndO
-----END PGP SIGNATURE-----

--=-gCBOqnj7FPo9/Pu1mCZc--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZJYIqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZJYIqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 04:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZJYIqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 04:46:18 -0400
Received: from ms01.sssup.it ([193.205.80.99]:33885 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752297AbZJYIqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 04:46:16 -0400
Subject: Re: [PATCH] DRTL kernel 2.6.32-rc3 : SCHED_EDF, DI RT-Mutex,
 Deadline  Based Interrupt Handlers
From: Raistlin <raistlin@linux.it>
To: Soumya K S <ssks.mt@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@gandalf.sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <e932a33e0910220742v5d99adbere9fc9c31f72b6b95@mail.gmail.com>
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com>
	 <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
	 <1256198088.6700.76.camel@Palantir>
	 <e932a33e0910220742v5d99adbere9fc9c31f72b6b95@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QpeMYHIlhEbE4XNWMNdH"
Date: Sun, 25 Oct 2009 09:46:16 +0100
Message-Id: <1256460376.15273.31.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QpeMYHIlhEbE4XNWMNdH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-22 at 20:12 +0530, Soumya K S wrote:=20
> Hi Dario,=20
Hi again,

> we needed a deadline based scheduler for DRTL and we zeroed
> in upon SCHED_EDF. We see that the threads here are fairly new too :-P
>=20
Yes, we are not far from the starting point as well... :-)

> > Nice, from here, it seemed we were working on very similar things, and =
I
> > was wondering if we could somehow collaborate... :-)
> >
> Sure! That would be good :)
>=20
So... I looked at the code and, even if the aim of our two projects are
quite the same, our implementations are very different.

The main difference is the bandwidth reservation thing.
I strongly think that, on a system like Linux, it should be very
important to have --at least as a possibility-- the following features:
- tasks can request for a guaranteed runtime over some time interval
  (bandwidth),
- admission test should guarantee no oversubscription
- bandwidth enforcing must avoid reciprocal tasks interferences.
Maybe we can make the second and third configurable/optional (already
thought about that, and it should be quite easy), but they need to be
there, at least to avoid extending the interface again when we'll
realize they'll needed! :-P

I don't know how much you, and other people here, are familiar with such
idea... We implemented it using one of the many existing algorithm. I
can give you pointers to papers and other implementations of it if
interested.
To keep it short and practical, you can think at it as something similar
to what MacOS-X (and I think Solaris) already have --and actively use,
e.g., for the Jack Audio Connection Kit-- and call
THREAD_TIME_CONSTRAINT (very poor docs, I think, but it gives the big
picture):
http://developer.apple.com/mac/library/documentation/Darwin/Conceptual/Kern=
elProgramming/scheduler/scheduler.html#//apple_ref/doc/uid/TP30000905-CH211=
-BEHJDFCA

Moreover, as Peter pointed out, coming out with an interface which is
too much tightly tied to EDF, or to any other specific algorithm,
wouldn't be the best idea. What would happen if somewhere in the future
we decide to change from the EDF algorithm to some other deadline based
one?
That's why we changed the name and the interface from _EDF/_edf (yep, it
has been our first choice too! :-P) to _DEADLINE/_deadline, and that's
why I think we should continue striving for even more
interface-algorithm independence.

Obviously, also SMP has to be there! :-P
We have it in fully partitioned right now, but I'll become global (with
support for cpu-affinity) in very short time I hope (Juri, from ReTiS
Lab in Pisa is already working on it).

For rt-mutexes/deadline inheritance, the big issue is that, it works if
you only have EDF, but with a "bandwidth aware scheduler", you need
something more, which is why we don't have it yet... However, I think it
could be a nice starting point.

Finally, I like the idea of deadline IRQ handling and I think it would
be worth to mind it some more. :-)

> > Even from the implementation point of view, I see you didn't used a new
> > scheduling class.
> >
> A simple system where there a few real-time tasks and a few non-real
> time tasks, the timelines can be architected out for each real-time
> task in the system. In such a case, given the RT bandwidth in the
> system, the task with the lowest deadline gets to be scheduled first
> till it is there in the system.
> In short, for such simple systems, we shifted the burden of admission
> control to the architect and kept close to the existing code.
>=20
Well, I kind of agree on both, _iff_ you're target is _only_ such small
embedded systems. However, my very humble opinion is that, on Linux, you
need something more general and, since we are talking about real-time,
as much predictable and analyzable as you can get... And I think a
separate scheduling class would be better suited for this. What do you
think?

> > I'm right in the opposite situation, I've got SMP (partitioned for now,
> > but we're working on migrations) and also CGROUPS support, but we are
> > still wondering how deadline (or something more sophisticated, like
> > bandwidth) inheritance could work in such a case...
> >
> That's right, we are still working on SMP and hope there are no
> scalability issues in this patch w.r.t SMP.
>=20
Well, I don't know. I guess achieving something similar to what we
already have now (partitioned SMP) should not be impossible even with
your approach... But if you want something different, such has global
(EDF) scheduling, where task can migrate among CPUs according to their
affinity, would but a major headache!! :-O

> > Do you already have any numbers or testcase? I have some (well, a few!)
> > of them... I'll try to find the time to give it a try to your patch wit=
h
> > them...
> >
> We have tested Co-operative context switch time, Pre-emptive context
> switch time and Interrupt Latency, all of them are of ~130us for
> OMAP3530.
>=20
Mmm... I'm not sure I see why and how your patch should affect context
switches duration... However, do you have the testcases for such tests?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-QpeMYHIlhEbE4XNWMNdH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrkEFEACgkQk4XaBE3IOsRRmQCghtOCaCEOryM3jraKZ2prvRWe
57sAn06GSC4z+IQQjCZWHAM/qvV3+d5S
=1JEd
-----END PGP SIGNATURE-----

--=-QpeMYHIlhEbE4XNWMNdH--


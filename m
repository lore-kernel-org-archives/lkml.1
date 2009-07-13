Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZGMPoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZGMPoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZGMPoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:44:10 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54149 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756237AbZGMPoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:44:09 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1247412708.6704.105.camel@laptop>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+L3c0QyQJbVpiOks8OCK"
Date: Mon, 13 Jul 2009 17:44:03 +0200
Message-Id: <1247499843.8107.548.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+L3c0QyQJbVpiOks8OCK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-07-12 at 17:31 +0200, Peter Zijlstra wrote:
> But the thing that concerns me most, there seem to be a few O(n)
> consequences. Suppose that for each resource (or lock) R_i, there is a
> block graph G_i, which consists of n nodes and would be m deep.
>
> [...]
>
> However PEP on SMP needs to ensure all n tasks in G_i are on the same
> cpu, because otherwise we can end up wanting to execute the resource
> owner on multiple cpus at the same time, which is bad.
>=20
That's from where we are trying to start evaluating the various
possibilities to extend the idea to SMP.

What we would like to achieve is some set of rules that, extending the
UP ones, yield a situation which is both:
- analyzable from the real-time theorist's point of view... Which is
  (un?)fortunately what we are :-)
- possible to implement... Which is not always (un!)fortunately obvious=20
  here :-)

I hope you don't mind if I share some thoughts with you about the
solution I was wondering about... In case you do, just ignore and excuse
me.

Very basically: from the analysis point of view one easy and effective
solution would be to have the blocked-running tasks --i.e., the tasks
blocked on some lock that have been left on the rq to proxy-execute the
lock owner-- busy waiting while the lock owner is running. This allows
for retaining a lot of nice properties BWI already has, as far as
analyzability is concerned.

On the other hand, from the practical end efficiency point of view, it
would be not that difficult to block these otherwise-spinning tasks, in
order to avoid wasting CPU time too much... The only important thing is
to properly account the budget of the correct server/group (which
probably must be the otherwise-spinning task's one), or the analysis is
gone again! :-O

Also, this will probably imply some amount of block/wakeup overhead
which could be of some impact especially in involved, maybe rare, but
possible, locking schemes... which we would like to evaluate
thoroughly...

> This can of course be amortized, but you end up having to migrate the
> task (or an avatar thereof) to the owner's cpu (if you'd want to migrate
> the owner to the blocker's cpu, then you're quickly into trouble when
> there's multiple blockers), but any way around this ends up being O(n).
>=20
I agree... Computational complexity is also an issue, and something to
whom we have to validate against.

> Also, when the owner gets blocked on something that doesn't have an
> owner (io completion, or a traditional semaphore), you have to take all
> n tasks from the runqueue (and back again when they do become runnable).
>=20

> PIP doesn't suffer this, but does suffer the pain from having to
> reimplement the full schedule function on the waitqueues, which when you
> have hierarchical scheduling means you have to replicate the full
> hierarchy per waitqueue.
>=20
And, further than this, at least from my point of view, if you have
server/group based scheduling, and in general some kind of budgeting or
bandwidth enforcing mechanism in place, PIP is far from being a
solution...

> Furthermore we cannot assume locked sections are short, and we must
> indeed assume that its any resource in the kernel associated with any
> service which can be used by any thread, worse, it can be any odd
> userspace resource/thread too, since we expose the block graph to
> userspace processes through PI-futexes.
>=20
Agree, 100%. :-)

Again, sorry for bothering with if someone of you is not interested...
If instead you are, any comments is more than welcome.

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-+L3c0QyQJbVpiOks8OCK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpbVkMACgkQk4XaBE3IOsQnSACgq/VhINs4DXpJtQECWnC7KVKf
v20An3Xrwu2tvGeJZiwzL+LZydsW2Fbe
=niDk
-----END PGP SIGNATURE-----

--=-+L3c0QyQJbVpiOks8OCK--


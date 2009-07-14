Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZGNKsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZGNKsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZGNKsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:48:02 -0400
Received: from ms01.sssup.it ([193.205.80.99]:42918 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753564AbZGNKsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:48:00 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
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
In-Reply-To: <4A5B61DF.8090101@nortel.com>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1NRz6kERELEN87JfwQzA"
Date: Tue, 14 Jul 2009 12:47:35 +0200
Message-Id: <1247568455.9086.115.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1NRz6kERELEN87JfwQzA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 10:33 -0600, Chris Friesen wrote:
> > On the other hand, from the practical end efficiency point of view, it
> > would be not that difficult to block these otherwise-spinning tasks, in
> > order to avoid wasting CPU time too much... The only important thing is
> > to properly account the budget of the correct server/group (which
> > probably must be the otherwise-spinning task's one), or the analysis is
> > gone again! :-O
>=20
> Could you elaborate on this "proper accounting"?
>=20
Well, I can try, but that's exactly the trickiest part! :-O

> If task A is blocked waiting for a lock (held by a task B on another
> cpu) and we run task C instead, how would you propose that the
> accounting be handled?
>=20
Ok, here we are.

=46rom the point of view of real-time theory, all is about having the (m,
on an m-CPU system) highest priority task(s) always running. That's
something a real-time theorist could kill to achieve! :-D

That is basically --well, as far as I've understood it since now! :-)--
because if you are sure you always have the highest task(s) up and
running, the schedulability analysis is "simple", and there are zillions
of schedulability test that can be applied and that will work more or
less out of the box!

The capability of a task to block complicates things in the sense that,
if (one of) your highest priority task(s) blocks, you end up in
executing someone else, invalidating our previous assumption. Moreover,
if also priority inversions can happen, well, guys, we are screwed! :-(=20

I think it is quite easy to figure out that blocking protocols, e.g. PI,
P(C)P, SRP, etc., act in the direction of mitigating right that kind of
issue, agree?
Now, if you came to server/group based scheduling[*] this is even nicer.
In fact, if you quickly go through the paper Peter pointed out (which is
our implementation of BWI --an incarnation of PEP, actually--) or to the
more theoretical one that describes the protocol in details[1], you will
find out that having proxying in place completely removes the blocking!
How is that possible? Well, when a task A blocks on B, then B executes
when and *where* A should: i.e., B is temporary added to A's group, uses
its priority/deadline and *consumes* its budget. This means that A's
group is always ready to run whenever it becomes the highest priority
group, even if A is blocked, which is why we say there is no more room
for blocking.

Now, all the above is true on UP setups. Extending to SMP (m CPUs) and
considering the first part of my draft proposal, i.e., having the
proxying tasks busy waiting (would say "spinning", but that busy wait is
interruptible, preemptable, etc.) on some CPU while their proxy is being
scheduled, we are back to the case of having the m highest entity
running... And thus we are happy!
This is because, again, given the holding of that assumption, all the
existent schedulability analysis automagically start working again,
without the need of accounting for any blocking term or blocking time
duration.

What we like most with this is that it means you can decide the
bandwidth (e.g., budget/period) you want to assign to each task group,
run one of the available scheduling tests --with and only with that
values!!--to see if it fits, turn the light on and=20
		_have_it_properly_enforced_,
without the need of clairvoyance on task blocking patterns and
durations.
Moreover, if you hare an hard real-time guy, and you have the knowledge
of the length of your critical sections you can use them to properly
dimension the budget of your server/group... But I don't think this is
the Linux case, is it? :-P

And so we are done!

Well, so and so. I fact, if you want (and we want! :-D) to go a step
further, and consider how to remove the --possibly quite log on Linux as
Peter said-- wasting of CPU time due to busy waiting, what you can do is
to actually block a proxying task, instead of having it "spinning", so
that some other task in some other group, which may not be one of the m
highest prio ones, can reclaim that bandwidth... But... Ladies and
gentlemen, here it is: BLOCKING. Again!! :-(
That's where we are right now, trying to find some possible solution to
avoid reintroducing from the window what we are trying to kick out from
the door, striving for a good compromise between pure theory and
practical viability.

A draft solution could be to act as said right above, but also pretend
that the correct groups/tasks have executed, such that the effects of
the blocking would be, let's say, absorbed... So, yes, something similar
to what you are arguing: decrease the budget of B (B's group?) when C is
being run.
I agree, this rises issues as well, e.g., is another kind of
"inheritance" to take care of, also, how many and which task/group's
budget are we going to affect?, and so on... But it's just a first shot
in the dark.

Ok, I see I've definitely written too much... Sorry about that... I Hope
I at least managed in making my point a little bit clearer... If not,
feel free to ask again.
As I repeat, we are still quite near to the starting blocks with this
thing, but I still am glad to share thoughts with all of you! :-)

Regards,
Dario

[*] but a more real-timish group scheduling than the one present in
Linux right at the moment, i.e., something where groups have (fixed or
dynamic) priorities.

[1] http://feanor.sssup.it/%7Elipari/papers/rtss2001-bwi.ps.gz

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-1NRz6kERELEN87JfwQzA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpcYkAACgkQk4XaBE3IOsSEJgCfVrk9wl/dXVrQDa94v5lsFwiH
S5wAoJkz7QIZDLUwSbq4tqfA4s83RIoB
=nrh2
-----END PGP SIGNATURE-----

--=-1NRz6kERELEN87JfwQzA--


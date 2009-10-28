Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZJ1QY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZJ1QY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZJ1QY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:24:58 -0400
Received: from ms01.sssup.it ([193.205.80.99]:35891 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752833AbZJ1QY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:24:57 -0400
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
In-Reply-To: <e932a33e0910280715u1722b8b4k9dabda45c61151ad@mail.gmail.com>
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com>
	 <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
	 <1256198088.6700.76.camel@Palantir>
	 <e932a33e0910220742v5d99adbere9fc9c31f72b6b95@mail.gmail.com>
	 <1256460376.15273.31.camel@Palantir>
	 <e932a33e0910280715u1722b8b4k9dabda45c61151ad@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-y+dWh4+ZGBJ0nI4mUmb+"
Date: Wed, 28 Oct 2009 17:24:50 +0100
Message-Id: <1256747090.25821.367.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y+dWh4+ZGBJ0nI4mUmb+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-28 at 19:45 +0530, Soumya K S wrote:
> > The main difference is the bandwidth reservation thing.
> > I strongly think that, on a system like Linux, it should be very
> > important to have --at least as a possibility-- the following features:
> > - tasks can request for a guaranteed runtime over some time interval
> >  (bandwidth),
>=20
> We can specify the bandwidth reservation of an RT class and we use the
> reservation policy of the RT scheduling class itself.=20
>
Yes, and all that you can specify is how much bandwidth all the
EDF+FIFO tasks in the system will get. I was talking about something
very different... :-(

> By increasing
> the static priority of the EDF task, we can guarantee that EDF tasks
> always get the required runtime.=20
>
Which is not enforced to stay below any kind of value of
deterministic/stochastic worst case execution time nor any kind of
budget which is guaranteed to not being overrun. This means that you
have no way to analyze the system and that you can make no assumptions
about your tasks meeting their deadline or not, about who's going to
miss it, by how far, etc.

You can have an EDF task A executing for more than what you expected (if
you expected something, and you _should_ expect something if you want to
analyze the system at some level, don't you?) and maybe missing its
deadline.

Much more worse, you can have task A executing for more than what you
expected and making task B and/or C and/or WHATEVER missing _their_
deadline, even if they "behave well"... This is far from real-time
guaranteed behaviour, at least in my opinion. :-(

> If the user puts all his EDF tasks in
> priority 1 , only his tasks run. In that case the entire RT bandwidth
> is reserved for the EDF tasks. In a way your patch also does the same
> thing by placing itself above the RT scheduling class.=20
>
Agree on this, never said something different. :-)

At least it is well known that deadline tasks have higher priority than
FIFO/RR tasks that have higher priority than OTHER tasks. This, together
with reservation based scheduling at the task (or at least task-group)
level is what make the system analyzable and predictable.

> Only thing what
> we don't have in place is partitioning of RT bandwidth across RR/FIFO
> and EDF, which right now, we overcome by intelligently placing the
> tasks with different policies in different priority levels.
>
I'm not finding the 'intelligent placing' in the patch, so I guess this
is up to the userspace. Providing the userspace with a flexible solution
is something very useful... Relying on userspace to do things
'intelligently' is something I'm not sure I would do, especially in a so
much general purpose OS like Linux, used in so much different contexts.
But, again, that's only my opinion. :-)

If I understood the code well (somme comments here and there would have
helped! :-P) one (or more) EDF task(s) can starve FIFO/RR tasks, which
may happen to me as well. However, it also may happen that one (or more)
FIFO/RR task(s) starve EDF tasks!

Thus, there always could be someone which might be starved and you can't
even say who it will be... Again, this seems lack of determinism to me.

> If you are asking bandwidth reservation for guaranteeing determinism,
> we definitely have determinism in place, but bandwidth reservation for
> other real-time scheduling policies is not in place.
>
See? World is so beautiful because there are so much different possible
opinions and interpretations of the same concepts! :-D :-D

> > - admission test should guarantee no oversubscription
>=20
> So, you are calculating the WCET online in the scheduler right?=20
>
No, I don't... Did you looked at the code?

> Can it
> calculate the amount of CPU time with the  required preciseness? Here,
> you are increasing the enqueue time by adding an O(n) calculation for
> every task that you enqueue.=20
>
No, I don't... Did you looked at the code? :-P

> That is the reason why for a small
> system, pushing this to architect made better sense in terms of
> decreased latencies where the turn around time from when the task
> enters till it gets the desired result matters, e.g., reading a sensor
> 2 times in 1ms.
>=20
Given the fact that I do not have anything in the scheduler that
increase latencies and enqueue/dequeue overhead, it sure depends on
you're target, as already said.

You keep saying that for a small system it is up to the system architect
to check if the configuration will be schedulable or not, which may be
reasonable.
What I'm wondering is how this poor guy might do that and hope to have
this enforced by a scheduling policy which allows a task to interfere
with all the other ones to the point of making them missing their
deadlines... And this could happen in your code, since you only have
deadline miss based checks, which may be not enough to prevent it.

> > That's why we changed the name and the interface from _EDF/_edf (yep, i=
t
> > has been our first choice too! :-P) to _DEADLINE/_deadline, and that's
> > why I think we should continue striving for even more
> > interface-algorithm independence.
> >
> True, but we really think its a matter of trade-off between how much
> response time you can guarantee for a real-time task v/s how much
> scalable you want your design to be.=20
>
Well, I'm not seeing how trying to have a better interface/algorithm
separation would affect the response time that much... For example, I
don't expect that putting your code in a separate scheduling class would
make you miss some deadline...

> The deterministic response times
> that you might have achieved by having all these features might be
> good enough (Not sure of your numbers here) in a soft real time
> scenario, but wondering if it would meet ends otherwise.
>=20
The response time I can achieve with all these features is exactly the
same you can achieve with the current FIFO/RR task, which have more or
less the same features. Actually, the scheduling overhead is even
smaller than in rt tasks since we are still able to enforce bandwidth
without the need of hierarchical scheduling and accounting...

The added feature of being able to asking the scheduler that you don't
want you're task response time, latency and ability to meet its deadline
to be affected by some other task which is running away comes with no
price in therms of response time.

By the way, what numbers do you miss here? Just ask and I'll do my best
to provide them to you...

> Yes, the target was industrial control systems where we needed
> deterministic real-time response and also the responsiveness of the
> task was critical. Here, the demanding real-time tasks were not too
> many (~4/5 at a given point in time) and also, there were other user
> tasks which had to update the results of this real-time task remotely.
> Hence, we were very vary of introducing latencies in the system.
> Instead, we focused on bringing in determinism into the system without
> increasing its latency!=20
>
Hey, 'the system' already has a scheduling policy called SCHED_FIFO
which already have _a_lot_ of determinism... and EDF is **not** more
deterministic than fix-priority! There are people that like more EDF
than FP, there are people that like more FP than EDF, they both have
advantages and drawbacks, but implementing EDF can't be claimed as
'bringing determinism'...

So, now I'm curious :-D.

You say you need EDF in that application scenario, which might be more
than true, but the reason can't be 'lack of determinism' since FP
scheduling is as much deterministic as you want/are able to configure it
using the correct priorities... So what was your problem with it?

> Also, the concept of a deadline miss handler
> was very handy, for a task missing its deadline not to interfere with
> the determinism of the other tasks.=20
>
Oh, ok. But I think we can agree that you can have a task that, as said
above, not miss its own deadline --and thus you don't catch it-- but
makes all the other tasks in the system to miss their own ones!

How your definition of determinism applies on this situation? :-O

> > Mmm... I'm not sure I see why and how your patch should affect context
> > switches duration... However, do you have the testcases for such tests?
> >
>=20
> Well we are actually saying that it does _not_ effect the context
> switch time :).
>
Which was expectable...

> We are measuring the time when a task is entered in the system till it
> gets scheduled both in preemptive and non-preemptive modes. This
> figure does not change even for a loaded system which shows the
> deterministic turn around time for a task in terms of scheduling
> latencies.
>=20
... Ok, it seems I need to be more explicit here: do you have the code
of the tests, so that someone else can reproduce them?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-y+dWh4+ZGBJ0nI4mUmb+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrocEsACgkQk4XaBE3IOsSOKwCeJFLLdNqtXemYBPuCbnRQZiw/
LpQAn1xQfnsvwb8K94eJEKB1/kMcn4qk
=y1I+
-----END PGP SIGNATURE-----

--=-y+dWh4+ZGBJ0nI4mUmb+--


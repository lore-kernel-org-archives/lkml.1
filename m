Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbZIWNAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbZIWNAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZIWNAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:00:22 -0400
Received: from ms01.sssup.it ([193.205.80.99]:48598 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751238AbZIWNAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:00:21 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <63386a3d0909221355o45cccdf2j707a5cb4cf36754b@mail.gmail.com>
References: <1253615424.20345.76.camel@Palantir>
	 <63386a3d0909221355o45cccdf2j707a5cb4cf36754b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uBH4+aTNJBURdWZ6bRGO"
Date: Wed, 23 Sep 2009 15:00:19 +0200
Message-Id: <1253710819.5631.432.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uBH4+aTNJBURdWZ6bRGO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 22:55 +0200, Linus Walleij wrote:
> Hi Raistlin,
>=20
Hi,

> it's great fun to see this scheduler materialize, I was present at the
> workshop in Kaiserslautern and waited for the code since.=20
Sorry it took long... Well, it is taking, actually, since it is not
finished! :D
Anyway, it's a pleasure to entertain you, at least I am now sure that
all this developing has not been completely pointless! :D :D

> What I'm
> interested in getting a briefing on right now is what practical use EDF
> schedulers have, since I think this is what many people will ask for.
>
100% agree with you. I think you directly hit one of the central points.

> I think actually the answers are the same as when I asked at Meld
> (of all places) what HRtimers are actually for. And I I got the non-all
> inclusive answer that they're for Flight simulators.
> Which is obviously in the domain of automatic control.
> http://en.wikipedia.org/wiki/Automatic_control
>=20
Wow, flight simulator are funny... They surely worth tglx and others
hrtimers efforts! :-)

> So one application of HRTimers has been to trigger events in
> userspace programs, especially when your dealing with issues
> related to automatic control. Automatic control is also
> mentioned throughout this patch.
>=20
Ok, turning back being serious, you are right about automatic control.
In fact, control applications are both a source of great inspiration for
new research in real-time systems, and probably the "field" where the
outcomes of that research might be exploited with best results.

This is, in my opinion, because in control applications interaction with
the external environment is the key part of the whole thing... And
external environment has its own timing that you usually can't change.
In fact, real-time is not about speed, timers precision, wakeup
latencies, etc. it is about predictability, and you usually need that
your robotic arm that can cut off some people's head if misbehaving to
be predictable! :O

However, a kernel with a predictable scheduler but with high latencies
and poor resolution timing event delivering may be enough, if your
environment runs at a proper, let's say, small rate, which is usually
not the case... And you can't wakeup your PID controller task at 1ms
rate if your OS timers have 4ms resolution, do you? :P

Thus, I think lowering kernel latencies, reducing the kernel
interference with sensible application to the bare minimum (e.g., the
interrupt threading, and so on) _and_ introducing deterministic and
predictable scheduling policies are distinct things, but both contribute
to the enhancement of Linux real-time behaviour, and on the
opportunities of using Linux in real-time environments, like automatic
control.

> I am very interested in if you or someone else
> could elaborate on the relation between HRtimers and deadline
> scheduling. To my untrained mind it looks like HRtimers will
> fire events to your task in a very precise manner, but
> you cannot currently guarantee that they will then proceed to
> process their target task in time (meet a deadline).
>=20
Ok, I think I just said something about this above, however, what you
say seems correct to me.
Trying to explain my view on this better (sorry if repeating myself) I
can say that, in principle, there is *NO* relation between hrtimers (or
interrupt threading, or low latencies, etc.) and deadline scheduling.

A periodic task in a real time systems has to wake-up at certain point
in time, say t, and complete its execution by another time instant, say
t+d, when it then goes to sleep until t+T.

So, waking up the task at t and t+T, or, e.g., notifying it missed its
deadline at t+d, is responsibility of the timers, and it is much more
better if their resolution is appropriate, with respect to the timing
constants we are talking about (I would say resolution << d <=3D T).
After the task is awake --especially if more than one task is awake at a
given point in time! :D-- scheduling it in a way it can complete by t+d
it is mostly up to the scheduler.

Let me add that, in order, of doing this, a fixed priority scheduler
(just like the POSIX one already in place in Linux for years) may be
more than suitable, and there may be no need for deadline scheduling at
all! There are tons of research papers about properties of fixed
priority scheduler real-time systems, and all the RTOS I'm aware of use
variation on this policy, while none of them has EDF, or similar,
implemented!
Nevertheless, whether your needs are satisfied by a fixed or dynamic
(e.g., EDF) priority scheduler, you may find useful precise task event
triggering. :-)

This is the non-relation I see between the two things. It seems to me
very similar to what you wrote, but I tried to elaborate as much as I
can, as you asked... Sorry for being so long and, probably, so
boring! :-(

> I'm under the impression that some people currently use
> some periodic HRtimers (through either the timerfd_create system
> call I guess, or POSIX timer_create(CLOCK_REALTIME_HR...)
> timers combined with some SHED_FIFO or so to achieve the same
> thing a deadline scheduler would do, but since SCHED_FIFO cannot
> really guarantee that this will work, you simply underutilize
> the system a bit, add the CONFIG_PREEMPT_RT patch so the
> timers are not blocked by things like slow interrupthandlers or
> starvation (priority inversion) and then hope for the best. It turns
> out to work. You measure on the system and it has the desired
> "hard realtime" characteristics.
>
Ok, I think you are describing two (possible?) different behaviours,
which deserves different treatment.

If one applies preempt-rt, setschedulers some task to FIFO, crosses his
fingers and sees if all works, well, this is what I might consider the
best sin one can perpetrate... But the world is so beautiful because
there exists a lot of different opinions! :D :D

On the contrary, as written above, high resolution timers, low latency
kernel and fixed priority scheduler (which _is_ predictable and
deterministic, maybe even more, if possible, than deadline one!) can be
used for successfully building up an hard real-time system, working like
a swiss clock, with strong guarantees and no needs for "hoping for the
best".

Since I think you are talking about the first approach, well, there are
a lot of applications that might be designed as a real-time application,
be given a period and a deadline and then scheduled according to
(something similar to) real-time scheduling theory, either with fixed or
deadline schedulers. Just think to a video/media player, and I think you
will realize that's the perfect example!
However, they are not designed as such and they nevertheless work more
than well. Thus, I don't think we (we =3D real-time academic people...
strange guys :P) can say that our solution (EDF scheduling in this case)
is the only correct and the best ever... I mean, of course we think like
that, but I would never say it here! :D :D

What I hope is that, deadline scheduling, given its high efficiency
(scheduling, not implementation) and flexibility, would be appealing
enough to be considered by people interested in real-time and control
applications, but also from some other guys... And that this make it
worth to have it in the kernel at some time! :-)

> Do people do such things? I haven't seen those applications,
> they all tend to be closed-source really.
>
Yeah, that's the big deal here, actually. :-(

> I would assume the
> vxWorks/pSOS/etc compatibility wrapper libraries do things
> like this, do they not?
>
Not sure of what you are thinking about here... Is it things like
Xenomai(/solo) skins?

> Now since that example up there included the RTOS replacement
> case, that means the list of possible applications utilizing these very
> responsive control systems would be the same as any good old
> so-called RTOS and include user-space applications for:
>=20
> * Any interactive simulations and games
(here you touched my heart... I do love games! :P)
> * Industrial automation including robotics
> * Process industry applications (e.g. chemical processing, power
>   plants, paper/car/textile/etc manufacturing)
> * Various weapons including missiles
> * Medical equipment
> * The above will sooner or later include a dataflow which
>   need some processing on it which leads to thinking of
>   data (token) flows leading up to:
> * Massive parallelization of FunnyStuff like the models found
>   in OpenDF (also part of the ACTORS project):
>   http://opendf.svn.sourceforge.net/viewvc/opendf/trunk/models/
>   here (correct me if I'm wrong) the deadline scheduling
>   will be used to construct timewise predictable flows in massively
>   parallel threadpools distributed over several processing nodes etc.
>   Illustrations include MPEG4 decoding, FIR, FFT so let's
>   say real-time constrained signal processing on some
>   time-critical dataflow.
>   (Don't know the deadline-critical parts of the Mandelbrot
>   set or the Game of Life though, hehe.)
Oh, sorry, but I'm light year far from correcting you on these issues...
Since I'm sure there are other people in the project with light years
better confidence than me with these issues! :-P

> This sounds a lot like a nail in the coffin for the RTOS and all
> its virtualized variants (running Linux inside an RTOS etc).
>=20
Well, I mostly agree. However, I think you mentioned in your list some
application that we can call "hard" real-time activities, some that we
can call "soft".
I hope all these efforts, maybe including EDF/Deadline scheduling, may
get Linux closer to correct and efficient handling of at least soft
(games, simulations, multimedia, etc) workloads.

If it will be able to completely replace all the existing RTOS I don't
know... Let's hope that!
Actually, it could be one of the (if not _the_) first supporting EDF,
which may represent a nice plus toward them. :-)

> (Please excuse my bastardized condensed-form popular science
> version of the noble goals of the ACTORS project, I only observed
> it at a distance so my vision was dimmed.)
>=20
Hey, no problem, as already said, the existence of so much different
opinions is a _good_ thing to me! :-D

Thanks a lot for the very interesting comments!

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-uBH4+aTNJBURdWZ6bRGO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq6G9sACgkQk4XaBE3IOsSffACffAlQFq/1v+l3CiUWr2mui1go
7H4AnRRCNE1SzDmVnfdJ2wZarb6EsZS2
=PI8A
-----END PGP SIGNATURE-----

--=-uBH4+aTNJBURdWZ6bRGO--


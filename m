Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZIVMvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZIVMvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZIVMvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:51:08 -0400
Received: from ms01.sssup.it ([193.205.80.99]:38523 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756146AbZIVMvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:51:06 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1253617510.7695.23.camel@twins>
References: <1253615424.20345.76.camel@Palantir>
	 <1253617510.7695.23.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0+swFyFSUMNDB24o4dTz"
Date: Tue, 22 Sep 2009 14:51:07 +0200
Message-Id: <1253623867.20345.156.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0+swFyFSUMNDB24o4dTz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi again

and first of all, thanks a lot for the quick reply!

On Tue, 2009-09-22 at 13:05 +0200, Peter Zijlstra wrote:
> >  * It does not make any restrictive assumption about the characteristic=
s
> >    of the tasks: it can handle periodic, sporadic or aperiodic tasks
> >    (see below)
>=20
> sched_param_ex seems to only contain two of the three sporadic task
> model parameters ;-)
>=20
Yes, that is true. Fact is that, inside the kernel, we deal only with
the runtime and a period, which is also equal to the (relative!)
deadline.
In fact, the (absolute) deadline of a task is set by adding _that_
period to the old deadline value, or to current time.

The, let's say, proper task period is left to the userspace, i.e.,
suspending until the next period/sporadic activation is not done in the
kernel, it is up to the task.
This is the most flexible interface we have been able to design, while
trying to reduce the amount of information that has to be added to the
minimum... Different ideas are more than welcome. :-)

> >  * We decided to put the new scheduling class in between sched_rt and
> >    sched_fair, for the following reasons:
>=20
> I'd argue to put it above rt, since having it below renders any
> guarantees void, since you have no idea about how much time is actually
> available.
>=20
Well, I think it might be possible, if rt is bandwidth constrained, as
it is/it is becoming... Don't you?

> >    - Backward compatibility and (POSIX) standard compliance require
> >      SCHED_FIFO/SCHED_RR tasks to run as soon as they can
>=20
> In short, sod POSIX.
>=20
> Simply define 'as soon as they can' to exclude EDF time ;-)
>=20
Well, I definitely am not going to fight to death for POSIX
compliance! :-P

It's just that we've heard a lot of times sentences like "not break well
known/standard behaviours, especially if exported to userspace" and we
have not been brave enough to contradict this. :D

Apart from that, I truly think that --again, if rt is bandwidth
constrained-- having fixed priority above EDF may lead to a solution
able to provide both, the predictability of the former, and the
flexibility of the latter, as said below (original mail).
Anyway, this is not going to be an issue, since moving edf forward is
quite easy.

Damn! I would like to find some time to design and run a couple of
examples and experiments on both configurations, and see what it comes
out... If I ever do, I'll let you know.

> >    - Since EDF is more efficient than fixed-priority in terms of
> >      schedulability, it will be easier for it to achieve high
> >      utilization even if it runs in the idle time of fixed-priority,
> >      than vice-versa
> >=20
> >    - Real-time analysis techniques already exist to deal with exactly
> >      such scheduling architecture
> >=20
> >    - The amount of interference coming from system SCHED_FIFO/SCHED_RR
> >      tasks can be accounted as system overhead
> >=20
> >    - In recent kernels, the bandwidth used by the whole sched_rt
> >      scheduling class can be forced to stay below a certain threshold
>=20
> The only two tasks that need to be the absolute highest priority are
> kstopmachine and migrate, so those would need to be lifted above EDF,
> the rest is not important :-)
>=20
Ok, I think this could be done easily... Maybe also making them EDF with
very small deadline, but then we would have to think about a reasonable
budget... Or, obviously, we can simply use something like a "system"
scheduling class.

But now, isn't this bringing will bring some unknown amount of
interference which may disable again the guarantees for edf? Do you
think this could be the case?

> >  * We will migrate the tasks among the runqueues trying to always have,
> >    on a system with m CPUs, the m earliest deadline ready tasks running
> >    on the CPUs.
> >    This is not present in the attached patch, but will be available
> >    soon.
>=20
> Ah, ok, so now its fully paritioned, but you'll add that push-pull logic
> to make it 'global-ish'.
>=20
Yes, consistently with Linux "distributed runqueue" scheduling approach.
For now, I'm just "porting" the push/pull rt logic to deadlines, inside
sched-edf.
This may be suboptimal and rise at least overhead, clock synchronization
and locking issue, but I hope, again, it could be a start... A (bad?)
solution to compare against, when designing better implementations, at
least.

> That should be done at the root_domain level, so that cpusets still work
> as expected.
>=20
Yeah, sure. Consider that this should be easy since, for this first
version, I'm just recycling almost 100% of the sched-rt approach (and
some code too!).

> >    int sched_setscheduler_ex (pid_t pid, int policy, struct sched_param=
_ex *param);
> >  =20
> >    for the sake of consistency, also sched_setaparam_ex() and
> >    sched_getparam_ex() have been implemented.
>=20
> There should also be a sys_sched_getscheduler_ex(), the get part of the
> existing interface is what stops us from extending the sched_param bits
> we have.
Right, I have getparam, I can easily add getscheduler. :-)

> >  * We did not add any further system call to allow periodic tasks to
> >    specify the end of the current instance, and the semantics of the
> >    existing sched_yield() system call has been extended for this
> >    purpose.
>=20
> OK, so a wakeup after a yield, before a period elapses also raises some
> warning/exception/signal thing?
>=20
I thought about that, and I finally concluded that this should be not
needed. In fact, when a task "arrives" with a new instance (which is
what happen if it yield-suspend-resume), its deadline is set to:

 max(clock, old_deadline) + period

Thus, even if a task slept few than expected, it makes no benefit out of
it, since the deadline advances --at best-- from the old value, and it
is not preempting other tasks, if any, with earlier deadline.

Do you agree?

The rationale behind this is, again, we tried to avoid as much as we
can, was to introduce some need of the kernel to be aware of the task
sleeping/resuming behaviour, since this was judged to be too much
restrictive.

Another thing I would like to have, is a task receiving a SIGXCPU if it
misses its deadline, which might happen actually, e.g., if you load an
UP system/a CPU more than 100% with EDF tasks.

> >  * In case a SCHED_EDF tasks forks, parent's budget is split among
> >    parent and child.
>=20
> Right, I guess there's really nothing else you can do here...
>=20
Well, me too... But during tests I run into a poor EDF shell that, after
each `ls' or `cat', lost half of its bandwidth up to be no longer
capable of running at all! :(

We may avoid this having the son giving back its bandwidth to the father
when dieing (what a sad story! :( ) but this would need distinguishing
between fork-ed and setschedul-ed EDF tasks. Moreover, e.g., what if the
son changed its EDF bandwidth in the meanwhile? Or worse if it changed
its scheduling policy?

At the current time, I'm just splitting the bandwidth, and nothing more.
Actually, I also think the solution is the right one, but I would really
like to discuss the issues it raises.

> Haven't looked at the code yet,. hope to do so shortly.
>=20
No problem... I also hope to update it shortly! ;-)

Thanks again,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-0+swFyFSUMNDB24o4dTz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq4yB8ACgkQk4XaBE3IOsQoWwCfcbbSAY2AORB5PsMVSzsCWFEl
UGYAn1kDJsod6CaeSR22mPC+cXGrkOKA
=jrPf
-----END PGP SIGNATURE-----

--=-0+swFyFSUMNDB24o4dTz--


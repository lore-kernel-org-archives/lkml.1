Return-Path: <linux-kernel-owner+w=401wt.eu-S934162AbZGQHcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162AbZGQHcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 03:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934178AbZGQHci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 03:32:38 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:35826 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170AbZGQHcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 03:32:36 -0400
From: Henrik Austad <henrik@austad.us>
To: Ted Baker <baker@cs.fsu.edu>
Date: Fri, 17 Jul 2009 09:31:54 +0200
User-Agent: KMail/1.9.10
Cc: Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
References: <200907102350.47124.henrik@austad.us> <200907160917.10098.henrik@austad.us> <20090716231323.GE27757@cs.fsu.edu>
In-Reply-To: <20090716231323.GE27757@cs.fsu.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3778488.6QWf1GZS0Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907170931.59932.henrik@austad.us>
X-SA-Exim-Connect-IP: 2001:700:1:21:21d:e0ff:fe55:5a61
X-SA-Exim-Mail-From: henrik@austad.us
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on asterix.frsk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3778488.6QWf1GZS0Z
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 17 July 2009 01:13:23 Ted Baker wrote:
> On Thu, Jul 16, 2009 at 09:17:09AM +0200, Henrik Austad wrote:
> > My understanding of PEP is that when B executes through the
> > A-proxy, B will consume parts of A's resources until the lock is
> > freed. This makes sense when A and B runs on different CPUs and
> > B is moved (temporarily) to CPU#A. If B were to use it's own
> > budget when running here, once A resumes execution and exhaustes
> > its entire budget, you can have over-utilization on that CPU
> > (and under-util on CPU#B).
>
> To be sure we are using A and B the same way here:
>   B is holding a lock.
>   A wants that lock.
>   A grants its priority B until B releases the lock.

I tried to be consistent, and I still can't see where I messed up, but this=
 is=20
what I meant.

With the mixed-in CPU-notation: I got the feeling that partitioned scheduli=
ng=20
was the preferred (or easiest to analyze), so I assumed that we had shifted=
=20
from my initial global motivation to a more mature partitioned view :-)

By CPU#A I menat the CPU where A is currently scheduled (in a partitioned=20
setup).

> How to look at the charges for usage seems not to have a perfect
> solution.  That is, you can't get around the fact that either:
>
> (1) B is using some its time at the wrong priority (priority inversion)
>
> or
>
> (2) B is using some of A's time to do B's work (the right
> priority, but the wrong task)
>
> The right way to resolve this conflict seems to depend a lot on
> where B runs, as well as whether you are managing budget per-CPU
> (partitioned model) or managing it globally (free migration
> model).

Yes. This has been one of my point all the way, but I realize I've been rat=
her=20
bad at actually showing that point.

> 1) In a global scheduling model, it does not matter where B runs.
> We want to charge B's critical section to B, since our
> schedulability analysis is based on the processor usage of each
> task.  It would be broken if A could be charged random bits of
> time for the execution of other tasks.  So, we must charge B.

Yes, I agree completely.

> 2) In a partitioned scheuling model, we worry about the
> CPU utilization of each processor.  We have several cases, depending
> where B runs when it runs with A's priority:
>
> 2.1) If B gets to run on A's processor, we have a problem
> with processor overload unless we charge the usage to A.  This
> is still a bad thing, though, since we then need to over-provision
> A to allow for this.
>
> 2.2) If B runs on its own processor, we want to use B's budget.
>
> 2.3) A third variatin is that all the critical sections for A and
> B run on a separate synchronization procesor.  In that case, the
> synchronization processor needs its own budget, and in effect we
> the critical sections of tasks A and B become aperiodic tasks in
> their own right.

An interesting solution. However, this means that the kernel need to analyz=
e=20
all tasks before they can run as it not only need to keep track of total "r=
aw=20
utilization" (the computational time required), but also on how much time=20
spent while holding locks. Throw inn a few conditional statements, and=20
finding this becomes somewhat of a challenge.

> > AFAIK, there are no such things as preemption-overhead charging
> > to a task's budget in the kernel today. This time simply
> > vanishes and must be compensated for when running a task through
> > the acceptance-stage (say, only 95% util pr CPU or some such).
>
> I don't see that anything can or does "vanish".  Consider this
> sequence of events on one processor:
>
> 1. task A is running, and calls scheduler (synchronously or maybe
> via IRQ, say from timer)
>
> 2. scheduler computes how much time A has used recently, and charges
> it to A's budget
>
> The overhead of the IRQ handler and scheduler are therefore
> charged to A.
>
> 3. scheduler switches to B
>
> 4. B calls scheduler
>
> 6. scheduler computes how much time B has used recently,
> and charges it to B's budget
>
> The rest of the overhead of the context switch from A to B, including cac=
he
> misses and page faults immediately following 3 are now
> effectively charged to B.

Good point, it has to be this way. I see a lot of code in kernel/sched_stat=
s.h=20
that I should have been aware of. My apologies.

> > > Back to the original question, of who should be charged for
> > > the actual critical section.
> >
> > That depends on where you want to run the tasks. If you want to
> > migrate B to CPU#A, A should be charged. If you run B on CPU#B,
> > then B should be charged (for the exact same reasoning A should
> > be charged in the first case).
>
> As I mentioned above, it also depends on whether you are using
> a partitioned or global scheduling policy for your analysis.

Yes. I guess we should split the thread in 2, or shift the topic as we are=
=20
discussing locking and how to resolve these.

> > The beauty of PEP, is that enabling B to run is very easy. In
> > the case where B runs on CPU#B, B must be updated statically so
> > that the scheduler will trigger on the new priority. In PEP,
> > this is done automatically when A is picked. One solution to
> > this, would be to migrate A to CPU#B and insert A into the
> > runqueue there. However, then you add more overhead by moving
> > the task around instead of just 'borrowing' the task_struct.
> >
> > > From the schedulability analysis point of view, B is getting
> > > higher priority time than it normally would be allowed to execute,
> > > potentially causing priority inversion (a.k.a. "interference" or
> > > "blocking") to a higher priority task D (which does not even share
> > > a need for the lock that B is holding) that would otherwise run on
> > > the same processor as B.  Without priority inheritance this kind
> > > of interferfence would not happen.  So, we are benefiting A at the
> > > expense of D. In the analysis, we can either allow for all such
> > > interference in a "blocking term" in the analysis for D, or we
> > > might call it "preemption" in the analysis of D and charge it to A
> > > (if A has higher priority than D).  Is the latter any better?
> >
> > If D has higher priority than A, then neither A nor B (with the
> > locks held) should be allowed to run before D.
>
> Yes, but I only meant D has higher priority than B.  A may have
> higher priority than D, but with multiple processors we can't just
> focus on the one highest priority task.  We need to look at the
> (number of CPUs) highest priority tasks, or we will may end
> up with our system behaving as if we have only one processor.

Yes, well, that will always be a problem. but on the other hand, B *has*=20
higher priority than D, since B is blocking A, and A has higher priority th=
an=20
D.

This becomes, as you say, messy in a partitioned system as a priority does =
not=20
mean *anything* outside a CPU. The same goes for a deadline as you must see=
=20
the deadline wrt to the other tasks in the same domain (I specifically choo=
se=20
domain here as we can apply that to all types, partitioned, clustered and=20
global).

This is what makes me believe that a global algorithm will make several of=
=20
these problems smaller, or even vanish completely, even if you have problem=
s=20
with caches going cold, high memory-bus traffic at frequent task preemption=
,=20
strong lock-contention on the rq-locks etc. These are all implementation=20
problems, not small problems, but they can be avoided and mended. A=20
partitioned scheduler is a bit like a broken hammer, you cannot really expe=
ct=20
to build a nice house with it :)

> This is a key difference with multiprocessor scheduling,
> and also with processor "share" scheduilng.

Yes, you can get into quite a mess if you're not careful.

> Expediting the highest priority task is *not* always the
> best strategy.  Assuming that each task has some amount of slack,
> there is no great benefit for completing a high-priority task
> early, if that means causing other tasks to miss their deadlines.

which was the whole point of the initial email, to present EFF (or M^2LLF, =
or=20
whatever is the most appropriate name for it) and get some feedback :-)

> That is, if by delaying the highest-priority task a little bit
> on one processor you can keep more processors busy,
> you may be able to successfully schedule a set of tasks that
> could not be scheduled to meet deadlines otherwise.
>
> (I can give you an example of how this happens if you want, but it
> would tedious if you can get my point without the example.)

No, no, I think I understand what you're getting at. Dhall's effect would b=
e=20
one such.

> > Yes, no task should be allowed to run more than the budget, but
> > that requires B to execute *only* on CPU#B.
>
> As mentioned above, that depends on whether you are
> applying a global or partitioned model.  With a global
> scheduling model the budget is not per-CPU.
>
> > On the other hand, one could say that if you run PEP and B is
> > executed on CPU#A, and A then exhausts its budget, you could
> > blame A as well, as lock-contention is a common problem and it's
> > not only the kernel's fault. Do we need perfect or best-effort
> > lock-resolving?
>
> Yes. For application locks, with application-managed partitioned
> scheduling, you can blame the application designer for building
> in cross-CPU contention.
>
> For kernel (hidden from the application) locks, it is a harder
> problem.

Which locks would that be? If a syscall results in lock-contention, shouldn=
't=20
the app be aware of those locks?

> I don't think there is a perfect solution for the partitioned
> scheduling model.

I know! :-)

> As mentioned above, you get to choose between B=20
> causing short-term priority inversion for other tasks on B's
> processor (but not using more than its budget on the average), or
> B causing budget over-run for A on A's processor.
>
> Ted


=2D-=20
     henrik

--nextPart3778488.6QWf1GZS0Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBKYCjv6k5VT6v45lkRAmmTAKCN1JaKnfrFIzaIL8+hN4ahAmfzJgCeL6wk
babmIH6GDCFpn+2HKM/QMsU=
=IjTo
-----END PGP SIGNATURE-----

--nextPart3778488.6QWf1GZS0Z--

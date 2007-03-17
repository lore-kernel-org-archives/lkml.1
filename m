Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbXCQMUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbXCQMUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933821AbXCQMUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:20:34 -0400
Received: from psmtp09.wxs.nl ([195.121.247.23]:43392 "EHLO psmtp09.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294AbXCQMUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:20:32 -0400
Date: Sat, 17 Mar 2007 13:23:43 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: is RSDL an "unfair" scheduler too?
In-reply-to: <200703172302.10819.kernel@kolivas.org>
To: ck@vds.kolivas.org
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200703171323.44517.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1614948.ICJe29H9Hh
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <20070317114903.GA20673@elte.hu> <200703172302.10819.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1614948.ICJe29H9Hh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Saturday 17 March 2007, schreef Con Kolivas:
> On Saturday 17 March 2007 22:49, Ingo Molnar wrote:
> > * Con Kolivas <kernel@kolivas.org> wrote:
> > > Despite the claims to the contrary, RSDL does not have _less_
> > > heuristics, it does not have _any_. It's purely entitlement based.
> >
> > RSDL still has heuristics very much, but this time it's hardcoded into
> > the design! Let me demonstrate this via a simple experiment.
> >
> > in the vanilla scheduler, the heuristics are ontop of a fairly basic
> > (and fast) scheduler, they are plain visible and thus 'optional'. In
> > RSDL, the heuristics are still present but more hidden and more
> > engrained into the design.
> >
> > But it's easy to demonstrate this under RSDL: consider the following two
> > scenarios, which implement precisely the same fundamental computing
> > workload (everything running on the same, default nice 0 level):
> >
> > 1) a single task runs almost all the time and sleeps about 1 msec every
> >    100 msecs.
> >
> >    [ run "while N=3D1; do N=3D1; done &" under bash to create such a
> >      workload. ]
> >
> > 2) tasks are in a 'ring' where each runs for 100 msec, sleeps for 1
> >    msec and passes the 'token' around to the next task in the ring. (in
> >    essence every task will sleep 9900 msecs before getting another run)
> >
> >    [ run http://redhat.com/~mingo/scheduler-patches/ring-test.c to
> >      create this workload. If the 100 tasks default is too much for you
> >      then you can run "./ring-test 10" - that will show similar effects.
> >    ]
> >
> > Workload #1 uses 100% of CPU time. Workload #2 uses 99% of CPU time.
> > They both do in essence the same thing.
> >
> > if RSDL had no heuristics at all then if i mixed #1 with #2, both
> > workloads would get roughly 50%/50% of the CPU, right? (as happens if i
> > mix #1 with #1 - both CPU-intense workloads get half of the CPU)
> >
> > in reality, in the 'ring workload' case, RSDL will only give about _5%_
> > of CPU time to the #1 CPU-intense task, and will give 95% of CPU time to
> > the #2 'ring' of tasks. So the distribution of timeslices is
> > significantly unfair!
> >
> > Why? Because RSDL still has heuristics, just elsewhere and more hidden:
> > in the "straightforward CPU intense task" case RSDL will 'penalize' the
> > task by depleting its quota for running nearly all the time, in the
> > "ring of tasks" case the 100 tasks will each run near their priority
> > maximum, fed by 'major epoch' events of RSDL, thus they get 'rewarded'
> > for seemingly sleeping alot and spreading things out. So RSDL has
> > fundamental unfairness built in as well - it's just different from the
> > vanilla scheduler.
>
> We're obviously disagreeing on what heuristics are so call it what you
> like.
>
> You're simply cashing in on the deep pipes that do kernel work for other
> tasks. You know very well that I dropped the TASK_NONINTERACTIVE flag from
> rsdl which checks that tasks are waiting on pipes and you're exploiting i=
t.
> That's not the RSDL heuristics at work at all, but you're trying to make =
it
> look like it is the intrinsic RSDL system at work. Putting that flag back
> in is simple enough when I'm not drugged. You could have simply pointed
> that out instead of trying to make my code look responsible.
>
> For the moment I'll assume you're not simply trying to make my code look
> bad and that you thought there really was an intrinsic design problem,
> otherwise I'd really be unhappy with what was happening to me.

Well, re-reading his post, he has a point - one WOULD expect each of these =
2=20
tasks to have an equal share of CPU, and if RSDL doesn't currently take thi=
s=20
pipe-thing into account, it might need some fixing. call it heuristics or n=
ot=20
(after all, how could one NOT say a scheduler uses heuristics of some kind?=
).

Anyway, relax (you know getting angry won't help you getting better) and=20
remember this is email - not exactly a perfet way to communicate, esp in th=
e=20
emotional area. I haven't said this anywhere else, as I'm waiting for RSDL =
to=20
be a bit more mature, but I have irritations with it as well - I don't have=
=20
the long full-system stalls I had with staircase (hail RSDL!) but I do have=
=20
more frequent, shorter stalls, when one app doesn't respond for up to 10=20
seconds, while others just continue to work. So it's not perfect yet, and=20
when I have time, I'll try to find out what's wrong. BTW, nice seems to hel=
p,=20
but not entirely.

grtz

Jos


--nextPart1614948.ICJe29H9Hh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF+93Q+wgQ1AD35iwRAgeMAKDDdIe9qLvSDUmDSqZCHWmD6k7tuwCcDbMU
mH2aFNHfBi54QXnsZReq638=
=MkEf
-----END PGP SIGNATURE-----

--nextPart1614948.ICJe29H9Hh--

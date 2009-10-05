Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbZJEIqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbZJEIqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbZJEIq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:46:28 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:39436 "EHLO lvk.cs.msu.su"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655AbZJEIq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:46:28 -0400
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: linux-rt-users@vger.kernel.org
Subject: Please advice on realtime application architecture
Date: Mon, 5 Oct 2009 12:45:30 +0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Stas Bezzubtsev <stas@lvk.cs.msu.su>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1349833.A9MRYJKk20";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200910051245.37688@blacky.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1349833.A9MRYJKk20
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

I'm currently trying to port a realtime application from an in-house RT=20
kernel to something standard, preferrably preempt-rt linux.

Application controls a set of i/o cards with some data computed in=20
realtime.
The cards are relatively slow:
=2D single word transmit with inl()/outl() or ioread32()/iowrite32() takes =
a=20
microsecond or more;
=2D setting up single i/o request requires up to several tens of these word=
=20
operations;
=2D large number of i/o operations has to be programmed on several devices =
in=20
parallel.
=2D in total, significant portion of raw CPU time (20% or more) is needed t=
o=20
execute raw hardware-control operations.

Application can generate a large number [hundreds] of i/o requests at a=20
lime, however later it could "change it's mind" and decide to change some=20
of those, or cancel the queue altogether.

Writing all generated i/o requests to hardware at a time is not feasible=20
since it will use enough CPU to make the main application miss it's=20
deadlines. Also, writing requests that will be later changed or cancelled=20
is a pure waste of CPU time.

So we once implemented "late/lazy hardware control".
There was a thread dedicated to hardware control, that:
=2D normally worked as an idle thread;
=2D but got highest priority in case of i/o operation not programmed yet wh=
en=20
hardware should execute it "soon".

That worked well in our previous environment where thread rescheduling was=
=20
very fast and lightweight.

And now we want to move to rt-preempt linux.

Here is bit more abstract model of the situation.
=2D there is a stream of "requests" that have to be executed on CPU;
=2D each request has a deadline, missing that deadline is absolutely=20
unacceptable;
=2D for each "request", approximate CPU time is more or less known; normall=
y=20
is is between 10 and 40 microseconds;
=2D number of requests is large, total execution of those consumes 20% of r=
aw=20
cpu time or even more;
=2D deadlines are distributed more or less uniform over the time;
=2D requests arre async, NOT periodic;
=2D in common case, request arrives long before deadline (99% of requests -=
=20
more than 500us, 70% of requests - more than 5 ms), but in some rare cases=
=20
time left between request arrive and deadline could be 100us or less=20
[although the lower margin could be probably increased by some changes at=20
highlevel];=20
=2D request may be cancelled by application; that may happen at any moment =
up=20
to the deadline;
=2D this request cancellation is a common case (say 30% of all requests get=
=20
cancelled)
=2D running cancelled request is no harm other than wasting CPU time;
=2D requests are preemptible by nature, however preempted request will have=
=20
to continue execution when resumed even if cancelled in meantime;=20
=2D monopolizong CPU for request execution for more than several tens of=20
microseconds should be avoided when possible.

This will likely run on x86-based industrial computers.
Dedication a cpu core to request processing does not look good: want to=20
make use of 80% of core's time not spent by to request processing; also=20
unsure that all installations of the system will have several cores.

A naive implementation may have a kernel thread running requests, with EDF=
=20
ordering; priority of the thread may be normally low, but raised to=20
SCHED_FIFO 99 from an hrtimer if deadlines become near, and lowered back=20
when no near deadlines.

However, there is a concern that if trying not to monopolize cpu too much,=
=20
hrtimer and reschedule overhead will become larger than actual request=20
execution time.

So I'm looking for some advice on how to implement the request processing.=
=20
Maybe there are some better ways than "naive implementation" described=20
above? What do you think?

Many thanks for any advice.

--nextPart1349833.A9MRYJKk20
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrJsisACgkQv3x5OskTLdt8ZwCfSS+TswLX9qYTnvKkj9wPxeKo
qJwAn0Oa25Gu9fKbxW/mzaZfBOLrZt3K
=ibvg
-----END PGP SIGNATURE-----

--nextPart1349833.A9MRYJKk20--

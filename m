Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZJCKrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZJCKrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZJCKrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:47:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51494 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbZJCKrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:47:31 -0400
Date: Sat, 3 Oct 2009 12:47:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: drago01 <drago01@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: sched regression introduced by NO_NEW_FAIR_SLEEPERS
Message-ID: <20091003104723.GC15919@elte.hu>
References: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com> <f6ca9fed0909271250h61e2ce94n31c9f23e835f802c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ca9fed0909271250h61e2ce94n31c9f23e835f802c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* drago01 <drago01@gmail.com> wrote:

> On Sun, Sep 27, 2009 at 9:47 PM, drago01 <drago01@gmail.com> wrote:
> > Hi,
> >
> > Chuck has backported some scheduler patches from 2.6.32 to the fedora kernel.
> >
> > I did the following test to test the new scheduler (cpu is a core i7
> > 920 4 cores + HT).
> >
> > run 8 "md5sum /dev/urandom" task and try to use the desktop (compiz).
> >
> > The result was that moving windows or rotating the cube is very slow.
> > (same happens with pure metacity but is is worse in compiz).
> >
> > Mounting debugfs and doing "echo NEW_FAIR_SLEEPERS > sched_features"
> > results into a useable desktop while the 8 md5sum tasks are running
> > (ie. the system behaves as if they where not running at all from an
> > interactivity pov).
> >
> >
> > P.S: please CC me when replying.
> >
> 
> With "NEW_FAIR_SLEEPERS" I can even run 100(!)  "md5sum" task without 
> any effect on interactivity. (still have not found a number of tasks 
> needed to make the system unresponsive as with 8 with 
> "NO_NEW_FAIR_SLEEPERS".

Can you try the latest -tip tree please:

  http://people.redhat.com/mingo/tip.git/README

There we default to FAIR_SLEEPERS + GENTLE_FAIR_SLEEPERS - which should 
give much of the new-fair-sleepers advantage.

There's also a new tool, 'perf sched', which you can install via:

  cd tools/perf/
  make -j install

And use like this to measure latencies in the system:

 $ perf sched record sleep 1
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.059 MB perf.data (~2563 samples) ]

 $ perf sched latency

 -----------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
 -----------------------------------------------------------------------------------------
  events/12:47          |      0.007 ms |        1 | avg:    0.054 ms | max:    0.054 ms |
  events/2:37           |      0.128 ms |        1 | avg:    0.016 ms | max:    0.016 ms |
  at-spi-registry:3292  |      0.752 ms |       20 | avg:    0.015 ms | max:    0.023 ms |
  Xorg:3161             |      0.519 ms |       20 | avg:    0.015 ms | max:    0.024 ms |
  perf:19070            |     21.241 ms |        5 | avg:    0.012 ms | max:    0.019 ms |
  events/1:36           |      0.009 ms |        1 | avg:    0.009 ms | max:    0.009 ms |
  hald-addon-stor:2790  |      0.204 ms |        9 | avg:    0.009 ms | max:    0.011 ms |
  scsi_eh_5:1072        |      0.200 ms |       12 | avg:    0.009 ms | max:    0.009 ms |
  events/0:35           |      0.007 ms |        1 | avg:    0.008 ms | max:    0.008 ms |
  ksoftirqd/12:28       |      0.088 ms |        5 | avg:    0.005 ms | max:    0.009 ms |
  sleep:19071           |      0.668 ms |        3 | avg:    0.005 ms | max:    0.008 ms |
  migration/13:29       |      0.000 ms |        1 | avg:    0.003 ms | max:    0.003 ms |
 -----------------------------------------------------------------------------------------
  TOTAL:                |     23.824 ms |       79 |
 ---------------------------------------------------

Thanks,

	Ingo

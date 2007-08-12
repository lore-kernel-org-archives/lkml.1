Return-Path: <linux-kernel-owner+w=401wt.eu-S936611AbXHLPaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936611AbXHLPaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759855AbXHLPaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:30:01 -0400
Received: from [212.12.190.217] ([212.12.190.217]:33110 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758380AbXHLPaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:30:00 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Sun, 12 Aug 2007 18:27:36 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <20070812041736.GA18291@elte.hu>
In-Reply-To: <20070812041736.GA18291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121827.36656.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > That's because granularity increases when decreasing nice, and results
> > in larger timeslices, which affects smoothness negatively.  chew.c
> > easily shows this problem with 2 background cpu-hogs at the same
> > nice-level.
> >
> > pid 908, prio   0, out for    8 ms, ran for    4 ms, load  37%
> > pid 908, prio   0, out for    8 ms, ran for    4 ms, load  37%
> > pid 908, prio   0, out for    8 ms, ran for    2 ms, load  26%
> > pid 908, prio   0, out for    8 ms, ran for    4 ms, load  38%
> > pid 908, prio   0, out for    2 ms, ran for    1 ms, load  47%
> >
> > pid 908, prio  -5, out for   23 ms, ran for    3 ms, load  14%
> > pid 908, prio  -5, out for   17 ms, ran for    9 ms, load  35%
>
> yeah. Incidentally, i refined this last week and those nice-level
> granularity changes went into the upstream scheduler code a few days
> ago:
>
>   commit 7cff8cf61cac15fa29a1ca802826d2bcbca66152
>   Author: Ingo Molnar <mingo@elte.hu>
>   Date:   Thu Aug 9 11:16:52 2007 +0200
>
>       sched: refine negative nice level granularity
>
>       refine the granularity of negative nice level tasks: let them
>       reschedule more often to offset the effect of them consuming
>       their wait_runtime proportionately slower. (This makes nice-0
>       task scheduling smoother in the presence of negatively
>       reniced tasks.)
>
>       Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> so could you please re-check chew jitter behavior with the latest
> kernel? (i've attached the standalone patch below, it will apply cleanly
> to rc2 too.)

That fixes it, but by reducing granularity ctx is up 4-fold.

Mind you, it does have an enormous effect on responsiveness, as negative nice 
with small granularity can't hijack the system any more.

> when testing this, you might also want to try chew-max:
>
>    http://redhat.com/~mingo/cfs-scheduler/tools/chew-max.c
>
> i added a few trivial enhancements to chew.c: it tracks the maximum
> latency, latency fluctuations (noise of scheduling) and allows it to be
> run for a fixed amount of time.

Looks great.  Thanks!

> NOTE: if you run chew from any indirect terminal (xterm, ssh, etc.) it's
> best to capture/report chew numbers like this:
>
>   ./chew-max 60 > chew.log
>
> otherwise the indirect scheduling activities of the chew printout will
> disturb the numbers.

Correct; that's why I always boot into /bin/sh to get a clean run.  But 
redirecting output to a file is also a good idea, provided that this file 
lives on something like tmpfs, otherwise you'll get flush out jitter.

> > It looks like the larger the granularity, the more unpredictable it
> > gets, which probably means that this unpredictability exists even at
> > smaller granularity but is only exposed with larger ones.
>
> this should only affect non-default nice levels. Note that 99.9%+ of all
> userspace Linux CPU time is spent on default nice level 0, and that is
> what controls the design. So the approach was always to first get nice-0
> right, and then to adjust the non-default nice level behavior too,
> carefully, without hurting nice-0 - to refine all the workloads where
> people (have to) use positive or negative nice levels. In any case,
> please keep re-testing this so that we can adjust it.

The thing is, this unpredictability seems to exist even at nice level 0, but 
the smaller granularity covers it all up.  It occasionally exhibits itself 
as hick-ups during transient heavy workload flux.  But it's not easily 
reproducible.


Thanks!

--
Al


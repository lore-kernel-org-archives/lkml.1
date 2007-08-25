Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbXHYRXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbXHYRXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 13:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXHYRXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 13:23:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42420 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbXHYRX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 13:23:28 -0400
Date: Sat, 25 Aug 2007 19:23:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull request] scheduler updates
Message-ID: <20070825172319.GA2080@elte.hu>
References: <20070824141215.GA24403@elte.hu> <alpine.LFD.0.999.0708241105410.25853@woody.linux-foundation.org> <20070824193758.GA6440@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824193758.GA6440@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> We'll see - people can still readily tweak these values under 
> CONFIG_SCHED_DEBUG=y and give us feedback, and if there's enough 
> demand for very-finegrained scheduling (throughput be damned), we 
> could introduce yet another config option or enable the runtime 
> tunable unconditionally. (Or maybe the best option is Peter Zijlstra's 
> adaptive granularity idea, that gives the best of both worlds.)

hm, glxgears smoothness regresses with the de-HZ-ification change: with 
an increasing background load the turning of the wheels quickly becomes 
visually ugly - with small ruckles instead of smooth rotation.

The reason for that is that the 20 msec granularity on my testbox (which 
is a dual-core box, so the default 10msec turns into 20msec) turns into 
40, 60, 80, 100 msec 'observed latency' for glxgears as load increases 
to 2x, 3x, 4x etc - and a 100 msec pause in rotation is easily 
perceivable to the human eye (and brain). Before that the delay curve 
with increasing load was 4msec/8msec/12msec etc.

Due to the removal of the HZ dependency we now have upset the 
granularity picture anyway, so i believe we should do the adaptive 
granularity thing right now. That will aim for a 40msec task-observable 
latency, in a load-independent manner. (!) (This is an approach we 
couldnt even dream of with the previous, fixed-timeslice scheduler.)

The code is simple (and it is all in the slowpath), it in essence boils 
down to this new code:

 +static long
 +sched_granularity(struct cfs_rq *cfs_rq)
 +{
 +       unsigned int gran = sysctl_sched_latency;
 +       unsigned int nr = cfs_rq->nr_running;
 +
 +       if (nr > 1) {
 +               gran = gran/nr - gran/nr/nr;
 +               gran = max(gran, sysctl_sched_granularity);
 +       }
 +
 +       return gran;
 +}
 
IMO it is a good compromise between long slicing and short slicing: 
there are two values, one is the "CPU-bound task latency the scheduler 
aims for", the second one is a minimum granularity (to not do too many 
context-switches).

Peter and me tested this all day with various workloads and extreme-load 
behavior has improved all over the place - while the server benchmarks 
(which want less preemption) are still fine too. The glxgear ruckles are 
all gone.

If you do not disagree with this (it's pretty late in the game with more 
than 1 month spent from the kernel cycle already), please pull the 
latest scheduler tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Find the shortlog further below. There are 3 commits in it: adaptive 
granularity, a subsequent cleanup, and a lockdep sysctl bug Peter 
noticed while hacking on this. (the bug was introduced with the initial 
CFS commits but nobody noticed because the lockdep sysctls are rarely 
used.)

The linecount increase is mostly due to the comments added to explain 
the "gran = lat/nr - lat/nr/nr" magic formula and due to the extra 
parameter.

Tested on 32-bit and 64-bit x86, and with a few make randconfig build 
tests too.

	Ingo

------------------>
Ingo Molnar (1):
      sched: cleanup, sched_granularity -> sched_min_granularity

Peter Zijlstra (2):
      sched: fix CONFIG_SCHED_DEBUG dependency of lockdep sysctls
      sched: adaptive scheduler granularity

 include/linux/sched.h |    3 +
 kernel/sched.c        |   16 ++++++----
 kernel/sched_fair.c   |   77 ++++++++++++++++++++++++++++++++++++++++++--------
 kernel/sysctl.c       |   33 ++++++++++++++-------
 4 files changed, 99 insertions(+), 30 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764677AbXHXTiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764677AbXHXTiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbXHXTh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:37:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbXHXTh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:37:59 -0400
Date: Fri, 24 Aug 2007 21:37:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull request] scheduler updates
Message-ID: <20070824193758.GA6440@elte.hu>
References: <20070824141215.GA24403@elte.hu> <alpine.LFD.0.999.0708241105410.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708241105410.25853@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 24 Aug 2007, Ingo Molnar wrote:
> > 
> > Then there's also a change/tweak that increases the default 
> > granularity: it's still well below human perception so should not be 
> > noticeable, but servers win a bit from less preemption of CPU-bound 
> > tasks. (this is also the first step towards eliminating HZ from the 
> > granularity default calculation.)
> 
> Your explanation makes NO sense.
> 
> It doesn't eliminate HZ at all. It's still there, and it's still 
> totally bogus.

fair enough, and i fixed that.

( i called the previous patch the "first step" because i was too chicken
  to pick a single granularity default :-/ )

for the current queue i went for settings close to that of HZ=250 - 
that's the most common HZ variant that was tested previously. That means 
10 msec on a 1-way box, 20 msec on a 2-way box, 30 msec on a 4-way box, 
etc. (up to a 100 msecs ceiling.)

> Please just *remove* that thing. It has no possible value! You claim 
> that the preemption granularity is in "ns", and that it defaults to "3 
> msec", but it does no such thing at all, even with your patch. It 
> does:
> 
> 	unsigned int sysctl_sched_granularity __read_mostly = 3000000000ULL/HZ;
> 
> which is just total and utter CRAP!

ok, i've removed that and all the other HZ hacks too. I've uploaded a 
new queue with that fixed (and all other patches unchanged):

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

booted it on a number of boxes (32-bit and 64-bit). The question will be 
desktop behavior. I typically run my test-desktops with HZ=100 to make 
sure that desktop workloads are fine with large granularity values and 
coarse timers too, so i'm reasonably positive about this default.

We'll see - people can still readily tweak these values under 
CONFIG_SCHED_DEBUG=y and give us feedback, and if there's enough demand 
for very-finegrained scheduling (throughput be damned), we could 
introduce yet another config option or enable the runtime tunable 
unconditionally. (Or maybe the best option is Peter Zijlstra's adaptive 
granularity idea, that gives the best of both worlds.)

	Ingo

------------------>
Bruce Ashfield (1):
      sched: CONFIG_SCHED_GROUP_FAIR=y fixlet

Dmitry Adamushko (1):
      sched: optimize task_tick_rt() a bit

Ingo Molnar (3):
      sched: remove HZ dependency from the granularity default
      sched: tidy up and simplify the bonus balance
      sched: fix startup penalty calculation

Peter Zijlstra (2):
      sched: simplify bonus calculation #1
      sched: simplify bonus calculation #2

Sven-Thorsten Dietrich (1):
      sched: simplify can_migrate_task()

 sched.c      |    8 +-------
 sched_fair.c |   35 +++++++++++++++++++----------------
 sched_rt.c   |   11 ++++++++---
 3 files changed, 28 insertions(+), 26 deletions(-)

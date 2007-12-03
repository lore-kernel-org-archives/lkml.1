Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbXLCLhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbXLCLhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXLCLhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:37:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbXLCLhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:37:38 -0500
Date: Mon, 3 Dec 2007 12:37:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203113716.GA8432@elte.hu>
References: <1196155985.25646.31.camel@ymzhang> <200712032115.43275.nickpiggin@yahoo.com.au> <20071203103326.GD30050@elte.hu> <200712032202.37975.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712032202.37975.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > given how poorly sched_yield() is/was defined the only "compatible" 
> > solution would be to go back to the old yield code.
> 
> While it is technically allowed to do anything with SCHED_OTHER class, 
> putting the thread to the back of the runnable tasks, or at least 
> having it give up _some_ priority (like the old scheduler) is less 
> surprising than having it do _nothing_.

wrong: it's not "nothing" that the new code does - run two yield-ing 
loops and they'll happily switch to each other, at a rate of a few 
million context switches per second.

( Note that the old scheduler's yield code did not actually change a 
  task's priority - so if an interactive task (such as firefox) yielded, 
  it got different behavior than CPU hogs. )

> Wheras JVMs (eg. that have garbage collectors call yield), presumably 
> get quite a lot of tuning, and that was probably done with the less 
> surprising (and more common) sched_yield behaviour.

i disagree. To some of them, having a _more_ agressive yield than 2.6.22 
might increase latencies and jitter - which can be seen as a regression 
as well. All tests i've seen so far show dramatically lower jitter in 
v2.6.23 and upwards kernels.

anyway, right now what we have is a closed-source benchmark (which is a 
quite silly one as well) against a popular open-source desktop app and 
in that case the choice is obvious. Actual Java app server benchmarks 
did not show any regression so maybe Java's use of yield for locking is 
not that significant after all and it's only Volanomark that is doing 
extra (unnecessary) yields. (and java benchmarks are part of the 
upstream kernel test grid anyway so we'd have noticed any serious 
regression)

if you insist on flipping the default then that just shows a blatant 
disregard to desktop performance - i personally care quite a bit about 
desktop performance. (and deterministic scheduling in particular)

> > i think the sanest long-term solution is to strongly discourage the 
> > use of SCHED_OTHER::yield, because there's just no sane definition 
> > for yield that apps could rely upon. (well Linus suggested a pretty 
> > sane definition but that would necessiate the burdening of the 
> > scheduler fastpath - we dont want to do that.) New ideas are welcome 
> > of course.
> 
> sched_yield is defined to put the calling task at the end of the queue 
> for the given priority level as you know (ie. at the end of all other 
> priority 0 tasks, for SCHED_OTHER).

almost: substitute "priority" with "nice level". One problem is, that's 
not what the old scheduler did.

> > [ also, actual technical feedback on the SCHED_BATCH patch i sent
> >   (which was the only "forward looking" moment in this thread so far
> >    ;-) would be nice too. ]
> 
> I dislike a wholesale change in behaviour like that. Especially when 
> it is changing behaviour of yield among SCHED_BATCH tasks versus yield 
> among SCHED_OTHER tasks.

There's no wholesale change in behavior, SCHED_BATCH tasks have clear 
expectations of being throughput versus latency, hence the patch makes 
quite a bit of sense to me. YMMV.

	Ingo

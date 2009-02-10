Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZBJFwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZBJFwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZBJFwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:52:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:33672 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750920AbZBJFwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:52:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19v3tk1Uz9vBvJGQId3oHE+zKBa0x5vja4P7KpHtG
	kcUKtRbRJ5M7zY
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <20090209214723.GA2664@elte.hu>
References: <20090205112414.104100700@chello.nl>
	 <20090205120608.GB8799@elte.hu> <1233895919.2604.323.camel@ymzhang>
	 <20090206151832.GL18368@elte.hu>
	 <1234161961.5991.41.camel@minggr.sh.intel.com>
	 <20090209214723.GA2664@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Tue, 10 Feb 2009 06:52:34 +0100
Message-Id: <1234245154.6033.92.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 22:47 +0100, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > On Fri, 2009-02-06 at 23:18 +0800, Ingo Molnar wrote:
> > > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > > 
> > > > On Thu, 2009-02-05 at 13:06 +0100, Ingo Molnar wrote:
> > > > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > > 
> > > > > > This should hopefully address all the itimer borkage.
> > > > > 
> > > > > Applied to tip:timers/urgent, thanks Peter!
> > > > > 
> > > > > Yanmin: could you check hacbench_pth with latest tip/master, do
> > > > > these fixes resolve that 3% regression you reported?
> > > >
> > > > Lin Ming tested it and hackbench_pth/volanoMark regression all disappear. 
> > > > But oltp has a regression. We think oltp new regression isn't related to 
> > > > the patch. Ming is investigating it.
> > > 
> > > Potential suspects for oltp regression would be:
> > > 
> > >  3d39870: sched_rt: don't use first_cpu on cpumask created with cpumask_and
> > >  a571bbe: sched: fix buddie group latency
> > >  a9f3e2b: sched: clear buddies more aggressively
> > >  1596e29: sched: symmetric sync vs avg_overlap
> > >  d942fb6: sched: fix sync wakeups
> > 
> > I tested the latest tip-master branch.
> > After reverting "d942fb6: sched: fix sync wakeups", the oltp regression
> > on the 8cores Stockley machine is mostly fixed.
> > 
> > On another 4*4 cores Tigerton machine, oltp has more than 10% regression
> > with 2.6.29-rc4 compared with 2.6.29-rc3.
> 
> ok, that commit needs fixed or reverted. Peter, Mike?

I see some ~problems.

Looking at the tasks sitting in my ~idle box right now:

tasks 284, avg_overlap = 0.000000 196

starts make -j30

tasks 401, avg_overlap = 0.000000 285

﻿0.0 (should) means zero wakeups since birth, it does not mean this task
is showing synchronous behavior until it's non-zero.  New tasks start
with zero, so until they grow an avg_overlap, when they wake, at least
half of the decision making data is bogus/non-existent.  With make -j30,
I added 117 tasks, 89 are unknown, 28 known.  This parallel load _tries_
to go affine.  On an nfs mount where runners are also frequent (and
truly synchronous) wakers, it tries really hard.

IOW, I think the affinity logic may become too strong when strengthened
by flipping the hint.  I originally inverted that test to filter out the
case where we _have_ behavioral data indicating that the tasks in
question were definitely not synchronous despite the sync wakeup hint.

﻿Another ~problem is that a task with low avg_overlap can change
behavior to cpu hog, and retain it's stale avg_overlap up to forever.

Maybe we shouldn't use avg_overlap until it's been established.

But..

Flip-side: I have a strong feeling that that _not_ using it would have
negative impact.  Freshly forked task generates red-hot data for a yet
to be awakened partner...

Sigh.  Damned if ya do, damned if ya don't.

	-Mike


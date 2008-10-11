Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYJKNOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYJKNOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYJKNN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:13:58 -0400
Received: from corega.com.ru ([195.178.208.66]:34949 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbYJKNN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:13:57 -0400
Date: Sat, 11 Oct 2008 17:13:52 +0400
From: Evgeniy Polyakov <s0mbre@tservice.net.ru>
To: Mike Galbraith <efault@gmx.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081011131352.GA16908@tservice.net.ru>
References: <20081009231759.GA8664@tservice.net.ru> <1223633623.4138.86.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1223633623.4138.86.camel@marge.simson.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike.

On Fri, Oct 10, 2008 at 12:13:43PM +0200, Mike Galbraith (efault@gmx.de) wrote:
> a7be37a adds some math overhead, calls to calc_delta_mine() per
> wakeup/context switch for all weight tasks, whereas previously these
> calls were only made for tasks which were not nice 0.  It also shifts
> performance a bit in favor of loads which dislike wakeup preemption,

I believe anyone dislikes this :)

> this effect lessens as task count increases.  Per testing, overhead is
> not the primary factor in throughput loss.  I believe clock accuracy to
> be a more important factor than overhead by a very large margin.

In my tests it was not just overhead, it was a disaster.
And stopping just before this commit gained 20 MB/s out of 30 MB/s lose
for 26-27 window. No matter what accuracy it brings, this is just wrong
to assume that such performance drop in some workloads is justified.
What this accuracy is needed for?

> Reverting a7be37a (and the two asym fixes) didn't do a whole lot for me
> either.  I'm still ~8% down from 2.6.26 for netperf, and ~3% for tbench,
> and the 2.6.26 numbers are gcc-4.1, which are a little lower than
> gcc-4.3.  Along the way, I've reverted 100% of scheduler and ilk 26->27
> and been unable to recover throughput.  (Too bad I didn't know about
> that TSO/GSO thingy, would have been nice.)
> 
> I can achieve nearly the same improvement for tbench with a little
> tinker, and _more_ for netperf than reverting these changes delivers,﻿
> see last log entry, experiment cut math overhead by less than 1/3.

Yeah, that's what I like :)

> For the full cfs history, even with those three reverts, I'm ~6% down on
> tbench, and ~14% for netperf, and haven't found out where it went.
> 
> > Curious reader can ask, where did we lost another 100 MB/s? This small
> > issue was not detected (or at least reported in netdev@ with provocative
> > enough subject), and it happend to live somehere in 2.6.24-2.6.25 changes.
> > I was so lucky to 'guess' (just after couple of hundreds of compilations),
> > that it corresponds to 8f4d37ec073c17e2d4aa8851df5837d798606d6f commit about
> > high-resolution timers, attached patch against 2.6.25 brings tbench
> > performance for the 2.6.25 kernel tree to 455 MB/s.
> 
> I have highres timers disabled in my kernels because per testing it does
> cost a lot at high frequency, but primarily because it's not available
> throughout test group, same for nohz.  A patchlet went into 2.6.27 to
> neutralized the cost of hrtick when it's not active.  Per re-test,
> 2.6.27 should be zero impact with hrtick disabled. 

Well, yes, disabling it should bring performance back, but since they
are actually enabled everywhere and trick with debugfs is not widely
known, this is actually a red flag.

> > There are still somewhat missed 20 MB/s, but 2.6.24 has 475 MB/s, so
> > likely bug lives between 2.6.24 and above 8f4d37ec073 commit.
> 
> I lost some at 24, got it back at 25 etc.  Some of it is fairness /
> preemption differences, but there's a bunch I can't find, and massive
> amounts of time spent bisecting were a waste of time.

Yup, but since I slacked with bits of beer after POHMELFS release I did
not regret too much :)

> My annotated test log.  File under fwiw.
> 
> Note:  2.6.23 cfs was apparently a bad-hair day for high frequency
> switchers.  Anyone entering the way-back-machine to test 2.6.23, should
> probably use cfs-24.1, which is 2.6.24 scheduler minus on zero impact
> for nice 0 loads line.
> 
> -------------------------------------------------------------------------
> UP config, no nohz or highres timers except as noted.

UP actually may expect the differece in our results: I have 4-way (2
physical and 2 logical (HT enabled) CPUs) 32-bit old Xeons with highmem
enabled. I also tried low-latency preemption and no preemption (server)
without much difference.

-- 
	Evgeniy Polyakov

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbZE1Ubd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbZE1Ubd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763080AbZE1Ub0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:31:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761050AbZE1UbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:31:25 -0400
Subject: Re: CFS Performance Issues
From: Peter Zijlstra <peterz@infradead.org>
To: Olaf Kirch <okir@suse.de>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Andreas Gruenbacher <agruen@suse.de>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <200905281502.22487.okir@suse.de>
References: <200905281502.22487.okir@suse.de>
Content-Type: text/plain
Date: Thu, 28 May 2009 22:31:18 +0200
Message-Id: <1243542678.6645.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 15:02 +0200, Olaf Kirch wrote:
> Hi Ingo,
> 
> As you probably know, we've been chasing a variety of performance issues
> on our SLE11 kernel, and one of the suspects has been CFS for quite a
> while. The benchmarks that pointed to CFS include AIM7, dbench, and a few
> others, but the picture has been a bit hazy as to what is really the problem here.
> 
> Now IBM recently told us they had played around with some scheduler
> tunables and found that by turning off NEW_FAIR_SCHEDULERS, they
> could make the regression on a compute benchmark go away completely.
> We're currently working on rerunning other benchmarks with NEW_FAIR_SLEEPERS
> turned off to see whether it has an impact on these as well.
> 
> Of course, the first question we asked ourselves was, how can NEW_FAIR_SLEEPERS
> affect a benchmark that rarely sleeps, or not at all?
> 
> The answer was, it's not affecting the benchmark processes, but some noise
> going on in the background. When I was first able to reproduce this on my work
> station, it was knotify4 running in the background - using hardly any CPU, but
> getting woken up ~1000 times a second. Don't ask me what it's doing :-)
> 
> So I sat down and reproduced this; the most recent iteration of the test program
> is courtesy of Andreas Gruenbacher (see below).
> 
> This program spawns a number of processes that just spin in a loop. It also spawns
> a single process that wakes up 1000 times a second. Every second, it computes the
> average time slice per process (utime / number of involuntary context switches),
> and prints out the overall average time slice and average utime.
> 
> While running this program, you can conveniently enable or disable fair sleepers.
> When I do this on my test machine (no desktop in the background this time :-)
> I see this:
> 
> ../slice 16
>     avg slice:  1.12 utime: 216263.187500
>     avg slice:  0.25 utime: 125507.687500
>     avg slice:  0.31 utime: 125257.937500
>     avg slice:  0.31 utime: 125507.812500
>     avg slice:  0.12 utime: 124507.875000
>     avg slice:  0.38 utime: 124757.687500
>     avg slice:  0.31 utime: 125508.000000
>     avg slice:  0.44 utime: 125757.750000
>     avg slice:  2.00 utime: 128258.000000
>  ------ here I turned off new_fair_sleepers ----
>     avg slice: 10.25 utime: 137008.500000
>     avg slice:  9.31 utime: 139008.875000
>     avg slice: 10.50 utime: 141508.687500
>     avg slice:  9.44 utime: 139258.750000
>     avg slice: 10.31 utime: 140008.687500
>     avg slice:  9.19 utime: 139008.625000
>     avg slice: 10.00 utime: 137258.625000
>     avg slice: 10.06 utime: 135258.562500
>     avg slice:  9.62 utime: 138758.562500
> 
> As you can see, the average time slice is *extremely* low with new fair
> sleepers enabled. Turning it off, we get ~10ms time slices, and a
> performance that is roughly 10% higher. It looks like this kind of
> "silly time slice syndrome" is what is really eating performance here.
> 
> After staring at place_entity for a while, and by watching the process'
> vruntime for a while, I think what's happening is this.
> 
> With fair sleepers turned off, a process that just got woken up will
> get the vruntime of the process that's leftmost in the rbtree, and will
> thus be placed to the right of the current task.
> 
> However, with fair_sleepers enabled, a newly woken up process
> will retain its old vruntime as long as it's less than sched_latency
> in the past, and thus it will be placed to the very left in the rbtree.
> Since a task that is mostly sleeping will never accrue vruntime at
> the same rate a cpu-bound task does, it will always preempt any
> running task almost immediately after it's scheduled.
> 
> Does this make sense?

Yep, you got it right.

> Any insight you can offer here is greatly appreciated!

There's a class of applications and benchmarks that rather likes this
behaviour, particularly those that favour timely delivery of signals and
other wakeup driven thingies.






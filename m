Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZE3LSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZE3LSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZE3LSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:18:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbZE3LSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:18:39 -0400
Date: Sat, 30 May 2009 13:18:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <okir@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Andreas Gruenbacher <agruen@suse.de>, Mike Galbraith <efault@gmx.de>
Subject: Re: CFS Performance Issues
Message-ID: <20090530111819.GD16913@elte.hu>
References: <200905281502.22487.okir@suse.de> <1243542678.6645.101.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243542678.6645.101.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-05-28 at 15:02 +0200, Olaf Kirch wrote:
> > Hi Ingo,
> > 
> > As you probably know, we've been chasing a variety of 
> > performance issues on our SLE11 kernel, and one of the suspects 
> > has been CFS for quite a while. The benchmarks that pointed to 
> > CFS include AIM7, dbench, and a few others, but the picture has 
> > been a bit hazy as to what is really the problem here.
> > 
> > Now IBM recently told us they had played around with some 
> > scheduler tunables and found that by turning off 
> > NEW_FAIR_SCHEDULERS, they could make the regression on a compute 
> > benchmark go away completely. We're currently working on 
> > rerunning other benchmarks with NEW_FAIR_SLEEPERS turned off to 
> > see whether it has an impact on these as well.
> > 
> > Of course, the first question we asked ourselves was, how can 
> > NEW_FAIR_SLEEPERS affect a benchmark that rarely sleeps, or not 
> > at all?
> > 
> > The answer was, it's not affecting the benchmark processes, but 
> > some noise going on in the background. When I was first able to 
> > reproduce this on my work station, it was knotify4 running in 
> > the background - using hardly any CPU, but getting woken up 
> > ~1000 times a second. Don't ask me what it's doing :-)
> > 
> > So I sat down and reproduced this; the most recent iteration of 
> > the test program is courtesy of Andreas Gruenbacher (see below).
> > 
> > This program spawns a number of processes that just spin in a 
> > loop. It also spawns a single process that wakes up 1000 times a 
> > second. Every second, it computes the average time slice per 
> > process (utime / number of involuntary context switches), and 
> > prints out the overall average time slice and average utime.
> > 
> > While running this program, you can conveniently enable or 
> > disable fair sleepers. When I do this on my test machine (no 
> > desktop in the background this time :-) I see this:
> > 
> > ../slice 16
> >     avg slice:  1.12 utime: 216263.187500
> >     avg slice:  0.25 utime: 125507.687500
> >     avg slice:  0.31 utime: 125257.937500
> >     avg slice:  0.31 utime: 125507.812500
> >     avg slice:  0.12 utime: 124507.875000
> >     avg slice:  0.38 utime: 124757.687500
> >     avg slice:  0.31 utime: 125508.000000
> >     avg slice:  0.44 utime: 125757.750000
> >     avg slice:  2.00 utime: 128258.000000
> >  ------ here I turned off new_fair_sleepers ----
> >     avg slice: 10.25 utime: 137008.500000
> >     avg slice:  9.31 utime: 139008.875000
> >     avg slice: 10.50 utime: 141508.687500
> >     avg slice:  9.44 utime: 139258.750000
> >     avg slice: 10.31 utime: 140008.687500
> >     avg slice:  9.19 utime: 139008.625000
> >     avg slice: 10.00 utime: 137258.625000
> >     avg slice: 10.06 utime: 135258.562500
> >     avg slice:  9.62 utime: 138758.562500
> > 
> > As you can see, the average time slice is *extremely* low with 
> > new fair sleepers enabled. Turning it off, we get ~10ms time 
> > slices, and a performance that is roughly 10% higher. It looks 
> > like this kind of "silly time slice syndrome" is what is really 
> > eating performance here.
> > 
> > After staring at place_entity for a while, and by watching the 
> > process' vruntime for a while, I think what's happening is this.
> > 
> > With fair sleepers turned off, a process that just got woken up 
> > will get the vruntime of the process that's leftmost in the 
> > rbtree, and will thus be placed to the right of the current 
> > task.
> > 
> > However, with fair_sleepers enabled, a newly woken up process 
> > will retain its old vruntime as long as it's less than 
> > sched_latency in the past, and thus it will be placed to the 
> > very left in the rbtree. Since a task that is mostly sleeping 
> > will never accrue vruntime at the same rate a cpu-bound task 
> > does, it will always preempt any running task almost immediately 
> > after it's scheduled.
> > 
> > Does this make sense?
> 
> Yep, you got it right.
> 
> > Any insight you can offer here is greatly appreciated!
> 
> There's a class of applications and benchmarks that rather likes 
> this behaviour, particularly those that favour timely delivery of 
> signals and other wakeup driven thingies.

Yes.

Firstly, thanks Olaf for measuring and analyzing this so carefully. 
>From your description i get the impression that you are trying to 
maximize throughput for benchmarks - AIM9 and dbench live and die on 
the ability to batch the workload.

If that is indeed the goal, could you try your measurement with 
SCHED_BATCH enabled for all relevant (server and client) tasks? 
SCHED_BATCH is a hint to the scheduler that the workload does not 
care about wakeup latecy. Do you still get the new-fair-sleepers 
sensitivity in that case?

The easiest way to se SCHED_BATCH is to do this in a shell:

  schedtool -B $$

and then restart all server tasks ('service mysqld restart' for 
example) and start the benchmark - all child tasks will have 
SCHED_BATCH set.

<plug>

Also, analysis of such problems can generally be done faster and 
more accuately (and the results are more convincing) if you use 
perfcounters. It's very easy to set it up, as long as you have Core2 
(or later) Intel CPUs or AMD CPUs. Pull this tree:

git pull \
 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git \
  perfcounters/core

No configuration needed - build it (accept the defaults), and boot 
it and do:

  cd Documentation/perf_counter/
  make -j

and you are set. You can try:

  ./perf stat -a sleep 10

to get a 10 seconds snapshot of what's going on in the system:

 aldebaran:~> perf stat -a sleep 10

 Performance counter stats for 'sleep':

  159827.019426  task clock ticks     (msecs)
           1274  context switches     #        0.000 M/sec
             78  CPU migrations       #        0.000 M/sec
           7777  pagefaults           #        0.000 M/sec
     2236492601  CPU cycles           #       13.993 M/sec
     1908732654  instructions         #       11.942 M/sec
        5059857  cache references     #        0.032 M/sec
         503188  cache misses         #        0.003 M/sec

 Wall-clock time elapsed: 10008.471596 msecs

You can also do 'perf stat dbench 10' type of measurements to only 
measure that particular workload. In particular the context switch 
rate, the cache-miss rate and the ratio between task-clock-ticks and 
wall-clock-time (efficiency parallelization) can be pretty telling 
about how 'healthy' a benchmark is - and how various tunables (such 
as new-fair-sleepers) affect it.

Say 'hackbench 20' gives this output on my a testbox:

 aldebaran:~> perf stat ./hackbench 20
 Time: 0.882

 Performance counter stats for './hackbench':

   12117.839049  task clock ticks     (msecs)
          63444  context switches     #        0.005 M/sec
           6972  CPU migrations       #        0.001 M/sec
          35356  pagefaults           #        0.003 M/sec
    34561571429  CPU cycles           #     2852.123 M/sec
    26980655850  instructions         #     2226.524 M/sec
      115693364  cache references     #        9.547 M/sec
       57710692  cache misses         #        4.762 M/sec

 Wall-clock time elapsed:   996.284274 msecs

This is a 2.8 GHz CPU, and the cycles/sec value of 2.852 shows that 
the workload is running at max CPU speed. 2.2 billion instructions 
per second is OK-ish. Cache-miss rate is a bit high - but that's not 
unexpected: hackbench 20 runs 400 tasks in parallel.

perf stat results become even more interesting when they are 
compared. You might want to give it a try.

Thanks,

	Ingo

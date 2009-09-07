Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZIGWS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZIGWS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 18:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZIGWSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 18:18:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZIGWSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 18:18:25 -0400
Date: Tue, 8 Sep 2009 00:18:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907221812.GA1700@elte.hu>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <4AA54AA7.9080709@redhat.com> <20090907184640.GG18599@kernel.dk> <20090907203627.GA17731@elte.hu> <20090907204645.GK18599@kernel.dk> <1252357417.7959.52.camel@laptop> <20090907210550.GL18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907210550.GL18599@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Sep 07 2009, Peter Zijlstra wrote:
> > On Mon, 2009-09-07 at 22:46 +0200, Jens Axboe wrote:
> > > > a bug in the SMP load-balancer that can cause interactivity problems 
> > > > on large CPU count systems.
> > > 
> > > Worth trying on the dual core box?
> > 
> > I debugged the issue on a dual core :-)
> > 
> > It should be more pronounced on larger machines, but its present on
> > dual-core too.
> 
> Alright, I'll upgrade that box to -tip tomorrow and see if it 
> makes a noticable difference. At -j4 or higher, I can literally 
> see windows slowly popping up when switching to a different 
> virtual desktop.

btw., if you run -tip and have these enabled:

  CONFIG_PERF_COUNTER=y 
  CONFIG_EVENT_TRACING=y

  cd tools/perf/
  make -j install

... then you can use a couple of new perfcounters features to 
measure scheduler latencies. For example:

  perf stat -e sched:sched_stat_wait -e task-clock ./hackbench 20

Will tell you how many times this workload got delayed by waiting 
for CPU time.

You can repeat the workload as well and see the statistical 
properties of those metrics:

 aldebaran:/home/mingo> perf stat --repeat 10 -e \
              sched:sched_stat_wait:r -e task-clock ./hackbench 20
 Time: 0.251
 Time: 0.214
 Time: 0.254
 Time: 0.278
 Time: 0.245
 Time: 0.308
 Time: 0.242
 Time: 0.222
 Time: 0.268
 Time: 0.244

 Performance counter stats for './hackbench 20' (10 runs):

          59826  sched:sched_stat_wait    #      0.026 M/sec   ( +-   5.540% )
    2280.099643  task-clock-msecs         #      7.525 CPUs    ( +-   1.620% )

    0.303013390  seconds time elapsed   ( +-   3.189% )

To get scheduling events, do:

 # perf list 2>&1 | grep sched:
  sched:sched_kthread_stop                   [Tracepoint event]
  sched:sched_kthread_stop_ret               [Tracepoint event]
  sched:sched_wait_task                      [Tracepoint event]
  sched:sched_wakeup                         [Tracepoint event]
  sched:sched_wakeup_new                     [Tracepoint event]
  sched:sched_switch                         [Tracepoint event]
  sched:sched_migrate_task                   [Tracepoint event]
  sched:sched_process_free                   [Tracepoint event]
  sched:sched_process_exit                   [Tracepoint event]
  sched:sched_process_wait                   [Tracepoint event]
  sched:sched_process_fork                   [Tracepoint event]
  sched:sched_signal_send                    [Tracepoint event]
  sched:sched_stat_wait                      [Tracepoint event]
  sched:sched_stat_sleep                     [Tracepoint event]
  sched:sched_stat_iowait                    [Tracepoint event]

stat_wait/sleep/iowait would be the interesting ones, for latency 
analysis.

Or, if you want to see all the specific delays and want to see 
min/max/avg, you can do:

  perf record -e sched:sched_stat_wait:r -f -R -c 1 ./hackbench 20
  perf trace

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbYL3HUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbYL3HUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYL3HUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:20:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYL3HUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:20:31 -0500
Date: Tue, 30 Dec 2008 08:20:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20081230072017.GA20225@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com> <20081230024819.GA23301@balbir.in.ibm.com> <20081230062139.GA30038@elte.hu> <20081230064432.GA30101@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230064432.GA30101@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2008-12-30 07:21:39]:
> 
> > 
> > * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > > > KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
> > > > > package system
> > > > >
> > > > > SchedMC Run Time     Package Idle    Energy  Power
> > > > > 0       81.68        52.83% 54.71%  1.00x J 1.00y W
> > > > > 1       80.70        36.62% 70.11%  0.95x J 0.96y W
> > > > > 2       74.95        19.53% 85.92%  0.90x J 0.98y W
> > 
> > > > Your result is very interesting.
> > > > level 2 is more fast and efficient of power.
> > > > 
> > > > What's major contributor to use less time in level 2?
> > > > I think it's cache bounce is less time than old.
> > > > Is right ?
> > > 
> > > Yes, correct
> > 
> > yes, i too noticed that runtime improved so dramatically: +7.5% on 
> > kernbench is a _very_ big deal.
> > 
> 
> Yes, it is, I think one way to identify it on the x86 box would be to 
> use the performance counter patches, I'll see it I can get it working.

yeah, good idea, and it's easy to get perf-counters working: just boot 
tip/master on a Core2 (or later) Intel CPU [see below about how to use 
perfcounters on other CPUs], and pick up timec.c:

   http://redhat.com/~mingo/perfcounters/timec.c

then run a kernel build like this:

   $ ./timec -e -5,-4,-3,0,1,2,3,4,5 make -j16 bzImage

that's all. You should get an array of metrics like this:

 [...]
Kernel: arch/x86/boot/bzImage is ready  (#28)

 Performance counter stats for 'make':

  628315.871980  task clock ticks     (msecs)

          42330  CPU migrations       (events)
         124980  context switches     (events)
       18698292  pagefaults           (events)
  1351875946010  CPU cycles           (events)
  1121901478363  instructions         (events)
    10654788968  cache references     (events)
      633581867  cache misses         (events)
   247508675357  branches             (events)
    21567244144  branch misses        (events)

 Wall-clock time elapsed: 118348.109066 msecs

I'd guess the CPU migrations, context-switches, cycles+instructions 
counters are the most interesting ones. I.e. on a Core2 a good metric is 
probably:

   $ ./timec -e -5,-4,0,1 make -j16 bzImage

[ If you see any weirdnesses in the numbers, then you should first suspect 
  some perf-counters bug. Please report any problems to us! ]

If your systems are not Core2 based then patches to extend perfcounters 
support to those CPUs are welcome as well ;-)

NOTE: the sw counters (migrations, per task cost) are available on all 
CPUs. I.e. you can always do:

   $ ./timec -e -5,-4,-3 make -j16 bzImage

regardless of CPU type.

And note that the wall-clock and task-clock results in this case will be 
far more accurate than normal 'time make -j16 bzImage' output.

	Ingo

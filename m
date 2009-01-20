Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZATODw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZATODw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZATODn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:03:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZATODm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:03:42 -0500
Date: Tue, 20 Jan 2009 15:03:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120140324.GA26424@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120112634.GA20858@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Times I believe are in nanoseconds for lmbench, anyway lower is 
> > better.
> > 
> > non pv   AVG=464.22 STD=5.56
> > paravirt AVG=502.87 STD=7.36
> > 
> > Nearly 10% performance drop here, which is quite a bit... hopefully 
> > people are testing the speed of their PV implementations against 
> > non-PV bare metal :)
> 
> Ouch, that looks unacceptably expensive. All the major distros turn 
> CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
> promise to have no measurable runtime overhead.

Here are some more precise stats done via hw counters on a perfcounters 
kernel using 'timec', running a modified version of the 'mmap performance 
stress-test' app i made years ago.

The MM benchmark app can be downloaded from:

   http://redhat.com/~mingo/misc/mmap-perf.c

timec.c can be picked up from:

   http://redhat.com/~mingo/perfcounters/timec.c

mmap-perf conducts 1 million mmap()/munmap()/mremap() calls, and touches 
the mapped area as well with a certain chance. The patterns are 
pseudo-random and the random seed is initialized to the same value so 
repeated runs produce the exact same mmap sequence.

I ran the test with a single thread and bound to a single core:

  # taskset 2 timec -e -5,-4,-3,0,1,2,3 ./mmap-perf 1

[ I ran it as root - so that kernel-space hardware-counter statistics are 
  included as well. ]

The results are quite surprisingly candid about the true costs of 
paravirt_ops on the native kernel's overhead (CONFIG_PARAVIRT=y):

-----------------------------------------------
| Performance counter stats for './mmap-perf' |
-----------------------------------------------
|                |
|  x86-defconfig |   PARAVIRT=y         
|------------------------------------------------------------------
|
|    1311.554526 |  1360.624932  task clock ticks (msecs)    +3.74%
|                |
|              1 |            1  CPU migrations
|             91 |           79  context switches
|          55945 |        55943  pagefaults
|    ............................................
|     3781392474 |   3918777174  CPU cycles                  +3.63%
|     1957153827 |   2161280486  instructions               +10.43%
|       50234816 |     51303520  cache references            +2.12%
|        5428258 |      5583728  cache misses                +2.86%
|                |
|    1314.782469 |  1363.694447  time elapsed (msecs)        +3.72%
|                |
-----------------------------------

The most surprising element is that in the paravirt_ops case we run 204 
million more instructions - out of the ~2000 million instructions total. 

That's an increase of over 10%!

That shows the expected $cache risks here as well: i ran this on an 
Extreme Edition CPU which has a ton of L2 cache [4MB] which mutes L2 
$cache misses quite a bit.

Note that this workload tests a broader range of MM related codepaths - 
not just pure pagefault costs.

	Ingo

ps. Measurement methodology:

    The software counters show that the test was indeed done on an idle 
    system: there are no CPU migrations (the task is affine), nor any 
    significant context-switches, and the pagefault count is essentially 
    the same as well. (because this is a fully repeatable workload.)

    The numbers are a representative sample from a run of more than 10 
    testruns, on an otherwise idle system. Measurement noise is very low:

      3906920196  CPU cycles           (events)
      3907556124  CPU cycles           (events)
      3907902335  CPU cycles           (events)
      3914423870  CPU cycles           (events)
      3915642464  CPU cycles           (events)
      3916134988  CPU cycles           (events)
      3916840093  CPU cycles           (events)
      3918777174  CPU cycles           (events)
      3918993251  CPU cycles           (events)
      3919907192  CPU cycles           (events)

    The max/min spread of 10 runs is 0.3%, so the precision of this 
    measurement is in the 0.1% range - more than enough to be conclusive.

    The max/min spread of the instruction counts is even better: in the 
    0.01% range. (that is because exactly the same workload is executed - 
    only timer IRQs and small disturbances cause noise here.)

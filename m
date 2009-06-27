Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZF0GEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZF0GEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 02:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZF0GEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 02:04:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZF0GEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 02:04:41 -0400
Date: Sat, 27 Jun 2009 08:04:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: performance counter ~0.4% error finding retired instruction
	count
Message-ID: <20090627060432.GB16200@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy>
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


* Vince Weaver <vince@deater.net> wrote:

> On Fri, 26 Jun 2009, Vince Weaver wrote:
>
>> From the best I can tell digging through the perf sources, the 
>> performance counters are set up and started in userspace, but instead 
>> of doing an immediate clone/exec, thousands of instructions worth of 
>> other stuff is done by perf in between.
>
> and for the curious, wondering how a simple
>
>   prctl(COUNTERS_ENABLE);
>   fork()
>   execvp()
>
> can cause 6000+ instructions of non-deterministic execution, it 
> turns out that perf is dynamically linked.  So it has to spend 
> 5000+ cycles in ld-linux.so resolving the excecvp() symbol before 
> it can actually execvp.

I measured 2000, but generally a few thousand cycles per invocation 
sounds about right.

That is in the 0.0001% measurement overhead range (per 'perf stat' 
invocation) for any realistic app that does something worth 
measuring - and even with a worst-case 'cheapest app' case it is in 
the 0.2-0.4% range.

Besides, you compare perfcounters to perfmon (which you seem to be a 
contributor of), while in reality perfmon has much, much worse (and 
unfixable, because designed-in) measurement overhead.

So why are you criticising perfcounters for a 5000 cycles 
measurement overhead while perfmon has huge, _hundreds of millions_ 
of cycles measurement overhead (per second) for various realistic 
workloads? [ In fact in one of the scheduler-tests perfmon has a 
whopping measurement overhead of _nine billion_ cycles, it increased 
total runtime of the workload from 3.3 seconds to 6.6 seconds. (!) ]

Why are you using a double standard here?

Here are some numbers to put the 5000 cycles startup cost into 
perspective. For example the default startup costs of even the 
simplest Linux binaries (/bin/true):

 titan:~> perf stat /bin/true

  Performance counter stats for '/bin/true':

       0.811328  task-clock-msecs     #      1.002 CPUs 
              1  context-switches     #      0.001 M/sec
              1  CPU-migrations       #      0.001 M/sec
            180  page-faults          #      0.222 M/sec
        1267713  cycles               #   1562.516 M/sec
         733772  instructions         #      0.579 IPC  
          26261  cache-references     #     32.368 M/sec
            531  cache-misses         #      0.654 M/sec

    0.000809407  seconds time elapsed

5000/1267713 cycles is in the 0.4% range. Run any app that actually 
does something beyond starting up, an app which has a chance to get 
a decent cache footprint and gets into steady state so that it gets 
stable properties that can be measured reliably - and you'll get 
into the billions of cycles range or more - at which point a few 
thousand cycles is in the 0.0001% measurement overhead range.

Compare to this the intrinsic noise of cycles metrics for some 
benchmark like hackbench:

 titan:~> perf stat -r 2 -e 0:0 -- ~/hackbench 10
 Time: 0.448
 Time: 0.447

  Performance counter stats for '/home/mingo/hackbench 10' (2 runs):

     2661715310  cycles                 ( +-   0.588% )

    0.480153304  seconds time elapsed   ( +-   0.549% )

The noise in this (very short) hackbench run above was 15 _million_ 
cycles. See how small a few thousand cycles are?

If the 5 thousand cycles measurement overhead _still_ matters to you 
under such circumstances then by all means please submit the patches 
to improve it. Despite your claims this is totally fixable with the 
current perfcounters design, Peter outlined the steps of how to 
solve it, you can utilize ptrace if you want to.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZFWOgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZFWOgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759313AbZFWOgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:36:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759093AbZFWOgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:36:04 -0400
Date: Tue, 23 Jun 2009 16:36:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
Message-ID: <20090623143601.GA13415@elte.hu>
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu> <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40DFF5.7010207@inria.fr>
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


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >   
> >>  $ perf stat -e cycles -e instructions -e r1000ffe0 ./hackbench 10
> >>  Time: 0.186
> >>     
> >
> > Correction: that should be r10000ffe0.
> 
> Oh thanks a lot, it seems to work now!

btw., it might make sense to expose NUMA inbalance via generic 
enumeration. Right now we have:

        PERF_COUNT_HW_CPU_CYCLES                = 0,
        PERF_COUNT_HW_INSTRUCTIONS              = 1,
        PERF_COUNT_HW_CACHE_REFERENCES          = 2,
        PERF_COUNT_HW_CACHE_MISSES              = 3,
        PERF_COUNT_HW_BRANCH_INSTRUCTIONS       = 4,
        PERF_COUNT_HW_BRANCH_MISSES             = 5,
        PERF_COUNT_HW_BUS_CYCLES                = 6,

plus we have cache stats:

 * Generalized hardware cache counters:
 *
 *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU } x
 *       { read, write, prefetch } x
 *       { accesses, misses }

NUMA is here to stay, and expressing local versus remote access 
stats seems useful. We could add two generic counters:

        PERF_COUNT_HW_RAM_LOCAL                 = 7,
        PERF_COUNT_HW_RAM_REMOTE                = 8,

And map them properly on all CPUs that support such stats. They'd be 
accessible via '-e ram-local-refs' and '-e ram-remote-refs' type of 
event symbols.

What is your typical usage pattern of this counter? What (general) 
kind of app do you profile with it and how do you make use of the 
specific node masks?

Would a local/all-remote distinction be enough, or do you need to 
make a distinction between the individual nodes to get the best 
insight into the workload?

> One strange thing I noticed: sometimes perf reports that there 
> were some accesses to target numa nodes 4-7 while my box only has 
> 4 numa nodes: If I request counters only for the non-existing 
> target numa nodes (4-7, with -e r1000010e0 -e r1000020e0 -e 
> r1000040e0 -e r1000080e0), I always get 4 zeros.
>
> But if I mix some couinters from the existing nodes (0-3) with 
> some counters from non-existing nodes (4-7), the non-existing ones 
> report some small but non-empty values. Does it ring any bell?

I can see that too. I have a similar system (4 nodes), and if i use 
the stats for nodes 4-7 (non-existent) i get:

phoenix:~> perf stat -e r1000010e0 -e r1000020e0 -e r1000040e0 -e r1000080e0 --repeat 10 ./hackbench 30
Time: 0.490
Time: 0.435
Time: 0.492
Time: 0.569
Time: 0.491
Time: 0.498
Time: 0.549
Time: 0.530
Time: 0.543
Time: 0.482

 Performance counter stats for './hackbench 30' (10 runs):

              0  raw 0x1000010e0        ( +-   0.000% )
              0  raw 0x1000020e0        ( +-   0.000% )
              0  raw 0x1000040e0        ( +-   0.000% )
              0  raw 0x1000080e0        ( +-   0.000% )

    0.610303953  seconds time elapsed.

( Note the --repeat option - that way you can repeat workloads and 
  observe their statistical properties. )

If i try the first 4 nodes i get:

phoenix:~> perf stat -e r1000001e0 -e r1000002e0 -e r1000004e0 -e r1000008e0 --repeat 10 ./hackbench 30
Time: 0.403
Time: 0.431
Time: 0.406
Time: 0.421
Time: 0.461
Time: 0.423
Time: 0.495
Time: 0.462
Time: 0.434
Time: 0.459

 Performance counter stats for './hackbench 30' (10 runs):

       52255370  raw 0x1000001e0        ( +-   5.510% )
       46052950  raw 0x1000002e0        ( +-   8.067% )
       45966395  raw 0x1000004e0        ( +-  10.341% )
       63240044  raw 0x1000008e0        ( +-  11.707% )

    0.530894007  seconds time elapsed.

Quite noisy across runs - which is expected on NUMA, as the memory 
allocations are not really deterministic and some more NUMA friendly 
than others. This box has all relevant NUMA options enabled:

 CONFIG_NUMA=y
 CONFIG_K8_NUMA=y
 CONFIG_X86_64_ACPI_NUMA=y
 CONFIG_ACPI_NUMA=y

But if i 'mix' counters, i too get weird stats:

phoenix:~> perf stat -e r1000020e0 -e r1000040e0 -e r1000080e0 -e r10000ffe0 --repeat 10 ./hackbench 30
Time: 0.432
Time: 0.446
Time: 0.428
Time: 0.472
Time: 0.443
Time: 0.454
Time: 0.398
Time: 0.438
Time: 0.403
Time: 0.463

 Performance counter stats for './hackbench 30' (10 runs):

        2355436  raw 0x1000020e0        ( +-   8.989% )
              0  raw 0x1000040e0        ( +-   0.000% )
              0  raw 0x1000080e0        ( +-   0.000% )
      204768941  raw 0x10000ffe0        ( +-   0.788% )

    0.528447241  seconds time elapsed.

That 2355436 count for node 5 should have been zero.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbZIDGoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbZIDGoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbZIDGoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:44:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59492 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZIDGob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:44:31 -0400
Date: Fri, 4 Sep 2009 08:44:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090904064418.GB29829@elte.hu>
References: <20090817064851.GQ12579@kernel.dk> <20090903.213702.250776705.davem@davemloft.net> <20090904050256.GA8382@elte.hu> <20090903.220906.44384937.davem@davemloft.net> <20090904052005.GN18599@kernel.dk> <20090904063419.GO18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904063419.GO18599@kernel.dk>
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

> On Fri, Sep 04 2009, Jens Axboe wrote:
> > On Thu, Sep 03 2009, David Miller wrote:
> > > From: Ingo Molnar <mingo@elte.hu>
> > > Date: Fri, 4 Sep 2009 07:02:56 +0200
> > > 
> > > > 
> > > > * David Miller <davem@davemloft.net> wrote:
> > > > 
> > > >> Does this build for you without adding an
> > > >> arch/sparc/include/asm/perf_counter.h that looks
> > > >> something like the following?
> > > >> 
> > > >> #ifndef _ASM_SPARC_PERF_COUNTER_H
> > > >> #define _ASM_SPARC_PERF_COUNTER_H
> > > >> 
> > > >> #define PERF_COUNTER_INDEX_OFFSET	0
> > > >> 
> > > >> #endif
> > > >> 
> > > >> Or is this somehow now required in the -tip trees?
> > > > 
> > > > This used to be required but i recently fixed this (and that fix is 
> > > > upstream as well) via:
> > > > 
> > > >   f738eb1: perf_counter: Fix the PARISC build
> > > > 
> > > > there's now a default define of 0 so you dont have to define it and 
> > > > can leave out this chunk.
> > > > 
> > > > ( That index is only interesting if the architecture has a way to 
> > > >   allow unprivileged user-space to access counter registers 
> > > >   directly. In that case the index reflects the offset from the 
> > > >   (constantly changing) dynamix index which we put into the mmap 
> > > >   header. With Sparc not having a hw-PMU implementation this index 
> > > >   is entirely uninteresting at this stage. )
> > > 
> > > But you still do need at least an empty perf_counter.h file
> > > right?  Jens must have left the file out of his submission
> > > by accident, and that's what I'm trying to get to the bottom
> > > of here :-)
> > > 
> > > I assume there was a similar change to deal with references to
> > > set_perf_counter_pending() too or is at least a NOP definition
> > > still needed?
> > 
> > It wasn't required when I built and used it (and sent the 
> > patch), I used the posted patch as-is. It's been a few weeks 
> > since I last updated and ran that box, let me double check after 
> > morning coffee and send you a fresh patch (if needed) :-)
> 
> It seems I had a left-over arch/sparc/include/asm/perf_counter.h 
> from earlier experiments that was never checked in, so that is why 
> it worked for me. include/linux/sched.h does:
> 
> #ifdef CONFIG_PERF_COUNTERS
> # include <asm/perf_counter.h>
> #endif
> 
> so that's no way around an empty stub file. Updated patch below, 
> this is what I have been using.

That stub is not wasted: it will be filled in with real arch hw-PMU 
details, once that's implemented too.

hw-PMU support has its advantages: it can provide NMI sampling that 
allows 'perf report' to pierce irqs-off critical sections, and it 
also gives access to non-time based metrics such as instructions, 
cache-misses, etc. - depending on what the CPU can do.

That way you can tell at a glance what a workload does:

 aldebaran:~> perf stat ./hackbench 10
 Time: 0.109

 Performance counter stats for './hackbench 10':

    1191.574039  task-clock-msecs         #      7.768 CPUs 
          50363  context-switches         #      0.042 M/sec
           4249  CPU-migrations           #      0.004 M/sec
          17710  page-faults              #      0.015 M/sec
     3600730931  cycles                   #   3021.827 M/sec
     1573681316  instructions             #      0.437 IPC  
       15394883  cache-references         #     12.920 M/sec
        5005241  cache-misses             #      4.201 M/sec

    0.153389368  seconds time elapsed

without hw-PMU support it looks like this:

 venus:~> perf stat ./hackbench 1
 Time: 7.600

 Performance counter stats for './hackbench 1':

   28218.316944  task-clock-ticks     #       3.590 CPU utilization factor
          62700  context-switches     #       0.002 M/sec
          11112  CPU-migrations       #       0.000 M/sec
           1919  page-faults          #       0.000 M/sec
  <not counted>  cycles              
  <not counted>  instructions        
  <not counted>  cache-references    
  <not counted>  cache-misses        

 Wall-clock time elapsed:  7860.000004 msecs

The soft stats and time measurements work just fine - the hardware 
metrics are not counted.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZFWIYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZFWIYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZFWIYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:24:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbZFWIYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:24:33 -0400
Date: Tue, 23 Jun 2009 10:24:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
	member in event_symbol
Message-ID: <20090623082411.GC11181@elte.hu>
References: <1245669194.17153.6.camel@localhost.localdomain> <1245669268.17153.8.camel@localhost.localdomain> <20090622113256.GA22479@elte.hu> <1245675657.7537.3.camel@localhost.localdomain> <20090622141009.GB6486@elte.hu> <1245700551.6167.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245700551.6167.5.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Mon, 2009-06-22 at 16:10 +0200, Ingo Molnar wrote:
> > yeah, somethig like that. I'd suggest to print out the actual 
> > measured events:
> > 
> >     cache-references      10123 events
> >     cache-misses             15 events
> > 
> > and if something does not appear to be ticking then do something 
> > like:
> > 
> >     cache-misses          <inactive>
> > 
> > I.e. 'perf test' could be a quick way both to users and to 
> > developers to see all possible hw and sw events.
> > 
> > Perhaps builtin-test.c should also do specific testcases for certain 
> > counters - say intentionally migrate to a CPU and back to see the 
> > CPU-migration count.
> > 
> > Also, you seem to have copied builtin-stat.c, right? Try to 
> > librarize as much of the functionality (into util/*) to make the 
> > resulting linecount increase as small as possible.
> 
> perf test also need some command to execute otherwise it will also 
> show long list of <inactive>

I think what it should do is to execute test-cases _internally_. Not 
just execute some random command on the system and hope for events.

> I think better I should support all events in perf stat so user 
> can get better information from it and we can all add some other 
> testing option to it.

I agree - see my previous mail about how to achieve this better: we 
should extend event string parsing with wildcards (regex) and with 
'set of events' symbols that act as convenient specifiers for 
certain typical uses.

> Anyway currently it looks like this :
> 
> [RFC][PATCH] perf_counter tools: introduce perf test to test event for ticks
> 
> perf test to Test performance counter events, its output on AMD box :
> 
> ./perf test -a -- ls -lR > /dev/null
> 
>  Performance counter stats for 'ls' -lR:
> 
>  cycles                                             1226819954
>  instructions                                        283680441
>  cache-references                                    144893559
>  cache-misses                                          3268438
>  branches                                             37488241
>  branch-misses                                         2464027
>  bus-cycles                                         <inactive>
>  cpu-clock-msecs                                   17175506056
>  task-clock-msecs                                  17175086665
>  page-faults                                               488
>  minor-faults                                              488
>  major-faults                                       <inactive>

We should try to provoke a real major fault (i.e. a fault with IO) 
here. Not sure how though :-)

>  context-switches                                         7956
>  CPU-migrations                                              7

this needs to be provoked intentionally via sched_setaffinity(): 
first migrate to cpu0, then to cpu1.

>  L1-data-Cache-Load-Referencees                      398303881
>  L1-data-Cache-Load-Misses                             3552374
>  L1-data-Cache-Store-Referencees                        270178
>  L1-data-Cache-Store-Misses                         <inactive>

this is probably inactive due to AMD not having events for that and 
the generic cache event being 0 there, right?

>  L1-data-Cache-Prefetch-Referencees                     611622
>  L1-data-Cache-Prefetch-Misses                          399730
>  L1-instruction-Cache-Load-Referencees               124696447
>  L1-instruction-Cache-Load-Misses                      2912802
>  L1-instruction-Cache-Store-Referencees             <inactive>
>  L1-instruction-Cache-Store-Misses                  <inactive>
>  L1-instruction-Cache-Prefetch-Referencees              156576
>  L1-instruction-Cache-Prefetch-Misses               <inactive>
>  L2-Cache-Load-Referencees                             4312353
>  L2-Cache-Load-Misses                                   470382
>  L2-Cache-Store-Referencees                            4392945
>  L2-Cache-Store-Misses                              <inactive>
>  L2-Cache-Prefetch-Referencees                      <inactive>
>  L2-Cache-Prefetch-Misses                           <inactive>
>  Data-TLB-Cache-Load-Referencees                     127076487
>  Data-TLB-Cache-Load-Misses                            1930048
>  Data-TLB-Cache-Store-Referencees                   <inactive>
>  Data-TLB-Cache-Store-Misses                        <inactive>
>  Data-TLB-Cache-Prefetch-Referencees                <inactive>
>  Data-TLB-Cache-Prefetch-Misses                     <inactive>
>  Instruction-TLB-Cache-Load-Referencees              132768077
>  Instruction-TLB-Cache-Load-Misses                        6406
>  Instruction-TLB-Cache-Store-Referencees            <inactive>
>  Instruction-TLB-Cache-Store-Misses                 <inactive>
>  Instruction-TLB-Cache-Prefetch-Referencees         <inactive>
>  Instruction-TLB-Cache-Prefetch-Misses              <inactive>
>  Branch-Cache-Load-Referencees                        58030210
>  Branch-Cache-Load-Misses                              3257804
>  Branch-Cache-Store-Referencees                     <inactive>
>  Branch-Cache-Store-Misses                          <inactive>
>  Branch-Cache-Prefetch-Referencees                  <inactive>
>  Branch-Cache-Prefetch-Misses                       <inactive>
> 
>     8.681671511  seconds time elapsed.

looks nice.

	Ingo

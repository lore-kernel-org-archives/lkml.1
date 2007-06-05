Return-Path: <linux-kernel-owner+w=401wt.eu-S1765671AbXFETu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765671AbXFETu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763526AbXFETuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:50:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762586AbXFETud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:50:33 -0400
Date: Tue, 5 Jun 2007 21:50:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605195015.GA24348@elte.hu>
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu> <20070604184106.GG11115@waste.org> <20070605071904.GB25163@elte.hu> <20070605140342.GR11115@waste.org> <b647ffbd0706050814u1e145b82qdb344d475d9ffe93@mail.gmail.com> <b647ffbd0706050841v2a326fb4n128249131ccbc11a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0706050841v2a326fb4n128249131ccbc11a@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> On 05/06/07, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> >> now at 257428593818894 nsecs
> >>
> >> cpu: 0
> >>   .nr_running            : 3
> >>   .raw_weighted_load     : 2063
> >>   .nr_switches           : 242830075
> >>   .nr_load_updates       : 30172063
> >>   .nr_uninterruptible    : 0
> >>   .jiffies               : 64282148
> >>   .next_balance          : 0
> >>   .curr->pid             : 27182
> >>   .clock                 : 125650217819008823
> >>   .prev_clock_raw        : 257428516403535
> >
> >The delta (clock - prev_clock_raw) looks insane.
> >
> 
> err.. please ignore it. 'clock' and 'prev_clock_raw' follow each other 
> only as long as the 'clock_warps' == 0.. otherwise 'delta' just 
> doesn't make any sense. And in your case:
> 
>  .clock_warps           : 9

yeah. Look at the sched_clock() reliability counts:

  .clock_warps           : 9
  .clock_unstable_events : 41133344
  .clock_max_delta       : 3954619

i.e. a quite large 'tsc unstable events' counter and with a handful 
negative warps detected, the actual maximum TSC delta was 3954 usecs 
(clock_max_delta), so i think rq_clock() behaved sane and sched_clock() 
has good quality on Matt's box. So the large block_max is still 
mysterious to me:

  > > sleep_max                :         57476665627
  > > block_max                :   18014060106626075

because the whole rq_clock() logic is about avoiding large jumps. So i 
dont see how 'now' could _ever_ have ended up being so very large. Even 
if the new sched-clock code in arch/i386/kernel/sched-clock.c frequently 
switches between sc->unstable == 0 or 1, (i.e. frequently switches 
between jiffies based and TSC based clock), the rq_clock() logic should 
cushion off any jumpiness or small warps from that. I'm wondering 
whether this line:

                r = (jiffies_64 - sc->sync_base) * (1000000000 / HZ);

could produce funnies. But even if it does, it could at most produce a 
very large _positive_ jump - which they would have to show up in 
clock_max_delta. Negative jumps are completely ignored by rq_clock(). 

although ... the 'raw' rq_clock() values are very large:

  .clock                 : 125650217819008823

  $ printf "%016Lx\n" 125650217819008823
  01be6635170d6f37

which could be due to some TSC corruption? So perhaps somewhere we 
calculated block_max with 'now' zero, hence resulting in that very large 
value? Still, i dont see how that could happen. Weird.

it would be nice to monitor how 'clock' changes in time on that box. It 
should be advancing monotonically and at most with the speed of the CPU 
clock. (but it can move slower, over C3/unstable/cpufreq periods.) This 
could be done the following way:

   while sleep 1; do cat /proc/sched_debug >> sched_debug.txt; done

Matt, could you run this for 1-2 minutes and send us the sched_debug.txt 
output?

	Ingo

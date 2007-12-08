Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbXLHTwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbXLHTwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXLHTwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:52:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54669 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXLHTwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:52:43 -0500
Date: Sat, 8 Dec 2007 20:52:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071208195211.GA3727@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org> <20071208100950.a3547868.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > But I don't think we need to do anything for 2.6.24..
> 
> Good. Although we should perhaps look at that reported performance 
> problem with SLUB. It looks like SLUB will do a memclear() for the 
> area twice (first for the whole page, then for the thing it allocated) 
> for the slow case. Maybe that exacerbates the problem.

i dont think the SLUB problem could be explained purely via a double 
memset(). [which ought to be extremely fast anyway] We are talking about 
a 10 times slowdown on a 64-way box of a workload that is fairly 
common-sense. (tasks sending messages to each other via bog standard 
means)

while i dont want to jump to conclusions without looking at some 
profiles, i think the SLUB performance regression is indicative of the 
following fallacy: "SLAB can be done significantly simpler while keeping 
the same performance".

I couldnt point to any particular aspect of SLAB that i could 
characterise as "needless bloat".

the SLUB concept is proudly outlined in init/Kconfig:

  config SLUB
        bool "SLUB (Unqueued Allocator)"
        help
           SLUB is a slab allocator that minimizes cache line usage
           instead of managing queues of cached objects (SLAB approach).
           Per cpu caching is realized using slabs of objects instead
           of queues of objects. SLUB can use memory efficiently
           and has enhanced diagnostics.

but that's not true anymore - the two concepts are pretty much 
equivalent, after all the "performance tuning" that went on in SLUB. 
(read: 'frantically try to catch up with SLAB in benchmarks')

so even today's upstream kernel, which has 'ancient' SLUB code, SLAB and 
SLUB have essentially the same linecount:

  $ wc -l mm/slab.c mm/slub.c
  4478 mm/slab.c
  4125 mm/slub.c

(and while linecount != complexity, there is a strong relationship.)

With SLAB having 10 years more test coverage and tuning.

the messiest and most fragile aspect of SLAB that i can think of is its 
bootstrap hacks - but that is an entirely unimportant detail in my 
opinion. SLAB has been cleaned up significantly in the past few years by 
Pekka Enberg & co, it's pretty pleasant and straightforward code these 
days.

I think we should we make SLAB the default for v2.6.24 ...

	Ingo

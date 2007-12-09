Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbXLIIvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbXLIIvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 03:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXLIIvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 03:51:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48030 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbXLIIu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 03:50:59 -0500
Date: Sun, 9 Dec 2007 09:50:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071209085030.GA14264@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org> <20071208100950.a3547868.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org> <20071208195211.GA3727@elte.hu> <20071208202930.GA17934@elte.hu> <84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Dec 8, 2007 10:29 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > so it has a "free list", which is clearly per cpu. Hang on! Isnt that
> > actually a per CPU queue? Which SLUB has not, we are told? The "U" in
> > SLUB. How on earth can an allocator in 2007 claim to have no queuing
> > (which is in essence caching)? Am i on crack with this? Did i miss
> > something really obvious?
> 
> I think you did. The difference is explained in Christoph's 
> announcement:
> 
> "A particular concern was the complex management of the numerous 
> object queues in SLAB. SLUB has no such queues. Instead we dedicate a 
> slab for each allocating CPU and use objects from a slab directly 
> instead of queueing them up."
> 
> Which, I think, is where SLUB gets its name from (the "unqueued" 
> part).

yes, i understand the initial announcement (and the Kconfig entry still 
says the same), but that is not matched up by the reality i see in the 
actual code - SLUB clearly uses a queue/list of objects (as cited in my 
previous mail), for obvious performance reasons.

unless i'm missing something obvious (and i easily might), i see SLUB as 
SLAB reimplemented with a different queueing model. Not "without 
queueing".

> Now, while SLAB code is "pleasant and straightforward code" (thanks, 
> btw) for UMA, it's really hairy for NUMA plus the "alien caches" eat 
> tons of memory (which is why Christoph wrote SLUB in the first place, 
> the current code in SLAB is mostly unfixable due to its *queuing* 
> nature).

i'm curious about the real facts behind this "alien cache problem". I 
heard about it and asked around and was told that there's some sort of 
bad quadratic behavior of memory consumption on NUMA - but i cannot 
actually see that in the code.

The alien caches feature of SLAB i see as a spread out clustered 
index/cache of objects on other nodes. It's not increasing the average 
per object memory consumption per se! The number of alien caches 
increases with increasing number of nodes, but _of course_, as memory 
size increases too so there's more stuff and a larger expected spreadout 
of memory to keep track of. ("Fixing" that would be like reintroducing a 
single runqueue for the scheduler, based on the argument that it's an 
O(1) number of runqueues against O(N) number of runqueues - which would 
be complete nonsense.)

so i see SLAB alien caches as an automatic self-partitioning mechanism 
... which has complexities but which also has _obvious_ performance 
benefits. Yes, it has some disadvantages like all caching schemes do - 
there's more cached memory tied up in the allocator at any given moment 
- but arguing against that would be like arguing against a 2MB L2 cache 
purely on the basis that a 1MB L2 cache is smaller and hence more 
space-efficient. Caches are there to cache stuff, and more caches ... 
use more memory. It's all a question of proportion and tuning, but the 
_design_ should be based on having as thorough caching as possible.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbXLILwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbXLILwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 06:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXLILwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 06:52:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41143 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXLILwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 06:52:05 -0500
Date: Sun, 9 Dec 2007 12:51:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071209115139.GA29518@elte.hu>
References: <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org> <20071208100950.a3547868.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org> <20071208195211.GA3727@elte.hu> <20071208202930.GA17934@elte.hu> <84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com> <20071209085030.GA14264@elte.hu> <84144f020712090118w27225592w8933ee2314db7556@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020712090118w27225592w8933ee2314db7556@mail.gmail.com>
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

> I mostly live in the legacy 32-bit UMA/UP land still so I cannot 
> verify this myself but the kind folks at SGI claim the following 
> (again from the announcement):
> 
> "On our systems with 1k nodes / processors we have several gigabytes
>  just tied up for storing references to objects for those queues This 
>  does not include the objects that could be on those queues. One fears 
>  that the whole memory of the machine could one day be consumed by 
>  those queues."

Yes, you can find gigs tied up on systems that have 100 GB of RAM, or 
you can have gigs tied up if you over-size your caches. I'd like to see 
an accurate calculation done on this.

> The problem is that for each cache, you have an "per-node alien 
> queues" for each node (see struct kmem_cache nodelists -> struct 
> kmem_list3 alien). Moving slab metadata to struct page solves this but 
> now you can only have one "queue" thats part of the same struct.

yes, it's what i referred to as "distributed, per node cache". It has no 
"quadratic overhead". It has SLAB memory spread out amongst nodes. I.e. 
1 million pages are distributed amongst 1k nodes with 1000 pages per 
node with each node having 1 page.

But that memory is not lost and it's disingenous to call it 'overhead' 
and it very much comes handy for performance _IF_ there's global 
workload that involves cross-node allocations. It's simply a cache that 
is mis-sized and mis-constructed on large node count systems but i bet 
it makes quite a performance difference on low-node-count systems.

On high node-count systems it might make sense to reduce the amount of 
cross-node caching and to _structure_ the distributed NUMA SLAB cache in 
an intelligent way (perhaps along cpuset boundaries) - but a total, 
design level _elimination_ of this caching concept, using very 
misleading arguments, just looks stupid to me ...

	Ingo

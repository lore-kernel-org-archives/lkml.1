Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbXLIMfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbXLIMfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 07:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXLIMfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 07:35:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56292 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXLIMfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 07:35:04 -0500
Date: Sun, 9 Dec 2007 13:34:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071209123441.GA21893@elte.hu>
References: <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org> <20071208100950.a3547868.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org> <20071208195211.GA3727@elte.hu> <20071208202930.GA17934@elte.hu> <84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com> <20071209085030.GA14264@elte.hu> <84144f020712090118w27225592w8933ee2314db7556@mail.gmail.com> <20071209115139.GA29518@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209115139.GA29518@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > The problem is that for each cache, you have an "per-node alien 
> > queues" for each node (see struct kmem_cache nodelists -> struct 
> > kmem_list3 alien). Moving slab metadata to struct page solves this 
> > but now you can only have one "queue" thats part of the same struct.
> 
> yes, it's what i referred to as "distributed, per node cache". It has 
> no "quadratic overhead". It has SLAB memory spread out amongst nodes. 
> I.e. 1 million pages are distributed amongst 1k nodes with 1000 pages 
> per node with each node having 1 page.
> 
> But that memory is not lost and it's disingenous to call it 'overhead' 
> and it very much comes handy for performance _IF_ there's global 
> workload that involves cross-node allocations. It's simply a cache 
> that is mis-sized and mis-constructed on large node count systems but 
> i bet it makes quite a performance difference on low-node-count 
> systems.
> 
> On high node-count systems it might make sense to reduce the amount of 
> cross-node caching and to _structure_ the distributed NUMA SLAB cache 
> in an intelligent way (perhaps along cpuset boundaries) [...]

i think much of this could be achieved by delaying the creation of alien 
caches up until the point a { node X } -> { node Y } alloc/free 
relationship gets established. So if a system is partitioned along 
cpusets, vast areas of the NxN matrix never gets populated with alien 
caches.

	Ingo

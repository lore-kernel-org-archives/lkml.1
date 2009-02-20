Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZBTJdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZBTJdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 04:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZBTJdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 04:33:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZBTJc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:32:58 -0500
Date: Fri, 20 Feb 2009 10:32:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
Message-ID: <20090220093234.GF24555@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499E20BC.4020408@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Ingo Molnar wrote:
> > * Tejun Heo <tj@kernel.org> wrote:
> > 
> >> Tejun Heo wrote:
> >>>   One trick we can do is to reserve the initial chunk in non-vmalloc
> >>>   area so that at least the static cpu ones and whatever gets
> >>>   allocated in the first chunk is served by regular large page
> >>>   mappings.  Given that those are most frequent visited ones, this
> >>>   could be a nice compromise - no noticeable penalty for usual cases
> >>>   yet allowing scalability for unusual cases.  If this is something
> >>>   which can be agreed on, I'll pursue this.
> >> I've given more thought to this and it actually will solve 
> >> most of issues for non-NUMA but it can't be done for NUMA.  
> >> Any better ideas?
> > 
> > It could be allocated via NUMA-aware bootmem allocations.
> 
> Hmmm... not really.  Here's what I was planning to do on non-NUMA.
> 
>   Allocate the first chunk using alloc_bootmem().  After setting up
>   each unit, give back extra space sans the initialized static area
>   and some amount of free space which should be enough for common
>   cases by calling free_bootmem().  Mark the returned space as used in
>   the chunk map.
> 
> This will allow sane chunk size and scalability without adding 
> TLB pressure, so it's actually pretty sweet.  Unfortunately, 
> this doesn't really work for NUMA because we don't have 
> control over how NUMA addresses are laid out so we can't 
> allocate contiguous NUMA-correct chunk without remapping.  And 
> if we remap, we can't give back what's left to the allocator.  
> Giving back the original address doubles TLB usage and giving 
> back the remapped address breaks __pa/__va.  :-(

Where's the problem? Via bootmem we can allocate an arbitrarily 
large, properly NUMA-affine, well-aligned, linear, large-TLB 
piece of memory, for each CPU.

We should allocate a large enough chunk for the static percpu 
variables, and remap them using 2MB mapping[s].

I'm not sure where the desire for 'chunking' below 2MB comes 
from - there's no real benefit from it - the TLB will either be 
4K or 2MB, going inbetween makes little sense.

So i think the best (and simplest) approach is to:

 - allocate the static percpu area using bootmem-alloc, but 
   using a 2MB alignment parameter and a 2MB aligned size. Then 
   we can remap it to some convenient and undisturbed virtual 
   memory area, using 2MB TLBs. [*]

 - The 'partial' bit of the 2MB page (the one that is outside 
   the 4K-uprounded portion of __per_cpu_end - __per_cpu_start) 
   can then be freed via bootmem and is available as regular 
   pages to the rest of the kernel.

 - Then we start dynamic allocations at the _next_ 2MB boundary 
   in the virtual remapped space, and use 4K mappings from that 
   point on. Since at least initially we dont want to waste a 
   full 2MB page on dynamic allocations, we've got no choice but 
   to use 4K pages.

 - This means that percpu_alloc() will not return a pointer to 
   an array of percpu pointers - but will return a standard 
   offset that is valid in each percpu area and points to 
   somewhere beyond the 2MB boundary that comes after the 
   initial static area. This means it needs some minimal memory 
   management - but it all looks relatively straightforward.

So the virtual memory area will be continous, with a 'hole' in 
it that separates the static and dynamic portions, and dynamic 
percpu pointers will point straight into it [with a %gs offset] 
- without an intermediary array of pointers.

No chunking, no fuss - just bootmem plus 4K allocations - the 
best of both worlds.

This also means we've essentially eliminated the boundary 
between static and dynamic APIs, and can probably use some of 
the same direct assembly optimizations (on x86) for local-CPU 
dynamic percpu accesses too. [maybe not all addressing modes are 
possible straight away, this needs a more precise check.]

	Ingo

[*] Note: the 2MB up-rounding bootmem trick above is needed to 
          make sure the partial 2MB page is still fully RAM - 
          it's not well-specified to have a PAT-incompatible 
          area (unmapped RAM, device memory, etc.) in that hole.


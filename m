Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZBUHKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZBUHKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 02:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZBUHK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 02:10:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:47111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZBUHK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 02:10:27 -0500
Message-ID: <499FA8D1.8030806@kernel.org>
Date: Sat, 21 Feb 2009 16:10:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org> <20090220093234.GF24555@elte.hu>
In-Reply-To: <20090220093234.GF24555@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Feb 2009 07:09:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> Where's the problem? Via bootmem we can allocate an arbitrarily 
> large, properly NUMA-affine, well-aligned, linear, large-TLB 
> piece of memory, for each CPU.

I wish it was that peachy.  The problem is the added TLB pressure.

> We should allocate a large enough chunk for the static percpu 
> variables, and remap them using 2MB mapping[s].
> 
> I'm not sure where the desire for 'chunking' below 2MB comes 
> from - there's no real benefit from it - the TLB will either be 
> 4K or 2MB, going inbetween makes little sense.

Making the 'chunk' size 2MB would be useful for non-NUMA.  For NUMA,
making the 'chunk' size 2MB doesn't help much.  For unit size, 4k is
the minimum and 2MB is a meaningful boundary if percpu area gets
sufficiently large as large page mapping can be used for NUMA.  For
chunk size, 4k * num_possible_cpus() is the minimum and 2MB is a
meaningful boundary for !NUMA and 2MB * num_possible_cpus() for NUMA.

Anything between 4k and one of the meaningful boundaries doesn't make
much difference other than the chunk size needs to be at least as
large as the maximum supported allocation.  If it's above certain
limit, going large doesn't provide much benefit.  Given the tight vm
situation on 32bits, there simply isn't good reason to default to 2MB
unless large mapping is gonna be used.

> So i think the best (and simplest) approach is to:
> 
>  - allocate the static percpu area using bootmem-alloc, but 
>    using a 2MB alignment parameter and a 2MB aligned size. Then 
>    we can remap it to some convenient and undisturbed virtual 
>    memory area, using 2MB TLBs. [*]
> 
>  - The 'partial' bit of the 2MB page (the one that is outside 
>    the 4K-uprounded portion of __per_cpu_end - __per_cpu_start) 
>    can then be freed via bootmem and is available as regular 
>    pages to the rest of the kernel.

Heh... that's exactly where the problem is.  If you remap and free
what's left.  The remapped area and the freed area will use two
separate 2MB TLBs instead of one.  It's probably worse than simply
using 4k mappings.

On !NUMA, we can get away with this because the static percpu area
doesn't need to be remapped so the physical mapping can used unchanged
and what's left can be returned to the system.  On NUMA, we need remap
so we can't easily return what's left.

>  - Then we start dynamic allocations at the _next_ 2MB boundary 
>    in the virtual remapped space, and use 4K mappings from that 
>    point on. Since at least initially we dont want to waste a 
>    full 2MB page on dynamic allocations, we've got no choice but 
>    to use 4K pages.

It will be better to reserve some area for dynamic allocation so that
usual percpu allocations can be served by the initial mapping, which
tends to be pretty small on usual configurations.

>  - This means that percpu_alloc() will not return a pointer to 
>    an array of percpu pointers - but will return a standard 
>    offset that is valid in each percpu area and points to 
>    somewhere beyond the 2MB boundary that comes after the 
>    initial static area. This means it needs some minimal memory 
>    management - but it all looks relatively straightforward.
>
> So the virtual memory area will be continous, with a 'hole' in 
> it that separates the static and dynamic portions, and dynamic 
> percpu pointers will point straight into it [with a %gs offset] 
> - without an intermediary array of pointers.
> 
> No chunking, no fuss - just bootmem plus 4K allocations - the 
> best of both worlds.

The new percpu_alloc() already does that.  Chunking or not makes no
difference on this regard.  The only difference whether there are more
holes in the allocated percpu addresses or not, which basically is
irrelevant and chunking makes things much more flexible and scalable.
ie. It can scale toward many many cpus or large large percpu areas
wheras making the areas contiguous make the scalability determined by
the product of the two.

Also, contiguous per-cpu areas might look simpler but it actually is
more complicated because it becomes much more arch dependent.  With
chunking, the complexity is in generic code as virtual address and
stuff are already in place.  If the cpu areas need to be made
contiguous, the generic code will get simpler but each arch needs to
come up with new address space layout.

There simply isn't any measurable advantage to making the area
contiguous.

> This also means we've essentially eliminated the boundary 
> between static and dynamic APIs, and can probably use some of 
> the same direct assembly optimizations (on x86) for local-CPU 
> dynamic percpu accesses too. [maybe not all addressing modes are 
> possible straight away, this needs a more precise check.]

The posted patchset already does that.  Please take a look at the new
per_cpu_ptr().  It's basically &per_cpu().  Unifying accessors is the
next step and I'm planning to conslidate local_t implementation into
it too but I think all that depends on we agreeing on the allocator.
I can remove the TLB problem from non-NUMA case but for NUMA I still
don't have a good idea.  Maybe we need to accept the overhead for
NUMA?  I don't know.

Thanks.

-- 
tejun

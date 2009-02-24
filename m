Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZBXLs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZBXLs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 06:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZBXLsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 06:48:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:51913 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbZBXLsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 06:48:40 -0500
Message-ID: <49A3DE76.5010606@kernel.org>
Date: Tue, 24 Feb 2009 20:48:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk	allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu>
In-Reply-To: <20090224095708.GA20739@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 11:48:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> Hm, i think there still must be some basic misunderstanding 
> somewhere here. Let me describe the design i described in the 
> previous mail in more detail.
> 
> In one of your changelogs you state:
> 
> |    On NUMA, embedding allocator can't be used as different 
> |    units can't be made to fall in the correct NUMA nodes.
> 
> This is a direct consequence of the unit/chunk abstraction,

Not at all.  That's an optimization for !NUMA.  The remap allocator is
what can be done on NUMA.  Chunking or not doesn't make any difference
in this regard.  The only difference between chunking and not chunking
is whether separately allocated percpu offsets have more or less holes
inbetween them, which is irrelevant for all purposes.

> and i think that abstraction is wrong.

No, it's not wrong.  It simply is irrelevant - it's congruent
vs. contiguos and all that we need is congruent.  Contiguous of course
achieves congruent but it doesn't make any difference for this
purpose.

Please take a look at the remap allocator.  That's what you had in
mind for the contiguos mapping.  The embedding allocator is an
improvement specifically for !NUMA so that it doesn't even have to
spend the single extra TLB entry for the first 2MB page, which BTW
would be impossible with contiguous mapping.

> What i'm suggesting is to have a simple continuous [non-chunked, 
> with a hole in the last bits of the first 2MB] virtual memory 
> range for each CPU.
> 
> This special virtual memory starts with a 2MB page (for the 
> static bits - perhaps also with a default starter dynamic area 
> appended to that - we can size this reasonably) and continues 
> with 4K mappings at the next 2MB boundary and goes on linearly 
> from that point on.
> 
> The variables within this singular 'percpu area' mirror each 
> other amongst CPUs. So if a dynamic (or static) percpu variable 
> is at offset 156100 in CPU#5's range - then it will be at offset 
> 156100 in CPU#11's percpu area too. Each of these areas are 
> tightly packed with that CPU's allocations (and only that CPU's 
> allocations), there's no chunking, no units.

Yes, I did understand that and did reply that in my previous email.

=== QUOTE ===
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
=== END OF QUOTE ===

> As with your proposal this tears down the current artificial 
> distinction between static and dynamic percpu variables.
>
> But with this approach we'd the following additional advantages:
> 
> - No dynamic-alloc single-allocation size limits _at all_ in 
>   practice. [up to the total size of the virtual memory window]
> 
>   ( With your current proposal the dynamic alloc is limited to
>     unit size - which is looks a bit inflexible as unit size
>     impacts other characteristics so when we want to increase 
>     the dynamic allocation size we'd also affect other areas of 
>     the code. )
> 
>   percpu_alloc() would become as limitless (on 64-bit) as 
>   vmalloc().

There is no artificial limit on unit_size.  Contiguous is special form
of congruent and thus it simply can't be more flexible than congruent.
If the maximum allocation size is somthing to worry about just bumping
the MIN constant should do the trick at the cost of consuming more
virtual address, but seriously I don't think the maximum allocation
size is something we need to worry about.  64k is way more than
enough.

> - no NUMA complications and no NUMA assymetry at all. When we 
>   extend a CPU's percpu area we do NUMA-local allocations to 
>   that CPU. The memory allocated is purely for that CPU's 
>   purpose.

Chunking or not doesn't make any difference in this regard.  The
posted allocator does exactly what you described above.

> - We'd have a very 'compressed' pte presence in the pagetables: 
>   the dynamic percpu area is as tightly packed as possible. With 
>   a chunked design we 'scatter' the ptes a bit more broadly.

Can you please elaborate a bit?

If you're worried about packing, with the current usage pattern, it
doesn't matter at all.  There are lots of small allocations and larger
ones often need small alignment.  They pack alright.

> The only thing that gets a bit trickier is sizing - but not by 
> much. The best way we can size this without practical 
> complications on very small or very large systems would by 
> setting the maximum _combined_ size for all percpu allocations.
> 
> Say we set this 'PERCPU_TOTAL' limit to 4 GB. That means that if 
> there are 8 possible CPUs, each CPU can have up to 512 MB of 
> RAM. That's plenty in practice.
> 
> We can do this splitup dynamically during bootup, because the 
> area is still fully linear, relative to the percpu offset.

I think it's a pretty big problem on 32bit and also it makes
implementing dynamic allocator much more involved for each arch wheras
chunking puts the complexity at the generic code and just uses the
existing vmalloc address mapping.  I really can't see advantage of
contiguous allocation.

> [ A system with 4k CPUs would want to have a larger PERCPU_TOTAL 
>   - but obviously it cannot be really mind-blowingly large 
>   because the total max has to be backed up with real RAM. So 
>   realistically we wont have more than 1TB in the next 10 years 
>   or so. Which is still well below the limitations of the 64-bit 
>   address space. ]

With chunking, we simply don't have to think about any of this.

> In a non-chunked allocator the whole bitmap management becomes 
> much simpler and more straightforward as well. It's also much 
> easier to think about than an interleaved unit+chunk design.

I don't know.  The bitmap allocator itself would be the same.  It's
just that with chunking we have multiple of them and complexities are
added when choosing where to allocate and reverse mapping pointer to
its chunk.  I think it's reasonably straight forward as it is.

Plus, it's not like we'll be able to do things as simple as
module_percpu allocator does anyway.  If we map/unmap pages using
highest allocated mark, single allocation can hold up vast amount of
memory.  If we start depopulating in the middle, we no longer can use
simple bitmap allocator and try to group allocations so that we don't
waste a lot of pages.  Reclamation is one of the reasons why I chose
chunking.

> The only special complication is the setup of the initial 2MB 
> area - but that is tricky to bootstrap anyway because we need to 
> set it up before the page allocator gets initialized. It's also 
> worthwile to put the most common percpu variables, and an 
> expected amount of dynamic area into a 2MB TLB.

Yeah, it's bootstrapping.  No matter what we do, it's gonna be a
little bit hairy.

Thanks.

-- 
tejun

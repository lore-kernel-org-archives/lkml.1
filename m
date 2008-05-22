Return-Path: <linux-kernel-owner+w=401wt.eu-S935245AbYEVAeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245AbYEVAeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762559AbYEVAeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:34:15 -0400
Received: from saeurebad.de ([85.214.36.134]:49089 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896AbYEVAeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:34:14 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       yhlu.kernel@gmail.com, ralf@linux-mips.org, rth@twiddle.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, kyle@parisc-linux.org, paulus@samba.org,
       lethal@linux-sh.org, davem@davemloft.net
Subject: Re: [RFC 0/3] bootmem rewrite
References: <20080521013735.559724194@saeurebad.de>
	<20080521165735.10c500dc.akpm@linux-foundation.org>
Date: Thu, 22 May 2008 02:33:45 +0200
In-Reply-To: <20080521165735.10c500dc.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 May 2008 16:57:35 -0700")
Message-ID: <87hccr2n4m.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 21 May 2008 03:37:35 +0200
> Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> Hi,
>> 
>> This is a complete overhaul of the bootmem allocator while preserving
>> its original functionality, excluding bugs.
>
> Where angels fear to tread.

Anyone who has seen this code realizes that this kind of advertisment is
essential to get people looking at patches for it ;)

>> free_bootmem and reserve_bootmem become a bit stricter than they are
>> right now, callsites have to make sure that the PFN range is
>> contiguous but it might go across node boundaries.
>> 
>> alloc_bootmem satisfying the allocation goal is more likely as the
>> routines will try to allocate on the node holding the goal first
>> before falling back as opposed to the original behaviour that
>> satisfies the goal only if it is on the first node.
>> 
>> All in all, I think the code has become simpler and cleaner.  All
>> public interfaces have been documented, too.
>> 
>> The first patch moves the bootmem node descriptor definitions into
>> bootmem.c where they belong.
>> 
>> The second patch is the new allocator itself.
>> 
>> The third patch converts all users of ->node_boot_start to
>> ->node_min_pfn as this is what they really use.  It then removes the
>> unused ->node_boot_start.
>> 
>> Compile and runtime tested on X86_32, therefor RFC only.
>> 
>>  arch/alpha/mm/numa.c             |    8 +-
>>  arch/arm/mm/discontig.c          |   34 +-
>>  arch/arm/plat-omap/fb.c          |    4 +-
>>  arch/avr32/mm/init.c             |    3 +-
>>  arch/ia64/mm/discontig.c         |   30 +-
>>  arch/m32r/mm/discontig.c         |    4 +-
>>  arch/m32r/mm/init.c              |    4 +-
>>  arch/m68k/mm/init.c              |    4 +-
>>  arch/mips/sgi-ip27/ip27-memory.c |    3 +-
>>  arch/mn10300/mm/init.c           |    6 +-
>>  arch/parisc/mm/init.c            |    3 +-
>>  arch/powerpc/mm/numa.c           |    3 +-
>>  arch/sh/mm/init.c                |    2 +-
>>  arch/sh/mm/numa.c                |    5 +-
>>  arch/sparc64/mm/init.c           |    3 +-
>>  arch/x86/mm/discontig_32.c       |    3 +-
>>  arch/x86/mm/numa_64.c            |    6 +-
>>  include/linux/bootmem.h          |  115 ++---
>>  mm/bootmem.c                     |  914 +++++++++++++++++++-------------------
>>  mm/page_alloc.c                  |    4 +-
>
> Oh gee.

Okay, seeing it again it looks a bit brutal.  But it's not.  The basic
principles are the same, it's not that I completely changed the
implementation.  Okay, perhaps I did.

And the arch changes are trivial.

> bootmem is an area where large numbers of people have done hit-and-run
> jobs over a lot of years.  Nobody owns it and I'm sure that you are now
> the world's expert.  We just need to push ahead with this, I guess.
>
> I expect there will be problems - so many architectures which do such
> different things, and all the configuration options churning things
> around.

I expect problems too.  I just can not go any further with it on the
resources I have.

> So how to move ahead with this?
>
> - I think I'd prefer not to drop
>
>   mm-fix-free_all_bootmem_core-alignment-check.patch
>   mm-normalize-internal-argument-passing-of-bootmem-data.patch
>   mm-unexport-__alloc_bootmem_core.patch
>
>   because those are small, simple things which are on track for
>   2.6.27 whereas a massive rewrite may take longer to get merged, and
>   may never get there at all, in which case we lost those little
>   fixes.

I can see that.

> - It would suit my purposes to have these patches right at the tail
>   of the -mm patch queue so that I can drop them easily if problems
>   occur, and so that others can revert them easily when diagnosing
>   problems.

Good.

> - It would be nice to get some review attention from architecture
>   guys, but I can understand them finding other things to do, when
>   bootmem is presumably good-enough-for-now.
>
> - Is x86_32 the only test platform which you have available?  Awkward.

Yes, unfortunately.  Hardware offers via private mail, please!

> Anyway, if you can redo these patches against most-recent-mm or,
> better, against http://userweb.kernel.org/~akpm/mmotm then it would
> make things easier for me to handle.  I can then at least test it all
> on my seven-odd test boxes.  Please feel free to ping me if you want a
> single rolled-up patch - that's always trivial and I can do it in three
> minutes.

I guess I just apply the quilt series to the tree you forked off?

> Finally, if you haven't done so, I'd encourage you to stuff as many
> handy debugging printks into this code as you possibly can.  Just fill
> 'er up with them.  So that when people start running it and it goes
> boom, they can send you their debug output _without_ having to go
> through another handful of email-email-patch-rebuild-retest cycles.  We
> can pull them all out later on.

Okay, I will make it gossip and send you a -mmotm-based version of it.

	Hannes

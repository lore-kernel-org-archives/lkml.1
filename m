Return-Path: <linux-kernel-owner+w=401wt.eu-S2992592AbXCBQcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992592AbXCBQcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992593AbXCBQcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:32:13 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:60941 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992592AbXCBQcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:32:10 -0500
Date: Fri, 2 Mar 2007 16:32:07 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302163206.GA1555@skynet.ie>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070301160915.6da876c5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On (01/03/07 16:09), Andrew Morton didst pronounce:
> On Thu, 1 Mar 2007 10:12:50 +0000
> mel@skynet.ie (Mel Gorman) wrote:
> 
> > Any opinion on merging these patches into -mm
> > for wider testing?
> 
> I'm a little reluctant to make changes to -mm's core mm unless those
> changes are reasonably certain to be on track for mainline, so let's talk
> about that.
> 

Sounds reasonable.

> What worries me is memory hot-unplug and per-container RSS limits.  We
> don't know how we're going to do either of these yet, and it could well be
> that the anti-frag work significantly complexicates whatever we end up
> doing there.
> 

Ok. I am going to assume as well that all these issues are not mutually
exclusive. To start with, anti-fragmentation in now really two things -
anti-fragmentation and memory partitioning

o Memory partitioning creates an additional zone with hard limits on usage
o Anti-fragmentation groups free pages based on mobility in MAX_ORDER blocks

They both help different things in different ways so it is important not
to conflate them as being the same thing. I would like them both in because
they complement each other nicely from a hugepages perspective.

> For prioritisation purposes I'd judge that memory hot-unplug is of similar
> value to the antifrag work (because memory hot-unplug permits DIMM
> poweroff).
> 
> And I'd judge that per-container RSS limits are of considerably more value
> than antifrag (in fact per-container RSS might be a superset of antifrag,
> in the sense that per-container RSS and containers could be abused to fix
> the i-cant-get-any-hugepages problem, dunno).
> 

It would be serious abuse and would be too easy to trigger OOM-like conditions
because of the constraints containers must work under to be useful. I'll
come back to this briefly later.

> So some urgent questions are: how are we going to do mem hotunplug and
> per-container RSS?
> 

The zone-based patches for memory partitioning should be providing what is
required for memory hot-remove of an entire DIMM or bank of memory (PPC64
also cares about removing smaller blocks of memory but zones are overkill
there and anti-fragmentation on its own is good enough).  Pages hot-added
to ZONE_MOVABLE will always be reclaimable or migratable in the case of
mlock(). Kamezawa Hiroyuki has indicated that his hot-remove patches also
do something like ZONE_MOVABLE. I would hope that his patches could be
easily based on top of my memory partitioning set of patches. The markup
of pages has been tested and the zone definitely works. I've added the
kamezawa.hiroyu@jp.fujitsu.com to the cc list so he can comment :)

What I do not do in my patchset is hot-add to ZONE_MOVABLE because I couldn't
be certain it's what the hotplug people wanted. They will of course need to
hot-add to that zone if they want to be able to remove it later.

For node-based memory hot-add and hot-remove, the node would consist of just
one populated zone - ZONE_MOVABLE.

For the removal of DIMMs, anti-fragmentation has something additional
to offer. The later patches in the anti-fragmentation patchset bias the
placement of unmovable pages towards the lower PFNs. It's not very strict
about this because being strict would cost. A mechanism could be put in place
that enforced the placement of unmovables pages at low PFNS. Due to the cost,
it would need to be disabled by default and enabled on request. On the plus
side, the cost would only be incurred when splitting a MAX_ORDER block of
pages which is a rare event.

One of the reasons why anti-frag doesn't negatively impact kernbench figures
in the majority of cases is because it's actually rare it kicks in to do
anything. Once pages are on the appropriate free lists, everything progresses
as normal.

> Our basic unit of memory management is the zone.  Right now, a zone maps
> onto some hardware-imposed thing.  But the zone-based MM works *well*.  I
> suspect that a good way to solve both per-container RSS and mem hotunplug
> is to split the zone concept away from its hardware limitations: create a
> "software zone" and a "hardware zone".

Ok, lets explore this notion a bit. I am thinking about this both in
terms of making RSS limits work properly and seeing if it collides with
anti-fragmentation or not.

Lets assume that a "hardware zone" is a management structure of pages that
have some addressing limitation. It might be 16MB for ISA devices, 4GB for
32 bit devices etc.

A "software zone" is a collection of pages belonging to a subsystem or
a process.  Containers are an example of a software zone.

That gives us a set of structures like

        Node
	 |
      --------
     /        \
hardware    hardware
zone          zone
              |   \--------------
              |    \             \
           main     container     container
   software zone   software zone  software zone

i.e. Each node has one hardware zone per "zone" today like ZONE_DMA, NORMAL
etc Each hardware zone consists of at least one software zone and an additional
software zone per container.

> All the existing page allocator and
> reclaim code remains basically unchanged, and it operates on "software
> zones". 

Ok. It means that counters and statistics will be per-software-zone instead
of per-hardware-zone. That means that most of the current struct zone would
be split in two.

However, to enforce the containers, software zones should not share pages. The
balancing problems would be considerable but worse, containers could interfere
with each other reducing their effectiveness. This is why anti-fragmentation
also should not be expressed as software zones. The case where the reclaimable
zone is too large and the movable zone is too compressed becomes difficult
to deal with in a sane manner.

> Each software zones always lies within a single hardware zone. 
> The software zones are resizeable.  For per-container RSS we give each
> container one (or perhaps multiple) resizeable software zones.
> 

Ok. That seems fair. I'll take a detour here and discuss how the number
of pages used by a container could be enforced. I'll then come back to
anti-fragmentation.

(reads through the RSS patches) The RSS patches have some notions vagely
related to software zones already.  I'm not convinced they enforce the number
of pages used by a container.

The hardware and software zones would look something like this (mainly taken
from the existing definition of struct zone). I've put big markers around
"new" stuff.

/* Hardware zones */
struct hardware_zone {

/* ==== NEW STUFF HERE ==== */
	/*
	 * Main software_zones. All allocations and pages by default
	 * come from this software_zone. Containers create their own
	 * and associate them with their mm_struct
	 *
	 * kswapd only operates within this software_zone. Containers
	 * are responsible for performing their own reclaim when they
	 * run out of pages
	 *
	 * If a new container is created and the required memory
	 * is not available in the hardware zone, it is taken from this
	 * software_zone. The pages taken from the software zone are
	 * contiguous if at all possible because otherwise it adds a new
	 * layer of fun to external fragmentation problems.
	 */
	struct software_zone 	*software_zone;
/* ==== END OF NEW STUFF ==== */

#ifdef CONFIG_NUMA
	int node;
#endif

	/*
	 * zone_start_pfn, spanned_pages and present_pages are all
	 * protected by span_seqlock.  It is a seqlock because it has
	 * to be read outside of zone->lock, and it is done in the main
	 * allocator path.  But, it is written quite infrequently.
	 *
	 * The lock is declared along with zone->lock because it is
	 * frequently read in proximity to zone->lock.  It's good to
	 * give them a chance of being in the same cacheline.
	 */
	unsigned long		spanned_pages;	/* total size, including holes */
	unsigned long		present_pages;	/* amount of memory (excluding holes) */

/* ==== MORE NEW STUFF ==== */
	/*
	 * These are free pages not associated with any software_zone
	 * yet. Software zones can request more pages if necessary
	 * but may not steal pages from each other. This is to 
	 * prevent containers from kicking each other
	 *
	 * Software zones should be given pages from here in as large
	 * as contiguous blocks as possible. This is to keep container
	 * memory grouped together as much as possible.
	 */
	spinlock_t		lock;
#ifdef CONFIG_MEMORY_HOTPLUG
	/* see spanned/present_pages for more description */
	seqlock_t		span_seqlock;
#endif
	struct free_area	free_pages[MAX_ORDER];
/* ==== END OF MORE NEW STUFF */

	/*
	 * rarely used fields:
	 */
	const char		*name;

};



/* Software zones */
struct software_zone {

/* ==== NEW STUFF ==== */
	/*
	 * Flags affecting how the software_zone behaves. These flags
	 * determine if the software_zone is allowed to request more
	 * pages from the hardware zone or not for example
	 *
	 * SZONE_CAN_TAKE_MORE: Takes more pages from hardware_zone
	 *			when low on memory instead of reclaiming.
	 *			The main software_zone has this, the
	 *			containers should not. They must reclaim
	 *			within the container or die
	 *
	 * SZONE_MOVABLE_ONLY: Only __GFP_MOVABLE pages are allocated
	 *			from here. If there are no pages left,
	 *			then the hardware zone is allocated
	 *			from if SZONE_CAN_TAKE_MORE is set.
	 *			This is very close to enforcing RSS
	 *			limits and a more sensible way of
	 *			doing things than the current RSS
	 *			patches
	 */
	unsigned long flags;

	/* The minimum size the software zone must be */
	unsigned long		min_nr_pages;

/* ==== END OF NEW STUFF ==== */

	/* Fields commonly accessed by the page allocator */
	unsigned long		pages_min, pages_low, pages_high;

	/*
	 * We don't know if the memory that we're going to allocate will be
	 * freeable or/and it will be released eventually, so to avoid totally
	 * wasting several GB of ram we must reserve some of the lower zone
	 * memory (otherwise we risk to run OOM on the lower zones despite
	 * there's tons of freeable ram on the higher zones). This array is
	 * recalculated at runtime if the sysctl_lowmem_reserve_ratio sysctl
	 * changes
	 */
	unsigned long		lowmem_reserve[MAX_NR_ZONES];

/* === LITTLE BIT OF NEW STUFF === */
	/* The parent hardware_zone */
	struct zone 		*hardware_zone;
/* === END AGAIN === */

#ifdef CONFIG_NUMA
	/*
	 * zone reclaim becomes active if more unmapped pages exist.
	 */
	unsigned long		min_unmapped_pages;
	unsigned long		min_slab_pages;
	struct per_cpu_pageset	*pageset[NR_CPUS];
#else
	struct per_cpu_pageset	pageset[NR_CPUS];
#endif
	/*
	 * free areas of different sizes
	 */
	spinlock_t		lock;
#ifdef CONFIG_MEMORY_HOTPLUG
	/* see spanned/present_pages for more description */
	seqlock_t		span_seqlock;
#endif
	struct free_area	free_area[MAX_ORDER];


	ZONE_PADDING(_pad1_)

	/* Fields commonly accessed by the page reclaim scanner */
	spinlock_t		lru_lock;	
	struct list_head	active_list;
	struct list_head	inactive_list;
	unsigned long		nr_scan_active;
	unsigned long		nr_scan_inactive;
	unsigned long		pages_scanned;	   /* since last reclaim */
	unsigned long		total_scanned;	   /* accumulated, may overflow */
	int			all_unreclaimable; /* All pages pinned */

	/* A count of how many reclaimers are scanning this zone */
	atomic_t		reclaim_in_progress;

	/* Zone statistics */
	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];

	/*
	 * prev_priority holds the scanning priority for this zone.  It is
	 * defined as the scanning priority at which we achieved our reclaim
	 * target at the previous try_to_free_pages() or balance_pgdat()
	 * invokation.
	 *
	 * We use prev_priority as a measure of how much stress page reclaim is
	 * under - it drives the swappiness decision: whether to unmap mapped
	 * pages.
	 *
	 * Access to both this field is quite racy even on uniprocessor.  But
	 * it is expected to average out OK.
	 */
	int prev_priority;


	ZONE_PADDING(_pad2_)
	/* Rarely used or read-mostly fields */

	/*
	 * wait_table		-- the array holding the hash table
	 * wait_table_hash_nr_entries	-- the size of the hash table array
	 * wait_table_bits	-- wait_table_size == (1 << wait_table_bits)
	 *
	 * The purpose of all these is to keep track of the people
	 * waiting for a page to become available and make them
	 * runnable again when possible. The trouble is that this
	 * consumes a lot of space, especially when so few things
	 * wait on pages at a given time. So instead of using
	 * per-page waitqueues, we use a waitqueue hash table.
	 *
	 * The bucket discipline is to sleep on the same queue when
	 * colliding and wake all in that wait queue when removing.
	 * When something wakes, it must check to be sure its page is
	 * truly available, a la thundering herd. The cost of a
	 * collision is great, but given the expected load of the
	 * table, they should be so rare as to be outweighed by the
	 * benefits from the saved space.
	 *
	 * __wait_on_page_locked() and unlock_page() in mm/filemap.c, are the
	 * primary users of these fields, and in mm/page_alloc.c
	 * free_area_init_core() performs the initialization of them.
	 */
	wait_queue_head_t	* wait_table;
	unsigned long		wait_table_hash_nr_entries;
	unsigned long		wait_table_bits;

	/*
	 * Discontig memory support fields.
	 */
	struct pglist_data	*zone_pgdat;
	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
	unsigned long		zone_start_pfn;

} ____cacheline_internodealigned_in_smp;



Hardware zones always have one software zone and it's all the the majority
of systems will have. Todays current behaviour is preserved and it's only
when containers come into play that things change.

A container could create a new software_zone with kmalloc (or a slab cache)
and associate it with their container management structure. They then set
the software zones min_nr_pages so that it gets populated with pages from
the hardware zone. If the hardware zone is depleted, it will take memory from
the main software zone in large contiguous chunks if possible. If anti-frag
is in place, the contiguous chunks will be available.

On allocation, buffered_rmqueue() checks for the presence of a software_zone
for the current mm and if it exists, use it. Otherwise zone->software_zone
is used to satisfy the allocation. This allows containers to use the core
page allocation code without altering it in a very significant way (main
alteration is to use software_zone instead of zone). 

As software zones are used on allocation, RSS limits are enforced without
worrying about the definition of RSS because it's all about availability
of pages. It would be able to do this with the existing infrastructure, not
additional bean counting. There is confusion about the exact definition of RSS
that was never really pinned down from what I can see. My understanding also
is that we don't care about individual processes as such, or even RSS but we
are concerned with the number of pages all the processes within a container
are using.  With software zones, hard limitations on the number of usable
pages can be enforced and all the zone-related infrastructure is there to help.

If shared page accounting is a concern, then what is needed are pairs of
software zones. A container has a private page container that enforces
allocations of private pages. They then use a second software_zone for
shared pages.  Multiple containers may share a software zone for shared
pages so that one container is not unfairly penalised for being the first
container to mmap() MAP_SHARED for example.

If a container runs low on memory, it reclaims pages within the LRU lists
of the software zones it has access to. If it fails to reclaim, it has a
mini-OOM and the OOM killer would need to be sure to target processes in the
container, not elsewhere. I'm not dealing with slab-reclaim here because it
is a issue deserving a discussion all to itself.

All this avoids creating unbounded number of zones that can fallback to each
other. While there may be large numbers of zones, there is no additional
search complexity because they are not related to each other except that
they belong to the same hardware zone.

On free, the software_zone the page belongs to needs to be discovered. There
are a few options that should be no suprise to anyone.

1. Use page bits to store the ID of the software zone. Only doable on 64 bit
2. Use an additional field in struct page for 32 bit (yuck)
3. If anti-frag is in place, only populate software zones with MAX_ORDER sized
   blocks. Use the pageblock bits (patch 1 in anti-frag) to map blocks of pages
   with software zones. This *might* limit the creation of new containers at
   runtime because of external fragmentation.
4. Have kswapd and asynchronous reclaim always go to the main software
   zone. Containers will always be doing direct reclaim because otherwise
   they can interfere with other containers. On free, they know the software
   zone to free to. If IO must be performed, they block waiting for the page
   to free and then free to the correct software zone

Of these, 4 seems like a reasonable choice. Containers that are
under-provisioned will feel the penalty directly by having to wait to perform
their own IO. They will not be able to steal pages from other containers in
any fashion so thje damage will be contained (pun not intended).

I think this covers the RSS-limitation requirements in the context of
software zones.


Now... how does this interact adversely with anti-fragmentation - well, it
doesn't really.  Anti-fragmentation will be mainly concerned with grouping
pages within the main software_zone. It will also group within the container
software zones although the containers probably do not care. The crossover is
when the hardware zone is taking pages for a new container, it will interact
with anti-fragmentation to get large contiguous regions if possible.  We will
not be creating a software zone for each migrate type because sizing those
and balancing them becomes a serious issue and an unnecessary one.

Anti-fragmentations work is really at the __rmqueue() level, not the higher
levels. The higher levels would be concerned with selecting the right software
zone to use and that is where containers should be working because they are
concerned about reclaim as well as page availability.

So. Even if the software_zone concept was developed and anti-fragmentation
was already in place, I do not believe they would collide in a
horrible-to-deal-with fashion.

> For memory hotunplug, some of the hardware zone's software zones are marked
> reclaimable and some are not; DIMMs which are wholly within reclaimable
> zones can be depopulated and powered off or removed.
> 
> NUMA and cpusets screwed up: they've gone and used nodes as their basic
> unit of memory management whereas they should have used zones.  This will
> need to be untangled.
> 

I guess nodes could become hardware zones because they contain essentially
the same information. In that case, what would happen then is that a number
of "main" software zones would be created at boot time for each of the
hardware-based limitations on PFN ranges. buffered_rmqueue would be responsible
for selecting the right software zone to use based on the __GFP flags.

It's not massively different to what we currently though except it plays
nicely with containers.

> Anyway, that's just a shot in the dark.  Could be that we implement unplug
> and RSS control by totally different means.

The unplug can use ZONE_MOVABLE as it stands today. RSS control can be done
as software zones as described above but it doesn't affect anti-fragmentation.

> But I do wish that we'd sort
> out what those means will be before we potentially complicate the story a
> lot by adding antifragmentation.

I believe the difficulty of the problem remains the same whether
anti-fragmentation is entered into the equation or not. Hence, I'd like
to see both anti-fragmentation and the zone-based work go in because they
should not interfere with the RSS work and they help huge pages a lot by
allowing the pool to be resized.

However, if that is objectionable, I'd at least like to see zone-based patches
go into -mm on the expectation that the memory hot-remove patches will be
able to use the infrastructure. It's not ideal for hugepages and it is not my
first preference, but it's a step in the right direction. Is this reasonable?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

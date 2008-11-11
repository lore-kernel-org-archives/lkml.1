Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYKKX0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYKKX0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYKKX0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:26:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYKKX0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:26:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [PATCH 1/2] Hibernate: Take overlapping zones into account
Date: Wed, 12 Nov 2008 00:30:42 +0100
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>, Pavel Machek <pavel@suse.cz>,
       Andy Whitcroft <apw@shadowen.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
References: <200811081356.13060.rjw@sisk.pl> <200811112131.42603.rjw@sisk.pl> <1226438713.7105.11.camel@nigel-laptop>
In-Reply-To: <1226438713.7105.11.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811120030.42841.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Nigel Cunningham wrote:
> Hi Rafael.
> 
> On Tue, 2008-11-11 at 21:31 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: Hibernate: Take overlapping zones into account
> > 
> > It has been requested to make hibernation work with memory
> > hotplugging enabled and for this purpose the hibernation code has to
> > be reworked to take the possible overlapping of zones into account.
> > Thus, rework the hibernation memory bitmaps code to prevent
> > duplication of PFNs from occuring and add checks to make sure that
> > one page frame will not be marked as saveable many times.
> > 
> > Additionally, use list.h lists instead of open-coded lists to
> > implement the memory bitmaps.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Pavel Machek <pavel@suse.cz>
> > Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> > Cc: Andy Whitcroft <apw@shadowen.org>
> > ---
> >  kernel/power/snapshot.c |  326 ++++++++++++++++++++++++------------------------
> >  1 file changed, 166 insertions(+), 160 deletions(-)
> > 
> > Index: linux-2.6/kernel/power/snapshot.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/power/snapshot.c
> > +++ linux-2.6/kernel/power/snapshot.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/syscalls.h>
> >  #include <linux/console.h>
> >  #include <linux/highmem.h>
> > +#include <linux/list.h>
> >  
> >  #include <asm/uaccess.h>
> >  #include <asm/mmu_context.h>
> > @@ -192,12 +193,6 @@ static void *chain_alloc(struct chain_al
> >  	return ret;
> >  }
> >  
> > -static void chain_free(struct chain_allocator *ca, int clear_page_nosave)
> > -{
> > -	free_list_of_pages(ca->chain, clear_page_nosave);
> > -	memset(ca, 0, sizeof(struct chain_allocator));
> > -}
> > -
> >  /**
> >   *	Data types related to memory bitmaps.
> >   *
> > @@ -233,7 +228,7 @@ static void chain_free(struct chain_allo
> >  #define BM_BITS_PER_BLOCK	(PAGE_SIZE << 3)
> >  
> >  struct bm_block {
> > -	struct bm_block *next;		/* next element of the list */
> > +	struct list_head hook;	/* hook into a list of bitmap blocks */
> >  	unsigned long start_pfn;	/* pfn represented by the first bit */
> >  	unsigned long end_pfn;	/* pfn represented by the last bit plus 1 */
> >  	unsigned long *data;	/* bitmap representing pages */
> > @@ -244,24 +239,15 @@ static inline unsigned long bm_block_bit
> >  	return bb->end_pfn - bb->start_pfn;
> >  }
> >  
> > -struct zone_bitmap {
> > -	struct zone_bitmap *next;	/* next element of the list */
> > -	unsigned long start_pfn;	/* minimal pfn in this zone */
> > -	unsigned long end_pfn;		/* maximal pfn in this zone plus 1 */
> > -	struct bm_block *bm_blocks;	/* list of bitmap blocks */
> > -	struct bm_block *cur_block;	/* recently used bitmap block */
> > -};
> > -
> >  /* strcut bm_position is used for browsing memory bitmaps */
> >  
> >  struct bm_position {
> > -	struct zone_bitmap *zone_bm;
> >  	struct bm_block *block;
> >  	int bit;
> >  };
> >  
> >  struct memory_bitmap {
> > -	struct zone_bitmap *zone_bm_list;	/* list of zone bitmaps */
> > +	struct list_head blocks;	/* list of bitmap blocks */
> >  	struct linked_page *p_list;	/* list of pages used to store zone
> >  					 * bitmap objects and bitmap block
> >  					 * objects
> > @@ -273,11 +259,7 @@ struct memory_bitmap {
> >  
> >  static void memory_bm_position_reset(struct memory_bitmap *bm)
> >  {
> > -	struct zone_bitmap *zone_bm;
> > -
> > -	zone_bm = bm->zone_bm_list;
> > -	bm->cur.zone_bm = zone_bm;
> > -	bm->cur.block = zone_bm->bm_blocks;
> > +	bm->cur.block = list_entry(bm->blocks.next, struct bm_block, hook);
> >  	bm->cur.bit = 0;
> >  }
> >  
> > @@ -285,151 +267,183 @@ static void memory_bm_free(struct memory
> >  
> >  /**
> >   *	create_bm_block_list - create a list of block bitmap objects
> > - */
> > -
> > -static inline struct bm_block *
> > -create_bm_block_list(unsigned int nr_blocks, struct chain_allocator *ca)
> > + *	@nr_blocks - number of blocks to allocate
> > + *	@list - list to put the allocated blocks into
> > + *	@ca - chain allocator to be used for allocating memory
> > + */
> > +static int create_bm_block_list(unsigned long pages,
> > +				struct list_head *list,
> > +				struct chain_allocator *ca)
> >  {
> > -	struct bm_block *bblist = NULL;
> > +	unsigned int nr_blocks = DIV_ROUND_UP(pages, BM_BITS_PER_BLOCK);
> >  
> >  	while (nr_blocks-- > 0) {
> >  		struct bm_block *bb;
> >  
> >  		bb = chain_alloc(ca, sizeof(struct bm_block));
> >  		if (!bb)
> > -			return NULL;
> > -
> > -		bb->next = bblist;
> > -		bblist = bb;
> > +			return -ENOMEM;
> > +		list_add(&bb->hook, list);
> >  	}
> > -	return bblist;
> > +
> > +	return 0;
> >  }
> >  
> > +struct mem_extent {
> > +	struct list_head hook;
> > +	unsigned long start;
> > +	unsigned long end;
> > +};
> > +
> >  /**
> > - *	create_zone_bm_list - create a list of zone bitmap objects
> > + *	free_mem_extents - free a list of memory extents
> > + *	@list - list of extents to empty
> >   */
> > +static void free_mem_extents(struct list_head *list)
> > +{
> > +	struct mem_extent *ext, *aux;
> >  
> > -static inline struct zone_bitmap *
> > -create_zone_bm_list(unsigned int nr_zones, struct chain_allocator *ca)
> > +	list_for_each_entry_safe(ext, aux, list, hook) {
> > +		list_del(&ext->hook);
> > +		kfree(ext);
> > +	}
> > +}
> > +
> > +/**
> > + *	create_mem_extents - create a list of memory extents representing
> > + *	                     contiguous ranges of PFNs
> > + *	@list - list to put the extents into
> > + *	@gfp_mask - mask to use for memory allocations
> > + */
> > +static int create_mem_extents(struct list_head *list, gfp_t gfp_mask)
> >  {
> > -	struct zone_bitmap *zbmlist = NULL;
> > +	struct zone *zone;
> >  
> > -	while (nr_zones-- > 0) {
> > -		struct zone_bitmap *zbm;
> > +	INIT_LIST_HEAD(list);
> >  
> > -		zbm = chain_alloc(ca, sizeof(struct zone_bitmap));
> > -		if (!zbm)
> > -			return NULL;
> > +	for_each_zone(zone) {
> > +		unsigned long zone_start, zone_end;
> > +		struct mem_extent *ext, *cur, *aux;
> > +
> > +		if (!populated_zone(zone))
> > +			continue;
> > +
> > +		zone_start = zone->zone_start_pfn;
> > +		zone_end = zone->zone_start_pfn + zone->spanned_pages;
> > +
> > +		list_for_each_entry(ext, list, hook)
> > +			if (zone_start <= ext->end)
> > +				break;
> > +
> > +		if (&ext->hook == list || zone_end < ext->start) {
> > +			/* New extent is necessary */
> > +			struct mem_extent *new_ext;
> > +
> > +			new_ext = kzalloc(sizeof(struct mem_extent), gfp_mask);
> > +			if (!new_ext) {
> > +				free_mem_extents(list);
> > +				return -ENOMEM;
> > +			}
> > +			new_ext->start = zone_start;
> > +			new_ext->end = zone_end;
> > +			list_add_tail(&new_ext->hook, &ext->hook);
> 
> Is list_add_tail right? You seem to be relying on the list being ordered
> in the list_for_each_entry above.
> 
> > +			continue;
> > +		}
> >  
> > -		zbm->next = zbmlist;
> > -		zbmlist = zbm;
> > +		/* Merge this zone's range of PFNs with the existing one */
> > +		if (zone_start < ext->start)
> > +			ext->start = zone_start;
> > +		if (zone_end > ext->end)
> > +			ext->end = zone_end;
> > +
> > +		/* More merging may be possible */
> > +		cur = ext;
> > +		list_for_each_entry_safe_continue(cur, aux, list, hook) {
> > +			if (zone_end < cur->start)
> > +				break;
> > +			if (zone_end < cur->end)
> > +				ext->end = cur->end;
> > +			list_del(&cur->hook);
> 
> kfree?
> 
> 
> > +		}
> >  	}
> > -	return zbmlist;
> > +
> > +	return 0;
> >  }
> >  
> >  /**
> >    *	memory_bm_create - allocate memory for a memory bitmap
> >    */
> > -
> >  static int
> >  memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
> >  {
> >  	struct chain_allocator ca;
> > -	struct zone *zone;
> > -	struct zone_bitmap *zone_bm;
> > -	struct bm_block *bb;
> > -	unsigned int nr;
> > +	struct list_head mem_extents;
> > +	struct mem_extent *ext;
> > +	int error;
> >  
> >  	chain_init(&ca, gfp_mask, safe_needed);
> > +	INIT_LIST_HEAD(&bm->blocks);
> >  
> > -	/* Compute the number of zones */
> > -	nr = 0;
> > -	for_each_zone(zone)
> > -		if (populated_zone(zone))
> > -			nr++;
> > -
> > -	/* Allocate the list of zones bitmap objects */
> > -	zone_bm = create_zone_bm_list(nr, &ca);
> > -	bm->zone_bm_list = zone_bm;
> > -	if (!zone_bm) {
> > -		chain_free(&ca, PG_UNSAFE_CLEAR);
> > -		return -ENOMEM;
> > -	}
> > +	error = create_mem_extents(&mem_extents, gfp_mask);
> > +	if (error)
> > +		return error;
> >  
> > -	/* Initialize the zone bitmap objects */
> > -	for_each_zone(zone) {
> > -		unsigned long pfn;
> > +	list_for_each_entry(ext, &mem_extents, hook) {
> > +		struct bm_block *bb;
> > +		unsigned long pfn = ext->start;
> > +		unsigned long pages = ext->end - ext->start;
> >  
> > -		if (!populated_zone(zone))
> > -			continue;
> > +		bb = list_entry(bm->blocks.prev, struct bm_block, hook);
> >  
> > -		zone_bm->start_pfn = zone->zone_start_pfn;
> > -		zone_bm->end_pfn = zone->zone_start_pfn + zone->spanned_pages;
> > -		/* Allocate the list of bitmap block objects */
> > -		nr = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
> > -		bb = create_bm_block_list(nr, &ca);
> > -		zone_bm->bm_blocks = bb;
> > -		zone_bm->cur_block = bb;
> > -		if (!bb)
> > -			goto Free;
> > +		error = create_bm_block_list(pages, bm->blocks.prev, &ca);
> > +		if (error)
> > +			goto Error;
> >  
> > -		nr = zone->spanned_pages;
> > -		pfn = zone->zone_start_pfn;
> > -		/* Initialize the bitmap block objects */
> > -		while (bb) {
> > -			unsigned long *ptr;
> > -
> > -			ptr = get_image_page(gfp_mask, safe_needed);
> > -			bb->data = ptr;
> > -			if (!ptr)
> > -				goto Free;
> > +		list_for_each_entry_continue(bb, &bm->blocks, hook) {
> > +			bb->data = get_image_page(gfp_mask, safe_needed);
> > +			if (!bb->data) {
> > +				error = -ENOMEM;
> > +				goto Error;
> > +			}
> >  
> >  			bb->start_pfn = pfn;
> > -			if (nr >= BM_BITS_PER_BLOCK) {
> > +			if (pages >= BM_BITS_PER_BLOCK) {
> >  				pfn += BM_BITS_PER_BLOCK;
> > -				nr -= BM_BITS_PER_BLOCK;
> > +				pages -= BM_BITS_PER_BLOCK;
> >  			} else {
> >  				/* This is executed only once in the loop */
> > -				pfn += nr;
> > +				pfn += pages;
> >  			}
> >  			bb->end_pfn = pfn;
> > -			bb = bb->next;
> >  		}
> > -		zone_bm = zone_bm->next;
> >  	}
> > +
> >  	bm->p_list = ca.chain;
> >  	memory_bm_position_reset(bm);
> > -	return 0;
> > + Exit:
> > +	free_mem_extents(&mem_extents);
> > +	return error;
> >  
> > - Free:
> > + Error:
> >  	bm->p_list = ca.chain;
> >  	memory_bm_free(bm, PG_UNSAFE_CLEAR);
> > -	return -ENOMEM;
> > +	goto Exit;
> >  }
> >  
> >  /**
> >    *	memory_bm_free - free memory occupied by the memory bitmap @bm
> >    */
> > -
> >  static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free)
> >  {
> > -	struct zone_bitmap *zone_bm;
> > +	struct bm_block *bb;
> >  
> > -	/* Free the list of bit blocks for each zone_bitmap object */
> > -	zone_bm = bm->zone_bm_list;
> > -	while (zone_bm) {
> > -		struct bm_block *bb;
> > +	list_for_each_entry(bb, &bm->blocks, hook)
> > +		if (bb->data)
> > +			free_image_page(bb->data, clear_nosave_free);
> >  
> > -		bb = zone_bm->bm_blocks;
> > -		while (bb) {
> > -			if (bb->data)
> > -				free_image_page(bb->data, clear_nosave_free);
> > -			bb = bb->next;
> > -		}
> > -		zone_bm = zone_bm->next;
> > -	}
> >  	free_list_of_pages(bm->p_list, clear_nosave_free);
> > -	bm->zone_bm_list = NULL;
> > +
> > +	INIT_LIST_HEAD(&bm->blocks);
> >  }
> >  
> >  /**
> > @@ -437,38 +451,33 @@ static void memory_bm_free(struct memory
> >   *	to given pfn.  The cur_zone_bm member of @bm and the cur_block member
> >   *	of @bm->cur_zone_bm are updated.
> >   */
> > -
> >  static int memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
> >  				void **addr, unsigned int *bit_nr)
> >  {
> > -	struct zone_bitmap *zone_bm;
> >  	struct bm_block *bb;
> >  
> > -	/* Check if the pfn is from the current zone */
> > -	zone_bm = bm->cur.zone_bm;
> > -	if (pfn < zone_bm->start_pfn || pfn >= zone_bm->end_pfn) {
> > -		zone_bm = bm->zone_bm_list;
> > -		/* We don't assume that the zones are sorted by pfns */
> > -		while (pfn < zone_bm->start_pfn || pfn >= zone_bm->end_pfn) {
> > -			zone_bm = zone_bm->next;
> > -
> > -			if (!zone_bm)
> > -				return -EFAULT;
> > -		}
> > -		bm->cur.zone_bm = zone_bm;
> > -	}
> > -	/* Check if the pfn corresponds to the current bitmap block */
> > -	bb = zone_bm->cur_block;
> > +	/*
> > +	 * Check if the pfn corresponds to the current bitmap block and find
> > +	 * the block where it fits if this is not the case.
> > +	 */
> > +	bb = bm->cur.block;
> >  	if (pfn < bb->start_pfn)
> > -		bb = zone_bm->bm_blocks;
> > +		list_for_each_entry_continue_reverse(bb, &bm->blocks, hook)
> > +			if (pfn >= bb->start_pfn)
> > +				break;
> > +
> > +	if (pfn >= bb->end_pfn)
> > +		list_for_each_entry_continue(bb, &bm->blocks, hook)
> > +			if (pfn >= bb->start_pfn && pfn < bb->end_pfn)
> > +				break;
> >  
> > -	while (pfn >= bb->end_pfn) {
> > -		bb = bb->next;
> > +	if (&bb->hook == &bm->blocks)
> > +		return -EFAULT;
> >  
> > -		BUG_ON(!bb);
> > -	}
> > -	zone_bm->cur_block = bb;
> > +	/* The block has been found */
> > +	bm->cur.block = bb;
> >  	pfn -= bb->start_pfn;
> > +	bm->cur.bit = pfn + 1;
> >  	*bit_nr = pfn;
> >  	*addr = bb->data;
> >  	return 0;
> > @@ -530,29 +539,21 @@ static int memory_bm_test_bit(struct mem
> >  
> >  static unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
> >  {
> > -	struct zone_bitmap *zone_bm;
> >  	struct bm_block *bb;
> >  	int bit;
> >  
> > +	bb = bm->cur.block;
> >  	do {
> > -		bb = bm->cur.block;
> > -		do {
> > -			bit = bm->cur.bit;
> > -			bit = find_next_bit(bb->data, bm_block_bits(bb), bit);
> > -			if (bit < bm_block_bits(bb))
> > -				goto Return_pfn;
> > -
> > -			bb = bb->next;
> > -			bm->cur.block = bb;
> > -			bm->cur.bit = 0;
> > -		} while (bb);
> > -		zone_bm = bm->cur.zone_bm->next;
> > -		if (zone_bm) {
> > -			bm->cur.zone_bm = zone_bm;
> > -			bm->cur.block = zone_bm->bm_blocks;
> > -			bm->cur.bit = 0;
> > -		}
> > -	} while (zone_bm);
> > +		bit = bm->cur.bit;
> > +		bit = find_next_bit(bb->data, bm_block_bits(bb), bit);
> > +		if (bit < bm_block_bits(bb))
> > +			goto Return_pfn;
> > +
> > +		bb = list_entry(bb->hook.next, struct bm_block, hook);
> > +		bm->cur.block = bb;
> > +		bm->cur.bit = 0;
> > +	} while (&bb->hook != &bm->blocks);
> > +
> >  	memory_bm_position_reset(bm);
> >  	return BM_END_OF_MAP;
> 
> Is anything above here related to the hotplug memory support? If not,
> perhaps this could be two patches?

Unfortunately, the first part of the patch introduces a potentially dangerous
situation that is only prevented by the second part.

Namely, if there are overlapping zones, the first part will only cause the
"true" pages to be saved.  Assume that the "true" PFN is in the second of the
two overlapping zones.  Then, on resume the bit corresponding to this PFN will
be set in the first zone and the ordering of pages in the image will be
invalid.  That's why the second part is necessary in the same patch.

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbYKSGkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbYKSGkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYKSGko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:40:44 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:24472 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751266AbYKSGkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:40:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TBVWMEVc+nsW9/FTBveF2zYZcjPEZEG9AljxWo8wSP2iQ9DR17bq6lJB0yCS7Ymo9/ZHtpGEEfm+cu/d0Tob+DIDKLZFMKPOqHAmVaPq/P9W8i6vYrSghGrUXLLGMu5FGMc9VKRUicrm3Y04eouAdrrkwLzzlrfpMvvZKww37M0=  ;
X-YMail-OSG: o.9cFpIVM1lh64upZ_ejPBZS0CgqeN6YVXDoKUEtWiedaNK.3Bd7bl96bcVP4DBKYqvmNLQ9AOw9DWxRWIcfu3jICdHJehkgtM8gAUlnoBKK2crCVYdOY7.wJTTbI4arxKKU_gUoSLs0w1eF1j6XafozJd0sdoCDBzQ..Obrnmbup7YBDinzXWaGkrcI
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Naval Saini" <navalnovel@gmail.com>, linux-arch@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: O_DIRECT patch for processors with VIPT cache for mainline kernel (specifically arm in our case)
Date: Wed, 19 Nov 2008 17:40:23 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, naval.saini@nxp.com
References: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com>
In-Reply-To: <d8dd82df0811180606w503563ach8650ab07dcd0a35c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811191740.23638.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 19 November 2008 01:06, Naval Saini wrote:
> Hi:
>
>
> We were facing some issues with O_DIRECT, when using XFS (mkfs.xfs) to
> format the USB disks. We debugged it to following comment in arm
> technical reference manual (which perhaps applies to other
> architectures aswell) :-
>
>
> From arm 1176 technical ref. manual :-
>
> 1. If multiple virtual addresses are mapped onto the same physical
> address then for all mappings of bits [13:12] the virtual addresses
> must be equal and the same as bits [13:12] of the physical address.
> The same physical address can be mapped by TLB entries of different
> page sizes, including page sizes over 4KB. Imposing this requirement
> on the virtual address is called page coloring.
> 2. Alternatively, if all mappings to a physical address are of a page
> size equal to 4KB, then the restriction that bits [13:12] of the
> virtual address must equal bits [13:12] of the physical address is not
> necessary. Bits [13:12] of all virtual address aliases must still be
> equal.
>
>
> I am looking forward to help from the community in making this patch a
> mainline kernel patch. It need help in reviewing it and fixing a bug
> in it (described below).
>
>
>
> Our configuration :-
>
> arm 11 architecture / linux-2.6.18.5 / uClibc-0.9.28 .

It would be interesting to know exactly what problem you are seeing.

ARM I think is supposed to handle aliasing problems by flushing
caches at appropriate points. It would be nice to know what's going
wrong and whether we can cover those holes.

Does the problem show up on the most recent kernel.org kernels?


> Proposed Fix :-
>
> Add a mechanism to allocate memory that is page color aligned. Patch
> in uclibc and linux kernel.

We've traditionally avoided cache colouring in the page allocator for
one reason or another. It should be a workable approach, but I think
the way to get it into mainline is to first fix the problem using the
existing cache flushing approach, and then demonstrate how page
colouring is a better solution.



> The idea behind the patch / explanation :-
>
>
> Modify memalign in uclibc to pass a new flag (MAP_COLORALIGN) to
> kernel (via mmap only / no sbrk) ; that directs it to allocate a
> memory in which all PAs and VAs are color aligned (see my post above
> for why we need it).
>
> The kernel has creates a vm_area for above mmap operation (with
> MAP_COLORALIGN flag), and adds VM_COLORALIGN to its vm_area->flags.
>
> When we get an __handle_mm_fault for this area, we have modified some
> kernel functions in file mm/page_alloc.c (such as __alloc_pages,
> get_page_from_freelist, buffered_rmqueue) to allocate an aligned
> memory (as stated above). We have modified the parameter  'order' (in
> these functions), to new name 'align_order'. This parameter carries
> needed alignment in upper half of the word and order (or size in
> pages) in lower half. This change is in effect only when VM_COLORALIGN
> is set in flags.
>
> So, finally we allocate the aligned pages in function
> __rmqueue_aligned_wrapper . It calls another function
> __rmqueue_aligned where it actually does the allocation. In these
> functions, we try to allocate the memory from areas (in buddy) of
> larger order first (see condition in __rmqueue_aligned_wrapper) and
> then from smaller order areas (if former fails). This is done for
> optimization considerations.
>
> The extra pages in the front and back of allocated area, are freed in
> the function expand_num_pages.
>
> Also i have procured permission from company's legal department to
> post the patch to the community.
>
>
>
> Bug in the patch :-
>
> I also need help with a bug in the patch. I stumbled across a crash
> with a simple program as below, when USB was not connected (ie.
> /dev/sda did not have an associated device),
>
> #define ALIGN (16*1024)
> #define BS (512)
> main ()
> {
>             posix_memalign ( &b2, ALIGN , BS ); ob2 = b2;
>             sda =open ("/dev/sda", O_RDWR ); // get dump here
>             return 0;
> }
>
>
> If I modify ALIGN to some lesser value, say 4096, dont get the crash.
> Perhaps it is some buddy allocator concept i need to understand, when
> i free pages in expand_num_pages (hoping someone can spot it out from
> the patch).
>
> Also suggest, how i can do some regression testing here.
>
>
> The Dump from above program :-
>
>
> ./test_odirect1
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000084 pgd = 97044000
> [00000084] *pgd=00000000
> Internal error: Oops: 17 [#1]
> Modules linked in:
> CPU: 0
> PC is at do_page_fault+0x20/0x244
> LR is at do_DataAbort+0x3c/0xa0
> pc : [<9706b748>]    lr : [<9706bb2c>]    Not tainted
> sp : 97720058  ip : 176ce431  fp : 9772009c
> r10: 00000000  r9 : 40000113  r8 : 97720150
> r7 : 00000000  r6 : 9738966c  r5 : 00000017  r4 : 973895fc
> r3 : 97720000  r2 : 97720150  r1 : 00000017  r0 : 00000084
> Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  Segment user
> Control: C5387D  Table: 17720000  DAC: 00000017
> Process modprobe (pid: 83, stack limit = 0x9771e250)
> Stack: (0x97720058 to 0x97720000)
> Backtrace:
> [<9706b728>] (do_page_fault+0x0/0x244) from [<9706bb2c>]
> (do_DataAbort+0x3c/0xa0)
> [<9706baf0>] (do_DataAbort+0x0/0xa0) from [<9706482c>]
> (__dabt_svc+0x4c/0x60) r8 = 97720290  r7 = 00000000  r6 = 9738966C  r5 =
> 97720184
>  r4 = FFFFFFFF
> [<9706b728>] (do_page_fault+0x0/0x244) from [<9706bb2c>]
> (do_DataAbort+0x3c/0xa0)
> [<9706baf0>] (do_DataAbort+0x0/0xa0) from [<9706482c>]
> (__dabt_svc+0x4c/0x60) r8 = 977203D0  r7 = 00000000  r6 = 9738966C  r5 =
> 977202C4
>  r4 = FFFFFFFF
> [<9706b728>] (do_page_fault+0x0/0x244) from [<9706bb2c>]
> (do_DataAbort+0x3c/0xa0)
>
> ........ (so on)
>
>
>
>
> PATCHES 1 -   applies to kernel
> --------------------
>
>
>
> --- linux-2.6.18.5/arch/arm/mm/mmap.c	2006-12-02 05:43:05.000000000 +0530
> +++ linux-2.6.18.5/arch/arm/mm/mmap.c	2008-11-07 19:29:09.000000000 +0530
> @@ -41,7 +41,7 @@ arch_get_unmapped_area(struct file *filp
>  	if (cache_type != read_cpuid(CPUID_ID)) {
>  		aliasing = (cache_type | cache_type >> 12) & (1 << 11);
>  		if (aliasing)
> -			do_align = filp || flags & MAP_SHARED;
> +			do_align = filp || flags & MAP_SHARED || flags & MAP_COLORALIGN;
>  	}
>  #else
>  #define do_align 0
> --- linux-2.6.18.5/mm/page_alloc.c	2006-12-02 05:43:05.000000000 +0530
> +++ linux-2.6.18.5/mm/page_alloc.c	2008-11-07 19:31:43.000000000 +0530
> @@ -519,6 +519,32 @@ static inline void expand(struct zone *z
>  	}
>  }
>
> +/* The order in while pages are being added to the areas, should not
> be changed.
> + * ie. smaller pages (with smaller order) towards the front and
> larger towards back.
> + */
> +static inline void expand_num_pages(struct zone *zone, struct page
> *page, unsigned int size)
> +{
> +        unsigned int mask, order;
> +        struct free_area *area;
> +
> +	mask = 1;
> +	order = 0;
> +        while (size) {
> +                if ( mask & size )  {
> +                        area = zone->free_area + order;
> +                        BUG_ON(bad_range(zone, page));
> +                        list_add(&page->lru, &area->free_list);
> +                        area->nr_free++;
> +                        set_page_order(page, order);
> +
> +			page = &page[mask];
> +                        size &= (~mask);
> +                }
> +		mask <<= 1;
> +		++order;
> +        }
> +}
> +
>  /*
>   * This page is about to be returned from the page allocator
>   */
> @@ -591,6 +617,110 @@ static struct page *__rmqueue(struct zon
>  	return NULL;
>  }
>
> +#define log2(n) ffz(~(n))
> +
> +/*
> + * __rmqueue_aligned :-
> + * Tries to allocate aligned pages of given order, from among pages
> of current_order.
> + */
> +static struct page *__rmqueue_aligned (struct zone *zone, unsigned
> int align_order , unsigned int current_order )
> +{
> +	struct free_area *area;
> +	struct list_head *pos;
> +	struct page *page;
> +
> +	unsigned int frontpad, padsize, lastpad, page_align;
> +	const unsigned int extra = (SHMLBA >> PAGE_SHIFT), extra_order =
> log2(extra); +	unsigned int order =
> EXTRACT_ORDER(__GFP_COLORALIGN,align_order); +	unsigned int align =
> EXTRACT_ALIGN(__GFP_COLORALIGN,align_order); +
> +	area = zone->free_area + current_order;
> +	if (list_empty(&area->free_list))
> +		return NULL;
> +
> +	list_for_each(pos,&area->free_list) {
> +		page = list_entry(pos, struct page, lru);
> +		page_align = page_to_pfn(page) & (extra-1);
> +
> +		if ( align == page_align ) { /* color alignment matches */
> +			frontpad = 0;
> +			break;
> +		}
> +
> +		if ( current_order > order ) /* chk if its not a tightfit; cant
> allocate from tight fit */
> +		{
> +			frontpad = (align > page_align) ? (align - page_align) : (extra +
> align - page_align);
> +									/* move below at 2 places, for efficiency */
> +
> +			if ( current_order > extra_order ) /* allocate from inside node */
> +				break;
> +
> +			if ( (unsigned int) ((0x1UL<<current_order) - (0x1UL<<order)) >=
> frontpad) +				break;
> +		}
> +	}
> +
> +	if ( pos == &area->free_list)  /* is true when we did not find any
> suitable match in the area */
> +		return NULL;
> +
> +	list_del(&page->lru);
> +	rmv_page_order(page);
> +	area->nr_free--;
> +	zone->free_pages -= 1UL << order;
> +
> +	/* Allocation looks as below :-
> +	 * [current_order pages] = [frontpad pages] + [order pages] +
> [lastpad pages] */
> +	padsize = (0x01UL<<order) + frontpad;
> +	lastpad = (0x01UL<<current_order) - padsize;
> +
> +	printk (" current %d = ", 0x1UL<<current_order);
> +	printk (" frontpad %d + order %d + lastpad %d \n", frontpad,
> 0x1UL<<order, lastpad);
> +
> +	/* we need to remove pages in front and back of allocation */
> +	if (lastpad)
> +		expand_num_pages (zone, &page[padsize], lastpad);
> +	if (frontpad) {
> +		expand_num_pages (zone, page, frontpad);
> +		page = &page[frontpad];
> +		rmv_page_order(page);
> +	}
> +
> +	return page;
> +}
> +
> +/* __rmqueue_aligned_wrapper :-
> + * calls __rmqueue_aligned in a manner, optimzed for speed.
> __rmqueue_aligned accepts a parameter
> + * current_order, which is the area we check for free pages. We first
> check for large pages thus
> + * spending lesser time looping in __rmqueue_aligned.
> + */
> +static struct page *__rmqueue_aligned_wrapper (struct zone *zone,
> unsigned int align_order)
> +{
> +	struct page *page = NULL;
> +	unsigned int optim_order, current_order;
> +	const unsigned int extra = (SHMLBA >> PAGE_SHIFT), extra_order =
> log2(extra); +	unsigned int order =
> EXTRACT_ORDER(__GFP_COLORALIGN,align_order); +	unsigned int align =
> EXTRACT_ALIGN(__GFP_COLORALIGN,align_order); +
> +	BUG_ON(align >= extra);
> +
> +	/* starting with higher order areas, results in faster find */
> +	if ( order == 0 )
> +		optim_order = extra_order;
> +	else if ( order <= extra_order )
> +		optim_order = extra_order + 1;
> +	else
> +		optim_order = order + 1;
> +
> +	for (current_order = optim_order; current_order < MAX_ORDER && page
> == NULL; current_order++ )
> +		page = __rmqueue_aligned ( zone , align_order , current_order );
> +
> +	for (current_order = optim_order-1; current_order >= order && page
> == NULL ; current_order-- )
> +		page = __rmqueue_aligned ( zone , align_order , current_order );
> +
> +	return page;
> +}
> +
> +
>  /*
>   * Obtain a specified number of elements from the buddy allocator, all
> under * a single hold of the lock, for efficiency.  Add them to the
> supplied list. @@ -773,16 +903,17 @@ void split_page(struct page *page,
> unsig
>   * or two.
>   */
>  static struct page *buffered_rmqueue(struct zonelist *zonelist,
> -			struct zone *zone, int order, gfp_t gfp_flags)
> +			struct zone *zone, int align_order, gfp_t gfp_flags)
>  {
>  	unsigned long flags;
>  	struct page *page;
>  	int cold = !!(gfp_flags & __GFP_COLD);
>  	int cpu;
> +	unsigned int order = EXTRACT_ORDER(gfp_flags,align_order);
>
>  again:
>  	cpu  = get_cpu();
> -	if (likely(order == 0)) {
> +	if (likely(order == 0 && !(gfp_flags & __GFP_COLORALIGN))) {
>  		struct per_cpu_pages *pcp;
>
>  		pcp = &zone_pcp(zone, cpu)->pcp[cold];
> @@ -798,9 +929,13 @@ again:
>  		pcp->count--;
>  	} else {
>  		spin_lock_irqsave(&zone->lock, flags);
> -		page = __rmqueue(zone, order);
> +		if ( likely(!(gfp_flags & __GFP_COLORALIGN)) ) {
> +			page = __rmqueue(zone, order);
> +		} else {
> +			page = __rmqueue_aligned_wrapper(zone, align_order);
> +		}
>  		spin_unlock(&zone->lock);
> -		if (!page)
> +		if (!page)
>  			goto failed;
>  	}
>
> @@ -864,12 +999,13 @@ int zone_watermark_ok(struct zone *z, in
>   * a page.
>   */
>  static struct page *
> -get_page_from_freelist(gfp_t gfp_mask, unsigned int order,
> +get_page_from_freelist(gfp_t gfp_mask, unsigned int align_order,
>  		struct zonelist *zonelist, int alloc_flags)
>  {
>  	struct zone **z = zonelist->zones;
>  	struct page *page = NULL;
>  	int classzone_idx = zone_idx(*z);
> +	unsigned int order = EXTRACT_ORDER(gfp_mask,align_order);
>
>  	/*
>  	 * Go through the zonelist once, looking for a zone with enough free.
> @@ -895,7 +1031,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
>  					continue;
>  		}
>
> -		page = buffered_rmqueue(zonelist, *z, order, gfp_mask);
> +		page = buffered_rmqueue(zonelist, *z, align_order, gfp_mask);
>  		if (page) {
>  			break;
>  		}
> @@ -905,9 +1041,13 @@ get_page_from_freelist(gfp_t gfp_mask, u
>
>  /*
>   * This is the 'heart' of the zoned buddy allocator.
> + *
> + * VIPT cache fix :-
> + * The upper half (ie. upper 16 bits in case of 32-bit integers) of
> align_order
> + * are used for passing, the required page color alignment for the
> allocated page.
>   */
>  struct page * fastcall
> -__alloc_pages(gfp_t gfp_mask, unsigned int order,
> +__alloc_pages(gfp_t gfp_mask, unsigned int align_order,
>  		struct zonelist *zonelist)
>  {
>  	const gfp_t wait = gfp_mask & __GFP_WAIT;
> @@ -918,6 +1058,7 @@ __alloc_pages(gfp_t gfp_mask, unsigned i
>  	int do_retry;
>  	int alloc_flags;
>  	int did_some_progress;
> +	unsigned int order = EXTRACT_ORDER(gfp_mask,align_order);
>
>  	might_sleep_if(wait);
>
> @@ -929,7 +1070,7 @@ restart:
>  		return NULL;
>  	}
>
> -	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
> +	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, align_order,
>  				zonelist, ALLOC_WMARK_LOW|ALLOC_CPUSET);
>  	if (page)
>  		goto got_pg;
> @@ -964,7 +1105,7 @@ restart:
>  	 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
>  	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
>  	 */
> -	page = get_page_from_freelist(gfp_mask, order, zonelist, alloc_flags);
> +	page = get_page_from_freelist(gfp_mask, align_order, zonelist,
> alloc_flags); if (page)
>  		goto got_pg;
>
> @@ -975,7 +1116,7 @@ restart:
>  		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
>  nofail_alloc:
>  			/* go through the zonelist yet again, ignoring mins */
> -			page = get_page_from_freelist(gfp_mask, order,
> +			page = get_page_from_freelist(gfp_mask, align_order,
>  				zonelist, ALLOC_NO_WATERMARKS);
>  			if (page)
>  				goto got_pg;
> @@ -1008,7 +1149,7 @@ rebalance:
>  	cond_resched();
>
>  	if (likely(did_some_progress)) {
> -		page = get_page_from_freelist(gfp_mask, order,
> +		page = get_page_from_freelist(gfp_mask, align_order,
>  						zonelist, alloc_flags);
>  		if (page)
>  			goto got_pg;
> @@ -1019,7 +1160,7 @@ rebalance:
>  		 * a parallel oom killing, we must fail if we're still
>  		 * under heavy pressure.
>  		 */
> -		page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
> +		page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, align_order,
>  				zonelist, ALLOC_WMARK_HIGH|ALLOC_CPUSET);
>  		if (page)
>  			goto got_pg;
> --- linux-2.6.18.5/include/asm-arm/mman.h	2006-12-02 05:43:05.000000000
> +0530 +++ linux-2.6.18.5/include/asm-arm/mman.h	2008-11-07
> 19:29:09.000000000 +0530 @@ -11,6 +11,11 @@
>  #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
>  #define MAP_NONBLOCK	0x10000		/* do not block on IO */
>
> +#ifdef CONFIG_CPU_V6
> +# undef  MAP_COLORALIGN
> +# define MAP_COLORALIGN  0x0200	/* For VIVT caches - the alignment
> should be color aligned */
> +#endif
> +
>  #define MCL_CURRENT	1		/* lock all current mappings */
>  #define MCL_FUTURE	2		/* lock all future mappings */
>
> --- linux-2.6.18.5/include/asm-arm/page.h	2006-12-02 05:43:05.000000000
> +0530 +++ linux-2.6.18.5/include/asm-arm/page.h	2008-11-07
> 19:29:09.000000000 +0530 @@ -134,6 +134,17 @@ extern void
> __cpu_copy_user_page(void *t
>  #define clear_page(page)	memzero((void *)(page), PAGE_SIZE)
>  extern void copy_page(void *to, const void *from);
>
> +#ifdef CONFIG_CPU_V6
> +#define BITLEN(x) (sizeof(x)<<3) /* for bytes to bits, multiply by 8 */
> +#define EXTRACT_ORDER(gfp,num) ( (gfp & __GFP_COLORALIGN) ? (num &
> 0xFFFF) : (num) )
> +#define EXTRACT_ALIGN(gfp,num) ( (gfp & __GFP_COLORALIGN) ?
> (num>>BITLEN(unsigned short)) : (0) )
> +
> +#define ALIGNMENT_BITS(addr) (((addr&(SHMLBA-1))>>PAGE_SHIFT) <<
> BITLEN(unsigned short))
> +#define ARCH_ALIGNORDER(flags,addr,order) ((flags & VM_COLORALIGN)?
> (ALIGNMENT_BITS(addr) | order) : (0))
> +
> +#define ARCH_ALIGNGFP(flags) ((flags & VM_COLORALIGN)?
> (__GFP_COLORALIGN):(0)) +#endif
> +
>  #undef STRICT_MM_TYPECHECKS
>
>  #ifdef STRICT_MM_TYPECHECKS
> --- linux-2.6.18.5/include/linux/mman.h	2006-12-02 05:43:05.000000000 +0530
> +++ linux-2.6.18.5/include/linux/mman.h	2008-11-07 19:29:09.000000000 +0530
> @@ -63,7 +63,8 @@ calc_vm_flag_bits(unsigned long flags)
>  	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
>  	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
>  	       _calc_vm_trans(flags, MAP_EXECUTABLE, VM_EXECUTABLE) |
> -	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
> +	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
> +	       _calc_vm_trans(flags, MAP_COLORALIGN, VM_COLORALIGN);
>  }
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MMAN_H */
> --- linux-2.6.18.5/include/linux/mm.h	2006-12-02 05:43:05.000000000 +0530
> +++ linux-2.6.18.5/include/linux/mm.h	2008-11-07 19:29:09.000000000 +0530
> @@ -160,6 +160,7 @@ extern unsigned int kobjsize(const void
>  #define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
>  #define VM_RESERVED	0x00080000	/* Count as reserved_vm like IO */
>  #define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
> +#define VM_COLORALIGN   0x00200000	/* The vma is aligned with colour
> bits for VIVT cache */
>  #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
>  #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
>  #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap)
> */ --- linux-2.6.18.5/include/linux/gfp.h	2008-11-07 19:33:55.000000000
> +0530 +++ linux-2.6.18.5/include/linux/gfp.h	2008-11-07 19:35:50.000000000
> +0530 @@ -47,6 +47,8 @@ struct vm_area_struct;
>  #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use
> emergency reserves */
>  #define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce
> hardwall cpuset memory allocs */
>
> +#define __GFP_COLORALIGN ((__force gfp_t)0x40000u) /* Used by
> processors with VIPT caches */
> +
>  #define __GFP_BITS_SHIFT 20	/* Room for 20 __GFP_FOO bits */
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>
> @@ -106,8 +108,9 @@ extern struct page *
>  FASTCALL(__alloc_pages(gfp_t, unsigned int, struct zonelist *));
>
>  static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
> -						unsigned int order)
> +						unsigned int align_order)
>  {
> +	unsigned int order = EXTRACT_ORDER(gfp_mask,align_order);
>  	if (unlikely(order >= MAX_ORDER))
>  		return NULL;
>
> @@ -115,7 +118,7 @@ static inline struct page *alloc_pages_n
>  	if (nid < 0)
>  		nid = numa_node_id();
>
> -	return __alloc_pages(gfp_mask, order,
> +	return __alloc_pages(gfp_mask, align_order,
>  		NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_mask));
>  }
>
> @@ -133,9 +136,11 @@ alloc_pages(gfp_t gfp_mask, unsigned int
>  extern struct page *alloc_page_vma(gfp_t gfp_mask,
>  			struct vm_area_struct *vma, unsigned long addr);
>  #else
> -#define alloc_pages(gfp_mask, order) \
> -		alloc_pages_node(numa_node_id(), gfp_mask, order)
> -#define alloc_page_vma(gfp_mask, vma, addr) alloc_pages(gfp_mask, 0)
> +
> +#define alloc_pages(gfp_mask, align_order) \
> +		alloc_pages_node(numa_node_id(), gfp_mask, align_order)
> +#define alloc_page_vma(gfp_mask, vma, addr) \
> +		alloc_pages(gfp_mask|ARCH_ALIGNGFP(vma->vm_flags),
> ARCH_ALIGNORDER(vma->vm_flags,addr,0))
>  #endif
>  #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
>
> --- linux-2.6.18.5/include/linux/highmem.h	2006-12-02 05:43:05.000000000
> +0530 +++ linux-2.6.18.5/include/linux/highmem.h	2008-11-07
> 20:11:44.000000000 +0530 @@ -67,6 +67,12 @@
> alloc_zeroed_user_highpage(struct vm_are
>  }
>  #endif
>
> +#ifndef ARCH_ALIGNORDER
> +#define EXTRACT_ORDER(num) (num)
> +#define EXTRACT_ALIGN(num) (0)
> +#define ARCH_ALIGNORDER(flag,align,order) (0);
> +#endif
> +
>  static inline void clear_highpage(struct page *page)
>  {
>  	void *kaddr = kmap_atomic(page, KM_USER0);
> --- linux-2.6.18.5/include/asm-generic/mman.h	2006-12-02
> 05:43:05.000000000 +0530
> +++ linux-2.6.18.5/include/asm-generic/mman.h	2008-11-07
> 19:29:09.000000000 +0530
> @@ -20,6 +20,9 @@
>  #define MAP_FIXED	0x10		/* Interpret addr exactly */
>  #define MAP_ANONYMOUS	0x20		/* don't use a file */
>
> +#define MAP_COLORALIGN  0x0            /* can be redefined (undef) to
> 0x00200000 in arch specific mmap.h,
> +                                           if the processor has VIVT
> cache with multiple associativity */
> +
>  #define MS_ASYNC	1		/* sync memory asynchronously */
>  #define MS_INVALIDATE	2		/* invalidate the caches */
>  #define MS_SYNC		4		/* synchronous memory sync */
>
>
>
>
> PATCH 2 -- applies to uclibc ( in buildroot directory
> toolchain/kernel-headers ) -------------------
>
>
> --- linux/include/asm-arm/mman.h	2008-10-30 16:16:31.000000000 +0530
> +++ linux/include/asm-arm/mman.h	2008-10-30 16:16:46.000000000 +0530
> @@ -3,6 +3,8 @@
>
>  #include <asm-generic/mman.h>
>
> +#define MAP_COLORALIGN  0x0200      /* For VIVT caches - the
> alignment should be color aligned */
> +
>  #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
>  #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
>  #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
>
>
>
>
> PATCH 3  -- applies to uclibc ( in buildroot directory toolchain/uClibc )
> ---------------
>
>
> --- uClibc/libc/stdlib/malloc-standard/malloc.c	2008-10-31
> 13:03:29.000000000 +0530
> +++ uClibc/libc/stdlib/malloc-standard/malloc.c	2008-11-03
> 16:28:16.000000000 +0530
> @@ -342,7 +342,15 @@ void __do_check_malloc_state(void)
>    space to service request for nb bytes, thus requiring that av->top
>    be extended or replaced.
>  */
> -static void* __malloc_alloc(size_t nb, mstate av)
> +
> +/* To do :-
> +   Check if brk can be used to allocate smaller chunks. Maybe sbrk call
> checks +   for vma_flags (such as MAP_COLORALIGN flag) and only
> allocates/expands +   areas that use the same time. If such a functionality
> is not there, +   perhaps it can be added in future. For now, all
> MAP_COLORALIGN allocations +   go through mmap2.
> +*/
> +static void* __malloc_alloc(size_t nb, mstate av, const int map_flags)
>  {
>      mchunkptr       old_top;        /* incoming value of av->top */
>      size_t old_size;       /* its size */
> @@ -374,7 +382,7 @@ static void* __malloc_alloc(size_t nb, m
>         than in malloc proper.
>         */
>
> -    if (have_fastchunks(av)) {
> +    if (have_fastchunks(av) && !(map_flags & MAP_COLORALIGN)) {
>  	assert(in_smallbin_range(nb));
>  	__malloc_consolidate(av);
>  	return malloc(nb - MALLOC_ALIGN_MASK);
> @@ -389,7 +397,7 @@ static void* __malloc_alloc(size_t nb, m
>         */
>
>      if ((unsigned long)(nb) >= (unsigned long)(av->mmap_threshold) &&
> -	    (av->n_mmaps < av->n_mmaps_max)) {
> +	    (av->n_mmaps < av->n_mmaps_max) || (map_flags & MAP_COLORALIGN)) {
>
>  	char* mm;             /* return value from mmap call*/
>
> @@ -403,7 +411,7 @@ static void* __malloc_alloc(size_t nb, m
>  	/* Don't try if size wraps around 0 */
>  	if ((unsigned long)(size) > (unsigned long)(nb)) {
>
> -	    mm = (char*)(MMAP(0, size, PROT_READ|PROT_WRITE));
> +	    mm = (char*)(MMAP(0, size, PROT_READ|PROT_WRITE, map_flags));
>
>  	    if (mm != (char*)(MORECORE_FAILURE)) {
>
> @@ -523,7 +531,7 @@ static void* __malloc_alloc(size_t nb, m
>  	/* Don't try if size wraps around 0 */
>  	if ((unsigned long)(size) > (unsigned long)(nb)) {
>
> -	    fst_brk = (char*)(MMAP(0, size, PROT_READ|PROT_WRITE));
> +	    fst_brk = (char*)(MMAP(0, size, PROT_READ|PROT_WRITE, map_flags));
>
>  	    if (fst_brk != (char*)(MORECORE_FAILURE)) {
>
> @@ -802,6 +810,20 @@ static int __malloc_largebin_index(unsig
>  /* ------------------------------ malloc ------------------------------ */
>  void* malloc(size_t bytes)
>  {
> +   return __internal_malloc(bytes, 0);
> +}
> +
> +
> +/* ---------------------- __internal_malloc ------------------------------
> */ +
> +/* Why did we add ' map_flags ' to parameter list ?
> +   Using map_flags, we can inform the kernel of the following :-
> +    - vma is page color aligned (For ex, is needed for using O_DIRECT
> +      on a VIVT, multiple assosiative cache).
> +   The first user of _internal_malloc function would be memalign.
> +*/
> +void* __internal_malloc(size_t bytes, const int map_flags)
> +{
>      mstate av;
>
>      size_t nb;               /* normalized request size */
> @@ -851,6 +873,9 @@ void* malloc(size_t bytes)
>  	goto use_top;
>      }
>
> +    /* for VIVT caches, if we want color alignment, only use
> __malloc_alloc */ +    if (map_flags & MAP_COLORALIGN) goto use_top;
> +
>      /*
>         If the size qualifies as a fastbin, first check corresponding bin.
>         */
> @@ -927,7 +952,8 @@ void* malloc(size_t bytes)
>  	if (in_smallbin_range(nb) &&
>  		bck == unsorted_chunks(av) &&
>  		victim == av->last_remainder &&
> -		(unsigned long)(size) > (unsigned long)(nb + MINSIZE)) {
> +		(unsigned long)(size) > (unsigned long)(nb + MINSIZE))
> +                {
>
>  	    /* split and reattach remainder */
>  	    remainder_size = size - nb;
> @@ -1142,7 +1168,7 @@ use_top:
>      victim = av->top;
>      size = chunksize(victim);
>
> -    if ((unsigned long)(size) >= (unsigned long)(nb + MINSIZE)) {
> +    if ((unsigned long)(size) >= (unsigned long)(nb + MINSIZE) &&
> !map_flags) { remainder_size = size - nb;
>  	remainder = chunk_at_offset(victim, nb);
>  	av->top = remainder;
> @@ -1155,7 +1181,7 @@ use_top:
>      }
>
>      /* If no space in top, relay to handle system-dependent cases */
> -    sysmem = __malloc_alloc(nb, av);
> +    sysmem = __malloc_alloc(nb, av, map_flags);
>      retval = sysmem;
>  DONE:
>      __MALLOC_UNLOCK;
> --- uClibc/libc/stdlib/malloc-standard/malloc.h	2008-10-31
> 13:03:35.000000000 +0530
> +++ uClibc/libc/stdlib/malloc-standard/malloc.h	2008-11-03
> 17:59:57.000000000 +0530
> @@ -347,6 +347,7 @@ __UCLIBC_MUTEX_EXTERN(__malloc_lock);
>  /* ------------------ MMAP support ------------------  */
>  #include <fcntl.h>
>  #include <sys/mman.h>
> +#include <asm/mman.h>
>
>  #if !defined(MAP_ANONYMOUS) && defined(MAP_ANON)
>  #define MAP_ANONYMOUS MAP_ANON
> @@ -354,13 +355,13 @@ __UCLIBC_MUTEX_EXTERN(__malloc_lock);
>
>  #ifdef __ARCH_USE_MMU__
>
> -#define MMAP(addr, size, prot) \
> - (mmap((addr), (size), (prot), MAP_PRIVATE|MAP_ANONYMOUS, 0, 0))
> +#define MMAP(addr, size, prot, map) \
> + (mmap((addr), (size), (prot), MAP_PRIVATE|MAP_ANONYMOUS|map, 0, 0))
>
>  #else
>
> -#define MMAP(addr, size, prot) \
> - (mmap((addr), (size), (prot), MAP_SHARED|MAP_ANONYMOUS, 0, 0))
> +#define MMAP(addr, size, prot, map) \
> + (mmap((addr), (size), (prot), MAP_SHARED|MAP_ANONYMOUS|map, 0, 0))
>
>  #endif
>
> @@ -931,6 +932,7 @@ extern struct malloc_state __malloc_stat
>
>  /* External internal utilities operating on mstates */
>  void   __malloc_consolidate(mstate) attribute_hidden;
> +void*  __internal_malloc(size_t bytes, const int map_flags);
>
>
>  /* Debugging support */
> --- uClibc/libc/stdlib/malloc-standard/memalign.c	2008-10-31
> 13:03:47.000000000 +0530
> +++ uClibc/libc/stdlib/malloc-standard/memalign.c	2008-11-03
> 16:27:09.000000000 +0530
> @@ -59,9 +59,11 @@ void* memalign(size_t alignment, size_t
>       * request, and then possibly free the leading and trailing space.  */
>
>
> -    /* Call malloc with worst case padding to hit alignment. */
> -
> -    m  = (char*)(malloc(nb + alignment + MINSIZE));
> +    /* Call __internal_malloc with worst case padding to hit alignment.
> +       Note: MAP_COLORALIGN would be disregarded in the kernel if
> architecture +       does not require it. For ex, It is needed in case of
> ARM 11 processors. +     */
> +    m  = (char*)(__internal_malloc(nb + alignment + MINSIZE,
> MAP_COLORALIGN));
>
>      if (m == 0) {
>  	retval = 0; /* propagate failure */

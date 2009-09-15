Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZIOGjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZIOGjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZIOGjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:39:36 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:35151 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZIOGjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:39:35 -0400
MIME-Version: 1.0
In-Reply-To: <84144f020909141310y164b2d1ak44dd6945d35e6ec@mail.gmail.com>
References: <200909100215.36350.ngupta@vflare.org>
	 <200909100249.26284.ngupta@vflare.org>
	 <84144f020909141310y164b2d1ak44dd6945d35e6ec@mail.gmail.com>
Date: Tue, 15 Sep 2009 12:09:38 +0530
Message-ID: <d760cf2d0909142339i30d74a9dic7ece86e7227c2e2@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtual block device driver (ramzswap)
From: Nitin Gupta <ngupta@vflare.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

Thanks for review. My comments inline.

On Tue, Sep 15, 2009 at 1:40 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
> I am not a block driver expert but here are some comments on the code
> that probably need to be addressed before merging.
>
>                        Pekka

>
> On Thu, Sep 10, 2009 at 12:19 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>> +
>> +/* Globals */
>> +static int RAMZSWAP_MAJOR;
>> +static struct ramzswap *DEVICES;
>> +
>> +/*
>> + * Pages that compress to larger than this size are
>> + * forwarded to backing swap, if present or stored
>> + * uncompressed in memory otherwise.
>> + */
>> +static unsigned int MAX_CPAGE_SIZE;
>> +
>> +/* Module params (documentation at end) */
>> +static unsigned long NUM_DEVICES;
>
> These variable names should be in lower case.
>

Global variables with lower case causes confusion.


>> +
>> +/* Function declarations */
>> +static int __init ramzswap_init(void);
>> +static int ramzswap_ioctl(struct block_device *, fmode_t,
>> +                       unsigned, unsigned long);
>> +static int setup_swap_header(struct ramzswap *, union swap_header *);
>> +static void ramzswap_set_memlimit(struct ramzswap *, size_t);
>> +static void ramzswap_set_disksize(struct ramzswap *, size_t);
>> +static void reset_device(struct ramzswap *rzs);
>
> It's preferable not to use forward declarations in new kernel code.
>

okay, I will rearrange functions to avoid this.


>> +static int test_flag(struct ramzswap *rzs, u32 index, enum rzs_pageflags flag)
>> +{
>> +       return rzs->table[index].flags & BIT(flag);
>> +}
>> +
>> +static void set_flag(struct ramzswap *rzs, u32 index, enum rzs_pageflags flag)
>> +{
>> +       rzs->table[index].flags |= BIT(flag);
>> +}
>> +
>> +static void clear_flag(struct ramzswap *rzs, u32 index,
>> +                                       enum rzs_pageflags flag)
>> +{
>> +       rzs->table[index].flags &= ~BIT(flag);
>> +}
>
> These function names could use a ramzswap specific prefix.

okay.

>
>> +
>> +static int page_zero_filled(void *ptr)
>> +{
>> +       u32 pos;
>> +       u64 *page;
>> +
>> +       page = (u64 *)ptr;
>> +
>> +       for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
>> +               if (page[pos])
>> +                       return 0;
>> +       }
>> +
>> +       return 1;
>> +}
>
> This looks like something that could be in lib/string.c.
>
> /me looks
>
> There's strspn so maybe you could introduce a memspn equivalent.
>


Maybe this is just too specific to this driver. Who else will use it?
So, this simple function should stay within this driver only. If it
finds more user,
we can them move it to lib/string.c.

If I now move it to string.c I am sure I will get reverse argument
from someone else:
"currently, it has no other users so bury it with this driver only".


>> +
>> +/*
>> + * Given <pagenum, offset> pair, provide a dereferencable pointer.
>> + */
>> +static void *get_ptr_atomic(struct page *page, u16 offset, enum km_type type)
>> +{
>> +       unsigned char *base;
>> +
>> +       base = kmap_atomic(page, type);
>> +       return base + offset;
>> +}
>> +
>> +static void put_ptr_atomic(void *ptr, enum km_type type)
>> +{
>> +       kunmap_atomic(ptr, type);
>> +}
>
> These two functions also appear in xmalloc. It's probably best to just
> kill the wrappers and use kmap/kunmap directly.
>

Wrapper for kmap_atomic is nice as spreading:
kmap_atomic(page, KM_USER0,1) + offset everywhere looks worse.
What is the problem if these little 1-liner wrappers are repeated in
xvmalloc too?
To me, they just add some clarity.


>> +
>> +static void ramzswap_flush_dcache_page(struct page *page)
>> +{
>> +#ifdef CONFIG_ARM
>> +       int flag = 0;
>> +       /*
>> +        * Ugly hack to get flush_dcache_page() work on ARM.
>> +        * page_mapping(page) == NULL after clearing this swap cache flag.
>> +        * Without clearing this flag, flush_dcache_page() will simply set
>> +        * "PG_dcache_dirty" bit and return.
>> +        */
>> +       if (PageSwapCache(page)) {
>> +               flag = 1;
>> +               ClearPageSwapCache(page);
>> +       }
>> +#endif
>> +       flush_dcache_page(page);
>> +#ifdef CONFIG_ARM
>> +       if (flag)
>> +               SetPageSwapCache(page);
>> +#endif
>> +}
>
> The above CONFIG_ARM magic really has no place in drivers/block.
>

Please read the comment above this hack to see why its needed. Also,
for details see this mail:
http://www.linux-mips.org/archives/linux-mips/2008-11/msg00038.html

No one replied to above mail. So, I though just to temporarily introduce this
hack while someone makes a proper fix for ARM (I will probably ping ARM/MIPS
folks again for this).

Without this hack, ramzswap simply won't work on ARM. See:
http://code.google.com/p/compcache/issues/detail?id=33

So, its extremely difficult to wait for the _proper_ fix.


>> +
>> +       pr_debug(C "extent: [%lu, %lu] %lu\n", phy_pagenum,
>> +               phy_pagenum + num_pages - 1, num_pages);
>
> What's this "C" thing everywhere? A subsystem prefix? Shouldn't you
> override pr_fmt() instead?
>

Yes, "C" is subsystem prefix. Will now override pr_fmt() instead.


>> +
>> +       trace_mark(ramzswap_lock_wait, "ramzswap_lock_wait");
>> +       mutex_lock(&rzs->lock);
>> +       trace_mark(ramzswap_lock_acquired, "ramzswap_lock_acquired");
>
> Hmm? What's this? I don't think you should be doing ad hoc
> trace_mark() in driver code.
>

This is not ad hoc. It is to see contention over this lock which I believe is a
major bottleneck even on dual-cores. I need to keep this to measure improvements
as I gradually make this locking more fine grained (using per-cpu buffer etc).



>> +#if 0
>> +       /* Back-reference needed for memory defragmentation */
>> +       if (!test_flag(rzs, index, RZS_UNCOMPRESSED)) {
>> +               zheader = (struct zobj_header *)cmem;
>> +               zheader->table_idx = index;
>> +               cmem += sizeof(*zheader);
>> +       }
>> +#endif
>
> Drop the above dead code?


This is a reminder for me that every object has to contain this header
ultimately
and hence object data does not start immediately from start of chunk.

More than the dead code, the comment adds more value to it. So lets keep it.


>
>> +
>> +       memcpy(cmem, src, clen);
>> +
>> +       put_ptr_atomic(cmem, KM_USER1);
>> +       if (unlikely(test_flag(rzs, index, RZS_UNCOMPRESSED)))
>> +               put_ptr_atomic(src, KM_USER0);
>> +
>> +       /* Update stats */
>> +       rzs->stats.compr_size += clen;
>> +       stat_inc(rzs->stats.pages_stored);
>> +       stat_inc_if_less(rzs->stats.good_compress, clen, PAGE_SIZE / 2 + 1);
>> +
>> +       mutex_unlock(&rzs->lock);
>> +
>> +       set_bit(BIO_UPTODATE, &bio->bi_flags);
>> +       bio_endio(bio, 0);
>> +       return 0;
>> +
>> +out:
>> +       if (fwd_write_request) {
>> +               stat_inc(rzs->stats.bdev_num_writes);
>> +               bio->bi_bdev = rzs->backing_swap;
>> +#if 0
>> +               /*
>> +                * TODO: We currently have linear mapping of ramzswap and
>> +                * backing swap sectors. This is not desired since we want
>> +                * to optimize writes to backing swap to minimize disk seeks
>> +                * or have effective wear leveling (for SSDs). Also, a
>> +                * non-linear mapping is required to implement compressed
>> +                * on-disk swapping.
>> +                */
>> +                bio->bi_sector = get_backing_swap_page()
>> +                                       << SECTORS_PER_PAGE_SHIFT;
>> +#endif
>
> This too?
>

Again, I want to retain this comment. Its very important for me. So, I prefer to
keep this small bit of dead code.


>> +static int ramzswap_ioctl_init_device(struct ramzswap *rzs)
>> +{
>> +       int ret;
>> +       size_t num_pages, totalram_bytes;
>> +       struct sysinfo i;
>> +       struct page *page;
>> +       union swap_header *swap_header;
>> +
>> +       if (rzs->init_done) {
>> +               pr_info(C "Device already initialized!\n");
>> +               return -EBUSY;
>> +       }
>> +
>> +       ret = setup_backing_swap(rzs);
>> +       if (ret)
>> +               goto fail;
>> +
>> +       si_meminfo(&i);
>> +       /* Here is a trivia: guess unit used for i.totalram !! */
>> +       totalram_bytes = i.totalram << PAGE_SHIFT;
>
> You can use totalram_pages here. OTOH, I'm not sure why the driver
> needs this information. Hmm?
>

The driver sets 'disksize' as 25% of RAM by default. So, it needs to know
how much RAM the system has.

>> +
>> +       if (rzs->backing_swap)
>> +               ramzswap_set_memlimit(rzs, totalram_bytes);
>> +       else
>> +               ramzswap_set_disksize(rzs, totalram_bytes);
>> +
>> +       rzs->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
>> +       if (rzs->compress_workmem == NULL) {
>> +               pr_err(C "Error allocating compressor working memory!\n");
>> +               ret = -ENOMEM;
>> +               goto fail;
>> +       }
>> +
>> +       rzs->compress_buffer = kzalloc(2 * PAGE_SIZE, GFP_KERNEL);
>
> Use alloc_pages(__GFP_ZERO) here?
>

alloc pages then map them (i.e. vmalloc). What did we gain? With
vmalloc, pages might
not be physically contiguous which might hurt performance as
compressor runs over this buffer.

So, use kzalloc().


>> diff --git a/drivers/block/ramzswap/ramzswap_drv.h b/drivers/block/ramzswap/ramzswap_drv.h
>> new file mode 100644
>> index 0000000..7f77edc
>> --- /dev/null
>> +++ b/drivers/block/ramzswap/ramzswap_drv.h
>
>> +
>> +#define SECTOR_SHIFT           9
>> +#define SECTOR_SIZE            (1 << SECTOR_SHIFT)
>> +#define SECTORS_PER_PAGE_SHIFT (PAGE_SHIFT - SECTOR_SHIFT)
>> +#define SECTORS_PER_PAGE       (1 << SECTORS_PER_PAGE_SHIFT)
>
> Don't we have these defines somewhere in include/linux?
>

I couldn't find something equivalent. At least swap code hard codes a
value of 9.
So, a #define looks somewhat better.


>> +
>> +/* Message prefix */
>> +#define C "ramzswap: "
>
> Use pr_fmt() instead.

okay.


>
>> +
>> +/* Debugging and Stats */
>> +#define NOP    do { } while (0)
>
> Huh? Drop this.

This is more of individual taste. This makes the code look cleaner to me.
I hope its not considered 'over decoration'.


>
>> +
>> +#if defined(CONFIG_BLK_DEV_RAMZSWAP_STATS)
>> +#define STATS
>> +#endif
>
> Why can't you rename that to CONFIG_RAMZSWAP_STATS and use that
> instead of the very generic STATS?
>

Everything in drivers/block/Kconfig has BLK_DEV_ as prefix
BLK_DEV_RAM
BLK_DEV_RAM_COUNT
BLK_DEV_RAM_SIZE

and following the pattern:

BLK_DEV_RAMZSWAP
BLK_DEV_RAMZSWAP_STATS


STATS is just a convenient shortcut for very longish BLK_DEV_RAMZSWAP_STATS
but I see this not used very often, so this shortcut is really not
needed. I will now directly
use the long version.


>> +
>> +#if defined(STATS)
>> +#define stat_inc(stat)                 ((stat)++)
>> +#define stat_dec(stat)                 ((stat)--)
>> +#define stat_inc_if_less(stat, val1, val2) \
>> +                               ((stat) += ((val1) < (val2) ? 1 : 0))
>> +#define stat_dec_if_less(stat, val1, val2) \
>> +                               ((stat) -= ((val1) < (val2) ? 1 : 0))
>> +#else  /* STATS */
>> +#define stat_inc(x)                    NOP
>> +#define stat_dec(x)                    NOP
>> +#define stat_inc_if_less(x, v1, v2)    NOP
>> +#define stat_dec_if_less(x, v1, v2)    NOP
>> +#endif /* STATS */
>
> Why do you need inc_if_less() and dec_if_less()?

No good reason. I will get rid of inc/dec_if_less().


> And why are these not static inlines?
>

stats variables exist only when 'STATS' is defined. So, every call to static
inline will have to be enclosed within '#if defined (STATS)'. Thus we use
macros instead.

Thanks,
Nitin

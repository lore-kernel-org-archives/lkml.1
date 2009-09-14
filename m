Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbZINUKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbZINUKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933714AbZINUK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:10:28 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58498 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbZINUKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r8gc6ThnVzQC36mI7LYoc0YyNmCW4+8Aokze1L2CabOAW5nTCCROEMQvQ+nIW2yuxR
         0U1Y4bZeOGULpLpcoB9uMIyJUAIRtl5zFp+qg174JX/nHLmcsU2cIl50kO1xRCUjVgb6
         neZmKFy9Q2p4KDGA8g2uOn+uvMm4n5X3odMUw=
MIME-Version: 1.0
In-Reply-To: <200909100249.26284.ngupta@vflare.org>
References: <200909100215.36350.ngupta@vflare.org>
	 <200909100249.26284.ngupta@vflare.org>
Date: Mon, 14 Sep 2009 23:10:22 +0300
X-Google-Sender-Auth: b71134528c7c3449
Message-ID: <84144f020909141310y164b2d1ak44dd6945d35e6ec@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtual block device driver (ramzswap)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ngupta@vflare.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

I am not a block driver expert but here are some comments on the code
that probably need to be addressed before merging.

                        Pekka

On Thu, Sep 10, 2009 at 12:19 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> @@ -0,0 +1,1529 @@
> +/*
> + * Compressed RAM based swap device
> + *
> + * Copyright (C) 2008, 2009  Nitin Gupta
> + *
> + * This code is released using a dual license strategy: BSD/GPL
> + * You can choose the licence that better fits your requirements.
> + *
> + * Released under the terms of 3-clause BSD License
> + * Released under the terms of GNU General Public License Version 2.0
> + *
> + * Project home: http://compcache.googlecode.com
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/bitops.h>
> +#include <linux/blkdev.h>
> +#include <linux/buffer_head.h>
> +#include <linux/device.h>
> +#include <linux/genhd.h>
> +#include <linux/highmem.h>
> +#include <linux/lzo.h>
> +#include <linux/marker.h>
> +#include <linux/mutex.h>
> +#include <linux/string.h>
> +#include <linux/swap.h>
> +#include <linux/swapops.h>
> +#include <linux/vmalloc.h>
> +#include <linux/version.h>
> +
> +#include "ramzswap_drv.h"
> +
> +/* Globals */
> +static int RAMZSWAP_MAJOR;
> +static struct ramzswap *DEVICES;
> +
> +/*
> + * Pages that compress to larger than this size are
> + * forwarded to backing swap, if present or stored
> + * uncompressed in memory otherwise.
> + */
> +static unsigned int MAX_CPAGE_SIZE;
> +
> +/* Module params (documentation at end) */
> +static unsigned long NUM_DEVICES;

These variable names should be in lower case.

> +
> +/* Function declarations */
> +static int __init ramzswap_init(void);
> +static int ramzswap_ioctl(struct block_device *, fmode_t,
> +                       unsigned, unsigned long);
> +static int setup_swap_header(struct ramzswap *, union swap_header *);
> +static void ramzswap_set_memlimit(struct ramzswap *, size_t);
> +static void ramzswap_set_disksize(struct ramzswap *, size_t);
> +static void reset_device(struct ramzswap *rzs);

It's preferable not to use forward declarations in new kernel code.

> +static int test_flag(struct ramzswap *rzs, u32 index, enum rzs_pageflags flag)
> +{
> +       return rzs->table[index].flags & BIT(flag);
> +}
> +
> +static void set_flag(struct ramzswap *rzs, u32 index, enum rzs_pageflags flag)
> +{
> +       rzs->table[index].flags |= BIT(flag);
> +}
> +
> +static void clear_flag(struct ramzswap *rzs, u32 index,
> +                                       enum rzs_pageflags flag)
> +{
> +       rzs->table[index].flags &= ~BIT(flag);
> +}

These function names could use a ramzswap specific prefix.

> +
> +static int page_zero_filled(void *ptr)
> +{
> +       u32 pos;
> +       u64 *page;
> +
> +       page = (u64 *)ptr;
> +
> +       for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
> +               if (page[pos])
> +                       return 0;
> +       }
> +
> +       return 1;
> +}

This looks like something that could be in lib/string.c.

/me looks

There's strspn so maybe you could introduce a memspn equivalent.

> +
> +/*
> + * Given <pagenum, offset> pair, provide a dereferencable pointer.
> + */
> +static void *get_ptr_atomic(struct page *page, u16 offset, enum km_type type)
> +{
> +       unsigned char *base;
> +
> +       base = kmap_atomic(page, type);
> +       return base + offset;
> +}
> +
> +static void put_ptr_atomic(void *ptr, enum km_type type)
> +{
> +       kunmap_atomic(ptr, type);
> +}

These two functions also appear in xmalloc. It's probably best to just
kill the wrappers and use kmap/kunmap directly.

> +
> +static void ramzswap_flush_dcache_page(struct page *page)
> +{
> +#ifdef CONFIG_ARM
> +       int flag = 0;
> +       /*
> +        * Ugly hack to get flush_dcache_page() work on ARM.
> +        * page_mapping(page) == NULL after clearing this swap cache flag.
> +        * Without clearing this flag, flush_dcache_page() will simply set
> +        * "PG_dcache_dirty" bit and return.
> +        */
> +       if (PageSwapCache(page)) {
> +               flag = 1;
> +               ClearPageSwapCache(page);
> +       }
> +#endif
> +       flush_dcache_page(page);
> +#ifdef CONFIG_ARM
> +       if (flag)
> +               SetPageSwapCache(page);
> +#endif
> +}

The above CONFIG_ARM magic really has no place in drivers/block.

> +static int add_backing_swap_extent(struct ramzswap *rzs,
> +                               pgoff_t phy_pagenum,
> +                               pgoff_t num_pages)
> +{
> +       unsigned int idx;
> +       struct list_head *head;
> +       struct page *curr_page, *new_page;
> +       unsigned int extents_per_page = PAGE_SIZE /
> +                               sizeof(struct ramzswap_backing_extent);
> +
> +       idx = rzs->num_extents % extents_per_page;
> +       if (!idx) {
> +               new_page = alloc_page(__GFP_ZERO);
> +               if (!new_page)
> +                       return -ENOMEM;
> +
> +               if (rzs->num_extents) {
> +                       curr_page = virt_to_page(rzs->curr_extent);
> +                       head = &curr_page->lru;
> +               } else {
> +                       head = &rzs->backing_swap_extent_list;
> +               }
> +
> +               list_add(&new_page->lru, head);
> +               rzs->curr_extent = page_address(new_page);
> +       }
> +
> +       rzs->curr_extent->phy_pagenum = phy_pagenum;
> +       rzs->curr_extent->num_pages = num_pages;
> +
> +       pr_debug(C "extent: [%lu, %lu] %lu\n", phy_pagenum,
> +               phy_pagenum + num_pages - 1, num_pages);

What's this "C" thing everywhere? A subsystem prefix? Shouldn't you
override pr_fmt() instead?

> +static int ramzswap_write(struct ramzswap *rzs, struct bio *bio)
> +{
> +       int ret, fwd_write_request = 0;
> +       u32 offset;
> +       size_t clen;
> +       pgoff_t index;
> +       struct zobj_header *zheader;
> +       struct page *page, *page_store;
> +       unsigned char *user_mem, *cmem, *src;
> +
> +       stat_inc(rzs->stats.num_writes);
> +
> +       page = bio->bi_io_vec[0].bv_page;
> +       index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
> +
> +       src = rzs->compress_buffer;
> +
> +       /*
> +        * System swaps to same sector again when the stored page
> +        * is no longer referenced by any process. So, its now safe
> +        * to free the memory that was allocated for this page.
> +        */
> +       if (rzs->table[index].page)
> +               ramzswap_free_page(rzs, index);
> +
> +       /*
> +        * No memory ia allocated for zero filled pages.
> +        * Simply clear zero page flag.
> +        */
> +       if (test_flag(rzs, index, RZS_ZERO)) {
> +               stat_dec(rzs->stats.pages_zero);
> +               clear_flag(rzs, index, RZS_ZERO);
> +       }
> +
> +       trace_mark(ramzswap_lock_wait, "ramzswap_lock_wait");
> +       mutex_lock(&rzs->lock);
> +       trace_mark(ramzswap_lock_acquired, "ramzswap_lock_acquired");

Hmm? What's this? I don't think you should be doing ad hoc
trace_mark() in driver code.

> +
> +       user_mem = get_ptr_atomic(page, 0, KM_USER0);
> +       if (page_zero_filled(user_mem)) {
> +               put_ptr_atomic(user_mem, KM_USER0);
> +               mutex_unlock(&rzs->lock);
> +               stat_inc(rzs->stats.pages_zero);
> +               set_flag(rzs, index, RZS_ZERO);
> +
> +               set_bit(BIO_UPTODATE, &bio->bi_flags);
> +               bio_endio(bio, 0);
> +               return 0;
> +       }
> +
> +       if (rzs->backing_swap &&
> +               (rzs->stats.compr_size > rzs->memlimit - PAGE_SIZE)) {
> +               put_ptr_atomic(user_mem, KM_USER0);
> +               mutex_unlock(&rzs->lock);
> +               fwd_write_request = 1;
> +               goto out;
> +       }
> +
> +       ret = lzo1x_1_compress(user_mem, PAGE_SIZE, src, &clen,
> +                               rzs->compress_workmem);
> +
> +       put_ptr_atomic(user_mem, KM_USER0);
> +
> +       if (unlikely(ret != LZO_E_OK)) {
> +               mutex_unlock(&rzs->lock);
> +               pr_err(C "Compression failed! err=%d\n", ret);
> +               stat_inc(rzs->stats.failed_writes);
> +               goto out;
> +       }
> +
> +       /*
> +        * Page is incompressible. Forward it to backing swap
> +        * if present. Otherwise, store it as-is (uncompressed)
> +        * since we do not want to return too many swap write
> +        * errors which has side effect of hanging the system.
> +        */
> +       if (unlikely(clen > MAX_CPAGE_SIZE)) {
> +               if (rzs->backing_swap) {
> +                       mutex_unlock(&rzs->lock);
> +                       fwd_write_request = 1;
> +                       goto out;
> +               }
> +
> +               clen = PAGE_SIZE;
> +               page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
> +               if (unlikely(!page_store)) {
> +                       mutex_unlock(&rzs->lock);
> +                       pr_info(C "Error allocating memory for incompressible "
> +                               "page: %lu\n", index);
> +                       stat_inc(rzs->stats.failed_writes);
> +                       goto out;
> +               }
> +
> +               offset = 0;
> +               set_flag(rzs, index, RZS_UNCOMPRESSED);
> +               stat_inc(rzs->stats.pages_expand);
> +               rzs->table[index].page = page_store;
> +               src = get_ptr_atomic(page, 0, KM_USER0);
> +               goto memstore;
> +       }
> +
> +       if (xv_malloc(rzs->mem_pool, clen + sizeof(*zheader),
> +                       &rzs->table[index].page, &offset,
> +                       GFP_NOIO | __GFP_HIGHMEM)) {
> +               mutex_unlock(&rzs->lock);
> +               pr_info(C "Error allocating memory for compressed "
> +                       "page: %lu, size=%zu\n", index, clen);
> +               stat_inc(rzs->stats.failed_writes);
> +               if (rzs->backing_swap)
> +                       fwd_write_request = 1;
> +               goto out;
> +       }
> +
> +memstore:
> +       rzs->table[index].offset = offset;
> +
> +       cmem = get_ptr_atomic(rzs->table[index].page,
> +                       rzs->table[index].offset, KM_USER1);
> +
> +#if 0
> +       /* Back-reference needed for memory defragmentation */
> +       if (!test_flag(rzs, index, RZS_UNCOMPRESSED)) {
> +               zheader = (struct zobj_header *)cmem;
> +               zheader->table_idx = index;
> +               cmem += sizeof(*zheader);
> +       }
> +#endif

Drop the above dead code?

> +
> +       memcpy(cmem, src, clen);
> +
> +       put_ptr_atomic(cmem, KM_USER1);
> +       if (unlikely(test_flag(rzs, index, RZS_UNCOMPRESSED)))
> +               put_ptr_atomic(src, KM_USER0);
> +
> +       /* Update stats */
> +       rzs->stats.compr_size += clen;
> +       stat_inc(rzs->stats.pages_stored);
> +       stat_inc_if_less(rzs->stats.good_compress, clen, PAGE_SIZE / 2 + 1);
> +
> +       mutex_unlock(&rzs->lock);
> +
> +       set_bit(BIO_UPTODATE, &bio->bi_flags);
> +       bio_endio(bio, 0);
> +       return 0;
> +
> +out:
> +       if (fwd_write_request) {
> +               stat_inc(rzs->stats.bdev_num_writes);
> +               bio->bi_bdev = rzs->backing_swap;
> +#if 0
> +               /*
> +                * TODO: We currently have linear mapping of ramzswap and
> +                * backing swap sectors. This is not desired since we want
> +                * to optimize writes to backing swap to minimize disk seeks
> +                * or have effective wear leveling (for SSDs). Also, a
> +                * non-linear mapping is required to implement compressed
> +                * on-disk swapping.
> +                */
> +                bio->bi_sector = get_backing_swap_page()
> +                                       << SECTORS_PER_PAGE_SHIFT;
> +#endif

This too?

> +static int ramzswap_ioctl_init_device(struct ramzswap *rzs)
> +{
> +       int ret;
> +       size_t num_pages, totalram_bytes;
> +       struct sysinfo i;
> +       struct page *page;
> +       union swap_header *swap_header;
> +
> +       if (rzs->init_done) {
> +               pr_info(C "Device already initialized!\n");
> +               return -EBUSY;
> +       }
> +
> +       ret = setup_backing_swap(rzs);
> +       if (ret)
> +               goto fail;
> +
> +       si_meminfo(&i);
> +       /* Here is a trivia: guess unit used for i.totalram !! */
> +       totalram_bytes = i.totalram << PAGE_SHIFT;

You can use totalram_pages here. OTOH, I'm not sure why the driver
needs this information. Hmm?

> +
> +       if (rzs->backing_swap)
> +               ramzswap_set_memlimit(rzs, totalram_bytes);
> +       else
> +               ramzswap_set_disksize(rzs, totalram_bytes);
> +
> +       rzs->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
> +       if (rzs->compress_workmem == NULL) {
> +               pr_err(C "Error allocating compressor working memory!\n");
> +               ret = -ENOMEM;
> +               goto fail;
> +       }
> +
> +       rzs->compress_buffer = kzalloc(2 * PAGE_SIZE, GFP_KERNEL);

Use alloc_pages(__GFP_ZERO) here?

> diff --git a/drivers/block/ramzswap/ramzswap_drv.h b/drivers/block/ramzswap/ramzswap_drv.h
> new file mode 100644
> index 0000000..7f77edc
> --- /dev/null
> +++ b/drivers/block/ramzswap/ramzswap_drv.h

> +
> +#define SECTOR_SHIFT           9
> +#define SECTOR_SIZE            (1 << SECTOR_SHIFT)
> +#define SECTORS_PER_PAGE_SHIFT (PAGE_SHIFT - SECTOR_SHIFT)
> +#define SECTORS_PER_PAGE       (1 << SECTORS_PER_PAGE_SHIFT)

Don't we have these defines somewhere in include/linux?

> +
> +/* Message prefix */
> +#define C "ramzswap: "

Use pr_fmt() instead.

> +
> +/* Debugging and Stats */
> +#define NOP    do { } while (0)

Huh? Drop this.

> +
> +#if defined(CONFIG_BLK_DEV_RAMZSWAP_STATS)
> +#define STATS
> +#endif

Why can't you rename that to CONFIG_RAMZSWAP_STATS and use that
instead of the very generic STATS?

> +
> +#if defined(STATS)
> +#define stat_inc(stat)                 ((stat)++)
> +#define stat_dec(stat)                 ((stat)--)
> +#define stat_inc_if_less(stat, val1, val2) \
> +                               ((stat) += ((val1) < (val2) ? 1 : 0))
> +#define stat_dec_if_less(stat, val1, val2) \
> +                               ((stat) -= ((val1) < (val2) ? 1 : 0))
> +#else  /* STATS */
> +#define stat_inc(x)                    NOP
> +#define stat_dec(x)                    NOP
> +#define stat_inc_if_less(x, v1, v2)    NOP
> +#define stat_dec_if_less(x, v1, v2)    NOP
> +#endif /* STATS */

Why do you need inc_if_less() and dec_if_less()? And why are these not
static inlines?

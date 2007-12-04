Return-Path: <linux-kernel-owner+w=401wt.eu-S1751456AbXLDGaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbXLDGaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 01:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXLDG36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 01:29:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbXLDG35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 01:29:57 -0500
Date: Mon, 3 Dec 2007 22:29:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] rewrite rd
Message-Id: <20071203222903.c820707b.akpm@linux-foundation.org>
In-Reply-To: <20071204042628.GA26636@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 05:26:28 +0100 Nick Piggin <npiggin@suse.de> wrote:

> Hi,
> 
> This is my proposal for a (hopefully) backwards compatible rd driver.
> The motivation for me is not pressing, except that I have this code
> sitting here that is either going to rot or get merged. I'm happy to
> make myself maintainer of this code, but if any real block device
> driver writer would like to, that would be fine by me ;)
> 
> Comments?
> 
> --
> 
> This is a rewrite of the ramdisk block device driver.
> 
> The old one is really difficult because it effectively implements a block
> device which serves data out of its own buffer cache. It relies on the dirty
> bit being set, to pin its backing store in cache, however there are non
> trivial paths which can clear the dirty bit (eg. try_to_free_buffers()),
> which had recently lead to data corruption. And in general it is completely
> wrong for a block device driver to do this.
> 
> The new one is more like a regular block device driver. It has no idea
> about vm/vfs stuff. It's backing store is similar to the buffer cache
> (a simple radix-tree of pages), but it doesn't know anything about page
> cache (the pages in the radix tree are not pagecache pages).
> 
> There is one slight downside -- direct block device access and filesystem
> metadata access goes through an extra copy and gets stored in RAM twice.
> However, this downside is only slight, because the real buffercache of the
> device is now reclaimable (because we're not playing crazy games with it),
> so under memory intensive situations, footprint should effectively be the
> same -- maybe even a slight advantage to the new driver because it can also
> reclaim buffer heads.

what about mmap(/dev/ram0)?

> The fact that it now goes through all the regular vm/fs paths makes it
> much more useful for testing, too.
> 
>    text    data     bss     dec     hex filename
>    2837     849     384    4070     fe6 drivers/block/rd.o
>    3528     371      12    3911     f47 drivers/block/brd.o
> 
> Text is larger, but data and bss are smaller, making total size smaller.
> 
> A few other nice things about it:
> - Similar structure and layout to the new loop device handlinag.
> - Dynamic ramdisk creation.
> - Runtime flexible buffer head size (because it is no longer part of the
>   ramdisk code).
> - Boot / load time flexible ramdisk size, which could easily be extended
>   to a per-ramdisk runtime changeable size (eg. with an ioctl).

This ramdisk driver can use highmem whereas the existing one can't (yes?). 
That's a pretty major difference.  Plus look at the revoltingness in rd.c's
mapping_set_gfp_mask()s.

> +++ linux-2.6/drivers/block/brd.c
> @@ -0,0 +1,536 @@
> +/*
> + * Ram backed block device driver.
> + *
> + * Copyright (C) 2007 Nick Piggin
> + * Copyright (C) 2007 Novell Inc.
> + *
> + * Parts derived from drivers/block/rd.c, and drivers/block/loop.c, copyright
> + * of their respective owners.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/major.h>
> +#include <linux/blkdev.h>
> +#include <linux/bio.h>
> +#include <linux/highmem.h>
> +#include <linux/gfp.h>
> +#include <linux/radix-tree.h>
> +#include <linux/buffer_head.h> /* invalidate_bh_lrus() */
> +
> +#include <asm/uaccess.h>
> +
> +#define SECTOR_SHIFT		9

That's our third definition of SECTOR_SHIFT.

> +#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
> +#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
> +
> +/*
> + * Each block ramdisk device has a radix_tree brd_pages of pages that stores
> + * the pages containing the block device's contents. A brd page's ->index is
> + * its offset in PAGE_SIZE units. This is similar to, but in no way connected
> + * with, the kernel's pagecache or buffer cache (which sit above our block
> + * device).
> + */
> +struct brd_device {
> +	int		brd_number;
> +	int		brd_refcnt;
> +	loff_t		brd_offset;
> +	loff_t		brd_sizelimit;
> +	unsigned	brd_blocksize;
> +
> +	struct request_queue	*brd_queue;
> +	struct gendisk		*brd_disk;
> +	struct list_head	brd_list;
> +
> +	/*
> +	 * Backing store of pages and lock to protect it. This is the contents
> +	 * of the block device.
> +	 */
> +	spinlock_t		brd_lock;
> +	struct radix_tree_root	brd_pages;
> +};
> +
> +/*
> + * Look up and return a brd's page for a given sector.
> + */
> +static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
> +{
> +	unsigned long idx;

Could use pgoff_t here if you think that's clearer.

> +	struct page *page;
> +
> +	/*
> +	 * The page lifetime is protected by the fact that we have opened the
> +	 * device node -- brd pages will never be deleted under us, so we
> +	 * don't need any further locking or refcounting.
> +	 *
> +	 * This is strictly true for the radix-tree nodes as well (ie. we
> +	 * don't actually need the rcu_read_lock()), however that is not a
> +	 * documented feature of the radix-tree API so it is better to be
> +	 * safe here (we don't have total exclusion from radix tree updates
> +	 * here, only deletes).
> +	 */
> +	rcu_read_lock();
> +	idx = sector >> PAGE_SECTORS_SHIFT; /* sector to page index */
> +	page = radix_tree_lookup(&brd->brd_pages, idx);
> +	rcu_read_unlock();
> +
> +	BUG_ON(page && page->index != idx);
> +
> +	return page;
> +}
> +
> +/*
> + * Look up and return a brd's page for a given sector.
> + * If one does not exist, allocate an empty page, and insert that. Then
> + * return it.
> + */
> +static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
> +{
> +	unsigned long idx;
> +	struct page *page;
> +
> +	page = brd_lookup_page(brd, sector);
> +	if (page)
> +		return page;
> +
> +	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);

Why GFP_NOIO?

Have you thought about __GFP_MOVABLE treatment here?  Seems pretty
desirable as this sucker can be large.

> +	if (!page)
> +		return NULL;
> +
> +	if (radix_tree_preload(GFP_NOIO)) {
> +		__free_page(page);
> +		return NULL;
> +	}
> +
> +	spin_lock(&brd->brd_lock);
> +	idx = sector >> PAGE_SECTORS_SHIFT;
> +	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
> +		__free_page(page);
> +		page = radix_tree_lookup(&brd->brd_pages, idx);
> +		BUG_ON(!page);
> +		BUG_ON(page->index != idx);
> +	} else
> +		page->index = idx;
> +	spin_unlock(&brd->brd_lock);
> +
> +	radix_tree_preload_end();
> +
> +	return page;
> +}
> +
> +/*
> + * Free all backing store pages and radix tree. This must only be called when
> + * there are no other users of the device.
> + */
> +#define FREE_BATCH 16
> +static void brd_free_pages(struct brd_device *brd)
> +{
> +	unsigned long pos = 0;
> +	struct page *pages[FREE_BATCH];
> +	int nr_pages;
> +
> +	do {
> +		int i;
> +
> +		nr_pages = radix_tree_gang_lookup(&brd->brd_pages,
> +				(void **)pages, pos, FREE_BATCH);
> +
> +		for (i = 0; i < nr_pages; i++) {
> +			void *ret;
> +
> +			BUG_ON(pages[i]->index < pos);
> +			pos = pages[i]->index;
> +			ret = radix_tree_delete(&brd->brd_pages, pos);
> +			BUG_ON(!ret || ret != pages[i]);
> +			__free_page(pages[i]);
> +		}
> +
> +		pos++;
> +
> +	} while (nr_pages == FREE_BATCH);
> +}

I have vague memories that radix_tree_gang_lookup()'s "naive"
implementation may return fewer items than you asked for even when there
are more items remaining - when it hits certain boundaries.

> +/*
> + * copy_to_brd_setup must be called before copy_to_brd. It may sleep.
> + */
> +static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n)
> +{
> +	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
> +	size_t copy;
> +
> +	copy = min((unsigned long)n, PAGE_SIZE - offset);

use min_t.  Or, better, sort out the types.

> +	if (!brd_insert_page(brd, sector))
> +		return -ENOMEM;
> +	if (copy < n) {
> +		sector += copy >> SECTOR_SHIFT;
> +		if (!brd_insert_page(brd, sector))
> +			return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Copy n bytes from src to the brd starting at sector. Does not sleep.
> + */
> +static void copy_to_brd(struct brd_device *brd, const void *src,
> +			sector_t sector, size_t n)
> +{
> +	struct page *page;
> +	void *dst;
> +	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
> +	size_t copy;
> +
> +	copy = min((unsigned long)n, PAGE_SIZE - offset);

Ditto.

> +	page = brd_lookup_page(brd, sector);
> +	BUG_ON(!page);
> +
> +	dst = kmap_atomic(page, KM_USER1);
> +	memcpy(dst + offset, src, copy);
> +	kunmap_atomic(dst, KM_USER1);

Might need flush_dcache_page() if mmap gets sorted out.

> +	if (copy < n) {
> +		src += copy;
> +		sector += copy >> SECTOR_SHIFT;
> +		copy = n - copy;
> +		page = brd_lookup_page(brd, sector);
> +		BUG_ON(!page);
> +
> +		dst = kmap_atomic(page, KM_USER1);
> +		memcpy(dst, src, copy);
> +		kunmap_atomic(dst, KM_USER1);
> +	}
> +}
> +
> +/*
> + * Copy n bytes to dst from the brd starting at sector. Does not sleep.
> + */
> +static void copy_from_brd(void *dst, struct brd_device *brd,
> +			sector_t sector, size_t n)
> +{
> +	struct page *page;
> +	const void *src;
> +	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
> +	size_t copy;
> +
> +	copy = min((unsigned long)n, PAGE_SIZE - offset);

tritto.

> +	page = brd_lookup_page(brd, sector);
> +	if (page) {
> +		src = kmap_atomic(page, KM_USER1);
> +		memcpy(dst, src + offset, copy);
> +		kunmap_atomic(src, KM_USER1);
> +	} else
> +		memset(dst, 0, copy);
> +
> +	if (copy < n) {
> +		dst += copy;
> +		sector += copy >> SECTOR_SHIFT;
> +		copy = n - copy;
> +		page = brd_lookup_page(brd, sector);
> +		if (page) {
> +			src = kmap_atomic(page, KM_USER1);
> +			memcpy(dst, src, copy);
> +			kunmap_atomic(src, KM_USER1);
> +		} else
> +			memset(dst, 0, copy);
> +	}
> +}
> +
> +/*
> + * Process a single bvec of a bio.
> + */
> +static int brd_do_bvec(struct brd_device *brd, struct page *page,
> +			unsigned int len, unsigned int off, int rw,
> +			sector_t sector)
> +{
> +	void *mem;
> +	int err = 0;
> +
> +	if (rw != READ) {
> +		err = copy_to_brd_setup(brd, sector, len);
> +		if (err)
> +			goto out;
> +	}
> +
> +	mem = kmap_atomic(page, KM_USER0);
> +	if (rw == READ) {
> +		copy_from_brd(mem + off, brd, sector, len);
> +		flush_dcache_page(page);

hm, there's a flush_dcache_page().  I guess you've throught it through ;)

> +	} else
> +		copy_to_brd(brd, mem + off, sector, len);
> +	kunmap_atomic(mem, KM_USER0);
> +
> +out:
> +	return err;
> +}
> +
>
> ...
>
> +static int brd_ioctl(struct inode *inode, struct file *file,
> +			unsigned int cmd, unsigned long arg)
> +{
> +	int error;
> +	struct block_device *bdev = inode->i_bdev;
> +	struct brd_device *brd = bdev->bd_disk->private_data;
> +
> +	if (cmd != BLKFLSBUF)
> +		return -ENOTTY;
> +
> +	/*
> +	 * ram device BLKFLSBUF has special semantics, we want to actually
> +	 * release and destroy the ramdisk data.
> +	 */
> +	mutex_lock(&bdev->bd_mutex);
> +	error = -EBUSY;
> +	if (bdev->bd_openers <= 1) {
> +		/*
> +		 * Invalidate the cache first, so it isn't written
> +		 * back to the device.
> +		 */
> +		invalidate_bh_lrus();
> +		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);

hm, some other thread can instantiate pagecache here.  I guess it's always
been like that and there's not a lot we can (or should) do about it.

> +		brd_free_pages(brd);
> +		error = 0;
> +	}
> +	mutex_unlock(&bdev->bd_mutex);
> +
> +	return error;
> +}
> +
>
> ...
>
> --- linux-2.6.orig/fs/buffer.c
> +++ linux-2.6/fs/buffer.c
> @@ -1436,6 +1436,7 @@ void invalidate_bh_lrus(void)
>  {
>  	on_each_cpu(invalidate_bh_lru, NULL, 1, 1);
>  }
> +EXPORT_SYMBOL_GPL(invalidate_bh_lrus);

Maybe create a new helper function which does
invalidate_bh_lrus()+truncate_inode_pages(), call that from kill_bdev() and
here, make invalidate_bh_lrus() static.

That's a separate patch, I guess.

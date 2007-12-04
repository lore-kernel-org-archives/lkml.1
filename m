Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXLDHBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXLDHBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXLDHBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:01:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbXLDHBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:01:34 -0500
Date: Tue, 4 Dec 2007 08:01:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] rewrite rd
Message-ID: <20071204070131.GE31482@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <20071203222903.c820707b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203222903.c820707b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 10:29:03PM -0800, Andrew Morton wrote:
> On Tue, 4 Dec 2007 05:26:28 +0100 Nick Piggin <npiggin@suse.de> wrote:
> > 
> > There is one slight downside -- direct block device access and filesystem
> > metadata access goes through an extra copy and gets stored in RAM twice.
> > However, this downside is only slight, because the real buffercache of the
> > device is now reclaimable (because we're not playing crazy games with it),
> > so under memory intensive situations, footprint should effectively be the
> > same -- maybe even a slight advantage to the new driver because it can also
> > reclaim buffer heads.
> 
> what about mmap(/dev/ram0)?

Same thing I guess -- it will use more memory in the common case, but should
actually be able to reclaim slightly more memory under pressure, so the
tiny systems guys shouldn't have too much trouble.

And we're avoiding the whole class of aliasing problems where mmap on
the old rd driver means that you're creating new mappings to your backing
store pages.

 
> > Text is larger, but data and bss are smaller, making total size smaller.
> > 
> > A few other nice things about it:
> > - Similar structure and layout to the new loop device handlinag.
> > - Dynamic ramdisk creation.
> > - Runtime flexible buffer head size (because it is no longer part of the
> >   ramdisk code).
> > - Boot / load time flexible ramdisk size, which could easily be extended
> >   to a per-ramdisk runtime changeable size (eg. with an ioctl).
> 
> This ramdisk driver can use highmem whereas the existing one can't (yes?). 
> That's a pretty major difference.  Plus look at the revoltingness in rd.c's
> mapping_set_gfp_mask()s.

Ah yep, there is the highmem advantage too.


> > +#define SECTOR_SHIFT		9
> 
> That's our third definition of SECTOR_SHIFT.

Or 7th, depend on how you count ;) I always thought redefining it is a
prerequsite to getting anything merged into the block layer, so I'm too
scared to put it in include/linux/blkdev.h ;)


> > +/*
> > + * Look up and return a brd's page for a given sector.
> > + */
> > +static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
> > +{
> > +	unsigned long idx;
> 
> Could use pgoff_t here if you think that's clearer.

I guess it is. Although on one hand the radix-tree uses unsigned long, but
on the other hand, page->index is pgoff.

> > +{
> > +	unsigned long idx;
> > +	struct page *page;
> > +
> > +	page = brd_lookup_page(brd, sector);
> > +	if (page)
> > +		return page;
> > +
> > +	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);
> 
> Why GFP_NOIO?

I guess it has similar issues to rd.c -- we can't risk recursing
into the block layer here. However unlike rd.c, we _could_ easily
add some mode or ioctl to allocate the backing store upfront, with
full reclaim flags...

 
> Have you thought about __GFP_MOVABLE treatment here?  Seems pretty
> desirable as this sucker can be large.

AFAIK that only applies to pagecache but I haven't been paying much
attention to that stuff lately. It wouldn't be hard to move these
pages around, if we had a hook from the vm for it.
 

> > +static void brd_free_pages(struct brd_device *brd)
> > +{
> > +	unsigned long pos = 0;
> > +	struct page *pages[FREE_BATCH];
> > +	int nr_pages;
> > +
> > +	do {
> > +		int i;
> > +
> > +		nr_pages = radix_tree_gang_lookup(&brd->brd_pages,
> > +				(void **)pages, pos, FREE_BATCH);
> > +
> > +		for (i = 0; i < nr_pages; i++) {
> > +			void *ret;
> > +
> > +			BUG_ON(pages[i]->index < pos);
> > +			pos = pages[i]->index;
> > +			ret = radix_tree_delete(&brd->brd_pages, pos);
> > +			BUG_ON(!ret || ret != pages[i]);
> > +			__free_page(pages[i]);
> > +		}
> > +
> > +		pos++;
> > +
> > +	} while (nr_pages == FREE_BATCH);
> > +}
> 
> I have vague memories that radix_tree_gang_lookup()'s "naive"
> implementation may return fewer items than you asked for even when there
> are more items remaining - when it hits certain boundaries.

Good memory, but it's the low level leaf traversal that bales out at
boundaries. The higher level code then retries, so we should be OK
here.

> > +/*
> > + * copy_to_brd_setup must be called before copy_to_brd. It may sleep.
> > + */
> > +static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n)
> > +{
> > +	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
> > +	size_t copy;
> > +
> > +	copy = min((unsigned long)n, PAGE_SIZE - offset);
> 
> use min_t.  Or, better, sort out the types.

I guess the API is using size_t, so that would be the more approprite type
to convert to. And I'll use min_t too.


> > +static void copy_to_brd(struct brd_device *brd, const void *src,
> > +			sector_t sector, size_t n)
> > +{
> > +	struct page *page;
> > +	void *dst;
> > +	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
> > +	size_t copy;
> > +
> > +	copy = min((unsigned long)n, PAGE_SIZE - offset);
> 
> Ditto.
> 
> > +	page = brd_lookup_page(brd, sector);
> > +	BUG_ON(!page);
> > +
> > +	dst = kmap_atomic(page, KM_USER1);
> > +	memcpy(dst + offset, src, copy);
> > +	kunmap_atomic(dst, KM_USER1);
> 
> Might need flush_dcache_page() if mmap gets sorted out.

The brd backing store never gets any userspace aliases, so I think it should
be OK when copying into it.

 
> > +static int brd_do_bvec(struct brd_device *brd, struct page *page,
> > +			unsigned int len, unsigned int off, int rw,
> > +			sector_t sector)
> > +{
> > +	void *mem;
> > +	int err = 0;
> > +
> > +	if (rw != READ) {
> > +		err = copy_to_brd_setup(brd, sector, len);
> > +		if (err)
> > +			goto out;
> > +	}
> > +
> > +	mem = kmap_atomic(page, KM_USER0);
> > +	if (rw == READ) {
> > +		copy_from_brd(mem + off, brd, sector, len);
> > +		flush_dcache_page(page);
> 
> hm, there's a flush_dcache_page().  I guess you've throught it through ;)

Copying into the pagecache yes needs to flush I think. Although strictly it
also needs a write barrier to prevent these stores being passed by the store
to set PG_uptodate (but that's another story, which I think should be fixed
in the PageUptodate macros rather than device drivers and filesystems...)

> > +	mutex_lock(&bdev->bd_mutex);
> > +	error = -EBUSY;
> > +	if (bdev->bd_openers <= 1) {
> > +		/*
> > +		 * Invalidate the cache first, so it isn't written
> > +		 * back to the device.
> > +		 */
> > +		invalidate_bh_lrus();
> > +		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
> 
> hm, some other thread can instantiate pagecache here.  I guess it's always
> been like that and there's not a lot we can (or should) do about it.
 
Yeah, another thread could do that...


> > +		brd_free_pages(brd);
> > +		error = 0;
> > +	}
> > +	mutex_unlock(&bdev->bd_mutex);
> > +
> > +	return error;
> > +}
> > +
> >
> > ...
> >
> > --- linux-2.6.orig/fs/buffer.c
> > +++ linux-2.6/fs/buffer.c
> > @@ -1436,6 +1436,7 @@ void invalidate_bh_lrus(void)
> >  {
> >  	on_each_cpu(invalidate_bh_lru, NULL, 1, 1);
> >  }
> > +EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
> 
> Maybe create a new helper function which does
> invalidate_bh_lrus()+truncate_inode_pages(), call that from kill_bdev() and
> here, make invalidate_bh_lrus() static.
> 
> That's a separate patch, I guess.

I was thinking also that perhaps the buffer cache layer could intercept
the ioctl on the way through and flush the buffer cache before going to
the device -- so device drivers don't have to have _any_ knowledge
about the buffer cache...?

Thanks for the review, I'll post an incremental patch in a sec.


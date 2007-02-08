Return-Path: <linux-kernel-owner+w=401wt.eu-S1423150AbXBHOrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423150AbXBHOrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 09:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423123AbXBHOrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 09:47:09 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:31819 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422783AbXBHOrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 09:47:07 -0500
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/3] ext2: use perform_write aop
References: <20070208105437.26443.35653.sendpatchset@linux.site>
	<20070208105508.26443.7806.sendpatchset@linux.site>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Thu, 08 Feb 2007 17:47:18 +0300
In-Reply-To: <20070208105508.26443.7806.sendpatchset@linux.site> (Nick Piggin's message of "Thu,  8 Feb 2007 14:07:46 +0100 (CET)")
Message-ID: <87zm7on1u1.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> Convert ext2 to use ->perform_write. This uses the main loop out of
> generic_perform_write, but when encountering a short usercopy, it
> zeroes out new uninitialised blocks, and passes in a short-length commit
> to __block_commit_write, which does the right thing (in terms of not
> setting things uptodate).
>
>  fs/buffer.c                 |  143 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext2/inode.c             |    7 ++
>  include/linux/buffer_head.h |    1 
>  include/linux/pagemap.h     |    2 
>  4 files changed, 153 insertions(+)
>
> Index: linux-2.6/fs/buffer.c
> ===================================================================
> --- linux-2.6.orig/fs/buffer.c
> +++ linux-2.6/fs/buffer.c
> @@ -1866,6 +1866,50 @@ next_bh:
>  	return err;
>  }
>  
> +void page_zero_new_buffers(struct page *page, unsigned from, unsigned to)
> +{
> +	unsigned int block_start, block_end;
> +	struct buffer_head *head, *bh;
> +
> +	BUG_ON(!PageLocked(page));
> +	if (!page_has_buffers(page))
> +		return;
> +
> +	bh = head = page_buffers(page);
> +	block_start = 0;
> +	do {
> +		block_end = block_start + bh->b_size;
> +
> +		if (buffer_new(bh)) {
> +			if (block_end > from && block_start < to) {
> +				if (!PageUptodate(page)) {
> +					unsigned start, end;
> +					void *kaddr;
> +
> +					start = max(from, block_start);
> +					end = min(to, block_end);
> +
> +					kaddr = kmap_atomic(page, KM_USER0);
> +					memset(kaddr+start, 0, block_end-end);
> +					flush_dcache_page(page);
> +					kunmap_atomic(kaddr, KM_USER0);
> +					set_buffer_uptodate(bh);
> +				}
> +
> +				/*
> +				 * XXX: make buffer_new behaviour more
> +				 * consistent.
> +				 * clear_buffer_new(bh);
> +				 */
> +				mark_buffer_dirty(bh);
> +			}
> +		}
> +
> +		block_start = block_end;
> +		bh = bh->b_this_page;
> +	} while (bh != head);
> +}
> +
>  static int __block_commit_write(struct inode *inode, struct page *page,
>  		unsigned from, unsigned to)
>  {
> @@ -1900,6 +1944,105 @@ static int __block_commit_write(struct i
>  	return 0;
>  }
>  
> +ssize_t block_perform_write(struct file *file, struct iovec_iterator *i,
> +					loff_t pos, get_block_t *get_block)
> +{
> +	struct address_space *mapping = file->f_mapping;
> +	struct inode *inode = mapping->host;
> +	long status = 0;
> +	ssize_t written = 0;
> +
> +	do {
> +		struct page *page;
> +		pgoff_t index;		/* Pagecache index for current page */
> +		unsigned long offset;	/* Offset into pagecache page */
> +		unsigned long bytes;	/* Bytes to write to page */
> +		size_t copied;		/* Bytes copied from user */
> +
> +		offset = (pos & (PAGE_CACHE_SIZE - 1));
> +		index = pos >> PAGE_CACHE_SHIFT;
> +		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
> +						iovec_iterator_count(i));
> +
> +		/*
> +		 * Bring in the user page that we will copy from _first_.
> +		 * Otherwise there's a nasty deadlock on copying from the
> +		 * same page as we're writing to, without it being marked
> +		 * up-to-date.
> +		 *
> +		 * Not only is this an optimisation, but it is also required
> +		 * to check that the address is actually valid, when atomic
> +		 * usercopies are used, below.
> +		 */
> +		if (unlikely(iovec_iterator_fault_in_readable(i))) {
> +			status = -EFAULT;
> +			break;
> +		}
> +
> +		page = __grab_cache_page(mapping, index);
> +		if (!page) {
> +			status = -ENOMEM;
> +			break;
> +		}
> +
> +		status = __block_prepare_write(inode, page, offset,
> +						offset+bytes, get_block);
> +		if (unlikely(status)) {
> +			ClearPageUptodate(page);
> +
> +			page_cache_release(page);
> +
> +			/*
> +			 * prepare_write() may have instantiated a few blocks
> +			 * outside i_size.  Trim these off again. Don't need
> +			 * i_size_read because we hold i_mutex.
> +			 */
> +			if (pos + bytes > inode->i_size)
> +				vmtruncate(inode, inode->i_size);
> +			break;
> +		}
> +
> +		/*
> +		 * Must not enter the pagefault handler here, because
> +		 * we hold the page lock. See mm/filemap.c for more
> +		 * details.
> +		 */
> +		pagefault_disable();
> +		copied = iovec_iterator_copy_from_user_atomic(page, i,
> +							offset, bytes);
> +		pagefault_enable();
> +		if (unlikely(copied < bytes))
> +			page_zero_new_buffers(page, offset+copied, offset+bytes);
> +		flush_dcache_page(page);
> +
<<<<<<<<<<< here fs cat do some fs-specific stuff without making
            internal state visiable.  cool.
> +		/* This could be a short (even 0-length) commit */
> +		__block_commit_write(inode, page, offset, offset+copied);
> +
> +		unlock_page(page);
> +		mark_page_accessed(page);
> +		page_cache_release(page);
> +
> +		iovec_iterator_advance(i, copied);
> +		pos += copied;
> +		written += copied;
> +
> +		balance_dirty_pages_ratelimited(mapping);
> +		cond_resched();
> +
> +	} while (iovec_iterator_count(i));
> +
<<<<<<<<<<<  If i've understand correctly folowing scenario possible:
         iteration 1: ->iovec_iterator_fault_in_readable(...)  = 0           
         iteration 1: __block_prepare_write  = {blocks allocated}
         iteration 1: iovec_iterator_copy_from_user_atomic(...) = 0 
         iteration 1: while(iovec_iterator_count(i))  == goto next loop

         iteration 2: ->iovec_iterator_fault_in_readable(...)  = -EFAULT
                      Than breack loop .
         At this point prepare_write() may have instantiated a few blocks
         outside i_size on iteration(1) So we have to trim these off again.

> +	/*
> +	 * No need to use i_size_read() here, the i_size
> +	 * cannot change under us because we hold i_mutex.
> +	 */
> +	if (pos > inode->i_size) {
> +		i_size_write(inode, pos);
> +		mark_inode_dirty(inode);
> +	}
> +
> +	return written ? written : status;
> +}
> +
>  /*
>   * Generic "read page" function for block devices that have the normal
>   * get_block functionality. This is most of the block device filesystems.
> Index: linux-2.6/fs/ext2/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/ext2/inode.c
> +++ linux-2.6/fs/ext2/inode.c
> @@ -642,6 +642,12 @@ ext2_readpages(struct file *file, struct
>  	return mpage_readpages(mapping, pages, nr_pages, ext2_get_block);
>  }
>  
> +static ssize_t
> +ext2_perform_write(struct file *file, struct iovec_iterator *i, loff_t pos)
> +{
> +	return block_perform_write(file, i, pos, ext2_get_block);
> +}
> +
>  static int
>  ext2_prepare_write(struct file *file, struct page *page,
>  			unsigned from, unsigned to)
> @@ -689,6 +695,7 @@ const struct address_space_operations ex
>  	.readpages		= ext2_readpages,
>  	.writepage		= ext2_writepage,
>  	.sync_page		= block_sync_page,
> +	.perform_write		= ext2_perform_write,
>  	.prepare_write		= ext2_prepare_write,
>  	.commit_write		= generic_commit_write,
>  	.bmap			= ext2_bmap,
> Index: linux-2.6/include/linux/buffer_head.h
> ===================================================================
> --- linux-2.6.orig/include/linux/buffer_head.h
> +++ linux-2.6/include/linux/buffer_head.h
> @@ -198,6 +198,7 @@ void block_invalidatepage(struct page *p
>  int block_write_full_page(struct page *page, get_block_t *get_block,
>  				struct writeback_control *wbc);
>  int block_read_full_page(struct page*, get_block_t*);
> +ssize_t block_perform_write(struct file *, struct iovec_iterator*, loff_t, get_block_t*);
>  int block_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
>  int cont_prepare_write(struct page*, unsigned, unsigned, get_block_t*,
>  				loff_t *);
> Index: linux-2.6/include/linux/pagemap.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pagemap.h
> +++ linux-2.6/include/linux/pagemap.h
> @@ -87,6 +87,8 @@ unsigned find_get_pages_contig(struct ad
>  unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
>  			int tag, unsigned int nr_pages, struct page **pages);
>  
> +struct page *__grab_cache_page(struct address_space *mapping, pgoff_t index);
> +
>  /*
>   * Returns locked page at given index in given cache, creating it if needed.
>   */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


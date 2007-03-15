Return-Path: <linux-kernel-owner+w=401wt.eu-S965042AbXCODz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042AbXCODz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 23:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965039AbXCODzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 23:55:55 -0400
Received: from mail.suse.de ([195.135.220.2]:51512 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965034AbXCODzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 23:55:54 -0400
Date: Thu, 15 Mar 2007 04:55:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
Message-ID: <20070315035547.GA15069@wotan.suse.de>
References: <20070314112529.13798.35417.sendpatchset@linux.site> <20070314112540.13798.97719.sendpatchset@linux.site> <871wjrh5wb.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871wjrh5wb.fsf@sw.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:28:04AM +0300, Dmitriy Monakhov wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> > +
> > +int pagecache_write_end(struct file *file, struct address_space *mapping,
> > +				loff_t pos, unsigned len, unsigned copied,
> > +				struct page *page, void *fsdata)
> > +{
> > +	const struct address_space_operations *aops = mapping->a_ops;
> > +	int ret;
> > +
> > +	if (aops->write_begin)
> > +		ret = aops->write_end(file, mapping, pos, len, copied, page, fsdata);
> > +	else {
> > +		int ret;
> > +		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
> > +		struct inode *inode = mapping->host;
> > +
> > +		flush_dcache_page(page);
> > +		ret = aops->commit_write(file, page, offset, offset+len);
> > +		if (ret < 0) {
> > +			unlock_page(page);
> > +			page_cache_release(page);
> > +			if (pos + len > inode->i_size)
> > +				vmtruncate(inode, inode->i_size);
> > +		} else
> > +			ret = copied;
> What about AOP_TRUNCATED_PAGE?  Off corse we can't just "goto retry" here :) ,
> but we may return it to caller and let's caller handle it.  

Yeah AOP_TRUNCATED_PAGE... I'm _hoping_ that OCFS2 and GFS2 will be able
to avoid that using write_begin/write_end, so the caller will not have to
know anything about it.

I don't know that commit_write can even return AOP_TRUNCATED_PAGE... we
should have gathered all our locks in prepare_write.


> > +	}
> > +
> > +	return copied;
> if ->commit_write return non negative value we return with sill locked page  look above at [1] 
> may be it will be unlocked by caller? I guess no it was just forgoten.

Yeah, thanks. I think I converted all my filesystems to use write_begin /
write_end, so I probably didn't test this path :P. I do plan to go through
and try to individually test error cases and stress test it over the next
couple of days.


> > +void page_zero_new_buffers(struct page *page, unsigned from, unsigned to)
> > +{
> > +	unsigned int block_start, block_end;
> > +	struct buffer_head *head, *bh;
> > +
> > +	BUG_ON(!PageLocked(page));
> > +	if (!page_has_buffers(page))
> > +		return;__block_prepare_write 
> > +
> > +	bh = head = page_buffers(page);
> >  	block_start = 0;
> >  	do {
> > -		block_end = block_start+blocksize;
> > -		if (block_end <= from)
> > -			goto next_bh;
> > -		if (block_start >= to)
> > -			break;
> > +		block_end = block_start + bh->b_size;
> > +
> >  		if (buffer_new(bh)) {
> > -			void *kaddr;
> > +			if (block_end > from && block_start < to) {
> > +				if (!PageUptodate(page)) {
> > +					unsigned start, end;
> > +					void *kaddr;
> > +
> > +					start = max(from, block_start);
> > +					end = min(to, block_end);
> > +
> > +					kaddr = kmap_atomic(page, KM_USER0);
> > +					memset(kaddr+start, 0, block_end-end);
> <<<<OOPS why you new block wasn't fully zeroed? as it was done before.
> At least this result in information leak in case of (stat == from)
> just imagine fs with blocksize == 1k conains file with i_size == 4096 and 
> fist two blocks not mapped (hole), now invoke write op from 1023 to 2048.
> For example we succeed in allocating first block, but faile while allocating second
> , then we call page_zero_new_buffers(...from == 1023, to == 2048)
>   and then zerro only one last byte for first block, and set is uptodate
> After this we just do read( from == 0, to == 1023) and steal old block content.

When we first invoke the write op, it should see were doing a partial
write into the first buffer and bring it uptodate first. I don't see the
problem, but again I do need to go through and exercise various cases
like this.


> > @@ -222,67 +221,47 @@ static int do_lo_send_aops(struct loop_d
> >  	len = bvec->bv_len;
> >  	while (len > 0) {
> >  		sector_t IV;
> > -		unsigned size;
> > +		unsigned size, copied;
> >  		int transfer_result;
> > +		struct page *page;
> > +		void *fsdata;
> >  
> >  		IV = ((sector_t)index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
> >  		size = PAGE_CACHE_SIZE - offset;
> >  		if (size > len)
> >  			size = len;
> > -		page = grab_cache_page(mapping, index);
> > -		if (unlikely(!page))
> > +
> > +		ret = pagecache_write_begin(file, mapping, pos, size, 1,
> > +							&page, &fsdata);
> > +		if (ret)
> >  			goto fail;
> > -		ret = aops->prepare_write(file, page, offset,
> > -					  offset + size);
> > -		if (unlikely(ret)) {
> > -			if (ret == AOP_TRUNCATED_PAGE) {
> > -				page_cache_release(page);
> > -				continue;
> > -			}
> > -			goto unlock;
> > -		}
> > +
> >  		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
> >  				bvec->bv_page, bv_offs, size, IV);
> > -		if (unlikely(transfer_result)) {
> > -			char *kaddr;
> > +		copied = size;
> > +		if (unlikely(transfer_result))
> > +			copied = 0;
> > +
> > +		ret = pagecache_write_end(file, mapping, pos, size, copied,
> > +							page, fsdata);
> > +		if (ret < 0)
> > +			goto fail;
> > +		if (ret < copied)
> > +			copied = ret;
> >  
> > -			/*
> > -			 * The transfer failed, but we still write the data to
> > -			 * keep prepare/commit calls balanced.
> > -			 */
> > -			printk(KERN_ERR "loop: transfer error block %llu\n",
> > -			       (unsigned long long)index);
> > -			kaddr = kmap_atomic(page, KM_USER0);
> > -			memset(kaddr + offset, 0, size);
> > -			kunmap_atomic(kaddr, KM_USER0);
> > -		}
> > -		flush_dcache_page(page);
> > -		ret = aops->commit_write(file, page, offset,
> > -					 offset + size);
> > -		if (unlikely(ret)) {
> > -			if (ret == AOP_TRUNCATED_PAGE) {
> > -				page_cache_release(page);
> > -				continue;
> > -			}
> > -			goto unlock;
> <<<<<< BTW: do_lo_send_aops() code itself is realy ugly, for example patrial 
>              write not supported. 

Well, the new code just works. The old code tried to support partial writes,
but it ends up just zeroing out the rest of the unwritten part of the page,
so it can actually overwrite real data.

This is one of the problems with prepare_write/commit_write: error handling
is fairly complex, and leaving it up to the callers is just insane because
we can't even get it right in mm/ :P


Anyway, thanks for having a look over it. You definitely spotted a bug
with the page locking.

Nick

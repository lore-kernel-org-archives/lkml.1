Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXIGSSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXIGSSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 14:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbXIGSSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 14:18:25 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:32038 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757509AbXIGSSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 14:18:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=V9vl6C1IFtZYuo1FQIAr1HJwx/ZFlxA9NCTwSdsgifZV5+yf70NSZKgzuKpAjJu7Em40BkLPf79PwUG+HpuNkPdAugP2IFdjpu5NTN9V8eYVUN7VNLHo5dcQPE9hTyzQKlyu4ZLnj50Aq/6fWd3HdvPinAn3MVB4r0RcMmWyGkQ=  ;
X-YMail-OSG: IqD4o6cVM1km6F_WoYhrpCrK_FvJf9JCywc_OPEUHUYv3rHPt3PSFdlLpWVOJzkJvwYLRbbodg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Bernd Schubert <bs@q-leap.de>
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 1/2)
Date: Sat, 8 Sep 2007 14:15:53 +1000
User-Agent: KMail/1.9.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>, brian@clusterfs.com,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
References: <200709051546.06224.bs@q-leap.de> <20070905083529.a1c8a0a9.randy.dunlap@oracle.com> <200709051941.56145.bs@q-leap.de>
In-Reply-To: <200709051941.56145.bs@q-leap.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081415.54211.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2007 03:41, Bernd Schubert wrote:

> > This comment block should be:
> >
> > /**
> >  * generic_file_buffered_write - handle an iov
> >  * @iocb:	file operations
> >  * @iov:	vector of data to write
> >  * @nr_segs:	number of iov segments
> >  * @pos:	position in the file
> >  * @ppos:	position in the file after this function
> >  * @count:	number of bytes to write
> >  * @written:	offset in iov->base (data to skip on write)
> >  *
> >  * This function will do 3 main tasks for each iov:
> >  * - prepare a write
> >  * - copy the data from iov into a new page
> >  * - commit this page
>
> Thanks, done.
>
> I also removed the FIXMEs and created a second patch.
>
> Signed-off-by: Bernd Schubert <bs@q-leap.de>
> Signed-off-by: Goswin von Brederlow <goswin@vonbrederlow.de>

Minor nit: when resubmitting a patch, you should include everything
(ie. the full changelog of problem statement and fix description) in a
single mail. It's just a bit easier...

So I believe the problem is that for a multi-segment iovec, we currently
prepare_write/commit_write once for each segment, right? We do this
because there is a nasty deadlock in the VM (copy_from_user being
called with a page locked), and copying multiple segs dramatically
increases the chances that one of these copies will cause a page fault
and thus potentially deadlock.

The fix you have I don't think can work because a filesystem must be
notified of the modification _before_ it has happened. (If I understand
correctly, you are skipping the prepare_write potentially until after
some data is copied?).

Anyway, there are fixes for this deadlock in Andrew's -mm tree, but
also a workaround for the NFSD problem in git commit 29dbb3fc. Did
you try a later kernel to see if it is fixed there?

Thanks,
Nick

>
>  mm/filemap.c |  142 +++++++++++++++++++++++++++++++++----------------
>  1 file changed, 96 insertions(+), 46 deletions(-)
>
> Index: linux-2.6.20.3/mm/filemap.c
> ===================================================================
> --- linux-2.6.20.3.orig/mm/filemap.c	2007-09-05 14:04:18.000000000 +0200
> +++ linux-2.6.20.3/mm/filemap.c	2007-09-05 18:50:26.000000000 +0200
> @@ -2057,6 +2057,21 @@
>  }
>  EXPORT_SYMBOL(generic_file_direct_write);
>
> +/**
> + * generic_file_buffered_write - handle iov'ectors
> + * @iob:	file operations
> + * @iov:	vector of data to write
> + * @nr_segs:	number of iov segments
> + * @pos:	position in the file
> + * @ppos:	position in the file after this function
> + * @count:	number of bytes to write
> + * written:	offset in iov->base (data to skip on write)
> + *
> + * This function will do 3 main tasks for each iov:
> + * - prepare a write
> + * - copy the data from iov into a new page
> + * - commit this page
> + */
>  ssize_t
>  generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
>  		unsigned long nr_segs, loff_t pos, loff_t *ppos,
> @@ -2074,6 +2089,11 @@
>  	const struct iovec *cur_iov = iov; /* current iovec */
>  	size_t		iov_base = 0;	   /* offset in the current iovec */
>  	char __user	*buf;
> +	unsigned long	data_start = (pos & (PAGE_CACHE_SIZE -1)); /* Within page
> */ +	loff_t		wpos = pos; /* the position in the file we will return */ +
> +	/* position in file as index of pages */
> +	unsigned long	index = pos >> PAGE_CACHE_SHIFT;
>
>  	pagevec_init(&lru_pvec, 0);
>
> @@ -2087,9 +2107,15 @@
>  		buf = cur_iov->iov_base + iov_base;
>  	}
>
> +	page = __grab_cache_page(mapping, index, &cached_page, &lru_pvec);
> +	if (!page) {
> +		status = -ENOMEM;
> +		goto out;
> +	}
> +
>  	do {
> -		unsigned long index;
>  		unsigned long offset;
> +		unsigned long data_end; /* end of data within the page */
>  		size_t copied;
>
>  		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
> @@ -2106,6 +2132,8 @@
>  		 */
>  		bytes = min(bytes, cur_iov->iov_len - iov_base);
>
> +		data_end = offset + bytes;
> +
>  		/*
>  		 * Bring in the user page that we will copy from _first_.
>  		 * Otherwise there's a nasty deadlock on copying from the
> @@ -2114,34 +2142,30 @@
>  		 */
>  		fault_in_pages_readable(buf, bytes);
>
> -		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
> -		if (!page) {
> -			status = -ENOMEM;
> -			break;
> -		}
> -
>  		if (unlikely(bytes == 0)) {
>  			status = 0;
>  			copied = 0;
>  			goto zero_length_segment;
>  		}
>
> -		status = a_ops->prepare_write(file, page, offset, offset+bytes);
> -		if (unlikely(status)) {
> -			loff_t isize = i_size_read(inode);
> -
> -			if (status != AOP_TRUNCATED_PAGE)
> -				unlock_page(page);
> -			page_cache_release(page);
> -			if (status == AOP_TRUNCATED_PAGE)
> -				continue;
> +		if (data_end == PAGE_CACHE_SIZE || count == bytes) {
>  			/*
> -			 * prepare_write() may have instantiated a few blocks
> -			 * outside i_size.  Trim these off again.
> +			 * Only prepare a write if its an entire page or if
> +			 * we don't have more data
>  			 */
> -			if (pos + bytes > isize)
> -				vmtruncate(inode, isize);
> -			break;
> +			status = a_ops->prepare_write(file, page, data_start, data_end);
> +			if (unlikely(status)) {
> +				loff_t isize = i_size_read(inode);
> +
> +				if (status == AOP_TRUNCATED_PAGE)
> +					continue;
> +				/*
> +				* prepare_write() may have instantiated a few blocks
> +				* outside i_size.  Trim these off again.
> +				*/
> +				if (pos + bytes > isize)
> +					vmtruncate(inode, isize);
> +			}
>  		}
>  		if (likely(nr_segs == 1))
>  			copied = filemap_copy_from_user(page, offset,
> @@ -2149,60 +2173,86 @@
>  		else
>  			copied = filemap_copy_from_user_iovec(page, offset,
>  						cur_iov, iov_base, bytes);
> -		flush_dcache_page(page);
> -		status = a_ops->commit_write(file, page, offset, offset+bytes);
> -		if (status == AOP_TRUNCATED_PAGE) {
> +
> +		if (data_end == PAGE_CACHE_SIZE || count == bytes) {
> +			/*
> +			 * Same as above, always try fill pages up to
> +			 * PAGE_CACHE_SIZE if possible (sufficient data)
> +			 */
> +			flush_dcache_page(page);
> +			status = a_ops->commit_write(file, page,
> +						     data_start, data_end);
> +			if (status == AOP_TRUNCATED_PAGE) {
> +				continue;
> +			}
> +			unlock_page(page);
> +			mark_page_accessed(page);
>  			page_cache_release(page);
> -			continue;
> +			balance_dirty_pages_ratelimited(mapping);
> +			cond_resched();
> +			if (bytes < count) { /* still more iov data to write */
> +				page = __grab_cache_page(mapping, index + 1,
> +							 &cached_page, &lru_pvec);
> +				if (!page) {
> +					status = -ENOMEM;
> +					goto out;
> +				}
> +			} else {
> +				page = NULL;
> +			}
> +			written += data_end - data_start;
> +			wpos    += data_end - data_start;
> +			data_start = 0; /* correct would be data_end % PAGE_SIZE
> +			                 * but if this would be != 0, we don't
> +			                 * have more data
> +			                 */
>  		}
>  zero_length_segment:
>  		if (likely(copied >= 0)) {
> -			if (!status)
> -				status = copied;
> -
> -			if (status >= 0) {
> -				written += status;
> -				count -= status;
> -				pos += status;
> -				buf += status;
> +			if (!status) {
> +				count -= copied;
> +				pos += copied;
> +				buf += copied;
>  				if (unlikely(nr_segs > 1)) {
>  					filemap_set_next_iovec(&cur_iov,
> -							&iov_base, status);
> +							&iov_base, copied);
>  					if (count)
>  						buf = cur_iov->iov_base +
>  							iov_base;
>  				} else {
> -					iov_base += status;
> +					iov_base += copied;
>  				}
>  			}
>  		}
>  		if (unlikely(copied != bytes))
> -			if (status >= 0)
> +			if (!status)
>  				status = -EFAULT;
> -		unlock_page(page);
> -		mark_page_accessed(page);
> -		page_cache_release(page);
> -		if (status < 0)
> +		if (status)
>  			break;
> -		balance_dirty_pages_ratelimited(mapping);
> -		cond_resched();
>  	} while (count);
> -	*ppos = pos;
> +
> +out:
> +	*ppos = wpos;
>
>  	if (cached_page)
>  		page_cache_release(cached_page);
>
> +	if (page) {
> +		unlock_page(page);
> +		page_cache_release(page);
> +	}
> +
>  	/*
>  	 * For now, when the user asks for O_SYNC, we'll actually give O_DSYNC
>  	 */
> -	if (likely(status >= 0)) {
> +	if (likely(!status)) {
>  		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
>  			if (!a_ops->writepage || !is_sync_kiocb(iocb))
>  				status = generic_osync_inode(inode, mapping,
>  						OSYNC_METADATA|OSYNC_DATA);
>  		}
> -  	}
> -
> +	}
> +
>  	/*
>  	 * If we get here for O_DIRECT writes then we must have fallen through
>  	 * to buffered writes (block instantiation inside i_size).  So we sync

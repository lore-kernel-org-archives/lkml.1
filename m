Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZDBPcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZDBPcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZDBPcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:32:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49322 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbZDBPcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:32:18 -0400
Message-ID: <49D4DA7E.7010508@redhat.com>
Date: Thu, 02 Apr 2009 11:32:14 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080915)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of
 data	to an inode [ver #46]
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230515.28177.73948.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230515.28177.73948.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Add an address space operation to write one single page of data to an inode at
> a page-aligned location (thus permitting the implementation to be highly
> optimised).  The data source is a single page.
>
> This is used by CacheFiles to store the contents of netfs pages into their
> backing file pages.
>
> Supply a generic implementation for this that uses the write_begin() and
> write_end() address_space operations to bind a copy directly into the page
> cache.
>
> Hook the Ext2 and Ext3 operations to the generic implementation.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Steve Dickson <steved@redhat.com>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>
>  fs/ext2/inode.c    |    2 ++
>  fs/ext3/inode.c    |    3 +++
>  include/linux/fs.h |    7 ++++++
>  mm/filemap.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 73 insertions(+), 0 deletions(-)
>
>
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index b43b955..5d17070 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -817,6 +817,8 @@ const struct address_space_operations ext2_nobh_aops = {
>  	.direct_IO		= ext2_direct_IO,
>  	.writepages		= ext2_writepages,
>  	.migratepage		= buffer_migrate_page,
> +	.write_one_page		= generic_file_buffered_write_one_page,
> +	.write_one_page		= generic_file_buffered_write_one_page,
>   

You probably only need one of these lines, don't you?

    Thanx...

       ps

>  };
>  
>  /*
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index d897033..a2e5fef 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1803,6 +1803,7 @@ static const struct address_space_operations ext3_ordered_aops = {
>  	.direct_IO		= ext3_direct_IO,
>  	.migratepage		= buffer_migrate_page,
>  	.is_partially_uptodate  = block_is_partially_uptodate,
> +	.write_one_page		= generic_file_buffered_write_one_page,
>  };
>  
>  static const struct address_space_operations ext3_writeback_aops = {
> @@ -1818,6 +1819,7 @@ static const struct address_space_operations ext3_writeback_aops = {
>  	.direct_IO		= ext3_direct_IO,
>  	.migratepage		= buffer_migrate_page,
>  	.is_partially_uptodate  = block_is_partially_uptodate,
> +	.write_one_page		= generic_file_buffered_write_one_page,
>  };
>  
>  static const struct address_space_operations ext3_journalled_aops = {
> @@ -1832,6 +1834,7 @@ static const struct address_space_operations ext3_journalled_aops = {
>  	.invalidatepage		= ext3_invalidatepage,
>  	.releasepage		= ext3_releasepage,
>  	.is_partially_uptodate  = block_is_partially_uptodate,
> +	.write_one_page		= generic_file_buffered_write_one_page,
>  };
>  
>  void ext3_set_aops(struct inode *inode)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 61211ad..df93cdf 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -532,6 +532,11 @@ struct address_space_operations {
>  	int (*launder_page) (struct page *);
>  	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
>  					unsigned long);
> +
> +	/* write the contents of the source page over the page at the specified
> +	 * index in the target address space (the source page does not need to
> +	 * be related to the target address space) */
> +	int (*write_one_page)(struct address_space *, pgoff_t, struct page *);
>  };
>  
>  /*
> @@ -2119,6 +2124,8 @@ extern ssize_t generic_file_direct_write(struct kiocb *, const struct iovec *,
>  		unsigned long *, loff_t, loff_t *, size_t, size_t);
>  extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
>  		unsigned long, loff_t, loff_t *, size_t, ssize_t);
> +extern int generic_file_buffered_write_one_page(struct address_space *,
> +						pgoff_t, struct page *);
>  extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
>  extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
>  extern int generic_segment_checks(const struct iovec *iov,
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 3c55c1a..d766c2f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2320,6 +2320,67 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
>  }
>  EXPORT_SYMBOL(generic_file_buffered_write);
>  
> +/**
> + * generic_file_buffered_write_one_page - Write a single page of data to an
> + *	inode
> + * @mapping - The address space of the target inode
> + * @index - The target page in the target inode to fill
> + * @source - The data to write into the target page
> + *
> + * Write the data from the source page to the page in the nominated address
> + * space at the @index specified.  Note that the file will not be extended if
> + * the page crosses the EOF marker, in which case only the first part of the
> + * page will be written.
> + *
> + * The @source page does not need to have any association with the file or the
> + * target page offset.
> + */
> +int generic_file_buffered_write_one_page(struct address_space *mapping,
> +					 pgoff_t index,
> +					 struct page *source)
> +{
> +	const struct address_space_operations *a_ops = mapping->a_ops;
> +	struct page *page;
> +	unsigned len;
> +	loff_t isize, pos;
> +	void *fsdata;
> +	int ret;
> +
> +	pos = index;
> +	pos <<= PAGE_CACHE_SHIFT;
> +
> +	len = PAGE_CACHE_SIZE;
> +	isize = i_size_read(mapping->host);
> +	if ((isize >> PAGE_CACHE_SHIFT) == index)
> +		len = isize & (PAGE_CACHE_SIZE - 1);
> +
> +	ret = pagecache_write_begin(NULL, mapping, pos, len,
> +				    AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
> +	if (ret < 0)
> +		goto sync;
> +
> +	copy_highpage(page, source);
> +
> +	ret = pagecache_write_end(NULL, mapping, pos, len, len, page, fsdata);
> +	if (ret < 0)
> +		goto sync;
> +
> +	balance_dirty_pages_ratelimited(mapping);
> +	cond_resched();
> +
> +sync:
> +	/* the caller must handle O_SYNC themselves, but we handle S_SYNC and
> +	 * MS_SYNCHRONOUS here */
> +	if (unlikely(IS_SYNC(mapping->host)) && !a_ops->writepage)
> +		ret = generic_osync_inode(mapping->host, mapping,
> +					     OSYNC_METADATA | OSYNC_DATA);
> +
> +	/* the caller must handle O_DIRECT for themselves */
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(generic_file_buffered_write_one_page);
> +
>  static ssize_t
>  __generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
>  				unsigned long nr_segs, loff_t *ppos)
>
> _______________________________________________
> NFSv4 mailing list
> NFSv4@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
>   


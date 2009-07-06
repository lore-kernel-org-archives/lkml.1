Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZGFR7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZGFR7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZGFR7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:59:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:56622 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZGFR7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:59:41 -0400
Date: Mon, 6 Jul 2009 19:59:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 3/3] fs: convert ext2,tmpfs to new truncate
Message-ID: <20090706175943.GV2714@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de> <20090706165629.GS2714@wotan.suse.de> <20090706172838.GC26042@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706172838.GC26042@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 01:28:38PM -0400, Christoph Hellwig wrote:
> On Mon, Jul 06, 2009 at 06:56:29PM +0200, Nick Piggin wrote:
> > 
> > Convert filemap_xip.c, buffer.c, and some filesystems to the new truncate
> > convention. Converting generic helpers is using some ugly code (testing
> > for i_op->ftruncate) to distinguish new and old callers... better
> > alternative might be just define a new function for these guys.
> 
> Splitting generic preparations, ext2 and shmem into separate patch would
> be a tad cleaner I think.

Yes it would.

 
> The testing for the new op is pretty ugly, but this should be just a
> transition help, so it's fine to me.

OK good.

> 
> >  		struct page **pagep, void **fsdata)
> >  {
> > +	int ret;
> > +
> >  	*pagep = NULL;
> > -	return __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
> > +	ret = __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
> > +	if (ret < 0) {
> > +		loff_t isize = inode->i_size;
> > +		if (pos + len > isize)
> > +			ext2_ftruncate(NULL, 0, inode, isize);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int ext2_write_end(struct file *file, struct address_space *mapping,
> > +			loff_t pos, unsigned len, unsigned copied,
> > +			struct page *page, void *fsdata)
> > +{
> > +	int ret;
> > +
> > +	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
> > +	if (ret < len) {
> > +		loff_t isize = inode->i_size;
> > +		if (pos + len > isize)
> > +			ext2_ftruncate(NULL, 0, inode, isize);
> > +	}
> > +	return ret;
> >  }
> >  
> >  static int
> > @@ -770,13 +793,22 @@ ext2_nobh_write_begin(struct file *file,
> >  		loff_t pos, unsigned len, unsigned flags,
> >  		struct page **pagep, void **fsdata)
> >  {
> > +	int ret;
> > +
> >  	/*
> >  	 * Dir-in-pagecache still uses ext2_write_begin. Would have to rework
> >  	 * directory handling code to pass around offsets rather than struct
> >  	 * pages in order to make this work easily.
> >  	 */
> > -	return nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
> > +	ret = nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
> >  							ext2_get_block);
> > +	if (ret < 0) {
> > +		loff_t isize;
> > +		isize = i_size_read(inode);
> > +		if (pos + len > isize)
> > +			ext2_ftruncate(NULL, 0, inode, isize);
> > +	}
> > +	return ret;
> >  }
> >  
> >  static int ext2_nobh_writepage(struct page *page,
> > @@ -796,9 +828,15 @@ ext2_direct_IO(int rw, struct kiocb *ioc
> >  {
> >  	struct file *file = iocb->ki_filp;
> >  	struct inode *inode = file->f_mapping->host;
> > +	ssize_t ret;
> >  
> > -	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
> > +	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
> >  				offset, nr_segs, ext2_get_block, NULL);
> > +	if (ret < 0 && (rw & WRITE)) {
> > +		loff_t isize = i_size_read(inode);
> > +		ext2_ftruncate(NULL, 0, inode, isize);
> 
> These calls don't actually have i_alloc_mutex anymore, do they?

No that's right. But ext2 already had been calling into vmtruncate
without i_alloc_sem (via vmtruncate in write(2) path for trimming
blocks)... hmm, maybe that was a bug itself, though (OTOH, maybe
it doesn't matter because direct IO should not get to blocks
past i_size).


> >  {
> > -	shmem_truncate_range(inode, inode->i_size, (loff_t)-1);
> > +	loff_t oldsize;
> > +	int error;
> > +
> > +	error = inode_truncate_ok(inode, offset);
> > +	if (error)
> > +		return error;
> > +	oldsize = inode->i_size;
> > +	i_size_write(inode, offset);
> > +	truncate_pagecache(inode, oldsize, offset);
> > +	shmem_truncate_range(inode, offset, (loff_t)-1);
> > +
> > +	return error;
> >  }
> 
> Just make this
> 
> 	error = simple_ftruncate(...);
> 	if (!error)
> 		shmem_truncate_range(inode, offset, -1);
> 	return error;

Yes that's better.

Thanks
